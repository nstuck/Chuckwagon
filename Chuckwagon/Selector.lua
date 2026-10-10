-- Selector.lua: pure logic. Given what's in the bags (Inventory snapshot), the
-- item DB (Data/Items.lua) and the player's options, pick the item each macro
-- should use. No WoW API calls here, so it can be tested outside the game.
local _, ns = ...

local Selector = {}
ns.Selector = Selector

local MAIN_HAND, OFF_HAND = 16, 17

----------------------------------------------------------------------------
-- Defaults. Options left nil fall back to these.
----------------------------------------------------------------------------

-- Preferred Well Fed stat per class, best first.
local BUFF_DEFAULTS = {
    WARRIOR = { "str", "sta" },
    PALADIN = { "str", "sta" },
    ROGUE = { "agi", "ap" },
    HUNTER = { "agi", "ap" },
    MAGE = { "spd", "int" },
    WARLOCK = { "spd", "int" },
    PRIEST = { "heal", "int" },
    DRUID = { "int", "sta" },
    SHAMAN = { "int", "sta" },
}

-- Weapon enchant kinds per hand, best first. "stone" means whichever of
-- sharpening stone / weightstone fits the weapon. Casters get no stone
-- fallback: stones are useless to them.
local MELEE = { "elemental", "stone" }
local WEAPON_DEFAULTS = {
    WARRIOR = { [MAIN_HAND] = MELEE, [OFF_HAND] = MELEE },
    PALADIN = { [MAIN_HAND] = MELEE, [OFF_HAND] = MELEE },
    HUNTER = { [MAIN_HAND] = MELEE, [OFF_HAND] = MELEE },
    SHAMAN = { [MAIN_HAND] = MELEE, [OFF_HAND] = MELEE },
    ROGUE = {
        [MAIN_HAND] = { "instant", "deadly", "elemental", "stone" },
        [OFF_HAND] = { "deadly", "instant", "elemental", "stone" },
    },
    MAGE = { [MAIN_HAND] = { "wizardoil", "manaoil" }, [OFF_HAND] = { "wizardoil", "manaoil" } },
    WARLOCK = { [MAIN_HAND] = { "wizardoil", "manaoil" }, [OFF_HAND] = { "wizardoil", "manaoil" } },
    PRIEST = { [MAIN_HAND] = { "manaoil", "wizardoil" }, [OFF_HAND] = { "manaoil", "wizardoil" } },
    DRUID = { [MAIN_HAND] = { "manaoil", "wizardoil" }, [OFF_HAND] = { "manaoil", "wizardoil" } },
}

-- Returns the full option set for a class, with defaults filled in.
-- opts fields (all optional):
--   healOrder     sources for the heal macro: "healthstone", "potion", "herb"
--   manaOrder     sources for the mana macro: "gem", "potion"
--   conjuredFirst food/water/potions eat conjured items first
--   buffOrder     Well Fed stats, best first ("str", "agi", "sta", "int", "spi",
--                 "ap", "spd", "heal", "crit", "mp5", "hp5")
--   buffFallback  with none of buffOrder in bags, use any Well Fed food
--   weaponOrder   { [16] = kinds, [17] = kinds } (item `kind`s, or "stone")
function Selector.Options(classFile, opts)
    opts = opts or {}
    local weapon = WEAPON_DEFAULTS[classFile] or WEAPON_DEFAULTS.WARRIOR
    local function pick(value, default)
        if value == nil then
            return default
        end
        return value
    end
    return {
        healOrder = pick(opts.healOrder, { "healthstone", "potion", "herb" }),
        manaOrder = pick(opts.manaOrder, { "gem", "potion" }),
        conjuredFirst = pick(opts.conjuredFirst, true),
        buffOrder = pick(opts.buffOrder, BUFF_DEFAULTS[classFile] or { "sta" }),
        buffFallback = pick(opts.buffFallback, true),
        weaponOrder = {
            [MAIN_HAND] = pick(opts.weaponOrder and opts.weaponOrder[MAIN_HAND], weapon[MAIN_HAND]),
            [OFF_HAND] = pick(opts.weaponOrder and opts.weaponOrder[OFF_HAND], weapon[OFF_HAND]),
        },
    }
end

----------------------------------------------------------------------------
-- Helpers
----------------------------------------------------------------------------

-- The client runs Lua 5.1, which has no bit operators: test bit `index`.
local function HasBit(mask, index)
    return math.floor(mask / 2 ^ index) % 2 == 1
end
Selector.HasBit = HasBit

-- In the bags, level high enough, and the item's class restriction (if any)
-- allows the player's class (ItemSparse.AllowableClass: bit classID - 1).
-- Cooldowns don't matter: the macro should show the best item even while it
-- is cooling down.
local function Usable(item, snap)
    if item.lvl and snap.level and item.lvl > snap.level then
        return false
    end
    if item.classes and snap.classID and not HasBit(item.classes, snap.classID - 1) then
        return false
    end
    -- Bandages need a First Aid rank; snap.firstAid nil = unknown, don't filter.
    if item.skill and snap.firstAid and item.skill > snap.firstAid then
        return false
    end
    return true
end

-- Every owned, usable item passing `filter`, as { id = , item = }.
local function Candidates(snap, items, filter)
    local out = {}
    for id in pairs(snap.counts) do
        local item = items[id]
        if item and Usable(item, snap) and filter(item) then
            out[#out + 1] = { id = id, item = item }
        end
    end
    return out
end

-- Highest score wins; ties go to the higher required level, then the lower
-- item ID (so the choice never flips between scans). `conjuredFirst` puts
-- conjured items ahead of everything else.
local function Best(list, score, conjuredFirst)
    local best, bestKey
    for _, c in ipairs(list) do
        local key = {
            (conjuredFirst and c.item.conj) and 1 or 0,
            score(c.item),
            c.item.lvl or 0,
            -c.id,
        }
        local better = not bestKey
        if not better then
            for i = 1, #key do
                if key[i] ~= bestKey[i] then
                    better = key[i] > bestKey[i]
                    break
                end
            end
        end
        if better then
            best, bestKey = c, key
        end
    end
    return best and best.id or nil
end

-- Health/mana a food restores, as an amount. Percentage foods (hpPct per
-- tick) need the player's max: they tick once per second for `dur` seconds
-- (DB2 aura period 1000 ms; Restorative Bread's in-game text "100% ... over
-- 20 sec" = 5% x 20, /chuck verify T11). Unknown max -> they rank last.
local function Restores(item, flat, pct, max)
    local amount = item[flat] or 0
    if item[pct] then
        amount = amount + (max and item[pct] / 100 * max * (item.dur or 1) or 0)
    end
    return amount
end

----------------------------------------------------------------------------
-- Macros
----------------------------------------------------------------------------

local HEAL_SOURCES = {
    healthstone = function(i)
        return i.cat == "healthstone"
    end,
    potion = function(i)
        return i.cat == "potion" and (i.hp or 0) > 0
    end,
    -- Other instant heals; on Forever these share the healthstone cooldown.
    herb = function(i)
        return i.cat == "other" and (i.hp or 0) > 0
    end,
}

local MANA_SOURCES = {
    -- Mage mana gems (conjured instant mana outside the potion cooldown).
    gem = function(i)
        return i.cat == "other" and (i.mp or 0) > 0 and i.conj == true
    end,
    potion = function(i)
        return i.cat == "potion" and (i.mp or 0) > 0
    end,
}

-- First source in `order` with anything usable; best item of that source.
local function FromSources(snap, items, sources, order, field, conjuredFirst)
    for _, name in ipairs(order) do
        local filter = sources[name]
        if filter then
            local id = Best(Candidates(snap, items, filter), function(i)
                return i[field] or 0
            end, conjuredFirst)
            if id then
                return id, name
            end
        end
    end
end

local function IsRankedBuff(item)
    return item.buff ~= nil and item.buff.other == nil
end

local function ChooseFood(snap, items, opts, flat, pct, max)
    return Best(Candidates(snap, items, function(i)
        -- Foods with an unranked buff (zone speed, procs) count as plain food.
        return i.cat == "food" and not IsRankedBuff(i) and (i[flat] or i[pct]) ~= nil
    end), function(i)
        return Restores(i, flat, pct, max)
    end, opts.conjuredFirst)
end

local function ChooseBuffFood(snap, items, opts)
    local buffFoods = Candidates(snap, items, function(i)
        return i.cat == "food" and IsRankedBuff(i)
    end)
    for _, stat in ipairs(opts.buffOrder) do
        local withStat = {}
        for _, c in ipairs(buffFoods) do
            if c.item.buff[stat] then
                withStat[#withStat + 1] = c
            end
        end
        local id = Best(withStat, function(i)
            return i.buff[stat]
        end, false)
        if id then
            return id, stat
        end
    end
    if opts.buffFallback then
        -- Any Well Fed food still gives a stat and, on Forever, +5% kill XP.
        local id = Best(buffFoods, function(i)
            return i.lvl or 0
        end, false)
        if id then
            return id, "any"
        end
    end
end

-- Bandage that heals the most; First Aid rank checked in Usable.
local function ChooseBandage(snap, items)
    return Best(Candidates(snap, items, function(i)
        return i.cat == "bandage"
    end), function(i)
        return i.hp or 0
    end, false)
end

-- Does weapon enchant `item` fit this equipped weapon? wep 0 = any weapon.
local function Fits(item, weapon)
    return item.wep == 0 or (weapon.subclassID ~= nil and HasBit(item.wep, weapon.subclassID))
end

local function KindMatches(item, kind)
    if kind == "stone" then
        return item.kind == "sharpen" or item.kind == "weight"
    end
    return item.kind == kind
end

-- Best enchant item for one hand: first kind in `order` the player has that fits.
local function ChooseForHand(snap, items, weapon, order)
    for _, kind in ipairs(order) do
        local id = Best(Candidates(snap, items, function(i)
            return i.cat == "weapon" and KindMatches(i, kind) and Fits(i, weapon)
        end), function(i)
            return i.bonus or 0
        end, false)
        if id then
            return id
        end
    end
end

-- Is the enchant this item would give already on the weapon? Imbue scrolls
-- use Forever's separate "Imbue" enchant type; everything else "Temporary".
local function AlreadyApplied(item, weapon)
    local e = weapon.enchants
    if not e then
        return false
    end
    if item.kind and item.kind:sub(1, 6) == "imbue_" then
        return e.imbue
    end
    return e.temporary
end

-- One macro, one hand per click. Target the main hand unless it already
-- has its enchant and the off hand still needs one.
local function ChooseWeapon(snap, items, opts)
    local hands = {}
    for _, slot in ipairs({ MAIN_HAND, OFF_HAND }) do
        local weapon = snap.weapons and snap.weapons[slot]
        if weapon then
            local id = ChooseForHand(snap, items, weapon, opts.weaponOrder[slot] or {})
            if id then
                hands[slot] = { itemID = id, applied = AlreadyApplied(items[id], weapon) }
            end
        end
    end
    local target
    if hands[MAIN_HAND] and not hands[MAIN_HAND].applied then
        target = MAIN_HAND
    elseif hands[OFF_HAND] and not hands[OFF_HAND].applied then
        target = OFF_HAND
    elseif hands[MAIN_HAND] then
        target = MAIN_HAND
    elseif hands[OFF_HAND] then
        target = OFF_HAND
    end
    if not target then
        return nil
    end
    return { itemID = hands[target].itemID, slot = target, hands = hands }
end

-- Picks every macro's item. Returns a table keyed by macro:
--   heal, mana, food, water, buff, bandage = { itemID =, source = } or nil
--   weapon = { itemID =, slot = 16|17, hands = { [16] = {itemID, applied}, [17] = ... } } or nil
-- `snap` is an Inventory snapshot (counts, level, classID, classFile, weapons,
-- maxHealth, maxMana); `items` is ns.Items; `opts` comes from Selector.Options.
function Selector.Choose(snap, items, opts)
    local result = {}
    local id, source = FromSources(snap, items, HEAL_SOURCES, opts.healOrder, "hp", opts.conjuredFirst)
    if id then
        result.heal = { itemID = id, source = source }
    end
    id, source = FromSources(snap, items, MANA_SOURCES, opts.manaOrder, "mp", opts.conjuredFirst)
    if id then
        result.mana = { itemID = id, source = source }
    end
    id = ChooseFood(snap, items, opts, "hp", "hpPct", snap.maxHealth)
    if id then
        result.food = { itemID = id }
    end
    id = ChooseFood(snap, items, opts, "mp", "mpPct", snap.maxMana)
    if id then
        result.water = { itemID = id }
    end
    id, source = ChooseBuffFood(snap, items, opts)
    if id then
        result.buff = { itemID = id, source = source }
    end
    id = ChooseBandage(snap, items)
    if id then
        result.bandage = { itemID = id }
    end
    result.weapon = ChooseWeapon(snap, items, opts)
    return result
end

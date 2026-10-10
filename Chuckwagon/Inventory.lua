-- Inventory.lua: what the player has and is wielding right now, for the pure
-- Selector. Counts every item in Data/Items.lua, reads the equipped weapons and
-- their temporary enchants, and the player's level and class. Rescans are
-- debounced and event-driven, never polled.
local _, ns = ...

local Inventory = {}
ns.Inventory = Inventory

-- Bursts of bag/equipment events (looting a stack, swapping a set) collapse
-- into one scan.
local DEBOUNCE_SECONDS = 0.3

local MAIN_HAND, OFF_HAND = 16, 17 -- inventory slot IDs
local WEAPON_CLASS = 2 -- Enum.ItemClass.Weapon

-- Enum.WeaponSlot / Enum.ItemEnchantType on the forever branch
-- (ItemConstantsDocumentation.lua); literals are the fallback if Enum lacks them.
local WeaponSlot = (Enum and Enum.WeaponSlot) or { MainHand = 0, OffHand = 1 }
local EnchantType = (Enum and Enum.ItemEnchantType) or { Temporary = 2, Imbue = 3 }
local WEAPON_SLOT_FOR = { [MAIN_HAND] = WeaponSlot.MainHand, [OFF_HAND] = WeaponSlot.OffHand }

local snapshot -- last scan result, see Inventory.Scan
local callbacks = {}
local generation = 0

-- fn(snapshot) runs after every completed scan.
function Inventory.OnChanged(fn)
    callbacks[#callbacks + 1] = fn
end

function Inventory.Get()
    return snapshot
end

-- Temporary enchant state of one hand. Forever's C_Item.GetWeaponEnchantInfo
-- returns a list per slot, with stones/oils/poisons as "Temporary" and the
-- mage imbue scrolls as a separate "Imbue" type, so a weapon can hold one of
-- each. nil when the API is missing.
local function ReadEnchants(slot)
    local get = C_Item.GetWeaponEnchantInfo
    if not get then
        return nil
    end
    local state = { temporary = false, imbue = false }
    for _, enchant in ipairs(get(WEAPON_SLOT_FOR[slot]) or {}) do
        if enchant.hasEnchant then
            if enchant.enchantType == EnchantType.Temporary then
                state.temporary = true
                state.temporaryLeft = enchant.timeLeft
            elseif enchant.enchantType == EnchantType.Imbue then
                state.imbue = true
                state.imbueLeft = enchant.timeLeft
            end
        end
    end
    return state
end

-- Equipped weapon in a hand, or nil when the slot is empty or holds a shield or
-- an off-hand item. GetItemInfoInstant is synchronous (no cache wait).
local function ReadWeapon(slot)
    local itemID = GetInventoryItemID("player", slot)
    if not itemID then
        return nil
    end
    local _, _, _, equipLoc, _, classID, subclassID = C_Item.GetItemInfoInstant(itemID)
    if classID ~= WEAPON_CLASS then
        return nil
    end
    return {
        itemID = itemID,
        subclassID = subclassID,
        equipLoc = equipLoc,
        enchants = ReadEnchants(slot),
    }
end

-- UnitHealthMax/UnitPowerMax are "secret" while the player is addon-restricted
-- (SecretWhenUnitHealthMaxRestricted in UnitDocumentation.lua; arithmetic on a
-- secret is a Lua error). Keep the last readable value.
local lastMaxHealth, lastMaxMana
local POWER_MANA = 0 -- Enum.PowerType.Mana

local function Readable(value)
    if value == nil or (issecretvalue and issecretvalue(value)) then
        return nil
    end
    return value
end

-- First Aid rank: 0 when not learned, nil when the API is missing (then
-- bandages aren't filtered by skill). The third return of GetProfessions is
-- First Aid on Forever (Camelot/Blizzard_ProfessionsBook.lua on the forever
-- branch: "local prof1, prof2, faid, fish, cook = GetProfessions()"), and
-- GetProfessionInfo's third return is the rank. Bandages require skill line
-- 2942, a child of First Aid (129); that its rank is this one is unverified (T8).
local function ReadFirstAid()
    if not GetProfessions or not GetProfessionInfo then
        return nil
    end
    local _, _, firstAid = GetProfessions()
    if not firstAid then
        return 0
    end
    local _, _, rank = GetProfessionInfo(firstAid)
    return rank or 0
end

-- Reads everything now. Returns and stores:
--   counts      itemID -> count in the carried bags (only items with count > 0)
--   level       player level
--   classID     player class ID (1 Warrior ... 11 Druid), classFile e.g. "PALADIN"
--   weapons     [16] / [17] -> ReadWeapon result or nil
--   maxHealth, maxMana  for percentage food (nil until first readable)
--   firstAid    First Aid rank for bandages (see ReadFirstAid)
function Inventory.Scan(levelOverride)
    local counts = {}
    for itemID in pairs(ns.Items) do
        -- No optional flags: carried bags only, never the bank
        -- (https://warcraft.wiki.gg/wiki/API_C_Item.GetItemCount).
        local count = C_Item.GetItemCount(itemID)
        if count and count > 0 then
            counts[itemID] = count
        end
    end
    lastMaxHealth = Readable(UnitHealthMax("player")) or lastMaxHealth
    lastMaxMana = Readable(UnitPowerMax("player", POWER_MANA)) or lastMaxMana
    local _, classFile, classID = UnitClass("player")
    snapshot = {
        counts = counts,
        level = levelOverride or UnitLevel("player"),
        classID = classID,
        classFile = classFile,
        weapons = { [MAIN_HAND] = ReadWeapon(MAIN_HAND), [OFF_HAND] = ReadWeapon(OFF_HAND) },
        maxHealth = lastMaxHealth,
        maxMana = lastMaxMana,
        firstAid = ReadFirstAid(),
    }
    if ns.Debug then
        local kinds = 0
        for _ in pairs(counts) do
            kinds = kinds + 1
        end
        local mh, oh = snapshot.weapons[MAIN_HAND], snapshot.weapons[OFF_HAND]
        ns:Debug(("scan: %d tracked items in bags, level %s, main hand %s, off hand %s"):format(
            kinds, tostring(snapshot.level),
            mh and ("subclass " .. tostring(mh.subclassID)) or "none",
            oh and ("subclass " .. tostring(oh.subclassID)) or "none"))
    end
    for _, fn in ipairs(callbacks) do
        fn(snapshot)
    end
    return snapshot
end

-- Schedules a scan; requests within DEBOUNCE_SECONDS collapse into one.
-- C_Timer.After can't be cancelled, so a generation counter drops stale timers.
local pendingLevel
function Inventory.Request(level)
    pendingLevel = level or pendingLevel
    generation = generation + 1
    local mine = generation
    C_Timer.After(DEBOUNCE_SECONDS, function()
        if mine == generation then
            local lvl = pendingLevel
            pendingLevel = nil
            Inventory.Scan(lvl)
        end
    end)
end

local function RequestScan()
    Inventory.Request()
end

ns:RegisterEvent("PLAYER_ENTERING_WORLD", RequestScan)
-- Fires once after a burst of BAG_UPDATEs
-- (https://warcraft.wiki.gg/wiki/BAG_UPDATE_DELAYED).
ns:RegisterEvent("BAG_UPDATE_DELAYED", RequestScan)
-- Stones/oils/poisons applied or expired (the weapon macro then moves on to
-- the other hand).
ns:RegisterEvent("WEAPON_ENCHANT_CHANGED", RequestScan)
-- First Aid learned or ranked up (SkillInfoDocumentation.lua, forever branch).
ns:RegisterEvent("SKILL_LINES_CHANGED", RequestScan)
ns:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", function(_event, slot)
    if slot == MAIN_HAND or slot == OFF_HAND then
        Inventory.Request()
    end
end)
-- The event carries the new level (https://warcraft.wiki.gg/wiki/PLAYER_LEVEL_UP);
-- use it, since UnitLevel may still report the old one right then (unverified,
-- from memory; harmless if UnitLevel is already current).
ns:RegisterEvent("PLAYER_LEVEL_UP", function(_event, newLevel)
    Inventory.Request(newLevel)
end)

-- Status.lua: /chuck status (what the addon found in the bags, what each macro
-- uses and why) and /chuck rebuild (rescan now). /chuck status is what players
-- paste into bug reports. Status.Lines is pure, so the
-- report is tested offline; the slash commands are the only WoW-facing part.
local _, ns = ...

local L = ns.L

local Status = {}
ns.Status = Status

local MAIN_HAND, OFF_HAND = 16, 17

local function Order(list)
    return table.concat(list or {}, " > ")
end

-- "Name xN" for an item in the bags.
local function Owned(info, itemID)
    local count = info.snap.counts[itemID] or 0
    return ("%s x%d"):format(info.nameOf(itemID), count)
end

-- What the chosen item gives, e.g. "120 health", "3 int", "+8".
local function Amount(key, item, source)
    if key == "heal" or key == "food" or key == "bandage" then
        if item.hpPct then
            return L["STATUS_PCT_HEALTH"]:format(item.hpPct)
        end
        return L["STATUS_HEALTH"]:format(item.hp or 0)
    elseif key == "mana" or key == "water" then
        if item.mpPct then
            return L["STATUS_PCT_MANA"]:format(item.mpPct)
        end
        return L["STATUS_MANA"]:format(item.mp or 0)
    elseif key == "buff" then
        local stat = source
        if stat == "any" then
            stat = next(item.buff)
        end
        return ("%s %s"):format(tostring(item.buff[stat]), tostring(stat))
    elseif key == "weapon" then
        return ("+%s"):format(tostring(item.bonus or 0))
    end
    return ""
end

local function HandName(slot)
    return slot == OFF_HAND and L["STATUS_OFF_HAND"] or L["STATUS_MAIN_HAND"]
end

-- The rule that produced (or failed to produce) a macro's choice.
local function Why(info, key, choice)
    local opts, snap = info.opts, info.snap
    if key == "heal" or key == "mana" then
        local order = Order(key == "heal" and opts.healOrder or opts.manaOrder)
        if choice then
            return L["STATUS_WHY_SOURCE"]:format(choice.source, order)
        end
        return L["STATUS_WHY_ORDER"]:format(order)
    elseif key == "food" or key == "water" then
        if choice and opts.conjuredFirst and info.items[choice.itemID].conj then
            return L["STATUS_WHY_CONJURED"]
        end
        return choice and L["STATUS_WHY_BEST"] or L["STATUS_WHY_NONE"]
    elseif key == "buff" then
        local why = L["STATUS_WHY_BUFF"]:format(Order(opts.buffOrder), opts.buffFallback and "on" or "off")
        if choice and choice.source == "any" then
            why = L["STATUS_WHY_BUFF_ANY"] .. "; " .. why
        end
        return why
    elseif key == "bandage" then
        if snap.firstAid == nil then
            return L["STATUS_WHY_BANDAGE_UNKNOWN"]
        end
        return L["STATUS_WHY_BANDAGE"]:format(snap.firstAid)
    elseif key == "weapon" then
        local parts = {}
        for _, slot in ipairs({ MAIN_HAND, OFF_HAND }) do
            local weapon = snap.weapons and snap.weapons[slot]
            if weapon then
                local hand = choice and choice.hands and choice.hands[slot]
                local state = hand and hand.applied and L["STATUS_ENCHANTED"] or ""
                parts[#parts + 1] = ("%s (subclass %s%s): %s"):format(
                    HandName(slot), tostring(weapon.subclassID), state, Order(opts.weaponOrder[slot]))
            end
        end
        if #parts == 0 then
            return L["STATUS_NO_WEAPON"]
        end
        local why = table.concat(parts, "; ")
        if choice then
            why = L["STATUS_FOR_HAND"]:format(HandName(choice.slot)) .. "; " .. why
        end
        return why
    end
    return ""
end

-- The report, one string per chat line. `info` fields:
--   snap     Inventory snapshot (nil before the first scan)
--   choices  Selector.Choose result, opts the Selector options it used
--   items    ns.Items; macros: MacroBody.MACROS
--   nameOf   itemID -> display name
--   state    MacroWriter.State(): { combat =, loading = }
function Status.Lines(info)
    local snap = info.snap
    if not snap or not info.choices then
        return { L["STATUS_NO_SCAN"] }
    end
    local lines = {}
    lines[#lines + 1] = L["STATUS_PLAYER"]:format(tostring(snap.classFile), tostring(snap.level))

    local found = {}
    for itemID in pairs(snap.counts) do
        found[#found + 1] = itemID
    end
    table.sort(found)
    for i, itemID in ipairs(found) do
        found[i] = Owned(info, itemID)
    end
    lines[#lines + 1] = L["STATUS_FOUND"]:format(#found > 0 and table.concat(found, ", ") or L["STATUS_NOTHING"])

    for _, m in ipairs(info.macros) do
        local choice = info.choices[m.key]
        local what
        if choice and choice.itemID then
            local item = info.items[choice.itemID]
            what = ("%s, %s"):format(Owned(info, choice.itemID), Amount(m.key, item, choice.source))
        else
            what = L["STATUS_NONE"]
        end
        lines[#lines + 1] = ("  %s: %s (%s)"):format(m.name, what, Why(info, m.key, choice))
    end

    if info.state and info.state.combat then
        lines[#lines + 1] = L["STATUS_WAIT_COMBAT"]
    end
    if info.state and info.state.loading then
        lines[#lines + 1] = L["STATUS_WAIT_LOADING"]
    end
    return lines
end

----------------------------------------------------------------------------
-- Slash commands
----------------------------------------------------------------------------

-- C_Item.GetItemNameByID is on the forever branch (ItemDocumentation.lua);
-- nil while the item isn't cached, so fall back to the ID.
local function NameOf(itemID)
    local get = C_Item and C_Item.GetItemNameByID
    return (get and get(itemID)) or ("item:" .. itemID)
end

local function PrintStatus()
    local writer = ns.MacroWriter
    ns:Print(L["STATUS_HEADER"]:format(ns.Version()))
    for _, line in ipairs(Status.Lines({
        snap = ns.Inventory.Get(),
        choices = writer.lastChoices,
        opts = writer.lastOptions,
        items = ns.Items,
        macros = ns.MacroBody.MACROS,
        nameOf = NameOf,
        state = writer.State(),
    })) do
        print(line)
    end
end

-- Names of items the client hasn't cached are nil (owner's T10 status showed
-- "item:2679"), so ask for them and print when they arrive, or after
-- NAME_WAIT seconds with whatever is known. ITEM_DATA_LOAD_RESULT payload
-- (itemID, success): forever branch ItemDocumentation.lua.
local NAME_WAIT = 2
local waitingNames -- itemID -> true while a status print waits, else nil

local function FinishWaiting()
    if waitingNames then
        waitingNames = nil
        PrintStatus()
    end
end

ns:RegisterEvent("ITEM_DATA_LOAD_RESULT", function(_event, itemID)
    if waitingNames and waitingNames[itemID] then
        waitingNames[itemID] = nil
        if next(waitingNames) == nil then
            FinishWaiting()
        end
    end
end)

ns.slashCommands["status"] = function()
    if waitingNames then
        return -- a print is already on its way
    end
    local snap = ns.Inventory.Get()
    local get = C_Item and C_Item.GetItemNameByID
    local request = C_Item and C_Item.RequestLoadItemDataByID
    local missing = {}
    if snap and get and request then
        for itemID in pairs(snap.counts) do
            if not get(itemID) then
                missing[itemID] = true
            end
        end
    end
    if next(missing) == nil then
        PrintStatus()
        return
    end
    waitingNames = missing
    for itemID in pairs(missing) do
        request(itemID)
    end
    C_Timer.After(NAME_WAIT, FinishWaiting)
end

-- Rescan now: the scan's OnChanged listener rewrites the macros (or queues
-- the write in combat).
ns.slashCommands["rebuild"] = function()
    ns.Inventory.Scan()
    ns:Print(L["REBUILT"])
end

table.insert(ns.helpLines, 1, "HELP_REBUILD")
table.insert(ns.helpLines, 1, "HELP_STATUS")

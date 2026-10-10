-- Commands.lua: slash commands that change the macro settings (the options
-- panel, Options.lua, writes the same settings). Each command with no arguments shows the current
-- value and the choices; "default" resets a list to the class default (nil).
-- Writes go through ns.SetSetting / ns.SetCharSetting, so MacroWriter's
-- listeners rewrite the macros.
local _, ns = ...

local L = ns.L

local MAIN_HAND, OFF_HAND = 16, 17

-- Sorted keys of a set, for printing choices.
local function SortedKeys(set)
    local out = {}
    for k in pairs(set) do
        out[#out + 1] = k
    end
    table.sort(out)
    return out
end

local function Set(list)
    local out = {}
    for _, v in ipairs(list) do
        out[v] = true
    end
    return out
end

-- Buff stats and weapon enchant kinds come from the item DB, so a rebuilt DB
-- with a new stat or poison is accepted without touching this file.
local function BuffStats()
    local set = {}
    for _, item in pairs(ns.Items) do
        for stat in pairs(item.buff or {}) do
            if stat ~= "other" then
                set[stat] = true
            end
        end
    end
    return set
end

local function WeaponKinds()
    local set = { stone = true } -- "stone": whichever stone fits (Selector)
    for _, item in pairs(ns.Items) do
        if item.cat == "weapon" and item.kind then
            set[item.kind] = true
        end
    end
    return set
end

-- The effective options (saved choices with class defaults filled in), for
-- showing current values.
local function Effective()
    local snap = ns.Inventory.Get()
    local classFile = snap and snap.classFile or select(2, UnitClass("player"))
    return ns.Selector.Options(classFile, ns.MacroWriter.UserOptions())
end

local function Show(label, value, isDefault)
    print(L["SET_SHOW"]:format(label, value, isDefault and L["SET_DEFAULT"] or ""))
end

-- Parses "a b c" into a list of known words, dropping repeats. Returns the
-- list, or nil and the first unknown word.
local function ParseList(rest, valid)
    local list, seen = {}, {}
    for word in rest:lower():gmatch("%S+") do
        if not valid[word] then
            return nil, word
        end
        if not seen[word] then
            seen[word] = true
            list[#list + 1] = word
        end
    end
    return list
end

-- One list setting: /chuck <cmd> [words...|default].
--   label: locale key; valid: set of words; get(opts): effective list;
--   saved(): the raw saved value (nil = default); save(list or nil).
local function ListCommand(spec)
    return function(rest)
        local valid = spec.valid()
        local choices = table.concat(SortedKeys(valid), ", ")
        rest = rest or ""
        if rest:match("^%s*$") then
            Show(L[spec.label], table.concat(spec.get(Effective()), " > "), spec.saved() == nil)
            print(L["SET_CHOICES"]:format(choices))
            return
        end
        if rest:lower():match("^%s*default%s*$") then
            spec.save(nil)
            Show(L[spec.label], table.concat(spec.get(Effective()), " > "), true)
            return
        end
        local list, bad = ParseList(rest, valid)
        if not list then
            ns:Print(L["SET_BAD"]:format(bad, L[spec.label], choices))
            return
        end
        spec.save(list)
        Show(L[spec.label], table.concat(list, " > "), false)
    end
end

-- One on/off setting: /chuck <cmd> [on|off].
local function ToggleCommand(key, label)
    return function(rest)
        local word = (rest or ""):lower():match("^%s*(%S*)")
        if word == "on" or word == "off" then
            ns.SetSetting(key, word == "on")
        elseif word ~= "" then
            ns:Print(L["SET_BAD"]:format(word, L[label], "on, off"))
            return
        end
        Show(L[label], ns.DB().settings[key] and "on" or "off", false)
    end
end

local function AccountList(key, label, valid)
    return ListCommand({
        label = label,
        valid = function()
            return Set(valid)
        end,
        get = function(opts)
            return opts[key]
        end,
        saved = function()
            return ns.DB().settings[key]
        end,
        save = function(list)
            ns.SetSetting(key, list)
        end,
    })
end

ns.slashCommands["heal"] = AccountList("healOrder", "OPT_HEAL", { "healthstone", "potion", "herb" })
ns.slashCommands["mana"] = AccountList("manaOrder", "OPT_MANA", { "gem", "potion" })

ns.slashCommands["buff"] = ListCommand({
    label = "OPT_BUFF",
    valid = BuffStats,
    get = function(opts)
        return opts.buffOrder
    end,
    saved = function()
        return (ns.GetCharSettings() or {}).buffOrder
    end,
    save = function(list)
        ns.SetCharSetting("buffOrder", list)
    end,
})

-- /chuck weapon mh|oh [kinds...|default]. The two hands are one saved table
-- ({ [16] = list, [17] = list }), replaced whole on every change.
local function WeaponHand(slot, label)
    return ListCommand({
        label = label,
        valid = WeaponKinds,
        get = function(opts)
            return opts.weaponOrder[slot]
        end,
        saved = function()
            local order = (ns.GetCharSettings() or {}).weaponOrder
            return order and order[slot]
        end,
        save = function(list)
            local old = (ns.GetCharSettings() or {}).weaponOrder or {}
            local order = { [MAIN_HAND] = old[MAIN_HAND], [OFF_HAND] = old[OFF_HAND] }
            order[slot] = list
            if order[MAIN_HAND] == nil and order[OFF_HAND] == nil then
                order = nil
            end
            ns.SetCharSetting("weaponOrder", order)
        end,
    })
end

local weaponMH = WeaponHand(MAIN_HAND, "OPT_WEAPON_MH")
local weaponOH = WeaponHand(OFF_HAND, "OPT_WEAPON_OH")

ns.slashCommands["weapon"] = function(rest)
    local hand, more = (rest or ""):lower():match("^%s*(%S*)%s*(.-)$")
    if hand == "mh" then
        weaponMH(more)
    elseif hand == "oh" then
        weaponOH(more)
    else
        weaponMH("")
        weaponOH("")
        print(L["SET_WEAPON_USAGE"])
    end
end

ns.slashCommands["conjured"] = ToggleCommand("conjuredFirst", "OPT_CONJURED")
ns.slashCommands["buffany"] = ToggleCommand("buffFallback", "OPT_BUFFANY")

ns.slashCommands["bandage"] = function(rest)
    local word = (rest or ""):lower():match("^%s*(%S*)")
    if word == "self" or word == "friendly" then
        ns.SetSetting("bandageTarget", word)
    elseif word ~= "" then
        ns:Print(L["SET_BAD"]:format(word, L["OPT_BANDAGE"], "self, friendly"))
        return
    end
    Show(L["OPT_BANDAGE"], ns.DB().settings.bandageTarget, false)
end

for _, key in ipairs({ "HELP_HEAL", "HELP_MANA", "HELP_BUFF", "HELP_WEAPON", "HELP_CONJURED", "HELP_BUFFANY",
    "HELP_BANDAGE" }) do
    table.insert(ns.helpLines, #ns.helpLines - 1, key)
end

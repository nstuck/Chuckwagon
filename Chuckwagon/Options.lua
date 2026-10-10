-- Options.lua: the Blizzard Settings panel, `/chuck options` (alias
-- `/chuck config`), and the addon-compartment entry that opens it. Settings
-- API signatures as in Blizzard's UI source for Forever
-- (Blizzard_Settings_Shared).
--
-- One write path: every control is a Settings.RegisterProxySetting whose
-- setter calls ns.SetSetting / ns.SetCharSetting (Core.lua), the same
-- functions Commands.lua's slash commands call; MacroWriter reacts through
-- ns.OnSettingChanged. This file's own listeners only call
-- Settings.NotifyUpdate so an open panel shows a value changed elsewhere.
--
-- The stock vertical layout has no ordered-list control, so each list
-- setting (heal/mana order, buff stats, weapon kinds per hand) is shown as
-- numbered dropdowns ("1st", "2nd", ...), one proxy setting per position.
-- Placing a choice that is already in the list swaps the two; "(none)"
-- removes that position. The list logic is Options.Place (pure, tested).
local addonName, ns = ...

local L = ns.L
local Options = {}
ns.Options = Options

local MAIN_HAND, OFF_HAND = 16, 17
local NONE = "none"

-- The registered category, or nil if the Settings API wasn't available.
local category

----------------------------------------------------------------------------
-- List editing (pure)
----------------------------------------------------------------------------

local function Copy(list)
    local out = {}
    for i, v in ipairs(list or {}) do
        out[i] = v
    end
    return out
end

local function IndexOf(list, value)
    for i, v in ipairs(list) do
        if v == value then
            return i
        end
    end
end

local function SameList(a, b)
    if #a ~= #b then
        return false
    end
    for i = 1, #a do
        if a[i] ~= b[i] then
            return false
        end
    end
    return true
end

-- Returns a new list with `value` at position `slot` of `list`:
--   NONE           removes that position (later entries move up);
--   already listed swaps the two positions, or moves it to the end when
--                  `slot` is past the end;
--   new value      replaces that position, or is appended past the end.
function Options.Place(list, slot, value)
    local out = Copy(list)
    local at = value ~= NONE and IndexOf(out, value) or nil
    if value == NONE then
        if slot <= #out then
            table.remove(out, slot)
        end
    elseif slot > #out then
        if at then
            table.remove(out, at)
        end
        out[#out + 1] = value
    elseif at then
        out[at], out[slot] = out[slot], value
    else
        out[slot] = value
    end
    return out
end

-- The value to save: nil when the list equals the class default, so the
-- player keeps following the default (a saved nil means "class default").
function Options.ToSaved(list, default)
    if SameList(list, default) then
        return nil
    end
    return list
end

----------------------------------------------------------------------------
-- Choices and labels
----------------------------------------------------------------------------

-- Every item kind a class can use. Kinds come from the item DB (like
-- Commands.lua), so a rebuilt DB needs no code change; a kind whose every
-- item is restricted to other classes (poisons, Mage imbue scrolls) is left
-- out, except `keep` (a value already in the player's list).
local function WeaponChoices(classID, keep)
    local usable = { stone = true } -- "stone": whichever stone fits (Selector)
    for _, item in pairs(ns.Items) do
        if item.cat == "weapon" and item.kind then
            if not (item.classes and classID) or ns.Selector.HasBit(item.classes, classID - 1) then
                usable[item.kind] = true
            end
        end
    end
    for _, kind in ipairs(keep or {}) do
        usable[kind] = true
    end
    return usable
end

local function BuffChoices()
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

-- Display label for a choice word: a locale key CHOICE_<word>, else the
-- name of an item of that kind (a kind added by a DB rebuild), else the word.
local function ChoiceLabel(word)
    local key = "CHOICE_" .. word
    local text = L[key]
    if text ~= key then
        return text
    end
    local getName = C_Item and C_Item.GetItemNameByID
    if getName then
        for id, item in pairs(ns.Items) do
            if item.kind == word then
                local name = getName(id)
                if name then
                    return name
                end
            end
        end
    end
    return word
end
Options.ChoiceLabel = ChoiceLabel

local function SortedByLabel(set)
    local out = {}
    for word in pairs(set) do
        out[#out + 1] = word
    end
    table.sort(out, function(a, b)
        return ChoiceLabel(a) < ChoiceLabel(b)
    end)
    return out
end

----------------------------------------------------------------------------
-- Panel helpers
----------------------------------------------------------------------------

-- Settings variables live in Blizzard's global registry, so prefix them.
local function Variable(key)
    return "Chuckwagon_" .. key
end

-- key -> { variable, ... } refreshed when that setting changes.
local watched = {}

local function Watch(key, variable)
    if not watched[key] then
        watched[key] = {}
        ns.OnSettingChanged(key, function()
            for _, v in ipairs(watched[key]) do
                Settings.NotifyUpdate(v)
            end
        end)
    end
    table.insert(watched[key], variable)
end

local function RegisterCheckbox(key, name, tooltip, default)
    local variable = Variable(key)
    local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, default,
        function()
            return ns.DB().settings[key] and true or false
        end,
        function(value)
            ns.SetSetting(key, value)
        end)
    Watch(key, variable)
    Settings.CreateCheckbox(category, setting, tooltip)
end

local function DropdownOptions(words)
    return function()
        local container = Settings.CreateControlTextContainer()
        for _, word in ipairs(words()) do
            container:Add(word, word == NONE and L["CHOICE_NONE"] or ChoiceLabel(word))
        end
        return container:GetData()
    end
end

-- The panel's Defaults button calls SetValueToDefault on every setting in
-- the category, in no fixed order (Blizzard_SettingsPanel.lua,
-- SetCurrentCategorySettingsToDefaults), so per-position defaults could
-- fight each other through the swaps. While it runs, a list position
-- resets the whole list to the class default instead.
local function SettingDefaults()
    return SettingsPanel and SettingsPanel.CheckIsSettingDefaults and SettingsPanel:CheckIsSettingDefaults()
end

local ORDINALS = { "ORDINAL_1", "ORDINAL_2", "ORDINAL_3", "ORDINAL_4" }

-- A list setting shown as `slots` numbered dropdowns.
--   spec.key        setting key (for refreshes)
--   spec.label      locale key of the list's name
--   spec.tooltip    locale key of the tooltip
--   spec.current()  the effective list (saved or class default)
--   spec.default    the class default list
--   spec.choices()  set of valid words
--   spec.save(list) writes the list (nil = class default)
local function RegisterList(spec, slots)
    for slot = 1, slots do
        local variable = Variable(spec.key .. (spec.suffix or "") .. "_" .. slot)
        local name = L["OPTIONS_SLOT"]:format(L[spec.label], L[ORDINALS[slot]])
        local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.String, name,
            spec.default[slot] or NONE,
            function()
                return spec.current()[slot] or NONE
            end,
            function(value)
                if SettingDefaults() then
                    spec.save(nil)
                    return
                end
                local list = Options.Place(spec.current(), slot, value)
                spec.save(Options.ToSaved(list, spec.default))
            end)
        Watch(spec.key, variable)
        Settings.CreateDropdown(category, setting, DropdownOptions(function()
            local words = SortedByLabel(spec.choices())
            table.insert(words, 1, NONE)
            return words
        end), L[spec.tooltip])
    end
end

-- The options as the Selector will use them: saved values with class
-- defaults filled in.
local function Effective()
    return ns.Selector.Options(select(2, UnitClass("player")), ns.MacroWriter.UserOptions())
end

local function SetFrom(list)
    local set = {}
    for _, v in ipairs(list) do
        set[v] = true
    end
    return set
end

----------------------------------------------------------------------------
-- Panel
----------------------------------------------------------------------------

local function BuildPanel()
    if type(Settings) ~= "table" or type(Settings.RegisterVerticalLayoutCategory) ~= "function" then
        ns:Debug("Options: Settings API not available; skipping options panel")
        return
    end
    local haveLayout = type(SettingsPanel) == "table" and type(SettingsPanel.GetLayout) == "function"

    category = Settings.RegisterVerticalLayoutCategory(ns.ADDON_TITLE)
    local layout = haveLayout and SettingsPanel:GetLayout(category) or nil

    local function AddHeader(name, tooltip)
        if layout and type(CreateSettingsListSectionHeaderInitializer) == "function" then
            layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(name, tooltip))
        end
    end

    local _, classFile, classID = UnitClass("player")
    local defaults = ns.Selector.Options(classFile, {})

    -- 1. All characters (account settings)
    AddHeader(L["OPTIONS_SECTION_ACCOUNT"], L["OPTIONS_SECTION_ACCOUNT_DESC"])
    local function AccountList(key, label, tooltip, valid)
        RegisterList({
            key = key,
            label = label,
            tooltip = tooltip,
            default = defaults[key],
            current = function()
                return Effective()[key]
            end,
            choices = function()
                return SetFrom(valid)
            end,
            save = function(list)
                ns.SetSetting(key, list)
            end,
        }, #valid)
    end
    AccountList("healOrder", "OPT_HEAL", "OPTIONS_HEAL_DESC", { "healthstone", "potion", "herb" })
    AccountList("manaOrder", "OPT_MANA", "OPTIONS_MANA_DESC", { "gem", "potion" })
    RegisterCheckbox("conjuredFirst", L["OPT_CONJURED"], L["OPTIONS_CONJURED_DESC"], true)
    RegisterCheckbox("buffFallback", L["OPT_BUFFANY"], L["OPTIONS_BUFFANY_DESC"], true)

    local bandage = Settings.RegisterProxySetting(category, Variable("bandageTarget"), Settings.VarType.String,
        L["OPT_BANDAGE"], "self",
        function()
            return ns.DB().settings.bandageTarget
        end,
        function(value)
            ns.SetSetting("bandageTarget", value)
        end)
    Watch("bandageTarget", Variable("bandageTarget"))
    Settings.CreateDropdown(category, bandage, function()
        local container = Settings.CreateControlTextContainer()
        container:Add("self", L["CHOICE_BANDAGE_SELF"])
        container:Add("friendly", L["CHOICE_BANDAGE_FRIENDLY"])
        return container:GetData()
    end, L["OPTIONS_BANDAGE_DESC"])

    -- 2. This character (per-character lists)
    AddHeader(L["OPTIONS_SECTION_CHAR"]:format(UnitName("player") or "?"), L["OPTIONS_SECTION_CHAR_DESC"])
    RegisterList({
        key = "buffOrder",
        label = "OPT_BUFF",
        tooltip = "OPTIONS_BUFF_DESC",
        default = defaults.buffOrder,
        current = function()
            return Effective().buffOrder
        end,
        choices = BuffChoices,
        save = function(list)
            ns.SetCharSetting("buffOrder", list)
        end,
    }, 3)

    -- Both hands are one saved table ({ [16] = list, [17] = list }),
    -- replaced whole on every change (same as Commands.lua).
    local function WeaponHand(slot, label, suffix)
        RegisterList({
            key = "weaponOrder",
            suffix = suffix,
            label = label,
            tooltip = "OPTIONS_WEAPON_DESC",
            default = defaults.weaponOrder[slot],
            current = function()
                return Effective().weaponOrder[slot]
            end,
            choices = function()
                return WeaponChoices(classID, Effective().weaponOrder[slot])
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
        }, 4)
    end
    WeaponHand(MAIN_HAND, "OPT_WEAPON_MH", "MH")
    WeaponHand(OFF_HAND, "OPT_WEAPON_OH", "OH")

    -- 3. Advanced
    AddHeader(L["OPTIONS_SECTION_ADVANCED"])
    RegisterCheckbox("debug", L["OPTIONS_DEBUG"], L["OPTIONS_DEBUG_DESC"], false)

    Settings.RegisterAddOnCategory(category)
end

----------------------------------------------------------------------------
-- Opening
----------------------------------------------------------------------------

-- No combat gate: the settings panel isn't a protected frame on Forever.
function Options.Open()
    if not category then
        ns:Print(L["OPTIONS_NOT_AVAILABLE"])
        return
    end
    Settings.OpenToCategory(category:GetID())
end

ns.slashCommands["options"] = Options.Open
ns.slashCommands["config"] = Options.Open
table.insert(ns.helpLines, #ns.helpLines, "HELP_OPTIONS")

----------------------------------------------------------------------------
-- Addon compartment (TOC AddonCompartmentFunc*)
----------------------------------------------------------------------------

-- Receives (addonName, buttonName): Forever's AddonCompartment.lua unwraps
-- the menu data before calling this global (Blizzard_Minimap's
-- AddonCompartment.lua). Runs insecurely, which is fine: opening Settings isn't
-- protected.
_G[addonName .. "_OnAddonCompartmentClick"] = function(_addonName, _buttonName)
    Options.Open()
end

_G[addonName .. "_OnAddonCompartmentEnter"] = function(_addonName, button)
    if not (GameTooltip and button) then
        return
    end
    GameTooltip:SetOwner(button, "ANCHOR_LEFT")
    GameTooltip:SetText(ns.ADDON_TITLE .. " " .. ns.Version())
    GameTooltip:AddLine(L["COMPARTMENT_HINT"], 1, 1, 1)
    GameTooltip:Show()
end

_G[addonName .. "_OnAddonCompartmentLeave"] = function(_addonName, _button)
    if GameTooltip then
        GameTooltip:Hide()
    end
end

-- Core.lua's PLAYER_LOGIN handler (registered first, since Core loads
-- first) has set ns.charKey by the time this runs.
ns:RegisterEvent("PLAYER_LOGIN", BuildPanel)

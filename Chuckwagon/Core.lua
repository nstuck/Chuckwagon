-- Core.lua: namespace, event dispatch, SavedVariables defaults/migration,
-- debug/print helpers, the settings write path, and the /chuck slash command.
--
-- Other modules plug in through ns:RegisterEvent, ns.slashCommands,
-- ns.helpLines and ns.OnSettingChanged, so this file never needs to know
-- they exist.
local addonName, ns = ...

-- The SavedVariables global follows the folder name: ChuckwagonDB here, and
-- ChuckwagonDevDB in a development copy (its TOC declares that name). Code
-- reaches it through ns.DB(), never by name.
ns.DB_NAME = addonName .. "DB"

-- The addon's display name. Every string that should follow a rename goes
-- through this constant, never a literal; a rename then only touches this
-- line, the TOC, and the slash globals.
ns.ADDON_TITLE = "Chuckwagon"

local L = ns.L

-- Current SavedVariables schema version. Bump this and add a migration step
-- in MIGRATIONS whenever the shape of the saved db changes.
local CURRENT_VERSION = 2

-- Ordered migration steps, keyed by the version a save is currently *at*:
-- MIGRATIONS[1] upgrades a version-1 db to version 2, and so on. Each step
-- sets db.version itself.
local MIGRATIONS = {
    -- 1 -> 2: the healthstoneFirst flag became the healOrder list (which
    -- also covers herbs). Only a non-default choice is kept; nil healOrder =
    -- class default.
    [1] = function(db)
        local settings = db.settings
        if type(settings) == "table" then
            if settings.healthstoneFirst == false then
                settings.healOrder = { "potion", "healthstone", "herb" }
            end
            settings.healthstoneFirst = nil
        end
        db.version = 2
    end,
}

----------------------------------------------------------------------------
-- Event dispatch
----------------------------------------------------------------------------

-- One shared frame for every event this addon cares about. Other modules
-- call ns:RegisterEvent(event, handler) instead of creating their own
-- frames, so there's a single OnEvent dispatch point to reason about.
local eventFrame = CreateFrame("Frame")
local handlers = {} -- event -> { handler, handler, ... }

function ns:RegisterEvent(event, handler)
    if not handlers[event] then
        handlers[event] = {}
        eventFrame:RegisterEvent(event)
    end
    table.insert(handlers[event], handler)
end

eventFrame:SetScript("OnEvent", function(_self, event, ...)
    local list = handlers[event]
    if not list then
        return
    end
    for _, handler in ipairs(list) do
        handler(event, ...)
    end
end)

----------------------------------------------------------------------------
-- Print / debug helpers
----------------------------------------------------------------------------

function ns:Print(...)
    print("|cff33ff99[" .. ns.ADDON_TITLE .. "]|r", ...)
end

-- Only prints when settings.debug is true. Safe to call before the saved db
-- exists; it stays silent until defaults are applied.
function ns:Debug(...)
    local db = ns.DB()
    if db and db.settings and db.settings.debug then
        print("|cff888888[" .. ns.ADDON_TITLE .. " debug]|r", ...)
    end
end

----------------------------------------------------------------------------
-- SavedVariables: defaults, migration, per-character table
----------------------------------------------------------------------------

-- Fills in `defaults` wherever `t` is missing a key, recursing into nested
-- tables. Never overwrites a key already set, including an explicit `false`
-- (a plain `t[key] or default` would turn a saved false back into true).
local function ApplyDefaults(t, defaults)
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if type(t[key]) ~= "table" then
                t[key] = {}
            end
            ApplyDefaults(t[key], value)
        elseif t[key] == nil then
            t[key] = value
        end
    end
end

-- Account-wide settings.
-- List settings (healOrder, manaOrder) are NOT listed here: ApplyDefaults
-- would merge a saved list with the default index by index. They stay nil
-- until the player sets one, and nil means "use Selector.Options' default".
local DEFAULT_SETTINGS = {
    debug = false,
    -- Food/water macros eat conjured items first (they vanish on logout).
    conjuredFirst = true,
    -- With no buff food of a wanted stat, use any Well Fed food.
    buffFallback = true,
    -- Bandage macro target, "self" or "friendly" (mouseover/target first).
    bandageTarget = "self",
}

-- Per-character entry in db.chars["Name-Realm"]. Its settings are lists
-- (buffOrder, and weaponOrder as { [16] = kinds, [17] = kinds }),
-- saved whole and nil until set, for the same reason as above.
local DEFAULT_CHAR = {}

local function RunMigrations(db)
    while db.version < CURRENT_VERSION do
        local step = MIGRATIONS[db.version]
        if not step then
            -- CURRENT_VERSION and MIGRATIONS are maintained together, so this
            -- shouldn't happen; stop rather than loop forever.
            break
        end
        step(db)
    end
end

-- The account-wide SavedVariables table (global ns.DB_NAME), or nil before
-- ADDON_LOADED.
function ns.DB()
    return _G[ns.DB_NAME]
end

-- Only valid from ADDON_LOADED onwards (the earliest point the saved global
-- is populated: https://warcraft.wiki.gg/wiki/AddOn_loading_process).
local function InitializeDB()
    if _G[ns.DB_NAME] == nil then
        _G[ns.DB_NAME] = {}
    end
    local db = _G[ns.DB_NAME]

    if db.version == nil then
        db.version = CURRENT_VERSION
    end
    RunMigrations(db)

    if type(db.settings) ~= "table" then
        db.settings = {}
    end
    ApplyDefaults(db.settings, DEFAULT_SETTINGS)

    if type(db.chars) ~= "table" then
        db.chars = {}
    end
end

-- "Name-Realm" key for db.chars. Only called from PLAYER_LOGIN or later: on
-- the Forever beta client UnitName("player") has returned "Unknown" before
-- PLAYER_LOGIN.
local function CurrentCharKey()
    local name = UnitName("player")
    -- GetNormalizedRealmName can be nil during loading screens
    -- (https://warcraft.wiki.gg/wiki/API_GetNormalizedRealmName).
    local realm = GetNormalizedRealmName()
    if not realm then
        realm = (GetRealmName() or ""):gsub("[%s%-%.]", "")
    end
    return (name or "Unknown") .. "-" .. realm
end

local function EnsureCharEntry()
    local db = ns.DB()
    local key = CurrentCharKey()
    if type(db.chars[key]) ~= "table" then
        db.chars[key] = {}
    end
    ApplyDefaults(db.chars[key], DEFAULT_CHAR)
    ns.charKey = key
    return db.chars[key]
end

ns:RegisterEvent("ADDON_LOADED", function(_event, loadedAddonName)
    if loadedAddonName ~= addonName then
        return
    end
    -- Deliberately stays registered: other modules may hook ADDON_LOADED
    -- through ns:RegisterEvent, and unregistering here would drop them.
    InitializeDB()
end)

ns:RegisterEvent("PLAYER_LOGIN", function()
    EnsureCharEntry()
    ns:Debug("Initialized character entry for", ns.charKey)
end)

----------------------------------------------------------------------------
-- Settings: one write path
----------------------------------------------------------------------------

-- key -> { fn, ... }. Modules call ns.OnSettingChanged(key, fn) to react to a
-- setting changing (e.g. the macro writer rebuilding macros), so slash
-- commands and a future options panel share the same side effects.
local settingListeners = {}

function ns.OnSettingChanged(key, fn)
    if not settingListeners[key] then
        settingListeners[key] = {}
    end
    table.insert(settingListeners[key], fn)
end

local function Notify(key, value)
    local list = settingListeners[key]
    if list then
        for _, fn in ipairs(list) do
            fn(value)
        end
    end
end

-- The only place db.settings[key] is written, besides ApplyDefaults
-- and migrations. Listeners only run when the value actually changes (a new
-- list table always counts as a change). nil resets a list to its default.
function ns.SetSetting(key, value)
    local settings = ns.DB().settings
    if settings[key] == value then
        return
    end
    settings[key] = value
    Notify(key, value)
end

-- This character's settings table, or nil before PLAYER_LOGIN.
function ns.GetCharSettings()
    local db = ns.DB()
    return ns.charKey and db and db.chars[ns.charKey] or nil
end

-- Same as SetSetting, for per-character keys (their names don't overlap
-- with account keys, so they share the listener registry).
function ns.SetCharSetting(key, value)
    local char = ns.GetCharSettings()
    if not char or char[key] == value then
        return
    end
    char[key] = value
    Notify(key, value)
end

----------------------------------------------------------------------------
-- Slash command: /chuck, /chuckwagon
----------------------------------------------------------------------------

-- Dispatch table keyed by sub-command, so later modules add their own
-- entries without touching this file:
--   ns.slashCommands["foo"] = function(rest) ... end
ns.slashCommands = {}

ns.slashCommands["debug"] = function()
    local settings = ns.DB().settings
    ns.SetSetting("debug", not settings.debug)
    if settings.debug then
        ns:Print(L["DEBUG_ON"])
    else
        ns:Print(L["DEBUG_OFF"])
    end
end

-- The packaged TOC carries the git tag (the packager replaces
-- v0.1.1); an unpackaged copy still has the placeholder,
-- so call that "dev" instead of printing the raw token.
function ns.Version()
    local get = C_AddOns and C_AddOns.GetAddOnMetadata
    local version = get and get(addonName, "Version")
    if not version or version:find("@", 1, true) then
        return "dev"
    end
    return version
end

-- Help lines in display order. Modules that add a slash command append their
-- locale key here: table.insert(ns.helpLines, "HELP_FOO").
ns.helpLines = { "HELP_DEBUG", "HELP_HELP" }

local function PrintHelp()
    ns:Print(L["HELP_HEADER"]:format(ns.ADDON_TITLE, ns.Version()))
    for _, key in ipairs(ns.helpLines) do
        print(L[key])
    end
end

ns.slashCommands["help"] = PrintHelp

local function HandleSlashCommand(msg)
    -- First word is the sub-command; the rest is passed through as `rest`.
    local command, rest = msg:match("^(%S*)%s*(.-)$")
    command = (command or ""):lower()

    if command == "" then
        PrintHelp()
        return
    end

    local handler = ns.slashCommands[command]
    if handler then
        handler(rest)
    else
        ns:Print(L["UNKNOWN_COMMAND"]:format(command))
        PrintHelp()
    end
end

-- /chuck and /chuckwagon: neither appears in Forever's GlobalStrings or its
-- UI source, so they clash with no built-in command. (/cw would: it is a
-- whisper alias.)
SLASH_CHUCKWAGON1 = "/chuck"
SLASH_CHUCKWAGON2 = "/chuckwagon"
SlashCmdList["CHUCKWAGON"] = HandleSlashCommand

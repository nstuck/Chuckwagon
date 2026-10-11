-- MacroWriter.lua: writes our eight macros (MacroBody) whenever the Inventory
-- snapshot changes. Macros are found by name, never by index, created in the
-- account-wide pool (shared by all characters), rewritten only when the body
-- or icon changed, and never touched in combat (queued until
-- PLAYER_REGEN_ENABLED). A player's own macros are never edited.
local _, ns = ...

local L = ns.L

local MacroWriter = {}
ns.MacroWriter = MacroWriter

-- 120 on the forever branch (MacroConstantsDocumentation.lua); literal
-- fallback in case Constants is missing.
local MAX_ACCOUNT_MACROS = (Constants and Constants.MacroConsts and Constants.MacroConsts.MAX_ACCOUNT_MACROS)
    or 120

-- How long to wait for macros to show up at login before trusting an empty
-- macro list (see MacrosReady).
local LOGIN_WAIT_SECONDS = 10

local pendingCombat = false -- a refresh was skipped in combat
local waitingForMacros = false -- a refresh was skipped because macros looked unloaded
local trustEmpty = false -- LOGIN_WAIT_SECONDS passed; an empty list is real
local warnedFull = false

-- Last Selector.Choose result and the options it used, for /chuck status.
MacroWriter.lastChoices = nil
MacroWriter.lastOptions = nil

-- Why the macros may be behind the bags right now, for /chuck status.
function MacroWriter.State()
    return { combat = pendingCombat, loading = waitingForMacros }
end

-- The player's saved choices, as Selector.Options input (nil = class
-- default): account-wide settings plus this character's lists.
function MacroWriter.UserOptions()
    local settings = ns.DB().settings
    local char = ns.GetCharSettings() or {}
    return {
        manaOrder = settings.manaOrder,
        conjuredFirst = settings.conjuredFirst,
        buffFallback = settings.buffFallback,
        weaponRefresh = settings.weaponRefresh,
        buffOrder = char.buffOrder,
        weaponOrder = char.weaponOrder,
    }
end

-- GetMacroIndexByName returns 0 for "not found"
-- (https://warcraft.wiki.gg/wiki/API_GetMacroIndexByName), which is also what
-- it would return if macros weren't loaded yet; creating then would make a
-- duplicate. The forever UI source has no "macros loaded" event (only
-- UPDATE_MACROS), so: once we have created a macro (db.createdMacros),
-- an empty account pool means "not loaded yet" until UPDATE_MACROS fires or
-- LOGIN_WAIT_SECONDS pass. Unverified whether macros can be unloaded this
-- late on Forever; this is a guard, not a known bug.
local function MacrosReady()
    if trustEmpty or not ns.DB().createdMacros then
        return true
    end
    local numAccount = GetNumMacros()
    return numAccount and numAccount > 0
end

-- Index of macro `m` (current name first, then its old names); 0 if none.
local function FindIndex(m)
    local index = GetMacroIndexByName(m.name)
    if index and index > 0 then
        return index
    end
    for _, oldName in ipairs(m.old or {}) do
        index = GetMacroIndexByName(oldName)
        if index and index > 0 then
            return index
        end
    end
    return 0
end

-- Macro bodies may come back with trailing whitespace; compare without it.
local function SameBody(a, b)
    return ((a or ""):gsub("%s+$", "")) == ((b or ""):gsub("%s+$", ""))
end

-- Creates or updates one macro. Returns true if it wrote anything.
-- UPDATE_MACROS fires for our own writes too
-- (https://warcraft.wiki.gg/wiki/UPDATE_MACROS),
-- so writing only on a real change also keeps that event quiet.
local function WriteOne(m)
    local index = FindIndex(m)
    if index == 0 then
        -- CreateMacro raises a Lua error when the pool is full
        -- (https://warcraft.wiki.gg/wiki/API_CreateMacro).
        if (GetNumMacros() or 0) >= MAX_ACCOUNT_MACROS then
            if not warnedFull then
                warnedFull = true
                ns:Print(L["MACROS_FULL"]:format(MAX_ACCOUNT_MACROS, m.name))
            end
            return false
        end
        -- perCharacter nil = account-wide pool.
        CreateMacro(m.name, m.icon, m.body, nil)
        ns.DB().createdMacros = true
        ns:Debug("created", m.name)
        return true
    end
    local name, icon, body = GetMacroInfo(index)
    if name == m.name and icon == m.icon and SameBody(body, m.body) then
        return false
    end
    -- Name passed too, so an old-named macro gets the current name.
    EditMacro(index, m.name, m.icon, m.body)
    ns:Debug("updated", m.name, (m.body:gsub("\n", " | ")))
    return true
end

-- A weapon enchant crossing the refresh time fires no event, so rescan just
-- after it does; the scan's listener rewrites the weapon macro (or queues it
-- in combat). C_Timer.After can't be cancelled: a generation counter drops
-- timers that a newer refresh replaced.
local refreshGeneration = 0
local function ScheduleWeaponRefresh(waitMs)
    refreshGeneration = refreshGeneration + 1
    if not waitMs then
        return
    end
    local mine = refreshGeneration
    C_Timer.After(waitMs / 1000 + 1, function()
        if mine == refreshGeneration then
            ns.Inventory.Request()
        end
    end)
end

-- Picks every macro's item from the latest Inventory snapshot and writes the
-- macros that changed. Safe to call any time: it defers itself in combat and
-- before the first scan.
function MacroWriter.Refresh()
    local snap = ns.Inventory.Get()
    if not snap or not ns.DB() then
        return
    end
    -- EditMacro/CreateMacro are no-combat restricted
    -- (https://warcraft.wiki.gg/wiki/API_EditMacro). Until combat ends a
    -- macro may point at a used-up item; that's expected.
    if InCombatLockdown() then
        pendingCombat = true
        return
    end
    if not MacrosReady() then
        if not waitingForMacros then
            waitingForMacros = true
            C_Timer.After(LOGIN_WAIT_SECONDS, function()
                trustEmpty = true
                if waitingForMacros then
                    MacroWriter.Refresh()
                end
            end)
        end
        return
    end
    waitingForMacros = false
    pendingCombat = false

    local Selector = ns.Selector
    local opts = Selector.Options(snap.classFile, MacroWriter.UserOptions())
    local choices = Selector.Choose(snap, ns.Items, opts)
    MacroWriter.lastChoices, MacroWriter.lastOptions = choices, opts
    local settings = ns.DB().settings
    for _, m in ipairs(ns.MacroBody.Build(choices, { bandageTarget = settings.bandageTarget })) do
        WriteOne(m)
    end
    -- Times left are as of the scan, which may be older than this refresh.
    local wait = Selector.NextRefresh(choices.weapon, opts)
    if wait and snap.time and GetTime then
        wait = math.max(0, wait - (GetTime() - snap.time) * 1000)
    end
    ScheduleWeaponRefresh(wait)
end

ns.Inventory.OnChanged(MacroWriter.Refresh)

-- After combat, scan again rather than reuse the snapshot from before the
-- fight: enchant times left have moved on (the scan's listener refreshes).
ns:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    if pendingCombat then
        ns.Inventory.Scan()
    end
end)

-- Only used to finish a refresh that was waiting for macros to load. Never
-- refresh on every UPDATE_MACROS: our own writes fire it.
ns:RegisterEvent("UPDATE_MACROS", function()
    if waitingForMacros then
        MacroWriter.Refresh()
    end
end)

-- A setting change rescans rather than reuse the last snapshot: weapon
-- enchant times in it may be minutes old (the scan's listener refreshes).
local function RescanNow()
    ns.Inventory.Scan()
end
for _, key in ipairs({ "manaOrder", "conjuredFirst", "buffFallback", "bandageTarget",
    "buffOrder", "weaponOrder", "weaponRefresh" }) do
    ns.OnSettingChanged(key, RescanNow)
end

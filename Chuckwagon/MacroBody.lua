-- MacroBody.lua: pure logic. Turns the Selector's choices into the name, icon
-- and body text of each of our seven macros. No WoW API calls here, so it
-- can be tested outside the game. Macro syntax:
-- https://warcraft.wiki.gg/wiki/Making_a_macro.
local _, ns = ...

local MacroBody = {}
ns.MacroBody = MacroBody

-- Question-mark icon, file ID 134400 (QUESTIONMARK_INV_ICON in Blizzard's UI
-- source). With "#showtooltip <item>" the action button shows the item's own
-- icon, count and cooldown, and "?" when there is no item. Passing this one
-- icon means no icon lookup and no rewrite when only the icon would change.
-- Seen working for addon-written macros in game.
MacroBody.ICON = 134400

-- Body size limit (https://warcraft.wiki.gg/wiki/API_EditMacro).
MacroBody.MAX_BODY = 255

-- Our macros in display order. The names live only here. `old` lists earlier
-- names of the same macro so a rename finds and renames the existing macro
-- instead of creating a second one. Only list names no player could have made
-- themselves: a match is taken over.
MacroBody.MACROS = {
    { key = "heal", name = "CW Heal", old = {} },
    { key = "mana", name = "CW Mana Pot", old = {} },
    { key = "food", name = "CW Food", old = {} },
    { key = "water", name = "CW Water", old = {} },
    { key = "buff", name = "CW Buff Food", old = {} },
    { key = "weapon", name = "CW Stone", old = {} },
    { key = "bandage", name = "CW Bandage", old = {} },
}

-- Bandage targets (setting bandageTarget). Conditionals:
-- https://warcraft.wiki.gg/wiki/Macro_conditionals. "self" always bandages the
-- player; "friendly" bandages a living friendly mouseover or target first.
local BANDAGE_TARGETS = {
    self = "[@player]",
    friendly = "[@mouseover,help,nodead][@target,help,nodead][@player]",
}

-- Items are referenced by ID ("item:<id>"), so a body never waits for item
-- names to load from the server, and it doesn't depend on the client
-- language. /use item:<id> isn't on https://warcraft.wiki.gg/wiki/MACRO_use
-- but works on Forever (seen in game).
local function Ref(itemID)
    return "item:" .. itemID
end

-- Body for one macro. `choice` is the Selector's result for this macro
-- (Selector.Choose) or nil when nothing usable is in the bags.
--   heal, mana, food, water, buff: one /use of the chosen item.
--   weapon: /use the enchant item, then /use the inventory slot (16 main
--     hand, 17 off hand) to apply it there
--     (https://warcraft.wiki.gg/wiki/MACRO_use).
--   nothing to use: "#showtooltip" alone, which shows "?".
--   bandage: /use with a target conditional (opts.bandageTarget).
function MacroBody.Body(key, choice, opts)
    if not choice or not choice.itemID then
        return "#showtooltip"
    end
    local ref = Ref(choice.itemID)
    local lines = { "#showtooltip " .. ref, "/use " .. ref }
    if key == "bandage" then
        local target = BANDAGE_TARGETS[opts and opts.bandageTarget] or BANDAGE_TARGETS.self
        lines[2] = "/use " .. target .. " " .. ref
    elseif key == "weapon" then
        lines[#lines + 1] = "/use " .. choice.slot
    end
    return table.concat(lines, "\n")
end

-- Every macro to write, from a Selector.Choose result: array of
-- { key, name, old, icon, body } in MACROS order. opts: { bandageTarget = }.
function MacroBody.Build(choices, opts)
    local out = {}
    for _, m in ipairs(MacroBody.MACROS) do
        out[#out + 1] = {
            key = m.key,
            name = m.name,
            old = m.old,
            icon = MacroBody.ICON,
            body = MacroBody.Body(m.key, choices[m.key], opts),
        }
    end
    return out
end

-- Locale table. enUS is the base locale and the fallback for every other
-- locale: if a future locale file is missing a key, the metatable below
-- returns the key itself rather than nil, so a forgotten translation shows
-- an ugly-but-readable string instead of a Lua error.
--
-- Every user-facing string in the addon should be a L["SOME_KEY"] lookup,
-- never a literal, so a translation only ever needs to touch this file.
local _, ns = ...

local L = setmetatable({}, {
    __index = function(_, key)
        return key
    end,
})
ns.L = L

-- Slash command help (/chuck help, and shown on an unrecognised sub-command).
L["HELP_HEADER"] = "%s %s commands:" -- addon title, version (e.g. "v0.1.0")
L["HELP_DEBUG"] = "/chuck debug - toggle debug output"
L["HELP_HELP"] = "/chuck help - show this list"
L["UNKNOWN_COMMAND"] = "Unknown command: %s"

L["DEBUG_ON"] = "Debug output enabled."
L["DEBUG_OFF"] = "Debug output disabled."

-- MacroWriter: the account-wide macro pool is full. Max slots, macro name.
L["MACROS_FULL"] =
    "Your general macro slots are full (%d). Delete one so the \"%s\" macro can be created, then /reload."

-- Status.lua: /chuck status and /chuck rebuild.
L["HELP_STATUS"] = "/chuck status - what's in your bags and what each macro uses, and why"
L["HELP_REBUILD"] = "/chuck rebuild - rescan bags and rewrite the macros now"
L["REBUILT"] = "Rescanned. Macros are up to date (or will update when combat ends)."
L["STATUS_HEADER"] = "status (%s):" -- addon version
L["STATUS_NO_SCAN"] = "  No bag scan yet. Try /chuck rebuild."
L["STATUS_PLAYER"] = "  %s level %s" -- class file, level
L["STATUS_FOUND"] = "  In bags: %s" -- list of "Item xN"
L["STATUS_NOTHING"] = "no tracked consumables"
L["STATUS_NONE"] = "nothing usable (shows ?)"
L["STATUS_HEALTH"] = "%d health"
L["STATUS_MANA"] = "%d mana"
L["STATUS_PCT_HEALTH"] = "%s%% health per tick"
L["STATUS_PCT_MANA"] = "%s%% mana per tick"
L["STATUS_WHY_SOURCE"] = "first source in bags: %s; order %s" -- source, order
L["STATUS_WHY_ORDER"] = "looks for %s"
L["STATUS_WHY_CONJURED"] = "conjured first"
L["STATUS_WHY_BEST"] = "restores the most"
L["STATUS_WHY_NONE"] = "no usable food/drink"
L["STATUS_WHY_BUFF"] = "wants %s; any Well Fed fallback %s" -- stat order, on/off
L["STATUS_WHY_BUFF_ANY"] = "none of the wanted stats, any Well Fed"
L["STATUS_WHY_BANDAGE"] = "heals the most at First Aid rank %d"
L["STATUS_WHY_BANDAGE_UNKNOWN"] = "heals the most; First Aid rank unreadable"
L["STATUS_MAIN_HAND"] = "main hand"
L["STATUS_OFF_HAND"] = "off hand"
L["STATUS_ENCHANTED"] = ", already enchanted"
L["STATUS_NO_WEAPON"] = "no weapon equipped"
L["STATUS_FOR_HAND"] = "applies to %s"
L["STATUS_WAIT_COMBAT"] = "  In combat: macros update when combat ends."
L["STATUS_WAIT_LOADING"] = "  Waiting for the game to load your macros."

-- Commands.lua: settings slash commands (Options.lua writes the same settings).
L["HELP_HEAL"] = "/chuck heal [healthstone potion herb|default] - heal macro source order"
L["HELP_MANA"] = "/chuck mana [gem potion|default] - mana macro source order"
L["HELP_BUFF"] = "/chuck buff [stats...|default] - this character's buff food stats, best first"
L["HELP_WEAPON"] = "/chuck weapon mh|oh [kinds...|default] - this character's weapon enchants per hand"
L["HELP_CONJURED"] = "/chuck conjured on|off - eat and drink conjured items first"
L["HELP_BUFFANY"] = "/chuck buffany on|off - any Well Fed food when none of your stats is in bags"
L["HELP_BANDAGE"] = "/chuck bandage self|friendly - bandage yourself, or a friendly mouseover/target first"
L["SET_SHOW"] = "  %s: %s%s" -- label, value, default marker
L["SET_DEFAULT"] = " (default)"
L["SET_CHOICES"] = "  Choices: %s. \"default\" resets."
L["SET_BAD"] = "Unknown choice \"%s\" for %s. Choices: %s"
L["SET_WEAPON_USAGE"] = "  Usage: /chuck weapon mh|oh <kinds...>|default"
L["OPT_HEAL"] = "Heal order"
L["OPT_MANA"] = "Mana order"
L["OPT_BUFF"] = "Buff food stats"
L["OPT_WEAPON_MH"] = "Main hand enchants"
L["OPT_WEAPON_OH"] = "Off hand enchants"
L["OPT_CONJURED"] = "Conjured first"
L["OPT_BUFFANY"] = "Any Well Fed fallback"
L["OPT_BANDAGE"] = "Bandage target"

-- Options.lua: the settings panel. Choice labels are CHOICE_<word>,
-- where <word> is the saved value (heal/mana source, buff stat, weapon kind).
L["HELP_OPTIONS"] = "/chuck options - open the settings panel"
L["OPTIONS_NOT_AVAILABLE"] = "The settings panel isn't available in this client. Use the /chuck commands instead."
L["COMPARTMENT_HINT"] = "Click to open the settings."
L["OPTIONS_SECTION_ACCOUNT"] = "All characters"
L["OPTIONS_SECTION_ACCOUNT_DESC"] = "These settings apply to every character on this account."
L["OPTIONS_SECTION_CHAR"] = "This character (%s)" -- character name
L["OPTIONS_SECTION_CHAR_DESC"] =
    "Saved separately for each character. Defaults depend on the class. Defaults resets them to the class defaults."
L["OPTIONS_SECTION_ADVANCED"] = "Advanced"
L["OPTIONS_SLOT"] = "%s: %s" -- list name, ordinal
L["ORDINAL_1"] = "1st"
L["ORDINAL_2"] = "2nd"
L["ORDINAL_3"] = "3rd"
L["ORDINAL_4"] = "4th"
L["OPTIONS_HEAL_DESC"] = "What the heal macro uses, in order: the first one in your bags wins. "
    .. "Picking one that's already listed swaps them. (none) ends the list."
L["OPTIONS_MANA_DESC"] = "What the mana macro uses, in order: the first one in your bags wins. "
    .. "Picking one that's already listed swaps them. (none) ends the list."
L["OPTIONS_CONJURED_DESC"] =
    "Eat and drink conjured food and water before anything else, since it disappears when you log out."
L["OPTIONS_BUFFANY_DESC"] =
    "When you have no buff food with any of this character's stats, use any Well Fed food."
L["OPTIONS_BANDAGE_DESC"] = "Who the bandage macro bandages."
L["OPTIONS_BUFF_DESC"] =
    "Buff food stats this character wants, best first. The macro picks the biggest buff of the first stat you have."
L["OPTIONS_WEAPON_DESC"] = "Weapon enchants for this hand, best first. The macro uses the first one in your bags "
    .. "that fits the weapon. \"Matching stone\" means a sharpening stone or weightstone, whichever fits."
L["OPTIONS_DEBUG"] = "Debug output"
L["OPTIONS_DEBUG_DESC"] = "Print what the addon scans and writes to chat. For bug reports."
L["CHOICE_NONE"] = "(none)"
L["CHOICE_BANDAGE_SELF"] = "Yourself"
L["CHOICE_BANDAGE_FRIENDLY"] = "Friendly mouseover or target, else yourself"
L["CHOICE_healthstone"] = "Healthstone"
L["CHOICE_potion"] = "Potion"
L["CHOICE_herb"] = "Herb (Whipper Root and similar)"
L["CHOICE_gem"] = "Mana gem"
L["CHOICE_agi"] = "Agility"
L["CHOICE_ap"] = "Attack power"
L["CHOICE_crit"] = "Critical strike"
L["CHOICE_heal"] = "Healing"
L["CHOICE_int"] = "Intellect"
L["CHOICE_spd"] = "Spell damage"
L["CHOICE_spi"] = "Spirit"
L["CHOICE_sta"] = "Stamina"
L["CHOICE_str"] = "Strength"
L["CHOICE_stone"] = "Matching stone"
L["CHOICE_sharpen"] = "Sharpening stone"
L["CHOICE_weight"] = "Weightstone"
L["CHOICE_elemental"] = "Elemental Sharpening Stone"
L["CHOICE_blackfathom"] = "Blackfathom Sharpening Stone"
L["CHOICE_wizardoil"] = "Wizard oil"
L["CHOICE_manaoil"] = "Mana oil"
L["CHOICE_shadowoil"] = "Shadow Oil"
L["CHOICE_frostoil"] = "Frost Oil"
L["CHOICE_instant"] = "Instant Poison"
L["CHOICE_deadly"] = "Deadly Poison"
L["CHOICE_wound"] = "Wound Poison"
L["CHOICE_crippling"] = "Crippling Poison"
L["CHOICE_mindnumbing"] = "Mind-numbing Poison"
L["CHOICE_numbing"] = "Numbing Poison"
L["CHOICE_atrophic"] = "Atrophic Poison"
L["CHOICE_occult"] = "Occult Poison"
L["CHOICE_sebacious"] = "Sebacious Poison"
L["CHOICE_imbue_accuracy"] = "Scroll of Imbue Accuracy"
L["CHOICE_imbue_baleflame"] = "Scroll of Imbue Baleflame"
L["CHOICE_imbue_balefrost"] = "Scroll of Imbue Balefrost"
L["CHOICE_imbue_chillknife"] = "Scroll of Imbue Chillknife"
L["CHOICE_imbue_flame"] = "Scroll of Imbue Flame"
L["CHOICE_imbue_frost"] = "Scroll of Imbue Frost"
L["CHOICE_imbue_iceknife"] = "Scroll of Imbue Iceknife"
L["CHOICE_imbue_manablade"] = "Scroll of Imbue Manablade"
L["CHOICE_imbue_precision"] = "Scroll of Imbue Precision"
L["CHOICE_imbue_quickening"] = "Scroll of Imbue Quickening"
L["CHOICE_imbue_spark"] = "Scroll of Imbue Spark"
L["CHOICE_imbue_spellbreak"] = "Scroll of Imbue Spellbreak"
L["CHOICE_imbue_striking"] = "Scroll of Imbue Striking"

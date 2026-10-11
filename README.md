# Chuckwagon

**Always grab the right consumable.** Chuckwagon is a World of Warcraft: Forever addon that keeps
a set of macros pointed at the best item in your bags: the strongest potion you can use, conjured
food before vendor food, the right stone for each weapon. As you level, loot and use things up,
the macros rewrite themselves. Put them on your bars once and never edit them again.

[Download on CurseForge](https://www.curseforge.com/wow/addons/chuckwagon) ·
[What's new](CHANGELOG.md) · [Report a problem](#report-a-problem)

**About this repository:** the [`Chuckwagon/`](Chuckwagon/) folder holds the source of the latest
release, the same files the CurseForge download installs, and each release is tagged.

**Contents:** [Report a problem](#report-a-problem) · [Features](#features) ·
[Options](#options) · [Commands](#commands) · [Known limitations](#known-limitations) ·
[Working as designed](#working-as-designed)

## Report a problem

**[Open a new issue](../../issues/new/choose)** and pick the form that fits:

- **Lua error**: you got a BugSack report or the default error pop-up.
- **Wrong macro pick**: a macro uses the wrong item, or doesn't update.
- **Bug**: something else broke or didn't happen.
- **Feature request**: an idea, a missing option, or a consumable Chuckwagon doesn't know.

The most useful thing you can paste is the output of `/chuck status`. It shows what Chuckwagon
found in your bags, what each macro uses, and why.

Before reporting, check [Working as designed](#working-as-designed): some things that look like
bugs are intentional.

## Features

### Eight self-updating macros

| Macro | What it uses |
| --- | --- |
| **CW Heal** | The best health potion you can use |
| **CW Healthstone** | Your healthstone, or a healing herb that shares its cooldown (Whipper Root Tuber and similar) |
| **CW Mana Pot** | Mana gem, then mana potion |
| **CW Food** | Conjured food first, then whatever restores the most |
| **CW Water** | Conjured water first, then whatever restores the most |
| **CW Buff Food** | Well Fed food with the stat your class wants |
| **CW Stone** | The right weapon enchant for each hand |
| **CW Bandage** | The best bandage your First Aid skill allows |

- Open the macro window (`/macro`), find the **CW** macros on the **General** tab, and drag
  them onto your bars.
- Account-wide: every character uses the same buttons and fills them with its own best items
  when it logs in.
- Nothing usable in your bags? The macro stays on your bar with a question-mark icon until you
  have something again.

### Smart picks

- **Only what you can use:** your level, your class and your First Aid skill are all checked.
- **Conjured first:** conjured food and water vanish when you log out, so they're eaten first
  (you can turn this off).
- **Buff food by class:** each class has a sensible stat order (Agility then Attack Power for
  rogues, Spell Damage then Intellect for mages and warlocks, and so on), with any Well Fed food
  as a fallback.
- **Weapon enchants by weapon:** sharpening stones for blades, weightstones for blunt weapons,
  Elemental Sharpening Stones for anything, wizard and mana oils for casters, poisons for rogues.
- **Dual wielding:** the weapon macro does one hand per click, whichever needs it (main hand
  first when both do).
- **No wasted stones, no waiting:** a weapon whose stone, oil or poison still has plenty of time
  is skipped, and once it's down to 2 minutes (your choice) the macro tops it up.
- **Healthstone and potion on separate buttons:** macros can't change during combat, so with a
  button each you can use both in the same fight.
- **Bandages:** on yourself by default, or on a friendly mouseover or target if you prefer.
- **Forever's items** are understood, including its reworked food and Forever-only items.

### Safe by design

- Only ever touches its own macros, never yours. Needs eight free General macro slots.
- Never edits macros in combat (a Blizzard rule for every addon): if you use something up
  mid-fight, the button updates as soon as combat ends.
- Lightweight: event-driven, no constant polling, no libraries.

## Options

Open with `/chuck options`, from **Options → AddOns → Chuckwagon**, or from the addon
compartment button on the minimap.

- Mana macro order
- Conjured food and water first
- Any Well Fed food when none of your stats is in your bags
- Bandage target: yourself, or a friendly mouseover or target
- Weapon enchant refresh: CW Stone tops up a stone, oil or poison once it's down to this much time
  (default 2 minutes, or only when it wears off)
- Buff food stats for this character, best first
- Weapon enchants for each hand for this character (for example Instant Poison in the main hand,
  Deadly Poison in the off hand)
- Debug output

## Commands

| Command | What it does |
| --- | --- |
| `/chuck` or `/chuckwagon` | Show the command list |
| `/chuck options` | Open the options panel |
| `/chuck status` | What's in your bags, what each macro uses, and why |
| `/chuck rebuild` | Rescan your bags and rewrite the macros now |
| `/chuck stone` | Your weapon enchants and their time left, and why CW Stone did nothing |
| `/chuck mana` | Show or set the mana order, e.g. `/chuck mana potion gem` |
| `/chuck buff` | Show or set this character's buff food stats, e.g. `/chuck buff agi sta` |
| `/chuck weapon mh` or `oh` | Show or set this character's weapon enchants for one hand |
| `/chuck conjured on` or `off` | Conjured food and water first |
| `/chuck buffany on` or `off` | Any Well Fed food as a fallback |
| `/chuck bandage self` or `friendly` | Who the bandage macro bandages |
| `/chuck refresh <minutes>` | Re-apply a weapon enchant once it's down to this many minutes (0 = when it wears off; default 2) |
| `/chuck debug` | Toggle debug output |

**Tip:** add `default` to any list command (`/chuck mana default`) to go back to your class
defaults. Each list command run on its own shows the current setting and the choices.

## Known limitations

Chuckwagon is in beta, like Forever itself. These parts haven't been checked in game in every
situation yet. If one misbehaves for you, a report with `/chuck status` helps a lot:

- **Rogue poisons:** Forever applies poisons differently from stones and oils. The weapon macro
  may not apply a poison, or may not move on to the off hand afterwards.
- **Mage imbue scrolls** are only used if you add them to your weapon list, and haven't been
  tested.
- **Very first login** on an account with no macros at all: in rare cases you might see two of a
  CW macro. Delete the extra one; it won't come back.

## Working as designed

- **Macros don't change in combat.** That's a Blizzard rule for every addon. If you use up an
  item mid-fight, its button updates when combat ends. That's why healthstones and potions have a
  button each: you can use both in the same fight.
- **Food and water don't work mounted or in combat.** That's the game's rule.
- **CW Stone does nothing while your weapons are already enchanted.** It doesn't replace a stone,
  oil or poison with plenty of time left, so no item is wasted. Clicking it then says so in chat,
  with the time left on each weapon. Once one is down to 2 minutes (your choice, in the options or
  `/chuck refresh`), it applies a fresh one, and the game asks you to confirm the replacement. If
  that happens mid-fight, the button changes when combat ends.
- **A question-mark icon** means nothing usable for that macro is in your bags.
- **Macro slots full:** Chuckwagon needs eight free General macro slots. If there's no room it
  says so in chat and skips creating the missing macros.
- **Every class gets all eight macros**, even ones it can't use (water on a warrior). Just leave
  those off your bars.

## License

Chuckwagon is open source under the [MIT license](LICENSE).

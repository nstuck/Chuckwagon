# Chuckwagon

<!-- Player-facing release notes only: this file ships in the zip and is the CurseForge
changelog: each release uploads only its own section (tools/release-notes.sh). One
"## vX.Y.Z" section per release, newest first; the heading starts with exactly the tag name.
Work in progress goes under "## vX.Y.Z (unreleased)"; drop "(unreleased)" in the release commit. -->

## v0.1.1

- Chuckwagon is now **open source under the MIT license**. The source of each release, a full guide and the issue tracker are at [github.com/nstuck/Chuckwagon](https://github.com/nstuck/Chuckwagon).
- Updated for WoW Forever build 1.60.1.70338: recognises 12 new consumables (level 1 versions of common potions, food, stones and oils), and Sprouted Frond's heal amount matches the game's new value.

## v0.1.0 (first beta)

First public release, for World of Warcraft: Forever.

- **Seven self-updating macros** that always use the best item in your bags: **CW Heal** (healthstone, health potion, healing herbs), **CW Mana Pot** (mana gem, mana potion), **CW Food**, **CW Water**, **CW Buff Food**, **CW Stone** (weapon enchants) and **CW Bandage**. Put them on your bars once; they rewrite themselves as your bags change.
- **Smart picks**: only items your level, class and First Aid skill allow; conjured food and water first; buff food by your class's stats with any Well Fed food as a fallback; the right stone, oil or poison for each weapon, one hand per click when dual wielding.
- **Options panel** (`/chuck options`, Options → AddOns, or the addon compartment): heal and mana order, conjured first, Well Fed fallback, bandage target, and per-character buff food stats and weapon enchants for each hand. Every setting also has a `/chuck` command.
- **`/chuck status`** shows what's in your bags, what each macro uses, and why. Please include it in bug reports.
- Never edits macros in combat, and only ever touches its own macros. Needs seven free General macro slots.

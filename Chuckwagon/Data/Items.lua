local _, ns = ...

-- Generated from WoW Forever build 1.60.1.70338 game data (DB2 tables via wago.tools).
-- Not edited by hand. One line per item, keyed by item ID; the trailing comment is
-- the item name. Fields:
--   cat     potion | healthstone | food | bandage | weapon | other (instant heal/mana
--           outside the potion cooldown: herbs, mana gems)
--   hp, mp  health / mana restored (potions: average; food/drink: total)
--   hpPct, mpPct, dur  food/drink restoring a percentage per tick, for dur seconds
--   cd      other only: shared cooldown category (1153 = the healthstone's)
--   lvl     required level; ilvl item level (tiebreak)
--   skill   bandage only: required First Aid rank
--   conj    true when conjured
--   classes class restriction, bit (classID - 1) per allowed class; absent = all
--   buff    food only: Well Fed stats, e.g. { int = 3 }; { other = 1 } = unranked buff
--   kind    weapon only: stone, oil, poison or imbue scroll type
--   wep     weapon only: weapon subclass bit mask it fits; 0 = any weapon
--   bonus   weapon only: flat enchant amount (stones: +damage)
--   review  true when the data is marked for an in-game check
ns.ITEMS_BUILD = "1.60.1.70338"

ns.Items = {
    [117] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Tough Jerky
    [118] = { cat = "potion", hp = 80, lvl = 1, ilvl = 5 }, -- Minor Healing Potion
    [159] = { cat = "food", mp = 145, lvl = 1, ilvl = 5 }, -- Refreshing Spring Water
    [414] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Dalaran Sharp
    [422] = { cat = "food", hp = 530, lvl = 15, ilvl = 25 }, -- Dwarven Mild
    [724] = { cat = "food", hp = 234, buff = { str = 3 }, lvl = 5, ilvl = 15 }, -- Goretusk Liver Pie
    [733] = { cat = "food", hp = 234, buff = { other = 1 }, lvl = 5, ilvl = 15 }, -- Westfall Stew
    [787] = { cat = "food", hp = 234, buff = { ap = 6 }, lvl = 1, ilvl = 10 }, -- Slitherskin Mackerel
    [858] = { cat = "potion", hp = 160, lvl = 3, ilvl = 13 }, -- Lesser Healing Potion
    [929] = { cat = "potion", hp = 320, lvl = 12, ilvl = 22 }, -- Healing Potion
    [961] = { cat = "food", hp = 58, lvl = 0, ilvl = 5 }, -- Healing Herb
    [1017] = { cat = "food", hp = 530, buff = { agi = 5 }, lvl = 15, ilvl = 25 }, -- Seasoned Wolf Kabob
    [1072] = { cat = "potion", mp = 320, lvl = 0, ilvl = 25 }, -- Full Moonshine
    [1082] = { cat = "food", hp = 234, buff = { int = 3 }, lvl = 5, ilvl = 15 }, -- Redridge Goulash
    [1113] = { cat = "food", hp = 234, lvl = 5, ilvl = 15, conj = true }, -- Conjured Bread
    [1114] = { cat = "food", hp = 530, lvl = 15, ilvl = 25, conj = true }, -- Conjured Rye
    [1119] = { cat = "food", hp = 530, lvl = 0, ilvl = 25 }, -- Bottled Spirits
    [1179] = { cat = "food", mp = 420, lvl = 5, ilvl = 15 }, -- Ice Cold Milk
    [1205] = { cat = "food", mp = 803, lvl = 15, ilvl = 25 }, -- Melon Juice
    [1251] = { cat = "bandage", hp = 66, skill = 1, lvl = 0, ilvl = 1 }, -- Linen Bandage
    [1326] = { cat = "food", hp = 234, lvl = 0, ilvl = 15 }, -- Sauteed Sunfish
    [1401] = { cat = "other", hp = 30, cd = 11, lvl = 4, ilvl = 14 }, -- Green Tea Leaf
    [1487] = { cat = "food", hp = 841, lvl = 25, ilvl = 35, conj = true }, -- Conjured Pumpernickel
    [1645] = { cat = "food", mp = 1915, lvl = 35, ilvl = 45 }, -- Moonberry Juice
    [1707] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Stormwind Brie
    [1708] = { cat = "food", mp = 1292, lvl = 25, ilvl = 35 }, -- Sweet Nectar
    [1710] = { cat = "potion", hp = 520, lvl = 21, ilvl = 31 }, -- Greater Healing Potion
    [2070] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Darnassian Bleu
    [2136] = { cat = "food", mp = 803, lvl = 15, ilvl = 25, conj = true }, -- Conjured Purified Water
    [2287] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Haunch of Meat
    [2288] = { cat = "food", mp = 420, lvl = 5, ilvl = 15, conj = true }, -- Conjured Fresh Water
    [2455] = { cat = "potion", mp = 160, lvl = 5, ilvl = 15 }, -- Minor Mana Potion
    [2456] = { cat = "potion", hp = 120, mp = 120, lvl = 5, ilvl = 15 }, -- Minor Rejuvenation Potion
    [2581] = { cat = "bandage", hp = 114, skill = 20, lvl = 0, ilvl = 1 }, -- Heavy Linen Bandage
    [2679] = { cat = "food", hp = 58, lvl = 1, ilvl = 10 }, -- Charred Wolf Meat
    [2680] = { cat = "food", hp = 58, buff = { agi = 1 }, lvl = 1, ilvl = 10 }, -- Spiced Wolf Meat
    [2681] = { cat = "food", hp = 58, buff = { str = 1 }, lvl = 1, ilvl = 10 }, -- Roasted Boar Meat
    [2682] = { cat = "food", hp = 58, buff = { int = 1 }, lvl = 1, ilvl = 10 }, -- Cooked Crab Claw
    [2683] = { cat = "food", hp = 234, buff = { int = 3 }, lvl = 5, ilvl = 15 }, -- Crab Cake
    [2684] = { cat = "food", hp = 234, buff = { agi = 3 }, lvl = 5, ilvl = 15 }, -- Coyote Steak
    [2685] = { cat = "food", hp = 530, buff = { str = 5 }, lvl = 15, ilvl = 25 }, -- Succulent Pork Ribs
    [2687] = { cat = "food", hp = 234, buff = { str = 3 }, lvl = 5, ilvl = 15 }, -- Dry Pork Ribs
    [2862] = { cat = "weapon", kind = "sharpen", wep = 33219, bonus = 2, lvl = 1, ilvl = 5 }, -- Rough Sharpening Stone
    [2863] = { cat = "weapon", kind = "sharpen", wep = 33219, bonus = 3, lvl = 5, ilvl = 15 }, -- Coarse Sharpening Stone
    [2871] = { cat = "weapon", kind = "sharpen", wep = 33219, bonus = 4, lvl = 15, ilvl = 25 }, -- Heavy Sharpening Stone
    [2888] = { cat = "food", hp = 58, buff = { str = 1 }, lvl = 1, ilvl = 10 }, -- Beer Basted Boar Ribs
    [2892] = { cat = "weapon", kind = "deadly", wep = 173555, lvl = 30, ilvl = 30, classes = 8 }, -- Deadly Poison
    [2893] = { cat = "weapon", kind = "deadly", wep = 173555, lvl = 38, ilvl = 38, classes = 8 }, -- Deadly Poison II
    [3087] = { cat = "potion", mp = 160, lvl = 0, ilvl = 15 }, -- Mug of Shimmer Stout
    [3220] = { cat = "food", hp = 234, buff = { str = 3 }, lvl = 5, ilvl = 15 }, -- Blood Sausage
    [3239] = { cat = "weapon", kind = "weight", wep = 9264, bonus = 2, lvl = 1, ilvl = 5 }, -- Rough Weightstone
    [3240] = { cat = "weapon", kind = "weight", wep = 9264, bonus = 3, lvl = 5, ilvl = 15 }, -- Coarse Weightstone
    [3241] = { cat = "weapon", kind = "weight", wep = 9264, bonus = 4, lvl = 15, ilvl = 25 }, -- Heavy Weightstone
    [3385] = { cat = "potion", mp = 320, lvl = 14, ilvl = 24 }, -- Lesser Mana Potion
    [3448] = { cat = "food", hp = 282, mp = 282, lvl = 0, ilvl = 15 }, -- Senggin Root
    [3530] = { cat = "bandage", hp = 161, skill = 50, lvl = 0, ilvl = 1 }, -- Wool Bandage
    [3531] = { cat = "bandage", hp = 301, skill = 75, lvl = 0, ilvl = 1 }, -- Heavy Wool Bandage
    [3662] = { cat = "food", hp = 234, buff = { agi = 3 }, lvl = 5, ilvl = 15 }, -- Crocolisk Steak
    [3663] = { cat = "food", hp = 58, buff = { sta = 1 }, lvl = 1, ilvl = 10 }, -- Murloc Fin Soup
    [3664] = { cat = "food", hp = 530, buff = { agi = 5 }, lvl = 15, ilvl = 25 }, -- Crocolisk Gumbo
    [3665] = { cat = "food", hp = 530, buff = { sta = 5 }, lvl = 15, ilvl = 25 }, -- Curiously Tasty Omelet
    [3666] = { cat = "food", hp = 530, buff = { sta = 5 }, lvl = 15, ilvl = 25 }, -- Gooey Spider Cake
    [3726] = { cat = "food", hp = 234, buff = { str = 3 }, lvl = 5, ilvl = 15 }, -- Big Bear Steak
    [3727] = { cat = "food", hp = 530, buff = { agi = 5 }, lvl = 15, ilvl = 25 }, -- Hot Lion Chops
    [3728] = { cat = "food", hp = 841, buff = { agi = 10 }, lvl = 25, ilvl = 35 }, -- Tasty Lion Steak
    [3729] = { cat = "food", hp = 530, buff = { sta = 5 }, lvl = 15, ilvl = 25 }, -- Soothing Turtle Bisque
    [3770] = { cat = "food", hp = 530, lvl = 15, ilvl = 25 }, -- Mutton Chop
    [3771] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Wild Hog Shank
    [3772] = { cat = "food", mp = 1292, lvl = 25, ilvl = 35, conj = true }, -- Conjured Spring Water
    [3775] = { cat = "weapon", kind = "crippling", wep = 173555, lvl = 20, ilvl = 20, classes = 8 }, -- Crippling Poison
    [3776] = { cat = "weapon", kind = "crippling", wep = 173555, lvl = 50, ilvl = 50, classes = 8 }, -- Crippling Poison II
    [3824] = { cat = "weapon", kind = "shadowoil", wep = 173555, bonus = 15, lvl = 24, ilvl = 34 }, -- Shadow Oil
    [3827] = { cat = "potion", mp = 520, lvl = 22, ilvl = 32 }, -- Mana Potion
    [3829] = { cat = "weapon", kind = "frostoil", wep = 173555, bonus = 10, lvl = 30, ilvl = 40 }, -- Frost Oil
    [3927] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Fine Aged Cheddar
    [3928] = { cat = "potion", hp = 800, lvl = 35, ilvl = 45 }, -- Superior Healing Potion
    [4457] = { cat = "food", hp = 841, buff = { int = 10 }, lvl = 25, ilvl = 35 }, -- Barbecued Buzzard Wing
    [4536] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Shiny Red Apple
    [4537] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Tel'Abim Banana
    [4538] = { cat = "food", hp = 530, lvl = 15, ilvl = 25 }, -- Snapvine Watermelon
    [4539] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Goldenbark Apple
    [4540] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Tough Hunk of Bread
    [4541] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Freshly Baked Bread
    [4542] = { cat = "food", hp = 530, lvl = 15, ilvl = 25 }, -- Moist Cornbread
    [4544] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Mulgore Spice Bread
    [4592] = { cat = "food", hp = 530, buff = { ap = 10 }, lvl = 5, ilvl = 15 }, -- Longjaw Mud Snapper
    [4593] = { cat = "food", hp = 530, buff = { other = 1 }, lvl = 15, ilvl = 25 }, -- Bristle Whisker Catfish
    [4594] = { cat = "food", hp = 841, buff = { other = 1 }, lvl = 25, ilvl = 35 }, -- Rockscale Cod
    [4596] = { cat = "potion", hp = 160, lvl = 5, ilvl = 15 }, -- Minor Discolored Healing Potion
    [4599] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Cured Ham Steak
    [4601] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Soft Banana Bread
    [4602] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Moon Harvest Pumpkin
    [4604] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Forest Mushroom Cap
    [4605] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Red-speckled Mushroom
    [4606] = { cat = "food", hp = 530, lvl = 15, ilvl = 25 }, -- Spongy Morel
    [4607] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Delicious Cave Mold
    [4608] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Raw Black Truffle
    [4656] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Small Pumpkin
    [4791] = { cat = "food", mp = 1292, lvl = 25, ilvl = 35 }, -- Enchanted Water
    [5057] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Ripe Watermelon
    [5066] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Fissure Plant
    [5095] = { cat = "food", hp = 58, buff = { spd = 1 }, lvl = 5, ilvl = 15 }, -- Rainbow Fin Albacore
    [5205] = { cat = "other", hp = 94, cd = 1153, lvl = 5, ilvl = 15 }, -- Sprouted Frond
    [5237] = { cat = "weapon", kind = "mindnumbing", wep = 173555, lvl = 24, ilvl = 24, classes = 8 }, -- Mind-numbing Poison
    [5349] = { cat = "food", hp = 58, lvl = 1, ilvl = 5, conj = true }, -- Conjured Muffin
    [5350] = { cat = "food", mp = 145, lvl = 1, ilvl = 5, conj = true }, -- Conjured Water
    [5472] = { cat = "food", hp = 58, buff = { sta = 1 }, lvl = 1, ilvl = 10 }, -- Kaldorei Spider Kabob
    [5473] = { cat = "food", hp = 282, lvl = 1, ilvl = 10 }, -- Scorpid Surprise
    [5474] = { cat = "food", hp = 58, buff = { sta = 1 }, lvl = 1, ilvl = 10 }, -- Roasted Kodo Meat
    [5476] = { cat = "food", hp = 234, buff = { other = 1 }, lvl = 5, ilvl = 15 }, -- Fillet of Frenzy
    [5477] = { cat = "food", hp = 58, buff = { int = 1 }, lvl = 1, ilvl = 10 }, -- Strider Stew
    [5478] = { cat = "food", hp = 530, lvl = 15, ilvl = 25 }, -- Dig Rat Stew
    [5479] = { cat = "food", hp = 234, buff = { sta = 3 }, lvl = 5, ilvl = 15 }, -- Crispy Lizard Tail
    [5480] = { cat = "food", hp = 530, buff = { str = 5 }, lvl = 15, ilvl = 25 }, -- Lean Venison
    [5509] = { cat = "healthstone", hp = 600, lvl = 24, ilvl = 34, conj = true }, -- Healthstone
    [5510] = { cat = "healthstone", hp = 960, lvl = 36, ilvl = 46, conj = true }, -- Greater Healthstone
    [5511] = { cat = "healthstone", hp = 300, lvl = 12, ilvl = 22, conj = true }, -- Lesser Healthstone
    [5512] = { cat = "healthstone", hp = 120, lvl = 1, ilvl = 10, conj = true }, -- Minor Healthstone
    [5513] = { cat = "other", mp = 600, cd = 1153, lvl = 38, ilvl = 38, conj = true }, -- Mana Jade
    [5525] = { cat = "food", hp = 58, lvl = 1, ilvl = 10 }, -- Boiled Clams
    [5526] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Clam Chowder
    [5527] = { cat = "food", hp = 530, buff = { spi = 6, sta = 6 }, lvl = 15, ilvl = 25 }, -- Goblin Deviled Clams
    [6038] = { cat = "food", hp = 841, buff = { sta = 10 }, lvl = 25, ilvl = 35 }, -- Giant Clam Scorcho
    [6149] = { cat = "potion", mp = 800, lvl = 31, ilvl = 41 }, -- Greater Mana Potion
    [6290] = { cat = "food", hp = 58, buff = { ap = 2 }, lvl = 1, ilvl = 10 }, -- Brilliant Smallfish
    [6299] = { cat = "food", hp = 28, lvl = 1, ilvl = 5 }, -- Sickly Looking Fish
    [6316] = { cat = "food", hp = 58, buff = { other = 1 }, lvl = 5, ilvl = 15 }, -- Loch Frenzy Delight
    [6450] = { cat = "bandage", hp = 400, skill = 100, lvl = 0, ilvl = 1 }, -- Silk Bandage
    [6451] = { cat = "bandage", hp = 640, skill = 125, lvl = 0, ilvl = 1 }, -- Heavy Silk Bandage
    [6807] = { cat = "food", hp = 841, lvl = 0, ilvl = 35 }, -- Frog Leg Stew
    [6887] = { cat = "food", hp = 1338, buff = { spd = 22 }, lvl = 35, ilvl = 45 }, -- Spotted Yellowtail
    [6888] = { cat = "food", hp = 58, buff = { sta = 1 }, lvl = 1, ilvl = 10 }, -- Herb Baked Egg
    [6890] = { cat = "food", hp = 58, buff = { str = 1 }, lvl = 1, ilvl = 10 }, -- Smoked Bear Meat
    [6947] = { cat = "weapon", kind = "instant", wep = 173555, lvl = 20, ilvl = 20, classes = 8 }, -- Instant Poison
    [6949] = { cat = "weapon", kind = "instant", wep = 173555, lvl = 28, ilvl = 28, classes = 8 }, -- Instant Poison II
    [6950] = { cat = "weapon", kind = "instant", wep = 173555, lvl = 36, ilvl = 36, classes = 8 }, -- Instant Poison III
    [6951] = { cat = "weapon", kind = "mindnumbing", wep = 173555, lvl = 38, ilvl = 38, classes = 8 }, -- Mind-numbing Poison II
    [7097] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Leg Meat
    [7228] = { cat = "food", hp = 530, lvl = 15, ilvl = 25 }, -- Tigule's Strawberry Ice Cream
    [7806] = { cat = "food", hp = 58, buff = { spi = 2, sta = 2 }, lvl = 1, ilvl = 5 }, -- Lollipop
    [7807] = { cat = "food", hp = 58, buff = { spi = 2, sta = 2 }, lvl = 1, ilvl = 5 }, -- Candy Bar
    [7808] = { cat = "food", hp = 58, buff = { spi = 2, sta = 2 }, lvl = 1, ilvl = 5 }, -- Chocolate Square
    [7964] = { cat = "weapon", kind = "sharpen", wep = 33219, bonus = 6, lvl = 25, ilvl = 35 }, -- Solid Sharpening Stone
    [7965] = { cat = "weapon", kind = "weight", wep = 9264, bonus = 6, lvl = 25, ilvl = 35 }, -- Solid Weightstone
    [8007] = { cat = "other", mp = 850, cd = 1153, lvl = 48, ilvl = 48, conj = true }, -- Mana Citrine
    [8008] = { cat = "other", mp = 1100, cd = 1153, lvl = 58, ilvl = 58, conj = true }, -- Mana Ruby
    [8075] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45, conj = true }, -- Conjured Sourdough
    [8076] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55, conj = true }, -- Conjured Sweet Roll
    [8077] = { cat = "food", mp = 1915, lvl = 35, ilvl = 45, conj = true }, -- Conjured Mineral Water
    [8078] = { cat = "food", mp = 2821, lvl = 45, ilvl = 55, conj = true }, -- Conjured Sparkling Water
    [8079] = { cat = "food", mp = 4038, lvl = 55, ilvl = 65, conj = true }, -- Conjured Crystal Water
    [8364] = { cat = "food", hp = 841, buff = { ap = 20 }, lvl = 25, ilvl = 35 }, -- Mithril Head Trout
    [8543] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Underwater Mushroom Cap
    [8544] = { cat = "bandage", hp = 800, skill = 150, lvl = 0, ilvl = 1 }, -- Mageweave Bandage
    [8545] = { cat = "bandage", hp = 1104, skill = 175, lvl = 0, ilvl = 1 }, -- Heavy Mageweave Bandage
    [8766] = { cat = "food", mp = 2821, lvl = 45, ilvl = 55 }, -- Morning Glory Dew
    [8926] = { cat = "weapon", kind = "instant", wep = 173555, lvl = 44, ilvl = 44, classes = 8 }, -- Instant Poison IV
    [8927] = { cat = "weapon", kind = "instant", wep = 173555, lvl = 52, ilvl = 52, classes = 8 }, -- Instant Poison V
    [8928] = { cat = "weapon", kind = "instant", wep = 173555, lvl = 60, ilvl = 60, classes = 8 }, -- Instant Poison VI
    [8932] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Alterac Swiss
    [8948] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Dried King Bolete
    [8950] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Homemade Cherry Pie
    [8952] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Roasted Quail
    [8953] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Deep Fried Plantains
    [8957] = { cat = "food", hp = 1338, buff = { other = 1 }, lvl = 45, ilvl = 55 }, -- Spinefin Halibut
    [8984] = { cat = "weapon", kind = "deadly", wep = 173555, lvl = 46, ilvl = 46, classes = 8 }, -- Deadly Poison III
    [8985] = { cat = "weapon", kind = "deadly", wep = 173555, lvl = 54, ilvl = 54, classes = 8 }, -- Deadly Poison IV
    [9144] = { cat = "potion", hp = 750, mp = 750, lvl = 35, ilvl = 45 }, -- Wildvine Potion
    [9186] = { cat = "weapon", kind = "mindnumbing", wep = 173555, lvl = 52, ilvl = 52, classes = 8 }, -- Mind-numbing Poison III
    [9421] = { cat = "healthstone", hp = 1440, lvl = 48, ilvl = 58, conj = true }, -- Major Healthstone
    [9451] = { cat = "food", mp = 803, lvl = 15, ilvl = 25 }, -- Bubbling Water
    [9681] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Grilled King Crawler Legs
    [10841] = { cat = "food", mp = 1292, buff = { other = 1 }, lvl = 25, ilvl = 35 }, -- Goldthorn Tea
    [10918] = { cat = "weapon", kind = "wound", wep = 173555, lvl = 32, ilvl = 32, classes = 8 }, -- Wound Poison
    [10920] = { cat = "weapon", kind = "wound", wep = 173555, lvl = 40, ilvl = 40, classes = 8 }, -- Wound Poison II
    [10921] = { cat = "weapon", kind = "wound", wep = 173555, lvl = 48, ilvl = 48, classes = 8 }, -- Wound Poison III
    [10922] = { cat = "weapon", kind = "wound", wep = 173555, lvl = 56, ilvl = 56, classes = 8 }, -- Wound Poison IV
    [11109] = { cat = "food", hp = 28, lvl = 1, ilvl = 5 }, -- Special Chicken Feed
    [11415] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Mixed Berries
    [11444] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Grim Guzzler Boar
    [11584] = { cat = "food", hp = 58, buff = { spi = 2, sta = 2 }, lvl = 0, ilvl = 5 }, -- Cactus Apple Surprise
    [11951] = { cat = "other", hp = 800, cd = 1153, lvl = 45, ilvl = 55 }, -- Whipper Root Tuber
    [11952] = { cat = "other", hp = 425, mp = 425, cd = 1153, lvl = 45, ilvl = 55 }, -- Night Dragon's Breath
    [12209] = { cat = "food", hp = 530, buff = { agi = 5 }, lvl = 15, ilvl = 25 }, -- Lean Wolf Steak
    [12210] = { cat = "food", hp = 530, buff = { int = 5 }, lvl = 15, ilvl = 25 }, -- Roast Raptor
    [12212] = { cat = "food", hp = 1338, buff = { agi = 15 }, lvl = 35, ilvl = 45 }, -- Jungle Stew
    [12213] = { cat = "food", hp = 234, buff = { sta = 3 }, lvl = 5, ilvl = 15 }, -- Carrion Surprise
    [12214] = { cat = "food", hp = 530, buff = { sta = 5 }, lvl = 15, ilvl = 25 }, -- Mystery Stew
    [12215] = { cat = "food", hp = 841, buff = { sta = 10 }, lvl = 25, ilvl = 35 }, -- Heavy Kodo Stew
    [12216] = { cat = "food", hp = 841, buff = { int = 10 }, lvl = 25, ilvl = 35 }, -- Spiced Chili Crab
    [12217] = { cat = "food", buff = { other = 1 }, lvl = 25, ilvl = 35 }, -- Dragonbreath Chili
    [12218] = { cat = "food", hp = 1338, buff = { sta = 15 }, lvl = 35, ilvl = 45 }, -- Monster Omelet
    [12224] = { cat = "food", hp = 58, buff = { int = 1 }, lvl = 1, ilvl = 10 }, -- Crispy Bat Wing
    [12238] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Darkshore Grouper
    [12404] = { cat = "weapon", kind = "sharpen", wep = 33219, bonus = 8, lvl = 35, ilvl = 45 }, -- Dense Sharpening Stone
    [12643] = { cat = "weapon", kind = "weight", wep = 9264, bonus = 8, lvl = 35, ilvl = 45 }, -- Dense Weightstone
    [12763] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Un'Goro Etherfruit
    [13443] = { cat = "potion", mp = 1200, lvl = 41, ilvl = 51 }, -- Superior Mana Potion
    [13444] = { cat = "potion", mp = 1800, lvl = 49, ilvl = 59 }, -- Major Mana Potion
    [13446] = { cat = "potion", hp = 1400, lvl = 45, ilvl = 55 }, -- Major Healing Potion
    [13546] = { cat = "food", hp = 1338, lvl = 25, ilvl = 35 }, -- Bloodbelly Fish
    [13724] = { cat = "food", hp = 2065, mp = 4240, lvl = 45, ilvl = 55 }, -- Enriched Manna Biscuit
    [13755] = { cat = "food", hp = 841, lvl = 35, ilvl = 45 }, -- Raw Winter Squid
    [13810] = { cat = "food", hp = 1858, lvl = 45, ilvl = 55 }, -- Blessed Sunfruit
    [13851] = { cat = "food", hp = 841, buff = { agi = 10 }, lvl = 25, ilvl = 35 }, -- Hot Wolf Ribs
    [13893] = { cat = "food", hp = 1338, lvl = 45, ilvl = 55 }, -- Large Raw Mightfish
    [13927] = { cat = "food", hp = 1338, buff = { ap = 30 }, lvl = 35, ilvl = 45 }, -- Cooked Glossy Mightfish
    [13928] = { cat = "food", hp = 2065, buff = { crit = 1 }, lvl = 35, ilvl = 45 }, -- Grilled Squid
    [13929] = { cat = "food", hp = 2065, buff = { crit = 1 }, lvl = 35, ilvl = 45 }, -- Hot Smoked Bass
    [13930] = { cat = "food", hp = 1338, buff = { other = 1 }, lvl = 35, ilvl = 45 }, -- Filet of Redgill
    [13931] = { cat = "food", hp = 1338, buff = { spd = 22 }, lvl = 35, ilvl = 45 }, -- Nightfin Soup
    [13932] = { cat = "food", hp = 2065, buff = { ap = 40 }, lvl = 35, ilvl = 45 }, -- Poached Sunscale Salmon
    [13933] = { cat = "food", hp = 2065, buff = { spd = 28 }, lvl = 45, ilvl = 55 }, -- Lobster Stew
    [13934] = { cat = "food", hp = 2065, buff = { ap = 40 }, lvl = 45, ilvl = 55 }, -- Mightfish Steak
    [13935] = { cat = "food", hp = 2065, buff = { spd = 28 }, lvl = 45, ilvl = 55 }, -- Baked Salmon
    [14529] = { cat = "bandage", hp = 1360, skill = 200, lvl = 0, ilvl = 52 }, -- Runecloth Bandage
    [14530] = { cat = "bandage", hp = 2000, skill = 225, lvl = 0, ilvl = 58 }, -- Heavy Runecloth Bandage
    [14894] = { cat = "other", hp = 600, mp = 600, cd = 1153, lvl = 0, ilvl = 51, conj = true }, -- Lily Root
    [15723] = { cat = "other", hp = 1400, mp = 1400, cd = 1153, lvl = 50, ilvl = 60 }, -- Tea with Sugar
    [16166] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Bean Soup
    [16167] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Versicolor Treat
    [16168] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Heaven Peach
    [16169] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Wild Ricecake
    [16170] = { cat = "food", hp = 530, lvl = 15, ilvl = 25 }, -- Steamed Mandu
    [16171] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Shinsollo
    [16766] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Undermine Clam Chowder
    [16971] = { cat = "food", hp = 1338, buff = { spi = 12, sta = 12 }, lvl = 40, ilvl = 45 }, -- Clamlette Surprise
    [17119] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Deeprun Rat Kabob
    [17197] = { cat = "food", hp = 58, buff = { spi = 2, sta = 2 }, lvl = 1, ilvl = 10 }, -- Gingerbread Cookie
    [17198] = { cat = "food", hp = 58, buff = { spi = 2, sta = 2 }, lvl = 1, ilvl = 10 }, -- Egg Nog
    [17222] = { cat = "food", hp = 1338, buff = { sta = 15 }, lvl = 35, ilvl = 45 }, -- Spider Sausage
    [17344] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Candy Cane
    [17348] = { cat = "potion", hp = 1120, lvl = 45, ilvl = 55 }, -- Major Healing Draught
    [17349] = { cat = "potion", hp = 640, lvl = 35, ilvl = 45 }, -- Superior Healing Draught
    [17351] = { cat = "potion", mp = 1120, lvl = 45, ilvl = 55 }, -- Major Mana Draught
    [17352] = { cat = "potion", mp = 640, lvl = 35, ilvl = 45 }, -- Superior Mana Draught
    [17404] = { cat = "food", mp = 420, lvl = 5, ilvl = 15 }, -- Blended Bean Brew
    [17406] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Holiday Cheesewheel
    [17407] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Graccu's Homemade Meat Pie
    [17408] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Spicy Beefstick
    [18045] = { cat = "food", hp = 1338, buff = { agi = 15 }, lvl = 35, ilvl = 45 }, -- Tender Wolf Steak
    [18253] = { cat = "potion", hp = 1600, mp = 1600, lvl = 50, ilvl = 60 }, -- Major Rejuvenation Potion
    [18254] = { cat = "food", hp = 1338, buff = { int = 15 }, lvl = 35, ilvl = 45 }, -- Runn Tum Tuber Surprise
    [18255] = { cat = "food", hp = 1338, lvl = 45, ilvl = 55 }, -- Runn Tum Tuber
    [18262] = { cat = "weapon", kind = "elemental", wep = 42483, lvl = 50, ilvl = 60 }, -- Elemental Sharpening Stone
    [18300] = { cat = "food", mp = 4038, lvl = 55, ilvl = 65 }, -- Hyjal Nectar
    [18632] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Moonbrook Riot Taffy
    [18633] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Styleen's Sour Suckerpop
    [18635] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Bellara's Nutterbar
    [18839] = { cat = "potion", hp = 800, lvl = 35, ilvl = 45 }, -- Combat Healing Potion
    [18841] = { cat = "potion", mp = 1200, lvl = 41, ilvl = 51 }, -- Combat Mana Potion
    [19004] = { cat = "healthstone", hp = 110, lvl = 1, ilvl = 10, conj = true }, -- Minor Healthstone
    [19005] = { cat = "healthstone", hp = 120, lvl = 1, ilvl = 10, conj = true }, -- Minor Healthstone
    [19006] = { cat = "healthstone", hp = 275, lvl = 12, ilvl = 22, conj = true }, -- Lesser Healthstone
    [19007] = { cat = "healthstone", hp = 300, lvl = 12, ilvl = 22, conj = true }, -- Lesser Healthstone
    [19008] = { cat = "healthstone", hp = 550, lvl = 24, ilvl = 34, conj = true }, -- Healthstone
    [19009] = { cat = "healthstone", hp = 600, lvl = 24, ilvl = 34, conj = true }, -- Healthstone
    [19010] = { cat = "healthstone", hp = 880, lvl = 36, ilvl = 46, conj = true }, -- Greater Healthstone
    [19011] = { cat = "healthstone", hp = 960, lvl = 36, ilvl = 46, conj = true }, -- Greater Healthstone
    [19012] = { cat = "healthstone", hp = 1320, lvl = 48, ilvl = 58, conj = true }, -- Major Healthstone
    [19013] = { cat = "healthstone", hp = 1440, lvl = 48, ilvl = 58, conj = true }, -- Major Healthstone
    [19066] = { cat = "bandage", hp = 2000, skill = 225, lvl = 45, ilvl = 55 }, -- Warsong Gulch Runecloth Bandage
    [19067] = { cat = "bandage", hp = 1104, skill = 175, lvl = 35, ilvl = 45 }, -- Warsong Gulch Mageweave Bandage
    [19068] = { cat = "bandage", hp = 640, skill = 125, lvl = 25, ilvl = 35 }, -- Warsong Gulch Silk Bandage
    [19223] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Darkmoon Dog
    [19224] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Red Hot Wings
    [19225] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Deep Fried Candybar
    [19299] = { cat = "food", mp = 803, lvl = 15, ilvl = 25 }, -- Fizzy Faire Drink
    [19300] = { cat = "food", mp = 1915, lvl = 35, ilvl = 45 }, -- Bottled Winterspring Water
    [19301] = { cat = "food", hp = 4240, mp = 4240, lvl = 51, ilvl = 60 }, -- Alterac Manna Biscuit
    [19304] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Spiced Beef Jerky
    [19305] = { cat = "food", hp = 530, lvl = 15, ilvl = 25 }, -- Pickled Kodo Foot
    [19306] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Crunchy Frog
    [19307] = { cat = "bandage", hp = 2000, skill = 225, lvl = 0, ilvl = 58 }, -- Alterac Heavy Runecloth Bandage
    [19696] = { cat = "food", hpPct = 2, dur = 25, lvl = 0, ilvl = 55, conj = true }, -- Harvest Bread
    [19994] = { cat = "food", hpPct = 2, dur = 25, lvl = 0, ilvl = 55 }, -- Harvest Fruit
    [19995] = { cat = "food", hpPct = 2, dur = 25, lvl = 0, ilvl = 55 }, -- Harvest Boar
    [19996] = { cat = "food", hpPct = 2, dur = 25, lvl = 0, ilvl = 55 }, -- Harvest Fish
    [20031] = { cat = "food", hp = 2451, mp = 4240, lvl = 55, ilvl = 65 }, -- Essence Mango
    [20065] = { cat = "bandage", hp = 1104, skill = 175, lvl = 35, ilvl = 45 }, -- Arathi Basin Mageweave Bandage
    [20066] = { cat = "bandage", hp = 2000, skill = 225, lvl = 45, ilvl = 55 }, -- Arathi Basin Runecloth Bandage
    [20067] = { cat = "bandage", hp = 640, skill = 125, lvl = 25, ilvl = 35 }, -- Arathi Basin Silk Bandage
    [20074] = { cat = "food", hp = 841, buff = { agi = 10 }, lvl = 25, ilvl = 35 }, -- Heavy Crocolisk Stew
    [20232] = { cat = "bandage", hp = 1104, skill = 175, lvl = 35, ilvl = 45 }, -- Defiler's Mageweave Bandage
    [20234] = { cat = "bandage", hp = 2000, skill = 225, lvl = 45, ilvl = 55 }, -- Defiler's Runecloth Bandage
    [20235] = { cat = "bandage", hp = 640, skill = 125, lvl = 25, ilvl = 35 }, -- Defiler's Silk Bandage
    [20237] = { cat = "bandage", hp = 1104, skill = 175, lvl = 35, ilvl = 45 }, -- Highlander's Mageweave Bandage
    [20243] = { cat = "bandage", hp = 2000, skill = 225, lvl = 45, ilvl = 55 }, -- Highlander's Runecloth Bandage
    [20244] = { cat = "bandage", hp = 640, skill = 125, lvl = 25, ilvl = 35 }, -- Highlander's Silk Bandage
    [20452] = { cat = "food", hp = 2065, buff = { str = 20 }, lvl = 45, ilvl = 55 }, -- Smoked Desert Dumplings
    [20516] = { cat = "food", hpPct = 2, dur = 24, lvl = 0, ilvl = 55 }, -- Bobbing Apple
    [20744] = { cat = "weapon", kind = "wizardoil", wep = 0, lvl = 5, ilvl = 15 }, -- Minor Wizard Oil
    [20745] = { cat = "weapon", kind = "manaoil", wep = 0, lvl = 20, ilvl = 30 }, -- Minor Mana Oil
    [20746] = { cat = "weapon", kind = "wizardoil", wep = 0, lvl = 30, ilvl = 40 }, -- Lesser Wizard Oil
    [20747] = { cat = "weapon", kind = "manaoil", wep = 0, lvl = 40, ilvl = 50 }, -- Lesser Mana Oil
    [20748] = { cat = "weapon", kind = "manaoil", wep = 0, lvl = 45, ilvl = 55 }, -- Brilliant Mana Oil
    [20749] = { cat = "weapon", kind = "wizardoil", wep = 0, lvl = 45, ilvl = 55 }, -- Brilliant Wizard Oil
    [20750] = { cat = "weapon", kind = "wizardoil", wep = 0, lvl = 40, ilvl = 50 }, -- Wizard Oil
    [20844] = { cat = "weapon", kind = "deadly", wep = 173555, lvl = 60, ilvl = 60, classes = 8 }, -- Deadly Poison V
    [21023] = { cat = "food", hp = 2451, buff = { sta = 25 }, lvl = 45, ilvl = 55 }, -- Dirge's Kickin' Chimaerok Chops
    [21030] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Darnassus Kimchi Pie
    [21031] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Cabbage Kimchi
    [21033] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Radish Kimchi
    [21072] = { cat = "food", hp = 234, buff = { spd = 4 }, lvl = 10, ilvl = 20 }, -- Smoked Sagefish
    [21215] = { cat = "food", hpPct = 5, mpPct = 5, dur = 20, lvl = 40, ilvl = 65 }, -- Graccu's Mince Meat Fruitcake
    [21217] = { cat = "food", hp = 530, buff = { spd = 7 }, lvl = 30, ilvl = 55 }, -- Sagefish Delight
    [21235] = { cat = "food", hpPct = 2, dur = 25, lvl = 0, ilvl = 55 }, -- Winter Veil Roast
    [21254] = { cat = "food", hpPct = 2, dur = 24, lvl = 0, ilvl = 55 }, -- Winter Veil Cookie
    [21552] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Striped Yellowtail
    [22324] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Winter Kimchi
    [22895] = { cat = "food", hp = 3057, lvl = 55, ilvl = 65, conj = true }, -- Conjured Cinnamon Roll
    [23160] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Friendship Bread
    [23172] = { cat = "food", hpPct = 4, mpPct = 3, dur = 25, lvl = 0, ilvl = 55 }, -- Refreshing Red Apple
    [23578] = { cat = "potion", mp = 1800, lvl = 49, ilvl = 59 }, -- Diet McWeaksauce
    [23579] = { cat = "potion", hp = 1400, lvl = 45, ilvl = 55 }, -- The McWeaksauce Classic
    [23684] = { cat = "bandage", hp = 2500, skill = 225, lvl = 0, ilvl = 60 }, -- Crystal Infused Bandage
    [211845] = { cat = "weapon", kind = "blackfathom", wep = 42483, lvl = 0, ilvl = 25 }, -- Blackfathom Sharpening Stone
    [216619] = { cat = "other", hp = 500, mp = 900, cd = 103, lvl = 0, ilvl = 33 }, -- Student Fodder
    [217345] = { cat = "weapon", kind = "sebacious", wep = 173555, bonus = 30, lvl = 60, ilvl = 60, classes = 8 }, -- Sebacious Poison
    [217346] = { cat = "weapon", kind = "numbing", wep = 173555, bonus = 30, lvl = 60, ilvl = 60, classes = 8 }, -- Numbing Poison
    [217347] = { cat = "weapon", kind = "atrophic", wep = 173555, bonus = 30, lvl = 60, ilvl = 60, classes = 8 }, -- Atrophic Poison
    [223913] = { cat = "potion", hp = 1500, lvl = 40, ilvl = 55 }, -- Major Healing Potion
    [223914] = { cat = "potion", hp = 650, lvl = 20, ilvl = 31 }, -- Greater Healing Potion
    [226374] = { cat = "weapon", kind = "occult", wep = 173555, bonus = 30, lvl = 54, ilvl = 54, classes = 8 }, -- Occult Poison I
    [231778] = { cat = "food", mp = 4903, lvl = 55, ilvl = 65, conj = true }, -- Mountain Spring Water
    [232433] = { cat = "bandage", hp = 3400, skill = 300, lvl = 50, ilvl = 70 }, -- Dense Runecloth Bandage
    [234444] = { cat = "weapon", kind = "occult", wep = 173555, bonus = 30, lvl = 60, ilvl = 60, classes = 8 }, -- Occult Poison II
    [238638] = { cat = "food", hp = 2451, buff = { agi = 25, sta = 10 }, lvl = 55, ilvl = 65, review = true }, -- Filet o' Flank
    [241650] = { cat = "potion", hp = 2800, lvl = 60, ilvl = 70 }, -- Major Discolored Healing Potion
    [247239] = { cat = "potion", hp = 320, lvl = 3, ilvl = 13 }, -- Lesser Discolored Healing Potion
    [247240] = { cat = "potion", hp = 640, lvl = 12, ilvl = 22 }, -- Discolored Healing Potion
    [247241] = { cat = "potion", hp = 1040, lvl = 21, ilvl = 31 }, -- Greater Discolored Healing Potion
    [247242] = { cat = "potion", hp = 1600, lvl = 35, ilvl = 45 }, -- Superior Discolored Healing Potion
    [248613] = { cat = "food", hp = 530, lvl = 15, ilvl = 25 }, -- Lightning in a Bottle
    [249796] = { cat = "food", hp = 1338, lvl = 45, ilvl = 55 }, -- Hyjal Berries
    [249865] = { cat = "food", mp = 145, buff = { heal = 2 }, lvl = 1, ilvl = 5 }, -- Peace Tea
    [249866] = { cat = "food", mp = 420, buff = { heal = 7 }, lvl = 5, ilvl = 15 }, -- Royal Tea
    [249867] = { cat = "food", mp = 803, buff = { heal = 11 }, lvl = 15, ilvl = 25 }, -- Root Tea
    [249868] = { cat = "food", mp = 1292, buff = { heal = 22 }, lvl = 25, ilvl = 35 }, -- Triage Tea
    [249869] = { cat = "food", mp = 1915, buff = { heal = 33 }, lvl = 35, ilvl = 45 }, -- Sunny Tea
    [249870] = { cat = "food", mp = 2821, buff = { heal = 44 }, lvl = 45, ilvl = 55 }, -- Sage's Tea
    [249871] = { cat = "food", mp = 145, buff = { spi = 1 }, lvl = 1, ilvl = 5 }, -- Venomous Smoothie
    [249872] = { cat = "food", mp = 420, buff = { spi = 3 }, lvl = 5, ilvl = 15 }, -- Slimy Smoothie
    [249873] = { cat = "food", mp = 803, buff = { spi = 5 }, lvl = 15, ilvl = 25 }, -- Mrrggl Smrrthle
    [249874] = { cat = "food", mp = 1292, buff = { spi = 10 }, lvl = 25, ilvl = 35 }, -- Calcified Smoothie
    [249875] = { cat = "food", mp = 1915, buff = { spi = 15 }, lvl = 35, ilvl = 45 }, -- Spicy Smoothie
    [249876] = { cat = "food", mp = 2821, buff = { spi = 20 }, lvl = 45, ilvl = 55 }, -- Wicked Smoothie
    [250065] = { cat = "food", hp = 1338, buff = { str = 15 }, lvl = 35, ilvl = 45 }, -- Savory Stag Sliders
    [250066] = { cat = "food", hp = 2065, buff = { int = 20 }, lvl = 45, ilvl = 55 }, -- Soaring Pamplona
    [250067] = { cat = "food", hp = 2065, buff = { int = 20 }, lvl = 45, ilvl = 55 }, -- Bat Hachee
    [250068] = { cat = "food", hp = 2065, buff = { sta = 20 }, lvl = 45, ilvl = 55 }, -- Savory Turtle Stew
    [250069] = { cat = "food", hp = 2065, buff = { agi = 20 }, lvl = 45, ilvl = 55 }, -- Flank au Poivre
    [250070] = { cat = "food", hp = 2065, buff = { str = 20 }, lvl = 45, ilvl = 55 }, -- Bear Bruscitti
    [250071] = { cat = "food", hp = 2065, buff = { str = 20 }, lvl = 45, ilvl = 55 }, -- Steaming Stag Steak
    [250072] = { cat = "food", hp = 2065, buff = { agi = 20 }, lvl = 45, ilvl = 55 }, -- Swiftstrike Steak
    [250073] = { cat = "food", hp = 841, buff = { int = 10 }, lvl = 25, ilvl = 35 }, -- Raging Raptor Ribs
    [250074] = { cat = "food", hp = 841, buff = { str = 10 }, lvl = 25, ilvl = 35 }, -- Bear Brisket
    [250075] = { cat = "food", hp = 2065, buff = { int = 20 }, lvl = 45, ilvl = 55 }, -- Prehistoric Pulled Raptor
    [250076] = { cat = "food", hp = 1338, buff = { int = 15 }, lvl = 35, ilvl = 45 }, -- Raptor Rouladen
    [250077] = { cat = "food", hp = 234, buff = { int = 3 }, lvl = 5, ilvl = 15 }, -- Twice-Spiced Raptor Slice
    [250078] = { cat = "food", hp = 841, buff = { sta = 10 }, lvl = 25, ilvl = 35 }, -- Giant Scrambled Eggs
    [250079] = { cat = "food", hp = 58, buff = { int = 1 }, lvl = 1, ilvl = 10 }, -- Tasty Raptor Bites
    [250080] = { cat = "food", hp = 234, buff = { sta = 3 }, lvl = 5, ilvl = 15 }, -- Breakfast Omelette
    [250081] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Clam Linguine
    [252022] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Galestrider Jerky
    [252023] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Zaalanarr Sharp
    [252026] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Gustberry Pie
    [252027] = { cat = "food", mp = 420, lvl = 5, ilvl = 15 }, -- Gustberry Juice
    [252028] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Fresh Gustberry Bread
    [252029] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Hippogryph Flank
    [252030] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Pungent Skycheddar
    [252031] = { cat = "food", mp = 145, lvl = 1, ilvl = 5 }, -- Crisp Spring Water
    [252032] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Red Delicious Stormapple
    [255663] = { cat = "potion", hp = 60, mp = 40, lvl = 0, ilvl = 1 }, -- Windstone
    [260623] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Candied Fruit Sampler
    [260624] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Pristine Peach
    [260625] = { cat = "food", hp = 1338, lvl = 35, ilvl = 45 }, -- Garnished Rice Cake
    [260627] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Savory Shen'dralar Steak
    [260628] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Stuffed Pumpkin
    [262433] = { cat = "food", hp = 4240, mp = 4240, lvl = 0, ilvl = 60 }, -- Ketharas' Hyjal Stew
    [263509] = { cat = "food", hp = 58, buff = { sta = 1 }, lvl = 5, ilvl = 15 }, -- Skywall Souffle
    [263512] = { cat = "food", hp = 58, buff = { int = 1 }, lvl = 5, ilvl = 15 }, -- Pincer Bites
    [267341] = { cat = "food", hp = 2065, buff = { other = 1 }, lvl = 55, ilvl = 60 }, -- Sweetpaw Jam
    [267474] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Galeswept Forestshroom
    [268881] = { cat = "potion", hp = 80, lvl = 1, ilvl = 5, conj = true }, -- Perishable Minor Healing Potion
    [268882] = { cat = "potion", hp = 160, lvl = 3, ilvl = 13, conj = true }, -- Perishable Lesser Healing Potion
    [268883] = { cat = "potion", hp = 320, lvl = 12, ilvl = 22, conj = true }, -- Perishable Healing Potion
    [268912] = { cat = "food", hp = 234, buff = { sta = 3 }, lvl = 5, ilvl = 15, conj = true }, -- Expiring Crab Cake
    [268913] = { cat = "food", hp = 234, buff = { sta = 3 }, lvl = 5, ilvl = 15, conj = true }, -- Expiring Crocolisk Steak
    [272056] = { cat = "bandage", hp = 640, skill = 125, lvl = 25, ilvl = 35 }, -- Darkspear Islands Silk Bandage
    [272057] = { cat = "bandage", hp = 1104, skill = 175, lvl = 35, ilvl = 45 }, -- Darkspear Islands Mageweave Bandage
    [272058] = { cat = "bandage", hp = 2000, skill = 225, lvl = 45, ilvl = 55 }, -- Darkspear Islands Runecloth Bandage
    [274935] = { cat = "potion", hp = 800, mp = 800, lvl = 35, ilvl = 45 }, -- Tessa's Tonic
    [274947] = { cat = "weapon", kind = "imbue_flame", wep = 1024, lvl = 5, ilvl = 15, classes = 128 }, -- Scroll of Imbue Lesser Flame
    [274971] = { cat = "food", hp = 841, buff = { spd = 14 }, lvl = 25, ilvl = 35 }, -- Briny Seafood Stew
    [274976] = { cat = "food", hp = 841, buff = { str = 10 }, lvl = 25, ilvl = 35 }, -- Plain Ol' Paletusk
    [275067] = { cat = "weapon", kind = "imbue_chillknife", wep = 32768, lvl = 5, ilvl = 15, classes = 128 }, -- Scroll of Imbue Chillknife
    [277485] = { cat = "weapon", kind = "imbue_frost", wep = 1024, lvl = 16, ilvl = 25, classes = 128 }, -- Scroll of Imbue Frost
    [277486] = { cat = "weapon", kind = "imbue_striking", wep = 1024, lvl = 16, ilvl = 25, classes = 128 }, -- Scroll of Imbue Striking
    [277487] = { cat = "weapon", kind = "imbue_baleflame", wep = 1024, lvl = 16, ilvl = 25, classes = 128 }, -- Scroll of Imbue Baleflame
    [277488] = { cat = "weapon", kind = "imbue_iceknife", wep = 32768, lvl = 16, ilvl = 25, classes = 128 }, -- Scroll of Imbue Iceknife
    [277489] = { cat = "weapon", kind = "imbue_spark", wep = 128, lvl = 16, ilvl = 25, classes = 128 }, -- Scroll of Imbue Spark
    [277494] = { cat = "weapon", kind = "imbue_accuracy", wep = 1024, lvl = 25, ilvl = 40, classes = 128 }, -- Scroll of Imbue Accuracy
    [277495] = { cat = "weapon", kind = "imbue_quickening", wep = 1024, lvl = 25, ilvl = 40, classes = 128 }, -- Scroll of Imbue Quickening
    [277496] = { cat = "weapon", kind = "imbue_balefrost", wep = 1024, lvl = 25, ilvl = 40, classes = 128 }, -- Scroll of Imbue Balefrost
    [277497] = { cat = "weapon", kind = "imbue_flame", wep = 1024, lvl = 25, ilvl = 40, classes = 128 }, -- Scroll of Imbue Flame
    [277498] = { cat = "weapon", kind = "imbue_manablade", wep = 32768, lvl = 25, ilvl = 40, classes = 128 }, -- Scroll of Imbue Manablade
    [277500] = { cat = "weapon", kind = "imbue_flame", wep = 1024, lvl = 46, ilvl = 55, classes = 128 }, -- Scroll of Imbue Greater Flame
    [277501] = { cat = "weapon", kind = "imbue_frost", wep = 1024, lvl = 46, ilvl = 55, classes = 128 }, -- Scroll of Imbue Greater Frost
    [277502] = { cat = "weapon", kind = "imbue_precision", wep = 1024, lvl = 46, ilvl = 55, classes = 128 }, -- Scroll of Imbue Precision
    [277503] = { cat = "weapon", kind = "imbue_spellbreak", wep = 1024, lvl = 46, ilvl = 55, classes = 128 }, -- Scroll of Imbue Spellbreak
    [278117] = { cat = "food", hp = 234, lvl = 5, ilvl = 15 }, -- Hard Boiled Eggs
    [278118] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Rich Broth
    [278119] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Bread with Butter
    [278120] = { cat = "food", hp = 841, lvl = 25, ilvl = 35 }, -- Fruit Platter
    [278121] = { cat = "food", hp = 530, lvl = 15, ilvl = 25 }, -- Smoked Sausage
    [278122] = { cat = "food", hp = 2065, lvl = 45, ilvl = 55 }, -- Carrot Salad
    [278265] = { cat = "food", hp = 28, lvl = 1, ilvl = 5 }, -- Nutritious Slime Sludge
    [278569] = { cat = "food", hp = 58, lvl = 1, ilvl = 5 }, -- Yesterday's Leftovers
    [282018] = { cat = "food", hpPct = 5, mpPct = 5, dur = 20, lvl = 1, ilvl = 1 }, -- Restorative Bread
    [286152] = { cat = "food", hp = 1338, buff = { other = 1 }, lvl = 35, ilvl = 45 }, -- Plated Armorfish
    [287963] = { cat = "food", hp = 2065, lvl = 1, ilvl = 55 }, -- Roasted Quail
    [287964] = { cat = "food", mp = 2821, lvl = 1, ilvl = 55 }, -- Morning Glory Dew
    [287966] = { cat = "potion", hp = 80, lvl = 1, ilvl = 5 }, -- Minor Healing Potion
    [287967] = { cat = "potion", hp = 160, lvl = 1, ilvl = 13 }, -- Lesser Healing Potion
    [287968] = { cat = "potion", mp = 160, lvl = 1, ilvl = 15 }, -- Minor Mana Potion
    [287969] = { cat = "potion", mp = 320, lvl = 1, ilvl = 24 }, -- Lesser Mana Potion
    [287973] = { cat = "food", hp = 1338, buff = { agi = 15 }, lvl = 1, ilvl = 45 }, -- Tender Wolf Steak
    [287974] = { cat = "food", hp = 2065, buff = { crit = 1 }, lvl = 1, ilvl = 45 }, -- Grilled Squid
    [287977] = { cat = "potion", hp = 520, lvl = 1, ilvl = 31 }, -- Greater Healing Potion
    [287978] = { cat = "weapon", kind = "sharpen", wep = 33219, bonus = 2, lvl = 1, ilvl = 5 }, -- Rough Sharpening Stone
    [287979] = { cat = "weapon", kind = "wizardoil", wep = 0, lvl = 1, ilvl = 40 }, -- Lesser Wizard Oil
    [287980] = { cat = "weapon", kind = "elemental", wep = 42483, lvl = 1, ilvl = 60 }, -- Elemental Sharpening Stone
}

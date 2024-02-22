doFile("/scripts/RacialAbilityBoost/RacialAbilityBoostBorderGuards.lua")
doFile("/scripts/RacialAbilityBoost/RacialAbilityBoostDarkAcolytes.lua")

-- Adjustable params

PARAM_RANGER_SET_FAVORED_ENEMY_COST = 200
PARAM_RANGER_GET_FAVORED_ENEMY_COST = 200
PARAM_WIZARD_ARTIFICER_COST = 200
PARAM_WIZARD_ARTIFICER_ARTIFACT_COST = 500
PARAM_RUNEMAGE_WAR_MACHINE_VISIT_COST = 100
PARAM_WARLOCK_DARK_RITUAL_COST = 1000
PARAM_WARLOCK_DARK_ACOLYTE_BASE_SAVING = 0.4
PARAM_WARLOCK_DARK_ACOLYTE_PER_LEVEL_SAVING = 0.02
PARAM_STRONGHOLD_WALKERS_HUT_COST = 200

MAX_WIZARD_SPELLS_PER_HAND = 30
TOWN_NEUTRAL = 8

-- Rune spell info

RUNE_SPELLS = {
    [1] = {[0] = SPELL_RUNE_OF_CHARGE, [1] = SPELL_RUNE_OF_BERSERKING},
    [2] = {[0] = SPELL_RUNE_OF_MAGIC_CONTROL, [1] = SPELL_RUNE_OF_EXORCISM},
    [3] = {[0] = SPELL_RUNE_OF_ELEMENTAL_IMMUNITY, [1] = SPELL_RUNE_OF_ETHEREALNESS},
    [4] = {[0] = SPELL_RUNE_OF_STUNNING, [1] = SPELL_RUNE_OF_REVIVE},
    [5] = {[0] = SPELL_RUNE_OF_BATTLERAGE, [1] = SPELL_RUNE_OF_DRAGONFORM}, }

-- Warcry spell info

WARCRY_SPELLS = {
    [1] = {[0] = SPELL_WARCRY_RALLING_CRY, [1] = SPELL_WARCRY_CALL_OF_BLOOD}, 
    [2] = {[0] = SPELL_WARCRY_WORD_OF_THE_CHIEF, [1] = SPELL_WARCRY_FEAR_MY_ROAR}, 
    [3] = {[0] = SPELL_WARCRY_BATTLECRY, [1] = SPELL_WARCRY_SHOUT_OF_MANY}, }

-- Destructive spell info
DESTRUCTIVE_SPELLS = {
    [1] = {[0] = SPELL_MAGIC_ARROW, [1] = SPELL_STONE_SPIKES},
    [2] = {[0] = SPELL_LIGHTNING_BOLT, [1] = SPELL_ICE_BOLT},
    [3] = {[0] = SPELL_FIREBALL, [1] = SPELL_FROST_RING, [2] = SPELL_FIREWALL},
}

-- Basic info
MINI_TOWN = {[TOWN_PRESERVE] = "RABMiniPreserve",
             [TOWN_ACADEMY] = "RABMiniAcademy",
             [TOWN_HEAVEN] = "RABMiniHaven",
             [TOWN_FORTRESS] = "RABMiniFortress",
             [TOWN_STRONGHOLD] = "RABMiniStronghold", };

MINI_WAR_MACHINE_FACTORY = "RABMiniWarMachineFactory"

-- Avengers weekly growth matrix

AVENGERS_ENEMY_SLOTS = {
    [TOWN_HEAVEN] = {[1] = {CREATURE_PEASANT, 22}, [2] = {CREATURE_ARCHER,   12},
                     [3] = {CREATURE_FOOTMAN, 10}, [4] = {CREATURE_GRIFFIN,  5}, 
                     [5] = {CREATURE_PRIEST,  3},  [6] = {CREATURE_CAVALIER, 2},
                     [7] = {CREATURE_ANGEL,   1},},

    [TOWN_PRESERVE] = {[1] = {CREATURE_PIXIE,        10}, [2] = {CREATURE_BLADE_JUGGLER, 9},
                       [3] = {CREATURE_WOOD_ELF,     7},  [4] = {CREATURE_DRUID,         4}, 
                       [5] = {CREATURE_UNICORN,      3},  [6] = {CREATURE_TREANT,        2},
                       [7] = {CREATURE_GREEN_DRAGON, 1},},

    [TOWN_ACADEMY] = {[1] = {CREATURE_GREMLIN,    20}, [2] = {CREATURE_STONE_GARGOYLE, 14},
                      [3] = {CREATURE_IRON_GOLEM, 9},  [4] = {CREATURE_MAGI,           5}, 
                      [5] = {CREATURE_GENIE,      3},  [6] = {CREATURE_RAKSHASA,       2},
                      [7] = {CREATURE_GIANT,      1},},

    [TOWN_DUNGEON] = {[1] = {CREATURE_SCOUT,       7}, [2] = {CREATURE_WITCH,  5},
                      [3] = {CREATURE_MINOTAUR,    6}, [4] = {CREATURE_RIDER,  4}, 
                      [5] = {CREATURE_HYDRA,       3}, [6] = {CREATURE_MATRON, 2},
                      [7] = {CREATURE_DEEP_DRAGON, 1},},

    [TOWN_NECROMANCY] = {[1] = {CREATURE_SKELETON,    20}, [2] = {CREATURE_WALKING_DEAD, 15},
                         [3] = {CREATURE_MANES,       9},  [4] = {CREATURE_VAMPIRE,      5}, 
                         [5] = {CREATURE_LICH,        3},  [6] = {CREATURE_WIGHT,        2},
                         [7] = {CREATURE_BONE_DRAGON, 1},},

    [TOWN_INFERNO] = {[1] = {CREATURE_FAMILIAR,   16}, [2] = {CREATURE_DEMON,     15},
                      [3] = {CREATURE_HELL_HOUND, 8},  [4] = {CREATURE_SUCCUBUS,  5}, 
                      [5] = {CREATURE_NIGHTMARE,  3},  [6] = {CREATURE_PIT_FIEND, 2},
                      [7] = {CREATURE_DEVIL,      1},},

    [TOWN_FORTRESS] = {[1] = {CREATURE_DEFENDER,    18}, [2] = {CREATURE_AXE_FIGHTER, 14},
                       [3] = {CREATURE_BEAR_RIDER,  7},  [4] = {CREATURE_BROWLER,     6}, 
                       [5] = {CREATURE_RUNE_MAGE,   3},  [6] = {CREATURE_THANE,       2},
                       [7] = {CREATURE_FIRE_DRAGON, 1},},

    [TOWN_STRONGHOLD] = {[1] = {CREATURE_GOBLIN,           25}, [2] = {CREATURE_CENTAUR, 14},
                         [3] = {CREATURE_ORC_WARRIOR,      11}, [4] = {CREATURE_SHAMAN,  5}, 
                         [5] = {CREATURE_ORCCHIEF_BUTCHER, 5},  [6] = {CREATURE_WYVERN,  2},
                         [7] = {CREATURE_CYCLOP,           1},},

    [TOWN_NEUTRAL] = {[1] = {CREATURE_FIRE_ELEMENTAL,  4}, [2] = {CREATURE_WATER_ELEMENTAL, 4},
                      [3] = {CREATURE_EARTH_ELEMENTAL, 4}, [4] = {CREATURE_AIR_ELEMENTAL,   4}, 
                      [5] = {CREATURE_WOLF,            8}, [6] = {CREATURE_MUMMY,           3},
                      [7] = {CREATURE_DEATH_KNIGHT,    2}, [8] = {CREATURE_MANTICORE,       2},
                      [9] = {CREATURE_PHOENIX,         1},},}

-- Get Enemy areans
RACE2COMBATARENA = {
    [TOWN_HEAVEN] = "/Scenes/CombatArenas/Grass_Big_02.xdb#xpointer(/AdventureFlybyScene)",
    [TOWN_PRESERVE] = "/Scenes/CombatArenas/Beach_Grass_Big_01.xdb#xpointer(/AdventureFlybyScene)",
    [TOWN_ACADEMY] = "/Scenes/CombatArenas/Sand_Big_01.xdb#xpointer(/AdventureFlybyScene)",
    [TOWN_DUNGEON] = "/Scenes/CombatArenas/Subterra_abyss.xdb#xpointer(/AdventureFlybyScene)",
    [TOWN_NECROMANCY] = "/Scenes/CombatArenas/Dirt_Big_01.xdb#xpointer(/AdventureFlybyScene)",
    [TOWN_INFERNO] = "/Scenes/CombatArenas/Lava_Big_01.xdb#xpointer(/AdventureFlybyScene)",
    [TOWN_FORTRESS] = "/Scenes/CombatArenas/Snow_01.xdb#xpointer(/AdventureFlybyScene)",
    [TOWN_STRONGHOLD] = "/Scenes/CombatArenas/Subterra_Dwarven_02.xdb#xpointer(/AdventureFlybyScene)",
    [TOWN_NEUTRAL] = "/Scenes/CombatArenas/Boat_Arena.xdb#xpointer(/AdventureFlybyScene)",}

-- Get Artificer abilities
ARTIFICER_ABILITIES = {
    [1] = {SPELL_ENCOURAGE, SPELL_ABILITY_UNSUMMON, SPELL_ABILITY_DARK_RITUAL, SPELL_ABILITY_COUNTERSPELL, SPELL_PRAYER},
    [2] = {SPELL_HOLY_CHARGE, SPELL_DEMONIC_STRIKE, SPELL_DEATH_SCREAM, SPELL_UBER_CHAIN_LIGHTNING, },
    [3] = {SPELL_CONSUME_CORPSE, SPELL_EFFECT_POWERFULL_BLOW, SPELL_BOSS_FIREWALL, SPELL_IMBUE_ARROW, SPELL_UBER_METEOR_SHOWER},
    [4] = {SPELL_ABILITY_AVATAR_OF_DEATH, SPELL_SPIRIT_LINK, }, }

ABILITY2STRING = {
    [SPELL_ENCOURAGE] = "SPELL_ENCOURAGE",
    [SPELL_ABILITY_UNSUMMON] = "SPELL_ABILITY_UNSUMMON",
    [SPELL_ABILITY_DARK_RITUAL] = "SPELL_ABILITY_DARK_RITUAL",
    [SPELL_ABILITY_COUNTERSPELL] = "SPELL_ABILITY_COUNTERSPELL",
    [SPELL_PRAYER] = "SPELL_PRAYER",
    [SPELL_HOLY_CHARGE] = "SPELL_HOLY_CHARGE",
    [SPELL_DEMONIC_STRIKE] = "SPELL_DEMONIC_STRIKE",
    [SPELL_DEATH_SCREAM] = "SPELL_DEATH_SCREAM",
    [SPELL_UBER_CHAIN_LIGHTNING] = "SPELL_UBER_CHAIN_LIGHTNING",
    [SPELL_CONSUME_CORPSE] = "SPELL_CONSUME_CORPSE",
    [SPELL_EFFECT_POWERFULL_BLOW] = "SPELL_EFFECT_POWERFULL_BLOW",
    [SPELL_BOSS_FIREWALL] = "SPELL_BOSS_FIREWALL",
    [SPELL_IMBUE_ARROW] = "SPELL_IMBUE_ARROW",
    [SPELL_UBER_METEOR_SHOWER] = "SPELL_UBER_METEOR_SHOWER",
    [SPELL_ABILITY_AVATAR_OF_DEATH] = "SPELL_ABILITY_AVATAR_OF_DEATH",
    [SPELL_SPIRIT_LINK] = "SPELL_SPIRIT_LINK", }

-- Texts

RACE2TYPES = {
    [TOWN_HEAVEN] = "TOWN_HEAVEN",
    [TOWN_PRESERVE] = "TOWN_PRESERVE",
    [TOWN_ACADEMY] = "TOWN_ACADEMY",
    [TOWN_DUNGEON] = "TOWN_DUNGEON",
    [TOWN_NECROMANCY] = "TOWN_NECROMANCY",
    [TOWN_INFERNO] = "TOWN_INFERNO",
    [TOWN_FORTRESS] = "TOWN_FORTRESS",
    [TOWN_STRONGHOLD] = "TOWN_STRONGHOLD", }

RACE2TEXT = {
    [TOWN_HEAVEN] = "/GameMechanics/RefTables/Haven.txt",
    [TOWN_PRESERVE] = "/GameMechanics/RefTables/Preserve.txt",
    [TOWN_ACADEMY] = "/GameMechanics/RefTables/Academy.txt",
    [TOWN_DUNGEON] = "/GameMechanics/RefTables/Dungeon.txt",
    [TOWN_NECROMANCY] = "/GameMechanics/RefTables/Necropolis.txt",
    [TOWN_INFERNO] = "/GameMechanics/RefTables/Inferno.txt",
    [TOWN_FORTRESS] = "/GameMechanics/RefTables/Fortress.txt",
    [TOWN_STRONGHOLD] = "/GameMechanics/RefTables/Stronghold.txt",
    [TOWN_NEUTRAL] = "/Text/Game/Player/Colors/neutral.txt",}

CLASS2TEXT = {
    [TOWN_HEAVEN] = "/GameMechanics/RefTables/HeroClass/HeroClassKnight.txt",
    [TOWN_PRESERVE] = "/GameMechanics/RefTables/HeroClass/HeroClassRanger.txt",
    [TOWN_ACADEMY] = "/GameMechanics/RefTables/HeroClass/HeroClassWizard.txt",
    [TOWN_DUNGEON] = "/GameMechanics/RefTables/HeroClass/HeroClassWarlock.txt",
    [TOWN_NECROMANCY] = "/GameMechanics/RefTables/HeroClass/HeroClassNecromancer.txt",
    [TOWN_INFERNO] = "/GameMechanics/RefTables/HeroClass/HeroClassDemonLord.txt",
    [TOWN_FORTRESS] = "/GameMechanics/RefTables/HeroClass/HeroClassRunemage.txt",
    [TOWN_STRONGHOLD] = "/GameMechanics/RefTables/HeroClass/HeroClassBarbarian.txt",}

RUNE2TEXT = {
    [SPELL_RUNE_OF_CHARGE] = "/GameMechanics/Spell/Combat_Spells/RunicMagic/RuneOfChargeText.txt",
    [SPELL_RUNE_OF_BERSERKING] = "/GameMechanics/Spell/Combat_Spells/RunicMagic/RuneOfBerserkingName.txt",
    [SPELL_RUNE_OF_MAGIC_CONTROL] = "/GameMechanics/Spell/Combat_Spells/RunicMagic/RuneOfMagicControlName.txt",
    [SPELL_RUNE_OF_EXORCISM] = "/GameMechanics/Spell/Combat_Spells/RunicMagic/RuneOfExorcismName.txt",
    [SPELL_RUNE_OF_ELEMENTAL_IMMUNITY] = "/GameMechanics/Spell/Combat_Spells/RunicMagic/RuneOfElementalImmunityName.txt",
    [SPELL_RUNE_OF_ETHEREALNESS] = "/GameMechanics/Spell/Combat_Spells/RunicMagic/RuneOfEthrealnessName.txt",
    [SPELL_RUNE_OF_STUNNING] = "/GameMechanics/Spell/Combat_Spells/RunicMagic/RuneOfStunningName.txt",
    [SPELL_RUNE_OF_REVIVE] = "/GameMechanics/Spell/Combat_Spells/RunicMagic/RuneOfReviveName.txt",
    [SPELL_RUNE_OF_BATTLERAGE] = "/GameMechanics/Spell/Combat_Spells/RunicMagic/RuneOfBattleRageName.txt",
    [SPELL_RUNE_OF_DRAGONFORM] = "/GameMechanics/Spell/Combat_Spells/RunicMagic/RuneOfDragonFormName.txt", }

WARCRY2TEXT = {
    [SPELL_WARCRY_RALLING_CRY] = "/Text/Game/Spells/Hero_Special_Abilities/Warcry_RallingCry/Name.txt",
    [SPELL_WARCRY_CALL_OF_BLOOD] = "/Text/Game/Spells/Hero_Special_Abilities/Warcry_CallOfBlood/Name.txt",
    [SPELL_WARCRY_WORD_OF_THE_CHIEF] = "/Text/Game/Spells/Hero_Special_Abilities/Warcry_WordOfTheChief/Name.txt",
    [SPELL_WARCRY_FEAR_MY_ROAR] = "/Text/Game/Spells/Hero_Special_Abilities/Warcry_FearMyRoar/Name.txt",
    [SPELL_WARCRY_BATTLECRY] = "/Text/Game/Spells/Hero_Special_Abilities/Warcry_BattleCry/Name.txt",
    [SPELL_WARCRY_SHOUT_OF_MANY] = "/Text/Game/Spells/Hero_Special_Abilities/Warcry_ShoutOfMany/Name.txt", }

DESTRUCTIVE2TEXT = {
    [SPELL_MAGIC_ARROW] = "/Text/Game/Spells/Combat/Magic_Arrow/Name.txt",
    [SPELL_STONE_SPIKES] = "/Text/Game/Spells/Combat/StoneSpikes/Name.txt",
    [SPELL_LIGHTNING_BOLT] = "/Text/Game/Spells/Combat/Lightning_Bolt/Name.txt",
    [SPELL_ICE_BOLT] = "/Text/Game/Spells/Combat/Ice_Bolt/Name.txt",
    [SPELL_FIREBALL] = "/Text/Game/Spells/Combat/Fireball/Name.txt", 
    [SPELL_FROST_RING] = "/Text/Game/Spells/Combat/Frost_Ring/Name.txt",
    [SPELL_FIREWALL] = "/Text/Game/Spells/Combat/Firewall/Name.txt", }

CREATURE2TEXT = {
    [CREATURE_PEASANT] = "/Text/Game/Creatures/Haven/Peasant.txt",
    [CREATURE_ARCHER] = "/Text/Game/Creatures/Haven/Archer.txt",
    [CREATURE_FOOTMAN] = "/Text/Game/Creatures/Haven/Footman.txt",
    [CREATURE_GRIFFIN] = "/Text/Game/Creatures/Haven/Griffin.txt",
    [CREATURE_PRIEST] = "/Text/Game/Creatures/Haven/Priest.txt",
    [CREATURE_CAVALIER] = "/Text/Game/Creatures/Haven/Cavalier.txt",
    [CREATURE_ANGEL] = "/Text/Game/Creatures/Haven/Angel.txt",
    [CREATURE_PIXIE] = "/Text/Game/Creatures/Preserve/Pixie.txt",
    [CREATURE_BLADE_JUGGLER] = "/Text/Game/Creatures/Preserve/Blade_Juggler.txt",
    [CREATURE_WOOD_ELF] = "/Text/Game/Creatures/Preserve/Wood_Elf.txt",
    [CREATURE_DRUID] = "/Text/Game/Creatures/Preserve/Druid.txt",
    [CREATURE_UNICORN] = "/Text/Game/Creatures/Preserve/Unicorn.txt",
    [CREATURE_TREANT] = "/Text/Game/Creatures/Preserve/Treant.txt",
    [CREATURE_GREEN_DRAGON] = "/Text/Game/Creatures/Preserve/Green_Dragon.txt",
    [CREATURE_GREMLIN] = "/Text/Game/Creatures/Academy/Gremlin.txt",
    [CREATURE_STONE_GARGOYLE] = "/Text/Game/Creatures/Academy/Stone_Gargoyle.txt",
    [CREATURE_IRON_GOLEM] = "/Text/Game/Creatures/Academy/Iron_Golem.txt",
    [CREATURE_MAGI] = "/Text/Game/Creatures/Academy/Magi.txt",
    [CREATURE_GENIE] = "/Text/Game/Creatures/Academy/Genie.txt",
    [CREATURE_RAKSHASA] = "/Text/Game/Creatures/Academy/Rakshasa.txt",
    [CREATURE_GIANT] = "/Text/Game/Creatures/Academy/Giant.txt",
    [CREATURE_SCOUT] = "/Text/Game/Creatures/Dungeon/Scout.txt",
    [CREATURE_WITCH] = "/Text/Game/Creatures/Dungeon/Witch.txt",
    [CREATURE_MINOTAUR] = "/Text/Game/Creatures/Dungeon/Minotaur.txt",
    [CREATURE_RIDER] = "/Text/Game/Creatures/Dungeon/Rider.txt",
    [CREATURE_HYDRA] = "/Text/Game/Creatures/Dungeon/Hydra.txt",
    [CREATURE_MATRON] = "/Text/Game/Creatures/Dungeon/Matron.txt",
    [CREATURE_DEEP_DRAGON] = "/Text/Game/Creatures/Dungeon/Deep_Dragon.txt",
    [CREATURE_SKELETON] = "/Text/Game/Creatures/Necropolis/Skeleton.txt",
    [CREATURE_WALKING_DEAD] = "/Text/Game/Creatures/Necropolis/Walking_Dead.txt",
    [CREATURE_MANES] = "/Text/Game/Creatures/Necropolis/Manes.txt",
    [CREATURE_VAMPIRE] = "/Text/Game/Creatures/Necropolis/Vampire.txt",
    [CREATURE_LICH] = "/Text/Game/Creatures/Necropolis/Lich.txt",
    [CREATURE_WIGHT] = "/Text/Game/Creatures/Necropolis/Wight.txt",
    [CREATURE_BONE_DRAGON] = "/Text/Game/Creatures/Necropolis/Bone_Dragon.txt",
    [CREATURE_FAMILIAR] = "/Text/Game/Creatures/Inferno/Familiar.txt",
    [CREATURE_DEMON] = "/Text/Game/Creatures/Inferno/Demon.txt",
    [CREATURE_HELL_HOUND] = "/Text/Game/Creatures/Inferno/HellHound.txt",
    [CREATURE_SUCCUBUS] = "/Text/Game/Creatures/Inferno/Succubus.txt",
    [CREATURE_NIGHTMARE] = "/Text/Game/Creatures/Inferno/Nightmare.txt",
    [CREATURE_PIT_FIEND] = "/Text/Game/Creatures/Inferno/PitFiend.txt",
    [CREATURE_DEVIL] = "/Text/Game/Creatures/Inferno/Devil.txt",
    [CREATURE_DEFENDER] = "/Text/Game/Creatures/Dwarf/Defender.txt",
    [CREATURE_AXE_FIGHTER] = "/Text/Game/Creatures/Dwarf/Axe_Fighter.txt",
    [CREATURE_BEAR_RIDER] = "/Text/Game/Creatures/Dwarf/Bear_Raider.txt",
    [CREATURE_BROWLER] = "/Text/Game/Creatures/Dwarf/Brawler.txt",
    [CREATURE_RUNE_MAGE] = "/Text/Game/Creatures/Dwarf/Rune_Mage.txt",
    [CREATURE_THANE] = "/Text/Game/Creatures/Dwarf/Thane.txt",
    [CREATURE_FIRE_DRAGON] = "/Text/Game/Creatures/Dwarf/Fire_Dragon.txt",
    [CREATURE_GOBLIN] = "/Text/Game/Creatures/Orcs/Goblin1.txt",
    [CREATURE_CENTAUR] = "/Text/Game/Creatures/Orcs/Centaur1.txt",
    [CREATURE_ORC_WARRIOR] = "/Text/Game/Creatures/Orcs/Orc1.txt",
    [CREATURE_SHAMAN] = "/Text/Game/Creatures/Orcs/Shaman1.txt",
    [CREATURE_ORCCHIEF_BUTCHER] = "/Text/Game/Creatures/Orcs/OrcChief1.txt",
    [CREATURE_WYVERN] = "/Text/Game/Creatures/Orcs/Wyvern1.txt",
    [CREATURE_CYCLOP] = "/Text/Game/Creatures/Orcs/Cyclop1.txt",
    [CREATURE_FIRE_ELEMENTAL] = "/Text/Game/Creatures/Neutrals/Fire_Elemental.txt",
    [CREATURE_WATER_ELEMENTAL] = "/Text/Game/Creatures/Neutrals/Water_Elemental.txt",
    [CREATURE_EARTH_ELEMENTAL] = "/Text/Game/Creatures/Neutrals/Earth_Elemental.txt",
    [CREATURE_AIR_ELEMENTAL] = "/Text/Game/Creatures/Neutrals/Air_Elemental.txt",
    [CREATURE_WOLF] = "/Text/Game/Creatures/Neutrals/Wolf/name.txt",
    [CREATURE_MUMMY] = "/Text/Game/Creatures/Neutrals/Mummy/name.txt",
    [CREATURE_DEATH_KNIGHT] = "/Text/Game/Creatures/Neutrals/Death_Knight.txt",
    [CREATURE_MANTICORE] = "/Text/Game/Creatures/Neutrals/Manticore/name.txt",
    [CREATURE_PHOENIX] = "/Text/Game/Creatures/Neutrals/Phoenix.txt", }

RESOURCE2TEXT = {
    [WOOD] = "/UI/Common/Resources/Wood.txt",
    [ORE] = "/UI/Common/Resources/Ore.txt",
    [MERCURY] = "/UI/Common/Resources/Mercury.txt",
    [CRYSTAL] = "/UI/Common/Resources/Crystal.txt",
    [SULFUR] = "/UI/Common/Resources/Sulfur.txt",
    [GEM] = "/UI/Common/Resources/Gems.txt",
    [GOLD] = "/UI/Common/Resources/Gold.txt", }

ABILITY2TEXT = {
    [SPELL_ENCOURAGE] = "/Text/Game/Spells/Hero_Special_Abilities/Encourage/Name.txt", 
    [SPELL_ABILITY_UNSUMMON] = "/Text/Game/Spells/Hero_Special_Abilities/Unsummon/Name.txt", 
    [SPELL_ABILITY_DARK_RITUAL] = "/Text/Game/Spells/Hero_Special_Abilities/DarkRitual/Name.txt", 
    [SPELL_ABILITY_COUNTERSPELL]  = "/Text/Game/Skills/Common/Sorcery/CounterSpell/Name.txt", 
    [SPELL_HOLY_CHARGE] = "/Text/Game/Spells/Hero_Special_Abilities/HolyCharge/Name.txt",
    [SPELL_PRAYER] = "/Text/Game/Spells/Hero_Special_Abilities/Prayer/Name.txt", 
    [SPELL_DEMONIC_STRIKE] = "/Text/Game/Skills/Unique/Gating/DemonicStrike/Name.txt", 
    [SPELL_DEATH_SCREAM] = "/Text/Game/Spells/Hero_Special_Abilities/DeathScream/Name.txt", 
    [SPELL_UBER_CHAIN_LIGHTNING] = "/Text/Game/Spells/Combat/Uber_Chain_Lightning/Name.txt", 
    [SPELL_CONSUME_CORPSE] = "/Text/Game/Skills/Unique/Gating/ConsumeCorpse/Name.txt", 
    [SPELL_EFFECT_POWERFULL_BLOW] = "/Text/Game/Skills/Unique/DemonicRage/PowerfullBlow/Name.txt", 
    [SPELL_BOSS_FIREWALL] = "/Text/Game/Spells/Combat/BigBossFirewall/Name.txt", 
    [SPELL_IMBUE_ARROW] = "/Text/Game/Skills/Unique/Avenger/ImbueArrow/Name.txt",
    [SPELL_UBER_METEOR_SHOWER] = "/Text/Game/Spells/Hero_Special_Abilities/UmbueArrow/Name.txt",
    [SPELL_ABILITY_AVATAR_OF_DEATH] = "/Text/Game/Heroes/Specializations/Necropolis/AvatarOfDeath/Name.txt", 
    [SPELL_SPIRIT_LINK] = "/Text/Game/Spells/Hero_Special_Abilities/SpiritLink/Name.txt", }


ACADEMY_SPECIAL_2_TEXT = "/Text/Game/TownBuildings/Academy/Special_2/Name.txt"
WIZARD_SKILL_ARTIFICER_TEXT = {
    [1] = "/Text/Game/Skills/Unique/Artificer/1/Name.txt",
    [2] = "/Text/Game/Skills/Unique/Artificer/2/Name.txt",
    [3] = "/Text/Game/Skills/Unique/Artificer/3/Name.txt", 
    [4] = "/Text/Game/Skills/Unique/Artificer/4/Name.txt", }

KNIGHT_SKILL_TRAINING_TEXT = {
    [1] = "/Text/Game/Skills/Unique/Training/1/Name.txt",
    [2] = "/Text/Game/Skills/Unique/Training/2/Name.txt",
    [3] = "/Text/Game/Skills/Unique/Training/3/Name.txt",}
KNIGHT_TRAINING_EXPERT_TEXT = "/Text/Game/Skills/Unique/Training/ExpertTrainer/Name.txt"
HAVEN_DWELLING_2_TEXT = "/Text/Game/TownBuildings/Haven/Dwelling_2/Upgraded_Name.txt"

FORTRESS_BLACKSMITH_TEXT = "/Text/Game/TownBuildings/Dwarves/Blacksmith/Name.txt"
RUNEMAGE_SKILL_RUNELORE_TEXT = {
    [1] = "/Text/Game/Skills/Unique/Runelore/1/Name.txt",
    [2] = "/Text/Game/Skills/Unique/Runelore/2/Name.txt",
    [3] = "/Text/Game/Skills/Unique/Runelore/3/Name.txt", }

DUNGEON_DARK_RITUAL_TEXT = "/Text/Game/Spells/Hero_Special_Abilities/DarkRitual/Name.txt"
DUNGEON_DARK_ACOLYTE_TEXT = "/Text/Game/Heroes/Specializations/Dungeon/Dark_Acolyte/Name.txt"
WALOCK_IRRESISTABLE_MAGIC_TEXT = {
    [0] = "/Text/Game/Skills/Unique/Invocation/Common/name.txt",
    [1] = "/Text/Game/Skills/Unique/Invocation/1/Name.txt",
    [2] = "/Text/Game/Skills/Unique/Invocation/2/Name.txt",
    [3] = "/Text/Game/Skills/Unique/Invocation/3/Name.txt",
    [4] = "/Text/Game/Skills/Unique/Invocation/4/Name.txt", }
KNOWLEDGE_ATTRIBUTE_TEXT = "/GameMechanics/RefTables/HeroAttribute/Knowledge.txt"

PRESERVE_SPECIAL_0_TEXT = "/Text/Game/TownBuildings/Preserve/Special_0/Name.txt"

BARBARIAN_SKILL_TEXT = {
    [HERO_SKILL_VOICE] = {[1] = "/Text/Game/Skills/BarbarianSpec/Voice/1/Name.txt", 
                          [2] = "/Text/Game/Skills/BarbarianSpec/Voice/2/Name.txt",
                          [3] = "/Text/Game/Skills/BarbarianSpec/Voice/3/Name.txt", },
    [HERO_SKILL_BARBARIAN_LEARNING] = {[1] = "/Text/Game/Skills/Common/Learning/1/Name.txt",
                                       [2] = "/Text/Game/Skills/Common/Learning/2/Name.txt",
                                       [3] = "/Text/Game/Skills/Common/Learning/3/Name.txt", },
    [HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC] = {[1] = "/Text/Game/Skills/BarbarianSpec/DestructiveMagic/1/Name.txt",
                                              [2] = "/Text/Game/Skills/BarbarianSpec/DestructiveMagic/2/Name.txt",
                                              [3] = "/Text/Game/Skills/BarbarianSpec/DestructiveMagic/3/Name.txt", },
    [HERO_SKILL_SHATTER_DARK_MAGIC] = {[1] = "/Text/Game/Skills/BarbarianSpec/DarkMagic/1/Name.txt",
                                       [2] = "/Text/Game/Skills/BarbarianSpec/DarkMagic/2/Name.txt",
                                       [3] = "/Text/Game/Skills/BarbarianSpec/DarkMagic/3/Name.txt",},
    [HERO_SKILL_SHATTER_LIGHT_MAGIC] = {[1] = "/Text/Game/Skills/BarbarianSpec/LightMagic/1/Name.txt",
                                        [2] = "/Text/Game/Skills/BarbarianSpec/LightMagic/2/Name.txt",
                                        [3] = "/Text/Game/Skills/BarbarianSpec/LightMagic/3/Name.txt", },
    [HERO_SKILL_SHATTER_SUMMONING_MAGIC] = {[1] = "/Text/Game/Skills/BarbarianSpec/SummoningMagic/1/Name.txt",
                                            [2] = "/Text/Game/Skills/BarbarianSpec/SummoningMagic/2/Name.txt",
                                            [3] = "/Text/Game/Skills/BarbarianSpec/SummoningMagic/3/Name.txt",}, }
TOWN_NEUTRAL = 8


doFile("/scripts/RacialAbilityBoost/RacialAbilityBoostBorderGuards.lua")
doFile("/scripts/RacialAbilityBoost/RacialAbilityBoostDarkAcolytes.lua")
doFile("/scripts/RacialAbilityBoost/RacialAbilityBoostDarkSuzerains.lua")
doFile("/scripts/RacialAbilityBoost/RacialAbilityBoostCreatureInfos.lua")

-- Adjustable params

PARAM_HAVEN_BASE_QUOTA = 20
PARAM_HAVEN_SPECIAL1_QUOTA = 10
PARAM_HAVEN_TRAINING_CREATURE_LEVEL_LIMIT = {
    [1] = 2, [2] = 4, [3] = 6, [4] = 7}
PARAM_HAVEN_TRAINING_COST_RACIAL_REDUCTION = {
    [1] = 0.0, [2] = 0.15, [3] = 0.30, [4] = 0.45}
PARAM_HAVEN_TRAINING_COST_PER_SPECIAL2_REDUCTION = 0.05
PARAM_HAVEN_TRAINING_COST_EXPERT_TRAINER_REDUCTION = 0.35
PARAM_HAVEN_TRAINING_COST_SUZERAIN_REDUCTION = 0.01
PARAM_HAVEN_TRAINING_COST_SUZERAIN_LEVEL = 3


PARAM_HAVEN_TRAINING_COST_BASE_MUL = 3
PARAM_HAVEN_TRAINING_COST_NO_BUILDING_MUL = 2

PARAM_DEMONLORD_RECALL_DEAD_BASE_DAYS = 4
PARAM_DEMONLORD_RECALL_DEAD_DAYS_PER_TIER = 2
PARAM_DEMONLORD_RECALL_DEAD_RACIAL_DISCOUNT = {
    [1] = 1.0, [2] = 0.7, [3] = 0.5, [4] = 0.4}
PARAM_DEMONLORD_RECALL_DEAD_RACIAL_RATIO = {
    [1] = 0.5, [2] = 0.6, [3] = 0.7, [4] = 0.8}
PARAM_DEMONLORD_SUMMON_GATED_BASE_DAYS = 12
PARAM_DEMONLORD_SUMMON_GATED_DAYS_PER_TIER = 2
PARAM_DEMONLORD_SUMMON_GATED_RACIAL_DISCOUNT = {
    [1] = 1.0, [2] = 0.7, [3] = 0.5, [4] = 0.4}
PARAM_DEMONLORD_SUMMON_GATED_RACIAL_RATIO = {
    [1] = 0.04, [2] = 0.05, [3] = 0.06, [4] = 0.07}
PARAM_DEMONLOAD_RECRUITMENT_COST = 1000
PARAM_DEMONLORD_CREATURE_EXPIRE_DAYS = 7

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

RAB_ZERO =  1e-6

-- Training info

HAVEN_SPECIAL1 = "/Text/Game/TownBuildings/Haven/Special_1/Name.txt"
HAVEN_SPECIAL2 = "/Text/Game/TownBuildings/Haven/Special_2/Name.txt"
HAVEN_EXPERT_TRAINER_TEXT = "/Text/Game/Skills/Unique/Training/ExpertTrainer/Name.txt"

TRAINING_MAPPING = {
    -- Haven
    [CREATURE_PEASANT] = CREATURE_ARCHER, [CREATURE_ARCHER] = CREATURE_FOOTMAN, [CREATURE_FOOTMAN] = CREATURE_PRIEST,
    [CREATURE_PRIEST] = CREATURE_CAVALIER,
    -- Sylvan
    [CREATURE_BLADE_JUGGLER] = CREATURE_WOOD_ELF, [CREATURE_WOOD_ELF] = CREATURE_DRUID, 
    -- Dungeon
    [CREATURE_SCOUT] = CREATURE_WITCH, [CREATURE_WITCH] = CREATURE_RIDER, [CREATURE_RIDER] = CREATURE_MATRON,
    -- Academy
    [-1] = CREATURE_MAGI,
    -- Fortress
    [CREATURE_DEFENDER] = CREATURE_AXE_FIGHTER, [CREATURE_AXE_FIGHTER] = CREATURE_BEAR_RIDER, [CREATURE_BEAR_RIDER] = CREATURE_BROWLER,
    [CREATURE_BROWLER] = CREATURE_RUNE_MAGE, [CREATURE_RUNE_MAGE] = CREATURE_THANE,
    -- Stronghold
    [CREATURE_ORC_WARRIOR] = CREATURE_SHAMAN, [CREATURE_SHAMAN] = CREATURE_ORCCHIEF_BUTCHER,
}

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
             [TOWN_INFERNO] = "RABMiniInferno",
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
    [2] = {SPELL_HOLY_CHARGE, SPELL_DEMONIC_STRIKE, SPELL_DEATH_SCREAM, },
    [3] = {SPELL_CONSUME_CORPSE, SPELL_EFFECT_POWERFULL_BLOW, SPELL_UBER_METEOR_SHOWER, SPELL_IMBUE_ARROW, SPELL_UBER_CHAIN_LIGHTNING, },
    [4] = {SPELL_ABILITY_AVATAR_OF_DEATH, SPELL_SPIRIT_LINK, SPELL_BOSS_FIREWALL, }, }

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

DEMONLORD_SKILL_GATING_TEXT = {
    [1] = "/Text/Game/Skills/Unique/Gating/1/Name.txt",
    [2] = "/Text/Game/Skills/Unique/Gating/2/Name.txt",
    [3] = "/Text/Game/Skills/Unique/Gating/3/Name.txt", 
    [4] = "/Text/Game/Skills/Unique/Gating/4/Name.txt", }

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
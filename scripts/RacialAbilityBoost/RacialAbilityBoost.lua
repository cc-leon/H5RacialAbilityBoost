doFile("/scripts/RacialAbilityBoost/RacialAbilityBoostCombatConstants.lua")
doFile("/scripts/RacialAbilityBoost/RacialAbilityBoostConstants.lua")
doFile("/scripts/RacialAbilityBoost/RacialAbilityBoostCommon.lua")

RAB_TXT = "/Text/Interface/RacialAbilityBoost/"

-- Portraits
PORT_HAVEN = "/GameMechanics/RefTables/GhostMode/face_Revenant.(Texture).xdb#xpointer(/Texture)"
PORT_SYLVAN = "/GameMechanics/RefTables/GhostMode/face_Shade.(Texture.xdb#xpointer(/Texture)"
PORT_ACADEMY = "/GameMechanics/RefTables/GhostMode/face_Phantasm.(Texture).xdb#xpointer(/Texture)"
PORT_DUNGEON = "/GameMechanics/RefTables/GhostMode/face_Banshee.(Texture).xdb#xpointer(/Texture)"
PORT_NECROPOLIS = "/GameMechanics/RefTables/GhostMode/face_Spectre.(Texture).xdb#xpointer(/Texture)"
PORT_INFERNO = "/GameMechanics/RefTables/GhostMode/face_Chimera.(Texture).xdb#xpointer(/Texture)"
PORT_FORTRESS = "/GameMechanics/RefTables/GhostMode/face_StoneSpirit.(Texture).xdb#xpointer(/Texture)"
PORT_STRONGHOLD = "/GameMechanics/RefTables/GhostMode/face_Spook.(Texture).xdb#xpointer(/Texture)"

-- Data exchange for callbacks
g_tabCallbackParams = {}

-- Flags
g_iToday = 0 -- tracking date change

g_bOtherInitialization = 0  -- trace if _rab_other_initialization has been run
g_tabAcademyUsedFactory = {}  -- trace if a hero has used arcane forge on a day
g_tabAcademySpellsRemaining = {} -- trace how many spells remains for each spellId each hand
g_tabAcademySpellsHeroBoughtSpell = {} -- trace if a hero has bought a spell
g_tabDunegonUsedDarkRitual = {}  -- trace if a hero has used dark ritual per day
g_tabDungeonIrresistableKnowledge = {}  -- trace if knowledge has been awarded based on irresitable magic
g_iHavenTrainingQuota = 0  -- total haven training quota
g_tabInfernoCreatureInfos = {}  -- inferno creature tracking, [playerId][dayNo][creatureId] = amount
g_tabPreserveUsedSettingEnemy = {}  -- trace if a hero has used setting enemy on a day
g_tabStrongholdUsedWalksHut = {}  -- trace if a hero has used walk's hut on a day
g_tabStrongholdShatterMagicLearnt = {}  -- trace if a hero has learnt shatter magic
g_tabStrongholdEnlightenmentShoutLearnt = {}  -- trace if a hero has learnt enlightenment or shout

function RacialAbilityBoost(heroName, customAbilityID)
    if g_bOtherInitialization == 0 then
        _rab_other_initialization()
        g_bOtherInitialization = 1
    end

    if customAbilityID == CUSTOM_ABILITY_3 then
        stackSplit(heroName, customAbilityID)

    elseif customAbilityID == CUSTOM_ABILITY_4 then
        local heroRace = _GetHeroRace(heroName)
        g_tabCallbackParams[1] = heroName

        if heroRace == TOWN_ACADEMY then
            local options = {[1] = {RAB_TXT.."AcademyOption1.txt"; movement = PARAM_WIZARD_ARTIFICER_COST}, 
                             [2] = {RAB_TXT.."AcademyOption2.txt"; gold = RESOURCE2TEXT[GOLD], movement = PARAM_WIZARD_ARTIFICER_ARTIFACT_COST}}
            _PagedTalkBox(
                PORT_ACADEMY,
                RAB_TXT.."dummy2.txt",
                {RAB_TXT.."AcademyTalkBoxDescription.txt"; race = RACE2TEXT[TOWN_ACADEMY], class = CLASS2TEXT[TOWN_ACADEMY]},
                RAB_TXT.."RABTalkBoxTitle.txt",
                "_AcademyAbilityCallback", options)
        elseif heroRace == TOWN_DUNGEON then
            local options = {[1] = {RAB_TXT.."DungeonOption1.txt"; darkritual = DUNGEON_DARK_RITUAL_TEXT},
                             [2] = {RAB_TXT.."DungeonOption2.txt"; knowledge = KNOWLEDGE_ATTRIBUTE_TEXT},
                             [3] = RAB_TXT.."DungeonOption3.txt", }
            _PagedTalkBox(
                PORT_DUNGEON,
                RAB_TXT.."dummy2.txt",
                {RAB_TXT.."DungeonTalkBoxDescription.txt"; race = RACE2TEXT[TOWN_DUNGEON], class = CLASS2TEXT[TOWN_DUNGEON], cost = PARAM_WARLOCK_DARK_RITUAL_COST, darkritual = DUNGEON_DARK_RITUAL_TEXT, darkacolyte = DUNGEON_DARK_ACOLYTE_TEXT, knowledge = KNOWLEDGE_ATTRIBUTE_TEXT},
                RAB_TXT.."RABTalkBoxTitle.txt",
                "_DungeonAbilityCallback", options)
        elseif heroRace == TOWN_FORTRESS then
            local options = {[1] = RAB_TXT.."FortressOption1.txt", [2] = RAB_TXT.."FortressOption2.txt", }
            _PagedTalkBox(
                PORT_FORTRESS,
                RAB_TXT.."dummy2.txt",
                {RAB_TXT.."FortressTalkBoxDescription.txt"; race = RACE2TEXT[TOWN_FORTRESS], class = CLASS2TEXT[TOWN_FORTRESS]},
                RAB_TXT.."RABTalkBoxTitle.txt",
                "_FortressAbilityCallback", options)
        elseif heroRace == TOWN_HEAVEN then
            local options = {[1] = {RAB_TXT.."HavenOption1.txt"; skill = KNIGHT_SKILL_TRAINING_TEXT[3], perk = KNIGHT_TRAINING_EXPERT_TEXT}, 
                             [2] = RAB_TXT.."HavenOption2.txt", [3] = RAB_TXT.."HavenOption3.txt", [4] = RAB_TXT.."HavenOption4.txt"}
            _PagedTalkBox(
                PORT_HAVEN,
                RAB_TXT.."dummy2.txt",
                {RAB_TXT.."HavenTalkBoxDescription.txt"; race = RACE2TEXT[TOWN_HEAVEN], class = CLASS2TEXT[TOWN_HEAVEN], skill = KNIGHT_SKILL_TRAINING_TEXT[3], perk = KNIGHT_TRAINING_EXPERT_TEXT},
                RAB_TXT.."RABTalkBoxTitle.txt",
                "_HavenAbilityCallback", options)
        elseif heroRace == TOWN_INFERNO then
            local switchString = RAB_TXT.."On.txt"
            if GetGameVar(RAB_COMBAT_GATING_SUFFIX.."SupressFlyMessage") == "" then
                switchString = RAB_TXT.."Off.txt"
            end
            local options = {[1] = RAB_TXT.."InfernoOption1.txt", [2] = RAB_TXT.."InfernoOption2.txt",
                             [3] = {RAB_TXT.."InfernoOption3.txt"; movement = PARAM_DEMONLOAD_RECRUITMENT_COST},
                             [4] = {RAB_TXT.."InfernoOption4.txt"; switch = switchString}}
            _PagedTalkBox(
                PORT_INFERNO,
                RAB_TXT.."dummy2.txt",
                {RAB_TXT.."InfernoTalkBoxDescription.txt"; race = RACE2TEXT[TOWN_INFERNO], class = CLASS2TEXT[TOWN_INFERNO]},
                RAB_TXT.."RABTalkBoxTitle.txt",
                "_InfernoAbilityCallback", options)
        elseif heroRace == TOWN_NECROMANCY then
            MessageBox({RAB_TXT.."NecropolisTalkBoxDescription.txt"; class = CLASS2TEXT[TOWN_NECROMANCY]})
        elseif heroRace == TOWN_PRESERVE  then
            local options = {[1] = {RAB_TXT.."PreserveOption1.txt"; movement = PARAM_RANGER_SET_FAVORED_ENEMY_COST},
                             [2] = {RAB_TXT.."PreserveOption2.txt"; movement = PARAM_RANGER_GET_FAVORED_ENEMY_COST},}
            _PagedTalkBox(
                PORT_SYLVAN,
                RAB_TXT.."dummy2.txt",
                {RAB_TXT.."PreserveTalkBoxDescription.txt"; race = RACE2TEXT[TOWN_PRESERVE], class = CLASS2TEXT[TOWN_PRESERVE]},
                RAB_TXT.."RABTalkBoxTitle.txt",
                "_PreserveAbilityCallback", options)
        elseif heroRace == TOWN_STRONGHOLD then
            local options = {[1] = RAB_TXT.."StrongholdOption1.txt",
                             [2] = {RAB_TXT.."StrongholdOption2.txt"; movement = PARAM_STRONGHOLD_WALKERS_HUT_COST}, 
                             [3] = RAB_TXT.."StrongholdOption3.txt", }
            _PagedTalkBox(
                PORT_STRONGHOLD,
                RAB_TXT.."dummy2.txt",
                {RAB_TXT.."StrongholdTalkBoxDescription.txt"; race = RACE2TEXT[TOWN_STRONGHOLD], class = CLASS2TEXT[TOWN_STRONGHOLD]},
                RAB_TXT.."RABTalkBoxTitle.txt",
                "_StrongholdAbilityCallback", options)
        end
    end
end

function _AcademyUpdateMagicGuilds()
    local maxLevel = _GetBuildingLevelInAllTowns(TOWN_ACADEMY, TOWN_BUILDING_ACADEMY_LIBRARY)
    local miniLevel = GetTownBuildingLevel(MINI_TOWN[TOWN_ACADEMY], TOWN_BUILDING_ACADEMY_LIBRARY)
    if maxLevel > miniLevel then
        UpgradeTownBuilding(MINI_TOWN[TOWN_ACADEMY], TOWN_BUILDING_ACADEMY_LIBRARY)
    elseif maxLevel < miniLevel then
        DestroyTownBuildingToLevel(MINI_TOWN[TOWN_ACADEMY], TOWN_BUILDING_ACADEMY_LIBRARY, 0)
    end

    maxLevel = _GetBuildingLevelInAllTowns(TOWN_ACADEMY, TOWN_BUILDING_MAGIC_GUILD)
    miniLevel = GetTownBuildingLevel(MINI_TOWN[TOWN_ACADEMY], TOWN_BUILDING_MAGIC_GUILD)

    if maxLevel > miniLevel then
        SetTownBuildingLimitLevel(MINI_TOWN[TOWN_ACADEMY], TOWN_BUILDING_MAGIC_GUILD, maxLevel)
        for i = 1, (maxLevel - miniLevel) do
            UpgradeTownBuilding(MINI_TOWN[TOWN_ACADEMY], TOWN_BUILDING_MAGIC_GUILD)
        end
    elseif maxLevel < miniLevel then
        DestroyTownBuildingToLevel(MINI_TOWN[TOWN_ACADEMY], TOWN_BUILDING_MAGIC_GUILD, maxLevel, 0)
    end
end

function _AcademyAbilityCallback(cNum)
    if cNum == 1 then
        if not _checkMovementCondition(g_tabCallbackParams[1], PARAM_WIZARD_ARTIFICER_COST) then
            return
        end
        local drKey = g_tabCallbackParams[1]..GetDate(ABSOLUTE_DAY)
        if g_tabAcademyUsedFactory[drKey] == nil then
            if not IsObjectExists(MINI_TOWN[TOWN_ACADEMY]) then
                MessageBox(RAB_TXT.."MissingObjectWarning.txt")
                return nil
            end
            _AcademyUpdateMagicGuilds()
            if _forceHeroInteractWithObject(g_tabCallbackParams[1], MINI_TOWN[TOWN_ACADEMY], true) == true then
                g_tabAcademyUsedFactory[drKey] = true
            end
        else
            MessageBox({RAB_TXT.."DailyLimitCheckFailure.txt"; times = 1, days = 1, limit = 1}, "")
        end
    elseif cNum == 2 then
        local options = {}
        local artiInfo = {}
        for spellLevel, spellIds in ARTIFICER_ABILITIES do
            local spellCosts = _getSpecialSpellsCost(spellLevel, TOWN_ACADEMY)
            for i, spellId in spellIds do
                if g_tabAcademySpellsHeroBoughtSpell[spellId][g_tabCallbackParams[1]] == true then
                    options[length(options) + 1] = {RAB_TXT.."AcademyArtificerArtefactInvalidOption.txt";
                                                    tier = spellLevel, spell = ABILITY2TEXT[spellId]}
                    artiInfo[length(options)] = {["spell"] = spellId, ["level"] = spellLevel, ["cost"] = nil}
                else
                    options[length(options) + 1] = {RAB_TXT.."AcademyArtificerArtefactValidOption.txt";
                                                    tier = spellLevel, spell = ABILITY2TEXT[spellId], cost = spellCosts[GOLD],
                                                    gold = RESOURCE2TEXT[GOLD], skill = WIZARD_SKILL_ARTIFICER_TEXT[spellLevel]}
                    artiInfo[length(options)] = {["spell"] = spellId, ["level"] = spellLevel, ["cost"] = spellCosts}
                end
            end
        end
        g_tabCallbackParams[2] = artiInfo
        _PagedTalkBox(
            PORT_ACADEMY,
            RAB_TXT.."dummy2.txt",
            {RAB_TXT.."AcademyArtificerArtefactDescription.txt"; race = RACE2TEXT[TOWN_ACADEMY], class = CLASS2TEXT[TOWN_ACADEMY]},
            RAB_TXT.."RABTalkBoxTitle.txt",
            "_AcademyArtificerArtefactCallback", options)
    end
end

function _AcademyArtificerArtefactCallback(cNum)
    local heroName = g_tabCallbackParams[1]
    local artiInfo = g_tabCallbackParams[2]
    if cNum < 1 then
        RacialAbilityBoost(heroName, CUSTOM_ABILITY_4)
        return
    end
    if artiInfo[cNum]["cost"] == nil then
        MessageBox({RAB_TXT.."AcademyArtificerArtefactInvalidOption.txt"; tier = artiInfo["level"], spell = ABILITY2TEXT[artiInfo[cNum]["spell"]]}, "")
        return
    end
    if artiInfo[cNum]["level"] > GetHeroSkillMastery(heroName, SKILL_ARTIFICIER) then
        MessageBox({RAB_TXT.."AcademyArtificerArtefactInsufficient.txt"; tier = artiInfo[cNum]["level"],
                    skill1 = WIZARD_SKILL_ARTIFICER_TEXT[artiInfo[cNum]["level"]], skill2 = WIZARD_SKILL_ARTIFICER_TEXT[GetHeroSkillMastery(heroName, SKILL_ARTIFICIER)]}, "")
        return
    end

    g_tabCallbackParams[2] = artiInfo[cNum]
    local options = {[1] = RAB_TXT.."AcademyArtificerArtefactHandOption1.txt",
                     [2] = RAB_TXT.."AcademyArtificerArtefactHandOption2.txt"}
    _PagedTalkBox(
        PORT_ACADEMY,
        RAB_TXT.."dummy2.txt",
        {RAB_TXT.."AcademyArtificerArtefactHandDescription.txt"; tier = artiInfo[cNum]["level"], spell = ABILITY2TEXT[artiInfo[cNum]["spell"]]},
        RAB_TXT.."RABTalkBoxTitle.txt",
        "_AcademyArtificerArtefactHandCallback", options)
end

function _AcademyArtificerArtefactHandCallback(cNum)
    local artiType = ""
    local artiInfo = g_tabCallbackParams[2]
    local heroName = g_tabCallbackParams[1]

    if cNum == 1 then
        artiType = "Wand"
    elseif cNum == 2 then
        artiType = "Scroll"
    else
        _AcademyAbilityCallback(2)
        return
    end

    local spellId = artiInfo["spell"]
    local objectName = artiType.."_"..ABILITY2STRING[spellId].."_"..(MAX_WIZARD_SPELLS_PER_HAND + 1 - g_tabAcademySpellsRemaining[spellId][artiType])
    if not IsObjectExists(objectName) then
        MessageBox(RAB_TXT.."MissingObjectWarning.txt")
        return nil
    end
    if g_tabAcademySpellsRemaining[spellId][artiType] <= 0 then
        MessageBox(RAB_TXT.."ObjectLimitReachedWarning.txt")
        return nil
    end

    if not _checkMovementCondition(heroName, PARAM_WIZARD_ARTIFICER_ARTIFACT_COST) then
        return
    end
    if not _currentPlayerResourceCheck(heroName, artiInfo["cost"]) then
        return
    end

    BlockGame()
    local x, y, z = GetObjectPos(heroName)
    MakeHeroInteractWithObject(heroName, objectName)
    sleep(2)
    SetObjectPos(heroName, x, y, z)
    sleep(2)
    g_tabAcademySpellsRemaining[spellId][artiType] = g_tabAcademySpellsRemaining[spellId][artiType] - 1
    g_tabAcademySpellsHeroBoughtSpell[spellId][heroName] = true
    UnblockGame()
end

function _DungeonAbilityCallback(cNum)
    if cNum == 1 then
        _DungeonImprovedDarkRitual(g_tabCallbackParams[1])
    elseif cNum == 2 then
        _DungeonIrresistableKnowledge(g_tabCallbackParams[1])
    elseif cNum == 3 then
        _DungeonLearnDestructiveSpells(g_tabCallbackParams[1])
    end
end

function _DungeonImprovedDarkRitual(heroName)
    local drKey = heroName..GetDate(ABSOLUTE_DAY)
    if g_tabDunegonUsedDarkRitual[drKey] == nil then
        local movCost = PARAM_WARLOCK_DARK_RITUAL_COST
        if contains(DARK_ACOLYTE_HEROES, heroName) then
            movCost = movCost * (1 - PARAM_WARLOCK_DARK_ACOLYTE_BASE_SAVING - PARAM_WARLOCK_DARK_ACOLYTE_PER_LEVEL_SAVING * GetHeroLevel(heroName))
        end
        local oldMov = GetHeroStat(heroName, 7)
        local oldMana = GetHeroStat(heroName, 8)
        if oldMov >= movCost then
            BlockGame()
            ChangeHeroStat(heroName, 8, 1e8)
            sleep(5)
            local newMana = GetHeroStat(heroName, 8)
            ShowFlyMessage({RAB_TXT.."DungeonDarkRitualFlyMessage.txt"; movement = movCost, mana = (newMana - oldMana)}, heroName, GetCurrentPlayer(), 5)
            ChangeHeroStat(heroName, 7, -movCost)
            g_tabDunegonUsedDarkRitual[drKey] = true
            sleep(5)
            UnblockGame()
        else
            MessageBox({RAB_TXT.."InsufficientMovementWarning.txt"; move1 = movCost, move2 = oldMov})
        end
    else
        MessageBox({RAB_TXT.."DungeonDarkRitualAlreadyUsed.txt"; darkritual = DUNGEON_DARK_RITUAL_TEXT})
    end
end

function _DungeonIrresistableKnowledge(heroName)
    BlockGame()

    local skillLevel = GetHeroSkillMastery(heroName, SKILL_INVOCATION)
    if skillLevel >= 1 then
        ShowFlyMessage({RAB_TXT.."DungeonIrresistableKnowledgeNoAward.txt"; skill = WALOCK_IRRESISTABLE_MAGIC_TEXT[1], knowledge = KNOWLEDGE_ATTRIBUTE_TEXT}, heroName, GetCurrentPlayer(), 5)
        sleep(3)
    end

    for i = 2, 4 do
        skillLevel = GetHeroSkillMastery(heroName, SKILL_INVOCATION)
        if skillLevel >= i then
            if g_tabDungeonIrresistableKnowledge[heroName..i] == true then
                ShowFlyMessage({RAB_TXT.."DungeonIrresistableKnowledgeAlready.txt"; skill = WALOCK_IRRESISTABLE_MAGIC_TEXT[i], knowledge = KNOWLEDGE_ATTRIBUTE_TEXT}, heroName, GetCurrentPlayer(), 5)
            else
                ShowFlyMessage({RAB_TXT.."DungeonIrresistableKnowledgeAwarded.txt"; skill = WALOCK_IRRESISTABLE_MAGIC_TEXT[i], knowledge = KNOWLEDGE_ATTRIBUTE_TEXT}, heroName, GetCurrentPlayer(), 5)
                ChangeHeroStat(heroName, 4, 1)
                g_tabDungeonIrresistableKnowledge[heroName..i] = true
            end
        else
            ShowFlyMessage({RAB_TXT.."DungeonIrresistableKnowledgeInsufficient.txt"; skill = WALOCK_IRRESISTABLE_MAGIC_TEXT[i]}, heroName, GetCurrentPlayer(), 5)
        end
        sleep(3)
    end

    UnblockGame()
end

function _DungeonCheckDestructiveSpells(heroName, spellLevel)
    if GetHeroSkillMastery(heroName, SKILL_INVOCATION) >= spellLevel then
        local spellToLearn = {}
        for i, spell in DESTRUCTIVE_SPELLS[spellLevel] do
            if not KnowHeroSpell(heroName, spell) then
                spellToLearn[length(spellToLearn)] = spell
            end
        end
        if length(spellToLearn) == 0 then
            ShowFlyMessage({RAB_TXT.."DungeonIrresistableSpellAlready.txt"; level = spellLevel}, heroName, GetCurrentPlayer(), 5)
            sleep(3)
        elseif length(spellToLearn) == length(DESTRUCTIVE_SPELLS[spellLevel]) then
            ShowFlyMessage({RAB_TXT.."DungeonIrresistableSpellNoAward.txt"; level = spellLevel}, heroName, GetCurrentPlayer(), 5)
            sleep(3)
        else
            for i, newSpell in spellToLearn do
                TeachHeroSpell(heroName, newSpell)
                ShowFlyMessage({RAB_TXT.."DungeonIrresistableSpellAwarded.txt"; level = spellLevel, spell = DESTRUCTIVE2TEXT[newSpell]}, heroName, GetCurrentPlayer(), 5)
                sleep(3)
            end
        end
    else
        ShowFlyMessage({RAB_TXT.."DungeonIrresistableSpellInsufficient.txt"; skill = WALOCK_IRRESISTABLE_MAGIC_TEXT[spellLevel], level = spellLevel}, heroName, GetCurrentPlayer(), 5)
        sleep(3)
    end
end

function _DungeonLearnDestructiveSpells(heroName)
    BlockGame()
    for i = 1, 3 do
        _DungeonCheckDestructiveSpells(heroName, i)
    end
    UnblockGame()
end

function _FortressAbilityCallback(cNum)
    if cNum == 1 then
        _FortressTeachRuneSpells(g_tabCallbackParams[1])
    elseif cNum == 2 then
        if not _checkMovementCondition(g_tabCallbackParams[1], PARAM_RUNEMAGE_WAR_MACHINE_VISIT_COST) then
            return
        end
        _forceHeroInteractWithObject(g_tabCallbackParams[1], MINI_WAR_MACHINE_FACTORY, nil)
    end
end

function _FortressTeachRuneSpells(heroName)
    local options = {}
    for i, spells in RUNE_SPELLS do
        local requirements = _getSpecialSpellsCost(i, TOWN_FORTRESS)
        for j, spellId in spells do
            options[length(options) + 1] = {RAB_TXT.."FortressRuneSpellTalkBoxOption.txt"; spell = RUNE2TEXT[spellId], tier = i,
                                            woodAmount = requirements[WOOD], wood = RESOURCE2TEXT[WOOD],
                                            oreAmount = requirements[ORE], ore = RESOURCE2TEXT[ORE],
                                            goldAmount = requirements[GOLD], gold = RESOURCE2TEXT[GOLD], }
        end
    end
    _PagedTalkBox(
        PORT_FORTRESS,
        RAB_TXT.."dummy2.txt",
        RAB_TXT.."FortressRuneSpellTalkBoxDescription.txt",
        RAB_TXT.."RABTalkBoxTitle.txt",
        "_FortressTeachRuneSpellsCallback", options)
end

function _FortressCheckHeroCanLearnSpell(heroName, spellId)
    local spellLevel= _getSpellTierById(spellId, RUNE_SPELLS)
    local runicLevel = GetHeroSkillMastery(heroName, HERO_SKILL_RUNELORE)
    if (ceil(spellLevel / 2) <= runicLevel) then
        return true
    else
        MessageBox({RAB_TXT.."FortressRuneSpellInsufficientSkill.txt"; skill = RUNEMAGE_SKILL_RUNELORE_TEXT[runicLevel], tier = spellLevel, spell = RUNE2TEXT[spellId]}, "")
        return nil
    end
end

function _FortressTeachRuneSpellsCallback(cNum)
    if cNum > 0 then
        local spellId = _cNumToSpellId(cNum, RUNE_SPELLS)
        local spellLevel = _getSpellTierById(spellId, RUNE_SPELLS)
        local heroName = g_tabCallbackParams[1]
        local resourceCost = _getSpecialSpellsCost(spellLevel, TOWN_FORTRESS)
        if not _checkSpellAlreadyLearnt(heroName, spellId, RUNE2TEXT[spellId]) then
            if _FortressCheckHeroCanLearnSpell(heroName, spellId) then
                if _currentPlayerResourceCheck(heroName, resourceCost) then
                    BlockGame()
                    TeachHeroSpell(heroName, spellId)
                    ShowFlyMessage({RAB_TXT.."FortressRuneSpellLearnt.txt"; tier = spellLevel, spell = RUNE2TEXT[spellId]}, heroName, GetCurrentPlayer(), 5)
                    sleep(2)
                    UnblockGame()
                end
            end
        end
    else
        RacialAbilityBoost(g_tabCallbackParams[1], CUSTOM_ABILITY_4)
    end
end

function _HavenCalculateTrainingReduction(heroName)
    local result = 1
    result  = result - PARAM_HAVEN_TRAINING_COST_RACIAL_REDUCTION[GetHeroSkillMastery(heroName, SKILL_TRAINING)]
    result = result - PARAM_HAVEN_TRAINING_COST_EXPERT_TRAINER_REDUCTION * GetHeroSkillMastery(heroName, PERK_EXPERT_TRAINER)
    result = result - _GetNumBuildingsInAllTowns(TOWN_HEAVEN, TOWN_BUILDING_SPECIAL_2, 1) * PARAM_HAVEN_TRAINING_COST_PER_SPECIAL2_REDUCTION
    if contains(SUZERAIN_HEROES, heroName) then
        result = result - ceil(GetHeroLevel(heroName) / PARAM_HAVEN_TRAINING_COST_SUZERAIN_LEVEL) * PARAM_HAVEN_TRAINING_COST_SUZERAIN_REDUCTION 
    end

    if result < 0 then
        result = 0
    end
    return result
end

function _HavenCalculateTrainingMul(creatureId)
    local result = PARAM_HAVEN_TRAINING_COST_BASE_MUL
    local buildingId = TOWN_BUILDING_DWELLING_1 + CREATURE2TIER[creatureId] - 1
    local buildingLevel = 1
    if CREATURE2GRADE[creatureId] > 0 then
        buildingLevel = 2
    end
    local buildingRace = CREATURE2TOWN[creatureId]
    if _GetBuildingLevelInAllTowns(buildingRace, buildingId) < buildingLevel then
        result = result * PARAM_HAVEN_TRAINING_COST_NO_BUILDING_MUL
    end
    return result
end

function _HavenCalculateTrainingMaxQuota()
    local result = PARAM_HAVEN_BASE_QUOTA
    result = result + _GetNumBuildingsInAllTowns(TOWN_HEAVEN, TOWN_BUILDING_SPECIAL_1, 1) * PARAM_HAVEN_SPECIAL1_QUOTA
    return result
end

function _HavenGenerateTrainingOption(heroName, slotId, slotInfo, trainedId, options, optionsData)
    local heroDiscount = _HavenCalculateTrainingReduction(heroName)
    local maxQuota = _HavenCalculateTrainingMaxQuota()

    if g_iHavenTrainingQuota < slotInfo[2] then
        options[length(options) + 1] = {RAB_TXT.."HavenSameRaceTrainingOptionInsufficientQuota.txt";
            slot_id = slotId + 1, creature_name = CREATURE2TEXT[slotInfo[1]],
            creature_count = slotInfo[2], remaining_quota = g_iHavenTrainingQuota}
        optionsData[length(options)] = {"no", options[length(options)]}
    else
        if trainedId == nil then
            trainedId = slotInfo[1]
            local creatureGrade = CREATURE2GRADE[slotInfo[1]]
            if creatureGrade > 0 then
                trainedId = CREATURE_UPGRADE2UNGRADED[slotInfo[1]]
                trainedId = TRAINING_MAPPING[trainedId]
                trainedId = CREATURE_UNGRADE2UPGRADED[creatureGrade][trainedId]
            else
                trainedId = TRAINING_MAPPING[trainedId]
            end
        end

        local creatureTier = CREATURE2TIER[trainedId]
        local maxTier = PARAM_HAVEN_TRAINING_CREATURE_LEVEL_LIMIT[GetHeroSkillMastery(heroName, SKILL_TRAINING)]

        if creatureTier > maxTier then
            options[length(options) + 1] = {RAB_TXT.."HavenSameRaceTrainingOptionInsufficientLevel.txt";
                                            slot_id = slotId + 1, creature_name1 = CREATURE2TEXT[slotInfo[1]],
                                            creature_name2 = CREATURE2TEXT[trainedId],
                                            creature_tier1 = creatureTier, creature_tier2 = maxTier}
            optionsData[length(options)] = {"no", options[length(options)]}
        else
            local creatureMul = _HavenCalculateTrainingMul(trainedId)
            local totalCost = round(CREATURE2COST[trainedId] * slotInfo[2] * creatureMul * heroDiscount)
            local totalGold = GetPlayerResource(GetCurrentPlayer(), GOLD)
            if totalGold < totalCost then
                options[length(options) + 1] = {RAB_TXT.."HavenSameRaceTrainingOptionInsufficientGold.txt";
                                                slot_id = slotId + 1, creature_name = CREATURE2TEXT[slotInfo[1]], creature_count = slotInfo[2],
                                                creature_name1 = CREATURE2TEXT[slotInfo[1]], creature_name2 = CREATURE2TEXT[trainedId], 
                                                training_cost = totalCost, remaining_gold = totalGold, gold = RESOURCE2TEXT[GOLD]}
                optionsData[length(options)] = {"no", options[length(options)]}
            else
                options[length(options) + 1] = {RAB_TXT.."HavenSameRaceTrainingOptionTrainable.txt";
                                                slot_id = slotId + 1, creature_name1 = CREATURE2TEXT[slotInfo[1]], creature_count = slotInfo[2],
                                                creature_name2 = CREATURE2TEXT[trainedId], training_cost = totalCost, gold = RESOURCE2TEXT[GOLD]}
                optionsData[length(options)] = {"yes", slotId, trainedId, totalCost}
            end
        end
    end
end

function _HavenGenerateTrainingTalkboxDescription(heroName)
    local heroDiscount = _HavenCalculateTrainingReduction(heroName)
    local maxQuota = _HavenCalculateTrainingMaxQuota()

    return {RAB_TXT.."HavenSameRaceTrainingDescription.txt";
            training_quota_remaining = g_iHavenTrainingQuota, training_quota_max = maxQuota,
            training_cost_reduction = round((1 - heroDiscount) * 100)}
end

function _HavenTrainingGetAllStartingUnit(creatureId)
    local result = {}
    local allHumanoids = {}
    local creatureTier = CREATURE2TIER[creatureId]
    local creatureRace = CREATURE2TOWN[creatureId]
    local creatureGrade = CREATURE2GRADE[creatureId]
    local creatureUngraded = creatureId
    if creatureGrade > 0 then
        creatureUngraded = CREATURE_UPGRADE2UNGRADED[creatureId]
    end

    for untrained, trained in TRAINING_MAPPING do
        local currRace = CREATURE2TOWN[untrained]
        if currRace == nil then
            currRace = CREATURE2TOWN[trained]
        end
        if allHumanoids[currRace] == nil then
            allHumanoids[currRace] = {}
        end
        if currRace ~= creatureRace then
            if allHumanoids[currRace][length(allHumanoids[currRace]) + 1] ~= nil then
                allHumanoids[currRace][length(allHumanoids[currRace]) + 1] = untrained
            end
            allHumanoids[currRace][length(allHumanoids[currRace]) + 1] = trained
        end
    end

    for i = TOWN_HEAVEN, TOWN_STRONGHOLD do
        if allHumanoids[i] ~= nil then
            local tierDiff = 9999
            local trainedId = CREATURE_UNKNOWN
            for j, humanoidId in allHumanoids[i] do
                local resultTier = CREATURE2TIER[humanoidId]
                if abs(resultTier - creatureTier) < tierDiff then
                    tierDiff = abs(resultTier - creatureTier)
                    trainedId = humanoidId
                end
            end
            if trainedId ~= CREATURE_UNKNOWN then
                if creatureGrade > 0 then
                    result[i] = CREATURE_UNGRADE2UPGRADED[creatureGrade][trainedId]
                else
                    result[i] = trainedId
                end
            end
        end
    end

    return result
end

function _HavenAbilityCallback(cNum)
    local heroName = g_tabCallbackParams[1]
    if cNum == 1 then
        MessageBox({RAB_TXT.."HavenTrainingMechanismDescription.txt";
            race = RACE2TEXT[TOWN_HEAVEN], class = CLASS2TEXT[TOWN_HEAVEN],
            training_basic_level = PARAM_HAVEN_TRAINING_CREATURE_LEVEL_LIMIT[1],
            training_advanced_level = PARAM_HAVEN_TRAINING_CREATURE_LEVEL_LIMIT[2],
            training_expert_level = PARAM_HAVEN_TRAINING_CREATURE_LEVEL_LIMIT[3],
            training_ultimate_level = PARAM_HAVEN_TRAINING_CREATURE_LEVEL_LIMIT[4],
            town_haven = RACE2TEXT[TOWN_HEAVEN], creature_peasant = CREATURE2TEXT[CREATURE_PEASANT],
            creature_archer = CREATURE2TEXT[CREATURE_ARCHER], creature_footman = CREATURE2TEXT[CREATURE_FOOTMAN],
            creature_priest = CREATURE2TEXT[CREATURE_PRIEST], creature_cavalier = CREATURE2TEXT[CREATURE_CAVALIER],
            town_sylvan = RACE2TEXT[TOWN_PRESERVE], creature_blade_juggler = CREATURE2TEXT[CREATURE_BLADE_JUGGLER],
            creature_wood_elf = CREATURE2TEXT[CREATURE_WOOD_ELF], creature_druid = CREATURE2TEXT[CREATURE_DRUID],
            town_academy = RACE2TEXT[TOWN_ACADEMY], creature_magi = CREATURE2TEXT[CREATURE_MAGI],
            town_dungeon = RACE2TEXT[TOWN_DUNGEON], creature_scout = CREATURE2TEXT[CREATURE_SCOUT],
            creature_witch = CREATURE2TEXT[CREATURE_WITCH], creature_rider = CREATURE2TEXT[CREATURE_RIDER],
            creature_matron = CREATURE2TEXT[CREATURE_MATRON],
            town_fortress = RACE2TEXT[TOWN_FORTRESS], creature_defender = CREATURE2TEXT[CREATURE_DEFENDER],
            creature_axe_fighter = CREATURE2TEXT[CREATURE_AXE_FIGHTER], creature_bear_rider = CREATURE2TEXT[CREATURE_BEAR_RIDER],
            creature_browler = CREATURE2TEXT[CREATURE_BROWLER], creature_rune_mage = CREATURE2TEXT[CREATURE_RUNE_MAGE],
            creature_thane = CREATURE2TEXT[CREATURE_THANE],
            town_stronghold = RACE2TEXT[TOWN_STRONGHOLD], 
            creature_orc_warrior = CREATURE2TEXT[CREATURE_ORC_WARRIOR], creature_shaman = CREATURE2TEXT[CREATURE_SHAMAN],
            creature_orcchief_butcher = CREATURE2TEXT[CREATURE_ORCCHIEF_BUTCHER],
            haven_special1 = HAVEN_SPECIAL1, haven_special2 = HAVEN_SPECIAL2,
            training_quota_base = PARAM_HAVEN_BASE_QUOTA, training_quota_per_town = PARAM_HAVEN_SPECIAL1_QUOTA,
            training_base_cost_coeff = PARAM_HAVEN_TRAINING_COST_BASE_MUL, training_missing_cost_coeff = PARAM_HAVEN_TRAINING_COST_NO_BUILDING_MUL,
            training_cost_reduction1 = round(PARAM_HAVEN_TRAINING_COST_RACIAL_REDUCTION[1] * 100),
            training_cost_reduction2 = round(PARAM_HAVEN_TRAINING_COST_RACIAL_REDUCTION[2] * 100),
            training_cost_reduction3 = round(PARAM_HAVEN_TRAINING_COST_RACIAL_REDUCTION[3] * 100),
            training_cost_reduction4 = round(PARAM_HAVEN_TRAINING_COST_RACIAL_REDUCTION[4] * 100),
            expert_trainer = HAVEN_EXPERT_TRAINER_TEXT,
            expert_trainer_reduction = round(PARAM_HAVEN_TRAINING_COST_EXPERT_TRAINER_REDUCTION * 100),
            training_cost_reduction_special2 = round(PARAM_HAVEN_TRAINING_COST_PER_SPECIAL2_REDUCTION * 100), })

    elseif cNum == 2 then
        local creatureSlots = _GetCreatureSlots(heroName)
        local options = {}
        local optionsData = {}
        for slotId, slotInfo in creatureSlots do
            if slotInfo[1] ~= 0 then
                if _isCreatureHumanoid(slotInfo[1]) then
                    if _isCreatureTrainable(slotInfo[1]) then
                        _HavenGenerateTrainingOption(heroName, slotId, slotInfo, nil, options, optionsData)
                    else
                        options[length(options) + 1] = {RAB_TXT.."HavenSameRaceTrainingOptionMaxed.txt";
                                                        slot_id = slotId + 1, creature_name = CREATURE2TEXT[slotInfo[1]]}
                        optionsData[length(options)] = {"no", options[length(options)]}
                    end
                else
                    options[length(options) + 1] = {RAB_TXT.."HavenSameRaceTrainingOptionUnTrainable.txt"; slot_id = slotId + 1, creature_name = CREATURE2TEXT[slotInfo[1]]}
                    optionsData[length(options)] = {"no", options[length(options)]}
                end
            end
        end

        g_tabCallbackParams[2] = optionsData
        _PagedTalkBox(
            PORT_HAVEN,
            RAB_TXT.."dummy2.txt",
            _HavenGenerateTrainingTalkboxDescription(heroName),
            RAB_TXT.."HavenSameRaceTrainingName.txt",
            "_HavenTrainingCallback", options)

    elseif cNum == 3 then
        local creatureSlots = _GetCreatureSlots(heroName)
        local options = {}
        local optionsData = {}
        for slotId, slotInfo in creatureSlots do
            if slotInfo[1] ~= 0 then
                if _isCreatureHumanoid(slotInfo[1]) then
                    if g_iHavenTrainingQuota < slotInfo[2] then
                        options[length(options) + 1] = {RAB_TXT.."HavenSameRaceTrainingOptionInsufficientQuota.txt";
                            slot_id = slotId + 1, creature_name = CREATURE2TEXT[slotInfo[1]],
                            creature_count = slotInfo[2], remaining_quota = g_iHavenTrainingQuota}
                        optionsData[length(options)] = {"no", options[length(options)]}
                    else
                        options[length(options) + 1] = {RAB_TXT.."HavenCrossRaceTrainingOption.txt";
                            slot_id = slotId + 1, creature_name = CREATURE2TEXT[slotInfo[1]], creature_count = slotInfo[2]}
                        optionsData[length(options)] = {"yes", slotId, slotInfo}
                    end
                else
                    options[length(options) + 1] = {RAB_TXT.."HavenSameRaceTrainingOptionUnTrainable.txt"; slot_id = slotId + 1, creature_name = CREATURE2TEXT[slotInfo[1]]}
                    optionsData[length(options)] = {"no", options[length(options)]}
                end
            end
        end

        g_tabCallbackParams[2] = optionsData
        _PagedTalkBox(
            PORT_HAVEN,
            RAB_TXT.."dummy2.txt",
            _HavenGenerateTrainingTalkboxDescription(heroName),
            RAB_TXT.."HavenCrossRaceTrainingName.txt",
            "_HavenCrossRaceTrainingCallback", options)
    elseif cNum == 4 then
        SetObjectDwellingCreatures(MINI_TOWN[TOWN_HEAVEN], CREATURE_ARCHER, 0)
        if _buildingConditionCheck(MINI_TOWN[TOWN_HEAVEN], "TOWN_HEAVEN", TOWN_BUILDING_DWELLING_2, 2, HAVEN_DWELLING_2_TEXT, RACE2TEXT[TOWN_HEAVEN]) == true then
            _forceHeroInteractWithObject(g_tabCallbackParams[1], MINI_TOWN[TOWN_HEAVEN], true)
        end
    end
end

function _HavenCrossRaceTrainingCallback(cNum)
    local heroName = g_tabCallbackParams[1]
    if cNum > 0 then
        local optionsData = g_tabCallbackParams[2]
        if optionsData[cNum][1] == "no" then
            MessageBox(optionsData[cNum][2])
        else
            local slotId = optionsData[cNum][2]
            local slotInfo = optionsData[cNum][3]
            local crossraceOptions = _HavenTrainingGetAllStartingUnit(slotInfo[1])
            local options = {}
            local optionsData = {}
            for crossTown, crossCreature in crossraceOptions do
                _HavenGenerateTrainingOption(heroName, slotId, slotInfo, crossCreature, options, optionsData)
            end

            g_tabCallbackParams[2] = optionsData
            _PagedTalkBox(
                PORT_HAVEN,
                RAB_TXT.."dummy2.txt",
                _HavenGenerateTrainingTalkboxDescription(heroName),
                RAB_TXT.."HavenCrossRaceTrainingName.txt",
                "_HavenTrainingCallback", options)
        end
    else
        RacialAbilityBoost(heroName, CUSTOM_ABILITY_4)
    end
end

function _HavenTrainingCallback(cNum)
    local heroName = g_tabCallbackParams[1]
    if cNum > 0 then
        local optionsData = g_tabCallbackParams[2]
        if optionsData[cNum][1] == "no" then
            MessageBox(optionsData[cNum][2])
        else
            BlockGame()
            local slotId = optionsData[cNum][2]
            local trainedId = optionsData[cNum][3]
            local totalCost = optionsData[cNum][4]
            local heroSlots = _GetCreatureSlots(heroName)
            ShowFlyMessage({RAB_TXT.."HavenTrainingFlyMessage.txt";
                            creature_count = heroSlots[slotId][2], creature_name1 = CREATURE2TEXT[heroSlots[slotId][1]], 
                            creature_name2 = CREATURE2TEXT[trainedId],},
                           heroName, GetCurrentPlayer(), 5)
            heroSlots[slotId][1] = trainedId
            g_iHavenTrainingQuota = g_iHavenTrainingQuota - heroSlots[slotId][2]
            _SetCreatureSlots(heroName, heroSlots)
            SetPlayerResource(GetCurrentPlayer(), GOLD, GetPlayerResource(GetCurrentPlayer(), GOLD) - totalCost)
            ShowFlyMessage({RAB_TXT.."LostResourceFlyMessage.txt";
                            amount = totalCost, resource = RESOURCE2TEXT[GOLD]},
                           heroName, GetCurrentPlayer(), 5)
            UnblockGame()
        end
    else
        RacialAbilityBoost(heroName, CUSTOM_ABILITY_4)
    end
end

function _InfernoGetMaxRecallSummonDay()
    local result = _getMaxValue(PARAM_DEMONLORD_SUMMON_GATED_BASE_DAYS + PARAM_DEMONLORD_SUMMON_GATED_DAYS_PER_TIER * 7,
                                PARAM_DEMONLORD_RECALL_DEAD_BASE_DAYS + PARAM_DEMONLORD_RECALL_DEAD_DAYS_PER_TIER * 7)
    return result
end

function _InfernoAbilityCallback(cNum)
    if cNum == 1 then
        MessageBox({RAB_TXT.."InfernoRecallSummonMechanismDescription.txt";
            race = RACE2TEXT[TOWN_INFERNO], class = CLASS2TEXT[TOWN_INFERNO], miniRace = RAB_TXT.."MiniInferno.txt",
            skill1 = DEMONLORD_SKILL_GATING_TEXT[1], skill2 = DEMONLORD_SKILL_GATING_TEXT[2],
            skill3 = DEMONLORD_SKILL_GATING_TEXT[3], skill4 = DEMONLORD_SKILL_GATING_TEXT[4],
            skill1_value1 = round(PARAM_DEMONLORD_RECALL_DEAD_RACIAL_RATIO[1] * 100),
            skill1_value2 = PARAM_DEMONLORD_RECALL_DEAD_BASE_DAYS, skill1_value3 = PARAM_DEMONLORD_RECALL_DEAD_DAYS_PER_TIER,
            skill1_value4 = round(PARAM_DEMONLORD_SUMMON_GATED_RACIAL_RATIO[1] * 100),
            skill1_value5 = PARAM_DEMONLORD_SUMMON_GATED_BASE_DAYS, skill1_value6 = PARAM_DEMONLORD_SUMMON_GATED_DAYS_PER_TIER,
            skill1_value7 = PARAM_DEMONLORD_CREATURE_EXPIRE_DAYS,
            skill2_value1 = round(PARAM_DEMONLORD_RECALL_DEAD_RACIAL_RATIO[2] * 100),
            skill2_value2 = round(PARAM_DEMONLORD_RECALL_DEAD_RACIAL_DISCOUNT[2] * 100), 
            skill2_value3 = round(PARAM_DEMONLORD_SUMMON_GATED_RACIAL_RATIO[2] * 100),
            skill2_value4 = round(PARAM_DEMONLORD_RECALL_DEAD_RACIAL_DISCOUNT[2] * 100),
            skill3_value1 = round(PARAM_DEMONLORD_RECALL_DEAD_RACIAL_RATIO[3] * 100),
            skill3_value2 = round(PARAM_DEMONLORD_RECALL_DEAD_RACIAL_DISCOUNT[3] * 100), 
            skill3_value3 = round(PARAM_DEMONLORD_SUMMON_GATED_RACIAL_RATIO[3] * 100),
            skill3_value4 = round(PARAM_DEMONLORD_RECALL_DEAD_RACIAL_DISCOUNT[3] * 100),
            skill4_value1 = round(PARAM_DEMONLORD_RECALL_DEAD_RACIAL_RATIO[4] * 100),
            skill4_value2 = round(PARAM_DEMONLORD_RECALL_DEAD_RACIAL_DISCOUNT[4] * 100), 
            skill4_value3 = round(PARAM_DEMONLORD_SUMMON_GATED_RACIAL_RATIO[4] * 100),
            skill4_value4 = round(PARAM_DEMONLORD_RECALL_DEAD_RACIAL_DISCOUNT[4] * 100), })

    elseif cNum == 2 then
        local maxDayNo = _InfernoGetMaxRecallSummonDay()
        local cmd = "MessageBox({RAB_TXT..\"InfernoRecallSummonMainSummary.txt\"; "
        local playerId = GetCurrentPlayer()
        for dayNo = -PARAM_DEMONLORD_CREATURE_EXPIRE_DAYS, maxDayNo do
            local dayString = "text"..(dayNo + PARAM_DEMONLORD_CREATURE_EXPIRE_DAYS).." = {RAB_TXT..\"InfernoRecallSummonSummaryEntry.txt\"; elementDay = "
            if dayNo > 0 then
                dayString = dayString.."{RAB_TXT..\"InfernoRecallSummonSummaryEntryDay1.txt\"; dayNo = "..abs(dayNo).."}, "
            elseif dayNo < 0 then
                dayString = dayString.."{RAB_TXT..\"InfernoRecallSummonSummaryEntryDay2.txt\"; dayNo = "..abs(PARAM_DEMONLORD_CREATURE_EXPIRE_DAYS + dayNo + 1).."}, "
            else
                dayString = dayString.."RAB_TXT..\"InfernoRecallSummonSummaryEntryDay3.txt\", "
            end
            local shouldAdd = 0
            for creatureId, creatureAmount in g_tabInfernoCreatureInfos[playerId][dayNo] do
                if abs(creatureAmount) > abs(RAB_ZERO)  then
                    shouldAdd = 1
                    local creatureTier = round((creatureId - CREATURE_FAMILIAR) / 2 + 1)
                    dayString = dayString.."creature"..creatureTier.." = {RAB_TXT..\"InfernoRecallSummonSummaryEntryCreature.txt\"; "
                    dayString = dayString.."creatureAmount = "..creatureAmount..", creatureName=CREATURE2TEXT["..creatureId.."], }, "
                end
            end
            if shouldAdd > 0 then
                dayString = dayString.."},"
                cmd = cmd..dayString
            end
        end
        cmd = cmd.."})"
        parse(cmd)()
    elseif cNum == 3 then
        -- collate all purchasable creatures
        if not IsObjectExists(MINI_TOWN[TOWN_INFERNO]) then
            MessageBox(RAB_TXT.."MissingObjectWarning.txt")
            return nil
        end
        BlockGame()
        local dwellingCreaturesBefore = {}
        local playerId = GetCurrentPlayer()
        for dayNo = -PARAM_DEMONLORD_CREATURE_EXPIRE_DAYS, 0 do
            for creatureId, creatureAmount in g_tabInfernoCreatureInfos[playerId][dayNo] do
                if dwellingCreaturesBefore[creatureId] == nil then
                    dwellingCreaturesBefore[creatureId] = 0.0
                end
                dwellingCreaturesBefore[creatureId] = dwellingCreaturesBefore[creatureId] + creatureAmount
            end
        end
        for creatureId, creatureAmount in dwellingCreaturesBefore do
            SetObjectDwellingCreatures(MINI_TOWN[TOWN_INFERNO], creatureId, creatureAmount)
        end
        sleep(1)
        for creatureId, creatureAmount in dwellingCreaturesBefore do
            dwellingCreaturesBefore[creatureId] = GetObjectDwellingCreatures(MINI_TOWN[TOWN_INFERNO], creatureId)
        end
        UnblockGame()
        if _checkMovementCondition(g_tabCallbackParams[1], PARAM_DEMONLOAD_RECRUITMENT_COST) then
            _forceHeroInteractWithObject(g_tabCallbackParams[1], MINI_TOWN[TOWN_INFERNO], true)
        end
        BlockGame()
        local dwellingCreaturesDiff = {}
        for creatureId, creatureAmount in dwellingCreaturesBefore do
            dwellingCreaturesDiff[creatureId] = dwellingCreaturesBefore[creatureId] - GetObjectDwellingCreatures(MINI_TOWN[TOWN_INFERNO], creatureId)
        end

        for dayNo = -PARAM_DEMONLORD_CREATURE_EXPIRE_DAYS, 0 do
            for creatureId = CREATURE_FAMILIAR, CREATURE_DEVIL, 2 do
                if abs(dwellingCreaturesDiff[creatureId]) >= abs(RAB_ZERO) then
                    if dwellingCreaturesDiff[creatureId] >= g_tabInfernoCreatureInfos[playerId][dayNo][creatureId] then
                        dwellingCreaturesDiff[creatureId] = dwellingCreaturesDiff[creatureId] - g_tabInfernoCreatureInfos[playerId][dayNo][creatureId]
                        g_tabInfernoCreatureInfos[playerId][dayNo][creatureId] = 0
                    else
                        g_tabInfernoCreatureInfos[playerId][dayNo][creatureId] = g_tabInfernoCreatureInfos[playerId][dayNo][creatureId] - dwellingCreaturesDiff[creatureId]
                        dwellingCreaturesDiff[creatureId] = 0
                    end
                end
            end
        end

        for creatureId, creatureAmount in dwellingCreaturesBefore do
            SetObjectDwellingCreatures(MINI_TOWN[TOWN_INFERNO], creatureId, 0)
        end
        sleep(1)
        UnblockGame()
    elseif cNum == 4 then
        local QuestionBoxString = "InfernoRecallSummonShowFlyMessageQuestionOff.txt"
        local switchString = "Off.txt"
        if GetGameVar(RAB_COMBAT_GATING_SUFFIX.."SupressFlyMessage") == "" then
            QuestionBoxString = "InfernoRecallSummonShowFlyMessageQuestionOn.txt"
            switchString = "On.txt"
        end
        QuestionBox({RAB_TXT..QuestionBoxString; class=CLASS2TEXT[TOWN_INFERNO], switch = RAB_TXT..switchString}, 
                    "_InfernoShowFlyMessageConfigYes", "_InfernoShowFlyMessageConfigNo")
    end
end

function _InfernoShowFlyMessageConfigYes()
    SetGameVar(RAB_COMBAT_GATING_SUFFIX.."SupressFlyMessage", "")
end

function _InfernoShowFlyMessageConfigNo()
    SetGameVar(RAB_COMBAT_GATING_SUFFIX.."SupressFlyMessage", "Yes")
end

function _PreserveAbilityCallback(cNum)
    if cNum == 1 then  -- Set favored enemies
        if not _checkMovementCondition(g_tabCallbackParams[1], PARAM_RANGER_SET_FAVORED_ENEMY_COST) then
            return
        end
        local drKey = g_tabCallbackParams[1]..GetDate(ABSOLUTE_DAY)
        if g_tabPreserveUsedSettingEnemy[drKey] == nil then
            if _forceHeroInteractWithObject(g_tabCallbackParams[1], MINI_TOWN[TOWN_PRESERVE], true) == true then
                g_tabPreserveUsedSettingEnemy[drKey] = true
            end
        else
            MessageBox({RAB_TXT.."DailyLimitCheckFailure.txt"; times = 1, days = 1, limit = 1}, "")
        end
    elseif cNum == 2 then -- Get favored enemies
        if not _checkMovementCondition(g_tabCallbackParams[1], PARAM_RANGER_GET_FAVORED_ENEMY_COST) then
            return
        end
        _PreserveRacialBoostGetEnemy(g_tabCallbackParams[1])
    end
end

function _PreserveRacialBoostGetEnemy(heroName) 
    local options = {}
    for i, townText in RACE2TEXT do
        options[i + 1] = townText
    end
    g_tabCallbackParams[1] = heroName
    _PagedTalkBox(
        PORT_SYLVAN,
        RAB_TXT.."dummy2.txt",
        RAB_TXT.."PreserveGetEnemySelectRaceTalkBoxDescription.txt",
        RAB_TXT.."PreserveGetEnemySelectRaceTalkBoxName.txt",
        "_PreserveRacialBoostGetEnemySelectRaceCallback", options)
end

function _PreserveRacialBoostGetEnemySelectRaceCallback(cNum)
    if cNum > 0 then
        local options = {}
        g_tabCallbackParams[2] = cNum - 1
        for i, creaturePair in AVENGERS_ENEMY_SLOTS[g_tabCallbackParams[2]] do
            if g_tabCallbackParams[2] == TOWN_NEUTRAL then
                options[i] = {RAB_TXT.."PreserveGetEnemySelectTierTalkBoxOptionType2.txt";
                              creature = CREATURE2TEXT[creaturePair[1]],
                              growth = creaturePair[2]}
            else
                options[i] = {RAB_TXT.."PreserveGetEnemySelectTierTalkBoxOptionType1.txt";
                              tier = i,
                              creature = CREATURE2TEXT[creaturePair[1]], 
                              growth = creaturePair[2]}
            end
        end
        _PagedTalkBox(
            PORT_SYLVAN,
            RAB_TXT.."dummy.txt",
            {RAB_TXT.."PreserveGetEnemySelectTierTalkBoxDescription.txt"; race = RACE2TEXT[g_tabCallbackParams[2]]},
            RAB_TXT.."PreserveGetEnemySelectTierTalkBoxName.txt",
            "_PreserveRacialBoostGetEnemySelectTierCallback", options)
    else
        RacialAbilityBoost(g_tabCallbackParams[1], CUSTOM_ABILITY_4)
    end
end

function _PreserveRacialBoostGetEnemySelectTierCallback(cNum)
    if cNum > 0 then
        local heroName = g_tabCallbackParams[1]
        local race = g_tabCallbackParams[2]
        StartCombat(heroName, nil, 
                    1, AVENGERS_ENEMY_SLOTS[race][cNum][1], AVENGERS_ENEMY_SLOTS[race][cNum][2] * 2,
                    nil, "", RACE2COMBATARENA[race])
    else
        _PreserveRacialBoostGetEnemy(g_tabCallbackParams[1])
    end
end

function _StrongholdAbilityCallback(cNum)
    if cNum == 1 then
        _StrongholdTeachWarcries(g_tabCallbackParams[1])
    elseif cNum == 2 then
        _StrongholdUseWalksHut(g_tabCallbackParams[1])
    elseif cNum == 3 then
        _StrongholdLearnSkill(g_tabCallbackParams[1])
    end
end

function _StrongholdTeachWarcries(heroName)
    local options = {}
    for i, spells in WARCRY_SPELLS do
        local requirements = _getSpecialSpellsCost(i, TOWN_STRONGHOLD)
        for j, spellId in spells do
            options[length(options) + 1] = {RAB_TXT.."StrongholdWarcryTalkBoxOption.txt"; spell = WARCRY2TEXT[spellId], tier = i,
                                            woodoreAmount = requirements[WOOD], rareAmount = requirements[CRYSTAL],
                                            goldAmount = requirements[GOLD], gold = RESOURCE2TEXT[GOLD], }
        end
    end
    _PagedTalkBox(
        PORT_STRONGHOLD,
        RAB_TXT.."dummy2.txt",
        RAB_TXT.."StrongholdWarcryTalkBoxDescription.txt",
        RAB_TXT.."RABTalkBoxTitle.txt",
        "_StrongholdTeachWarcriesCallback", options)
end

function _StrongholdCheckHeroCanLearnSpell(heroName, spellId)
    local spellLevel= _getSpellTierById(spellId, WARCRY_SPELLS)
    local heroLevel = GetHeroLevel(heroName)
    local requiredLevel = (spellLevel - 1) * 5 + 1
    if requiredLevel <= 1 then
        requiredLevel = 2
    end

    if heroLevel >= requiredLevel then
        return true
    else
        MessageBox({RAB_TXT.."StrongholdWarcryInsufficientLevel.txt"; tier = spellLevel, spell = WARCRY2TEXT[spellId], currLevel=heroLevel, minLevel = requiredLevel}, "")
        return nil
    end
end

function _StrongholdTeachWarcriesCallback(cNum)
    if cNum > 0 then
        local spellId = _cNumToSpellId(cNum, WARCRY_SPELLS)
        local spellLevel = _getSpellTierById(spellId, WARCRY_SPELLS)
        local heroName = g_tabCallbackParams[1]
        local resourceCost = _getSpecialSpellsCost(spellLevel, TOWN_STRONGHOLD)
        if not _checkSpellAlreadyLearnt(heroName, spellId, WARCRY2TEXT[spellId]) then
            if _StrongholdCheckHeroCanLearnSpell(heroName, spellId) then
                if _currentPlayerResourceCheck(heroName, resourceCost) then
                    BlockGame()
                    TeachHeroSpell(heroName, spellId)
                    ShowFlyMessage({RAB_TXT.."StrongholdWarcryLearnt.txt"; tier = spellLevel, spell = WARCRY2TEXT[spellId]}, heroName, GetCurrentPlayer(), 5)
                    sleep(2)
                    UnblockGame()
                end
            end
        end
    else
        RacialAbilityBoost(g_tabCallbackParams[1], CUSTOM_ABILITY_4)
    end
end

function _StrongholdUseWalksHut(heroName)
    if not _checkMovementCondition(heroName, PARAM_STRONGHOLD_WALKERS_HUT_COST) then
        return
    end

    local drKey = heroName..GetDate(ABSOLUTE_DAY)
    if g_tabStrongholdUsedWalksHut[drKey] == nil then
        if _forceHeroInteractWithObject(heroName, MINI_TOWN[TOWN_STRONGHOLD], true) == true then
            g_tabStrongholdUsedWalksHut[drKey] = true
        end
    else
        MessageBox({RAB_TXT.."DailyLimitCheckFailure.txt"; times = 1, days = 1, limit = 1}, "")
    end
end

function _StrongholdLearnSkill(heroName)
    local options = {}
    local skillMatrix = {}
    local skills = {[1] = HERO_SKILL_VOICE, [2] = HERO_SKILL_BARBARIAN_LEARNING, [3] = HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC,
                    [4] = HERO_SKILL_SHATTER_DARK_MAGIC, [5] = HERO_SKILL_SHATTER_LIGHT_MAGIC, [6] = HERO_SKILL_SHATTER_SUMMONING_MAGIC, }

    local talkBoxDescription = {RAB_TXT.."StrongholdLearnSkillsTalkBoxDescription.txt"; race = RACE2TEXT[TOWN_STRONGHOLD], class = CLASS2TEXT[TOWN_STRONGHOLD]}
    if g_tabStrongholdEnlightenmentShoutLearnt[heroName] == true and g_tabStrongholdShatterMagicLearnt[heroName] == nil then
        talkBoxDescription = {RAB_TXT.."StrongholdLearnSkillsTalkBoxDescriptionType1.txt"; race = RACE2TEXT[TOWN_STRONGHOLD], class = CLASS2TEXT[TOWN_STRONGHOLD]}
    elseif g_tabStrongholdEnlightenmentShoutLearnt[heroName] == nil and g_tabStrongholdShatterMagicLearnt[heroName] == true then
        talkBoxDescription = {RAB_TXT.."StrongholdLearnSkillsTalkBoxDescriptionType2.txt"; race = RACE2TEXT[TOWN_STRONGHOLD], class = CLASS2TEXT[TOWN_STRONGHOLD]}
    elseif g_tabStrongholdEnlightenmentShoutLearnt[heroName] == true and g_tabStrongholdShatterMagicLearnt[heroName] == true then
        MessageBox(RAB_TXT.."StrongholdLearnSkillsAlready3.txt", "")
        return
    end

    for i, skillId in skills do
        skillLevel = GetHeroSkillMastery(heroName, skillId)
        if skillLevel >= 3 then
            options[i] = {RAB_TXT.."StrongholdLearnSkillsInvalidOption.txt"; skill = BARBARIAN_SKILL_TEXT[skillId][3]}
        else
            options[i] = {RAB_TXT.."StrongholdLearnSkillsValidOption.txt"; skill = BARBARIAN_SKILL_TEXT[skillId][skillLevel + 1]}
        end
        skillMatrix[i] = {["id"] = skillId, ["level"] = skillLevel, }
    end

    g_tabCallbackParams[1] = heroName
    g_tabCallbackParams[2] = skillMatrix

    _PagedTalkBox(
        PORT_STRONGHOLD,
        RAB_TXT.."dummy2.txt",
        talkBoxDescription,
        RAB_TXT.."RABTalkBoxTitle.txt",
        "_StrongholdLearnSkillCallback", options)
end

function _StrongholdLearnSkillCallback(cNum)
    local heroName = g_tabCallbackParams[1]
    if cNum >= 1 then
        local skillMatrix = g_tabCallbackParams[2]
        local skillId = skillMatrix[cNum]["id"]
        local skillLevel = skillMatrix[cNum]["level"]
        local numMainSkills = _getHeroNumMainSkillLearnt(heroName)

        local enlightenmentOrShout = {HERO_SKILL_BARBARIAN_LEARNING, HERO_SKILL_VOICE}
        local shatterMagic = {HERO_SKILL_SHATTER_DARK_MAGIC, HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC,
                              HERO_SKILL_SHATTER_LIGHT_MAGIC, HERO_SKILL_SHATTER_SUMMONING_MAGIC}

        if skillLevel >= 3 then
            MessageBox({RAB_TXT.."StrongholdLearnSkillsInvalidOption.txt"; skill = BARBARIAN_SKILL_TEXT[skillId][3]}, "")
            return
        end

        if skillLevel == 0 and numMainSkills >= 6 then
            MessageBox(RAB_TXT.."StrongholdLearnSkillsNoSlots.txt", "")
            return
        end

        if contains(enlightenmentOrShout, skillId) then
            if g_tabStrongholdEnlightenmentShoutLearnt[heroName] == true then
                MessageBox(RAB_TXT.."StrongholdLearnSkillsAlready1.txt", "")
                return
            else
                g_tabStrongholdEnlightenmentShoutLearnt[heroName] = true
            end
        end

        if contains(shatterMagic, skillId) then
            if g_tabStrongholdShatterMagicLearnt[heroName] == true then
                MessageBox(RAB_TXT.."StrongholdLearnSkillsAlready2.txt", "")
                return
            else
                g_tabStrongholdShatterMagicLearnt[heroName] = true
            end
        end

        BlockGame()
        GiveHeroSkill(heroName, skillId)
        ShowFlyMessage({RAB_TXT.."StrongholdLearnSkillsFlyMessage.txt"; skill = BARBARIAN_SKILL_TEXT[skillId][skillLevel + 1]},
                       heroName, GetCurrentPlayer(), 5)
        sleep(3)
        UnblockGame()

    else
        RacialAbilityBoost(heroName, CUSTOM_ABILITY_4)
    end
end

function _rab_monitoring_thread()
    sleep(1)
    --initialize Inferno creature tracking matrix
    local maxDayNo = _InfernoGetMaxRecallSummonDay()
    for playerId = PLAYER_1, PLAYER_8 do
        if GetPlayerState(playerId) == PLAYER_ACTIVE and IsAIPlayer(playerId) == 0 then
            g_tabInfernoCreatureInfos[playerId] = {}
            for dayNo = -PARAM_DEMONLORD_CREATURE_EXPIRE_DAYS, maxDayNo do
                g_tabInfernoCreatureInfos[playerId][dayNo] = {}
                for creatureId = CREATURE_FAMILIAR, CREATURE_DEVIL, 2 do
                    g_tabInfernoCreatureInfos[playerId][dayNo][creatureId] = 0
                end
            end
        end
    end


    while true do
        -- Accumulate Inferno creature counts
        for sideId, sideString in RAB_COMBAT_GATING_SIDE2STRING do
            local varName = RAB_COMBAT_GATING_SUFFIX..sideString.."Hero"
            local heroName = GetGameVar(varName)
            if heroName ~= "" and IsHeroAlive(heroName) then
                BlockGame()
                local playerId = _getHeroPlayer(heroName)
                if IsAIPlayer(playerId) == 0 and _GetHeroRace(heroName) == TOWN_INFERNO then
                    local gatingLevel = GetHeroSkillMastery(heroName, SKILL_GATING)
                    local countDownDays = 0
                    for realFakeId, realFakeString in RAB_COMBAT_GATING_REAL_FAKE do
                        for creatureId = CREATURE_FAMILIAR, CREATURE_DEVIL, 2 do
                            local creatureTier = (creatureId - CREATURE_FAMILIAR) / 2 + 1
                            if realFakeString == "Real" then
                                countDownDays = PARAM_DEMONLORD_RECALL_DEAD_BASE_DAYS + creatureTier * PARAM_DEMONLORD_RECALL_DEAD_DAYS_PER_TIER
                                countDownDays = countDownDays * PARAM_DEMONLORD_RECALL_DEAD_RACIAL_DISCOUNT[gatingLevel]
                            else
                                countDownDays = PARAM_DEMONLORD_SUMMON_GATED_BASE_DAYS + creatureTier * PARAM_DEMONLORD_SUMMON_GATED_DAYS_PER_TIER
                                countDownDays = countDownDays * PARAM_DEMONLORD_SUMMON_GATED_RACIAL_DISCOUNT[gatingLevel]
                            end
                            countDownDays = round(countDownDays)

                            local combatAmount = GetGameVar(RAB_COMBAT_GATING_SUFFIX..sideString..realFakeString..creatureId)
                            if combatAmount == "" then
                                combatAmount = 0
                            else
                                combatAmount = combatAmount + 0
                            end

                            SetGameVar(RAB_COMBAT_GATING_SUFFIX..sideString..realFakeString..creatureId, "")
                            if realFakeString == "Real" then
                                combatAmount = combatAmount * PARAM_DEMONLORD_RECALL_DEAD_RACIAL_RATIO[gatingLevel]
                                if combatAmount > 0 and GetGameVar(RAB_COMBAT_GATING_SUFFIX.."SupressFlyMessage") == "" then
                                    ShowFlyMessage({RAB_TXT.."InfernoRecallSummonRealFlyMessage.txt"; amount = combatAmount, creatureName = CREATURE2TEXT[creatureId], days=countDownDays}, heroName, GetCurrentPlayer(), 5)
                                    sleep(2)
                                end
                            else
                                combatAmount = combatAmount * PARAM_DEMONLORD_SUMMON_GATED_RACIAL_RATIO[gatingLevel]
                                if combatAmount > 0 and GetGameVar(RAB_COMBAT_GATING_SUFFIX.."SupressFlyMessage") == "" then
                                    ShowFlyMessage({RAB_TXT.."InfernoRecallSummonFakeFlyMessage.txt"; amount = combatAmount, creatureName = CREATURE2TEXT[creatureId], days=countDownDays}, heroName, GetCurrentPlayer(), 5)
                                    sleep(2)
                                end
                            end
                            g_tabInfernoCreatureInfos[playerId][countDownDays][creatureId] = g_tabInfernoCreatureInfos[playerId][countDownDays][creatureId] + combatAmount
                        end
                    end
                end
                SetGameVar(varName, "")
                UnblockGame()
            end
        end

        -- Shift creature in days
        local today = GetDate(ABSOLUTE_DAY)
        if today > g_iToday then
            BlockGame()
            -- Do inferno creature day shifts
            local playerId = GetCurrentPlayer()
            for dayNo = -PARAM_DEMONLORD_CREATURE_EXPIRE_DAYS, maxDayNo - 1 do
                for creatureId = CREATURE_FAMILIAR, CREATURE_DEVIL, 2 do
                    g_tabInfernoCreatureInfos[playerId][dayNo][creatureId] = g_tabInfernoCreatureInfos[playerId][dayNo + 1][creatureId]
                end
            end
            for creatureId = CREATURE_FAMILIAR, CREATURE_DEVIL, 2 do
                g_tabInfernoCreatureInfos[playerId][maxDayNo][creatureId] = 0
            end

            --   Accumulate decimal point from the past day to today
            for creatureId, creatureAmount in g_tabInfernoCreatureInfos[playerId][-1] do
                if abs(creatureAmount) > abs(RAB_ZERO) then
                    local decimalPart = frac(creatureAmount)
                    g_tabInfernoCreatureInfos[playerId][0][creatureId] = g_tabInfernoCreatureInfos[playerId][0][creatureId] + decimalPart
                    g_tabInfernoCreatureInfos[playerId][-1][creatureId] = intg(creatureAmount)
                end
            end

            -- Accumulate Haven training quota each Monday
            if GetDate(DAY_OF_WEEK) == 1 then
                g_iHavenTrainingQuota = g_iHavenTrainingQuota + _HavenCalculateTrainingMaxQuota()
            end

            -- Move ahead
            g_iToday = today
            UnblockGame()
        end

        -- Check Haven Hero Skills
        local playerId = GetCurrentPlayer()
        if IsAIPlayer(playerId) == 0 then
            local heroes = GetPlayerHeroes(playerId)
            for heroIndex, heroName in heroes do
                if _GetHeroRace(heroName) == TOWN_HEAVEN then
                    SetGameVar("RABHavenHero"..heroName.."TrainingLevel", GetHeroSkillMastery(heroName, SKILL_TRAINING))
                    SetGameVar("RABHavenHero"..heroName.."ExpertTrainer", GetHeroSkillMastery(heroName, PERK_EXPERT_TRAINER))
                    SetGameVar("RABHavenHero"..heroName.."Pariah", GetHeroSkillMastery(heroName, KNIGHT_FEAT_PARIAH))
                end
            end
        end

        sleep(1)
    end
end

function _rab_other_initialization()
    for spellId, spellString in ABILITY2STRING do
        g_tabAcademySpellsRemaining[spellId] = {}
        g_tabAcademySpellsRemaining[spellId]["Wand"] = MAX_WIZARD_SPELLS_PER_HAND
        g_tabAcademySpellsRemaining[spellId]["Scroll"] = MAX_WIZARD_SPELLS_PER_HAND
        g_tabAcademySpellsHeroBoughtSpell[spellId] = {}
    end
    g_iHavenTrainingQuota = PARAM_HAVEN_BASE_QUOTA
end

function _rab_hireHero(heroName)
    if STACK_SPLIT_LOADED == true then
        ControlHeroCustomAbility(heroName, CUSTOM_ABILITY_3, CUSTOM_ABILITY_ENABLED)
    end
    ControlHeroCustomAbility(heroName, CUSTOM_ABILITY_4, CUSTOM_ABILITY_ENABLED)
end

function _rab_loseHero(heroName)
    if STACK_SPLIT_LOADED == true then
        ControlHeroCustomAbility(heroName, CUSTOM_ABILITY_3, CUSTOM_ABILITY_NOT_PRESENT)
    end
    ControlHeroCustomAbility(heroName, CUSTOM_ABILITY_4, CUSTOM_ABILITY_NOT_PRESENT)
    if _GetHeroRace(heroName) == TOWN_HEAVEN then
        SetGameVar("RABHavenHero"..heroName.."TrainingLevel", "")
        SetGameVar("RABHavenHero"..heroName.."ExpertTrainer", "")
        SetGameVar("RABHavenHero"..heroName.."Pariah", "")
    end
end

function RABInitialization()
    BlockGame()
    for playerId = 1, 8 do
        if GetPlayerState(playerId) == true and IsAIPlayer(playerId) == 0 then
            for i, heroName in GetPlayerHeroes(playerId) do
                _rab_hireHero(heroName)
            end

            Trigger(PLAYER_ADD_HERO_TRIGGER, playerId, nil)
            Trigger(PLAYER_REMOVE_HERO_TRIGGER, playerId, nil)
            Trigger(PLAYER_ADD_HERO_TRIGGER, playerId, "_rab_hireHero")
            Trigger(PLAYER_REMOVE_HERO_TRIGGER, playerId, "_rab_loseHero")
        end
    end

    Trigger(CUSTOM_ABILITY_TRIGGER, "RacialAbilityBoost")
    startThread(_rab_monitoring_thread)
    print("Racial Ability Boost module successfully loaded!")
    UnblockGame()
end

RABInitialization()

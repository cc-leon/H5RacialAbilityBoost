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
g_tabAcademyUsedFactory = {}  -- trace if a hero has used arcane forge on a day
g_tabDunegonUsedDarkRitual = {}  -- trace if a hero has used dark ritual per day
g_tabDungeonIrresistableKnowledge = {}  -- trace if knowledge has been awarded based on irresitable magic
g_tabHavenUsedTraining = {}  -- trace if a faction has used its haven training quota
g_tabPreserveUsedSettingEnemy = {}  -- trace if a hero has used setting enemy on a day
g_tabStrongholdUsedWalksHut = {}  -- trace if a hero has used walk's hut on a day
g_tabStrongholdShatterMagicLearnt = {}  -- trace if a hero has learnt shatter magic
g_tabStrongholdEnlightenmentShoutLearnt = {}  -- trace if a hero has learnt enlightenment or shout

function RacialAbilityBoost(heroName, customAbilityID)
    if customAbilityID == CUSTOM_ABILITY_3 then
        stackSplit(heroName, customAbilityID)

    elseif customAbilityID == CUSTOM_ABILITY_4 then
        local heroRace = _GetHeroRace(heroName)
        g_tabCallbackParams[1] = heroName

        if heroRace == TOWN_ACADEMY then
            local options = {[1] = {RAB_TXT.."AcademyOption1.txt"; movement = PARAM_WIZARD_ARTIFICER_COST}, }
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
            local options = {[1] = RAB_TXT.."FortressOption1.txt", [2] = RAB_TXT.."FortressOption2.txt", [3] = RAB_TXT.."FortressOption3.txt", }
            _PagedTalkBox(
                PORT_FORTRESS,
                RAB_TXT.."dummy2.txt",
                {RAB_TXT.."FortressTalkBoxDescription.txt"; race = RACE2TEXT[TOWN_FORTRESS], class = CLASS2TEXT[TOWN_FORTRESS]},
                RAB_TXT.."RABTalkBoxTitle.txt",
                "_FortressAbilityCallback", options)
        elseif heroRace == TOWN_HEAVEN then
            local options = {[1] = {RAB_TXT.."HavenOption1.txt"; skill = KNIGHT_SKILL_TRAINING_TEXT[3], perk = KNIGHT_TRAINING_EXPERT_TEXT}, [2] = RAB_TXT.."HavenOption2.txt", }
            _PagedTalkBox(
                PORT_HAVEN,
                RAB_TXT.."dummy2.txt",
                {RAB_TXT.."HavenTalkBoxDescription.txt"; race = RACE2TEXT[TOWN_HEAVEN], class = CLASS2TEXT[TOWN_HEAVEN], skill = KNIGHT_SKILL_TRAINING_TEXT[3], perk = KNIGHT_TRAINING_EXPERT_TEXT},
                RAB_TXT.."RABTalkBoxTitle.txt",
                "_HavenAbilityCallback", options)
        elseif heroRace == TOWN_INFERNO then
            MessageBox({RAB_TXT.."InfernoTalkBoxDescription.txt"; class = CLASS2TEXT[TOWN_INFERNO]})
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

function _AcademyAbilityCallback(cNum)
    if cNum == 1 then
        if not _checkMovementCondition(g_tabCallbackParams[1], PARAM_WIZARD_ARTIFICER_COST) then
            return
        end
        local drKey = g_tabCallbackParams[1]..GetDate(ABSOLUTE_DAY)
        if g_tabAcademyUsedFactory[drKey] == nil then
            _forceHeroInteractWithObject(g_tabCallbackParams[1], MINI_TOWN[TOWN_ACADEMY], true)
            g_tabAcademyUsedFactory[drKey] = true
        else
            MessageBox({RAB_TXT.."DailyLimitCheckFailure.txt"; times = 1, days = 1, limit = 1}, "")
        end
    end
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
        print("spellLevel "..spellLevel)
        print(spellToLearn)
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
        if _buildingConditionCheck(MINI_TOWN[TOWN_FORTRESS], "TOWN_FORTRESS", TOWN_BUILDING_BLACKSMITH, 1, FORTRESS_BLACKSMITH_TEXT, RACE2TEXT[TOWN_FORTRESS]) == true then
            _forceHeroInteractWithObject(g_tabCallbackParams[1], MINI_WAR_MACHINE_FACTORY, nil)
        end
    elseif cNum == 3 then
        if contains(BORDERGUARD_HEROES, g_tabCallbackParams[1]) then
            _FortressBorderGuardSummonCity(g_tabCallbackParams[1])
        else
            MessageBox(RAB_TXT.."FortressBorderGuardCheckFailure.txt", "")
        end
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

function _FortressBorderGuardSummonCity(heroName)
    if not IsObjectExists(MINI_TOWN[TOWN_FORTRESS]) then
        MessageBox(RAB_TXT.."MissingObjectWarning.txt")
        return nil
    end
    BlockGame()
    MakeTownMovable(MINI_TOWN[TOWN_FORTRESS])
    sleep(1)
    local x, y, z = GetObjectPos(heroName)
    PlayVisualEffect( "/Effects/_(Effect)/Spells/townportal_end.xdb#xpointer(/Effect)", heroName, "", 0, 0, 0, 0, 0 )
    Play3DSound("/Sounds/_(Sound)/Spells/TownTeleportEnd.xdb#xpointer(/Sound)", x, y, z)
    sleep(5)
    local x, y, z = GetObjectPos(MINI_TOWN[TOWN_FORTRESS])
    PlayVisualEffect("/Effects/_(Effect)/Spells/townportal_start.xdb#xpointer(/Effect)", MINI_TOWN[TOWN_FORTRESS], "", 0, 0, 0, 0, 0 )
    Play3DSound("/Sounds/_(Sound)/Spells/TownTeleportStart.xdb#xpointer(/Sound)", x, y, z)
    sleep(10)
    local x, y, z = GetObjectPos(heroName)
    if GetObjectOwner(MINI_TOWN[TOWN_FORTRESS]) == PLAYER_NONE then
        x = x + 1
        SetObjectPos(MINI_TOWN[TOWN_FORTRESS], x, y, z)
        x = x - 1
    end
    SetObjectOwner(MINI_TOWN[TOWN_FORTRESS], GetCurrentPlayer())
    sleep(1)
    SetObjectPos(MINI_TOWN[TOWN_FORTRESS], x, y, z)
    sleep(5)
    UnblockGame()
end

function _HavenAbilityCallback(cNum)
    if cNum == 1 then
        if g_tabHavenUsedTraining[GetCurrentPlayer()] == nil then
            local heroName = g_tabCallbackParams[1]
            if GetHeroLevel(g_tabCallbackParams[1]) == 1 then
                BlockGame()
                while true do
                    local skillLevel = GetHeroSkillMastery(heroName, SKILL_TRAINING)
                    if skillLevel <= 2 then
                        GiveHeroSkill(heroName, SKILL_TRAINING)
                        ShowFlyMessage({RAB_TXT.."SkillLearntFlyMessage.txt"; skill = KNIGHT_SKILL_TRAINING_TEXT[skillLevel + 1]}, heroName, GetCurrentPlayer(), 5)
                        sleep(2)
                    else
                        break
                    end
                end
                if GetHeroSkillMastery(heroName, PERK_EXPERT_TRAINER) == 0 then
                        GiveHeroSkill(heroName, PERK_EXPERT_TRAINER)
                        ShowFlyMessage({RAB_TXT.."SkillLearntFlyMessage.txt"; skill = KNIGHT_TRAINING_EXPERT_TEXT}, heroName, GetCurrentPlayer(), 5)
                        sleep(2)
                end
                g_tabHavenUsedTraining[GetCurrentPlayer()] = true
                UnblockGame()
            else
                MessageBox({RAB_TXT.."HavenTrainingLevelCheckFailure.txt"; race = RACE2TEXT[TOWN_HEAVEN], class = CLASS2TEXT[TOWN_HEAVEN]}, "")
            end
        else
            MessageBox({RAB_TXT.."HavenAlreadyTrainedCheckFailure.txt"; player = GetCurrentPlayer()}, "")
        end
    elseif cNum == 2 then
        if _buildingConditionCheck(MINI_TOWN[TOWN_HEAVEN], "TOWN_HEAVEN", TOWN_BUILDING_DWELLING_2, 2, HAVEN_DWELLING_2_TEXT, RACE2TEXT[TOWN_HEAVEN]) == true then
            _forceHeroInteractWithObject(g_tabCallbackParams[1], MINI_TOWN[TOWN_HEAVEN], true)
        end
    end
end

function _PreserveAbilityCallback(cNum)
    if cNum == 1 then  -- Set favored enemies
        if not _checkMovementCondition(g_tabCallbackParams[1], PARAM_RANGER_SET_FAVORED_ENEMY_COST) then
            return
        end
        local drKey = g_tabCallbackParams[1]..GetDate(ABSOLUTE_DAY)
        if g_tabPreserveUsedSettingEnemy[drKey] == nil then
            _forceHeroInteractWithObject(g_tabCallbackParams[1], MINI_TOWN[TOWN_PRESERVE], true)
            g_tabPreserveUsedSettingEnemy[drKey] = true
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
        _forceHeroInteractWithObject(heroName, MINI_TOWN[TOWN_STRONGHOLD], true)
        g_tabStrongholdUsedWalksHut[drKey] = true
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

    print("Racial Ability Boost module successfully loaded!")
    UnblockGame()
end

RABInitialization()
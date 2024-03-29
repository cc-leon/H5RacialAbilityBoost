_pagedObj = {
    ["page"] = nil, ["port"] = nil, ["info"] = nil, ["desc"] = nil, 
    ["capt"] = nil, ["callback"] = nil, ["options"] = nil, ["next"] = nil, ["back"] = nil}


function _PagedTalkBoxCallback(pNum, cNum)
    local callback = ""
    local recall = nil
    if (not (_pagedObj["next"] or _pagedObj["back"])) or cNum == 0 then
        callback = _pagedObj["callback"].."("..cNum..")"
    elseif _pagedObj["back"] and cNum == _pagedObj["back"] then
        _pagedObj["page"] = 1
        recall = true
    elseif _pagedObj["next"] and cNum == _pagedObj["next"] then
        _pagedObj["page"] = _pagedObj["page"] + 1
        recall = true
    else
        callback = _pagedObj["callback"].."("..((_pagedObj["page"] - 1) * 4 + cNum)..")"
    end
    if recall then
        _PagedTalkBox(_pagedObj["port"], _pagedObj["info"], _pagedObj["desc"], _pagedObj["capt"], _pagedObj["callback"], _pagedObj["options"])
    else
        _pagedObj = {}
        parse(callback)()
    end
end


function _PagedTalkBox(port, info, desc, capt, callback, options)
    args = {}
    if not _pagedObj["page"] then
        _pagedObj["page"] = 1
        _pagedObj["port"] = port
        _pagedObj["info"] = info
        _pagedObj["desc"] = desc
        _pagedObj["capt"] = capt
        _pagedObj["callback"] = callback
        _pagedObj["options"] = options
    end
    if length(options) <= 5 then
        if options[1] then args[1] = {RAB_TXT.."TalkBoxOption.txt"; texts = options[1]} end
        if options[2] then args[2] = {RAB_TXT.."TalkBoxOption.txt"; texts = options[2]} end
        if options[3] then args[3] = {RAB_TXT.."TalkBoxOption.txt"; texts = options[3]} end
        if options[4] then args[4] = {RAB_TXT.."TalkBoxOption.txt"; texts = options[4]} end
        if options[5] then args[5] = {RAB_TXT.."TalkBoxOption.txt"; texts = options[5]} end
    else
        local startI = (_pagedObj["page"] - 1) * 4
        _pagedObj["next"] = nil
        _pagedObj["back"] = nil
        for i = 1, 4 do
            if options[startI + i] then
                args[i] = {RAB_TXT.."TalkBoxOption.txt"; texts = options[startI + i]}
            else
                args[i] = RAB_TXT.."TalkBoxBack.txt"
                _pagedObj["next"] = nil
                _pagedObj["back"] = i
                break
            end
        end
        if options[startI + 5] then
            args[5] = RAB_TXT.."TalkBoxNext.txt"
            _pagedObj["next"] = 5
            _pagedObj["back"] = nil
        elseif not _pagedObj["back"] then
            args[5] = RAB_TXT.."TalkBoxBack.txt"
            _pagedObj["next"] = nil
            _pagedObj["back"] = 5
        end
    end

    TalkBoxForPlayers(
        GetPlayerFilter(GetCurrentPlayer()),
        port,
        info,
        {RAB_TXT.."TalkBoxMain.txt"; texts = desc},
        nil,
        "_PagedTalkBoxCallback",
        1,
        capt,
        nil,
        0,
        args[1], args[2], args[3], args[4], args[5])
end

function _getMaxValue(value1, value2)
    if value1 > value2 then
        return value1
    else
        return value2
    end
end

function _GetHeroRace(heroName)
    -- Return the race id of a hero
    if GetHeroSkillMastery(heroName, SKILL_TRAINING) >= 1 then
        return TOWN_HEAVEN
    elseif GetHeroSkillMastery(heroName, SKILL_AVENGER) >= 1 then
        return TOWN_PRESERVE
    elseif GetHeroSkillMastery(heroName, SKILL_ARTIFICIER) >= 1 then
        return TOWN_ACADEMY
    elseif GetHeroSkillMastery(heroName, SKILL_INVOCATION) >= 1 then
        return TOWN_DUNGEON
    elseif GetHeroSkillMastery(heroName, SKILL_NECROMANCY) >= 1 then
        return TOWN_NECROMANCY
    elseif GetHeroSkillMastery(heroName, SKILL_GATING) >= 1 then
        return TOWN_INFERNO
    elseif GetHeroSkillMastery(heroName, HERO_SKILL_RUNELORE) >= 1 then
        return TOWN_FORTRESS
    elseif GetHeroSkillMastery(heroName, HERO_SKILL_DEMONIC_RAGE) >= 1 then
        return TOWN_STRONGHOLD
    else
        return nil
    end
end

function _buildingConditionCheck(objectName, townType, buildingType, buildingLevel, buildingTxt, raceTxt)
    if not IsObjectExists(objectName) then
        MessageBox(RAB_TXT.."MissingObjectWarning.txt")
        return nil
    end
    for i, townName in GetObjectNamesByType(townType) do
        if GetObjectOwner(townName) == GetCurrentPlayer() and GetTownBuildingLevel(townName, buildingType) >= buildingLevel then
            return true
        end
    end
    MessageBox({RAB_TXT.."BuildingCheckFailure.txt"; building = buildingTxt, race = raceTxt})
    return nil
end

function _GetBuildingLevelInAllTowns(townType, buildingId)
    local result = 0
    for i, townName in GetObjectNamesByType(RACE2TYPES[townType]) do
        if GetObjectOwner(townName) == GetCurrentPlayer() then
            if GetTownBuildingLevel(townName, buildingId) > result then
                result = GetTownBuildingLevel(townName, buildingId)
            end
        end
    end
    return result
end

function _GetNumBuildingsInAllTowns(townType, buildingId, minLevel)
    local result = 0
    for i, townName in GetObjectNamesByType(RACE2TYPES[townType]) do
        if GetObjectOwner(townName) == GetCurrentPlayer() then
            if GetTownBuildingLevel(townName, buildingId) >= minLevel then
                result = result + 1
            end
        end
    end
    return result
end

function _checkMovementCondition(heroName, cost)
    remainingMovement = GetHeroStat(heroName, 7)
    if remainingMovement > cost then
        ChangeHeroStat(heroName, 7, -cost)
        return true
    else
        MessageBox({RAB_TXT.."InsufficientMovementWarning.txt"; move1 = cost, move2 = remainingMovement}, "")
        return nil
    end
end

function _isHeroInTown(heroName)
    for i, townType in RACE2TYPES do
        for i, townName in GetObjectNamesByType(townType) do
            if IsHeroInTown(heroName, townName) then
                return true
            end
        end
    end
    return nil
end

function _forceHeroInteractWithObject(heroName, objectName, ownable)
    if not IsObjectExists(objectName) then
        MessageBox(RAB_TXT.."MissingObjectWarning.txt")
        return nil
    end

    if _isHeroInTown(heroName) == true then
        MessageBox(RAB_TXT.."CannotUseInTownWarning.txt", "")
        return nil
    end

    if IsHeroInBoat(heroName) == true then
        MessageBox(RAB_TXT.."CannotUseInBoatWarning.txt", "")
        return nil
    end

    local x, y, z = GetObjectPos(heroName)
    BlockGame()
    if ownable == true then
        SetObjectOwner(objectName, GetObjectOwner(heroName))
    end
    MakeHeroInteractWithObject(heroName, objectName)
    sleep(10)
    SetObjectPos(heroName, x, y, z)
    sleep(1)
    if ownable == true then
        SetObjectOwner(objectName, PLAYER_NONE)
    end
    sleep(5)
    UnblockGame()
    return true
end

function _getSpecialSpellsCost(spellLevel, faction)
    local result = {}
    if faction == TOWN_ACADEMY then
        if spellLevel == 1 then
            result[GOLD] = 3500
        elseif spellLevel == 2 then
            result[GOLD] = 4000
        elseif spellLevel == 3 then
            result[GOLD] = 5000
        elseif spellLevel == 4 then
            result[GOLD] = 20000
        else
            result[GOLD] = 0
        end
    elseif faction == TOWN_FORTRESS then
        result[GOLD] = 1500 + (spellLevel - 1) * 300
        result[WOOD] = floor(spellLevel / 2)
        result[ORE] = floor(spellLevel / 2)
    elseif faction == TOWN_STRONGHOLD then
        result[GOLD] = 1500 + (spellLevel - 1) * 500
        result[WOOD] = 5 + (spellLevel - 1) 
        result[ORE] = 5 + (spellLevel - 1)
        result[MERCURY] = (spellLevel - 1)
        result[CRYSTAL] = (spellLevel - 1)
        result[SULFUR] = (spellLevel - 1)
        result[GEM] = (spellLevel - 1)
    end
    return result
end

function _cNumToSpellId(cNum, spellTab)
    local result = 0
    for i, spells in spellTab do
        for j, spell in spells do
            result = result + 1
            if cNum == result then
                return spell
            end
        end
    end
    return nil
end

function _getSpellTierById(spellId, spellTab)
    for i, spells in spellTab do
        for j, spell in spells do
            if spell == spellId then
                return i
            end
        end
    end
    return nil
end

function _checkSpellAlreadyLearnt(heroName, spellId, spellText)
    if KnowHeroSpell(heroName, spellId) == true then
        MessageBox({RAB_TXT.."SpellAlreadyLearnt.txt"; spell = spellText})
        return true
    else
        return nil
    end
end

function _currentPlayerResourceCheck(heroName, resourceCosts)
    for resourceType, resourceRequired in resourceCosts do
        local currentResource = GetPlayerResource(GetCurrentPlayer(), resourceType)
        if currentResource < resourceRequired then
            MessageBox({RAB_TXT.."InsufficientResourceWarning.txt"; amount1 = resourceRequired, amount2 = currentResource, resource = RESOURCE2TEXT[resourceType]}, "")
            return nil
        end
    end
    BlockGame()
    for resourceType, resourceRequired in resourceCosts do
        ShowFlyMessage({RAB_TXT.."LostResourceFlyMessage.txt"; amount = resourceRequired, resource = RESOURCE2TEXT[resourceType]}, heroName, GetCurrentPlayer(), 5)
        SetPlayerResource(GetCurrentPlayer(), resourceType, GetPlayerResource(GetCurrentPlayer(), resourceType) - resourceRequired)
        sleep(2)
    end
    UnblockGame()
    return true
end

function _getHeroNumMainSkillLearnt(heroName)
    local skillsToCheck = {
        SKILL_LOGISTICS,  SKILL_WAR_MACHINES, SKILL_LEARNING,
        SKILL_LEADERSHIP, SKILL_LUCK,         SKILL_OFFENCE,
        SKILL_DEFENCE,    SKILL_SORCERY,      SKILL_DESTRUCTIVE_MAGIC,
        SKILL_DARK_MAGIC, SKILL_LIGHT_MAGIC,  SKILL_SUMMONING_MAGIC,
        SKILL_TRAINING,   SKILL_GATING,       SKILL_NECROMANCY,
        SKILL_AVENGER,    SKILL_ARTIFICIER,   SKILL_INVOCATION,
        HERO_SKILL_RUNELORE,                  HERO_SKILL_DEMONIC_RAGE,
        -- HERO_SKILL_BARBARIAN_LEARNING,
        HERO_SKILL_VOICE,
        HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC, HERO_SKILL_SHATTER_DARK_MAGIC,
        HERO_SKILL_SHATTER_LIGHT_MAGIC,       HERO_SKILL_SHATTER_SUMMONING_MAGIC, }
    local result = 0

    for i, skillId in skillsToCheck do
        if GetHeroSkillMastery(heroName, skillId) > 0 then
            result = result + 1
        end
    end
    return result
end

function _isCreatureHumanoid(creatureId)
    if CREATURE_UPGRADE2UNGRADED[creatureId] ~= nil then
        creatureId = CREATURE_UPGRADE2UNGRADED[creatureId]
    end
    if TRAINING_MAPPING[creatureId] == nil then
        if contains(TRAINING_MAPPING, creatureId) then
            return true
        else
            return nil
        end
    else
        return true
    end
end

function _isCreatureTrainable(creatureId)
    if CREATURE_UPGRADE2UNGRADED[creatureId] ~= nil then
        creatureId = CREATURE_UPGRADE2UNGRADED[creatureId]
    end
    return TRAINING_MAPPING[creatureId] ~= nil
end

-- Given slots information newCreatures (a dict with slot number to a list which has creature id and amount)
-- Set the object's stacks to be the same as newCreatures
-- Must be blocked
function _SetCreatureSlots(objName, newCreatures)
    local creatureId, creatureCount = 0, 0
    local finSlot, finId = 7, 0
    for i = 0, 6 do
        creatureId, creatureCount = GetObjectArmySlotCreature(objName, i)
        if creatureId ~= 0 then RemoveObjectCreatures(objName, creatureId, creatureCount, i) end
    end
    sleep(1)
    for i = 0, 6 do
        creatureId, creatureCount = GetObjectArmySlotCreature(objName, i)
        if creatureId ~= 0 then
            finSlot = i
            finId = creatureId
        end
    end
    for i = 0, 6 do
        if newCreatures[i][1] ~= 0 and newCreatures[i][2] ~= 0 and i ~= finSlot then 
            AddObjectCreatures(objName, newCreatures[i][1], newCreatures[i][2], i)
        end
    end
    if finSlot < 7 then
        sleep(1)
        RemoveObjectCreatures(objName, finId, 1, finSlot)
        sleep(1)
        creatureId, creatureCount = GetObjectArmySlotCreature(objName, finSlot)
        if newCreatures[finSlot][1] ~= 0 then
            AddObjectCreatures(objName, newCreatures[finSlot][1], newCreatures[finSlot][2])
            sleep(1)
        end
        if creatureId ~= 0 then
            RemoveObjectCreatures(objName, finId, 1, finSlot)
            sleep(1)
        end
    else
        sleep(1)
    end
end

-- Return slots information newCreatures (a dict with slot number to a list which has creature id and amount)
-- of the object
function _GetCreatureSlots(objName)

    result = {}

    for i = 0, 6 do
        local creatureId, creatureCount = GetObjectArmySlotCreature(objName, i)
        result[i] = {creatureId, creatureCount}
    end

    return result
end

-- Get the hero's player owner ID
-- This is needed as in contrary to GetObjectOwner, when a hero is inside town and disappeared from the hero list,
-- GetObjectOwner will raise an error, despite the hero still IsHeroAlive() and IsObjectExists() returning true.
-- This function is to circumvent this limitation of GetObjectOwner
function _getHeroPlayer(heroName)
    for playerId = PLAYER_1, PLAYER_8 do
        if GetPlayerState(playerId) == PLAYER_ACTIVE then
            local heroes = GetPlayerHeroes(playerId)
            if contains(heroes, heroName) then
                return playerId
            end
        end
    end
    return PLAYER_NONE
end
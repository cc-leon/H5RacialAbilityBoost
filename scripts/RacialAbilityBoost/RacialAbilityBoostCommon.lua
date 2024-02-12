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
        GetPlayerFilter(1),
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

function _forceHeroInteractWithObject(heroName, objectName, ownable)
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
    sleep(10)
    UnblockGame()
end
doFile("/scripts/RacialAbilityBoost/RacialAbilityBoostCombatConstants.lua")


g_tabCombatHeroNames = {[ATTACKER] = "", [DEFENDER] = "", }  -- heroName of both side
g_tabCombatUnitInfos = {}  -- tracking unit creature id
-- side/Real/(Start|End)/unitNo, side/Fake/(Start|End)/unitNo, tracking unit amount changes
g_tabCombatCreatureTracking = {}
g_bCombatShouldTrack = 0 -- Skip move if both sides have no inferno creatures

function _initializeCreatureTracking()

    for sideId, sideString in RAB_COMBAT_GATING_SIDE2STRING do
        g_tabCombatCreatureTracking[sideId] = {}
        for realFakeId, realFakeString in RAB_COMBAT_GATING_REAL_FAKE do
            g_tabCombatCreatureTracking[sideId][realFakeString] = {}
            for startEndId, startEndString in RAB_COMBAT_GATING_START_END do
                g_tabCombatCreatureTracking[sideId][realFakeString][startEndString] = {}
            end
        end
    end

    -- Cleaning Game Var
    _RABResetInfernoGatingTrackingGameVar()
end

function _updateCreatureTracking()
    for side, heroName in g_tabCombatHeroNames do
        if heroName ~= "" then
            -- Record and update new summoned creature amount
            for j, unitNo in GetCreatures(side) do
                if g_tabCombatCreatureTracking[side]["Real"]["End"][unitNo] == nil then
                    local creatureId = _RABGetUngradedInfernoCreature(GetCreatureType(unitNo))
                    if creatureId ~= CREATURE_UNKNOWN then
                        g_tabCombatCreatureTracking[side]["Fake"]["Start"][unitNo] = GetCreatureNumber(unitNo)
                        g_tabCombatUnitInfos[unitNo] = creatureId
                    end
                end
            end

            -- Record real units number changes (including death) and destruction
            for unitNo, unitAmount in g_tabCombatCreatureTracking[side]["Real"]["End"] do
                if unitAmount ~= nil then
                    if IsCombatUnit(unitNo) == nil then
                        g_tabCombatCreatureTracking[side]["Real"]["End"][unitNo] = nil
                    else
                        g_tabCombatCreatureTracking[side]["Real"]["End"][unitNo] = GetCreatureNumber(unitNo)
                    end
                end
            end

            -- Record summoned units destruction
            for unitNo, unitAmount in g_tabCombatCreatureTracking[side]["Fake"]["Start"] do
                if unitAmount ~= nil then
                    if IsCombatUnit(unitNo) == nil or GetCreatureNumber(unitNo) == 0 then
                        g_tabCombatCreatureTracking[side]["Fake"]["Start"][unitNo] = nil
                    end
                end
            end

            -- Update Game Var
            --   Initialize creature counter
            local creatureCounts = {}
            for sideId, sideString in RAB_COMBAT_GATING_SIDE2STRING do
                creatureCounts[sideId] = {}
                for realFakeId, realFakeString in RAB_COMBAT_GATING_REAL_FAKE do
                    creatureCounts[sideId][realFakeString] = {}
                    for creatureId = CREATURE_FAMILIAR, CREATURE_DEVIL, 2 do
                        creatureCounts[sideId][realFakeString][creatureId] = 0
                    end
                end
            end

            for sideId, heroName in g_tabCombatHeroNames do
                if heroName ~= "" then
                    -- Accumulate real amount
                    for unitNo, startUnitAmount in g_tabCombatCreatureTracking[side]["Real"]["Start"] do
                        local endUnitAmount = g_tabCombatCreatureTracking[side]["Real"]["End"][unitNo]
                        local creatureId = g_tabCombatUnitInfos[unitNo]
                        if endUnitAmount == nil then
                            endUnitAmount = 0
                        end
                        local realAmount = startUnitAmount - endUnitAmount
                        if realAmount < 0 then
                            realAmount = 0
                        end
                        creatureCounts[sideId]["Real"][creatureId] = creatureCounts[sideId]["Real"][creatureId] + realAmount
                    end

                    -- Accumulate fake amount
                    for unitNo, unitAmount in g_tabCombatCreatureTracking[side]["Fake"]["Start"] do
                        if unitAmount ~= nil then
                            local creatureId = g_tabCombatUnitInfos[unitNo]
                            creatureCounts[sideId]["Fake"][creatureId] = creatureCounts[sideId]["Fake"][creatureId] + unitAmount
                        end
                    end
                end
            end

            --    write into Game Var
            for sideId, heroName in g_tabCombatHeroNames do
                for realFakeId, realFakeString in RAB_COMBAT_GATING_REAL_FAKE do
                    for creatureId, creatureAmount in creatureCounts[sideId][realFakeString] do
                        if heroName ~= "" then
                            local varName = RAB_COMBAT_GATING_SUFFIX..RAB_COMBAT_GATING_SIDE2STRING[sideId]..realFakeString..creatureId
                            SetGameVar(varName, creatureAmount)
                        end
                    end
                end
            end
        end
    end
end


-- Hook functions

function Start()
    _initializeCreatureTracking()
    for side, i in g_tabCombatHeroNames do
        local heroUnit = GetHero(side)
        if heroUnit ~= nil then
            g_tabCombatHeroNames[side] = GetHeroName(heroUnit)
            for j, unitNo in GetCreatures(side) do
                local creatureId = _RABGetUngradedInfernoCreature(GetCreatureType(unitNo))
                if creatureId ~= CREATURE_UNKNOWN then
                    local creatureAmount = GetCreatureNumber(unitNo)
                    g_tabCombatCreatureTracking[side]["Real"]["Start"][unitNo] = creatureAmount
                    g_tabCombatCreatureTracking[side]["Real"]["End"][unitNo] = creatureAmount
                    g_tabCombatUnitInfos[unitNo] = creatureId
                end
            end
            SetGameVar(RAB_COMBAT_GATING_SUFFIX..RAB_COMBAT_GATING_SIDE2STRING[side].."Hero", g_tabCombatHeroNames[side])
        end
        g_bCombatShouldTrack = g_bCombatShouldTrack + length(g_tabCombatCreatureTracking[side]["Real"]["Start"])
    end
end

function UnitMove(unitName)
    local temp = nil
    if IsAttacker(unitName) then
        temp = AttackerUnitMove(unitName)
    elseif IsDefender(unitName) then
        temp = DefenderUnitMove(unitName)
    end
    if g_bCombatShouldTrack > 0 then
        _updateCreatureTracking()
    end
    return temp
end

print("Racial ability boost combat module successfully loaded!")
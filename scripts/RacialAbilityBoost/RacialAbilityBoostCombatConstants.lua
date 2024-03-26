ATTACKER = 0
DEFENDER = 1

RAB_COMBAT_GATING_SUFFIX = "RABInfernoGatingTracking"
RAB_COMBAT_GATING_SIDE2STRING = {[ATTACKER] = "Attacker", [DEFENDER] = "Defender", }
RAB_COMBAT_GATING_REAL_FAKE = {"Real", "Fake"}
RAB_COMBAT_GATING_START_END = {"Start", "End"}
RAB_HAVEN_CASTER_SP = {[1] = 4, [2] = 6, [3] = 8, [4] = 10}
RAB_SP_TO_CREATURE_AMOUNT = {
    [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5,
    [6] = 6, [7] = 8, [8] = 9, [9] = 10, [10] = 12,
    [11] = 14, [12] = 16, [13] = 19}

PARAM_EXPERT_TRAINER_HERO_ATB_BOOST = 0.3

function _RABGetUngradedInfernoCreature(creatureId)
    if creatureId >= CREATURE_FAMILIAR and creatureId <= CREATURE_ARCHDEVIL then
        if mod(creatureId, 2) == 0 then
            return creatureId - 1
        else
            return creatureId
        end
    elseif creatureId >= CREATURE_QUASIT and creatureId <=CREATURE_ARCH_DEMON then
        return CREATURE_FAMILIAR + (2 * (creatureId - CREATURE_QUASIT))
    else
        return CREATURE_UNKNOWN
    end
end

function _RABResetInfernoGatingTrackingGameVar()
    for sideId, sideString in RAB_COMBAT_GATING_SIDE2STRING do
        SetGameVar(RAB_COMBAT_GATING_SUFFIX..sideString.."Hero", "")
        for creatureId = CREATURE_FAMILIAR, CREATURE_DEVIL, 2 do
            for realFakeId, realFakeString in RAB_COMBAT_GATING_REAL_FAKE do
                SetGameVar(RAB_COMBAT_GATING_SUFFIX..sideString..realFakeString..creatureId, 0)
            end
        end
    end
end

function _RABGetHavenCasterAmount(trainingLvl)
    if RAB_HAVEN_CASTER_SP[trainingLvl] ~= nil then
        return RAB_SP_TO_CREATURE_AMOUNT[RAB_HAVEN_CASTER_SP[trainingLvl]]
    else
        return 0
    end
end

-- training level is integer, pariah is string
function _RABGetHavenSpells(trainingLvl, pariah)
    local result = {["mass"] = {}, ["single"] = {}}
    if pariah == "1" or trainingLvl == 4 then
        if trainingLvl >= 1 then
            result["single"][length(result["single"])] = SPELL_SORROW
        end
        if trainingLvl >= 2 then
            result["single"][length(result["single"])] = SPELL_DISRUPTING_RAY
        end
        if trainingLvl >= 3 then
            result["single"][length(result["single"])] = SPELL_FORGETFULNESS
        end
        if trainingLvl >= 4 then
            result["single"][length(result["single"])] = SPELL_SLOW
        end
    end
    if pariah ~=  "1" then
        if trainingLvl >= 1 then
            result["mass"][length(result["mass"])] = SPELL_MASS_BLOODLUST
        end
        if trainingLvl >= 2 then
            result["mass"][length(result["mass"])] = SPELL_MASS_HASTE
        end
        if trainingLvl >= 3 then
            result["mass"][length(result["mass"])] = SPELL_MASS_BLESS
        end
    end

    return result
end

function _RABGetOppositeSide(sideId)
    if sideId == ATTACKER then
        return DEFENDER
    else 
        return ATTACKER
    end
end
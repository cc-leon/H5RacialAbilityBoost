ATTACKER = 0
DEFENDER = 1

RAB_COMBAT_GATING_SUFFIX = "RABInfernoGatingTracking"
RAB_COMBAT_GATING_SIDE2STRING = {[ATTACKER] = "Attacker", [DEFENDER] = "Defender", }
RAB_COMBAT_GATING_REAL_FAKE = {"Real", "Fake"}
RAB_COMBAT_GATING_START_END = {"Start", "End"}

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
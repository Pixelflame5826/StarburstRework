function init()
  local bounds = mcontroller.boundBox()
  animator.setParticleEmitterBurstCount("flames", 6)
  animator.setParticleEmitterOffsetRegion("flames", {bounds[1], bounds[2] - 0.25, bounds[3], bounds[2] + 0.25})
  animator.setParticleEmitterOffsetRegion("drips", bounds)
  animator.setParticleEmitterActive("drips", true)
  
  script.setUpdateDelta(5)

  self.tickRate = config.getParameter("tickRate")
  self.tickDamage = config.getParameter("tickDamage")

  self.tickTimer = self.tickRate
  
  self.fatigueTime = 360
  self.fatigueTimer = self.fatigueTime
  
  effect.addStatModifierGroup({{stat = "healthRegen", amount = -0.4}})
  
  effect.addStatModifierGroup({{stat = "energyRegenPercentageRate", effectiveMultiplier = 0.50}})
  -- Hazard Radio Message
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "biomeheat", 5.0)
  -- Tutorial Radio Messages
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_deadlyhazardtutorial_a", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_deadlyhazardtutorial_b", 5.0)
end

function update(dt)
  self.tickTimer = math.max(0, self.tickTimer - dt)
  self.fatigueTimer = self.fatigueTimer - dt
  
  if (status.stat("pf_mildBiomeHeatImmunity") >= 1.0) then
    if self.fatigueTimer <= 0 then
	  self.fatigueTimer = self.fatigueTime
	  effect.addStatModifierGroup({{stat = "healthRegen", amount = -0.2}})
    end
  else
    if self.tickTimer <= 0 then
      animator.burstParticleEmitter("flames")
      self.tickTimer = self.tickRate
      status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = self.tickDamage,
        damageSourceKind = "fire",
        sourceEntityId = entity.id()
      })
    end
  end
end

function uninit()

end

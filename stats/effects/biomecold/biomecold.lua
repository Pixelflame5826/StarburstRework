function init()
  animator.setParticleEmitterOffsetRegion("snow", mcontroller.boundBox())
  animator.setParticleEmitterActive("snow", true)

  effect.setParentDirectives(config.getParameter("directives", ""))

  self.movementModifiers = config.getParameter("movementModifiers", {})

  self.energyCost = config.getParameter("energyCost", 1)
  self.healthDamage = config.getParameter("healthDamage", 0.5)
  
  script.setUpdateDelta(config.getParameter("tickRate", 1))

  effect.addStatModifierGroup({{stat = "energyRegenPercentageRate", effectiveMultiplier = 0}})

  world.sendEntityMessage(entity.id(), "queueRadioMessage", "biomecold", 5.0)
  
  effect.addStatModifierGroup({{stat = "healthRegen", amount = -0.2}})
  
  self.fatigueTime = 20.0
  self.fatigueTimer = self.fatigueTime
end

function update(dt)
  mcontroller.controlModifiers(self.movementModifiers)
  self.fatigueTimer = self.fatigueTimer - 1
  
  if (status.stat("pf_mildBiomeColdImmunity") >= 1.0) then
    effect.addStatModifierGroup({{stat = "energyRegenPercentageRate", effectiveMultiplier = 0.5}})
    if self.fatigueTimer <= 0 then
	  self.fatigueTimer = self.fatigueTime
	  effect.addStatModifierGroup({{stat = "healthRegen", amount = -0.1}})
	end
  else
    effect.addStatModifierGroup({{stat = "energyRegenPercentageRate", effectiveMultiplier = 0}})
    if not status.overConsumeResource("energy", self.energyCost) then
      status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = self.healthDamage,
        damageSourceKind = "ice",
        sourceEntityId = entity.id()
      })
    end
  end
end

function uninit()

end

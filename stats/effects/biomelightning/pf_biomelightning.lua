function init()
  animator.setParticleEmitterOffsetRegion("sparks", mcontroller.boundBox())
  animator.setParticleEmitterActive("sparks", true)


  self.healthDamage = config.getParameter("healthDamage", 5)
  
  script.setUpdateDelta(config.getParameter("tickRate", 1))
  
  effect.addStatModifierGroup({{stat = "maxEnergy", effectiveMultiplier = 0.5}})

  --- Hazard Radio Message
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_biomelightning", 5.0)
  -- Tutorial Radio Messages
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_deadlyhazardtutorial_a", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_deadlyhazardtutorial_b", 5.0)
  
  self.energyCost = config.getParameter("energyCost", 0.0)
  
  effect.addStatModifierGroup({{stat = "energyRegenPercentageRate", effectiveMultiplier = 0.1}})
end

function update(dt)
  if not status.overConsumeResource("energy", self.energyCost) then
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = self.healthDamage,
        damageSourceKind = "electric",
        sourceEntityId = entity.id()
      })
  end
  
  if not (status.stat("pf_mildBiomeLightningImmunity") >= 1.0) then
	status.addEphemeralEffect("pf_biomelightningregenblock")
  end
    
end

function uninit()

end

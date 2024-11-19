function init()
  
  animator.setParticleEmitterOffsetRegion("sparks", mcontroller.boundBox())
  
  if (world.entityType(entity.id()) == "player") then   
    animator.setParticleEmitterActive("sparks", true)
  end


  self.healthDamage = config.getParameter("healthDamage", 1)
  
  script.setUpdateDelta(config.getParameter("tickRate", 1))

  effect.addStatModifierGroup({{stat = "energyRegenPercentageRate", effectiveMultiplier = 0.75}})
  
  effect.addStatModifierGroup({{stat = "maxEnergy", effectiveMultiplier = 0.75}})
  
  self.energyCost = config.getParameter("energyCost", 0)

  -- Hazard Radio Message
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildbiomelightning", 5.0)
  -- Tutorial Radio Messages
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_a", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_b", 5.0)
end

function update(dt)
  if (not status.overConsumeResource("energy", self.energyCost) and (world.entityType(entity.id()) == "player")) then
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = self.healthDamage,
        damageSourceKind = "electric",
        sourceEntityId = entity.id()
      })
  end
end

function uninit()

end

function init()
  animator.setParticleEmitterOffsetRegion("snow", mcontroller.boundBox())
  
  if (world.entityType(entity.id()) == "player") then   
    animator.setParticleEmitterActive("snow", true)

    self.movementModifiers = config.getParameter("movementModifiers", {})

    self.healthDamage = config.getParameter("healthDamage", 0.001)
  
    script.setUpdateDelta(config.getParameter("tickRate", 1))

    effect.addStatModifierGroup({{stat = "maxEnergy", effectiveMultiplier = 0.75}})
  
    effect.addStatModifierGroup({{stat = "energyRegenBlockTime", effectiveMultiplier = 1.25}})
  end

  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildbiomecold", 5.0)
end

function update(dt)
  if (world.entityType(entity.id()) == "player") then   
    mcontroller.controlModifiers(self.movementModifiers)
    effect.addStatModifierGroup({{stat = "healthRegen", amount = -0.05}})
  end
end

function uninit()

end

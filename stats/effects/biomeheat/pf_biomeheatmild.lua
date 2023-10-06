function init()
  
  animator.setParticleEmitterOffsetRegion("sweat", mcontroller.boundBox())
  
  if (world.entityType(entity.id()) == "player") then   
    animator.setParticleEmitterActive("sweat", true)
  
    script.setUpdateDelta(config.getParameter("tickRate", 1))
  
    effect.addStatModifierGroup({{stat = "healthRegen", amount = -0.06}})

    effect.addStatModifierGroup({{stat = "energyRegenPercentageRate", effectiveMultiplier = 0.75}})
  
    effect.addStatModifierGroup({{stat = "maxEnergy", effectiveMultiplier = 0.75}})
  
    effect.addStatModifierGroup({{stat = "energyRegenBlockTime", effectiveMultiplier = 1.25}})
  end

  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildbiomeheat", 5.0)
end

function update(dt)
  if (world.entityType(entity.id()) == "player") then   
    effect.addStatModifierGroup({{stat = "healthRegen", amount = -0.01}})
  end
end

function uninit()

end

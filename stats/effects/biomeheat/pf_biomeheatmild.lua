function init()
  
  animator.setParticleEmitterOffsetRegion("sweat", mcontroller.boundBox())

  local worldEffects = world.environmentStatusEffects(mcontroller.position())
  local coldCheck = false
  for _, statusEffect in ipairs(worldEffects) do
    if statusEffect == "biomecold" then
      local coldCheck = true
    end
  end
  
  if (world.entityType(entity.id()) == "player") then 
    if(not coldCheck) then
      animator.setParticleEmitterActive("sweat", true)
  
      script.setUpdateDelta(config.getParameter("tickRate", 1))
  
      effect.addStatModifierGroup({{stat = "healthRegen", amount = -0.06}})

      effect.addStatModifierGroup({{stat = "energyRegenPercentageRate", effectiveMultiplier = 0.75}})
  
      effect.addStatModifierGroup({{stat = "maxEnergy", effectiveMultiplier = 0.75}})
  
      effect.addStatModifierGroup({{stat = "energyRegenBlockTime", effectiveMultiplier = 1.25}})
      
      -- Hazard Radio Message 
      world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildbiomeheat", 5.0)
      -- Tutorial Radio Messages
      world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_a", 5.0)
      world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_b", 5.0)
    else
      effect.addStatModifierGroup({{stat = "pf_mildBiomeColdImmunity", amount = 1}})
    end
  end
end

function update(dt)
  if (world.entityType(entity.id()) == "player") then   
    if(not coldCheck) then
      effect.addStatModifierGroup({{stat = "healthRegen", amount = -0.01}})
    end
  end
end

function uninit()

end

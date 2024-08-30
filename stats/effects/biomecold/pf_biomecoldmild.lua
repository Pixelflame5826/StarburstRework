function init()
  animator.setParticleEmitterOffsetRegion("snow", mcontroller.boundBox())
  
  local worldEffects = world.environmentStatusEffects(mcontroller.position())
  local heatCheck = false
  for _, statusEffect in ipairs(worldEffects) do
    if statusEffect == "biomeheat" then
      local heatCheck = true
    end
  end

  if (world.entityType(entity.id()) == "player") then   
    if(not heatCheck) then
      animator.setParticleEmitterActive("snow", true)

      self.movementModifiers = config.getParameter("movementModifiers", {})

      self.healthDamage = config.getParameter("healthDamage", 0.001)
  
      script.setUpdateDelta(config.getParameter("tickRate", 1))

      effect.addStatModifierGroup({{stat = "maxEnergy", effectiveMultiplier = 0.75}})
  
      effect.addStatModifierGroup({{stat = "energyRegenBlockTime", effectiveMultiplier = 1.25}})

      world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildbiomecold", 5.0)
    else
      effect.addStatModifierGroup({{stat = "pf_mildBiomeHeatImmunity", amount = 1}})
    end
  end
end

function update(dt)
  if (world.entityType(entity.id()) == "player") then   
    if(not heatCheck) then
      mcontroller.controlModifiers(self.movementModifiers)
      effect.addStatModifierGroup({{stat = "healthRegen", amount = -0.05}})
    end
  end
end

function uninit()

end

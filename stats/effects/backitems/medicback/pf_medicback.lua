function init()
  script.setUpdateDelta(5)
  
  --Health Scale
  self.healthModifier = config.getParameter("healthModifier", 0)
  effect.addStatModifierGroup({{stat = "maxHealth", effectiveMultiplier = self.healthModifier}})

  self.healingRate = 1.0 / config.getParameter("healTime", 60)
end

function update(dt)
  status.modifyResourcePercentage("health", self.healingRate * dt)
end

function uninit()
  
end

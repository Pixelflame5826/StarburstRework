function init()
  script.setUpdateDelta(5)
  
  effect.addStatModifierGroup({{stat = "fireStatusImmunity", amount = 1}, {stat = "pf_mildBiomeHeatImmunity", amount = 1}})

  self.healingRate = 1.0 / config.getParameter("healTime", 60)
end

function update(dt)
  status.modifyResourcePercentage("health", self.healingRate * dt)
end

function uninit()
  
end

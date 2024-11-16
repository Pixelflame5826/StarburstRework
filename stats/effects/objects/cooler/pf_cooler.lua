function init()
  script.setUpdateDelta(5)
  
  effect.addStatModifierGroup({{stat = "fireStatusImmunity", amount = 1}, {stat = "pf_mildBiomeHeatImmunity", amount = 1}})
end

function update(dt)
end

function uninit()
  
end

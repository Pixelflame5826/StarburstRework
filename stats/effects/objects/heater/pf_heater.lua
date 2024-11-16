function init()
  script.setUpdateDelta(5)
  
  effect.addStatModifierGroup({{stat = "iceStatusImmunity", amount = 1}, {stat = "pf_mildBiomeColdImmunity", amount = 1}})
end

function update(dt)
end

function uninit()
  
end

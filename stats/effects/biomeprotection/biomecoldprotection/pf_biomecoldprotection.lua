function init()
   effect.addStatModifierGroup({{stat = "iceResistance", amount = 0.2}, {stat = "biomecoldImmunity", amount = 1}, {stat = "pf_mildBiomeColdImmunity", amount = 1}})

   script.setUpdateDelta(0)
end

function update(dt)

end

function uninit()
  
end

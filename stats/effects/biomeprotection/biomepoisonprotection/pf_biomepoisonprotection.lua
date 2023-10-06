function init()
   effect.addStatModifierGroup({{stat = "poisonResistance", amount = 0.2}, {stat = "pf_biomepoisonImmunity", amount = 1}, {stat = "pf_mildBiomePoisonImmunity", amount = 1}})

   script.setUpdateDelta(0)
end

function update(dt)

end

function uninit()
  
end

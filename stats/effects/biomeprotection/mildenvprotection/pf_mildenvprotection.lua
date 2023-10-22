function init()
   effect.addStatModifierGroup({ {stat = "pf_mildBiomeRadiationImmunity", amount = 1}, {stat = "pf_mildBiomeColdImmunity", amount = 1}, {stat = "pf_mildBiomeHeatImmunity", amount = 1}, {stat = "pf_mildBiomePoisonImmunity", amount = 1}, {stat = "pf_mildBiomeLightningImmunity", amount = 1}})

   script.setUpdateDelta(0)
end

function update(dt)

end

function uninit()
  
end

function init()
   effect.addStatModifierGroup({{stat = "electricResistance", amount = 0.2}, {stat = "pf_biomelightningImmunity", amount = 1}, {stat = "pf_mildBiomeLightningImmunity", amount = 1}})

   script.setUpdateDelta(0)
end

function update(dt)

end

function uninit()
  
end

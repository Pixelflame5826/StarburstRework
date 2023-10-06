function init()
  effect.addStatModifierGroup({{stat = "energyRegenPercentageRate", effectiveMultiplier = 0.0}})
end

function update(dt)
  if( (status.stat("pf_mildBiomeLightningImmunity") >= 1.0) or (status.stat("pf_biomelightningImmunity") >= 1.0) ) then
    effect.expire()
  end
end

function uninit()

end

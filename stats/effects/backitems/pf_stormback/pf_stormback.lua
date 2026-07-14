function init()
  script.setUpdateDelta(3)
  effect.addStatModifierGroup({
    {stat = "pf_mildBiomeLightningImmunity", amount = 1},
    {stat = "pf_mildBiomeHeatImmunity", amount = 1},
    {stat = "pf_mildBiomeColdImmunity", amount = 1},
    {stat = "pf_mildBiomeRadiationImmunity", amount = 1},
    {stat = "pf_mildBiomePoisonImmunity", amount = 1}
  })
end

function update(dt)
  animator.setFlipped(mcontroller.facingDirection() == -1)
end

function uninit()
  
end

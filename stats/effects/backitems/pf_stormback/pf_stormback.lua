function init()
  script.setUpdateDelta(3)
  effect.addStatModifierGroup({{stat = "pf_mildBiomeLightningImmunity", amount = 1}})
end

function update(dt)
  animator.setFlipped(mcontroller.facingDirection() == -1)
end

function uninit()
  
end

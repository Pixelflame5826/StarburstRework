function init()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
  effect.setParentDirectives("fade=300030=0.8")
  effect.addStatModifierGroup({
    {stat = "jumpModifier", amount = -0.10},
	{stat = "fireResistance", amount = -0.5},
	{stat = "electricStatusImmunity", amount = 1.0},
	{stat = "electricResistance", amount = 0.7},
	{stat = "pf_isTarred", amount = 1.0}
  })
end

function update(dt)
  mcontroller.controlModifiers({
      groundMovementModifier = 0.7,
      speedModifier = 0.8,
      airJumpModifier = 0.90
    })
end

function uninit()

end

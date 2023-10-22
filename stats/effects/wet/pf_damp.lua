function init()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
  
  effect.addStatModifierGroup({
	{stat = "fireResistance", amount = 0.3},
	{stat = "fireStatusImmunity", amount = 1.0},
	{stat = "electricResistance", amount = -0.3}
  })
end

function update(dt)

end

function uninit()
  
end

function init()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
  
  effect.addStatModifierGroup({
	{stat = "iceResistance", amount = 0.5},
	{stat = "iceStatusImmunity", amount = 1.0},
	{stat = "poisonResistance", amount = -0.5},
	{stat = "pf_isSwamped", amount = 1.0}
  })
end

function update(dt)

end

function uninit()
  
end
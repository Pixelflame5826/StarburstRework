function init()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
  
  effect.addStatModifierGroup({
	{stat = "fireResistance", amount = 0.5},
	{stat = "fireStatusImmunity", amount = 1.0},
	{stat = "electricResistance", amount = -0.5},
	{stat = "pf_mildBiomeHeatImmunity", amount = 1},
	{stat = "pf_isWet", amount = 1.0}
  })
end

function update(dt)
  environmentStatus()
end

function uninit()
  
end

function environmentStatus(dt)
  local worldEffects = world.environmentStatusEffects(mcontroller.position())
  
  for _, statusEffect in ipairs(worldEffects) do
	if statusEffect == "biomecold" then
	  status.addEphemeralEffect("pf_wetcold")
	end
  end
  
end

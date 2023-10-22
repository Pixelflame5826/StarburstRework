function init()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
  
  self.outTime = 0.45
  
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
  
  if mcontroller.liquidPercentage() == 0 then
    self.outTime = self.outTime - dt
	if self.outTime <= 0 then
      effect.expire()
	end
  else
    self.outTime = 0.45
  end
end

function uninit()
  status.addEphemeralEffect("wet")
end

function environmentStatus(dt)
  local worldEffects = world.environmentStatusEffects(mcontroller.position())
  
  for _, statusEffect in ipairs(worldEffects) do
	if statusEffect == "biomecold" then
	  status.addEphemeralEffect("pf_wetcold")
	end
  end
  
end

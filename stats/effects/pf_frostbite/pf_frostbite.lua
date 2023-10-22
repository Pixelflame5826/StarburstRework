function init()
  animator.setParticleEmitterOffsetRegion("frost", mcontroller.boundBox())
  animator.setParticleEmitterActive("frost", true)
  effect.setParentDirectives("fade=8ed6f4=0.25")
  
  script.setUpdateDelta(5)

  self.tickDamagePercentage = 0.015
  self.tickTime = 1.0
  self.tickTimer = self.tickTime
  
  effect.addStatModifierGroup({
    {stat = "protection", effectiveMultiplier = 0.6},
	{stat = "physicalResistance", amount = -0.5},
	{stat = "fireResistance", amount = -1.5},
	{stat = "poisonResistance", amount = -0.5},
	{stat = "iceResistance", amount = -0.5},
	{stat = "electricResistance", amount = -0.5},
	{stat = "fireStatusImmunity", amount = 1.0}
  })
end

function update(dt)
  mcontroller.controlModifiers({
      groundMovementModifier = 0.4,
      speedModifier = 0.75,
      airJumpModifier = 0.9
    })
  status.removeEphemeralEffect("frostslow")
end

function uninit()
  
end

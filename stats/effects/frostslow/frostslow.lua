function init()
  animator.setParticleEmitterOffsetRegion("icetrail", mcontroller.boundBox())
  animator.setParticleEmitterActive("icetrail", true)
  effect.setParentDirectives("fade=00BBFF=0.15")

  script.setUpdateDelta(5)
  effect.addStatModifierGroup({
    {stat = "jumpModifier", amount = -0.15}
  })
end

function update(dt)
  if (status.stat("pf_isWet") >= 1.0) then
    status.addEphemeralEffect("pf_frostbite")
	effect.expire()
  end
  
  mcontroller.controlModifiers({
      groundMovementModifier = 0.3,
      speedModifier = 0.75,
      airJumpModifier = 0.85
    })
end

function uninit()

end

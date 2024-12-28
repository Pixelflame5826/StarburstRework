function init()

end

function update(dt)
  mcontroller.controlModifiers({
    groundMovementModifier = 0.9,
    speedModifier = 0.85,
    airJumpModifier = 0.9
  })

  if (status.stat("pf_tremorburst") >= 1.0) then
    status.addEphemeralEffect("pf_stagger")
	  effect.expire()
  end
end
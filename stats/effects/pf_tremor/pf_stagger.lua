function init()
  effect.setParentDirectives("fade=f0b514=0.4")
  animator.playSound("stagger_start")
  animator.setAnimationState("staggermessage", "on")
  animator.setAnimationRate(0)
  effect.addStatModifierGroup({
    {stat = "powerMultiplier", effectiveMultiplier = 0},
    {stat = "protection", effectiveMultiplier = 0.8},
	  {stat = "physicalResistance", amount = -0.25},
	  {stat = "fireResistance", amount = -0.25},
	  {stat = "poisonResistance", amount = -0.25},
	  {stat = "iceResistance", amount = -0.25},
	  {stat = "electricResistance", amount = -0.25},
    {stat = "pf_tremorImmunity", amount = 1}
  })

  if status.isResource("stunned") then
    status.setResource("stunned", math.max(status.resource("stunned"), effect.duration()))
  end

  mcontroller.setVelocity({0, 0})
end

function update(dt)
  mcontroller.controlModifiers({
    facingSuppressed = true,
    movementSuppressed = true
  })
  if status.resource("health") <= 0 then
    status.setResource("stunned", 0)
    effect.expire()
  end
end

function onExpire()
  animator.setAnimationRate(1)
end

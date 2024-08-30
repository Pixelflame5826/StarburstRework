function init()
  effect.addStatModifierGroup({
    {stat = "maxHealth", effectiveMultiplier = config.getParameter("healthBoost", 0)}, 
    {stat = "maxEnergy", effectiveMultiplier = config.getParameter("energyBoost", 0)}, 
    {stat = "powerMultiplier", effectiveMultiplier = config.getParameter("powerBoost", 0)}, 
    {stat = "protection", effectiveMultiplier = config.getParameter("protection", 0)}})
  script.setUpdateDelta(3)
end

function update(dt)
  animator.setFlipped(mcontroller.facingDirection() == -1)
end

function uninit()
  
end
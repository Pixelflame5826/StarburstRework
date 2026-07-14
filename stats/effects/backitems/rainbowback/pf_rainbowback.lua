function init()
  --Power
  self.powerModifier = config.getParameter("powerModifier", 0)
  effect.addStatModifierGroup({{stat = "powerMultiplier", effectiveMultiplier = self.powerModifier}})
end

function update(dt)
  animator.setFlipped(mcontroller.facingDirection() == -1)
  mcontroller.controlModifiers({
    speedModifier = 1.15
  })
end
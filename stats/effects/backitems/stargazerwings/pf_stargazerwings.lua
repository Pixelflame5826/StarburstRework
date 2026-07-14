function init()
  self.jumpModifier = config.getParameter("jumpModifier", 0)

  effect.addStatModifierGroup({
    {stat = "maxEnergy", effectiveMultiplier = config.getParameter("energyModifier", 1)}, 
    {stat = "fallDamageMultiplier", effectiveMultiplier = config.getParameter("falldamageMultiplier", 1)},
    {stat = "jumpModifier", amount = self.jumpModifier}
  })
end

function update(dt)
  mcontroller.controlModifiers({
    airJumpModifier = 1 + self.jumpModifier
  })
end
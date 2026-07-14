function init()
  self.movementParameters = config.getParameter("movementParameters", {})

  effect.addStatModifierGroup({
    {stat = "maxBreath", amount = config.getParameter("breathAmount", 0)},
    {stat = "breathDepletionRate", effectiveMultiplier = config.getParameter("breathRate", 1.0)},
  })
end

function update(dt)
  mcontroller.controlParameters(self.movementParameters)
end

function uninit()
end

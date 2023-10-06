function init()
  effect.addStatModifierGroup({
    {stat = "maxBreath", amount = config.getParameter("breathAmount", 0)},
    {stat = "breathDepletionRate", effectiveMultiplier = config.getParameter("breathRate", 1.0)},
  })

  script.setUpdateDelta(0)
end

function update(dt)
end

function uninit()
end

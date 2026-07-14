function init()
  effect.addStatModifierGroup({{stat = "fallDamageMultiplier", effectiveMultiplier = 0.5}, {stat = "jumpModifier", amount = 0.20}})
end

function update(dt)
  mcontroller.controlModifiers({
    airJumpModifier = 1.20,
    speedModifier = 1.10
  })
end
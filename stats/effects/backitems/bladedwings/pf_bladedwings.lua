function init()
  --Power
  self.powerModifier = config.getParameter("powerModifier", 0)
  effect.addStatModifierGroup({{stat = "powerMultiplier", effectiveMultiplier = self.powerModifier}})
  
  --Jump Height
  effect.addStatModifierGroup({
    {stat = "jumpModifier", amount = 0.1}
  })
end


function update(dt)
  mcontroller.controlModifiers({
    airJumpModifier = 1.10
  })
end

function uninit()

end

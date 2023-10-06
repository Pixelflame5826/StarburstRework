function init()
  --Power
  self.powerModifier = config.getParameter("powerModifier", 0)
  effect.addStatModifierGroup({{stat = "powerMultiplier", effectiveMultiplier = self.powerModifier}})
  
end


function update(dt)
  mcontroller.controlModifiers({
    airJumpModifier = 1.10
  })
end

function uninit()

end

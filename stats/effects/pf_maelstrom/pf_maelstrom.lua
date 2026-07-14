function init()
  --Power
  self.powerModifier = config.getParameter("powerModifier", 0)

  damageEffect = effect.addStatModifierGroup({})
end


function update(dt)
  if (status.stat("pf_isWet") >= 1.0) then
    effect.setStatModifierGroup(damageEffect, {{stat = "powerMultiplier", effectiveMultiplier = 1 + self.powerModifier}})
  elseif (status.stat("pf_isDamp") >= 1.0) then
    effect.setStatModifierGroup(damageEffect, {{stat = "powerMultiplier", effectiveMultiplier = 1 + (self.powerModifier / 2)}})
  else 
    effect.setStatModifierGroup(damageEffect, {})
  end
end

function uninit()

end

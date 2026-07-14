function init()
  --Power
  self.powerModifier = config.getParameter("powerModifier", 0)
  effect.addStatModifierGroup({
    {stat = "powerMultiplier", effectiveMultiplier = self.powerModifier},
    {stat = "fireStatusImmunity", amount = 1}, 
    {stat = "lavaImmunity", amount = 1}
  })
end
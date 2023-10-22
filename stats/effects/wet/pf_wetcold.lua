function init()
  self.movementModifiers = config.getParameter("movementModifiers", {})

  self.energyCost = config.getParameter("energyCost", 1)
  
  script.setUpdateDelta(config.getParameter("tickRate", 1))

  effect.addStatModifierGroup({{stat = "energyRegenPercentageRate", effectiveMultiplier = 0}})

  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_coldwater", 5.0)
end

function update(dt)
  if (world.entityType(entity.id()) == "player") then   
    mcontroller.controlModifiers(self.movementModifiers)
  
    status.overConsumeResource("energy", self.energyCost)
  end
end

function uninit()

end

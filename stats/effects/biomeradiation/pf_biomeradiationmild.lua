function init()
  if (world.entityType(entity.id()) == "player") then
    effect.setParentDirectives(config.getParameter("directives", ""))
  end
  
  -- Hazard Radio Message
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildbiomeradiation", 5.0)
  -- Tutorial Radio Messages
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_a", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_b", 5.0)

  self.healthPercentage = config.getParameter("healthPercentage", 0.1)
end

function update(dt)
  if (world.entityType(entity.id()) == "player") then   
    status.setResourcePercentage("health", math.min(status.resourcePercentage("health"), self.healthPercentage))
  end
end

function uninit()

end

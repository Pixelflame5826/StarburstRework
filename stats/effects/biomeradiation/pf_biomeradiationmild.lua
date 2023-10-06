function init()
  if (world.entityType(entity.id()) == "player") then
    effect.setParentDirectives(config.getParameter("directives", ""))
  end
  
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildbiomeradiation", 5.0)
  self.healthPercentage = config.getParameter("healthPercentage", 0.1)
end

function update(dt)
  if (world.entityType(entity.id()) == "player") then   
    status.setResourcePercentage("health", math.min(status.resourcePercentage("health"), self.healthPercentage))
  end
end

function uninit()

end

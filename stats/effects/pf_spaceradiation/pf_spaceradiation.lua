function init()
  effect.setParentDirectives(config.getParameter("directives", ""))

  -- Hazard Radio Message
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_spaceradiation", 5.0)
  -- Tutorial Radio Messages
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_spacehazardtutorial_a", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_spacehazardtutorial_b", 5.0)

  self.healthPercentage = config.getParameter("healthPercentage", 0.1)
end

function update(dt)
  status.setResourcePercentage("health", math.min(status.resourcePercentage("health"), self.healthPercentage))
end

function uninit()

end

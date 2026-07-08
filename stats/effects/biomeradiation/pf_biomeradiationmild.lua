function init()
  if (world.entityType(entity.id()) == "player") then
    effect.setParentDirectives(config.getParameter("directives", ""))
  end

  self.healthPercentage = config.getParameter("healthPercentage", 0.1)

  -- Tutorial Radio Messages
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildbiomeradiation", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_a", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_b", 5.0)

  -- Visual Warning
  world.sendEntityMessage(entity.id(), "biomeHazard", "pf_biomeradiationmild")
end

function update(dt)
  if (world.entityType(entity.id()) == "player") then   
    status.setResourcePercentage("health", math.min(status.resourcePercentage("health"), self.healthPercentage))
  end
end

function uninit()

end

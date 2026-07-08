function init()
  effect.setParentDirectives(config.getParameter("directives", ""))

  self.healthPercentage = config.getParameter("healthPercentage", 0.1)

  -- Tutorial Radio Messages
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "biomeradiation", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_deadlyhazardtutorial_a", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_deadlyhazardtutorial_b", 5.0)

  -- Visual Warning
  world.sendEntityMessage(entity.id(), "biomeHazard", "pf_biomeradiation")
end

function update(dt)
  if (status.stat("pf_mildBiomeRadiationImmunity") >= 1.0) then
    status.setResourcePercentage("health", math.min(status.resourcePercentage("health"), self.healthPercentage * 2 ))
  else
    status.setResourcePercentage("health", math.min(status.resourcePercentage("health"), self.healthPercentage))
  end
end

function uninit()

end

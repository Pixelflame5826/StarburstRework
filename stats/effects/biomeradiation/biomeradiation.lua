function init()
  effect.setParentDirectives(config.getParameter("directives", ""))
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "biomeradiation", 5.0)
  self.healthPercentage = config.getParameter("healthPercentage", 0.1)
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

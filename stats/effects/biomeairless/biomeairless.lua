function init()
  -- Hazard Radio Message
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "biomeairless", 5.0)
  -- Tutorial Radio Messages
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_a", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_b", 5.0)
end

function update(dt)
end

function uninit()
end

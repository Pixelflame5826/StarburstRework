function init()
  effect.setParentDirectives(config.getParameter("directives", ""))
  script.setUpdateDelta(2)

  self.tickRate = config.getParameter("tickRate")
  self.tickDamage = config.getParameter("tickDamage")

  self.tickTimer = self.tickRate

  -- Hazard Radio Message
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_spacedebris", 5.0)
  -- Tutorial Radio Messages
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_spacehazardtutorial_a", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_spacehazardtutorial_b", 5.0)
end

function update(dt)
  self.tickTimer = math.max(0, self.tickTimer - dt)
  if self.tickTimer == 0 and mcontroller.onGround() then
    self.tickTimer = self.tickRate
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = self.tickDamage,
        damageSourceKind = "shotgunbullet",
        sourceEntityId = entity.id()
      })
  end
end

function uninit()

end

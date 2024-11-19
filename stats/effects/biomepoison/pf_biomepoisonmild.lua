function init()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  
  if (world.entityType(entity.id()) == "player") then   
    animator.setParticleEmitterActive("drips", true)
  end

  script.setUpdateDelta(5)

  self.tickDamagePercentage = 0.005
  self.tickTime = 15.0
  self.tickTimer = self.tickTime

  -- Hazard Radio Message
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildbiomepoison", 5.0)
  -- Tutorial Radio Messages
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_a", 5.0)
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_mildhazardtutorial_b", 5.0)
end

function update(dt)
  self.tickTimer = self.tickTimer - dt
  if (self.tickTimer <= 0 and world.entityType(entity.id()) == "player")  then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "poison",
        sourceEntityId = entity.id()
      })
  end
end

function uninit()

end

function init()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)

  script.setUpdateDelta(5)

  self.tickDamagePercentage = config.getParameter("damageOverTime", 0.01)
  self.tickTime = 4.0
  self.tickTimer = self.tickTime
  self.maxHealthTimer = self.tickTime * 5
  
  self.maxHealthPercent = 1.0
  
  self.maxHealthDrain = config.getParameter("healthDrain", 0.03)
  
  self.healthPercentage = config.getParameter("healthPercentage", 0.2)
  
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "pf_biomepoison", 5.0)
end

function update(dt)
  self.tickTimer = self.tickTimer - dt
  self.maxHealthTimer = self.maxHealthTimer - dt
  
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "poison",
        sourceEntityId = entity.id()
      })
  end
  
  if self.maxHealthTimer <= 0 then
    self.maxHealthTimer = self.tickTime * 5
    if not (status.stat("pf_mildBiomePoisonImmunity") >= 1.0) then
      self.maxHealthPercent = self.maxHealthPercent - self.maxHealthDrain
	end
  end
  
  status.setResourcePercentage("health", math.min(status.resourcePercentage("health"), self.maxHealthPercent))
end

function uninit()

end

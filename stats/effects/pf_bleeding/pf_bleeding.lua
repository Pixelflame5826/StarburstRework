function init()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)

  script.setUpdateDelta(5)

  self.tickDamagePercentage = config.getParameter("damage", 0.015)
  self.tickTime = 1.0
  self.tickTimer = self.tickTime
  
  effect.addStatModifierGroup({
	  {stat = "healingStatusImmunity", amount = 1}
    })
end

function update(dt)
  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "default",
        sourceEntityId = entity.id()
      })
  end
end

function uninit()

end

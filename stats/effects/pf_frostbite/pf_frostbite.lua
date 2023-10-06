function init()
  animator.setParticleEmitterOffsetRegion("frost", mcontroller.boundBox())
  animator.setParticleEmitterActive("frost", true)
  effect.setParentDirectives("fade=8ed6f4=0.25")
  
  script.setUpdateDelta(5)

  self.tickDamagePercentage = 0.015
  self.tickTime = 1.0
  self.tickTimer = self.tickTime
  
  effect.addStatModifierGroup({
    {stat = "protection", effectiveMultiplier = 0.9}
  })
end

function update(dt)

  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "ice",
        sourceEntityId = entity.id()
      })
  end
end

function uninit()
  
end

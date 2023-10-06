function init()
  animator.setParticleEmitterOffsetRegion("shadow", mcontroller.boundBox())
  animator.setParticleEmitterActive("shadow", true)
  
  effect.setParentDirectives("fade=5a0000=0.9")

  self.movementModifiers = config.getParameter("movementModifiers", {})
  
  script.setUpdateDelta(10)

  effect.addStatModifierGroup({{stat = "maxEnergy", effectiveMultiplier = 0.75}})

  self.tickDamagePercentage = 0.07
  self.tickTime = 1.0
  self.tickTimer = self.tickTime
end

function update(dt)
  mcontroller.controlModifiers(self.movementModifiers)
  
  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "plasma",
        sourceEntityId = entity.id()
      })
  end
end

function uninit()

end

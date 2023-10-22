function init()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)

  script.setUpdateDelta(5)

  self.tickDamagePercentage = 0.025
  self.tickTime = 1.0
  self.tickTimer = self.tickTime
end

function update(dt)
  if (status.stat("pf_isSwamped") >= 1.0) then
    status.addEphemeralEffect("pf_septicpoison")
	effect.expire()
  end

  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "poison",
        sourceEntityId = entity.id()
      })
  end

  effect.setParentDirectives(string.format("fade=00AA00=%.1f", self.tickTimer * 0.4))
end

function uninit()

end

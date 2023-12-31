require "/scripts/util.lua"

function init()
  animator.setParticleEmitterOffsetRegion("sparks", mcontroller.boundBox())
  animator.setParticleEmitterActive("sparks", true)
  effect.setParentDirectives("fade=7733AA=0.25")

  script.setUpdateDelta(5)

  self.damageClampRange = config.getParameter("damageClampRange")

  self.tickTime = config.getParameter("boltInterval", 1.0)
  self.tickTimer = self.tickTime
  
  self.healthDamage = ((status.resourceMax("health") * config.getParameter("healthDamageFactor", 1.0)) / 2)
end

function update(dt)
  self.tickTimer = self.tickTimer - dt
  local boltPower = util.clamp(status.resourceMax("health") * config.getParameter("healthDamageFactor", 1.0), self.damageClampRange[1], self.damageClampRange[2])
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
	
	status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = self.healthDamage,
        damageSourceKind = "electric",
        sourceEntityId = entity.id()
    })
	
    local targetIds = world.entityQuery(mcontroller.position(), config.getParameter("jumpDistance", 8), {
      withoutEntityId = entity.id(),
      includedTypes = {"creature"}
    })

    shuffle(targetIds)

    for i,id in ipairs(targetIds) do
      local sourceEntityId = effect.sourceEntity() or entity.id()
      if world.entityCanDamage(sourceEntityId, id) and not world.lineTileCollision(mcontroller.position(), world.entityPosition(id)) then
        local sourceDamageTeam = world.entityDamageTeam(sourceEntityId)
        local directionTo = world.distance(world.entityPosition(id), mcontroller.position())
        world.spawnProjectile(
          "teslaboltsmall",
          mcontroller.position(),
          entity.id(),
          directionTo,
          false,
          {
            power = boltPower,
            damageTeam = sourceDamageTeam,
			statusEffects = { "electrified" }
          }
        )
        animator.playSound("bolt")
        return
      end
    end
  end
  status.removeEphemeralEffect("electrified")
end

function uninit()

end

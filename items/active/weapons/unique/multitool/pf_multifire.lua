require "/scripts/interp.lua"
require "/scripts/vec2.lua"
require "/scripts/util.lua"

MultiFire = WeaponAbility:new()

function MultiFire:init()
  self.weapon:setStance(self.stances.idle)

  self.projectileMode = config.getParameter("projectileMode", "projectile")

  self.impactSoundTimer = 0

  self.cooldownTimer = self.fireTime

  self.weapon.onLeaveAbility = function()
    activeItem.setScriptedAnimationParameter("chains", {})
    animator.setParticleEmitterActive("beamCollision", false)
    animator.stopAllSounds("fireLoop")
    self.weapon:setStance(self.stances.idle)
  end
end

function MultiFire:update(dt, fireMode, shiftHeld)
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  self.cooldownTimer = math.max(0, self.cooldownTimer - self.dt)
  self.impactSoundTimer = math.max(self.impactSoundTimer - self.dt, 0)

  if self.fireMode == (self.activatingFireMode or self.abilitySlot)
    and not self.weapon.currentAbility
    and not status.resourceLocked("energy")
    and self.cooldownTimer == 0 then
    
    if self.projectileMode == "projectile" then
      if not world.lineTileCollision(mcontroller.position(), self:firePosition()) then
        if self.fireType == "auto" and status.overConsumeResource("energy", self:energyPerShot()) then
          self:setState(self.autoFire)
        elseif self.fireType == "burst" then
          self:setState(self.burstFire)
        end
      end
    elseif self.projectileMode == "beam" then
      if not self:blocked() then
        self:setState(self.beamFire)
      end
    end
  end
end

function MultiFire:blocked()
  local startLine = mcontroller.position()
  local endLine = self:firePosition()
  local inBlock = vec2.floor(endLine)
  for _,block in ipairs(world.collisionBlocksAlongLine(startLine, endLine)) do
    if not compare(block, inBlock) then
      return true
    end
  end
  return false
end

function MultiFire:beamFire()
  self.weapon:setStance(self.stances.beamFire)

  animator.playSound("fireStart")
  animator.playSound("fireLoop", -1)

  local wasColliding = false
  local damageTimer = 0
  while self.fireMode == (self.activatingFireMode or self.abilitySlot)
      and not self:blocked()
      and status.overConsumeResource("energy", (self.energyUsage or 0) * self.dt) do
    local beamStart = self:firePosition()
    local aimDir = self:aimVector(0)
    local beamLength = self.beamLength
    local beamEnd = vec2.add(beamStart, vec2.mul(vec2.norm(aimDir), beamLength))

    local collidePoint = world.lineCollision(beamStart, beamEnd)
    local tileCollisionPoint = world.lineTileCollisionPoint(beamStart, beamEnd)
    if collidePoint and tileCollisionPoint then
      beamEnd = collidePoint

      beamLength = world.magnitude(beamStart, beamEnd)

      animator.setParticleEmitterActive("beamCollision", true)
      animator.resetTransformationGroup("beamEnd")
      animator.translateTransformationGroup("beamEnd", {beamLength, 0})

      if self.impactSoundTimer == 0 then
        animator.setSoundPosition("beamImpact", {self.beamLength, 0})
        animator.playSound("beamImpact")
        self.impactSoundTimer = self.damageInterval
      end
      
      damageTimer = damageTimer - script.updateDt()
      while damageTimer <= 0 do
        damageTimer = damageTimer + self.damageInterval

        local collideX = tileCollisionPoint[1][1]
        local collideY = tileCollisionPoint[1][2]
        if tileCollisionPoint[2][1] > 0 then
          collideX = math.ceil(collideX)
        else
          collideX = math.floor(collideX)
        end
        if tileCollisionPoint[2][2] > 0 then
          collideY = math.ceil(collideY)
        else
          collideY = math.floor(collideY)
        end
        if tileCollisionPoint[2][1] < 0 then
          collideX = collideX - 1
        end
        if tileCollisionPoint[2][2] < 0 then
          collideY = collideY - 1
        end
        local collideTile = {collideX, collideY}
        if vec2.mag(tileCollisionPoint[2]) == 0 then
          collideTile = vec2.floor(self:firePosition())
        end
        world.debugPoint(tileCollisionPoint[1], "yellow")
        world.debugLine(tileCollisionPoint[1], vec2.add(tileCollisionPoint[1], tileCollisionPoint[2]), "yellow")
        world.debugPoint(collideTile, "red")
        
        world.damageTiles({collideTile}, "foreground", self:firePosition(), "blockish", self.tileDamage, self.harvestLevel, activeItem.ownerEntityId())
      end
    else
      animator.setParticleEmitterActive("beamCollision", false)
    end

    self:drawBeam(beamEnd, collidePoint)

    coroutine.yield()
  end

  self:reset()
  animator.playSound("fireEnd")
end

function MultiFire:drawBeam(endPos, didCollide)
  local newChain = copy(self.chain)
  newChain.startOffset = self.weapon.muzzleOffset
  newChain.endPosition = endPos

  if didCollide then
    newChain.endSegmentImage = nil
  end

  activeItem.setScriptedAnimationParameter("chains", {newChain})
end

function MultiFire:autoFire()
  self.weapon:setStance(self.stances.gunFire)

  self:fireProjectile()
  self:muzzleFlash()

  if self.stances.gunFire.duration then
    util.wait(self.stances.gunFire.duration)
  end

  self.cooldownTimer = self.fireTime
  self:setState(self.cooldown)
end

function MultiFire:burstFire()
  self.weapon:setStance(self.stances.gunFire)

  local shots = self.burstCount
  while shots > 0 and status.overConsumeResource("energy", self:energyPerShot()) do
    self:fireProjectile()
    self:muzzleFlash()
    shots = shots - 1

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(1 - shots / self.burstCount, 0, self.stances.gunFire.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(1 - shots / self.burstCount, 0, self.stances.gunFire.armRotation))

    util.wait(self.burstTime)
  end

  self.cooldownTimer = (self.fireTime - self.burstTime) * self.burstCount
end

function MultiFire:muzzleFlash()
  animator.setPartTag("muzzleFlash", "variant", math.random(1, self.muzzleFlashVariants or 3))
  animator.setAnimationState("firing", "fire")
  animator.burstParticleEmitter("muzzleFlash")
  animator.playSound("gunFire")

  animator.setLightActive("muzzleFlash", true)
end

function MultiFire:cooldown()
  self.weapon:setStance(self.stances.cooldown)
  self.weapon:updateAim()

  local progress = 0
  util.wait(self.stances.cooldown.duration, function()
    local from = self.stances.cooldown.weaponOffset or {0,0}
    local to = self.stances.idle.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.cooldown.weaponRotation, self.stances.idle.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.cooldown.armRotation, self.stances.idle.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.cooldown.duration))
  end)
end

function MultiFire:fireProjectile(projectileType, projectileParams, inaccuracy, firePosition, projectileCount)
  local params = sb.jsonMerge(self.projectileParameters, projectileParams or {})
  params.power = self:damagePerShot()
  params.powerMultiplier = activeItem.ownerPowerMultiplier()
  params.speed = util.randomInRange(params.speed)

  if not projectileType then
    projectileType = self.projectileType
  end
  if type(projectileType) == "table" then
    projectileType = projectileType[math.random(#projectileType)]
  end

  local projectileId = 0
  for i = 1, (projectileCount or self.projectileCount) do
    if params.timeToLive then
      params.timeToLive = util.randomInRange(params.timeToLive)
    end

    projectileId = world.spawnProjectile(
        projectileType,
        firePosition or self:firePosition(),
        activeItem.ownerEntityId(),
        self:aimVector(inaccuracy or self.inaccuracy),
        false,
        params
      )
  end
  return projectileId
end

function MultiFire:energyPerShot()
  return self.energyUsage * self.fireTime * (self.energyUsageMultiplier or 1.0)
end

function MultiFire:damagePerShot()
  return (self.baseDamage or (self.baseDps * self.fireTime)) * (self.baseDamageMultiplier or 1.0) * config.getParameter("damageLevelMultiplier") / self.projectileCount
end

function MultiFire:firePosition()
  return vec2.add(mcontroller.position(), activeItem.handPosition(self.weapon.muzzleOffset))
end

function MultiFire:aimVector(inaccuracy)
  local aimVector = vec2.rotate({1, 0}, self.weapon.aimAngle + sb.nrand(inaccuracy, 0))
  aimVector[1] = aimVector[1] * mcontroller.facingDirection()
  return aimVector
end

function MultiFire:uninit()
  self:reset()
end

function MultiFire:reset()
  self.weapon:setDamage()
  activeItem.setScriptedAnimationParameter("chains", {})
  animator.setParticleEmitterActive("beamCollision", false)
  animator.stopAllSounds("fireStart")
  animator.stopAllSounds("fireLoop")
end

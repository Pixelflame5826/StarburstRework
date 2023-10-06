require "/scripts/util.lua"
require "/scripts/interp.lua"
require "/scripts/status.lua"
require "/scripts/poly.lua"
require "/items/active/weapons/weapon.lua"

pf_MasterSpin = WeaponAbility:new()

function pf_MasterSpin:init()
  status.clearPersistentEffects("weaponMovementAbility")
  
  self.cooldownTimer = self.cooldownTime
  
  storage.projectiles = storage.projectiles or {}
  
  self.projectileDelay = config.getParameter("projectileDelay", 0.05)
  
  self.baseDamageFactor = config.getParameter("baseDamageFactor", 1.0)
end

function pf_MasterSpin:update(dt, fireMode, shiftHeld)
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  self.cooldownTimer = math.max(0, self.cooldownTimer - self.dt)

  if not self.weapon.currentAbility
     and self.cooldownTimer == 0
     and self.fireMode == "alt"
     and mcontroller.onGround()
     and not status.statPositive("activeMovementAbilities")
     and status.overConsumeResource("energy", self.energyUsage) then

    self:setState(self.windup)
  end
  
  self:updateProjectiles()
end

-- Attack state: windup
function pf_MasterSpin:windup()
  self.projectileSwitch = true
  self.weapon:setStance(self.stances.windup)
  self.weapon:updateAim()
  
  status.setPersistentEffects("weaponMovementAbility", {{stat = "activeMovementAbilities", amount = 1}})

  util.wait(self.stances.windup.duration, function(dt)
      mcontroller.controlCrouch()
    end)

  self:setState(self.activate)
end

-- Attack state: fire

function pf_MasterSpin:activate()
  self.weapon:setStance(self.stances.flip)
  self.weapon:updateAim()

  animator.setAnimationState("swoosh", "flip")
  animator.playSound(self.fireSound or "flipSlash")
  animator.setParticleEmitterActive("flip", true)

  self.flipTime = self.rotations * self.rotationTime
  self.flipTimer = 0

  self.jumpTimer = self.jumpDuration
  
  
  self.stallTimer = self.stallDuration

  while self.flipTimer < self.flipTime do
    self.flipTimer = self.flipTimer + self.dt

    mcontroller.controlParameters(self.flipMovementParameters)

    if self.jumpTimer > 0 then
      self.jumpTimer = self.jumpTimer - self.dt
      mcontroller.setVelocity({self.jumpVelocity[1], self.jumpVelocity[2]})
	else
	  if self.stallTimer > 0 then
        mcontroller.setVelocity({0, 0})
	  end
	  if self.projectileSwitch then
	    self:createProjectiles()
		self.projectileSwitch = false
	  end
    end

    local damageArea = partDamageArea("swoosh")
    self.weapon:setDamage(self.damageConfig, damageArea, self.fireTime)

    mcontroller.setRotation(-math.pi * 2 * self.weapon.aimDirection * (self.flipTimer / self.rotationTime))
	
    coroutine.yield()
  end

  status.clearPersistentEffects("weaponMovementAbility")
  
  if #storage.projectiles > 0 then
    for _, projectileId in pairs(storage.projectiles) do
      if world.entityExists(projectileId) then
        world.sendEntityMessage(projectileId, "trigger", self.projectileDelay)
      end
    end
  end

  animator.setAnimationState("swoosh", "idle")
  mcontroller.setRotation(0)
  animator.setParticleEmitterActive("flip", false)
  self.cooldownTimer = self.cooldownTime
end

function pf_MasterSpin:uninit(final)
  if final then
    self:killProjectiles()
  end
end

function pf_MasterSpin:createProjectiles()
  local aimPosition = activeItem.ownerAimPosition()
  local fireDirection = world.distance(aimPosition, self:focusPosition())[1] > 0 and 1 or -1
  local pOffset = {fireDirection * (self.projectileDistance or 0), 0}
  local basePos = mcontroller.position()

  local pCount = self.projectileCount or 1

  local pParams = copy(self.projectileParameters)
  pParams.power = self.baseDamageFactor * pParams.baseDamage * config.getParameter("damageLevelMultiplier") / pCount
  pParams.powerMultiplier = activeItem.ownerPowerMultiplier()

  for i = 1, pCount do
    local projectileId = world.spawnProjectile(
        self.projectileType,
        vec2.add(basePos, pOffset),
        activeItem.ownerEntityId(),
        pOffset,
        false,
        pParams
      )

    if projectileId then
      table.insert(storage.projectiles, projectileId)
      world.sendEntityMessage(projectileId, "updateProjectile", aimPosition)
    end

    pOffset = vec2.rotate(pOffset, (2 * math.pi) / pCount)
  end
end

function pf_MasterSpin:focusPosition()
  return vec2.add(mcontroller.position(), mcontroller.position())
end

function pf_MasterSpin:updateProjectiles()
  local aimPosition = activeItem.ownerAimPosition()
  local newProjectiles = {}
  for _, projectileId in pairs(storage.projectiles) do
    if world.entityExists(projectileId) then
      local projectileResponse = world.sendEntityMessage(projectileId, "updateProjectile", aimPosition)
      if projectileResponse:finished() then
        local newIds = projectileResponse:result()
        if type(newIds) ~= "table" then
          newIds = {newIds}
        end
        for _, newId in pairs(newIds) do
          table.insert(newProjectiles, newId)
        end
      end
    end
  end
  storage.projectiles = newProjectiles
end

function pf_MasterSpin:killProjectiles()
  for _, projectileId in pairs(storage.projectiles) do
    if world.entityExists(projectileId) then
      world.sendEntityMessage(projectileId, "kill")
    end
  end
end


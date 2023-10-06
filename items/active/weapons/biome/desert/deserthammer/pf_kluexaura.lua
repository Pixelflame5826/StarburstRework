require "/scripts/util.lua"
require "/scripts/interp.lua"
require "/scripts/poly.lua"
require "/items/active/weapons/weapon.lua"

pf_KluexAura = WeaponAbility:new()

function pf_KluexAura:init()
  self:reset()
  self.cooldownTimer = self.cooldownTime
  self.activeTimer = 0
  
  storage.projectiles = storage.projectiles or {}
  
  self.projectileDelay = config.getParameter("projectileDelay", 1.0)
  
  self.baseDamageFactor = config.getParameter("baseDamageFactor", 1.0)
end

function pf_KluexAura:update(dt, fireMode, shiftHeld)
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  self.cooldownTimer = math.max(0, self.cooldownTimer - self.dt)

  if self.weapon.currentAbility == nil
    and self.cooldownTimer == 0
    and self.fireMode == "alt"
    and not status.resourceLocked("energy")
    and status.resource("energy") >= self.energyUsage * (self.minChargeTime / self.chargeTime) then

    self:setState(self.windup)
  end

  if self.active then
    self.activeTimer = math.max(0, self.activeTimer - self.dt)
    if self.activeTimer > 0 then
      self.weapon:setOwnerDamage(self.damageConfig, self.damagePoly)
    else
      self:deactivate()
    end
  end
  
  if self.active then
    self:updateProjectiles()
  end
end

-- Attack state: windup
function pf_KluexAura:windup()
  self.weapon:setStance(self.stances.windup)
  self.weapon:updateAim()

  animator.setParticleEmitterActive(self.weapon.elementalType.."Charge", true)
  animator.playSound(self.weapon.elementalType.."charge")

  local wasFull = false
  local chargeTimer = 0
  while self.fireMode == "alt" and (chargeTimer == self.chargeTime or status.overConsumeResource("energy", (self.energyUsage / self.chargeTime) * self.dt)) do
    chargeTimer = math.min(self.chargeTime, chargeTimer + self.dt)

    if chargeTimer == self.chargeTime and not wasFull then
      wasFull = true
      animator.stopAllSounds(self.weapon.elementalType.."charge")
      animator.playSound(self.weapon.elementalType.."full", -1)
    end

    local chargeRatio = math.sin(chargeTimer / self.chargeTime * 1.57)
    self.weapon.relativeArmRotation = util.toRadians(util.lerp(chargeRatio, {self.stances.windup.armRotation, self.stances.windup.endArmRotation}))
    self.weapon.relativeWeaponRotation = util.toRadians(util.lerp(chargeRatio, {self.stances.windup.weaponRotation, self.stances.windup.endWeaponRotation}))

    coroutine.yield()
  end

  animator.setParticleEmitterActive(self.weapon.elementalType.."Charge", false)
  animator.stopAllSounds(self.weapon.elementalType.."charge")
  animator.stopAllSounds(self.weapon.elementalType.."full")

  if chargeTimer > self.minChargeTime then
    self.activeTimer = self.duration * (chargeTimer / self.chargeTime)
    self:setState(self.fire)
  end
end

-- Attack state: fire
function pf_KluexAura:fire()
  self.weapon:setStance(self.stances.fire)

  self:activate()

  util.wait(self.stances.fire.duration)

  self.cooldownTimer = self.cooldownTime
end

function pf_KluexAura:activate()
  status.setPersistentEffects("elementalAura", { "pf_kluexaura" })
  animator.playSound(self.weapon.elementalType.."activate")
  if not self.active then
    animator.playSound(self.weapon.elementalType.."active", -1)
  end
  self.active = true
  
  self:createProjectiles()
  
  if #storage.projectiles > 0 then
    for _, projectileId in pairs(storage.projectiles) do
      if world.entityExists(projectileId) then
        world.sendEntityMessage(projectileId, "trigger", self.projectileDelay)
      end
    end
  end
end

function pf_KluexAura:deactivate()
  status.clearPersistentEffects("elementalAura")
  animator.stopAllSounds(self.weapon.elementalType.."active")
  animator.playSound(self.weapon.elementalType.."deactivate")
  self.active = false
end

function pf_KluexAura:reset()
  animator.setParticleEmitterActive(self.weapon.elementalType.."Charge", false)
  animator.stopAllSounds(self.weapon.elementalType.."charge")
  animator.stopAllSounds(self.weapon.elementalType.."full")
end

function pf_KluexAura:uninit(final)
  if final then
    status.clearPersistentEffects("elementalAura")
    animator.stopAllSounds(self.weapon.elementalType.."active")
  end
  if final then
    self:killProjectiles()
  end
  self:reset()
end

function pf_KluexAura:createProjectiles()
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

function pf_KluexAura:focusPosition()
  return vec2.add(mcontroller.position(), mcontroller.position())
end

function pf_KluexAura:updateProjectiles()
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

function pf_KluexAura:killProjectiles()
  for _, projectileId in pairs(storage.projectiles) do
    if world.entityExists(projectileId) then
      world.sendEntityMessage(projectileId, "kill")
    end
  end
end


require "/scripts/util.lua"
require "/scripts/status.lua"
require "/items/active/weapons/weapon.lua"

pf_elementalParry = WeaponAbility:new()

function pf_elementalParry:init()
  self.cooldownTimer = 0
end

function pf_elementalParry:update(dt, fireMode, shiftHeld)
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  self.cooldownTimer = math.max(0, self.cooldownTimer - dt)

  if self.weapon.currentAbility == nil
    and fireMode == "alt"
    and self.cooldownTimer == 0
    and status.overConsumeResource("energy", self.energyUsage) then

    self:setState(self.parry)
  end
end

function pf_elementalParry:parry()
  self.weapon:setStance(self.stances.parry)
  self.weapon:updateAim()
  animator.setParticleEmitterActive(self.weapon.elementalType.."ParryShield", true)

  status.setPersistentEffects("broadswordParry", {{stat = "shieldHealth", amount = self.shieldHealth}})

  local blockPoly = animator.partPoly("parryShield", "shieldPoly")
  activeItem.setItemShieldPolys({blockPoly})
  
  local damageArea = partDamageArea("parryShield")
  self.weapon:setDamage(self.damageConfig, damageArea)

  animator.setAnimationState("parryShield", "active")
  animator.playSound("guard")

  local damageListener = damageListener("damageTaken", function(notifications)
    for _,notification in pairs(notifications) do
      if notification.sourceEntityId ~= -65536 and notification.healthLost == 0 then
        animator.playSound("parry")
        animator.setAnimationState("parryShield", "block")
        return
      end
    end
  end)

  util.wait(self.parryTime, function(dt)
    --Interrupt when running out of shield stamina
    if not status.resourcePositive("shieldStamina") then return true end

    damageListener:update()
  end)

  self.cooldownTimer = self.cooldownTime
  activeItem.setItemShieldPolys({})
end

function pf_elementalParry:reset()
  animator.setAnimationState("parryShield", "inactive")
  status.clearPersistentEffects("broadswordParry")
  animator.setParticleEmitterActive(self.weapon.elementalType.."ParryShield", false)
  activeItem.setItemShieldPolys({})
  self.weapon:setDamage()
end

function pf_elementalParry:uninit()
  self:reset()
end

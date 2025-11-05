AmmoSwap = WeaponAbility:new()

function AmmoSwap:init()
  table.insert(self.ammoTypes, 1, config.getParameter("primaryAbility")) 

  self.ammoIndex = math.min(config.getParameter("ammoIndex", 1), #self.ammoTypes)
  self.ammoTimer = 0
  
  self.weapon.onLeaveAbility = function()
    self.weapon:setStance(self.stances.idle)
  end
end

function AmmoSwap:update(dt, fireMode, shiftHeld)
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  if not self.weapon.currentAbility and self.fireMode == (self.activatingFireMode or self.abilitySlot) and self.ammoTimer <= 0 then
    if self.animated then
      self:setState(self.switchInsert)
    else
      self:setState(self.switch)
    end
  end

  if self.ammoIndex ~= 1 and self.singleShot and (animator.animationState("firing") == "fire") then
    self.ammoTimer = self.ammoCooldown
    self.ammoIndex = 1
    activeItem.setInstanceValue("ammoIndex", self.ammoIndex)
    self:adaptAbility()
  end

  if self.ammoTimer > 0 then
    self.ammoTimer = self.ammoTimer - dt
  end
end

function AmmoSwap:switch()
  self.ammoIndex = (self.ammoIndex % #self.ammoTypes) + 1
  activeItem.setInstanceValue("ammoIndex", self.ammoIndex)

  self:adaptAbility()
  animator.playSound("switchAmmo")

  self.weapon:setStance(self.stances.switch)

  util.wait(self.stances.switch.duration)
end

function AmmoSwap:switchInsert()
  self.ammoIndex = (self.ammoIndex % #self.ammoTypes) + 1
  activeItem.setInstanceValue("ammoIndex", self.ammoIndex)

  self:adaptAbility()
  animator.playSound("switchAmmo")

  self.weapon:setStance(self.stances.open)

  util.wait(self.stances.open.duration)

  self.weapon:setStance(self.stances.switch)

  util.wait(self.stances.switch.duration)

  self.weapon:setStance(self.stances.close)

  util.wait(self.stances.close.duration)
end

function AmmoSwap:adaptAbility()
  local ability = self.weapon.abilities[self.adaptedAbilityIndex]
  util.mergeTable(ability, self.ammoTypes[self.ammoIndex])
end

function AmmoSwap:uninit()
end

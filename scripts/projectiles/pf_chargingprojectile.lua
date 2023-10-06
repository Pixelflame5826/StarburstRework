require "/scripts/vec2.lua"
require "/scripts/util.lua"

function init()
  self.tickTimer = config.getParameter("activationTime", 1)
end

function update(dt)
  self.tickTimer = self.tickTimer - dt
  
  if self.tickTimer <= 0 then
    activate()
  end
end

function activate()
  projectile.processAction({
    action = "projectile",
    type = config.getParameter("chargedProjectile"),
    inheritDamageFactor = 1.5
  })
  projectile.die()
end

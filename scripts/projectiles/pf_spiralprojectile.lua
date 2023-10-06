require "/scripts/vec2.lua"

function init()
  self.spiralAmplitude = config.getParameter("spiralAmplitude")

  self.timer = 0
  
  self.lastAngle = 0
end

function update(dt)
  self.timer = self.timer + dt
  local newAngle = self.spiralAmplitude * math.sqrt(self.timer)

  mcontroller.setVelocity(vec2.rotate(mcontroller.velocity(), newAngle - self.lastAngle))

  self.lastAngle = newAngle
end

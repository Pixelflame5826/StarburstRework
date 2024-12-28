function init()
  animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
  animator.setParticleEmitterActive("flames", true)
  
  effect.setParentDirectives("border=2;7ED9FC22;00000000")

  self.movementModifiers = config.getParameter("movementModifiers", {})
  

  effect.addStatModifierGroup({{stat = "powerMultiplier", effectiveMultiplier = 0.75}, {stat = "healingStatusImmunity", amount = 1}})
end

function update(dt)
  mcontroller.controlModifiers(self.movementModifiers)
end

function uninit()

end

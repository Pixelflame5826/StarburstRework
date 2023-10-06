function init()
  animator.setParticleEmitterOffsetRegion("shadow", mcontroller.boundBox())
  animator.setParticleEmitterActive("shadow", true)
  
  effect.setParentDirectives("fade=000000=0.9")

  self.movementModifiers = config.getParameter("movementModifiers", {})
  

  effect.addStatModifierGroup({{stat = "powerMultiplier", effectiveMultiplier = 0.75}})
  
  effect.addStatModifierGroup({{stat = "protection", amount = -30.0}})
  
  effect.addStatModifierGroup({{stat = "healStatusImmunity", amount = 1.0}})
  
  effect.addStatModifierGroup({{stat = "grit", amount = 1.0}})
end

function update(dt)
  mcontroller.controlModifiers(self.movementModifiers)
end

function uninit()

end

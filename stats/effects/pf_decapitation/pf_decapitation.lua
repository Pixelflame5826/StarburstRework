function init()
  self.killThreshold = config.getParameter("killThreshold", 0.0)
  
  self.killCheck = false

  script.setUpdateDelta(20)
  
  if (world.entityType(entity.id()) == "npc") then
	if (self.killThreshold >= status.resourcePercentage("health")) then
	  animator.setParticleEmitterActive("killMessage", true)
	  animator.setParticleEmitterActive("blood", true)
	  self.killCheck = true
	end
  end
end

function update(dt)
  if self.killCheck then
    mcontroller.setVelocity({0, 0})
    status.setResourcePercentage("health", 0)
  end
  
  status.addEphemeralEffect("pf_bleedingdeep")
end

function uninit()

end

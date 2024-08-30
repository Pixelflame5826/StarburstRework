function init()
  animator.setParticleEmitterOffsetRegion("rainbow", mcontroller.boundBox())
  animator.setParticleEmitterActive("rainbow", true)
  
  effect.setParentDirectives(config.getParameter("directives", ""))
  
  effect.addStatModifierGroup({
	{stat = "pf_isWet", amount = 1.0},
	{stat = "pf_isSwamped", amount = 1.0},
	{stat = "pf_isTarred", amount = 1.0},
  })
end

function update(dt)

end

function uninit()
  
end
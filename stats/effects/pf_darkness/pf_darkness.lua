function init()
  animator.setAnimationState("aura", "on")
  effect.addStatModifierGroup({{stat = "pf_currentlyDark", amount = 1}})
end

function onExpire()
  status.addEphemeralEffect("pf_darknesslifting")
end

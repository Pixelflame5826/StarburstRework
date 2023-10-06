function init()
   effect.addStatModifierGroup({{stat = "breathDepletionRate", effectiveMultiplier = 0}, {stat = "breathRegenerationRate", effectiveMultiplier = 5}})

   script.setUpdateDelta(0)
end

function update(dt)

end

function uninit()
  
end

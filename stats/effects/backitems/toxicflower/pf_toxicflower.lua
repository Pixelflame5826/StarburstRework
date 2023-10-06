function init()

  effect.addStatModifierGroup({
      {stat = "energyRegenPercentageRate", effectiveMultiplier = config.getParameter("regenBonusAmount", 10)}
    })
end

function update(dt)

end

function uninit()

end

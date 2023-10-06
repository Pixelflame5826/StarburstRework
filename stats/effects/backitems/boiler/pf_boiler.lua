function init()

  effect.addStatModifierGroup({
      {stat = "energyRegenPercentageRate", effectiveMultiplier = config.getParameter("regenBonusAmount", 10)},
	  {stat = "pf_mildBiomeColdImmunity", amount = 1}
    })
end

function update(dt)

end

function uninit()

end

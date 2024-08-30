function build(directory, config, parameters, level, seed)

  config.tooltipFields = config.tooltipFields or {}
  config.tooltipFields.tileDamageLabel = config.tileDamage
  config.tooltipFields.speedLabel = config.fireTime
  local blockRadius = config.blockRadius
  config.tooltipFields.blockRadiusLabel = string.format("%s x %s", blockRadius, blockRadius)
  
  --- Durability Calculations
  if config.durabilityPerUse == 0 then
    config.tooltipFields.durabilityLabel = "Unbreakable"
  else
    parameters.maxDurability = config.durability * config.durabilityPerUse
    parameters.currentDurability = config.durability - (parameters.durabilityHit or 0)
    config.tooltipFields.durabilityLabel = string.format("%s / ^gray;%s", parameters.currentDurability, parameters.maxDurability)
  end

  return config, parameters
end
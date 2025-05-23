function ageItem(baseItem, aging)

  baseItem.parameters.tooltipFields = baseItem.parameters.tooltipFields or {}

  baseItem.parameters.currentDurability = (baseItem.parameters.maxDurability or 0) - (baseItem.parameters.durabilityHit or 0)

  baseItem.parameters.tooltipFields.durabilityLabel = string.format("%s / ^gray;%s", baseItem.parameters.currentDurability, baseItem.parameters.maxDurability)

  return baseItem
end
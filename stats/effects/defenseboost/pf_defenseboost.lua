function init()
  self.protectionMod = config.getParameter("elementprotection", 0)

  effect.addStatModifierGroup({
    {stat = "physicalResistance", amount = self.protectionMod },
    {stat = "fireResistance", amount = self.protectionMod },
    {stat = "iceResistance", amount = self.protectionMod },
    {stat = "poisonResistance",amount = self.protectionMod },
    {stat = "electricResistance", amount = self.protectionMod }
  })
end

function update(dt)
end

function uninit()
  
end
function init()
  effect.addStatModifierGroup({
    {stat = "physicalResistance", config.getParameter("elementprotection", 0)},
    {stat = "fireResistance", config.getParameter("elementprotection", 0)},
    {stat = "iceResistance", config.getParameter("elementprotection", 0)},
    {stat = "poisonResistance", config.getParameter("elementprotection", 0)},
    {stat = "electricResistance", config.getParameter("elementprotection", 0)}
  })
end

function update(dt)
end

function uninit()
  
end
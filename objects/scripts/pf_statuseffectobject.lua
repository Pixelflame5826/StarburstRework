require "/scripts/util.lua"

function init()
  self.detectBoundMode = config.getParameter("detectBoundMode", "CollisionArea")
  local detectArea = config.getParameter("statusArea")
  self.detectEntityTypes = config.getParameter("detectEntityTypes")
  
  self.effect = config.getParameter("statusEffect")
  self.duration = config.getParameter("effectDuration")
  
  local pos = object.position()
  if type(detectArea[2]) == "number" then
    --center and radius
    self.detectArea = {
      {pos[1] + detectArea[1][1], pos[2] + detectArea[1][2]},
      detectArea[2]
    }
  elseif type(detectArea[2]) == "table" and #detectArea[2] == 2 then
    --rect corner1 and corner2
    self.detectArea = {
      {pos[1] + detectArea[1][1], pos[2] + detectArea[1][2]},
      {pos[1] + detectArea[2][1], pos[2] + detectArea[2][2]}
    }
  end
end

function update(dt) 
  local entityIds = world.entityQuery(self.detectArea[1], self.detectArea[2], {
      withoutEntityId = entity.id(),
      includedTypes = self.detectEntityTypes,
      boundMode = self.detectBoundMode
    })

  for _, effectEntity in ipairs(entityIds) do
	applyEffect(effectEntity, self.effect, self.duration)
  end
end

function applyEffect(id,effect,duration)
  if world.entityExists(id) then
	world.sendEntityMessage(id,"applyStatusEffect",effect, duration, entity.uniqueId())
  else
	return false
  end
end

require "/scripts/util.lua"

function init()
  if storage.state == nil then storage.state = config.getParameter("defaultActiveState", true) end

  self.detectBoundMode = config.getParameter("detectBoundMode", "CollisionArea")
  local detectArea = config.getParameter("statusArea")
  self.detectEntityTypes = config.getParameter("detectEntityTypes")
  
  self.effect = config.getParameter("statusEffect")
  self.duration = config.getParameter("effectDuration")
  
  self.interactive = config.getParameter("interactive", false)
  object.setInteractive(self.interactive)
  
  if config.getParameter("inputNodes") then
    processWireInput()
  end
  
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
  
  setAnimationState(storage.state)
end

--ANIMATION AND TOGGLE
function onNodeConnectionChange(args)
  processWireInput()
end

function onInputNodeChange(args)
  processWireInput()
end

function onInteraction(args)
  if not config.getParameter("inputNodes") or not object.isInputNodeConnected(0) then
    storage.state = not storage.state
    setAnimationState(storage.state)
  end
end

function processWireInput()
  if object.isInputNodeConnected(0) then
    object.setInteractive(false)
    storage.state = object.getInputNodeLevel(0)
    setAnimationState(storage.state)
  elseif self.interactive then
    object.setInteractive(true)
  end
end

function setAnimationState(newState)
  if newState then
    animator.setAnimationState("light", "on")
    object.setSoundEffectEnabled(true)
    if animator.hasSound("on") then
      animator.playSound("on");
    end
    object.setLightColor(config.getParameter("lightColor", {0, 0, 0}))
  else
    animator.setAnimationState("light", "off")
    object.setSoundEffectEnabled(false)
    if animator.hasSound("off") then
      animator.playSound("off");
    end
    object.setLightColor(config.getParameter("lightColorOff", {0, 0, 0}))
  end
end

--STATUS EFFECT
function update(dt)
  if storage.state then
    detectEntities()
  end
end

function detectEntities()
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

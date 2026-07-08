function init()
  self.warningTimer = 1
  self.storedHazard = ""

  message.setHandler("biomeHazard", function(_, _, biomeHazard)
    if self.warningTimer <= 0 then
      displayHazard(biomeHazard)
    else
      self.storedHazard = biomeHazard
    end
  end)
end

function displayHazard(biomeHazard)
  self.warningTimer = 2

  world.spawnProjectile(
    "pf_genericblank", 
    mcontroller.position(), 
    player.id(), 
    {0,0}, 
    false, 
    {
      actionOnReap = {
        {
          action = "particle",
          specification = string.format("%swarning", biomeHazard)
        },
        {
          action = "sound",
          options = { "/sfx/interface/playerstatuscritical.ogg" }
        }
      }
    }
  )
end

function update(dt)
  if self.warningTimer > 0 then
  	self.warningTimer = self.warningTimer - dt
  else
    if self.storedHazard ~= "" then
      displayHazard(self.storedHazard)
      self.storedHazard = ""
    end
  end
end

function uninit()

end

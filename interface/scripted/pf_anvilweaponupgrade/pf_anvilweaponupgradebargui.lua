require "/scripts/util.lua"
require "/scripts/interp.lua"

function init()
  self.itemList = "itemScrollArea.itemList"
  self.upgradeLevel = config.getParameter("upgradeLevel")
  self.upgradeMaterials = config.getParameter("upgradeMaterials")
  self.fallbackUpgradeMaterial = config.getParameter("fallbackUpgradeMaterial")
  self.materialImages = config.getParameter("materialImages")
  self.materialImagePath = config.getParameter("materialImagePath")

  self.upgradeableWeaponItems = {}
  self.selectedItem = nil
  populateItemList()
end

function update(dt)
  populateItemList()
end

function upgradeCost(itemConfig)
  return itemConfig == nil and 0 or 10
end

function populateItemList(forceRepop)
  local upgradeableWeaponItems = player.itemsWithTag("pf_anvilUpgradeableWeapon")
  for i = 1, #upgradeableWeaponItems do
    upgradeableWeaponItems[i].count = 1
  end

  local playerModules = player.hasCountOfItem("upgrademodule")

  if forceRepop or not compare(upgradeableWeaponItems, self.upgradeableWeaponItems) then
    self.upgradeableWeaponItems = upgradeableWeaponItems
    widget.clearListItems(self.itemList)
    widget.setButtonEnabled("btnTemper", false)

    local showEmptyLabel = true

    for i, item in pairs(self.upgradeableWeaponItems) do
      
	  local config = root.itemConfig(item)

      if (config.parameters.level or config.config.level or 1) < self.upgradeLevel then
        showEmptyLabel = false

        local listItem = string.format("%s.%s", self.itemList, widget.addListItem(self.itemList))
        local name = config.parameters.shortdescription or config.config.shortdescription
		local level = (config.parameters.level or config.config.level or 1)
        local levelLabel = "^#b9b5b2;Lvl " .. level

        widget.setText(string.format("%s.itemName", listItem), name)
        widget.setItemSlotItem(string.format("%s.itemIcon", listItem), item)
        widget.setText(string.format("%s.itemLevel", listItem), levelLabel)

        local price = upgradeCost(config)
        widget.setData(listItem,
          {
            index = i,
            price = price,
			level = level
          })

        widget.setVisible(string.format("%s.unavailableoverlay", listItem), price > playerModules)
        showWeapon(config, 10, level)
      end
    end

    self.selectedItem = nil
	
	if showEmptyLabel then
	  widget.setText("moduleCost", "0 / --")
	  widget.setVisible("materialIcon", false)
	end
	
    widget.setVisible("emptyLabel", showEmptyLabel)
  end
end

function showWeapon(itemConfig, price, level)
  
  widget.setVisible("materialIcon", true)
  
  local playerModules = 0
  
  playerModules = player.hasCountOfItem(self.upgradeMaterials[level] or self.fallbackUpgradeMaterial)
  widget.setImage("materialIcon", string.format(self.materialImagePath, self.materialImages[level]))
  
  local enableButton = false

  if itemConfig then
    enableButton = playerModules >= price
    local directive = enableButton and "^green;" or "^red;"
    widget.setText("moduleCost", string.format("%s%s / %s", directive, playerModules, price))
  else
    widget.setText("moduleCost", string.format("%s / --", playerModules))
  end

  widget.setButtonEnabled("btnTemper", enableButton)
end

function itemSelected()
  local listItem = widget.getListSelected(self.itemList)
  self.selectedItem = listItem
 

  if listItem then
    local itemData = widget.getData(string.format("%s.%s", self.itemList, listItem))
    local weaponItem = self.upgradeableWeaponItems[itemData.index]
    showWeapon(weaponItem, itemData.price, itemData.level)
  end
end

function doUpgrade()
  if self.selectedItem then
    local selectedData = widget.getData(string.format("%s.%s", self.itemList, self.selectedItem))
    local upgradeItem = self.upgradeableWeaponItems[selectedData.index]
	
    if upgradeItem then
      local consumedItem = player.consumeItem(upgradeItem, false, true)
	  
      if consumedItem then
	    local consumedCurrency = false
	    local upgradedItem = copy(consumedItem)
	    local itemConfig = root.itemConfig(upgradedItem)
		  local level = itemConfig.parameters and itemConfig.parameters.level or itemConfig.config and itemConfig.config.level or 1
	    local consumedCurrency = player.consumeItem({name = self.upgradeMaterials[level] or self.fallbackUpgradeMaterial, count = selectedData.price}, false, true)
		
        if consumedCurrency then
          upgradedItem.parameters.level = level + 1
          if itemConfig.config.upgradeParameters then
            upgradedItem.parameters = util.mergeTable(upgradedItem.parameters, itemConfig.config.upgradeParameters["level"..upgradedItem.parameters.level])
          end
        end
        player.giveItem(upgradedItem)
      end
    end
    populateItemList(true)
  end
end

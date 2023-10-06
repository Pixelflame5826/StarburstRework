require "/scripts/util.lua"
require "/scripts/interp.lua"

function init()
  self.itemList = "itemScrollArea.itemList"

  self.upgradeLevel = config.getParameter("upgradeLevel")

  self.upgradeableWeaponItems = {}
  self.selectedItem = nil
  populateItemList()
end

function update(dt)
  populateItemList()
end

function upgradeCost(itemConfig)
  if itemConfig == nil then return 0 end

  local newValue = ((itemConfig.parameters.level or itemConfig.config.level) or 1) / 2 

  return math.ceil(newValue)
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
        local name = config.config.shortdescription

        widget.setText(string.format("%s.itemName", listItem), name)
        widget.setItemSlotItem(string.format("%s.itemIcon", listItem), item)

        local price = upgradeCost(config)
        widget.setData(listItem,
          {
            index = i,
            price = price
          })

        widget.setVisible(string.format("%s.unavailableoverlay", listItem), price > playerModules)
      end
    end

    self.selectedItem = nil
    showWeapon(nil)

    widget.setVisible("emptyLabel", showEmptyLabel)
  end
end

function showWeapon(item, price)
  local playerModules = player.hasCountOfItem("upgrademodule")
  local enableButton = false

  if item then
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
    showWeapon(weaponItem, itemData.price)
  end
end

function doUpgrade()
  if self.selectedItem then
    local selectedData = widget.getData(string.format("%s.%s", self.itemList, self.selectedItem))
    local upgradeItem = self.upgradeableWeaponItems[selectedData.index]

    if upgradeItem then
      local consumedItem = player.consumeItem(upgradeItem, false, true)
      if consumedItem then
        local consumedCurrency = player.consumeItem({name = "upgrademodule", count = selectedData.price}, false, true) 
        local upgradedItem = copy(consumedItem)
        if consumedCurrency then
          upgradedItem.parameters.level = (itemConfig.parameters.level or itemConfig.config.level or 1) + 1
          local itemConfig = root.itemConfig(upgradedItem)
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

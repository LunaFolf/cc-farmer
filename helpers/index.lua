--[[
  This file contains helper functions for the program.
  In the future, this file will be made into a library for LunaOS.
]]

-- Get crop data from given block data
function getFromBlock(blockData)
  local isCrop = false
  local isWaterSource = false

  for i = 1, #config.harvestableTags do
    local tag = config.harvestableTags[i]
    if blockData.tags[tag] then
      isCrop = true
      break
    end
  end

  for i = 1, #config.waterSouceIdentifierTags do
    local tag = config.waterSouceIdentifierTags[i]
    if blockData.tags[tag] then
      isWaterSource = true
      break
    end
  end

  if not isCrop and not isWaterSource then return false, {} end

  if isCrop then return "crop", blockData end
  if isWaterSource then return "water", blockData end
end

-- Given a crop name similar to "minecraft:wheat", search the inventory for a valid seed to plant, by tags.
-- i.e. "minecraft:wheat" --> "c:seeds/wheat"
function selectSeed(crop)
  local seedTag = config.seedMap[crop]

  if not seedTag then return false end

  local selectedSlot = turtle.getSelectedSlot()

  -- check if currently selected item is a valid seed
  local data = turtle.getItemDetail(selectedSlot)
  if data and data.name == seedTag then return true end

  -- check if any other item is a valid seed, and select it
  for i = 1, 16 do
    local data = turtle.getItemDetail(i)
    if data and data.name == seedTag then
      turtle.select(i)
      return true
    end
  end

  -- no valid seed found
  return false
end

-- Now, lets setup some helper functions

function inventoryFreeSlots(side)
  local size = peripheral.call(side, "size")
  local list = peripheral.call(side, "list")

  local slots = {}

  for slot, item in pairs(list) do
    if item then
      local count = item.count
      local maxCount = peripheral.call(side, "getItemLimit", slot)

      local freeSpace = maxCount - count

      slots[item.name] = slots[item.name] or 0 + freeSpace
    else
      slots["empty"] = slots["empty"] or 0 + 1
    end
  end

  return slots
end

-- Check if the turtle has any chest like inventories on the sides, and if so, offload the inventory.
-- offload everything, except for fuel, which can be found via mapFuelSlots().
function offloadInventory()
  print("Offloading inventory...")

  local sides = peripheral.getNames()

  local fuelSlots = mapFuelSlots()

  local inventorySide = nil

  for i = 1, #sides do
    local side = sides[i]
    local isInventory = peripheral.hasType(side, "inventory")
    if isInventory then
      inventorySide = side
      break
    end
  end

  if inventorySide then

    -- Rotate the turtle to face the inventory
    if inventorySide == "left" then
      turnLeft()
    elseif inventorySide == "right" then
      turnRight()
    elseif inventorySide == "back" then
      turnAround()
    end

    for i = 1, 16 do
      turtle.select(i)
      turtle.drop()
    end

    -- Rotate the turtle back to the field
    if inventorySide == "left" then
      turnRight()
    elseif inventorySide == "right" then
      turnLeft()
    elseif inventorySide == "back" then
      turnAround()
    end
  end
end

-- Attempt harvest of below block, so long as it is a valid crop AND has reached maturity.
-- Then, attempt to replant the seed.
function attemptHarvest()
  local success, data = turtle.inspectDown()

  if success then
    local blockType, blockData = getFromBlock(data)

    if blockType == "crop" then
      local cropID = blockData.name
      local cropState = blockData.state

      if cropState.age >= config.cropMaxAge[cropID] then
        -- Crop is ready to harvest
        turtle.digDown()
        if selectSeed(cropID) then
          turtle.placeDown()
        end
      end
    end
  end
end

require("helpers.refuel")
require("helpers.movement")

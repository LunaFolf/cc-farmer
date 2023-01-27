require("config")
require("helpers.index")

-- Sweet, now lets get to work!

local function mapField()
  print("Mapping field...")

  goto({x = 0, y = 0, z = 1})

  local mapping = true
  local turns = 0

  while mapping do
    -- Now, lets check the block below us
    local success, data = turtle.inspectDown()

    -- If we have inspected a block, lets check if it's a crop and if so, add it field table.
    if success then
      local blockType, blockData = getFromBlock(data)

      local validBlockType = blockType == "crop" or blockType == "water"

      -- Map the first row of the field
      while success and validBlockType do
        table.insert(field, {x = currentPos.x, y = currentPos.y, data = blockData})
        if turns == 0 then fieldSize.y = fieldSize.y + 1 end

        attemptHarvest()

        forward(1)
        success, data = turtle.inspectDown()
        if success then
          blockType, blockData = getFromBlock(data)
          validBlockType = blockType == "crop" or blockType == "water"
        end
      end

      -- Now, lets move to the next row

      turns = turns + 1

      if currentDir == 1 then
        goto({x = turns, y = fieldSize.y - 1, z = 1}, 3)
      elseif currentDir == 3 then
        goto({x = turns, y = 0, z = 1}, 1)
      end
    else
      mapping = false
      fieldSize.x = turns
    end
  end


  print("Field size:", fieldSize.x, fieldSize.y)
  print("Returning to start position...")
  returnToStart()

  print("Field mapped!")
  offloadInventory()
end

mapField()

-- Now that the field has been mapped via mapField(), we can use this function for future harvest cycles, because we already know the size of the field.
local function harvestField()
  print("Harvesting field...")

  goto({x = 0, y = 0, z = 1})

  local turns = 0

  while turns < fieldSize.x do
    -- Now, lets check the block below us
    local success, data = turtle.inspectDown()

    -- If we have inspected a block, lets check if it's a crop and if so, add it field table.
    if success then
      local blockType, blockData = getFromBlock(data)

      local validBlockType = blockType == "crop" or blockType == "water"

      -- Map the first row of the field
      while success and validBlockType do
        attemptHarvest()

        forward(1)
        success, data = turtle.inspectDown()
        if success then
          blockType, blockData = getFromBlock(data)
          validBlockType = blockType == "crop" or blockType == "water"
        end
      end

      -- Now, lets move to the next row

      turns = turns + 1

      if currentDir == 1 then
        goto({x = turns, y = fieldSize.y - 1, z = 1}, 3)
      elseif currentDir == 3 then
        goto({x = turns, y = 0, z = 1}, 1)
      end
    else
      turns = fieldSize.x
    end
  end

  print("Returning to start position...")
  returnToStart()
end

-- TODO: mapField() and harvestField() are very similar, and could be combined, share code, or maybe one or even both could be simplified...

while true do
  os.sleep(config.harvestInterval)
  print("Starting harvest cycle")

  harvestField()
  offloadInventory()
end
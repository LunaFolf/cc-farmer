-- Given a file/dir path, check if the structure exists, if not, create it.
-- Use gmatch to split the path into it's component parts, and check if each part exists.
local function _validateFSPath(path)
  local currentPath = ""
  for part in string.gmatch(path, "[^/]+") do
    currentPath = currentPath .. "/" .. part
    if not fs.exists(currentPath) then
      fs.makeDir(currentPath)
    end
  end
end

local _configPath = ".lunaOS/farmbot" -- This is the path to the config file, relative to the root of the LunaOS drive.
local _configFile = _configPath .. "/config" -- This is the path to the config file, relative to the root of the LunaOS drive.

startPos, startDir = { x = -1, y = -1, z = 0 }, 1 -- This is the starting position of the turtle, and the direction it is facing.

field = {} -- This is the field table, it will contain a list of all the crops in the field, and their data.
fieldSize = { x = 0, y = 0 } -- This is the size of the field, it will be determined by the turtle.
currentPos = { x = -1, y = -1, z = 0 } -- This is the current position of the turtle, it will be updated as the turtle moves.
currentDir = 1 -- This is the current direction the turtle is facing, it will be updated as the turtle moves. 1 = North, 2 = East, 3 = South, 4 = West

-- Lets not forget to pull in the config file ;)
-- and if it doesn't exist, lets create it!

-- lets setup the default config table
config = {
  harvestInterval = 300, -- The interval at which the turtle will attempt to harvest crops, in seconds.
  harvestableTags = { "minecraft:crops", "computercraft:turtle_hoe_harvestable" }, -- The block tags that the turtle will consider harvestable crops.,
  waterSouceIdentifierTags = { "minecraft:slabs" },
  seedMap = {
    ["minecraft:wheat"] = "minecraft:wheat_seeds",
    ["minecraft:carrots"] = "minecraft:carrot",
    ["minecraft:potatoes"] = "minecraft:potato",
    ["minecraft:beetroots"] = "minecraft:beetroot_seeds",
    ["minecraft:nether_wart"] = "minecraft:nether_wart",
    ["minecraft:sugar_cane"] = "minecraft:sugar_cane"
  },
  cropMaxAge = {
    ["minecraft:wheat"] = 7,
    ["minecraft:carrots"] = 7,
    ["minecraft:potatoes"] = 7,
    ["minecraft:beetroots"] = 3,
    ["minecraft:nether_wart"] = 3,
    ["minecraft:sugar_cane"] = 1
  }
}

_validateFSPath(_configPath)

-- Now, lets check if the config file exists
if not fs.exists(_configFile) then
  -- If it doesn't, lets create it
  local file = fs.open(_configFile, "w")
  file.write(textutils.serialize(config))
  file.close()
else
  -- If it does, lets load it
  local file = fs.open(_configFile, "r")
  local _config = textutils.unserialize(file.readAll())
  file.close()

  -- Now, the config could be out of date, so lets check for missing values
  local hadToRewrite = false
  for key, value in pairs(config) do
    if _config[key] == nil then
      _config[key] = value
      hadToRewrite = true
    end
  end

  -- If we had to rewrite the config, lets save it
  if hadToRewrite then
    local file = fs.open(_configFile, "w")
    file.write(textutils.serialize(_config))
    file.close()
  end

  config = _config
end

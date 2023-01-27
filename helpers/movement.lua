-- Move forward a given number of spaces, supports negative numbers for moving backwards.
function forward(spaces)
  spaces = spaces or 1
  if spaces < 0 then
    turtle.back(math.abs(spaces))
  end
  for i = 1, spaces do
    turtle.forward()
  end

  -- Update the current position of the turtle

  if currentDir == 1 then
    currentPos.y = currentPos.y + spaces
  elseif currentDir == 2 then
    currentPos.x = currentPos.x + spaces
  elseif currentDir == 3 then
    currentPos.y = currentPos.y - spaces
  elseif currentDir == 4 then
    currentPos.x = currentPos.x - spaces
  else
    error("Invalid direction: " .. currentDir)
  end

end

-- Move back a given number of spaces, supports negative numbers for moving forwards, is just an alias for forward.
function back(spaces)
  forward(-spaces)
end

-- Move down a given number of spaces, supports negative numbers for moving up, is just an alias for up.
function down(spaces)
  up(-spaces)
end

-- Update the current direction of the turtle, based on the direction given.
function updateDirection(direction)
  if direction == "left" then
    currentDir = currentDir - 1
  elseif direction == "right" then
    currentDir = currentDir + 1
  else
    error("Invalid direction: " .. direction)
  end

  if currentDir < 1 then
    currentDir = 4
  elseif currentDir > 4 then
    currentDir = 1
  end
end

-- Move up a given number of spaces, supports negative numbers for moving down.
function up(spaces)
  spaces = spaces or 1
  if spaces < 0 then
    turtle.down(math.abs(spaces))
  end
  for i = 1, spaces do
    turtle.up()
  end

  -- Update the current position of the turtle
  currentPos.z = currentPos.z + spaces
end

-- Turn left a given number of times.
function turnLeft(times)
  times = times or 1
  for i = 1, times do
    turtle.turnLeft()

    -- Update the current direction of the turtle
    updateDirection("left")
  end
end

-- Turn right a given number of times.
function turnRight(times)
  times = times or 1
  for i = 1, times do
    turtle.turnRight()

    -- Update the current direction of the turtle
    updateDirection("right")
  end
end

-- Turns around (180 degrees), is just an alias for turnLeft(2).
function turnAround()
  turnLeft(2)
end

-- Given a currently facing direction, and a direction to face,
-- return the direction to turn, and the number of times to turn.
-- i.e. return "left", 2
function turnFromTo(currentDir, intendedDir)
  local dirDiff = intendedDir - currentDir
  if dirDiff < 0 then
    dirDiff = dirDiff + 4
  end

  if dirDiff == 0 then
    return "none", 0
  elseif dirDiff == 1 then
    turnRight(1)
    return "right", 1
  elseif dirDiff == 2 then
    turnAround()
    return "left", 2
  elseif dirDiff == 3 then
    turnLeft(1)
    return "left", 1
  else
    error("Invalid direction difference: " .. dirDiff)
  end
end

-- Goto the given position, and face the given direction.
function goto(pos, dir)
  dir = dir or currentDir

  local canMakeMove = hasEnoughFuel(pos)

  if not canMakeMove then
    error("Not enough fuel to complete move")
  end

  turnFromTo(currentDir, 1) -- Face north, so we know where we are

  if pos.z > currentPos.z then
    up(pos.z - currentPos.z)
  end

  -- First, lets move to the correct x position

  if pos.x ~= currentPos.x then
    local turnDir = pos.x < currentPos.x and 4 or 2
    turnFromTo(currentDir, turnDir)
    forward(math.abs(pos.x - currentPos.x))
  end

  -- Now, lets move to the correct y position

  if pos.y ~= currentPos.y then
    local turnDir = pos.y < currentPos.y and 3 or 1
    turnFromTo(currentDir, turnDir)
    forward(math.abs(pos.y - currentPos.y))
  end

  if pos.z < currentPos.z then
    down(currentPos.z - pos.z)
  end

  -- Finally, lets face the correct direction

  turnFromTo(currentDir, dir)
end

-- Return to the starting position, and face the starting direction.
function returnToStart()
  goto(startPos, startDir)
end
-- Return a table of all slot numbers that contain fuel.
function mapFuelSlots()
  local fuelSlots = {}
  for i = 1, 16 do
    if turtle.getItemCount(i) > 0 then
      turtle.select(i)
      if turtle.refuel(0) then
        table.insert(fuelSlots, i)
      end
    end
  end
  return fuelSlots
end

-- Does the turtle currently have fuel in it's inventory, that it can use to refuel itself?
-- If it can refuel, return the slot number, otherwise return false.
function canRefuelSelf()
  if turtle.getFuelLevel() >= turtle.getFuelLimit() then
    return false, nil
  end

  for i = 1, 16 do
    if turtle.getItemCount(i) > 0 then
      turtle.select(i)
      if turtle.refuel(0) then
        return true, i
      end
    end
  end
  return false, nil
end

-- Refule the turtle, using all the fuel available in it's inventory.
function refuelSelf()
  local canRefuel, slot = canRefuelSelf()
  print("Refueling turtle", canRefuel, slot)

  while canRefuel do
    turtle.select(slot)
    turtle.refuel()
    canRefuel, slot = canRefuelSelf()
    print("Refueling turtle", canRefuel, slot)
  end
end

-- Does the turtle have enough fuel to complete the task?
-- Bearing in mind, the turtle needs to be able to travel to the crop, harvest it, and return to it's starting position.
-- If the turtle doesn't have enough fuel, attempt to refuel itself.
-- If the turtle still doesn't have enough fuel, return false.
function hasEnoughFuel(targetPos)
  local distance = math.abs(targetPos.x - currentPos.x) + math.abs(targetPos.y - currentPos.y) +
      math.abs(targetPos.z - currentPos.z)
  if turtle.getFuelLevel() < distance * 2 then
    refuelSelf()
    if turtle.getFuelLevel() < distance * 2 then
      return false
    end
  end
  return true
end

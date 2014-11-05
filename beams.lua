robot = require("robot")

local args = {...}

if args[1] == nil or args[2] == nil or args[3] == nil or robot.count(1) < 1 or args[1] == "help" then
  print ("Usage: beams [length][# of beams][space]")
  print ("Place the robot in a corner with a wall to its left.")
  print ("Put one of the building blocks in the robot's")
  print ("first slot.")
  print ("")
  print ("")
  return
end

local stack = 0
local vertical = false
local flength = tonumber(args[1])
local rlength = tonumber(args[2])
local blocks = rlength * flength

--if robot.getFuelLevel() < blocks + 1 then
--  print ("You do not have enough fuel. This job needs ", blocks, " fuel.")
--  return
--end

if args[3] == "-v" then
  vertical = true
end

function step()
  while not robot.forward() do
    robot.dig()
  end
end

function stepUp()
  while not robot.down() do
    robot.digDown()
  end
end

function rotateRight()
  robot.turnRight()
  if vertical then 
    stepUp()
  else
    for i = 1, space, 1 do
      step()
    end
  end
  robot.turnRight()
end

function rotateLeft()
  robot.turnLeft()
  if vertical then
    stepUp()
  else
    step()
    step()
    step()
    step()
  end
  robot.turnLeft()
end

function placeDown()
  while not robot.placeUp() do
    robot.digUp()
  end
end

function findBlock()
  stack = 0
  local found = false
  for i = 2, 16, 1 do
    robot.select(i)
    if robot.count(i) > 0 and robot.compareTo(1) then
      found = true
      stack = robot.count(i)
      break
    end
  end
  return found
end

stepUp()

for i = 1, rlength, 1 do
  for j = 1, flength, 1 do
    if stack < 1 then
      print ("Waiting for stack.")
      while not findBlock() do end
    end
    if not robot.compareUp() then
      placeDown()
      stack = stack - 1
    end
    if j < flength then
      step()
    end
  end
  if i < rlength then
    if i % 2 ~= 0 then
      rotateRight()
    else
      rotateLeft()
    end
  end
end

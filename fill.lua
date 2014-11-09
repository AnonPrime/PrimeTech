----------------------------------------
-- File Name: fill                    --
-- Version    1.0                     --
-- Date:      2014/02/06              --
-- Author:    MiradoPrime             --
----------------------------------------
-- This program will fill in a plane  --
-- with the provided dimensions.      --
-- Additional arguments allow for     --
-- either a ceiling or wall mode.     --
----------------------------------------

local args = {...}

if args[1] == nil or args[2] == nil or robot.count(1) < 1 or args[1] == "help" then
  print ("Usage: fill [forward length][right length][option]")
  print ("Put one of the building blocks in the first slot.")
  print ("Options:")
  print ("  -c - Ceiling Mode")
  print ("  -v - Vertical (Wall) Mode")
  return
end

local stack = 0
local vertical = false
local ceiling = false
local flength = tonumber(args[1])
local rlength = tonumber(args[2])
local blocks = rlength * flength

--[[if turtle.getFuelLevel() < blocks + 1 then
  print ("You do not have enough fuel. This job needs ", blocks, " fuel.")
  return
end]]

if args[3] == "-v" then
  vertical = true
end

if args[3] == "-c" then
  ceiling = true
end

function step()
  while not robot.forward() do
    robot.swing()
  end
end

function stepUp()
  if ceiling then
    while not robot.down() do
      robot.swingDown()
    end  
  else
    while not robot.up() do
      robot.swingUp()
    end
  end
end

function rotateRight()
  robot.turnRight()
  if vertical then 
    stepUp()
  else
    step()
  end
  robot.turnRight()
end

function rotateLeft()
  robot.turnLeft()
  if vertical then
    stepUp()
  else
    step()
  end
  robot.turnLeft()
end

function placeDown()
  if ceiling then
    while not robot.placeUp() do
      robot.swingUp()
    end
  else
    while not robot.placeDown() do
      robot.swingDown()
    end
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
    if ceiling then
      if not robot.compareUp() then
        placeDown()
        stack = stack - 1
      end
    else
      if not robot.compareDown() then
        placeDown()
        stack = stack - 1
      end
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

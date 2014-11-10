local robot = require("robot")

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

function step()
  while not robot.forward() do
    --robot.swing()
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
    step()
    step()
    step()
    step()
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
    step()
    step()
    step()
    step()
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

stepUp()

local rows = (math.floor(rlength/6) + 1)

for i = 1, rows, 1 do
  for j = 0, flength - 1, 1 do
    if stack < 1 then
      print("waiting for stack")
      while not findBlock() do end
    end
    if j % 6 == 0 then
      placeDown()
      stack = stack - 1
    end
    if j < (flength - 1) then
      step()
    end
  end
  if i < rows then
    if i % 2 ~= 0 then
      rotateRight()
    else
      rotateLeft()
    end
  end
end

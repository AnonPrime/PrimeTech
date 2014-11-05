local robot = require("robot")

local args = {...}

if args[1] == nil or robot.count(1) < 1 or args[1] == "help" then
  print ("Usage: tower [height]")
  print ("Put one of the building blocks in the robot's")
  print ("first slot.")
  return
end

local stack = 0
local height = tonumber(args[1])
local blocks = height * 32

--if robot.getFuelLevel() < blocks + 32 then
--  print ("You do not have enough fuel. This job needs ", blocks, " fuel.")
--  return
--end

function step()
  while not robot.forward() do
    robot.swing()
  end
end

function stepUp()
  while not robot.up() do
    robot.swingUp()
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
  check()
  while not robot.placeDown() do
    robot.swingDown()
  end
  stack = stack - 1
end

function check()
  if stack < 1 then
    print("Waiting for stack.")
    while not findBlock() do end
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

function layer()
  for z = 1, 4, 1 do
    for x = 1, 7, 1 do
      placeDown()
      step()
    end
    robot.turnRight()
    step()
    placeDown()
    step()
    robot.turnLeft()
    step()
    placeDown()
    step()
    robot.turnRight()
    step()
   end
 end

stepUp()

for i = 1, height, 1 do
  layer()
  stepUp()
end

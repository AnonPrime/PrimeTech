local robot = require("robot")

local tArgs = {...}

local length = 0
local width = 1

local stack = 0
local depth = 0
local distance = 0
local dev = false
local verbose = false

-- Help Text --

function helpText()
  print("Usage: levelfill [Length] [Width]")
  print("")
  print("This program will fill an area to the level")
  print("that the robot was placed at. Place the robot")
  print("with its back and left sides in one corner.")
  print("[Length] - How far forward the robot will go")
  print("[Width] - How wide of a space to fill")
  print("If one value is present, will assume length")
  print("and will only do on wide.")
end

-- Validate Arguments --

if tArgs[1] == "help" or tArgs[1] == nil then
  helpText()
  if dev then
    print(tArgs[1]," ",tArgs[2])
  end
  return
end

length = tonumber(tArgs[1])
if length == nil then
  helpText()
  return
end

if tArgs[2] ~= nil then
  height = tonumber(tArgs[2])
  if height == nil then
    helpText()
    return
  end
end

-- Functions --

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

function place()
  if dev and verbose then
    print("place()")
  end
   if stack < 1 then
      print ("Waiting for stack.")
      while not findBlock() do end
  end
  if robot.place() then
    stack = stack - 1
  end
end

function placeDown()
  if dev and verbose then
    print("placeDown()")
  end
  if stack < 1 then
      print ("Waiting for stack.")
      while not findBlock() do end
  end
  if robot.placeDown() then
    stack = stack - 1
  end
end

function back()
  if dev and verbose then
    print("back()")
  end
  if not robot.back() then
    stuck = true
  end
end

function up()
  if dev and verbose then
    print("up()")
  end
  if not robot.up() then
    stuck = true
  end
end

function down()
  if dev and verbose then
    print("down()")
  end
  if not robot.down() then
    stuck = true
  end
end

function forward()
  if dev and verbose then
    print("forward()")
  end
  if not robot.forward() then
    stuck = true
  end
end

for i = 1, length, 1 do
  if not stuck then
    while robot.down() dp
      depth = depth + 1
    end
    for j = depth, 0, -1 do
      up()
      placeDown()
    end
    if i ~= length then
      forward()
    end
  end
end


if stuck then
  print ("Help boss! I seem to be in a jam here.")
else
  print ("I think I'm done boss. Better double check my work though.")
end

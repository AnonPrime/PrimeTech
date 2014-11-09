----------------------------------------
-- File Name: supports                --
-- Version    1.0                     --
-- Date:      2014/02/06              --
-- Author:    MiradoPrime             --
----------------------------------------
-- Description: This program will     --
--  place pillars and support beams   --
--  with the dimensions provided.     --
----------------------------------------

local robot = require("robot")

local tArgs = {...}
local space = 3
local height = 0
local pillars = 1
local beams = 0
local beamHeight = 0

local stack = 0
local stuck = false
local dev = true
local verbose = false

-- Help Text --

function helpText()
  print("Usage: supports [Height] [Space] [B Hgt] [Num]")
  print("")
  print("This program will place pillars and support")
  print("beams with the dimensions provided.")
  print("[Height] = Total Height of pillars")
  print("[Space] = Space between pillars")
  print("[B Hgt] = Height between support beams")
  print("[Num] = Number of pillars")
  print("Providing a value of 0 will use defaults")
end

-- Validate Arguments --

if tArgs[1] == "help" or tArgs[1] == nil or tArgs[2] == nil or tArgs[3] == nil or tArgs[4] == nil then
  helpText()
  print(tArgs[1]," ",tArgs[2]," ",tArgs[3]," ",tArgs[4])
  return
end

height = tonumber(tArgs[1])
space = tonumber(tArgs[2])
beamHeight = tonumber(tArgs[3])
pillars = tonumber(tArgs[4])


if height == nil or space == nil or pillars == nil or beamHeight == nil then
  helpText()
  return
end

if dev then
  print ("Arguments passed Validation: ")
  print ("  ",height," ",space," ",beamHeight," ",pillars)
end

-- Pillar --
--
-- Builds a pillar of a variable height

function pillar(p)
  local total = height
  if height == 0 then
    while robot.up() do
	  if p % (space + 1) == 0 then
		placeDown(1)
	  else
		if (total + 1) % ( beamHeight +  1) == 0 then
			placeDown(1)
		else
			placeDown(2)
		end
	  end
      total = total + 1
    end
    back()
    if not stuck then 
      	  if p % (space + 1) == 0 then
		place(1)
	  else
		if (total + 1) % ( beamHeight +  1) == 0 then
			place(1)
		else
			place(2)
		end
	  end
      total = total + 1
    else
      return total
    end
    for i = 1, total, 1 do
      robot.down()
    end
  else
    for i = 1, height - 1, 1 do
      up()
      if not stuck then 
	  if p % (space + 1) == 0 then
		placeDown(1)
	  else
		if (total + 1) % ( beamHeight +  1) == 0 then
			placeDown(1)
		else
			placeDown(2)
		end
	  end
      else
        break
      end
    end
    back()
    if not stuck then
      	  if p % (space + 1) == 0 then
		place(1)
	  else
		if (total + 1) % ( beamHeight +  1) == 0 then
			place(1)
		else
			place(2)
		end
    else
      return total
    end
    for i = 1, height - 1, 1 do
      down()
      if stuck then
        break
      end
    end
	end
  return total
end

function findBlock(slot)
  stack = 0
  local found = false
  for i = 2, 16, 1 do
    robot.select(i)
    if robot.count(i) > 0 and robot.compareTo(slot) then
      found = true
      stack = robot.count(i)
	  if stack > 1 then
		break
	  end
    end
  end
  return found
end
	
function place(slot)
  if dev and verbose then
    print("place()")
  end
  if not robot.compareTo(slot) then
    findblock(slot)
  end
  if stack < 1 then
      print ("Waiting for stack.")
      while not findBlock(slot) do end
  end
  if robot.place() then
    stack = stack - 1
  end
end

function placeDown(slot)
  if dev and verbose then
    print("placeDown()")
  end
  if not robot.compareTo(slot) then
    findblock(slot)
	
  end
  if stack < 1 then
      print ("Waiting for stack.")
      while not findBlock(slot) do end
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

for i = 0, (1 + (pillars * (space + 1)), 1 do
	pillar(i)
	if stuck then 
		return
	end
end


if stuck then
  print ("Help boss! I seem to be in a jam here.")
else
  print ("I think I'm done boss. Better double check my work though.")
end

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

function pillar()
  if dev and verbose then
    print("pillar()")
  end
  local total = height
  if height == 0 then
    while robot.up() do
      placeDown()
      total = total + 1
    end
    back()
    if not stuck then 
      place()
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
        placeDown()		
      else
        break
      end
    end
    back()
    if not stuck then
      place()
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


function beam()
  if dev and verbose then
    print("beam()")
  end
  if space > 0 then
    if beams > 0 then
      if dev then
        print("Making ",beams," beams, ",space," blocks long.")
      end
      for i = 1, beams, 1 do
        for j = 1, beamHeight, 1 do
          up()
          if stuck then
            return
          end
        end
        for k = 1, space, 1 do
          back()
          if stuck then
            return
          end
          place()
        end
        if i ~= beams then
          up()
          if stuck then
            return
          end
          for l = 1, space, 1 do
            forward()
            if stuck then
              return
            end
          end
        else
          for m = 1, ((beamHeight + 1)*beams) - 1, 1 do
            down()
            if stuck then
              print("Failed to move down",((beamHeight + 1)*beams) - 1," blocks.")
              return
            end
          end
        end
      end
    end
    if beams == 0 then
      if dev then
        print("Not making any beams!")
      end
      for n = 1, space, 1 do
        back()
        if stuck then
          return
        end
      end
    end
  end
  return
end

if pillars == 0 then
  while not stuck do
    beams = math.floor(pillar() / (beamHeight + 1))
    if dev then
      print("Beams: ",beams)
    end
    if stuck then
      break
    else
      beam()
    end
  end
else
  for i = 1, pillars, 1 do
    if not stuck then
      beams = math.floor(pillar() / (beamHeight + 1))
      if dev then
        print("Beams: ",beams)
      end
      if stuck then
        break
      elseif i ~= pillars  then
        beam()
      end
    end
  end
  robot.turnRight()
  back()
  while robot.down() do
  end
end

if stuck then
  print ("Help boss! I seem to be in a jam here.")
else
  print ("I think I'm done boss. Better double check my work though.")
end

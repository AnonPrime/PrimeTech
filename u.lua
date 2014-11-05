----------------------------------------
-- File Name: u                       --
-- Version    1.0                     --
-- Date:      2014/02/06              --
-- Author:    MiradoPrime             --
----------------------------------------
-- Description: This program will     --
--  make the robot attempt to move   --
--  up a number of times.             --
--  The program keeps track of the    --
--  distance travelled and outputs it.--
--  If the robot detects an object,  --
--  it will stop.                     --
----------------------------------------

local robot = require("robot")

local args = {...}
local distance = 0
local actual = 0

if args[1] == nil then
  distance = 1
else
  distance = tonumber(args[1])
end

for i = 1, distance, 1 do
  if not robot.up() then
    print("I can't go any further boss.")
    break
  end
  actual = actual + 1
end

print("The total distance was ",actual, " blocks up.")

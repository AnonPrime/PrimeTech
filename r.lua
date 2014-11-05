----------------------------------------
-- File Name: l                       --
-- Version    1.0                     --
-- Date:      2014/02/06              --
-- Author:    MiradoPrime             --
----------------------------------------
-- Description: This program will     --
--  make the robot turn left 90      --
--  degrees a number of times.        --
----------------------------------------

local robot = require("robot")

local tArgs = {...}
local times = 0

if tArgs[1] == nil then
  robot.turnLeft()
  return
end

if tArgs[1] == "help" then
  print("Usage: r [times]")
  print("This program will make robot turn left.")
  print("Will turn once with no arguments or number of [times].")
  return
end

times = tonumber(tArgs[1])

if times == nil then
  print("You are not making any sense boss.") 
elseif times == 0 then
  print("I didn't move, just like you asked boss.")
else
  for i = 1, times, 1 do
    robot.turnLeft()
      if i == 4 then
      print("Wheeeeee!")
    elseif i == 10 then
      print("Wheeeeeeeeee!")
    elseif i == 18 then
      print("I Say, we must move forward, not backward.")
    elseif i == 19 then
      print("Upward not forward. And always Twirling.")
    elseif i == 20 then
      print("Twirling, twirling, twirling towards freedom!")
    elseif i == 50 then
      print("Please, enough! I'm getting sick now boss.")
    end
  end
  print("I turned left ",times," times just like you asked boss.")
end

--[[
    Stuffed Sensor aka stuffy
    Copyright 2022 Luke Turner. Released under the MIT License.
    Tested with Create Above and Beyond modpack, your mileage may vary!

    Reads the contents of the inventory above, and emits a redstone signal out the front
    if the inventory above is full. Workaround for what seems to be a bug when reading
    Drawers with Stockpile Sensors.
    
    Code needs to be updated for different drawer sizes:

    - set expectedSlots to the number of locked slots in the drawer
      (e.g. if only using 3 slots of a 4-slot drawer, set this to 3)
      
    - set maxItems to the max stack size for each stack since this info can be inaccurate
      when reading from the drawer's inventory API.
--]]



print("= STUFFED SENSOR =")
print("")
print("inventory on top")
print("redstone output from front")
print("")

local inv = peripheral.wrap("top")
local expectedSlots = 1 -- TODO Update me each time
local maxItems = 1024   -- TODO update me each time

while true do
  local isFull = true
  local slotsSeen = 0
  for slot, item in pairs(inv.list()) do
    slotsSeen = slotsSeen + 1
    if item.count < maxItems then
      -- slot isn't full
      isFull = false
    end
  end
  
  if slotsSeen < expectedSlots then
    isFull = false
  end

  redstone.setOutput("front", isFull)
  sleep(5)
end
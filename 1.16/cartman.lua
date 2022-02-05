--[[
    Cart Manager aka cartman
    Copyright 2022 Luke Turner. Released under the MIT License.
    Tested with Create Above and Beyond modpack, your mileage may vary!

    Program to extract from Minecart Unloaders and insert into any other inventory touching
    the computer -- or, extracting from said inventory and inserting into Minecart Loaders.
    Unloaders/Loaders are from the More Minecarts mod. Because they have the option
    to "leave one item in slot," you can transfer up to 27 stacks of different items
    in a single minecart without risk of one item backstuffing and messing up the other
    items. This program provides similar functionality when extracting from Unloaders -- it
    leaves an item in every slot for filtering purposes.
--]]

print("")
print("= CART MANAGER =")
print("")

local inventories = { peripheral.find("inventory") }

local loaders = {}
local unloaders = {}
local otherInventories = {}

for _, x in ipairs(inventories) do
    if peripheral.hasType(x, "moreminecarts:minecart_unloader_te") then
        table.insert(unloaders, x)
    elseif peripheral.hasType(x, "moreminecarts:minecart_loader_te") then
        table.insert(loaders, x)
    elseif not peripheral.hasType(x, "create:belt") then
        table.insert(otherInventories, x)
    end
end

print("Loaders:")
for _, x in ipairs(loaders) do print("  ", peripheral.getName(x)) end

print("Unloaders:")
for _, x in ipairs(unloaders) do print("  ", peripheral.getName(x)) end

print("Inventories:")
for _, x in ipairs(otherInventories) do print("  ", peripheral.getName(x)) end

-- TODO, this balancing algorithm doesn't work very well when things get full
function pushBalanced(srcInv, destInvs)
    for slot, item in pairs(srcInv.list()) do
        local itemCount = item.count
        local numInvs = #destInvs
        for _, inv in ipairs(destInvs) do
            local destName = peripheral.getName(inv)
            local itemsPerInv = math.floor((itemCount - 1) / numInvs)
            local itemsMoved = srcInv.pushItems(destName, slot, itemsPerInv)
            print(("\nmoved %d %s to %s"):format(itemsMoved, item.name, destName))
            itemCount = itemCount - itemsMoved
            numInvs = numInvs - 1
        end
    end
end

while true do
    term.write(".")
    for _, unloader in ipairs(unloaders) do
        pushBalanced(unloader, otherInventories)
    end
    for _, inv in ipairs(otherInventories) do
        pushBalanced(inv, loaders)
    end
    sleep(10)
end
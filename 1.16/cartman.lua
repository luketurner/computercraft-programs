-- Minecart loader/unloader manager program
-- Copyright 2022 Luke Turner. Released under the MIT License.
-- Tested with Create Above and Beyond modpack, your mileage may vary!

print("")
print("= CARTMAN =")
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
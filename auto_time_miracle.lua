local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(game:GetService('ReplicatedStorage').src.Loader)
local ItemInventoryServiceClient = Loader.load_client_service(script, "ItemInventoryServiceClient")

-- Function to get normal items
function get_inventory_items()
    return ItemInventoryServiceClient["session"]["inventory"]['inventory_profile_data']['normal_items']
end

-- Function to count specific materials
function countMaterials(materialsToCount)
    local normalItems = get_inventory_items()
    local materialCounts = {}

    -- Initialize counts for the materials we want to count
    for _, material in ipairs(materialsToCount) do
        materialCounts[material] = 0
    end

    -- Count the materials in the normal items
    for itemName, itemCount in pairs(normalItems) do
        if materialCounts[itemName] ~= nil then
            materialCounts[itemName] = materialCounts[itemName] + itemCount -- Directly use itemCount
        end
    end

    return materialCounts
end

-- Function to craft ingots_steel from 15 ore_steel
local function craftIngotsSteel()
    local args = {
        [1] = "ingots_steel",
        [2] = "craft_relics_ui"
    }
    ReplicatedStorage.endpoints.client_to_server.craft_item:InvokeServer(unpack(args))
    print("Crafted ingots_steel!") -- Notification for crafting
end

-- Function to join the lobby
local function joinLobby(lobbyName)
    local args = {
        [1] = lobbyName
    }
    ReplicatedStorage.endpoints.client_to_server.request_join_lobby:InvokeServer(unpack(args))
    print("Joined lobby: " .. lobbyName) -- Notification for joining lobby
end

-- Function to lock the level
local function lockLevel(level)
    local args = {
        [1] = "_lobbytemplategreen4",
        [2] = level,
        [3] = false,
        [4] = "Hard"
    }
    ReplicatedStorage.endpoints.client_to_server.request_lock_level:InvokeServer(unpack(args))
    print("Locked level: " .. level) -- Notification for locking level
end

-- Function to craft hourglass_relic
local function craftHourglassRelic()
    local args = {
        [1] = "hourglass_relic",
        [2] = "craft_relics_ui"
    }
    ReplicatedStorage.endpoints.client_to_server.craft_item:InvokeServer(unpack(args))
    print("Crafted hourglass_relic!") -- Notification for crafting
end

-- Main execution loop
while true do
    -- Specify the materials you want to count
    local materialsToCount = {
        "ore_steel",
        "ingots_steel",
        "book_material",
        "devil_heart",
        "julius_page"
    }

    -- Count the materials
    local materialCounts = countMaterials(materialsToCount)

    print("Material Counts:")
    for material, count in pairs(materialCounts) do
        print(material .. ": " .. count)
    end 

    -- Craft ingots_steel if there are at least 15 ore_steel
    if materialCounts["ore_steel"] >= 15 then
        craftIngotsSteel()
    end

    -- Check conditions for joining lobbies
    if materialCounts["ingots_steel"] < 18 or materialCounts["book_material"] < 25 then
        joinLobby ("_lobbytemplategreen4") -- Join clover_legend_2
        lockLevel("clover_legend_2") -- Lock the level to clover_legend_2
    elseif materialCounts["devil_heart"] < 2 or materialCounts["julius_page"] < 25 then
        joinLobby("_lobbytemplategreen4") -- Join clover_legend_3
        lockLevel("clover_legend_3") -- Lock the level to clover_legend_3
    end

    -- If all materials are sufficient, craft hourglass_relic
    if materialCounts["ingots_steel"] >= 18 and materialCounts["book_material"] >= 25 and materialCounts["devil_heart"] >= 2 and materialCounts["julius_page"] >= 25 then
        craftHourglassRelic() -- Craft the hourglass_relic
        wait(2) -- Wait for a short period to ensure the crafting process is completed
    end

    wait(10) -- Wait before the next iteration to avoid spamming requests
end

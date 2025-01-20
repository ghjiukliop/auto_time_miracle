local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Function to check the inventory for a specific item
local function getItemCount(itemName)
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack") -- Check the Backpack for items
    if backpack then
        local item = backpack:FindFirstChild(itemName)
        if item then
            return item.Value -- Assuming the item has a Value property that indicates the count
        end
    end
    return 0
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
local function joinLobby()
    local args = {
        [1] = "_lobbytemplategreen4"
    }
    ReplicatedStorage.endpoints.client_to_server.request_join_lobby:InvokeServer(unpack(args))
    print("Joined lobby: _lobbytemplategreen4") -- Notification for joining lobby
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
    -- Check the counts of ore_steel, ingots_steel, book_material, devil_heart, and julius_page
    local oreSteelCount = getItemCount("ore_steel")
    local ingotsSteelCount = getItemCount("ingots_steel")
    local bookMaterialCount = getItemCount("book_material")
    local devilHeartCount = getItemCount("devil_heart")
    local juliusPageCount = getItemCount("julius_page")

    -- Craft ingots_steel if there are at least 15 ore_steel
    if oreSteelCount >= 15 then
        craftIngotsSteel()
    end

    -- If ingots_steel is below 18 or book_material is below 25, join clover_legend_2 and lock the level
    if ingotsSteelCount < 18 or bookMaterialCount < 25 then
        joinLobby() -- Join the lobby
        wait(2) -- Wait for a short period to ensure the lobby join is processed
        lockLevel("clover_legend_2") -- Lock the level to clover_legend_2
    end

    -- If devil_heart is below 2 or julius_page is below 25, join clover_legend_3 and lock the level
    if devilHeartCount < 2 or juliusPageCount < 25 then
        joinLobby() -- Join the lobby
        wait(2) -- Wait for a short period to ensure the lobby join is processed
        lockLevel("clover_legend_3") -- Lock the level to clover_legend_3
    end

    -- If all materials are sufficient, craft hourglass_relic
    if ingotsSteelCount >= 18 and bookMaterialCount >= 25 and devilHeartCount >= 2 and juliusPageCount >= 25 then
        craftHourglassRelic() -- Craft the hourglass_relic
        wait(2) -- Wait for a short period to ensure the crafting is processed
    end

    wait(10) -- Wait for 10 seconds before checking again (adjust as needed)
end
-- Import necessary modules
local GetService = require(game:GetService("ReplicatedStorage").Library.GetService)

-- Get Players service  
local Players : Player = game:GetService("Players")

-- Get ServerScriptService
local ServerScriptService = GetService['ServerScriptService']

-- Get HttpService for HTTP requests
local HttpService = GetService['HttpService']

-- Get Remotes folder from ReplicatedStorage
local Remotes : Folder = GetService['ReplicatedStorage']:FindFirstChild('Remotes')

-- Discord webhook URL for sending messages
local Webhook : HttpService = "https://discordapp.com/api/webhooks/1261464441967612054/JtTohRe7cMbgyUZl7ZVE-ul6H0jraT8vvUimL4igl2PXGhNXBSVRq-pTrywQgztz4CYP"

-- Import module table
local ModuleTable = require(GetService['ReplicatedStorage'].Library.ModuleTable)

-- Import table copy function  
local CopyTable = require(GetService['ReplicatedStorage'].Library.CopyTable)

-- Import DataStore2 module for data storage
local DataStore2 = require(ServerScriptService.DataStore2)

-- Main data module
local DataModule = {}

-- Save timer
DataModule.SaveTimer = 0

-- Player data table
DataModule.DataPlayer = {}

-- Auto save table
DataModule.AutoSaves = {}

-- API keys for data
DataModule.APIkey = {
    Main = "Data_Server_VersionTestData4",
    Client = "Data_Client_VersionTestData4"
}

-- Function to create a new player
function DataModule:New(player : Player) -- Add all table structures
    self = setmetatable({}, DataModule)

    -- Player game settings
    self.SettingsGame = {
        Loaded = false,
        Rank = "",
        PlayerName = player.Name,
        HP = 100,
        Premium = false,
        Banned = false,
        Tutorial = false,
        RobuxPurchases = {}
    }

    -- Menu settings
    self.SettingsMenu = {
        ['Pollen Text'] = true
    }

    -- Fake settings
    self.FakeSettings = {
        -- Field settings
        Field = "",
        OldField = "",
        GuiField = false,
        -- Mobs settings 
        MobsAttack = false,
        ModsField = nil,
        PlayerAttack = false,
        -- Hive settings
        HiveOwner = "",
        HiveNumberOwner = ""
    }

    -- Player stats
    self.IStats = {
        Honey = 0,
        DailyHoney = 0,
        Pollen = 0,
        Capacity = 0
    }

    -- Player boosts
    self.BoostGame = {
        FieldBoost = {},
        PlayerBoost = {
            ["Instant"] = 0,
            ["Pupler Instant"] = 0,
            ["White Instant"] = 0,
            ["Blue Instant"] = 0,
            ['Pollen'] = 100,
            ["Pupler Pollen"] = 100,
            ["White Pollen"] = 100,
            ["Blue Pollen"] = 100,
            ['Movement Collection'] = 100,
            -- Field boosts
            ['BananaPath1'] = 100
        },
        TokenBoost = {},
        CraftBoost = {}
    }

    -- Hive module
    self.HiveModule = {
        HiveSlotAll = 33, -- Total slots for player
        WaspSlotHive = {}
    }

    -- Fill hive slots with test data
    for i = 1, 33 do
        self.HiveModule.WaspSlotHive[i] = {
            Name = 'Test',
            Level = 1,
            Rarity = "★",
            Color = "Pupler",
            Band = 0
        }
    end

    -- Player equipment
    self.Equipment = {
        Tool = "Shovel",
        Bag = "Backpack",
        Shops = {
            Tools = {['Shovel'] = true},
            Bags = {['Backpack'] = true}
        }
    }

    -- Save player data
    DataModule.DataPlayer[player.Name] = self
    return self
end

-- Function to set items in studio
function DataModule:StudioItems(Player)
    local IsStudio = {}
    if game:GetService("RunService"):IsStudio() then
        self = setmetatable(DataModule.DataPlayer[Player.Name], IsStudio)
        self.IStats = {
            Honey = 1000,
            DailyHoney = 1000,
            Pollen = 0,
            Capacity = 1000
        }
        return DataModule.DataPlayer[Player.Name]
    end
end

-- Function to get player data
function DataModule:Get(Player)
    if game:GetService("RunService"):IsServer() then
        DataModule:StudioItems(Player)
        return DataModule.DataPlayer[Player.Name]
    else
        return Remotes.GetDataSave:InvokeServer()
    end
end

-- Player check
function DataModule.CheckPlayer(Client, PData)
    coroutine.wrap(function()
        if Client:GetRankInGroup(33683629) == 3 then
            DataModule:StudioItems(Client) -- When testing is allowed
        end
    end)()

    coroutine.wrap(function()
        for _, GetTable in next, ModuleTable.PlayerGame.BanPlayer do
            if GetTable == Client.Name then
                Client:Kick('Banned #001') -- Kick player due to ban
            end
        end
    end)()

    --[[coroutine.wrap(function() -- To be done properly
        local _, Err = pcall(function()
            HttpService:PostAsync(Webhook,
            HttpService:JSONEncode({
                content = `Player entered: {Client.Name} \n Player ID: {Client.UserId}, \n Player DataStore: \n {HttpService:JSONEncode(PData)}` -- Make PData
            })
        end)
        if Err then
            warn(Err)
        end
    end)]]--
end

-- Data storage function
function DataModule.DataStorage(Client, DataStorage) --! CHECK LOAD
    local Data : table = DataModule:Get(Client)
    for index, value in next, DataStorage do
        Data[index][value] = DataStorage[index][value]
    end
    return Data
end

-- Save player data function
function SaveData(client, PData)
    print(DataModule.DataPlayer[client.Name])
    DataStore2(DataModule.APIkey.Client, client):Set(CopyTable:CopyWithoutFunctions(PData))
    Remotes.DataUpdate:FireClient(client, PData)
end

-- Load player data function 
function DataModule:LoadData(Client)
    local _, Err = pcall(function()
        DataStore2.Combine(DataModule.APIkey.Main, DataModule.APIkey.Client)
        local PData : table = DataModule:New(Client)
        local DataStorage = DataStore2(DataModule.APIkey.Client, Client):GetTable(PData)
        PData = DataModule.DataStorage(Client, DataStorage)
        DataModule.CheckPlayer(Client, PData)
        PData.SettingsGame.Loaded = true
        DataModule.AutoSaves[Client.Name] = Client
    end)

    if Err then
        warn(Err) -- Output error if it occurred
    end
end

-- Connect events for players
do
    Players.PlayerAdded:Connect(function(player)
        DataModule:LoadData(player) -- Load data when player joins
    end)

    Players.PlayerRemoving:Connect(function(player)
        SaveData(player, DataModule:Get(player)) -- Save data when player leaves
        DataModule.AutoSaves[player.Name] = nil
    end)

    game.ReplicatedStorage.Remotes.GetDataSave.OnServerInvoke = function(client)
        local PData : table = DataModule:Get(client)
        return PData -- Return player data
    end

    coroutine.wrap(function()
        local _, Err = pcall(function()
            while true do 
                task.wait(1)
                DataModule.SaveTimer += 1
                if DataModule.SaveTimer > 2 then
                    for _, Player in pairs(DataModule.AutoSaves) do
                        if Player ~= nil then
                            local PData = DataModule:Get(Player)
                            SaveData(Player, PData) -- Automatic data saving
                        end
                    end
                    DataModule.SaveTimer = 0
                end
            end
        end)
    end)()
end

return DataModule -- Return data module

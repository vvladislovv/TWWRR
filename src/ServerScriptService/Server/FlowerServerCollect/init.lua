local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local GetService = require(ReplicatedStorage.Libary.GetService)
local Data = require(ServerScriptService.Server.Data)


local FlowerServerCollect = {}
FlowerServerCollect.FlowerPlayerTable = {}

function CollectFlower(Player : Player, Flower : Part , TSS : table)
    
end

Remotes.CollercterFlower.OnServerEvent:Connect(CollectFlower)

coroutine.wrap(function()
    game.Players.PlayerAdded:Connect(function(Player)
        FlowerServerCollect.FlowerPlayerTable[Player.Name] = {White = 0, Blue = 0, Coin = 0,  Pupler = 0}
    end)

    game.Players.PlayerRemoving:Connect(function(Player)
        FlowerServerCollect.FlowerPlayerTable[Player.Name] = nil
    end)
end)()

return FlowerServerCollect
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Data = require(ServerScriptService.Server.Data)


local ServerButton = {}

local function Distation(Button : Part, HRP : Humanoid)
    return function ()
        return (Button.Position - HRP.Position).Magnitude
    end
end


function Start()
   coroutine.wrap(function()
        local _, Err = pcall(function()

            game:GetService("RunService").Heartbeat:Connect(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    local Humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                    local HumRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    local PData = Data:Get(player)
                    if Humanoid and Humanoid.Health > 0 and HumRootPart then
                        for _, Button in ipairs(game.Workspace.GameSettings.Button:GetChildren()) do
                            if PData.SettingsGame.Loaded then
                                local Distance = Distation(Button, HumRootPart)()
                                if ReplicatedStorage.Remotes:WaitForChild('ButtonClient') ~= nil and player ~= nil then
                                    ReplicatedStorage.Remotes:WaitForChild('ButtonClient'):FireClient(player,Button,Distance)
                                end
                            end
                        end
                    end
                end
            end)

        end)

        if Err then
            warn(Err)
        end
   end)()
end

ReplicatedStorage.Remotes.ClientOpenServer.OnServerEvent:Connect(Start)

return ServerButton
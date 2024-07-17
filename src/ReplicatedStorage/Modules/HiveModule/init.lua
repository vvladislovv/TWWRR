local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetService = require(ReplicatedStorage.Libary.GetService)
local DataClient = require(ReplicatedStorage.Libary.DataClient)
local Player = GetService['Players'].LocalPlayer
local HiveFolder = workspace.GameSettings.Hives
local Remotes = ReplicatedStorage.Remotes
local StartHive = false
local PData = DataClient:PDataClient() -- _G.PData

local HiveModule = {}

function HiveModule:Start(Button : Part)
    if PData.FakeSettings.HiveOwner ~= Player.Name or Button:GetAttribute('HiveOwner') == "" then
        HiveOwnerClient(Button)
    end
end

function HiveOwnerClient(Button: Part)
    for _, index in next, HiveFolder:GetChildren() do        

        local function Touched(hit)
            if Player.Character == hit.Parent then
                if StartHive == false and PData.FakeSettings.HiveOwner == "" then
                    StartHive = true
                    Button.B.Enabled = false
                    Remotes.HiveOwner:FireServer(index,Button)
                end
            end
        end

        index.Platform.Up.Touched:Connect(Touched)
    end
end

function ButtonClientOwner(Button : Part, PDataServer : table, Hive : Folder)
    if PDataServer.FakeSettings.HiveOwner == Player.Name then
        Hive.Platform.Down.ParticleEmitter.Enabled = true
        Hive.Platform.Down.Highlight.Enabled = true
        Button.B.Enabled = true
    end
end

Remotes.HiveReturnClient.OnClientEvent:Connect(ButtonClientOwner)

return HiveModule
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetService = require(ReplicatedStorage.Libary.GetService)
local DataClient = require(ReplicatedStorage.Libary.DataClient)
local Player = GetService['Players'].LocalPlayer
local HiveFolder = workspace.GameSettings.Hives
local Remotes = ReplicatedStorage.Remotes

local PData = DataClient:PDataClient() -- _G.PData

local HiveModule = {}

function HiveModule:Start(Button : Part)
    if PData.FakeSettings.HiveOwner ~= Player.Name or Button:GetAttribute('HiveOwner') == "" then
        print(PData.FakeSettings.HiveOwner)
        print(Button:GetAttribute('HiveOwner'))
        HiveOwnerClient(Button)
    end
end



function HiveOwnerClient(Button: Part)
    for _, index in next, HiveFolder:GetChildren() do
        local StartHive = false

        local function Touched(hit)
            if Player.Character == hit.Parent then
                if StartHive == false then
                    StartHive = true
                    Button.B.Enabled = false
                    Remotes.HiveOwner:FireServer(index,Button)
                end
            end
        end

        index.Platform.Up.Touched:Connect(Touched)
    end
end

function ButtonClientOwner(Button : Part)
    Button.B.Enabled = true
end

Remotes.HiveReturnClient.OnClientEvent:Connect(ButtonClientOwner)

return HiveModule
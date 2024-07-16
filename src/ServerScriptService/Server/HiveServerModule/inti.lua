local HiveServerModule = {}
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetService = require(ReplicatedStorage.Libary.GetService)
local Data = require(ServerScriptService.Server.Data)
local HiveFolder = workspace.GameSettings.Hives
local Remotes = ReplicatedStorage.Remotes


function HiveOwner(Player: Player, Hive : Part, Button : Part)
    local PData = Data:Get(Player)
    if PData.FakeSettings.HiveOwner == "" and Hive:GetAttribute('Owner') == "" then
        -- придумать штуку которая будет менять дату которая не созраняеться на сервер и будет отсылка на клиент(Там уже будет все видно)
        PData.FakeSettings.HiveOwner = Player.Name
        Hive:SetAttribute('Owner', Player.Name)
        Button:SetAttribute('HiveOwner', Player.Name)
        Button.B.Enabled = false
        PData.FakeSettings.HiveNumberOwner = Hive.Name
        Hive.Platform.Up.SurfaceGui.Namer.Text = Player.Name
        Hive.Platform.Up.SurfaceGui.Tags.Text = Player.DisplayName
        Hive.Platform.Down.Highlight.Enabled = false

        Remotes.HiveReturnClient:FireClient(Player,Button)
    end

end



Remotes.HiveOwner.OnServerEvent:Connect(HiveOwner)

return HiveServerModule
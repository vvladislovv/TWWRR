local HiveServerModule = {}

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GetService = require(ReplicatedStorage.Libary.GetService)
local Data = require(ServerScriptService.Server.Data)
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)
local ModuleTable = require(ReplicatedStorage.Libary.ModuleTable)
local HiveFolder = workspace.GameSettings.Hives
local Remotes = ReplicatedStorage.Remotes



function HiveOwner(Player: Player, Hive : Part, Button : Part)
    local PData = Data:Get(Player)
    if PData.FakeSettings.HiveOwner == "" and Hive:GetAttribute('Owner') == "" then
        
        PData.FakeSettings.HiveOwner = Player.Name
        Hive:SetAttribute('Owner', Player.Name)
        Button:SetAttribute('HiveOwner', Player.Name)
        Button.B.Enabled = false
        PData.FakeSettings.HiveNumberOwner = Hive.Name
        Hive.Platform.Up.SurfaceGui.Namer.Text = Player.Name
        Hive.Platform.Up.SurfaceGui.Tags.Text = Player.DisplayName
        Hive.Platform.Down.Highlight.Enabled = false
        Hive.NamePlayerHive.NameHive.TextLabel.Text = Player.DisplayName
        Hive.NamePlayerHive.SlotHive.TextLabel.Text = `{PData.HiveModule.HiveSlotAll}/32`
        
        coroutine.wrap(function()
            HiveSpawn(Hive,PData)
            Remotes.HiveReturnClient:FireClient(Player,Button,PData,Hive)
        end)()
    end

end

function CheckSlotWasp(CheckSlot : number, Hive : Folder, PData : table)
    for NumberSlot, GetSlot in next, PData.HiveModule.WaspSlotHive do
        if NumberSlot == CheckSlot then
            local Rarity = tostring(GetSlot.Rarity)
            local GetTableRarity = ModuleTable.Rarity(Rarity)
            if GetTableRarity ~= nil then
                print(ModuleTable.WaspSpecif(GetSlot.Name).Icon)
                Hive.Slots[NumberSlot].Down.SurfaceGui.ImageLabel.Image = ModuleTable.WaspSpecif(GetSlot.Name).Icon
                Hive.Slots[NumberSlot].Down.Color = GetTableRarity[2]
            end
            Hive.Slots[NumberSlot]:SetAttribute('NameWasp',GetSlot.Name)
            Hive.Slots[NumberSlot].Down.Level:SetAttribute('Level',GetSlot.Level)
            Hive.Slots[NumberSlot].Down.Level.SurfaceGui.TextLabel.Text = GetSlot.Level
        end
    end
end

function SpawnSlotHive(Hive : Folder, PData : table)
    local CheckSlotPlayer = PData.HiveModule.HiveSlotAll
    local CheckSlot = 0

    if CheckSlotPlayer ~= CheckSlot then
        repeat
            task.wait(0.1)
            CheckSlot += 1

            CheckSlotWasp(CheckSlot,Hive,PData)
            TweenModule:SpawnSlotHive(Hive,CheckSlot)
        until CheckSlotPlayer == CheckSlot
    end
end


function HiveSpawn(Hive : Folder, PData : table)
    SpawnSlotHive(Hive,PData)
end


Remotes.HiveOwner.OnServerEvent:Connect(HiveOwner)

return HiveServerModule
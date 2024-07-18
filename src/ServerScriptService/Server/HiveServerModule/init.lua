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
        Hive.NamePlayerHive.SlotHive.TextLabel.Text = `{PData.HiveModule.HiveSlotAll}/33`
        
        coroutine.wrap(function()
            Remotes.HiveReturnClient:FireClient(Player,Button,PData,Hive)
            HiveSpawn(Hive,PData)
        end)()
    end

end

function CheckSlotWasp(CheckSlot : number, Hive : Folder, PData : table)
    for NumberSlot, GetSlot in next, PData.HiveModule.WaspSlotHive do
        if NumberSlot == CheckSlot then
            HiveServerModule:SpawnWaspSlot(GetSlot.Name, Hive, CheckSlot)
            local Rarity = tostring(GetSlot.Rarity)
            local GetTableRarity = ModuleTable.Rarity(Rarity)
            if GetTableRarity ~= nil then
                Hive.Slots[NumberSlot].Down.SurfaceGui.ImageLabel.Image = ModuleTable.WaspSpecif(GetSlot.Name).Icon
                Hive.Slots[NumberSlot].Down.Color = GetTableRarity[2]
            end
            Hive.Slots[NumberSlot]:SetAttribute('NameWasp',GetSlot.Name)
            Hive.Slots[NumberSlot].Down.Level:SetAttribute('Level',GetSlot.Level)
            Hive.Slots[NumberSlot].Down.Level.SurfaceGui.TextLabel.Text = GetSlot.Level
        end
    end
end


function HiveServerModule:SpawnWaspSlot(WaspName : string, Hive : Folder, CheckSlot : number)
    local WaspModel = ReplicatedStorage.Wasps[WaspName]:Clone()
    WaspModel.Parent = workspace.GameSettings.Wasps
    local PosSlot = Hive.Slots[CheckSlot].Down.SpawnWasp
    WaspModel.Model:SetPrimaryPartCFrame(CFrame.new(PosSlot.WorldCFrame.Position.X,PosSlot.WorldCFrame.Position.Y,PosSlot.WorldCFrame.Position.Z-3) * CFrame.Angles(0,math.rad(90),0)) 
    TweenModule:CreateWaspHive(WaspModel.Model,PosSlot)
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

function HivePlayerLeave(Player) -- Folder -> player -> Bees + Bag new Hives, Maeby Attribites
    for _, index in next, workspace.GameSettings.Hives:GetChildren() do
        if index:GetAttribute('Owner') == Player.Name then
            local PData = Data:Get(Player)

            local function SpawnHiveSlot()
                if index:GetAttribute('Owner') == PData.FakeSettings.HiveOwner then
                    local CheckSlotPlayer = PData.HiveModule.HiveSlotAll
                    local CheckSlot = 0
        
                    if CheckSlotPlayer ~= CheckSlot then
                        repeat
                            --task.wait(0.25)
                            CheckSlot += 1
                            TweenModule:DestroySlotHive(index, CheckSlot)

                            if CheckSlot <= 0 then
                                CheckSlot = 0
                            end

                        until CheckSlotPlayer == CheckSlot
                    end
                end
            end
            SpawnHiveSlot()
            index:SetAttribute('Owner', "")

            for _, value in workspace.GameSettings.Button:GetChildren() do
                value:SetAttribute('HiveOwner', '')
                value.B.Enabled = true                
            end

            index.Platform.Up.SurfaceGui.Namer.Text = "Nobody"
            index.Platform.Up.SurfaceGui.Tags.Text = ""
            index.NamePlayerHive.NameHive.TextLabel.Text = "Nobody"
            index.NamePlayerHive.SlotHive.TextLabel.Text = `0/33`
        end
    end
end

game.Players.PlayerRemoving:Connect(HivePlayerLeave)

Remotes.HiveOwner.OnServerEvent:Connect(HiveOwner)

return HiveServerModule
local HiveServerModule = {}

local Players : Player = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GetService : ModuleScript = require(ReplicatedStorage.Libary.GetService)
local Data : ModuleScript = require(ServerScriptService.Server.Data)
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local ModuleTable : ModuleScript = require(ReplicatedStorage.Libary.ModuleTable)
local HiveFolde : Folder = workspace.GameSettings.Hives
local Remotes : Folder = ReplicatedStorage.Remotes



function HiveOwner(Player: Player, Hive : Part, Button : Part)
    local PData : table = Data:Get(Player)
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
            HiveServerModule:SpawnWaspSlot(GetSlot.Name, Hive, CheckSlot, PData)

            local Rarity : string = tostring(GetSlot.Rarity)
            local GetTableRarity : table = ModuleTable.Rarity(Rarity)

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


function HiveServerModule:SpawnWaspSlot(WaspName : string, Hive : Folder, CheckSlot : number, PData : table)
    local WaspModel : Script = ReplicatedStorage.Wasps[WaspName]:Clone()
    WaspModel.Parent = workspace.GameSettings.Wasps[PData.SettingsGame.PlayerName]
    local PosSlot : Instance = Hive.Slots[CheckSlot].Down.SpawnWasp
    WaspModel.Model:SetPrimaryPartCFrame(CFrame.new(PosSlot.WorldCFrame.Position.X,PosSlot.WorldCFrame.Position.Y,PosSlot.WorldCFrame.Position.Z-3) * CFrame.Angles(0,math.rad(90),0)) 
    TweenModule:CreateWaspHive(WaspModel.Model,PosSlot)
end

function SpawnSlotHive(Hive : Folder, PData : table)
    local CheckSlotPlayer : number = PData.HiveModule.HiveSlotAll
    local CheckSlot : number = 0

    if not workspace.GameSettings.Wasps:FindFirstChild(PData.SettingsGame.PlayerName) then
        local FolderPlayer : Instance = Instance.new('Folder',workspace.GameSettings.Wasps)
        FolderPlayer.Name = PData.SettingsGame.PlayerName
    end

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

function HivePlayerLeave(Player : Player) -- Folder -> player -> Bees + Bag new Hives, Maeby Attribites
    for _, index in next, workspace.GameSettings.Hives:GetChildren() do
        if index:GetAttribute('Owner') == Player.Name then
            local PData : table = Data:Get(Player)

            local function SpawnHiveSlot()
                if index:GetAttribute('Owner') == PData.FakeSettings.HiveOwner then
                    for NumberSlot, GetSlot in next, PData.HiveModule.WaspSlotHive do
                        local CheckSlotPlayer : number = PData.HiveModule.HiveSlotAll
                        local CheckSlot : number = 0
                        if CheckSlotPlayer ~= CheckSlot then
                            repeat
                                CheckSlot += 1
                                local PosSlot : Instance = index.Slots[CheckSlot].Down.SpawnWasp
                                TweenModule:DestroySlotHive(index, CheckSlot)
                                workspace.GameSettings.Wasps[Player.Name][GetSlot.Name].Model:SetPrimaryPartCFrame(CFrame.new(PosSlot.WorldCFrame.Position.X,PosSlot.WorldCFrame.Position.Y,PosSlot.WorldCFrame.Position.Z-3) * CFrame.Angles(0,math.rad(90),0))

                                coroutine.wrap(function()
                                    if CheckSlot == CheckSlotPlayer then
                                        task.wait(0.5)
                                        workspace.GameSettings.Wasps[Player.Name]:Destroy()
                                     end
                                end)()

                            until CheckSlotPlayer == CheckSlot
                        end
                    end
                end
            end

            SpawnHiveSlot()

            for _, value in workspace.GameSettings.Button:GetChildren() do

                value:SetAttribute('HiveOwner', '')
                value.B.Enabled = true                
            end
            index:SetAttribute('Owner', "")
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
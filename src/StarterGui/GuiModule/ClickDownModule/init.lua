local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = require(ReplicatedStorage.Libary.GetService)
local DataClient = require(ReplicatedStorage.Libary.DataClient)
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)
local ModuleTable = require(ReplicatedStorage.Libary.ModuleTable)
local Player = GuiService['LocalPlayers']
local HiveFolder = workspace.GameSettings.Hives
local PlayerGui = Player:WaitForChild('PlayerGui')
local Dragging = false

local ClickDownModule = {}

function DownClick()
    local _, err = pcall(function()
        if not Dragging then
            Dragging = true
            local Type = PlayerGui.ScreenGuiTest.Frame.Frame.ImageButton:GetAttributes()
            local PData = DataClient:Get(Player)
            local CheckSlot = 0
            local PlayerSlot = PData.HiveModule.HiveSlotAll
            Dragging = false
            for index, value in next, (Type) do
                if value == "Food" and PData.FakeSettings.HiveNumberOwner ~= "" then
                    if HiveFolder[PData.FakeSettings.HiveNumberOwner]:GetAttribute('Owner') == Player.Name then
                        if CheckSlot ~= PlayerSlot then
                            repeat task.wait()
                                CheckSlot += 1
                                TweenModule:SlotEffectFood(HiveFolder[PData.FakeSettings.HiveNumberOwner].Slots[CheckSlot])
                            until CheckSlot == PlayerSlot
                        end
                    end
                end
            end
        end
    end)

    if err then
        warn(err)
    end
end

function UpClick()
    local _, err = pcall(function()
        if not Dragging then
            Dragging = true
            local Type = PlayerGui.ScreenGuiTest.Frame.Frame.ImageButton:GetAttributes()
            local PData = DataClient:Get(Player)
            local CheckSlot = PData.HiveModule.HiveSlotAll
            local PlayerSlot = PData.HiveModule.HiveSlotAll
            Dragging = false
            for index, value in next, (Type) do
                if value == "Food" and PData.FakeSettings.HiveNumberOwner ~= "" then
                    if HiveFolder[PData.FakeSettings.HiveNumberOwner]:GetAttribute('Owner') == Player.Name then
                        repeat task.wait()
                
                            for NumberSlot, GetSlot in next, PData.HiveModule.WaspSlotHive do
                                if NumberSlot == CheckSlot then
                                    local Rarity = tostring(GetSlot.Rarity)
                                    local GetTableRarity = ModuleTable.Rarity(Rarity)
                                    TweenModule:SlotEffectFoodOff(HiveFolder[PData.FakeSettings.HiveNumberOwner].Slots[NumberSlot],GetTableRarity)
                                end
                            end
                            CheckSlot -= 1
                        until CheckSlot < 1
                    end
                end
            end
        end
    end)

    if err then
        warn(err)
    end
end

PlayerGui.ScreenGuiTest.Frame.Frame.ImageButton.MouseButton1Down:Connect(DownClick)
PlayerGui.ScreenGuiTest.Frame.Frame.ImageButton.MouseButton1Up:Connect(UpClick)

return ClickDownModule
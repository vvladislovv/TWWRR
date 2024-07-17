local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = require(ReplicatedStorage.Libary.GetService)
local DataClient = require(ReplicatedStorage.Libary.DataClient)
local Player = GuiService['LocalPlayers']
local HiveFolder = workspace.GameSettings.Hives
local PlayerGui = Player:WaitForChild('PlayerGui')
local Dragging = false
local PData = DataClient:Get()
local ClickDownModule = {}

function DownClick()
    if not Dragging then
        Dragging = true
        local Type = PlayerGui.ScreenGuiTest.Frame.Frame.ImageButton:GetAttributes()
        print(Type)
        print(PData)
        task.wait(0.5)
        print(PData)
        for index, value in next, (Type) do
            if value == "Food" then
                print(PData.FakeSettings.HiveNumberOwner)
                print(HiveFolder[PData.FakeSettings.HiveNumberOwner]:GetAttribute())
                if HiveFolder[PData.FakeSettings.HiveNumberOwner]:GetAttribute() == Player.Name then
                    
                end
            end
        end
    end
end

PlayerGui.ScreenGuiTest.Frame.Frame.ImageButton.MouseButton1Down:Connect(DownClick)

return ClickDownModule
local GetService = require(game:GetService("ReplicatedStorage").Libary.GetService)
local ReplicatedStorage = GetService['ReplicatedStorage']
local UserInputService = GetService['UserInputService']
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)

local Remotes = ReplicatedStorage.Remotes
local Player = game.Players.LocalPlayer

local ScriptButton = nil
local ButtonModule = {}

function DistationButton(Button : Part, Distation)
    local suc, err = pcall(function()
        ScriptButton = Button
        if Distation < 10 then
            TweenModule.OpenButton(Button.B)

            if Button.Name == "Hive" then
                Button:SetAttribute('OpenButton', true)
            end
        elseif Distation > 10  then
            TweenModule.CloseButton(Button.B)
            if Button.Name == "Hive" then
                Button:SetAttribute('OpenButton', false)
            end
        end
    end)
    if err then
        warn(err)
    end
end

function KeyCode(input, GPE)
    if not GPE then
        if input.KeyCode == Enum.KeyCode.E or input.UserInputType == Enum.UserInputType.Touch then
            AnimKeyCode(ScriptButton, input)
            if ScriptButton:GetAttribute('OpenButton') then
                require(script.Parent.HiveModule):Start(ScriptButton)
            end
        end
    end
end

function AnimKeyCode(Button : Part, input)
    task.spawn(function()
        Button.B.ButtonE.ImageColor3 = Color3.fromRGB(255, 255, 255)

        while UserInputService:IsKeyDown(input.KeyCode.EnumType.E) do
            task.wait()
            Button.B.ButtonE.ImageColor3 = Color3.fromRGB(166, 166, 166)
            TweenModule:KeyCode(Button.B)
        end

        if not UserInputService:IsKeyDown(input.KeyCode.EnumType.E) then
            Button.B.ButtonE.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end

    end)
end

UserInputService.InputBegan:Connect(KeyCode)
GetService['ReplicatedStorage'].Remotes.ButtonClient.OnClientEvent:Connect(DistationButton)

return ButtonModule
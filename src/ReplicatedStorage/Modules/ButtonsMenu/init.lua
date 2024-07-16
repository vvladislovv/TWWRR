local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local TweenModule = require(ReplicatedStorage.Libary.TweenModule)
local Remotes = ReplicatedStorage.Remotes
local Player = game.Players.LocalPlayer

local ButtonModule = {}

function DistationButton()
    
end

function KeyCode(input, GPE)
    if not GPE then
        if input.KeyCode == Enum.KeyCode.E or input.UserInputType == Enum.UserInputType.Touch then
            
        end
    end
end


function AnimKeyCode()
    
end


return ButtonModule
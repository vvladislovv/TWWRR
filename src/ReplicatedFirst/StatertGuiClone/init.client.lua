if not game:IsLoaded() then
    game.Loaded:Wait()
end

local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local StarterGui = ReplicatedStorage.StarterGui

coroutine.wrap(function()
    for _, value in next, (StarterGui:GetChildren()) do
        value:Clone().Parent = PlayerGui
    end
end)()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local PData = nil
local DataClient = {}

function DataClient:PDataClient() -- Вместо _G.PData модуль
    local _,Err = pcall(function()
        repeat task.wait()
            PData = Remotes.GetDataSave:InvokeServer()
        until PData ~= nil
    end)

    if Err then
        warn(Err)
    end
    return PData
end



return DataClient
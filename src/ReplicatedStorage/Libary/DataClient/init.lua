local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local DataClient = {}
-- Придумать как сделать постонное обновление 
-- Добавить истязание улья
DataClient[Player.Name] = {}
function DataClient:PDataClient() -- Вместо _G.PData модуль
    local _,Err = pcall(function()
        repeat task.wait()
            if game:GetService("RunService"):IsClient() then
                DataClient[Player.Name] = Remotes.GetDataSave:InvokeServer()
                print(DataClient[Player.Name])
            end
        until DataClient[Player.Name] ~= {}
    end)

    if Err then
        warn(Err)
    end
    --print(PData)
    return DataClient[Player.Name]
end

function UpdateData(PDataNew)
    local _, Err = pcall(function()
        if PDataNew ~= nil then
            DataClient[Player.Name] = PDataNew
            DataClient:PDataClient()
        end
    end)

    if Err then
       warn(Err)
    end
end

function DataClient:Get(Player)
    if game:GetService("RunService"):IsClient() then
        return DataClient[Player.Name]
    end 
end

Remotes.DataUpdate.OnClientEvent:Connect(UpdateData)

return DataClient
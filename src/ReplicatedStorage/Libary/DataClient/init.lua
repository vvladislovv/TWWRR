local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local PData = nil
local DataClient = {}
-- Придумать как сделать постонное обновление 
-- Добавить истязание улья
function DataClient:PDataClient() -- Вместо _G.PData модуль
    local _,Err = pcall(function()
        repeat task.wait()
            PData = Remotes.GetDataSave:InvokeServer()
        until PData ~= nil
    end)

    if Err then
        warn(Err)
    end
    --print(PData)
    return PData
end

function UpdateData(PDataNew)
    local _, Err = pcall(function()
        if PDataNew ~= nil then
            PData = PDataNew
            DataClient:PDataClient()
            print(PDataNew)
        end
    end)

    if Err then
       warn(Err)
    end
end

function DataClient:Get() 
    if game:GetService("RunService"):IsClient() then
		return PData
	end
end


Remotes.DataUpdate.OnClientEvent:Connect(UpdateData)

return DataClient
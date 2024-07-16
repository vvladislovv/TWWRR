local Server = script.Parent.Server
local _, Err = pcall(function()
    --EquipmentModule:StartSysmes()
    for _, index in next, Server:GetDescendants() do
        if index:IsA('ModuleScript') then
            require(index)
        end
    end
end)

coroutine.wrap(function()
    if Err then
        warn(Err)
    end
end)()
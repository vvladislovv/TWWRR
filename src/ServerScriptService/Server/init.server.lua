local Equiment = require(script.Equiment)

local Server : ModuleScript = script.Parent.Server
local _, Err = pcall(function()
    Equiment:StartSysmes()
    for _, index in next, Server:GetDescendants() do
        if index:IsA('ModuleScript') then
            require(index)
           -- print(index)
        end
    end
end)

coroutine.wrap(function()
    if Err then
        warn(Err)
    end
end)()
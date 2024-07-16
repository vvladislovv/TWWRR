game:IsLoaded()
local ClientScript = game.ReplicatedStorage.Modules
local _, Err = pcall(function()
	for _, index in next, ClientScript:GetDescendants() do
		if index:IsA('ModuleScript') then
			require(index)

		end
	end
end)

coroutine.wrap(function()
	if Err then
		warn(Err)
	end
end)
game:IsLoaded()
local ClientScript : ModuleScript = game.ReplicatedStorage.Modules
local _, Err = pcall(function()
	
	coroutine.wrap(function()
		task.wait(0.5)
		game.ReplicatedStorage.Remotes.ClientOpenServer:FireServer()
	end)()

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


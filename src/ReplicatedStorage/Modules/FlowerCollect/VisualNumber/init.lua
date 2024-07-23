local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Remotes : Folder = ReplicatedStorage.Remotes
local TextPart : BasePart = ReplicatedStorage.Assert.VisualNumberPart -- set folder RS
local Player : Player = game.Players.LocalPlayer
local Utils : ModuleScript = require(ReplicatedStorage.Libary.Utils)
local HoneyPos : number, DamagePos : number
local DataClient = require(ReplicatedStorage.Libary.DataClient)
local VisualNumber = {}

VisualNumber.Icon = {
    ['Pupler'] = "",
    ['Blue'] = "",
    ['White'] = "",
}

VisualNumber.TableCollers = {
    Coin = Color3.fromRGB(255, 195, 75),
	Crit = Color3.fromRGB(160, 0, 255),
	Damage = Color3.fromRGB(255, 43, 47),

	White = Color3.fromRGB(255, 255, 255),
	Pupler = Color3.fromRGB(240, 75, 255),
	Blue = Color3.fromRGB(43, 117, 255),
}

function Crit(Text)
   coroutine.wrap(function()
        local RotationAngle : number = 15
        local TS = game:GetService("TweenService")  -- Не забудьте добавить эту строку, если TS не определен

        for i = 1, 6 do
            -- Поворот в одну сторону
            TS:Create(Text, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = RotationAngle}):Play()
            task.wait(0.25)
            -- Поворот в другую сторону
            TS:Create(Text, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = -RotationAngle}):Play()
            task.wait(0.25)
        end
   end)()
end

function GetSize(Amount: number, Crit : boolean)
    return function ()
        local SizeValue : number = 0

        if Amount <= 100 then
            SizeValue = 2
        elseif Amount > 1000 then
            SizeValue = 4
        elseif Amount > 10000 then
            SizeValue = 5
        end
        if Crit and Crit == true then -- DataClient:Get() (PData)
            SizeValue = 1.5 -- (_G.PData.Boost.PlayerBoost["Critical Power"])
        end
        return UDim2.fromScale(SizeValue, SizeValue / 2) 
    end
end


function GetLocation()
	for i : number = 1,2 do
		for _,v in workspace.Map.GameSettings.GameOnline.TextPollen:GetChildren() do
			for _, l in next, workspace.Map.GameSettings.GameOnline.TextPollen:GetChildren() do
				if l ~= v then
					if (v.Position - l.Position).Magnitude <= 0.5 then --  Следующая позиция после первой текста 
						if  tonumber(l.Name) > tonumber(v.Name) then
							l.Position = v.Position + Vector3.new(0,v.BillboardGui.Size.Height.Scale,0)
						else
							l.Position = v.Position + Vector3.new(0,v.BillboardGui.Size.Height.Scale,0)
						end
					end
				end
			end
		end
	end
end


function ray(VP : Vector3?)
	local ray : RaycastParams = RaycastParams.new()
	ray.FilterDescendantsInstances = {game.Workspace.Map.GameSettings.Fields}
	ray.FilterType = Enum.RaycastFilterType.Include

	local raycast : RaycastResult = workspace:Raycast(VP.Position, Vector3.new(0,-100,0), ray)
	if raycast and raycast.Instance then
		if tostring(raycast.Instance) == "Flower" then
			VP.Position = Vector3.new(raycast.Instance.Position.X, VP.Position.Y, raycast.Instance.Position.Z)
		end
	end
end

function VisualEvent(Tab)
    local VP : BasePart = TextPart:Clone()
    local Character = game.Workspace:FindFirstChild(Player.Name)
    VP.Parent = workspace.Map.GameSettings.GameOnline.TextPollen
	VP.BillboardGui.TextPlayer.Size = UDim2.new(0,0,0,0)
    TweenModule:SizeUp(VP)
	VP.BillboardGui.Size = GetSize(Tab.Amt, Tab.Crit)
	VP.Name = Tab.Amt

	if Tab.Color ~= "Coin" and Tab.Color ~= "Damage" then
		if Tab.Pos then
			if typeof(Tab.Pos) == "Vector3" then
				VP.Position = Tab.Pos
			else
				VP.Position = Tab.Pos.Position
			end
		else
			VP.Position = Character.PrimaryPart.Position
		end
		VP.Position += Vector3.new(0,2,0)
		ray(VP)
		local rand = math.random(1, Tab.Amt)
		if rand > 750 then
			Crit(VP.BillboardGui.TextPlayer)
		end
		VP.BillboardGui.TextPlayer.Text = "+"..Utils:CommaNumber(Tab.Amt)
		VP.BillboardGui.TextPlayer.TextColor3 = VisualNumber.TableCollers[Tab.Color]
		GetLocation(VP)
	elseif Tab.Color == "Coin" then
		VP.Parent = workspace.FolderTextPollen
		VP.Position = Character.PrimaryPart.Position + Vector3.new(0,5+HoneyPos,0)
		VP.BillboardGui.TextPlayer.Text = "+"..Utils:CommaNumber(Tab.Amount)
		VP.BillboardGui.TextPlayer.TextColor3 = VisualNumber.TableCollers.Coin
		HoneyPos += VP.BillboardGui.Size.Height.Scale
		if HoneyPos > 3 then
			HoneyPos = 0
		end
	end

	task.wait(0.5)
    TweenModule:SizeDown(VP)
	task.wait(1)
	VP:Destroy()
end

Remotes.VisualNumberEvent.OnClientEvent:Connect(VisualNumber)

return VisualNumber
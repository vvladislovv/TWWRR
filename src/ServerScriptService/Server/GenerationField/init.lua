
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes : Folder = ReplicatedStorage:WaitForChild('Remotes')

local FieldModule = {}
	FieldModule.Flowers = {}
	FieldModule.Fields = {
		["Banana"] = {
			Flowers = {
				MiniWhite = {1, 50},
				DoubleWhite = {1, 40},
                TripleWhite ={0,0},

				MiniPupler = {1, 3},
				DoublePupler = {1, 5},
                TriplePupler ={0,0},

				MiniBlue = {1, 6},
				DoubleBlue = {1, 5},
                TripleBlue ={0,0}
			}
		},
	}
	
	FieldModule.Correspondant = {
		["BananaPath1"] = "Banana",
	}
	
	FieldModule.FlowerTypes = {
		Pupler = {
			["1"] = "rbxassetid://18597562656",
            ["2"] = "rbxassetid://18597564076",
            ["3"] = "rbxassetid://18597565496",
		},
		Blue = {
			["1"] = "rbxassetid://18597560986",
            ["2"] = "rbxassetid://18597559167",
            ["3"] = "rbxassetid://18597554742",
		},
		White = {
            ["1"] = "rbxassetid://18597553591",
            ["2"] = "rbxassetid://18597552081",
            ["3"] = "rbxassetid://18597550680",
		}
	}

	function GetFlowerType(FlowerName : string)
		local Type = {}
		if string.find(FlowerName, "Mini") then
			Type["Value"] = "1"
		elseif string.find(FlowerName, "Double") then
			Type["Value"] = "2"
		elseif string.find(FlowerName, "Triple") then
			Type["Value"] = "3"
		end

		if string.find(FlowerName, "Pupler") then
			Type["Color"] = "Pupler"
		elseif string.find(FlowerName, "Blue") then
			Type["Color"] = "Blue"
		elseif string.find(FlowerName, "White") then
			Type["Color"] = "White"
		end

		Type["Texture"] = FieldModule.FlowerTypes[FlowerName]
		return Type
	end

	--! NumberRandom --
	function GetRandomFlower(FieldName : string)
		local MainTable : table, Number : number = {}, 0
		for _, imd in pairs(FieldModule.Fields[FieldName].Flowers) do
			local v : number = imd[math.random(1,2)]
			if v > 0 then
				Number = Number + v
				MainTable[#MainTable + 1] = { v + Number, _ }
			end
		end

		local RandomNumber : number = math.random(0, Number)

		for _,v in pairs(MainTable) do
			if RandomNumber <= v[1] then
				return v[2]
			end
		end

		return nil
	end
	
	function FieldModule:RegisterFlower(Flower: Part)
		local _, error = pcall(function()

			local FlowerParentName : string = Flower.Parent.Name
			local FlowerType : string = GetFlowerType(GetRandomFlower(FieldModule.Correspondant[FlowerParentName]))
			local FlowerColor : string = FlowerType.Color
			local ID : number = #FieldModule.Flowers + 1
			Flower:SetAttribute("ID",ID)

			FieldModule.Flowers[ID] = {
				Color = FlowerColor,
				Stat  = FlowerType,
				MaxP = Flower.Size.Y,
				MinP = Flower.Size.Y - 2,
				RegenFlower = 0.3,
			}

			local Color : string = FieldModule.Flowers[ID].Color
			local Number : number = FieldModule.Flowers[ID].Stat.Value
			Flower.TopTexture.Texture = FieldModule.FlowerTypes[Color][Number]
		end)

		if error then
			warn(error)
		end
	end

	function FieldModule:GenerateFlower(Field : BasePart, Position : Vector3)
		local Flower : BasePart = ReplicatedStorage.Assert.Flower:Clone()
		Flower.Parent = Field
		Flower.CFrame = Position

		local orientations : table = {Vector3.new(0, 90, 0), Vector3.new(0, 180, 0),Vector3.new(0, -90, 0), Vector3.new(0, -180, 0)}
		Flower.Orientation = orientations[math.random(1, 4)]

		FieldModule:RegisterFlower(Flower)
	end
    --! GetField --
    function FieldModule:GetField(Field)
        if game:GetService("RunService"):IsServer() then
            return FieldModule
        else
            return Remotes.GetField:InvokeServer()
        end
    end
    
    Remotes.GetField.OnServerInvoke = function(client : Player)
        local PData : table = FieldModule:GetField(client)
        return PData
    end

	--! Generate --
    coroutine.wrap(function()
        for _, Fieldfolder in next, (workspace.GameSettings.FieldsGame:GetChildren()) do
            for _, Zone in next, (Fieldfolder:GetChildren()) do
                if Zone:IsA("Part") then
                    local Field : Folder = Instance.new("Folder", workspace.GameSettings.Fields)
					Field.Name = Zone.Parent.Name
					Zone.Transparency = 1
					local halfX : number = (Zone.Size.X / 2) - 1
					local halfZ : number = (Zone.Size.Z / 2) - 1
					local step : number = 4

					for x = Zone.Position.X - halfX, Zone.Position.X + halfX, step do
						for z = Zone.Position.Z - halfZ, Zone.Position.Z + halfZ, step do
							FieldModule:GenerateFlower(Field, CFrame.new(x, Zone.Position.Y, z))
						end
					end
                end
            end
        end
    end)()



return FieldModule
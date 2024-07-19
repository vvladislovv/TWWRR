local Players : Player = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")
local Data : table = require(ServerScriptService.Server.Data)
local Remotes : Folder = ReplicatedStorage.Remotes
local ItemsFolder : Folder = ReplicatedStorage.Assert.ItemsGame

local Equipment = {}

function NoCollide(Character : Instance) -- Enabled Collides
    Character:WaitForChild("Humanoid")
    Character:WaitForChild('UpperTorso')
    Character:WaitForChild("HumanoidRootPart")
    Character:WaitForChild("Head")
    for _, value in pairs(Character:GetChildren()) do
        if value:IsA("BasePart") then
            value.CollisionGroup = "Players"
        end
    end
end

function Equipment:StartSysmes()
    PhysicsService:RegisterCollisionGroup("Players")
    PhysicsService:CollisionGroupSetCollidable("Players", "Players", false)

    local function Collision(Character : Instance)
        for _, obj in next, Character:GetChildren() do
            if obj:IsA("BasePart") then
                obj.CollisionGroup = "Players"
            end
        end
    end

    game.Players.PlayerAdded:Connect(function(Player : Player)
        if Player.Character then -- Если есть(доп проверка)
            Collision(Player.Character)
        end

        Player.CharacterAdded:Connect(Collision)

        local Character : Instance = workspace:WaitForChild(Player.Name)
        Equipment:Load(Player, Character)
    end)

end


function Equipment:Load(Player : Player, Character : Instance)
    NoCollide(Character)
    -- Boots ModuleScript

    local Humanoid = Character:FindFirstChild("Humanoid")
    local _, Err = pcall(function()
        Equipment:EquipItem(Player, Humanoid, "Bag")
        Equipment:EquipItem(Player, Humanoid, "Tool")
        Equipment:EquipItem(Player, Humanoid, "Boot")
        Equipment:EquipItem(Player, Humanoid, "Belt")
        Equipment:EquipItem(Player, Humanoid, "Glove")
        Equipment:EquipItem(Player, Humanoid, "Hat")
        Equipment:EquipItem(Player, Humanoid, "RGuard")
        Equipment:EquipItem(Player, Humanoid, "LGuard")
    end)

    Humanoid.Died:Connect(function()
        local PData : table = Data:Get(Player)
        PData.IStats.Pollen = 0
       -- PData:Update('IStats', PData.IStats)
        
        --! Оповищение, что рюкзак пуст
       -- Remote.Notify:FireClient(Player, 'Blue',"You died and lost all the pollen you had!", false)
        local Character = Player.CharacterAdded:Wait()
        Equipment:Load(Player, Character)
    end)
end

function Equipment:EquipItem(Player : Player, Humanoid : Humanoid, TypeItems : string)
    local PData : table = Data:Get(Player)

    if PData.Equipment[TypeItems] then
        local ItemPData : table = PData.Equipment[TypeItems]
		local ItemObject : nil
		local ItemObject2 : nil

        if ItemPData ~= "" then
            if TypeItems == "Boot" then
                for i = 1, 2 do
                    ItemObject = ItemsFolder:WaitForChild(TypeItems)[ItemPData..(i==1 and "L" or "R")]:Clone()
                    Humanoid:AddAccessory(ItemObject)
                    ItemObject.Name = TypeItems
                end
            elseif TypeItems == "Glove" then
                for i = 1, 2 do
                    ItemObject = ItemsFolder:WaitForChild(TypeItems)[ItemPData..(i==1 and "L" or "R")]:Clone()
                    Humanoid:AddAccessory(ItemObject)
                    ItemObject.Name = TypeItems
                end
            else
                ItemObject = ItemsFolder:WaitForChild(TypeItems)[ItemPData.."L"]:Clone()
                if ItemObject:IsA('Accessory') then
                    if TypeItems == "Tool" then
                        Humanoid:AddAccessory(ItemObject)
                        ItemObject.Name = TypeItems
                    end 
                end
            end
        end
    end
end

return Equipment
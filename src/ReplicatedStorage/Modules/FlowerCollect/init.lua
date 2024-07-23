local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StampsFolder : Folder = ReplicatedStorage.Assert.StampsGame

local GetService : ModuleScript = require(ReplicatedStorage.Libary.GetService)
local DataClient : ModuleScript = require(ReplicatedStorage.Libary.DataClient)
local TweenModule : ModuleScript = require(ReplicatedStorage.Libary.TweenModule)
local Zone : ModuleScript = require(ReplicatedStorage.Libary.Zone)
local LocalPlayer : Player = GetService['LocalPlayers']
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Remotes : Folder = ReplicatedStorage.Remotes
GetField = Remotes.GetField:InvokeServer()

local RayParams : RaycastParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Include
RayParams.FilterDescendantsInstances = {workspace.GameSettings.Fields}

local FlowerCollect = {}

local function GetRotation()
    return function ()
        local Orientation = CFrame.Angles(0, math.rad(0), 0)
        if Character then
            local HOrient = Character.PrimaryPart.Orientation
    
            if HOrient.Magnitude >= 50 and HOrient.Magnitude < 110 then
                Orientation = CFrame.Angles(0, math.rad(90), 0)
            end
    
            if HOrient.Magnitude > -90 and HOrient.Magnitude < 90 then
                Orientation = CFrame.Angles(0, math.rad(-90), 0)
            end
    
            if HOrient.Magnitude > 0 and HOrient.Magnitude < 50 then
                Orientation = CFrame.Angles(0, math.rad(-180), 0)
            end
    
            if HOrient.Magnitude <= 110 and HOrient.Magnitude >= 180 then
                Orientation = CFrame.Angles(0, math.rad(0), 0)
            end
    
            if HOrient.Magnitude > 110 and HOrient.Magnitude < 180 then
                Orientation = CFrame.Angles(0, math.rad(0), 0)
            end
        end
        return Orientation 
    end
end


local function RayStamp(TSS : table)
    return function ()
        local StartPosition : Vector3 = not TSS.Position and Character.PrimaryPart.Position or TSS.Position
        local EndPosition : Vector3 = StartPosition + Vector3.new(0,-15,0)
        local RayResult : RaycastResult = workspace:Raycast(StartPosition, EndPosition - StartPosition, RayParams)
        return RayResult
    end
end

function FlowerCollect:FlowerRayCost(TSS : table)
    local PData : table = DataClient:Get(LocalPlayer)

    local ToolStamps : Folder = StampsFolder[TSS.RayStamp]:Clone()
    ToolStamps.Parent = workspace.GameSettings.Stamp
    game.Debris:AddItem(ToolStamps, 1)

    local Rayy : table = RayStamp(TSS)()
    local _,err = pcall(function()
        coroutine.wrap(function()
            if tostring(Rayy.Instance) == "Flower" then
                if ToolStamps:IsA('Model') then
                    ToolStamps:PivotTo(CFrame.new(Rayy.Position + Vector3.new(0,3,0)) * GetRotation()())
                else
                    ToolStamps.CFrame = CFrame.new(Rayy.Position) * GetRotation()()
                end
            end
    
            if ToolStamps:IsA('Model') then
                for _, OBJ in next, (ToolStamps:GetChildren()) do
                    if OBJ.Name ~= "Root" then
                        local Ray2 : table = RayStamp({Stamp = OBJ.Position})()
                        if tostring(Ray2.Instance) == "Flower" and PData.FakeSettings.Field ~= "" then
                            Remotes.CollercterFlower:FireServer(Ray2.Instance, TSS)
                        end
                    end
                end
            else
                local Ray3 : table = RayStamp({Stamp = ToolStamps.Position})()
                if tostring(Ray3.Instance) == "Flower" and PData.FakeSettings.Field ~= "" then
                    Remotes.CollercterFlower:FireServer(Ray3.Instance, TSS)
                end
            end
    
        end)()
    end)

    if err then
       -- warn(err)
    end
end

--FlowerCollect:FlowerRayCost({Stamp = "Testers"}) -- Test

function FlowerCollect:UpFlower(Field : Part) -- string?
    local InfoField : table = GetField[Field.Name]

    task.spawn(function()
        while Field do task.wait(5)
            for _, FlowerPollen in next, (Field:GetChildren()) do
                if FlowerPollen:IsA("BasePart") then

                    InfoField = GetField.Flowers[FlowerPollen:GetAttribute('ID')]
                    --print(InfoField)
                    if FlowerPollen.Size.Y <= 1.75 then                        
                        TweenModule:RegenUp(FlowerPollen,DecAm)
                    end
                end 
            end
        end
    end)

end




function FlowerEffect(Flower : Part)
    Flower.ParticleEmitter.Enabled = true
    task.wait(0.35)
    Flower.ParticleEmitter.Enabled = false
end

function DownFlower(Flower : Part, DecAm : Vector3, FlowerTable : table)
    if Flower.Size.Y > 0.85 then
        coroutine.wrap(function()
            FlowerEffect(Flower)
        end)()
        _G.DecAm = DecAm
        TweenModule:FlowerDown(Flower,DecAm)
        Flower:WaitForChild("TopTexture").Transparency = (FlowerTable.MaxP-Flower.Position.Y-DecAm)/2.5
    end
end


Remotes.FlowerDownSize.OnClientEvent:Connect(DownFlower)

for _, Field in next, (workspace.GameSettings.Fields:GetChildren()) do
    -- local InfoField : table
     task.spawn(function()
         while true do
             task.wait(3)
             for _, Field2 in next, (Field:GetChildren()) do
                 if Field2:IsA("BasePart") then
                    -- InfoField = GetField.Flowers[Field2:GetAttribute('ID')]
                     -- сделать по этапно 
                     if Field2.Size.Y <= 1.75 then -- 0.893
                         task.delay(3 ,function()
                             TweenModule:RegenUp(Field2,_G.DecAm)
                         end)
                         break
                     end 
                 end
             end
         end
     end)
 end

for _, FieldFolder in next, workspace.GameSettings.FieldZone:GetChildren() do
    local ZonePlus : Instance = Zone.new(FieldFolder)

    ZonePlus.playerEntered:Connect(function(Player : Player)
        local PData : table = DataClient:Get(Player)
        PData.FakeSettings.Field = GetField.Correspondant[FieldFolder.Name]
        PData.FakeSettings.OldField = FieldFolder.Name
                
    end)

    ZonePlus.localPlayerExited:Connect(function(Player : Player)
        local PData : table = DataClient:Get(Player)

        PData.FakeSettings.Field = ""
        
    end)
end

return FlowerCollect
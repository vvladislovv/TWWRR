local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StampsFolder = ReplicatedStorage.Assert.StampsGame

local GetService = require(ReplicatedStorage.Libary.GetService)
local DataClient = require(ReplicatedStorage.Libary.DataClient)
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)
local LocalPlayer = GetService['LocalPlayers']
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Remotes = ReplicatedStorage.Remotes
GetField = Remotes.GetField:InvokeServer()

local RayParams = RaycastParams.new()
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
        local StartPosition = not TSS.Position and Character.PrimaryPart.Position or TSS.Position
        local EndPosition = StartPosition + Vector3.new(0,-15,0)
        local RayResult = workspace:Raycast(StartPosition, EndPosition - StartPosition, RayParams)
        return RayResult
    end
end

function FlowerCollect:FlowerRayCost(TSS : table)
    local PData = DataClient:Get(LocalPlayer)
    local ToolStamps = StampsFolder[TSS.Stamp]:Clone()
    ToolStamps.Parent = workspace.GameSettings.Stamp
    game.Debris:AddItem(ToolStamps, 1)

    local Rayy = RayStamp(TSS)()
    local _,err = pcall(function()
        coroutine.wrap(function()

            if tostring(Rayy.Instance) == "Flower" then
                if ToolStamps:IsA('Model') then
                    ToolStamps:GetPrivot(CFrame.new(Rayy.Position + Vector3.new(0,3,0)) * GetRotation()())
                else
                    ToolStamps.CFrame = CFrame.new(Rayy.Position) * GetRotation()()
                end
            end
    
            if ToolStamps:IsA('Model') then
                for _, OBJ in next, (ToolStamps:GetChildren()) do
                    if OBJ.Name ~= "Root" then
                        local Ray2 = RayStamp({Stamp = OBJ.Position})()
                        if tostring(Ray2.Instance) == "Flower" and PData.FakeSettings.Field ~= "" then
                            Remotes.CollercterFlower:FireServer(Ray2, TSS)
                        end
                    end
                end
            else
                local Ray3 = RayStamp({Stamp = ToolStamps.Position})()
                if tostring(Ray3.Instance) == "Flower" and PData.FakeSettings.Field ~= "" then
                    Remotes.CollercterFlower:FireServer(Ray3, TSS)
                end
            end
    
        end)()
    end)

    if err then
        warn(err)
    end
end

FlowerCollect:FlowerRayCost({Stamp = "Testers"}) -- Test

function FlowerCollect:UpFlower(Field : Part) -- string?
    local InfoField = GetField[Field.Name]

    coroutine.wrap(function()
        while Field do task.wait(5)
            for _, FlowerPollen in next, (Field:GetChildren()) do
                if FlowerPollen:IsA("BasePart") then

                    InfoField = _G.Field.Flowers[FlowerPollen:GetAttribute('ID')]
                    if FlowerPollen.Position.Y < InfoField.MaxP then

                        local ToMaxFlower = tonumber(InfoField.MaxP - FlowerPollen.Position.Y)
                        local FlowerPos = FlowerPollen.Position + Vector3.new(0, ToMaxFlower, 0)
                        local FlowerPosTime = FlowerPollen.Position + Vector3.new(0,InfoField.RegenFlower,0)

                        TweenModule:RegenUp(FlowerPollen,ToMaxFlower,InfoField,FlowerPos,FlowerPosTime)
                    end

                end 
            end
        end
    end)()
end

function FlowerEffect(Flower : Part)
    Flower.ParticleEmitter.Enabled = true
    task.wait(0.25)
    Flower.ParticleEmitter.Enabled = false
end

function DownFlower(Flower : Part, DecAm : Vector3)
    local CopProgram = coroutine.create(FlowerEffect(Flower))
    coroutine.resume(CopProgram)
    local FlowerPos = Flower.Position - Vector3.new(0,DecAm,0)
    TweenModule:FlowerDown(Flower,FlowerPos)
    coroutine.yield(CopProgram)
end

coroutine.wrap(function()
    for _, Field in next, workspace.Map.GameSettings.Fields:GetChildren() do
        FlowerCollect:UpFlowe(Field)
    end
end)()


return FlowerCollect
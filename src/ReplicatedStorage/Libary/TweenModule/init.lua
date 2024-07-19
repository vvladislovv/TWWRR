local TweenService = game:GetService("TweenService")

local TweenModule = {}

TweenModule.TweenInfoTable = {
    ['TweenInfo1'] = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ['TweenInfoSlot'] = TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    ['HiveWaspCreate'] = TweenInfo.new(0.45,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),
    ['FlowerDown'] = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
    ['FlowerUp'] = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
}


function TweenModule.OpenButton(Frame : Frame)
    TweenService:Create(Frame,TweenModule.TweenInfoTable['TweenInfo1'],{Size = UDim2.new(10,0,5, 0)}):Play()
end

function TweenModule.CloseButton(Frame : Frame)
    TweenService:Create(Frame,TweenModule.TweenInfoTable['TweenInfo1'],{Size = UDim2.new(0,0,0,0)}):Play()
end

function TweenModule:KeyCode(Frame : Frame)
    TweenService:Create(Frame,TweenModule.TweenInfoTable['TweenInfo1'],{Size = UDim2.new(8,0,4, 0)}):Play()
end

function  TweenModule:SlotEffectFood(Slot : BasePart)
    Slot.Down.Transparency = 0.15
    TweenService:Create(Slot.Down, TweenModule.TweenInfoTable['TweenInfoSlot'], {Color = Color3.fromRGB(61, 243, 92)}):Play()
end

function TweenModule:CreateWaspHive(CFrameModel : CFrame, PosSlot : Attachment)
    local endCFrame = CFrame.new(PosSlot.WorldCFrame.Position) * CFrame.Angles(0, math.rad(90), 0)
    TweenService:Create(CFrameModel.PrimaryPart, TweenModule.TweenInfoTable['HiveWaspCreate'], {CFrame = endCFrame}):Play()
end

function  TweenModule:SlotEffectFoodOff(Slot : BasePart, ColorSlot : Color3)
    TweenService:Create(Slot.Down, TweenModule.TweenInfoTable['TweenInfoSlot'], {Color = ColorSlot[2]}):Play()
end

function TweenModule:SpawnSlotHive(Hive : Folder, CheckSlot : number)
    local function SlotEffect()
        Hive.Slots[CheckSlot].Up.Material = Enum.Material.Neon
        Hive.Slots[CheckSlot].Down.Material = Enum.Material.Neon
        TweenService:Create(Hive.Slots[CheckSlot].Down, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(Hive.Slots[CheckSlot].Up, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        Hive.Slots[CheckSlot].Up.Material = Enum.Material.SmoothPlastic
        Hive.Slots[CheckSlot].Down.Material = Enum.Material.Neon
    end

    TweenService:Create(Hive.Slots[CheckSlot].Up, TweenModule.TweenInfoTable['TweenInfoSlot'], {Transparency = 0}):Play()
    SlotEffect()
    TweenService:Create(Hive.Slots[CheckSlot].Down, TweenModule.TweenInfoTable['TweenInfoSlot'], {Transparency = 0.45}):Play()
    Hive.Slots[CheckSlot].Down.Level.SurfaceGui.Enabled = true
    Hive.Slots[CheckSlot].Down.SurfaceGui.Enabled = true
    --Hive.Slots[CheckSlot].Up.ParticleEmitter.Enabled = true
    --Hive.Slots[CheckSlot].Up.ParticleEmitter.Enabled = false
end

function TweenModule:DestroySlotHive(Hive : Folder, CheckSlot : number)
    local function SlotEffect()
        Hive.Slots[CheckSlot].Up.Material = Enum.Material.Neon
        Hive.Slots[CheckSlot].Down.Material = Enum.Material.Neon
        TweenService:Create(Hive.Slots[CheckSlot].Down, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(Hive.Slots[CheckSlot].Up, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        Hive.Slots[CheckSlot].Up.Material = Enum.Material.SmoothPlastic
        Hive.Slots[CheckSlot].Down.Material = Enum.Material.Neon
    end

    TweenService:Create(Hive.Slots[CheckSlot].Up, TweenModule.TweenInfoTable['TweenInfoSlot'], {Transparency = 1}):Play()
    SlotEffect()
    TweenService:Create(Hive.Slots[CheckSlot].Down, TweenModule.TweenInfoTable['TweenInfoSlot'], {Transparency = 1}):Play()
    Hive.Slots[CheckSlot].Down.Level.SurfaceGui.Enabled = false
    Hive.Slots[CheckSlot].Down.SurfaceGui.Enabled = false
end

function TweenModule:FlowerDown(Flower : Part, FlowerPos : Vector3)
    TweenService:Create(Flower, TweenModule.TweenInfoTable['FlowerDown'], {Position = FlowerPos}):Play()
end

function TweenModule:RegenUp(Pollen : Part, ToMaxFlower: Vector3, InfoFieldGame : table, FlowerPos : Vector3, FlowerPosTime : Vector3)
    if ToMaxFlower < InfoFieldGame.RegenFlower then
        Pollen.ParticleEmitter.Enabled = false
        TweenService:Create(Pollen, TweenModule.TweenInfoTable["FlowerUp"], {Position = FlowerPos}):Play()
    else
        Pollen.ParticleEmitter.Enabled = false
        TweenService:Create(Pollen, TweenModule.TweenInfoTable["FlowerUp"], {Position = FlowerPosTime}):Play()
    end
end

return TweenModule
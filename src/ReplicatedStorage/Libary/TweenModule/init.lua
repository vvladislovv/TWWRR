local TweenService = game:GetService("TweenService")

local TweenModule = {}

TweenModule.TweenInfoTable = {
    ['TweenInfo1'] = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ['TweenInfoSlot'] = TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
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

function TweenModule:SpawnSlotHive(Hive : Folder,CheckSlot : number)
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

return TweenModule
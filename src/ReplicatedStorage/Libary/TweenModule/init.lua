local TweenService = game:GetService("TweenService")

local TweenModule = {}

TweenModule.TweenInfoTable = {}


function TweenModule.OpenButton(Frame : Frame)
    Frame:TweenSize(UDim2.new(10, 0,5, 0),"Out","Quad")
end

function TweenModule.CloseButton(Frame : Frame)
    Frame:TweenSize(UDim2.new(0, 0,0, 0),"Out","Quad")
end

return TweenModule
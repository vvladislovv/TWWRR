local Items = {}

    Items.Tools = function(ToolName : string)
            local NewTableTools = setmetatable({}, Items)

            NewTableTools = {
                ['Shovel'] = {
                    ToolSettings = {
                        Regeniration = 0.45,
                        CollectField = 12,
                        Power = 0.3,
                        RayStamp = "Shovel",
                        Color = nil,
                        ColorMutltiplier = 1,
                        AnimTools = {
                            [1] = 'rbxassetid://17469220213',
                            --[2] = ''
                        },
                        GuiItems = "rbxassetid://17180412078",
                    },
                    
                    ToolShop ={
                        Description = "",
                        Type = 'Tool',
                        Cost = 0,
                        Craft = {},
                    },
                }
            }
        return NewTableTools[ToolName]
    end

return Items
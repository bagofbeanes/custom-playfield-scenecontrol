---@class beane.CustomPlayfield.ContextExtension : Context
---   @field skyInputHeight number|ValueChannel
local context_extension = {}

local mt = {

    __newindex = 
        function(t, k, v)
            if k == "skyInputHeight" then Scene.skyInputLine.translationY = v
            else Context[k] = v end
        end,

    __index =
        function(t, k)
            if k == "skyInputHeight" then return Scene.skyInputLine.translationY end
            return Context[k]
        end

}
setmetatable(context_extension, mt)
context_extension.skyInputHeight = GetDefaultValue(Scene.skyInputLine.translationY)

return context_extension
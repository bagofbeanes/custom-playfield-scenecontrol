---@class beane.CustomPlayfield.ContextExtension : Context
---   @field skyInputHeight number|ValueChannel
---   @field dropRate DropRateChannel
---   @field globalOffset GlobalOffsetChannel
---   @field currentScore CurrentScoreChannel
---   @field currentCombo CurrentComboChannel
---   @field currentTiming CurrentTimingChannel
---   @field screenWidth ScreenWidthChannel
---   @field screenHeight ScreenHeightChannel
---   @field screenAspectRatio ProductChannel
---   @field is16By9 ScreenIs16By9Channel
---   @field isMirrorOn IsMirrorOnChannel
---   @field beatLength fun(timingGroup: integer): ProductChannel
---   @field bpm fun(timingGroup: integer): BPMChannel
---   @field divisor fun(timingGroup: integer): DivisorChannel
---   @field floorPosition fun(timingGroup: integer): FloorPositionChannel
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
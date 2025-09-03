local constants = require 'custom_playfield.util.constants'

local id_default = 'editor' -- by default, playfield elements will use the skin set in the editor
local skin_path = 'custom_playfield/sprites/skins/'

-- -- Disable editor track -- --
-- [[                      ]] --

local track_default = Scene.track
track_default.active = 0
track_default.edgeExtraL.copyAllChannelsFrom(Scene.track.edgeExtraL)
track_default.edgeExtraL.active = 0
track_default.extraL.copyAllChannelsFrom(Scene.track.extraL)
track_default.extraL.active = 0
track_default.criticalLine0.copyAllChannelsFrom(Scene.track.criticalLine0)
track_default.criticalLine0.active = 0
track_default.criticalLine1.active = 0
track_default.criticalLine2.active = 0
track_default.criticalLine3.active = 0
track_default.criticalLine4.active = 0
track_default.criticalLine5.active = 0

Scene.skyInputLine.translationZ = -999999
Scene.skyInputLabel.active = 0

-- [[                      ]] --
-- -- -------------------- -- --


---@class beane.CustomPlayfield.PlayfieldSkin
---   @field trackBody string
---   @field trackCriticalLine string
---   @field trackEdge string
---   @field trackLaneDivider string
---   @field trackExtraBody string
---   @field trackExtraCriticalLine string
---   @field trackExtraEdge string
---   @field trackExtraLaneDivider string
---   @field skyInputLine string
---   @field skyInputLabel string
PlayfieldSkin = {}

---Create a new skin. Unprovided skin IDs will default to the skin elements set in the editor
---@param self beane.CustomPlayfield.PlayfieldSkin
---@param id_track_body? string
---@param id_track_criticalline? string
---@param id_track_edge? string
---@param id_track_lanedivider? string
---@param id_trackextra_body? string
---@param id_trackextra_criticalline? string
---@param id_trackextra_edge? string
---@param id_trackextra_lanedivider? string
---@param id_skyinputline? string
---@param id_skyinputlabel? string
function PlayfieldSkin:new(id_track_body, id_track_criticalline, id_track_edge, id_track_lanedivider, id_trackextra_body, id_trackextra_criticalline, id_trackextra_edge, id_trackextra_lanedivider, id_skyinputline, id_skyinputlabel)

    local o = {

        trackBody = id_track_body                           or id_default,
        trackCriticalLine = id_track_criticalline           or id_default,
        trackEdge = id_track_edge                           or id_default,
        trackLaneDivider = id_track_lanedivider             or id_default,
        trackExtraBody = id_trackextra_body                 or id_default,
        trackExtraCriticalLine = id_trackextra_criticalline or id_default,
        trackExtraEdge = id_trackextra_edge                 or id_default,
        trackExtraLaneDivider = id_trackextra_lanedivider   or id_default,
        skyInputLine = id_skyinputline                      or id_default,
        skyInputLabel = id_skyinputlabel                    or id_default

    }

    local proxy = {}
    local mt = {

        __index = o,

        __newindex = 
            function(t, k, v)
            end

    }
    setmetatable(proxy, mt)

    setmetatable(o, self)
    self.__index = self

    return proxy

end

local function disable_track_elements(track)

    track.divideLine01.active = 0
    track.divideLine12.active = 0
    track.divideLine23.active = 0
    track.divideLine34.active = 0
    track.divideLine45.active = 0

    track.criticalLine0.active = 0
    track.criticalLine1.active = 0
    track.criticalLine2.active = 0
    track.criticalLine3.active = 0
    track.criticalLine4.active = 0
    track.criticalLine5.active = 0

    track.extraL.active = 0
    track.extraR.active = 0
    track.edgeExtraL.active = 0
    track.edgeExtraR.active = 0

    track.edgeLAlpha = 0
    track.edgeRAlpha = 0

end

-- -- Playfield skin element inits -- --
-- [[                              ]] --

function PlayfieldSkin.createTrackBodySprite(skin)

    local id = skin.trackBody
    local sprite

    -- default skin specific inits
    if (id == id_default) then

        sprite = track_default.copy()
        disable_track_elements(sprite)

        sprite.textureOffsetY = constants.trackWalk

    -- custom skin specific inits
    else

        sprite = Scene.createSprite(skin_path .. id .. '/TrackBody.png', 'default', 'background', xy(0.5, 0), 'repeat')
        
        sprite.scaleY = 60
        sprite.textureScaleX = -1
        sprite.textureScaleY = sprite.scaleY
        sprite.textureOffsetY = constants.trackWalk / sprite.scaleY

    end
    
    -- general inits
    SetDefaultValues(
        sprite,
        {
            colorR = 255, colorG = 255, colorB = 255, 
            colorH = 0, colorS = 0, colorV = 0,
            colorA = 255
        }
    )
    CopyDefaultValues(
        sprite,
        track_default, 
        {
            'translationX', 'translationY', 'translationZ',
            'rotationX', 'rotationY', 'rotationZ',
            'scaleX', 'scaleZ'
        }
    )

    sprite.active = CreateKey(1)
    sprite.sort = -2
    sprite.layer = 'Track'

    return sprite

end

function PlayfieldSkin.createTrackCriticalLineSprite(skin)

    local id = skin.trackCriticalLine
    local sprite

    -- default skin specific inits
    if (id == id_default) then

        sprite = track_default.criticalLine2.copy()
    
    -- custom skin specific inits
    else

        sprite = Scene.createSprite(skin_path .. id .. '/TrackCriticalLine.png', 'default', 'background', xy(0.5, 0.5), 'repeat')

    end

    -- general inits
    SetDefaultValues(
        sprite,
        {
            translationX = 0, translationY = 0, translationZ = 0,
            rotationX = -90, rotationY = 0, rotationZ = 0,

            colorR = 255, colorG = 255, colorB = 255, 
            colorH = 0, colorS = 0, colorV = 0,
            colorA = 255
        }
    )
    CopyDefaultValues(
        sprite,
        track_default.criticalLine2,
        {
            'scaleY', 'scaleZ'
        }
    )
    sprite.scaleX = 4 * 0.99615 * GetDefaultValue(track_default.criticalLine2.scaleX) * GetDefaultValue(track_default.scaleX)

    sprite.active = CreateKey(1)
    sprite.sort = 0
    sprite.layer = 'Track'

    return sprite

end

function PlayfieldSkin.createTrackEdgeSprite(skin)

    local id = skin.trackEdge
    local sprite

    -- default skin specific inits
    if (id == id_default) then

        sprite = track_default.edgeExtraL.copy()

        sprite.scaleY = GetDefaultValue(track_default.edgeExtraL.scaleY)
        sprite.textureOffsetY = constants.trackWalk
        
    -- custom skin specific inits
    else

        sprite = Scene.createSprite(skin_path .. id .. '/TrackEdge.png', 'default', 'background', xy(0.5, 0), 'repeat')
        
        sprite.scaleY = 60
        sprite.textureScaleX = -1
        sprite.textureScaleY = sprite.scaleY
        sprite.textureOffsetY = constants.trackWalk / sprite.scaleY

    end

    -- general inits
    SetDefaultValues(
        sprite,
        {
            translationX = 0, translationY = 0,
            rotationX = -90, rotationY = 0, rotationZ = 0,

            colorR = 255, colorG = 255, colorB = 255, 
            colorH = 0, colorS = 0, colorV = 0,
            colorA = 255
        }
    )
    sprite.translationZ = GetDefaultValue(track_default.translationZ)
    sprite.scaleX = GetDefaultValue(track_default.edgeExtraL.scaleX) * GetDefaultValue(track_default.scaleX)
    sprite.scaleZ = GetDefaultValue(track_default.edgeExtraL.scaleZ)

    sprite.active = CreateKey(1)
    sprite.sort = 3
    sprite.layer = 'Track'

    return sprite

end

function PlayfieldSkin.createTrackLaneDividerSprite(skin)

    local id = skin.trackLaneDivider
    local sprite

    -- default skin specific inits
    if (id == id_default) then

        sprite = track_default.divideLine23.copy()
        
        sprite.scaleY = GetDefaultValue(track_default.divideLine23.scaleY)

    -- custom skin specific inits
    else

        sprite = Scene.createSprite(skin_path .. id .. '/TrackLaneDivider.png', 'default', 'background', xy(0.5, 0), 'repeat')
        
        sprite.scaleY = 12.43724

    end

    -- generic inits
    SetDefaultValues(
        sprite,
        {
            translationX = 0, translationY = 0,
            rotationX = -90, rotationY = 0, rotationZ = 0
        }
    )
    SetDefaultKeys(
        sprite,
        {
            colorR = 255, colorG = 255, colorB = 255, colorA = 255
        }
    )
    sprite.translationZ = GetDefaultValue(track_default.translationZ)
    sprite.scaleX = GetDefaultValue(track_default.divideLine23.scaleX) * GetDefaultValue(track_default.scaleX)
    sprite.scaleZ = GetDefaultValue(track_default.divideLine23.scaleZ)

    sprite.active = CreateKey(1)
    sprite.sort = -1
    sprite.layer = 'Track'

    return sprite

end

function PlayfieldSkin.createTrackExtraBodySprite(skin)

    local id = skin.trackExtraBody
    local sprite

    -- default skin specific inits
    if (id == id_default) then

        sprite = track_default.extraL.copy()

        sprite.scaleY = GetDefaultValue(Scene.track.extraL.scaleY)

    -- custom skin specific inits
    else

        sprite = Scene.createSprite(skin_path .. id .. '/TrackExtraBody.png', 'default', 'background', xy(0.5, 0), 'repeat')
        
        sprite.scaleY = 15.35 -- 153.5/2.55 - might need this

    end

    -- general inits
    SetDefaultValues(
        sprite,
        {
            translationX = 0, translationY = 0,
            rotationX = -90, rotationY = 0, rotationZ = 0,
            scaleX = 212.5 * 8,

            colorR = 255, colorG = 255, colorB = 255, 
            colorH = 0, colorS = 0, colorV = 0,
            colorA = 255
        }
    )
    sprite.translationZ = GetDefaultValue(track_default.translationZ)
    sprite.scaleZ = GetDefaultValue(track_default.extraL.scaleZ)

    sprite.active = CreateKey(1)
    sprite.sort = -8
    sprite.layer = 'Track'

    return sprite

end

function PlayfieldSkin.createTrackExtraCriticalLineSprite(skin)

    local id = skin.trackExtraCriticalLine
    local sprite

    -- default skin specific inits
    if (id == id_default) then

        sprite = track_default.criticalLine0.copy()
    
    -- custom skin specific inits
    else

        sprite = Scene.createSprite(skin_path .. id .. '/TrackExtraCriticalLine.png', 'default', 'background', xy(0.5, 0.5), 'repeat')

    end

    -- general inits
    SetDefaultValues(
        sprite,
        {
            translationX = 0, translationY = 0,
            rotationX = -90, rotationY = 0, rotationZ = 0,

            colorR = 255, colorG = 255, colorB = 255, 
            colorH = 0, colorS = 0, colorV = 0,
            colorA = 255
        }
    )
    CopyDefaultValues(
        sprite,
        track_default.criticalLine2,
        {
            'translationZ',
            'scaleY', 'scaleZ'
        }
    )
    sprite.scaleX = 4 * 0.99615 * GetDefaultValue(track_default.criticalLine2.scaleX) * GetDefaultValue(track_default.scaleX)

    sprite.active = CreateKey(1)
    sprite.sort = -6
    sprite.layer = 'Track'

    return sprite

end

function PlayfieldSkin.createTrackExtraEdgeSprite(skin)

    local id = skin.trackExtraEdge
    local sprite

    -- default skin specific inits
    if (id == id_default) then

        sprite = track_default.edgeExtraL.copy()

        sprite.scaleY = GetDefaultValue(track_default.edgeExtraL.scaleY)
        sprite.textureOffsetY = constants.trackWalk
        
    -- custom skin specific inits
    else

        sprite = Scene.createSprite(skin_path .. id .. '/TrackExtraEdge.png', 'default', 'background', xy(0.5, 0), 'repeat')
        
        sprite.scaleY = 60
        sprite.textureScaleX = -1
        sprite.textureScaleY = sprite.scaleY
        sprite.textureOffsetY = constants.trackWalk / sprite.scaleY

    end

    -- general inits
    SetDefaultValues(
        sprite,
        {
            translationX = 0, translationY = 0,
            rotationX = -90, rotationY = 0, rotationZ = 0,

            colorR = 255, colorG = 255, colorB = 255, 
            colorH = 0, colorS = 0, colorV = 0,
            colorA = 255
        }
    )
    sprite.translationZ = GetDefaultValue(track_default.translationZ)
    sprite.scaleX = GetDefaultValue(track_default.edgeExtraL.scaleX) * GetDefaultValue(track_default.scaleX)
    sprite.scaleZ = GetDefaultValue(track_default.edgeExtraL.scaleZ)

    sprite.active = CreateKey(1)
    sprite.sort = -3
    sprite.layer = 'Track'

    return sprite

end

function PlayfieldSkin.createTrackExtraLaneDividerSprite(skin)

    local id = skin.trackExtraLaneDivider
    local sprite

    -- default skin specific inits
    if (id == id_default) then

        sprite = track_default.divideLine01.copy()
        
        sprite.scaleY = GetDefaultValue(track_default.divideLine01.scaleY)

    -- custom skin specific inits
    else

        sprite = Scene.createSprite(skin_path .. id .. '/TrackExtraLaneDivider.png', 'default', 'background', xy(0.5, 0), 'repeat')
        
        sprite.scaleY = 12.43724

    end

    -- generic inits
    SetDefaultValues(
        sprite,
        {
            translationX = 0, translationY = 0,
            rotationX = -90, rotationY = 0, rotationZ = 0,

            colorR = 255, colorG = 255, colorB = 255, 
            colorH = 0, colorS = 0, colorV = 0,
            colorA = 255
        }
    )
    sprite.translationZ = GetDefaultValue(track_default.translationZ)
    sprite.scaleX = GetDefaultValue(track_default.divideLine01.scaleX) * GetDefaultValue(track_default.scaleX)
    sprite.scaleZ = GetDefaultValue(track_default.divideLine01.scaleZ)

    sprite.active = CreateKey(1)
    sprite.sort = -4
    sprite.layer = 'Track'

    return sprite

end

function PlayfieldSkin.createSkyInputLineSprite(skin)

    local id = skin.skyInputLine
    local sprite

    -- default skin specific inits
    if (id == id_default) then

        sprite = Scene.skyInputLine.copy()
    
    -- custom skin specific inits
    else

        sprite = Scene.createSprite(skin_path .. id .. '/SkyInputLine.png', 'default', 'background', xy(0.5, 0), 'repeat')

    end

    -- general inits
    SetDefaultValues(
        sprite,
        {
            translationX = 0, translationY = 5.5, translationZ = 0,

            colorR = 255, colorG = 255, colorB = 255, 
            colorH = 0, colorS = 0, colorV = 0,
            colorA = 255
        }
    )
    CopyDefaultValues(
        sprite,
        Scene.skyInputLine,
        {
            'rotationX', 'rotationY', 'rotationZ',
            'scaleX', 'scaleY', 'scaleZ'
        }
    )

    sprite.active = CreateKey(1)
    sprite.sort = 0
    sprite.layer = 'UI'

    return sprite

end

function PlayfieldSkin.createSkyInputLabelSprite(skin)

    local id = skin.skyInputLabel
    local sprite

    -- default skin specific inits
    if (id == id_default) then

        sprite = Scene.skyInputLabel.copy()
    
    -- custom skin specific inits
    else

        sprite = Scene.createSprite(skin_path .. id .. '/SkyInputLabel.png', 'default', 'background', xy(0.5, 0), 'repeat')

    end

    -- general inits
    SetDefaultValues(
        sprite,
        {
            translationX = 0, translationY = 5.65, translationZ = 0,

            colorR = 255, colorG = 255, colorB = 255, 
            colorH = 0, colorS = 0, colorV = 0,
            colorA = 255
        }
    )
    CopyDefaultValues(
        sprite,
        Scene.skyInputLabel,
        {
            'rotationX', 'rotationY', 'rotationZ',
            'scaleY', 'scaleZ'
        }
    )

    sprite.active = CreateKey(1)
    sprite.sort = 0
    sprite.layer = 'UI'

    return sprite

end

-- [[                              ]] --
-- -- ---------------------------- -- --
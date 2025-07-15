local constants = require 'custom_playfield.util.constants'

---@class beane.CustomPlayfield.Playfield
---   @field maxLaneCount integer
---   @field laneCount KeyChannel
---   @field laneCountExtra KeyChannel
---   -- Playfield elements --
---   @field playfieldController beane.CustomPlayfield.CanvasObject
---   -- Track elements
---   @field trackController beane.CustomPlayfield.CanvasObject -- Controls all regular track elements
---   @field trackBody beane.CustomPlayfield.LayeredSpriteObject
---   @field trackEdgeController beane.CustomPlayfield.CanvasObject
---   @field trackEdgeL beane.CustomPlayfield.LayeredSpriteObject
---   @field trackEdgeR beane.CustomPlayfield.LayeredSpriteObject
---   @field trackCriticalLine beane.CustomPlayfield.LayeredSpriteObject
---   @field trackLaneDividerController beane.CustomPlayfield.CanvasObject
---   @field trackLaneDividers beane.CustomPlayfield.LayeredSpriteObject[]
---   -- Extra track elements
---   @field trackExtraController beane.CustomPlayfield.CanvasObject -- Controls all extra track elements
---   @field trackExtraBody beane.CustomPlayfield.LayeredSpriteObject
---   @field trackExtraEdgeController beane.CustomPlayfield.CanvasObject
---   @field trackExtraEdgeL beane.CustomPlayfield.LayeredSpriteObject
---   @field trackExtraEdgeR beane.CustomPlayfield.LayeredSpriteObject
---   @field trackExtraCriticalLine beane.CustomPlayfield.LayeredSpriteObject
---   @field trackExtraLaneDividerController beane.CustomPlayfield.CanvasObject
---   @field trackExtraLaneDividers beane.CustomPlayfield.LayeredSpriteObject[]
---   -- Sky input elements
---   @field skyInputController beane.CustomPlayfield.CanvasObject -- Controls all sky input elements
---   @field skyInputLine beane.CustomPlayfield.LayeredSpriteObject
---   @field skyInputLabel beane.CustomPlayfield.LayeredSpriteObject
Playfield = {}
Playfield.__index = Playfield

---Create a new `Playfield` using a provided skin. Creates the track, the extra track and the sky input elements
---@param skin beane.CustomPlayfield.PlayfieldSkin
---@param max_lane_count integer
---@return beane.CustomPlayfield.Playfield
function Playfield:new(skin, max_lane_count)

    local lanes_half = math.floor(max_lane_count / 2)

    local o = {

        maxLaneCount = max_lane_count,
        laneCount = CreateKey(0),
        laneCountExtra = CreateKey(0),

        -- -- Playfield elements -- --

        playfieldController = CanvasObject:new(),

        -- -- Track creation -- --
        -- [[                ]] --

        trackController = CanvasObject:new(),
        
        trackBody = LayeredSpriteObject:new(PlayfieldSkin.createTrackBodySprite(skin), 2),

        trackEdgeController = CanvasObject:new(),
        
        trackEdgeL = LayeredSpriteObject:new(PlayfieldSkin.createTrackEdgeSprite(skin), 2),
        trackEdgeR = LayeredSpriteObject:new(PlayfieldSkin.createTrackEdgeSprite(skin), 2),

        trackCriticalLine = LayeredSpriteObject:new(PlayfieldSkin.createTrackCriticalLineSprite(skin), 2),

        trackLaneDividerController = CanvasObject:new(),
        trackLaneDividers = {},

        -- [[                ]] --
        -- -- -------------- -- --


        -- -- Extra track creation -- --
        -- [[                      ]] --

        trackExtraController = CanvasObject:new(),

        trackExtraBody = LayeredSpriteObject:new(PlayfieldSkin.createTrackExtraBodySprite(skin), 2),

        trackExtraEdgeController = CanvasObject:new(),
        trackExtraEdgeL = LayeredSpriteObject:new(PlayfieldSkin.createTrackExtraEdgeSprite(skin), 2),
        trackExtraEdgeR = LayeredSpriteObject:new(PlayfieldSkin.createTrackExtraEdgeSprite(skin), 2),

        trackExtraCriticalLine = LayeredSpriteObject:new(PlayfieldSkin.createTrackExtraCriticalLineSprite(skin), 2),

        trackExtraLaneDividerController = CanvasObject:new(),
        trackExtraLaneDividers = {},

        -- [[                      ]] --
        -- -- -------------------- -- --


        -- -- Sky input creation -- --
        -- [[                    ]] --

        skyInputController = CanvasObject:new(),

        skyInputLine = LayeredSpriteObject:new(PlayfieldSkin.createSkyInputLineSprite(skin), 1),
        skyInputLabel = LayeredSpriteObject:new(PlayfieldSkin.createSkyInputLabelSprite(skin), 1)

        -- [[                    ]] --
        -- -- ------------------ -- --


        -- -- ------------------ -- --

    }

    -- -- Track initialization -- --
    -- [[                      ]] --

    local track_scale = CreateKey(0) -- Lane count stuff
    o.trackBody.transformLayers[2].scaleX = track_scale
    o.trackCriticalLine.transformLayers[2].scaleX = track_scale

    ControllerObject.setParentC(o.trackController, o.playfieldController)

    ControllerObject.setParentC(o.trackBody, o.trackController)
    o.trackBody.textureScaleX = -(o.laneCount / 4) -- makes track texture not stretch with lane count

    ControllerObject.setParentC(o.trackEdgeController, o.trackController)
    ControllerObject.setParentC(o.trackEdgeL, o.trackEdgeController)
    ControllerObject.setParentC(o.trackEdgeR, o.trackEdgeController)

    ControllerObject.setParentC(o.trackCriticalLine, o.trackController)

    ControllerObject.setParentC(o.trackLaneDividerController, o.trackController)
    for i = -lanes_half, lanes_half do

        o.trackLaneDividers[i] = LayeredSpriteObject:new(PlayfieldSkin.createTrackLaneDividerSprite(skin), 2)
        ControllerObject.setParentC(o.trackLaneDividers[i], o.trackLaneDividerController)

        local lanedivider = o.trackLaneDividers[i].transformLayers[2]
        lanedivider.translationX = CreateKey(-constants.laneWidth * i)

        if (i ~= 0) then

            local lanedivider_track_edge = ((i < 0 and o.trackEdgeL) or (i > 0 and o.trackEdgeR)).transformLayers[2]
            lanedivider.active = math.sign(i) * (lanedivider.translationX - lanedivider_track_edge.translationX) -- Activate based on whether or not the line is within the track boundary

        end

    end

    -- [[                      ]] --
    -- -- -------------------- -- --

    
    -- -- Extra track initialization -- --
    -- [[                            ]] --

    local trackextra_scale = CreateKey(0) -- Lane count stuff
    o.trackExtraBody.transformLayers[2].scaleX = trackextra_scale
    o.trackExtraCriticalLine.transformLayers[2].scaleX = trackextra_scale

    ControllerObject.setParentC(o.trackExtraController, o.playfieldController)

    ControllerObject.setParentC(o.trackExtraBody, o.trackExtraController)

    ControllerObject.setParentC(o.trackExtraEdgeController, o.trackExtraController)
    ControllerObject.setParentC(o.trackExtraEdgeL, o.trackExtraEdgeController)
    ControllerObject.setParentC(o.trackExtraEdgeR, o.trackExtraEdgeController)

    ControllerObject.setParentC(o.trackExtraCriticalLine, o.trackExtraController)

    ControllerObject.setParentC(o.trackExtraLaneDividerController, o.trackExtraController)
    for i = -lanes_half, lanes_half do

        o.trackExtraLaneDividers[i] = LayeredSpriteObject:new(PlayfieldSkin.createTrackExtraLaneDividerSprite(skin), 2)
        ControllerObject.setParentC(o.trackExtraLaneDividers[i], o.trackExtraLaneDividerController)

        local lanedivider = o.trackExtraLaneDividers[i].transformLayers[2]
        lanedivider.translationX = CreateKey(-constants.laneWidth * i)
        if (i ~= 0) then

            local lanedivider_track_edge = ((i < 0 and o.trackExtraEdgeL) or (i > 0 and o.trackExtraEdgeR)).transformLayers[2]
            lanedivider.active = math.sign(i) * (lanedivider.translationX - lanedivider_track_edge.translationX) -- Activate based on whether or not the line is within the extra track boundary

        end

    end

    o.trackExtraController.active.addKey(constants.timingDefault, 0)

    -- [[                            ]] --
    -- -- -------------------------- -- --

    -- -- Sky input initialization -- --
    -- [[                          ]] --

    ControllerObject.setParentC(o.skyInputController, o.playfieldController)
    ControllerObject.setParentC(o.skyInputLine, o.skyInputController)
    ControllerObject.setParentC(o.skyInputLabel, o.skyInputController)

    -- [[                          ]] --
    -- -- ------------------------ -- --

    local proxy = {}
    local mt = {

        __index = o,

        __newindex = 
            function(t, k, v)

                if k == "laneCount" then return end
                if k == "laneCountExtra" then return end

                o[k] = v

            end

    }
    setmetatable(proxy, mt)

    setmetatable(o, self)
    self.__index = self

    return proxy

end
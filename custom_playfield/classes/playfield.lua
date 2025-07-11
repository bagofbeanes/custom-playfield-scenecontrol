local constants = require 'custom_playfield.constants'

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

    ControllerObject.setParentC(o.trackController, o.playfieldController)

    ControllerObject.setParentC(o.trackBody, o.trackController)
    o.trackBody.transformLayers[2].root.scaleX = CreateKey(0) -- setLaneCount scales this
    o.trackBody.textureScaleX = -(o.laneCount / 4) -- makes track texture not stretch with lane count

    ControllerObject.setParentC(o.trackEdgeController, o.trackController)
    ControllerObject.setParentC(o.trackEdgeL, o.trackEdgeController)
    ControllerObject.setParentC(o.trackEdgeR, o.trackEdgeController)

    ControllerObject.setParentC(o.trackCriticalLine, o.trackController)
    o.trackCriticalLine.transformLayers[2].root.scaleX = CreateKey(0)

    ControllerObject.setParentC(o.trackLaneDividerController, o.trackController)
    for i = -lanes_half, lanes_half do

        o.trackLaneDividers[i] = LayeredSpriteObject:new(PlayfieldSkin.createTrackLaneDividerSprite(skin), 2)
        ControllerObject.setParentC(o.trackLaneDividers[i], o.trackLaneDividerController)

    end

    -- [[                      ]] --
    -- -- -------------------- -- --

    
    -- -- Extra track initialization -- --
    -- [[                            ]] --

    ControllerObject.setParentC(o.trackExtraController, o.playfieldController)

    ControllerObject.setParentC(o.trackExtraBody, o.trackExtraController)
    o.trackExtraBody.transformLayers[2].scaleX = CreateKey(0) -- setExtraLaneCount scales this

    ControllerObject.setParentC(o.trackExtraEdgeController, o.trackExtraController)
    ControllerObject.setParentC(o.trackExtraEdgeL, o.trackExtraEdgeController)
    ControllerObject.setParentC(o.trackExtraEdgeR, o.trackExtraEdgeController)

    ControllerObject.setParentC(o.trackExtraCriticalLine, o.trackExtraController)
    o.trackExtraCriticalLine.transformLayers[2].scaleX = CreateKey(0)

    ControllerObject.setParentC(o.trackExtraLaneDividerController, o.trackExtraController)
    for i = -lanes_half, lanes_half do

        o.trackExtraLaneDividers[i] = LayeredSpriteObject:new(PlayfieldSkin.createTrackExtraLaneDividerSprite(skin), 2)
        ControllerObject.setParentC(o.trackExtraLaneDividers[i], o.trackExtraLaneDividerController)

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


    setmetatable(o, self)
    self.__index = self

    return o

end
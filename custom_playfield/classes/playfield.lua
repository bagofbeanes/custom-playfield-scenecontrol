local constants = require 'custom_playfield.util.constants'

---@class beane.CustomPlayfield.IgnoreOptions
IgnoreOptions = {

    trackController = 1, -- Skips creation of all elements of TrackController
    trackExtraController = 2, -- Skips creation of all elements of TrackExtraController
    skyInputController = 4, -- Skips creation of all elements of SkyInputController

    trackBody = 8,
    trackEdgeL = 16,
    trackEdgeR = 32,
    trackCriticalLine = 64,
    trackLaneDividers = 128,

    trackExtraBody = 256,
    trackExtraEdgeL = 512,
    trackExtraEdgeR = 1024,
    trackExtraCriticalLine = 2048,
    trackExtraLaneDividers = 4096,

    skyInputLine = 8192,
    skyInputLabel = 16384,
    
}

local create_functions = {
    
    trackBody = function(skin)
        return LayeredSpriteObject:new(PlayfieldSkin.createTrackBodySprite(skin), 2)
    end,
    trackEdgeL = function(skin)
        return LayeredSpriteObject:new(PlayfieldSkin.createTrackEdgeSprite(skin), 2)
    end,
    trackEdgeR = function(skin)
        return LayeredSpriteObject:new(PlayfieldSkin.createTrackEdgeSprite(skin), 2)
    end,
    trackCriticalLine = function(skin)
        return LayeredSpriteObject:new(PlayfieldSkin.createTrackCriticalLineSprite(skin), 2)
    end,
    trackLaneDividers = function()
        return {}
    end,
    
    trackExtraBody = function(skin)
        return LayeredSpriteObject:new(PlayfieldSkin.createTrackExtraBodySprite(skin), 2)
    end,
    trackExtraEdgeL = function(skin)
        return LayeredSpriteObject:new(PlayfieldSkin.createTrackExtraEdgeSprite(skin), 2)
    end,
    trackExtraEdgeR = function(skin)
        return LayeredSpriteObject:new(PlayfieldSkin.createTrackExtraEdgeSprite(skin), 2)
    end,
    trackExtraCriticalLine = function(skin)
        return LayeredSpriteObject:new(PlayfieldSkin.createTrackExtraCriticalLineSprite(skin), 2)
    end,
    trackExtraLaneDividers = function()
        return {}
    end,
    
    skyInputLine = function(skin)
        return LayeredSpriteObject:new(PlayfieldSkin.createSkyInputLineSprite(skin), 1)
    end,
    skyInputLabel = function(skin)
        return LayeredSpriteObject:new(PlayfieldSkin.createSkyInputLabelSprite(skin), 1)
    end
    
}

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
---@param ignoreoptions? integer -- Flags/options for skipping creation of specified elements
---@return beane.CustomPlayfield.Playfield
function Playfield:new(skin, max_lane_count, ignoreoptions)

    ignoreoptions = ignoreoptions or 0
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
        trackEdgeController = CanvasObject:new(),
        trackLaneDividerController = CanvasObject:new(),

        -- [[                ]] --
        -- -- -------------- -- --


        -- -- Extra track creation -- --
        -- [[                      ]] --

        trackExtraController = CanvasObject:new(),
        trackExtraEdgeController = CanvasObject:new(),
        trackExtraLaneDividerController = CanvasObject:new(),

        -- [[                      ]] --
        -- -- -------------------- -- --


        -- -- Sky input creation -- --
        -- [[                    ]] --

        skyInputController = CanvasObject:new(),

        -- [[                    ]] --
        -- -- ------------------ -- --


        -- -- ------------------ -- --

    }
    
    for i, v in pairs(IgnoreOptions) do
        
        local j = math.log(v, 2);
        
        local enable = true
        
        if (j >= 3 and j <= 7) then
            enable = bit32.band(ignoreoptions, IgnoreOptions.trackController) == 0
        elseif (j >= 8 and j <= 12) then
            enable = bit32.band(ignoreoptions,IgnoreOptions.trackExtraController) == 0
        elseif (j >= 13 and j <= 14) then
            enable = bit32.band(ignoreoptions, IgnoreOptions.skyInputController) == 0
        end
        
        if (j >= 3 and bit32.band(ignoreoptions, v) == 0 and enable) then
            o[i] = create_functions[i](skin)
        end
        
    end

    -- -- Track initialization -- --
    -- [[                      ]] --
    
    ControllerObject.setParentC(o.trackController, o.playfieldController)
    ControllerObject.setParentC(o.trackEdgeController, o.trackController)
    ControllerObject.setParentC(o.trackLaneDividerController, o.trackController)
    
    if (o.trackBody ~= nil) then
        
        o.trackBody.transformLayers[2].scaleX = CreateKey(0)
        ControllerObject.setParentC(o.trackBody, o.trackController)
        o.trackBody.textureScaleX = -(o.laneCount / 4) -- makes track texture not stretch with lane count
        
    end
    
    if (o.trackEdgeL ~= nil) then
        
        ControllerObject.setParentC(o.trackEdgeL, o.trackEdgeController)
        
    end
    
    if (o.trackEdgeR ~= nil) then
        
        ControllerObject.setParentC(o.trackEdgeR, o.trackEdgeController)
        
    end
    
    if (o.trackCriticalLine ~= nil) then
        
        o.trackCriticalLine.transformLayers[2].scaleX = CreateKey(0)
        ControllerObject.setParentC(o.trackCriticalLine, o.trackController)
        
    end
    
    if (o.trackLaneDividers ~= nil) then
        
        for i = -lanes_half, lanes_half do

            o.trackLaneDividers[i] = LayeredSpriteObject:new(PlayfieldSkin.createTrackLaneDividerSprite(skin), 2)
            ControllerObject.setParentC(o.trackLaneDividers[i], o.trackLaneDividerController)

            local lanedivider = o.trackLaneDividers[i].transformLayers[2]
            lanedivider.translationX = CreateKey(-constants.laneWidth * i)
            if (i ~= 0) then
                
                local abs_i = math.abs(i)
                local lane_count_half = (o.laneCount / 2)
                lanedivider.active =  lane_count_half - abs_i + 1 -- Activate based on whether or not the line is within the track boundary

            end

        end
        
    end

    -- [[                      ]] --
    -- -- -------------------- -- --

    
    -- -- Extra track initialization -- --
    -- [[                            ]] --
    
    ControllerObject.setParentC(o.trackExtraController, o.playfieldController)
    ControllerObject.setParentC(o.trackExtraEdgeController, o.trackExtraController)
    ControllerObject.setParentC(o.trackExtraLaneDividerController, o.trackExtraController)
    o.trackExtraController.active.addKey(constants.timingDefault, 0)
    
    if (o.trackExtraBody ~= nil) then
        
        o.trackExtraBody.transformLayers[2].scaleX = CreateKey(0)
        ControllerObject.setParentC(o.trackExtraBody, o.trackExtraController)
        
    end
    
    if (o.trackExtraEdgeL ~= nil) then
        
        ControllerObject.setParentC(o.trackExtraEdgeL, o.trackExtraEdgeController)
        
    end
    
    if (o.trackExtraEdgeR ~= nil) then
        
        ControllerObject.setParentC(o.trackExtraEdgeR, o.trackExtraEdgeController)
        
    end
    
    if (o.trackExtraCriticalLine ~= nil) then
        
        o.trackExtraCriticalLine.transformLayers[2].scaleX = CreateKey(0)
        ControllerObject.setParentC(o.trackExtraCriticalLine, o.trackExtraController)
        
    end
    
    if (o.trackExtraLaneDividers ~= nil) then
        
        for i = -lanes_half, lanes_half do

            o.trackExtraLaneDividers[i] = LayeredSpriteObject:new(PlayfieldSkin.createTrackExtraLaneDividerSprite(skin), 2)
            ControllerObject.setParentC(o.trackExtraLaneDividers[i], o.trackExtraLaneDividerController)

            local lanedivider = o.trackExtraLaneDividers[i].transformLayers[2]
            lanedivider.translationX = CreateKey(-constants.laneWidth * i)
            if (i ~= 0) then

                local abs_i = math.abs(i)
                local lane_count_half = (o.laneCount / 2)
                lanedivider.active =  lane_count_half - abs_i + 1 -- Activate based on whether or not the line is within the track boundary
                
            end

        end
        
    end

    -- [[                            ]] --
    -- -- -------------------------- -- --

    -- -- Sky input initialization -- --
    -- [[                          ]] --
    
    ControllerObject.setParentC(o.skyInputController, o.playfieldController)
    
    if (o.skyInputLine ~= nil) then
        
        ControllerObject.setParentC(o.skyInputLine, o.skyInputController)
        
    end
    
    if (o.skyInputLabel ~= nil) then
        
        ControllerObject.setParentC(o.skyInputLabel, o.skyInputController)
        
    end

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

            end,
            
        __pairs =
            function(t)
                
                return next, o, nil
                
            end

    }
    setmetatable(proxy, mt)

    setmetatable(o, self)
    self.__index = self
        

    return proxy

end
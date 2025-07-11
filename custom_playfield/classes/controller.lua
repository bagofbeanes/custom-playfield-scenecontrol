---@class beane.CustomPlayfield.ControllerObject
---   @field root Controller
ControllerObject = {}

---@param controller Controller
function ControllerObject:new(controller)

    local o = {
        root = controller
    }

    local mt = {

        __metatable = self,

        __newindex =
            function(t, k, v)
                o.root[k] = v
            end,

        __index = 
            function (t, k)
                if self[k] ~= nil then return self[k] end
                if o.root[k] ~= nil then

                    if (k == "setParent") then 
                        notifyWarn("'setParent()' is not available for ControllerObjects. Please use 'ControllerObject.setParentC()' instead") 
                        return function() return nil end
                    end
                    if (k == "copy") then 
                        notifyWarn("'copy()' is not available for ControllerObjects.") 
                        return function() return nil end
                    end
                    
                    return o.root[k]
                end
            end

    }
    setmetatable(o, mt)

    return o

end

---@param child Controller | beane.CustomPlayfield.ControllerObject
---@param parent Controller | beane.CustomPlayfield.ControllerObject
function ControllerObject.setParentC(child, parent)

    local c = child
    if getmetatable(child) == ControllerObject or getmetatable(child) == CanvasObject then c = child.root end
    if getmetatable(child) == LayeredSpriteObject then c = child.transformLayers[1].root end
    
    local p = parent
    if getmetatable(parent) == ControllerObject or getmetatable(parent) == CanvasObject then p = parent.root end
    if getmetatable(parent) == LayeredSpriteObject then p = parent.transformLayers[1].root end
    
    c.setParent(p)

end


---@class beane.CustomPlayfield.CanvasObject : beane.CustomPlayfield.ControllerObject, CanvasController
CanvasObject = {}
setmetatable(CanvasObject, ControllerObject)

function CanvasObject:new()

    local base = ControllerObject:new(Scene.createCanvas(true))

    local o = {}
    SetDefaultKeys(
        base.root,
        {
            active = 1,
            pivotX = 0, pivotY = 0,

            translationX = 0, translationY = 0, translationZ = 0,
            rotationX = 0, rotationY = 0, rotationZ = 0,
            scaleX = 1, scaleY = 1, scaleZ = 1
        }
    )

    local mt = {

        __metatable = self,

        __newindex =
            function(t, k, v)
                base.root[k] = v
            end,

        __index = 
            function(t, k)
                if self[k] ~= nil then return self[k] end
                if base[k] ~= nil then return base[k] end
            end
            
    }
    setmetatable(o, mt)

    return o

end

---SpriteController with an optional number of transformation layers for more flexible transformations
---@class beane.CustomPlayfield.LayeredSpriteObject : beane.CustomPlayfield.ControllerObject, SpriteController
---   @field transformLayers beane.CustomPlayfield.CanvasObject[]
LayeredSpriteObject = {}
setmetatable(LayeredSpriteObject, ControllerObject)

---@param self beane.CustomPlayfield.LayeredSpriteObject
---@param sprite SpriteController
---@param layers? integer
---@return beane.CustomPlayfield.LayeredSpriteObject
function LayeredSpriteObject:new(sprite, layers)

    local base = ControllerObject:new(sprite)

    layers = (layers ~= nil and math.clamp(layers, 1, 8)) or 1

    local o = {
        transformLayers = {}
    }
    for i = 1, layers do

        o.transformLayers[i] = CanvasObject:new()
        if (i > 1) then o.transformLayers[i].root.setParent(o.transformLayers[i - 1].root) end

    end

    base.root.setParent(o.transformLayers[#o.transformLayers].root)

    local transformlayer_main = o.transformLayers[1].root
    local root = base.root
    local fields = {

        active = transformlayer_main,

        translationX = transformlayer_main,
        translationY = transformlayer_main,
        translationZ = transformlayer_main,

        rotationX = transformlayer_main,
        rotationY = transformlayer_main,
        rotationZ = transformlayer_main,

        scaleX = transformlayer_main,
        scaleY = transformlayer_main,
        scaleZ = transformlayer_main,

        colorR = root,
        colorG = root,
        colorB = root,

        colorH = root,
        colorS = root,
        colorV = root,

        colorA = root,

        textureOffsetX = root,
        textureOffsetY = root,
        textureScaleX = root,
        textureScaleY = root,

        sort = root,
        layer = root

    }
    
    local mt = {

        __metatable = self,

        __newindex =
            function(t, k, v)
                if fields[k] ~= nil then fields[k][k] = v; return end
                base.root[k] = v
            end,

        __index = 
            function(t, k)
                if self[k] ~= nil then return self[k] end
                if fields[k] ~= nil then return fields[k][k] end
                if base[k] ~= nil then return base[k] end
            end

    }
    setmetatable(o, mt)

    return o

end
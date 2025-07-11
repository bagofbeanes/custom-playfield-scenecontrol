local constants = require 'custom_playfield.constants'

-- -- Tweening -- --
-- [[          ]] --

---@param channel KeyChannel
---@param value any
---@param start_timing? integer
---@param end_timing? integer
---@param easing? ('linear' | 'l' | 'inconstant' | 'inconst' | 'cnsti' | 'outconstant' | 'outconst' | 'cnsto' | 'inoutconstant' | 'inoutconst' | 'cnstb' | 'insine' | 'si' | 'outsine' | 'so' | 'inoutsine' | 'b' | 'inquadratic' | 'inquad' | '2i' | 'outquadratic' | 'outquad' | '2o' | 'inoutquadratic' | 'inoutquad' | '2b' | 'incubic' | '3i' | 'outcubic' | 'outcube' | '3o' | 'inoutcubic' | 'inoutcube' | '3b' | 'inquartic' | 'inquart' | '4i' | 'outquartic' | 'outquart' | '4o' | 'inoutquartic' | 'inoutquart' | '4b' | 'inquintic' | 'inquint' | '5i' | 'outquintic' | 'outquint' | '5o' | 'inoutquintic' | 'inoutquint' | '5b' | 'inexponential' | 'inexpo' | 'exi' | 'outexponential' | 'outexpo' | 'exo' | 'inoutexponential' | 'inoutexpo' | 'exb' | 'incircle' | 'incirc' | 'ci' | 'outcircle' | 'outcirc' | 'co' | 'inoutcircle' | 'inoutcirc' | 'cb' | 'inback' | 'bki' | 'outback' | 'bko' | 'inoutback' | 'bkb' | 'inelastic' | 'eli' | 'outelastic' | 'elo' | 'inoutelastic' | 'elb' | 'inbounce' | 'bni' | 'outbounce' | 'bno' | 'inoutbounce' | 'bnb')
---@param additive? boolean
function Tween(channel, value, start_timing, end_timing, easing, additive)

    local value_previous = channel.valueAt(start_timing or constants.timingDefault) or 0
    value = (additive and value_previous + value) or value

    if (start_timing ~= nil) then
        if (start_timing == end_timing or end_timing == nil) then -- Creates a single key if the start and end time are the same
            channel.addKey(start_timing, value, 'inconst')
        else
            channel.addKey(start_timing, value_previous, easing or 'l')
                       .addKey(end_timing, value, 'inconst')
        end
    else
        channel.addKey(constants.timingDefault, value, 'inconst')
    end

end

-- [[          ]] --
-- -- -------- -- --



-- -- Functions related to default values -- --
-- [[                                     ]] --

-- Get the value of `channel` at `defaultTiming`
---@param channel ValueChannel
---@return number
function GetDefaultValue(channel)
    return channel.valueAt(constants.timingDefault)
end

-- Returns a keyframe at the base timing set to `value`
---@param default_value any
function CreateKey(default_value)

    local channel = Channel.keyframe()
    channel.setDefaultEasing('cnsti')
    channel.addKey(constants.timingDefault, default_value)

    return channel

end

-- Set all channels of a controller to its corresponding entry in `values`
---@param controller Controller
---@param values table<string, any> -- Key-value table of channels and the values to set them to
function SetDefaultValues(controller, values)

    for k, v in pairs(values) do
        controller[k] = v
    end
    
end

-- Set the default keyframes for all channels of a controller
---@param controller Controller
---@param values table<string, any> -- Key-value table of channels and the values to set them to
function SetDefaultKeys(controller, values)

    for k, v in pairs(values) do
        controller[k] = CreateKey(v)
    end

end

-- Copy the values of the specified channels from `controllerFrom` to `controllerTo`
---@param controller_target Controller
---@param controller_source Controller
---@param channels string[] -- List of channels to copy the values of
function CopyDefaultValues(controller_target, controller_source, channels)

    for _, v in pairs(channels) do
        controller_target[v] = GetDefaultValue(controller_source[v])
    end

end

-- Copy the default keyframes of the specified channels from `controllerFrom` to `controllerTo`
---@param controller_target Controller
---@param controller_source Controller
---@param channels string[] -- List of channels to copy the default keyframes of
function CopyDefaultKeys(controller_target, controller_source, channels)

    for _, v in pairs(channels) do
        controller_target[v] = CreateKey(GetDefaultValue(controller_source[v]))
    end

end

-- [[                                     ]] --
-- -- ----------------------------------- -- --



-- -- Math related functions -- --
-- [[                        ]] --

---@param x number
---@param min number
---@param max number
---@return number
function math.clamp(x, min, max)

    if (x < min) then
        return min
    elseif (x > max) then
        return max
    end
    return x

end

---@param x number
---@return number
function math.sign(x)

    if (x > 0) then return 1
    elseif (x < 0) then return -1 end
    return 0

end

---@param x number
---@param decimals integer
---@return number
function math.round(x, decimals)

    if (decimals < 0) then decimals = 0 end
    decimals = 10 ^ decimals
    return math.floor((x * decimals) + 0.5) / decimals

end

---@param x number
---@param decimals integer
---@return number
function math.truncate(x, decimals)

    if (decimals < 1) then decimals = 1 end
    decimals = 10 ^ decimals
    return math.floor((x * decimals)) / decimals

end

---@param x number
---@param min_from number
---@param max_from number
---@param min_to number
---@param max_to number
---@return number
function math.mapRange(x, min_from, max_from, min_to, max_to)

    local source_range = max_from - min_from
    local result_range = max_to - min_to

    return ((x - min_from) * result_range) / source_range + min_to

end

-- [[                        ]] --
-- -- ---------------------- -- --
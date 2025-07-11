local default_track = Scene.track
local function truncate(x, decimals)

    if (decimals < 1) then decimals = 1 end
    decimals = 10 ^ decimals
    return math.floor((x * decimals)) / decimals

end

-- -- Constant values -- --
-- [[                 ]] --

local constants = {}

-- Timing for default values, use when you want to add a key to before the chart starts
constants.timingDefault = -9999

-- Width of a single lane
constants.laneWidth = truncate(math.abs(default_track.divideLine12.translationX.valueAt(constants.timingDefault) - default_track.divideLine23.translationX.valueAt(constants.timingDefault)) * default_track.scaleX.valueAt(constants.timingDefault), 2)

-- Simulates track movement (thanks walker)
constants.trackWalk = Channel.keyframe().addKey(constants.timingDefault, 0, 'l').addKey(10000000, 60000) * (Context.bpm(0) / Context.bpm(0).valueAt(0))

return constants

-- [[                 ]] --
-- -- --------------- -- --
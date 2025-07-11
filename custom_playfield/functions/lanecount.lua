local constants = require 'custom_playfield.constants'

local line_width_default = GetDefaultValue(Scene.track.divideLine23.scaleX) * GetDefaultValue(Scene.track.scaleX)

---@param self beane.CustomPlayfield.Playfield
---@param lane_count number
---@param start_timing? integer
---@param end_timing? integer
---@param easing? ('linear' | 'l' | 'inconstant' | 'inconst' | 'cnsti' | 'outconstant' | 'outconst' | 'cnsto' | 'inoutconstant' | 'inoutconst' | 'cnstb' | 'insine' | 'si' | 'outsine' | 'so' | 'inoutsine' | 'b' | 'inquadratic' | 'inquad' | '2i' | 'outquadratic' | 'outquad' | '2o' | 'inoutquadratic' | 'inoutquad' | '2b' | 'incubic' | '3i' | 'outcubic' | 'outcube' | '3o' | 'inoutcubic' | 'inoutcube' | '3b' | 'inquartic' | 'inquart' | '4i' | 'outquartic' | 'outquart' | '4o' | 'inoutquartic' | 'inoutquart' | '4b' | 'inquintic' | 'inquint' | '5i' | 'outquintic' | 'outquint' | '5o' | 'inoutquintic' | 'inoutquint' | '5b' | 'inexponential' | 'inexpo' | 'exi' | 'outexponential' | 'outexpo' | 'exo' | 'inoutexponential' | 'inoutexpo' | 'exb' | 'incircle' | 'incirc' | 'ci' | 'outcircle' | 'outcirc' | 'co' | 'inoutcircle' | 'inoutcirc' | 'cb' | 'inback' | 'bki' | 'outback' | 'bko' | 'inoutback' | 'bkb' | 'inelastic' | 'eli' | 'outelastic' | 'elo' | 'inoutelastic' | 'elb' | 'inbounce' | 'bni' | 'outbounce' | 'bno' | 'inoutbounce' | 'bnb')
---@param is_extra boolean
local function setlanecount_main(self, lane_count, start_timing, end_timing, easing, is_extra)

    local track_lane_count = (is_extra and self.laneCountExtra) or self.laneCount
    local track_body = (is_extra and self.trackExtraBody) or self.trackBody
    local track_criticalline = (is_extra and self.trackExtraCriticalLine) or self.trackCriticalLine
    local track_edgeL = (is_extra and self.trackExtraEdgeL) or self.trackEdgeL
    local track_edgeR = (is_extra and self.trackExtraEdgeR) or self.trackEdgeR
    local track_lanedividers = (is_extra and self.trackExtraLaneDividers) or self.trackLaneDividers

    lane_count = math.clamp(lane_count, 0.00001, self.maxLaneCount)
    Tween(track_lane_count, lane_count, start_timing, end_timing, easing)
    
    local track_width = (lane_count / 4) - 0.005 -- Slightly smaller than needed to account for lane divider visibility between the regular and the extra track

    do -- Scale the track & critical line
    
        Tween(track_body.transformLayers[2].scaleX, track_width, start_timing, end_timing, easing)
        Tween(track_criticalline.transformLayers[2].scaleX, track_width, start_timing, end_timing, easing)

    end

    do -- Move track edges
    
        local edge_width = (36 / 512) * constants.laneWidth -- Width of a track edge (i think)
        local edge_translation = (edge_width + ((lane_count / 2) * constants.laneWidth)) - 0.033 -- Subtracting a very specific value from it to prevent a tiny space between the track and the edges

        Tween(track_edgeL.transformLayers[2].translationX, edge_translation, start_timing, end_timing, easing)
        Tween(track_edgeR.transformLayers[2].translationX, -edge_translation, start_timing, end_timing, easing)
    
    end

    do -- Handle divide lines

        local track_half = math.floor(self.maxLaneCount / 2) -- Lanes on one half of the track
        local line_count_half = lane_count / 2 - 1 -- Amount of lines that should appear on one half of the track, minus the middle

        local min_i_distance = track_half - line_count_half -- Minimum distance from the center index (0) required to move a line outwards (since outer lines are picked first)

        for i = -track_half, track_half do

            local lanedivider = track_lanedividers[i].transformLayers[2]

            if (i ~= 0) then -- Transform every divide line but the middle one

                if (math.abs(i) > math.floor(min_i_distance)) then -- Translate divide lines that are far enough from the center index (i think)
                
                    if (lanedivider.active.valueAt(start_timing or constants.timingDefault) == 0) then -- If line is inactive, make it active
                    
                        Tween(lanedivider.active, 1, start_timing)

                    end

                    local side_factor = math.sign(i) -- First and last divide lines are picked first and move out the furthest, closes in as necessary toward the center
                    local line_translation = constants.laneWidth * (i - (side_factor * min_i_distance)) -- Where to translate the line (determined by which half it's on and how far the first line on each half is from the center index)

                    Tween(lanedivider.translationX, line_translation, start_timing, end_timing, easing)
                    Tween(lanedivider.scaleX, line_width_default, start_timing, end_timing, easing)

                elseif (lanedivider.active.valueAt(start_timing or constants.timingDefault) == 1) then -- Move all other lines that aren't in the middle to the middle

                    Tween(lanedivider.translationX, 0, start_timing, end_timing, easing)
                    Tween(lanedivider.scaleX, 0, start_timing, end_timing, easing)
                    
                    Tween(lanedivider.active, 0, end_timing)

                end

            else -- Transform middle divide line

                if (lane_count % 2 == 0) then -- If lane lane_count is even, show middle line
        
                    Tween(lanedivider.scaleX, line_width_default, start_timing, end_timing, easing)
                    Tween(lanedivider.active, 1, start_timing)
                
                else -- Otherwise make the middle line disappear
                
                    Tween(lanedivider.scaleX, 0, start_timing, end_timing, easing)
                    Tween(lanedivider.active, 0, end_timing)
            
                end

            end

        end
    end

end

---Sets the number of visible lanes on the track
---@param self beane.CustomPlayfield.Playfield
---@param lane_count number
---@param start_timing? integer
---@param end_timing? integer
---@param easing? ('linear' | 'l' | 'inconstant' | 'inconst' | 'cnsti' | 'outconstant' | 'outconst' | 'cnsto' | 'inoutconstant' | 'inoutconst' | 'cnstb' | 'insine' | 'si' | 'outsine' | 'so' | 'inoutsine' | 'b' | 'inquadratic' | 'inquad' | '2i' | 'outquadratic' | 'outquad' | '2o' | 'inoutquadratic' | 'inoutquad' | '2b' | 'incubic' | '3i' | 'outcubic' | 'outcube' | '3o' | 'inoutcubic' | 'inoutcube' | '3b' | 'inquartic' | 'inquart' | '4i' | 'outquartic' | 'outquart' | '4o' | 'inoutquartic' | 'inoutquart' | '4b' | 'inquintic' | 'inquint' | '5i' | 'outquintic' | 'outquint' | '5o' | 'inoutquintic' | 'inoutquint' | '5b' | 'inexponential' | 'inexpo' | 'exi' | 'outexponential' | 'outexpo' | 'exo' | 'inoutexponential' | 'inoutexpo' | 'exb' | 'incircle' | 'incirc' | 'ci' | 'outcircle' | 'outcirc' | 'co' | 'inoutcircle' | 'inoutcirc' | 'cb' | 'inback' | 'bki' | 'outback' | 'bko' | 'inoutback' | 'bkb' | 'inelastic' | 'eli' | 'outelastic' | 'elo' | 'inoutelastic' | 'elb' | 'inbounce' | 'bni' | 'outbounce' | 'bno' | 'inoutbounce' | 'bnb')
function Playfield:setLaneCount(lane_count, start_timing, end_timing, easing)

    setlanecount_main(self, lane_count, start_timing, end_timing, easing, false)
    return self

end

---Sets the number of visible lanes on the extra track. Don't forget to activate `trackExtraController` first!
---@param self beane.CustomPlayfield.Playfield
---@param lane_count number
---@param start_timing? integer
---@param end_timing? integer
---@param easing? ('linear' | 'l' | 'inconstant' | 'inconst' | 'cnsti' | 'outconstant' | 'outconst' | 'cnsto' | 'inoutconstant' | 'inoutconst' | 'cnstb' | 'insine' | 'si' | 'outsine' | 'so' | 'inoutsine' | 'b' | 'inquadratic' | 'inquad' | '2i' | 'outquadratic' | 'outquad' | '2o' | 'inoutquadratic' | 'inoutquad' | '2b' | 'incubic' | '3i' | 'outcubic' | 'outcube' | '3o' | 'inoutcubic' | 'inoutcube' | '3b' | 'inquartic' | 'inquart' | '4i' | 'outquartic' | 'outquart' | '4o' | 'inoutquartic' | 'inoutquart' | '4b' | 'inquintic' | 'inquint' | '5i' | 'outquintic' | 'outquint' | '5o' | 'inoutquintic' | 'inoutquint' | '5b' | 'inexponential' | 'inexpo' | 'exi' | 'outexponential' | 'outexpo' | 'exo' | 'inoutexponential' | 'inoutexpo' | 'exb' | 'incircle' | 'incirc' | 'ci' | 'outcircle' | 'outcirc' | 'co' | 'inoutcircle' | 'inoutcirc' | 'cb' | 'inback' | 'bki' | 'outback' | 'bko' | 'inoutback' | 'bkb' | 'inelastic' | 'eli' | 'outelastic' | 'elo' | 'inoutelastic' | 'elb' | 'inbounce' | 'bni' | 'outbounce' | 'bno' | 'inoutbounce' | 'bnb')
function Playfield:setExtraLaneCount(lane_count, start_timing, end_timing, easing)

    setlanecount_main(self, lane_count, start_timing, end_timing, easing, true)
    return self

end
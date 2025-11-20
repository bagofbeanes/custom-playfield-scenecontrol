local constants = require 'custom_playfield.util.constants'

---@param self beane.CustomPlayfield.Playfield
---@param lane_count number
---@param start_timing? integer
---@param end_timing? integer
---@param easing? ('linear' | 'l' | 'inconstant' | 'inconst' | 'cnsti' | 'outconstant' | 'outconst' | 'cnsto' | 'inoutconstant' | 'inoutconst' | 'cnstb' | 'insine' | 'si' | 'outsine' | 'so' | 'inoutsine' | 'b' | 'inquadratic' | 'inquad' | '2i' | 'outquadratic' | 'outquad' | '2o' | 'inoutquadratic' | 'inoutquad' | '2b' | 'incubic' | '3i' | 'outcubic' | 'outcube' | '3o' | 'inoutcubic' | 'inoutcube' | '3b' | 'inquartic' | 'inquart' | '4i' | 'outquartic' | 'outquart' | '4o' | 'inoutquartic' | 'inoutquart' | '4b' | 'inquintic' | 'inquint' | '5i' | 'outquintic' | 'outquint' | '5o' | 'inoutquintic' | 'inoutquint' | '5b' | 'inexponential' | 'inexpo' | 'exi' | 'outexponential' | 'outexpo' | 'exo' | 'inoutexponential' | 'inoutexpo' | 'exb' | 'incircle' | 'incirc' | 'ci' | 'outcircle' | 'outcirc' | 'co' | 'inoutcircle' | 'inoutcirc' | 'cb' | 'inback' | 'bki' | 'outback' | 'bko' | 'inoutback' | 'bkb' | 'inelastic' | 'eli' | 'outelastic' | 'elo' | 'inoutelastic' | 'elb' | 'inbounce' | 'bni' | 'outbounce' | 'bno' | 'inoutbounce' | 'bnb')
---@param is_extra boolean
local function setlanecount_main(self, lane_count, start_timing, end_timing, easing, is_extra)

    start_timing = start_timing or constants.timingDefault

    local track_lane_count;     if is_extra then track_lane_count = self.laneCountExtra else track_lane_count = self.laneCount end
    local track_body;           if is_extra then track_body = self.trackExtraBody else track_body = self.trackBody end
    local track_edgeL;          if is_extra then track_edgeL = self.trackExtraEdgeL else track_edgeL = self.trackEdgeL end
    local track_edgeR;          if is_extra then track_edgeR = self.trackExtraEdgeR else track_edgeR = self.trackEdgeR end
    local track_lanedividers;   if is_extra then track_lanedividers = self.trackExtraLaneDividers else track_lanedividers = self.trackLaneDividers end

    lane_count = math.clamp(lane_count, 0, self.maxLaneCount)
    Tween(track_lane_count, lane_count, start_timing, end_timing, easing)
    
    local track_width = math.max(0, lane_count / 4) -- Slightly smaller than needed to account for lane divider visibility between the regular and the extra track

    do -- Scale the track & critical line
    
        if (track_body ~= nil) then
            Tween(track_body.transformLayers[2].scaleX, track_width, start_timing, end_timing, easing)
        end

    end

    do -- Move track edges
    
        local edge_width = (35 / 512) * 1.125 * constants.laneWidth -- Width of a track edge (dont understand why 1.125 is needed but it works)
        local edge_translation = (edge_width + ((lane_count / 2) * constants.laneWidth)) - 0.033 -- Subtracting a very specific value from it to prevent a tiny space between the track and the edges

        if (track_edgeL ~= nil) then Tween(track_edgeL.transformLayers[2].translationX, edge_translation, start_timing, end_timing, easing) end
        if (track_edgeR ~= nil) then Tween(track_edgeR.transformLayers[2].translationX, -edge_translation, start_timing, end_timing, easing) end
    
    end

    do -- Handle lane dividers

        if (track_lanedividers ~= nil) then
    
            local max_lane_count_half = math.floor(self.maxLaneCount / 2) -- Lanes on one half of the track
            local line_count_half = math.max(0, lane_count / 2) -- Amount of lines that should appear on one half of the track

            for i = -max_lane_count_half, max_lane_count_half do

                local lanedivider = track_lanedividers[i].transformLayers[2]

                if (i ~= 0) then -- Transform every lane divider but the middle one

                    local side_factor = math.sign(i)
                    local oddness_factor = math.ceil(line_count_half) - line_count_half
                    local line_position = constants.laneWidth * -side_factor * (math.abs(i) - oddness_factor)

                    if (math.abs(i) <= math.ceil(line_count_half)) then

                        Tween(lanedivider.translationX, line_position, start_timing, end_timing, easing)

                        local scale_end_timing = end_timing
                        if start_timing ~= nil and end_timing ~= nil then
                            scale_end_timing = start_timing + (end_timing - start_timing) / 2 -- Scaling will finish in half as much time
                        end

                        Tween(lanedivider.scaleX, 1, start_timing, scale_end_timing, easing)

                    else

                        Tween(lanedivider.translationX, line_position, start_timing, end_timing, easing)
                        Tween(lanedivider.scaleX, 0, start_timing, end_timing, easing)

                    end

                else -- Transform middle lane divider

                    if (lane_count % 2 == 0) then -- If lane lane_count is even, show middle line
            
                        Tween(lanedivider.scaleX, 1, start_timing, end_timing, easing)
                        Tween(lanedivider.active, 1, start_timing)
                    
                    else -- Otherwise make the middle line disappear
                    
                        Tween(lanedivider.scaleX, 0, start_timing, end_timing, easing)
                        Tween(lanedivider.active, 0, end_timing)
                
                    end

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
require 'custom_playfield.main'

local Context = require 'custom_playfield.util.context_extension'
local constants = require 'custom_playfield.util.constants'
local skin_list = require 'custom_playfield.skinlist'

-- Initialize a basic playfield
local playfield_main = Playfield:new(skin_list.confict, 6):setLaneCount(4, constants.timingDefault):setExtraLaneCount(4, constants.timingDefault)
playfield_main.trackExtraController.active = CreateKey(0)
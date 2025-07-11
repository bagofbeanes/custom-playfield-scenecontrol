require 'custom_playfield.main'

local constants = require 'custom_playfield.constants'
local skin_list = require 'custom_playfield.skinlist'
local Context = require 'custom_playfield.context_extension'

-- Initialize a basic playfield
local playfield_main = Playfield:new(skin_list.conflict, 6):setLaneCount(4, constants.timingDefault):setExtraLaneCount(4, constants.timingDefault)
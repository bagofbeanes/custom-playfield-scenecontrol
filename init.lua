require 'custom_playfield.main'

Context2 = require 'custom_playfield.util.context_extension'
Constants = require 'custom_playfield.util.constants'
SkinList = require 'custom_playfield.skinlist'

-- Initialize a basic playfield
local playfield_main = Playfield:new(SkinList.conflict, 6):setLaneCount(4, Constants.timingDefault):setExtraLaneCount(4, Constants.timingDefault)
playfield_main.trackExtraController.active = CreateKey(0)
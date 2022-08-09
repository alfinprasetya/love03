-- Push library (used to draw in virtual resolution)
-- Make game more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'lib/push'

-- Lua Class library
-- 
-- https://github.com/vrld/hump/blob/master/class.lua
class = require 'lib/class'

-- Global Constants file
require 'src/constants'

-- Utility function to handle sprite sheet
require 'src/Util'

-- State Machine
require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'

-- Object class
require 'src/Paddle'
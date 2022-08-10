-- Push library (used to draw in virtual resolution)
-- Make game more retro aesthetic
--
-- https://github.com/Ulydev/push
Push = require 'lib/push'

-- Lua Class library
-- 
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

-- Global Constants file
require 'src/constants'

-- Utility function to handle sprite sheet
require 'src/Util'

-- Level Maker
require 'src/LevelMaker'

-- State Machine
require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/ServeState'
require 'src/states/GameOverState'

-- Object class
require 'src/Paddle'
require 'src/Ball'
require 'src/Brick'
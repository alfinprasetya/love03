--[[
    Project Metadata
    No          : 3
    Name        : Breakout
    Author      : Alfin Prasetya
    Start Date  : 5 Agustus 2022
    Finish Date : n.a
]]

require 'src/Dependencies'

--Load function
function love.load()
    --App title
    love.window.setTitle('Breakout')

    --Set retro filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --Random generator
    math.randomseed(os.time())

    --Initialize fonts
        gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    }
    love.graphics.setFont(gFonts['small'])

    --Initialize Graphics Assets
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['ball'] = love.graphics.newImage('graphics/ball.png'),
        --['arrows'] = love.graphics.newImage('graphics/....png'),
        ['hearts'] = love.graphics.newImage('graphics/heart.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    --Generate quad from main image
    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuadsHearts(gTextures['hearts'])
    }

    --Set game window
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
        {
            fullscreen = false,
            resizable = false,
            vsync = true
        })
        
    
    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'stream')
    }

    --Initialize state machine
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function () return GameOverState() end
    }
    gStateMachine:change('start')

    --Table to track keyboard input
    love.keyboard.keypressed = {}
end

function love.resize(w, h)
    Push:resize(w, h)
end

--Update function
function love.update(dt)
    --Pass update function into gamestate object
    gStateMachine:update(dt)

    --Reset keys pressed
    love.keyboard.keypressed = {}
end

--Love function to detect keyboard input
function love.keypressed(key)
    --Passing key to keypressed table
    love.keyboard.keypressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keypressed[key] then
        return true
    else
        return false
    end
end

function love.draw()
    Push:apply('start')

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(
        gTextures['background'],
        -- Draw at coordinates 0,0
        0, 0,
        -- No rotation
        0,
        -- Scale factor on x and y to fit the screen
        VIRTUAL_WIDTH / backgroundWidth,
        VIRTUAL_HEIGHT / backgroundHeight
    )

    gStateMachine:render()

    displayFPS()

    Push:apply('end')
end

function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

function renderHealth(health)
    local healthX = VIRTUAL_WIDTH - 100

    for i = 1, health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 5)
        healthX = healthX + 13
    end

    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 5)
        healthX = healthX + 13
    end
end

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score: ', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, "right")
end
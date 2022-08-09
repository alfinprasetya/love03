
PlayState = class{__includes = BaseState}

function PlayState:init()
    self.paddle = Paddle()

    self.ball = Ball(math.random(10))

    self.ball.dx = math.random(2) == 1 and -100 or 100
    self.ball.dy = -100

    self.ball.x = VIRTUAL_WIDTH / 2 - 8
    self.ball.y = VIRTUAL_HEIGHT - 50

    self.paused = false
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        self.ball.y = self.paddle.y - self.ball.height - 1
        self.ball.dy = -self.ball.dy
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    self.paddle:render()
    self.ball:render()
    
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, "center")
    end
end
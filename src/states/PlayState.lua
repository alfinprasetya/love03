
PlayState = class{__includes = BaseState}

function PlayState:init()
    self.paused = false

    self.paddle = Paddle()
    self.ball = Ball()
    self.bricks = LevelMaker.createMap()

    self.ball.dx = math.random(-50, 50)
    self.ball.dy = -60

    self.ball.x = VIRTUAL_WIDTH / 2 - 4
    self.ball.y = VIRTUAL_HEIGHT - 50
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

    if self.ball:collides(self.paddle) and self.ball.y <= self.paddle.y + 8 then
        self.ball.y = self.paddle.y - self.ball.height - 1
        self.ball.dy = -self.ball.dy

        if self.ball.x < self.paddle.center and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(2 * (self.paddle.center - self.ball.x))

        elseif self.ball.x > self.paddle.center and self.paddle.dx > 0 then
            self.ball.dx = 50 + (2 * math.abs(self.paddle.center - self.ball.x))

        end

        gSounds['paddle-hit']:play()
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then

            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - self.ball.width

            elseif self.ball.x + self.ball.width - 2 > brick.x + brick.width and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + brick.width

            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - self.ball.height

            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + brick.height
            end

            self.ball.y = self.ball.y * 1.05

            brick:hit()
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    self.paddle:render()
    self.ball:render()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            brick:render()
        end
    end
    
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, "center")
    end
end
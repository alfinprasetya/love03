
PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball

    self.paused = false

    self.ball.dx = math.random(-50, 50)
    self.ball.dy = -70
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
            self.ball.dx = -50 + -(5 * (self.paddle.center - self.ball.x))

        elseif self.ball.x > self.paddle.center and self.paddle.dx > 0 then
            self.ball.dx = 50 + (5 * math.abs(self.paddle.center - self.ball.x))

        end

        gSounds['paddle-hit']:play()
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            self.score = self.score + (brick.tier * 20) + 10

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

    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score
            })
        end
    end

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
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

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    renderHealth(self.health)
    renderScore(self.score)
    
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, "center")
    end
end
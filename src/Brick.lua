
Brick = class{}

function Brick:init(x, y, color)
    self.color = color

    self.x = x
    self.y = y
    self.width = 32
    self. height = 16

    self.inPlay = true
end

function Brick:hit()
    gSounds['brick-hit-2']:play()

    self.inPlay = false
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['bricks'][1 + 6 * (self.color - 1)], self.x, self.y)
    end
end
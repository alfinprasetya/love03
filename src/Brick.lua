
Brick = Class{}

paletteColors = {
    -- red
    [1] = {
        ['r'] = 1,
        ['g'] = 0.4,
        ['b'] = 0.35
    },
    -- blue
    [2] = {
        ['r'] = 0.46,
        ['g'] = 0.84,
        ['b'] = 0.75
    },
    -- green
    [3] = {
        ['r'] = 0.6,
        ['g'] = 0.72,
        ['b'] = 0.23
    },
    -- orange
    [4] = {
        ['r'] = 1,
        ['g'] = 0.5,
        ['b'] = 0.23
    },
    -- gold
    [5] = {
        ['r'] = 1,
        ['g'] = 1,
        ['b'] = 0.9
    },
    -- dark purple
    [6] = {
        ['r'] = 1,
        ['g'] = 0.53,
        ['b'] = 0.66
    },
    -- grey
    [7] = {
        ['r'] = 1,
        ['g'] = 1,
        ['b'] = 0.9
    },
    -- brown
    [8] = {
        ['r'] = 1,
        ['g'] = 0.7,
        ['b'] = 0.66
    },
    -- light purple
    [9] = {
        ['r'] = 1,
        ['g'] = 1,
        ['b'] = 0.9
    },
    -- dark blue
    [10] = {
        ['r'] = 0.1,
        ['g'] = 0.57,
        ['b'] = 0.65
    }
}

function Brick:init(x, y)
    self.color = 1
    self.tier = 1

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16

    self.inPlay = true

    -- particle system belonging to the brick, emitted on hit
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
    self.psystem:setParticleLifetime(0.5, 1)
    self.psystem:setSizeVariation(0.5)
    self.psystem:setLinearAcceleration(-5, -5, 80, 80)
    self.psystem:setSpin(0, 60)
    self.psystem:setSpinVariation(1)
    self.psystem:setTangentialAcceleration(10, 20)
    self.psystem:setEmissionArea('normal', 8, 8)
end

function Brick:hit()
    -- emit from the proper particle system first, since it depends on color
    self.psystem:setColors(
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        0.33 * (self.tier + 1),
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        0
    )
    self.psystem:emit(32)

    if self.tier > 0 then
        self.tier = self.tier - 1
    else
        self.inPlay = false
    end

    gSounds['brick-hit-2']:play()

    if not self.inPlay then
        gSounds['brick-hit-1']:play()
    end
end

function Brick:update(dt)
    self.psystem:update(dt)
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['bricks'][self.color + (self.tier * 10)], self.x, self.y)
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end
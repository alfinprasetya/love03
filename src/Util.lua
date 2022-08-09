
-- Function to generate quad/tile from any given image
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] = 
                love.graphics.newQuad(
                    x * tilewidth, y * tileheight, tilewidth, tileheight, sheetWidth, sheetHeight
                )
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

-- Utility function to slice table
function table.slice(tbl, first, last, step)
    local sliced = {}
   
    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end

    return sliced
end

-- Generate paddle sprite from sprite sheet
function GenerateQuadsPaddles(atlas)
    local width = atlas:getWidth()
    local height = atlas:getHeight()
    local x = 0
    local y = 384

    local counter = 1
    local quads = {}

    for i = 0, 7 do
        -- smallest
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, width, height)
        counter = counter + 1
        -- small
        quads[counter] = love.graphics.newQuad(x + 40, y, 48, 16, width, height)
        counter = counter + 1
        -- medium
        quads[counter] = love.graphics.newQuad(x + 96, y, 64, 16, width, height)
        counter = counter + 1
        -- large
        quads[counter] = love.graphics.newQuad(x + 168, y, 80 , 16, width, height)
        counter = counter + 1
        -- larger
        quads[counter] = love.graphics.newQuad(x + 256, y, 96, 16, width, height)
        counter = counter + 1

        x = 0
        y = y + 16
    end

    return quads
end

-- Generate paddle sprite from sprite sheet
function GenerateQuadsBalls(atlas)
    local width = atlas:getWidth()
    local height = atlas:getHeight()
    local x = 384
    local y = 384

    local counter = 1
    local quads = {}

    for j = 0, 4 do
        for i = 0, 1 do
           quads[counter] = love.graphics.newQuad(x, y, 16, 16, width, height)
           x = x + 16
           counter = counter + 1
        end
        x = 384
        y = y + 16
    end

    return quads
end

LevelMaker = class{}

function LevelMaker.createMap(level)
    local bricks = {}

    local numRows = math.random(2, 5)
    local numCols = math.random(7, 12)
    local color = math.random(10)

    for y = 1, numRows do
        for x = 1, numCols do
            b = Brick(
                (x-1) 
                * 34 
                + 12
                + (12 - numCols) * 17,
                y * 17,
                color
            )

            table.insert(bricks, b)
        end

        color = math.max(1, math.min(10, color - math.random(-10, 10)))
    end

    return bricks
end
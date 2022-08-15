
-- Global patterns to make entire map a certain shape
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

-- Per-row patterns
SOLID = 1
ALTERNATE = 2
SKIP = 3
NONE = 4

LevelMaker = Class{}

function LevelMaker.createMap(level)
    local bricks = {}

    local numRows = math.random(2, 5)

    local numCols = math.random(7, 11)
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols
    
    local color = math.random(10)

    -- highest possible spawned brick color in this level
    local highestTier = math.min(2, level)

    for y = 1, numRows do
        -- whether we want to enable skipping for this row
        local skipPattern = math.random(1, 2) == 1 and true or false

        -- used only when we want to skip a block, for skip pattern
        local skipFlag = math.random(2) == 1 and true or false

        -- whether we want to enable alternating colors for this row
        local alternatePattern = math.random(1, 2) == 1 and true or false

        -- choose two colors to alternate between
        local alternateColor1 = math.random(1, 10)
        local alternateColor2 = math.random(1, 10)
        local alternateTier1 = math.random(0, highestTier)
        local alternateTier2 = math.random(0, highestTier)

        -- used only when we want to alternate a block, for alternate pattern
        local alternateFlag = math.random(2) == 1 and true or false

        -- solid color we'll use if we're not skipping or alternating
        local solidColor = math.random(1, 10)
        local solidTier = math.random(0, highestTier)
        
        for x = 1, numCols do

            -- if skipping is turned on and we're on a skip iteration...
            if skipPattern and skipFlag then
                -- turn skipping off for the next iteration
                skipFlag = not skipFlag

                -- Lua doesn't have a continue statement, so this is the workaround
                goto continue
            else
                -- flip the flag to true on an iteration we don't use it
                skipFlag = not skipFlag
            end

            local b = Brick(
                (x-1) 
                * 34 
                + 29
                + (11 - numCols) * 17,
                y * 17 + 8
            )

            -- if we're alternating, figure out which color/tier we're on
            if alternatePattern and alternateFlag then
                b.color = alternateColor1
                b.tier = alternateTier1
                alternateFlag = not alternateFlag
            else
                b.color = alternateColor2
                b.tier = alternateTier2
                alternateFlag = not alternateFlag
            end

            -- if not alternating and we made it here, use the solid color/tier
            if not alternatePattern then
                b.color = solidColor
                b.tier = solidTier
            end 

            table.insert(bricks, b)

            ::continue::
        end
    end

    if #bricks == 0 then
        return self.createMap(level)
    else
        return bricks
    end
end
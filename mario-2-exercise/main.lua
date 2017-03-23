--[[
    Super Mario Bros. Demo
    Author: Colton Ogden
    Original Credit: Nintendo

    Demonstrates constant scrolling of a screen of tiles and placing tiles
    in a sprite batch.
]]

push = require 'push'

require 'Map'

-- close resolution to NES but 16:9
virtualWidth = 432
virtualHeight = 243

-- actual window resolution
windowWidth = 1280
windowHeight = 720

-- a speed to multiply delta time to scroll map; smooth value
local scrollSpeed = 62

-- an object to contain our map data
map = Map:create()

-- performs initialization of all objects and data needed by program
function love.load()
    -- makes upscaling look pixel-y instead of blurry
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- sets up a different, better-looking retro font as our default
    love.graphics.setFont(love.graphics.newFont('fonts/font.ttf', 8))

    -- sets up virtual screen resolution for an authentic retro feel
    push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
        fullscreen = false,
        resizable = true
    })
end

-- called whenever window is resized
function love.resize(w, h)
    push:resize(w, h)
end

-- called whenever a key is pressed
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
    -- TODO: update our map
    -- HINT: check Map.lua?

end

-- called each frame, used to render to the screen
function love.draw()
    -- begin virtual resolution drawing
    push:apply('start')

    -- clear screen using Mario background blue
    love.graphics.clear(108, 140, 255, 255)

    -- renders our map object onto the screen
    -- TODO: translate our coordinate system so we can simulate camera behavior
    -- HINT: love.graphics.translate?
    -- HINT: though our camera offsets in map should be positive, should they be
    -- positive when translating?
    -- HINT: notice anything graphically strange when offsetting by floating-point values?
    -- maybe see math.floor in Lua's standard library?

    map:render()

    -- end virtual resolution
    push:apply('end')
end

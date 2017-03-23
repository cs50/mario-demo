--[[
    Represents our player in the game, with its own sprite.
]]

Player = {}
Player.__index = Player

-- determines sprite flipping
direction = 'right'

function Player:create(map)
    local this = {
        x = 0,
        y = 0,
        width = 16,
        height = 32,

        -- offset from top left to center to support sprite flipping
        xOffset = 8,
        yOffset = 16,

        -- reference to map for checking tiles
        map = map,
        texture = love.graphics.newImage('graphics/mario1.png'),

        -- animation frames
        frames = {},

        -- current animation frame
        currentFrame = nil,

        -- used to determine behavior and animations
        state = 'idle',

        -- x and y velocity
        dx = 0,
        dy = 0
    }

    -- position on top of map tiles
    this.y = map.tileHeight * ((map.mapHeight - 2) / 2) - this.height
    this.x = map.tileWidth * 10

    this.frames = {
        -- first frame in the sheet, idle pose
        -- TODO: construct Mario's first idle frame
        -- HINT: love.graphics.newQuad
        -- HINT: Mario's size is 16 pixels wide by 32 pixels tall

    }

    this.currentFrame = this.frames[1]

    -- behavior map we can call based on player state
    this.behaviors = {
        ['idle'] = function(dt)
            -- basic sprite flipping example
            -- TODO: set direction depending on which key we've pressed
            -- HINT: direction can be either 'left' or 'right'
            -- HINT: love.keyboard.wasPressed, which we've defined ourselves in
            -- main.lua

        end
    }

    setmetatable(this, self)
    return this
end

function Player:update(dt)
    -- TODO: call our behavior function depending on our current state
    -- HINT: self.behaviors should have all possible behaviors
    -- HINT: our state should act as a key
    -- HINT: the behavior itself is a function... so let's call it like one?

end

function Player:render()
    local scaleX

    -- set negative x scale factor if facing left, which will flip the sprite
    -- when applied
    -- TODO: set our horizontal scale depending on which direction he's facing
    -- HINT: a positive scale of 1 means he'll be facing to the right


    -- draw sprite with scale factor and offsets
    love.graphics.draw(self.texture, self.currentFrame, self.x + self.xOffset,
        self.y + self.yOffset, 0, scaleX, 1, self.xOffset, self.yOffset)
end

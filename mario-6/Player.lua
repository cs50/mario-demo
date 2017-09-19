--[[
    Represents our player in the game, with its own sprite.
]]

Player = {}
Player.__index = Player

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

        -- determines sprite flipping
        direction = 'right',

        -- x and y velocity
        dx = 0,
        dy = 0
    }

    -- position on top of map tiles
    this.y = map.tileHeight * ((map.mapHeight - 2) / 2) - this.height
    this.x = map.tileWidth * 10

    this.frames = {
        -- first frame in the sheet, idle pose
        love.graphics.newQuad(0, 0, 16, 32, this.texture:getDimensions())
    }

    this.currentFrame = this.frames[1]

    -- behavior map we can call based on player state
    this.behaviors = {
        ['idle'] = function(dt)
            -- basic sprite flipping example
            if love.keyboard.isDown('left') then
                direction = 'left'
                this.dx = -80
            elseif love.keyboard.isDown('right') then
                direction = 'right'
                this.dx = 80
            else
                this.dx = 0
            end
        end
    }

    setmetatable(this, self)
    return this
end

function Player:update(dt)
    self.behaviors[self.state](dt)

    -- new X calculation on velocity
    self.x = self.x + self.dx * dt
end

function Player:render()
    local scaleX

    -- set negative x scale factor if facing left, which will flip the sprite
    -- when applied
    if direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end

    -- draw sprite with scale factor and offsets
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x + self.xOffset),
        math.floor(self.y + self.yOffset), 0, scaleX, 1, self.xOffset, self.yOffset)
end

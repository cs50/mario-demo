--[[
    Represents our player in the game, with its own sprite.
]]

require 'Animation'

Player = {}
Player.__index = Player

local WALKING_SPEED = 140
local JUMP_VELOCITY = 400

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

        -- current animation frame
        currentFrame = nil,

        -- current animation being updated
        animation = nil,

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

    -- initialize all player animations
    this.animations = {
        ['idle'] = Animation:create({
            texture = this.texture,
            frames = {
                love.graphics.newQuad(0, 0, 16, 32, this.texture:getDimensions())
            }
        }),
        ['walking'] = Animation:create({
            texture = this.texture,
            frames = {
                love.graphics.newQuad(18, 0, 16, 32, this.texture:getDimensions()),
                love.graphics.newQuad(34, 0, 16, 32, this.texture:getDimensions()),
                love.graphics.newQuad(50, 0, 16, 32, this.texture:getDimensions()),
                love.graphics.newQuad(34, 0, 16, 32, this.texture:getDimensions()),
            },
            interval = 0.07
        }),
        ['jumping'] = Animation:create({
            texture = this.texture,
            frames = {
                love.graphics.newQuad(88, 0, 16, 32, this.texture:getDimensions())
            }
        })
    }

    -- initialize animation and current frame we should render
    this.animation = this.animations['idle']
    this.currentFrame = this.animation:getCurrentFrame()

    -- behavior map we can call based on player state
    this.behaviors = {
        ['idle'] = function(dt)
            -- begin moving if left or right is pressed
            if love.keyboard.wasPressed('space') then
                this.dy = -JUMP_VELOCITY
                this.state = 'jumping'
                this.animation = this.animations['jumping']
            elseif love.keyboard.isDown('left') then
                direction = 'left'
                this.dx = -WALKING_SPEED
                this.state = 'walking'
                this.animations['walking']:restart()
                this.animation = this.animations['walking']
            elseif love.keyboard.isDown('right') then
                this.direction = 'right'
                this.dx = WALKING_SPEED
                this.state = 'walking'
                this.animations['walking']:restart()
                this.animation = this.animations['walking']
            else
                this.dx = 0
            end
        end,
        ['walking'] = function(dt)
            -- keep track of input to switch movement while walking, or reset
            -- to idle if we're not moving
            if love.keyboard.wasPressed('space') then
                this.dy = -JUMP_VELOCITY
                this.state = 'jumping'
                this.animation = this.animations['jumping']
            elseif love.keyboard.isDown('left') then
                this.direction = 'left'
                this.dx = -WALKING_SPEED
            elseif love.keyboard.isDown('right') then
                this.direction = 'right'
                this.dx = WALKING_SPEED
            else
                this.dx = 0
                this.state = 'idle'
                this.animation = this.animations['idle']
            end

            -- check for collisions moving left and right
            this:checkRightCollision()
            this:checkLeftCollision()

            -- check if there's a tile directly beneath us
            if not this.map:collides(this.map:tileAt(this.x, this.y + this.height)) and
                not this.map:collides(this.map:tileAt(this.x + this.width - 1, this.y + this.height)) then
                -- if so, reset velocity and position and change state
                this.state = 'jumping'
                this.animation = this.animations['jumping']
            end
        end,
        ['jumping'] = function(dt)
            if love.keyboard.isDown('left') then
                this.direction = 'left'
                this.dx = -WALKING_SPEED
            elseif love.keyboard.isDown('right') then
                this.direction = 'right'
                this.dx = WALKING_SPEED
            end

            -- apply map's gravity before y velocity
            this.dy = this.dy + this.map.gravity

            -- check if there's a tile directly beneath us
            if this.map:collides(this.map:tileAt(this.x, this.y + this.height)) or
                this.map:collides(this.map:tileAt(this.x + this.width - 1, this.y + this.height)) then
                -- if so, reset velocity and position and change state
                this.dy = 0
                this.state = 'idle'
                this.animation = this.animations['idle']
                this.y = this.y - (this.y % this.map.tileHeight)
            end

            -- check for collisions moving left and right
            this:checkRightCollision()
            this:checkLeftCollision()
        end
    }

    setmetatable(this, self)
    return this
end

function Player:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.x = self.x + self.dx * dt

    -- if we have negative y velocity (jumping), check if we collide
    -- with any blocks above us
    if self.dy < 0 then
        if self.map:collides(self.map:tileAt(self.x, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y)) then
            -- reset y velocity
            self.dy = 0

            -- change block to different block
            if self.map:tileAt(self.x, self.y) == TILE_QUESTION then
                self.map:setTile(math.floor(self.x / self.map.tileWidth) + 1,
                    math.floor(self.y / self.map.tileHeight) + 1, TILE_QUESTION_DARK)
                self.map:refreshSpriteBatch()
            end
            if self.map:tileAt(self.x + self.width - 1, self.y) == TILE_QUESTION then
                self.map:setTile(math.floor((self.x + self.width - 1) / self.map.tileWidth) + 1,
                    math.floor(self.y / self.map.tileHeight) + 1, TILE_QUESTION_DARK)
                self.map:refreshSpriteBatch()
            end
        end
    end

    -- apply velocity
    self.y = self.y + self.dy * dt
end

-- checks two tiles to our left to see if a collision occurred
function Player:checkLeftCollision()
    if self.dx < 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
            self.map:collides(self.map:tileAt(self.x - 1, self.y + self.height - 1)) then
            -- if so, reset velocity and position and change state
            self.dx = 0
            local xmod = (self.x - 1) % self.map.tileWidth
            local offset = self.map.tileWidth - xmod
            self.x = math.floor(self.x - 1 + offset)
        end
    end
end

-- checks two tiles to our right to see if a collision occurred
function Player:checkRightCollision()
    if self.dx > 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width, self.y + self.height - 1)) then
            -- if so, reset velocity and position and change state
            self.dx = 0
            self.x = math.floor(self.x - (self.x % self.map.tileWidth))
        end
    end
end

function Player:render()
    local scaleX

    -- set negative x scale factor if facing left, which will flip the sprite
    -- when applied
    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end

    -- draw sprite with scale factor and offsets
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x + self.xOffset),
        math.floor(self.y + self.yOffset), 0, scaleX, 1, self.xOffset, self.yOffset)
end

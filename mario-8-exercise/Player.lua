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
        -- TODO: add a jumping animation for Mario
        -- HINT: it will just be one frame, though note the frame starts at X: 88!

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
                direction = 'right'
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
                direction = 'left'
                this.dx = -WALKING_SPEED
            elseif love.keyboard.isDown('right') then
                direction = 'right'
                this.dx = WALKING_SPEED
            else
                this.dx = 0
                this.state = 'idle'
                this.animation = this.animations['idle']
            end
        end,
        ['jumping'] = function(dt)
            if love.keyboard.isDown('left') then
                direction = 'left'
                this.dx = -WALKING_SPEED
            elseif love.keyboard.isDown('right') then
                direction = 'right'
                this.dx = WALKING_SPEED
            end

            -- TODO: apply map's gravity to y velocity
            -- HINT: gravity is defined in Map.lua!


            if this.y == this.map.tileHeight *
                ((this.map.mapHeight - 2) / 2) - this.height then
                -- TODO: reset Mario to idle animation and state
                -- HINT: be sure to also set his Y velocity so he stops falling!

            end
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

    -- TODO: apply velocity and prevent going beneath tiles
    -- HINT: math.min is your friend; don't let him go below map height / 2!
    -- HINT: don't forget to subtract 1 from map height since things are drawn
    -- 0-based!
    -- also, don't forget to subtract his height, or he'll be below the ground!

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

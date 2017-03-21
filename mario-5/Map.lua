--[[
    Contains tile data and necessary code for rendering a tile map to the
    screen.
]]

require 'Util'

-- object-oriented boilerplate; establish Map's "prototype"
Map = {}
Map.__index = Map

TILE_BRICK = 1
TILE_EMPTY = 29
TILE_QUESTION = 25

-- pipe tiles
PIPE_TOP_LEFT = 265
PIPE_TOP_RIGHT = 266
PIPE_BOTTOM_LEFT = 298
PIPE_BOTTOM_RIGHT = 299

-- cloud tiles
CLOUD_TOP_LEFT = 661
CLOUD_TOP_MIDDLE = 662
CLOUD_TOP_RIGHT = 663
CLOUD_BOTTOM_LEFT = 694
CLOUD_BOTTOM_MIDDLE = 695
CLOUD_BOTTOM_RIGHT = 696

-- bush tiles
BUSH_LEFT = 309
BUSH_MIDDLE = 310
BUSH_RIGHT = 311

-- a speed to multiply delta time to scroll map; smooth value
local scrollSpeed = 124

-- constructor for our map object
function Map:create()
    local this = {
        -- our texture containing all sprites
        spritesheet = love.graphics.newImage('graphics/tiles.png'),
        tileWidth = 16,
        tileHeight = 16,
        mapWidth = 100,
        mapHeight = 28,
        tiles = {},

        -- camera offsets
        camX = 0,
        camY = -3,
    }

    -- associate player with map
    this.player = Player:create(this)

    -- generate a quad (individual frame/sprite) for each tile
    this.tileSprites = generateQuads(this.spritesheet, 16, 16)

    -- cache width and height of map in pixels
    this.mapWidthPixels = this.mapWidth * this.tileWidth
    this.mapHeightPixels = this.mapHeight * this.tileHeight

    -- sprite batch for efficient tile rendering
    this.spriteBatch = love.graphics.newSpriteBatch(this.spritesheet, this.mapWidth *
        this.mapHeight)

    -- more OO boilerplate so we have access to class functions
    setmetatable(this, self)

    -- first, fill map with empty tiles
    for y = 1, this.mapHeight do
        for x = 1, this.mapWidth do
            this:setTile(x, y, TILE_EMPTY)
        end
    end

    -- begin generating the terrain using vertical scan lines
    local x = 1
    while x < this.mapWidth do
        -- 2% chance to generate a cloud
        -- make sure we're 3 tiles from edge at least
        if x < this.mapWidth - 3 then
            if math.random(20) == 1 then
                -- choose a random vertical spot above where blocks/pipes generate
                local cloudStart = math.random(this.mapHeight / 2 - 6)

                this:setTile(x, cloudStart, CLOUD_TOP_LEFT)
                this:setTile(x, cloudStart + 1, CLOUD_BOTTOM_LEFT)
                this:setTile(x + 1, cloudStart, CLOUD_TOP_MIDDLE)
                this:setTile(x + 1, cloudStart + 1, CLOUD_BOTTOM_MIDDLE)
                this:setTile(x + 2, cloudStart, CLOUD_TOP_RIGHT)
                this:setTile(x + 2, cloudStart + 1, CLOUD_BOTTOM_RIGHT)
            end
        end

        -- 5% chance to generate a pipe
        if math.random(20) == 1 then
            -- left side of pipe
            this:setTile(x, this.mapHeight / 2 - 2, PIPE_TOP_LEFT)
            this:setTile(x, this.mapHeight / 2 - 1, PIPE_BOTTOM_LEFT)

            -- creates column of tiles going to bottom of map
            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end

            -- next vertical scan line
            x = x + 1

            -- right side of pipe
            this:setTile(x, this.mapHeight / 2 - 2, PIPE_TOP_RIGHT)
            this:setTile(x, this.mapHeight / 2 - 1, PIPE_BOTTOM_RIGHT)

            -- creates column of tiles going to bottom of map
            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end

            -- next vertical scan line
            x = x + 1

        -- 10% chance to generate bush, being sure to generate away from edge
        elseif math.random(10) == 1 and x < this.mapWidth - 3 then
            local bushLevel = this.mapHeight / 2 - 1

            -- place bush component and then column of bricks
            this:setTile(x, bushLevel, BUSH_LEFT)
            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end
            x = x + 1

            this:setTile(x, bushLevel, BUSH_MIDDLE)
            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end
            x = x + 1

            this:setTile(x, bushLevel, BUSH_RIGHT)
            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end
            x = x + 1

        -- 10% chance to not generate anything, creating a gap
        elseif math.random(10) ~= 1 then
            -- creates column of tiles going to bottom of map
            for y = this.mapHeight / 2, this.mapHeight do
                this:setTile(x, y, TILE_BRICK)
            end

            -- chance to create a block for Mario to hit
            if math.random(15) == 1 then
                this:setTile(x, this.mapHeight / 2 - 4, TILE_QUESTION)
            end

            -- next vertical scan line
            x = x + 1
        else
            -- increment X so we skip two scanlines, creating a 2-tile gap
            x = x + 2
        end
    end

    -- create sprite batch from tile quads
    for y = 1, this.mapHeight do
        for x = 1, this.mapWidth do
            this.spriteBatch:add(this.tileSprites[this:getTile(x, y)],
                (x - 1) * this.tileWidth, (y - 1) * this.tileHeight)
        end
    end

    return this
end

-- function to update camera offset based on player coordinates
function Map:update(dt)
    self.player:update(dt)

    -- keep camera's X coordinate following the player, preventing camera from
    -- scrolling past 0 to the left and the map's width
    self.camX = math.max(0, math.min(self.player.x - virtualWidth / 2,
        math.min(self.mapWidthPixels - virtualWidth, self.player.x)))
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, tile)
    self.tiles[(y - 1) * self.mapWidth + x] = tile
end

-- renders our map to the screen, to be called by main's render
function Map:render()
    -- replace tile-by-tile rendering with spriteBatch draw call
    love.graphics.draw(self.spriteBatch)
    self.player:render()
end

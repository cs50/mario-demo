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

-- a speed to multiply delta time to scroll map; smooth value
local scrollSpeed = 62

-- constructor for our map object
function Map:create()
    local this = {
        -- our texture containing all sprites
        spritesheet = love.graphics.newImage('graphics/tiles.png'),
        tileWidth = 16,
        tileHeight = 16,
        mapWidth = 30,
        mapHeight = 28,
        tiles = {},

        -- camera offsets
        camX = 0,
        camY = -3
    }

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

    -- -- fill bottom half of map with tiles
    for y = this.mapHeight / 2, this.mapHeight do
        for x = 1, this.mapWidth do
            this:setTile(x, y, TILE_BRICK)
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

-- function to update camera offset with delta time
function Map:update(dt)
    self.camX = self.camX + dt * scrollSpeed
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
end

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

-- constructor for our map object
function Map:create()
    local this = {
        -- our texture containing all sprites
        spritesheet = love.graphics.newImage('graphics/tiles.png'),
        tileWidth = 16,
        tileHeight = 16,
        mapWidth = 30,
        mapHeight = 28,
        tiles = {}
    }

    -- generate a quad (individual frame/sprite) for each tile
    this.tileSprites = generateQuads(this.spritesheet, 16, 16)

    -- more OO boilerplate so we have access to class functions
    setmetatable(this, self)

    -- first, fill map with empty tiles
    for y = 1, this.mapHeight do
        for x = 1, this.mapWidth do
            this:setTile(x, y, TILE_EMPTY)
        end
    end

    -- fill bottom half of map with tiles
    for y = this.mapHeight / 2, this.mapHeight do
        for x = 1, this.mapWidth do
            this:setTile(x, y, TILE_BRICK)
        end
    end

    return this
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
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            love.graphics.draw(self.spritesheet, self.tileSprites[self:getTile(x, y)],
                (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
        end
    end
end

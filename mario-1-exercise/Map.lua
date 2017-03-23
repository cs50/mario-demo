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

    -- cache width and height of map in pixels
    this.mapWidthPixels = this.mapWidth * this.tileWidth
    this.mapHeightPixels = this.mapHeight * this.tileHeight

    -- more OO boilerplate so we have access to class functions
    setmetatable(this, self)

    -- first, fill map with empty tiles
    for y = 1, this.mapHeight do
        for x = 1, this.mapWidth do
            -- TODO: set that tile to be our empty tile defined above
            -- HINT: maybe this file has a function for setting tiles?

        end
    end

    -- -- fill bottom half of map with tiles
    for y = this.mapHeight / 2, this.mapHeight do
        for x = 1, this.mapWidth do
            -- TODO: set that tile to be our brick tile defined above
            -- HINT: maybe this file has a function for setting tiles?

        end
    end

    return this
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y)
    -- TODO: return the tile ID at a given X, Y coordinate
    -- HINT: maybe we already have a structure defined in our class for holding tiles?
    -- HINT: if this structure is a 1-dimensional "array" of sorts, how can we
    -- compute its index given an X and a Y value? maybe by multiplying the map
    -- width by some value?

end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, tile)
    -- TODO: assign a tile ID at a given X, Y coordinate in this class
    -- HINT: we should already have a structure for holding the IDs
    -- HINT: just like getTile, how can we calculate the index given an X and
    -- Y value? seems like mapWidth is the key here....

end

-- renders our map to the screen, to be called by main's render
function Map:render()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            -- TODO: draw to the screen the tile at X, Y
            -- HINT: love.graphics.draw has a variant that takes in a quad; we'll
            -- probably need this to get a specific tile out of our spritesheet
            -- HINT: maybe we can use getTile once implemented?
            -- HINT: though Lua tables are 1-indexed, drawing in LÖVE still starts
            -- at 0, 0!

        end
    end
end

--[[
    Holds a collection of frames that switch depending on how much time has
    passed.
]]

Animation = {}
Animation.__index = Animation

function Animation:create(params)
    local this = {
        texture = params.texture,

        -- quads defining this animation
        frames = params.frames or {},

        -- time in seconds each frame takes (1/20 by default)
        interval = params.interval or 0.05,

        -- stores amount of time that has elapsed
        timer = 0,

        currentFrame = 1
    }

    setmetatable(this, self)
    return this
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end

function Animation:restart()
    self.timer = 0
    self.currentFrame = 1
end

function Animation:update(dt)
    self.timer = self.timer + dt

    -- iteratively subtract interval from timer to proceed in the animation,
    -- in case we skipped more than one frame

    -- TODO: update our current frame number based on dt
    -- HINT: we should increment our frame by 1 for every interval passed,
    -- but be mindful of exceeding the total # of frames! maybe % and the
    -- # table operator in Lua will come in handy?
    -- HINT: we will need some kind of a while loop to take into account the
    -- subtraction of interval from timer, but don't forget to actually subtract
    -- the interval from the timer so this loop eventually terminates!
    
end

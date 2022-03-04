Door = GameObject:extend()
local open_time = 3

function Door:new()
    self.super.new(self, 0, gameHeight-108, 64, 108, images.door)
    self.open = 0
end

function Door:update(dt)
    if self.open>0 then
        self.open = self.open-dt
    end
end

function Door:ordered()
    if self.open<=0 then
        self.frame = love.math.random(3, 5)
    end
    self.open = open_time
    sounds.order:play()
end

function Door:draw(earthquake)
    local dx, dy = 0, 0
    if earthquake then
        dx = love.math.random(-3, 0)
        dy = love.math.random(-2, 2)
    end
    local frame
    if self.open>0 then
        frame = self.frame
    else
        frame = 1
    end

    self.super.draw(self, false, dx, dy, frame)
end
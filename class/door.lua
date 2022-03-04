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

function Door:draw()
    local frame
    if self.open>0 then
        frame = self.frame
    else
        frame = 1
    end

    self.super.draw(self, false, 0, 0, frame)
end
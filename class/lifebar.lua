Lifebar = GameObject:extend()
local lifewidth = 96
local lifeheight = 16


function Lifebar:new()
    self.super.new(self, 0, 1, lifewidth, lifeheight, images.lifebar)
    self.mainFrame = love.graphics.newQuad(0, 0, self.width, self.height, self.img:getWidth(), self.img:getHeight())
end

function Lifebar:draw(happiness, low_happiness, high_happiness, life, maxlife)
    love.graphics.draw(self.img, self.mainFrame, self.x, self.y)
    local frame
    if happiness < self.happiness<low_happiness+game.time*inc_ratio then
        frame = 1
    elseif happiness < self.happiness<high_happiness+2*game.time*inc_ratio then
        frame = 2
    else
        frame = 3
    end
    local nowwidth = 8+math.floor((lifewidth-16)*life/maxlife)
    love.graphics.draw(self.img, love.graphics.newQuad(0, lifeheight*frame, nowwidth, lifeheight, self.img:getWidth(), self.img:getHeight()), self.x, self.y)
end
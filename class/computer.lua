Computer = GameObject:extend()

function Computer:new(x, y, width, height)
    self.super.new(self, x, y, width, height)
    self.state = "work"
    self.work = Work(self.x + 5, self.y + 5 , self.width-10, self.height-15)
    self.shop = Shop(self.x + 5, self.y + 5 , self.width-10, self.height-15)
    self.workIcon = GameObject(self.x+18, self.y+self.height-20, 40, 8)
    self.shopIcon = GameObject(self.x+18+42, self.y+self.height-20, 40, 8)
end

function Computer:keypressed(key)
    if self.state == "work" then
        self.work:keypressed(key)
    end
end

function Computer:mousepressed(x, y)
    if self.shopIcon:isPointInside(x, y) then
        self.state="shop"
    elseif self.workIcon:isPointInside(x, y) then
        self.state="work"
    elseif self.state == "shop" then
        self.shop:mousepressed(x, y)
    end
end

function Computer:draw(earthquake)
    local dx, dy = 0, 0
    if earthquake then
        dx = dx + love.math.random(0, 3)
        dy = dy + love.math.random(0, 3)
    end

    self.super.draw(self, false, 0.2, 0.2, 0.2, dx, dy)
    if self.state == "work"then
        self.work:draw(dx, dy)
    else
        self.shop:draw(dx, dy)
    end
    self.workIcon:draw(false, 1, 1, 1, dx, dy)
    self.shopIcon:draw(false, 1, 1, 1, dx, dy)
end
Computer = GameObject:extend()

function Computer:new(x, y, width, height)
    self.super.new(self, x, y, width, height, images.computer)
    self.state = "work"
    self.work = Work(self.x + 9, self.y + 10 , 178, 90)
    self.shop = Shop(self.x + 9, self.y + 10 , 178, 90)
    self.workIcon = Item(self.x+18, self.y+92, 24, 8)
    self.shopIcon = Item(self.x+43, self.y+92, 38, 8)
    self.mouse = GameObject(self.x+8, self.y+9, 8, 8, images.mouse)
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

function Computer:update(mouseX, mouseY)
    if self.work:isPointInside(mouseX, mouseY) then
        self.mouse.x = mouseX-1
        self.mouse.y = mouseY-1
    end
end

function Computer:draw(earthquake)
    local dx, dy = 0, 0
    if earthquake then
        dx = dx + love.math.random(0, 3)
        dy = dy + love.math.random(0, 3)
    end

    --self.super.draw(self, false, 0.2, 0.2, 0.2, dx, dy)
    if self.state == "work"then
        frame = 1
        self.work:draw(dx, dy)
    else
        self.shop:draw(dx, dy)
    end
    --self.workIcon:draw(false, dx, dy)
    --self.shopIcon:draw(false, dx, dy)
    self.mouse:draw(false, dx, dy)
    self.super.draw(self, false, dx, dy)
end
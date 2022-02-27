Item = Object:extend()

function Item:new(x, y, width, height, price, happiness, instability, img, sound)
    self.x = x
    self.y = y
    self.width = width
    self. height = height
    self.happiness = happiness
    self.total_instability = instability
    self.instability = 0
    self.img = img
    self.sound = sound
    self.angle = 0
    self.gravity = 0
    self.price = price
end

function Item:update(dt, earthquake)
    if earthquake then
        self.instability = self.instability + dt
    end

    if self.instability >= self.total_instability then
        self.angle = self.angle + dt
        self.gravity = self.gravity + dt*100
        self.y = self.y + self.gravity*dt
    end
end

function Item:isDropped()
    return self.gravity>0 and self.y > gameHeight
end

function Item:canBePlaced()
    local colliding = false
    for index, item in ipairs(game.placed) do
        colliding = colliding or self:collide(item)
    end
    colliding = colliding or self:collide(game.computer)
    if colliding then
        return nil
    else
        return {x = self.x , y = self.y}
    end

end

function Item:place(canBePlaced, x, y)
    if x then self.x = x end
    if y then self.y = y end
    if canBePlaced then
        self.angle = 0
        self.instability = 0
    else
        self.instability = self.total_instability+1
    end
    self.gravity = 0
end

function Item:drawProjection(proj)
    local x, y
    if proj then
        love.graphics.setColor(0, 1, 0, 0.5)
        x, y = proj.x, proj.y
    else
        love.graphics.setColor(0, 1, 0, 0.5)
        x, y = self.x, self.y
    end
    love.graphics.rectangle("line", x, y, self.width, self.height)
end

-- function Item:draw(earthquake, dx, dy)
--     self.super.draw(self, earthquake and self.gravity==0 , 1, 0, 1, dx, dy)
-- end
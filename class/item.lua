Item = Object:extend()
Item:implement(GameObject)

function Item:new(width, height, price, happiness, instability, frame, sound)
    self.x = 0
    self.y = 0
    self.width = width
    self.height = height
    self.happiness = happiness
    self.total_instability = instability
    self.instability = 0
    self.frame = frame
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
    local drop = self.gravity>0 and self.y > gameHeight
    if drop then
        self.sound:play()
    end
    return drop
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
    if proj then
        love.graphics.setColor(0.4, 1, 0.3, 0.7)
    else
        love.graphics.setColor(1, 0.4, 0.3, 0.7)
    end
    self:draw()
    love.graphics.setColor(1, 1, 1)
end

-- function Item:draw(earthquake, dx, dy)
--     --self.super.draw(self, earthquake and self.gravity==0 , 1, 0, 1, dx, dy)
--     local x, y = self.x, self.y
--     if earthquake then
--         x = x + love.math.random(0, 3)
--         y = y + love.math.random(0, 3)
--     end
--     if dx and dy then
--         x = x + dx
--         y = y + dy
--     end
--     love.graphics.rectangle("line", x, y, self.width, self.height)
-- end
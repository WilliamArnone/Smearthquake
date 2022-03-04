Item = GameObject:extend()

function Item:new(x, y, width, height, img, frame, price, happiness, instability, sound)
    GameObject.new(self, x, y, width, height, img, frame, price, happiness, instability, sound)
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
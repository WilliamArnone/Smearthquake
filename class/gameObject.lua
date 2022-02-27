GameObject = Object:extend()

function GameObject:new(x, y, width, height)
    self.width = width
    self.height = height
    self.x = x
    self.y = y
end

function GameObject:isPointInside(x, y)
    return x > self.x and x < self.x+self.width and y > self.y and y < self.y+self.height
end

function GameObject:collide(obj)
    return self.x + self.width > obj.x and
        obj.x + obj.width > self.x and
        self.y + self.height > obj.y and
        obj.y + obj.height > self.y
end

function GameObject:draw(earthquake, r, g, b, dx, dy)
    local x, y = self.x, self.y
    if earthquake then
        x = x + love.math.random(0, 3)
        y = y + love.math.random(0, 3)
    end
    if dx and dy then
        x = x + dx
        y = y + dy
    end

    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("line", x, y, self.width, self.height)
end
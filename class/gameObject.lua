GameObject = Object:extend()

function GameObject:new(x, y, width, height, img, frame, price, happiness, instability, sound)
    self.width = width
    self.height = height
    self.img = img
    self.x = x
    self.y = y
    self.happiness = happiness
    self.total_instability = instability
    self.instability = 0
    self.frame = frame
    self.sound = sound
    self.angle = 0
    self.gravity = 0
    self.price = price
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

function GameObject:draw(earthquake, dx, dy, angle, sx, sy)
    local x, y = self.x, self.y
    if earthquake then
        x = x + love.math.random(-2, 2)
        y = y + love.math.random(-2, 2)
    end
    if dx and dy then
        x = x + dx
        y = y + dy
    end

    --love.graphics.setColor(r, g, b)
    --love.graphics.rectangle("line", x, y, self.width, self.height)
    if not self.img then
        love.graphics.rectangle("line", x, y, self.width, self.height)
    else
        if self.frame then
            if self.frame then
                frame = self.frame
            end
            love.graphics.draw(self.img.image, self.img.frames[frame], x, y, angle, sx, sy)
        else
            love.graphics.draw(self.img, x, y, angle, sx, sy)
        end
    end

end
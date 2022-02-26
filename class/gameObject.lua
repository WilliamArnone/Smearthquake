GameObject = Object:extend()

function GameObject:new(width, height, happiness, instability)
    self.width = width
    self.height = height
    self.happiness = happiness
    self.instability = instability
    self.isNew = true
    self.isPlaced = true
    self.x = 0
    self.y = 0
    
end

function GameObject:place(x, y)
    self.x = x
    self.y = y
    self.isPlaced = true
end

function GameObject:startDrag()
    self.isNew = false
    self.isPlaced = true
end
function GameObject:endDrag()
    self.isPlaced = false
end

function GameObject:update(dt, x, y)
    if not self.isPlaced then
        self.x, self.y = x, y
    end
end

function GameObject:draw(earthquake)
    local x, y = self.x, self.y
    if earthquake then
        x = x + love.math.random(0, 5)
        y = y + love.math.random(0, 5)
    end
    if self.isNew then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(0, 1, 0)
    end
        love.graphics.rectangle("line", x, y, self.width, self.height)
end
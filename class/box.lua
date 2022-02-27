Box = GameObject:extend()

function Box:new(x, y, item)
    self.super.new(self, x, y, 32, 32)
    self.item = item
end

function Box:draw(earthquake)
    self.super.draw(self, earthquake, 1, 1, 1)
end
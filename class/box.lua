Box = GameObject:extend()

function Box:new(x, y, item, frame)
    self.super.new(self, x, y, 32, 32, images.box)
    self.frame = frame
    self.item = item
    self.isopen = false
    self.timer = 2
end

function Box:update(dt)
    if self.isopen then
        self.timer = self.timer-dt
    end
    return self.timer<=0
end

function Box:open()
    self.isopen = true
    self.frame = self.frame+1
end

function Box:draw(earthquake)
    self.super.draw(self, earthquake, false, false, self.frame)
end
Hand = GameObject:extend()
local speed =  6

function Hand:new(isRight)
    if isRight then
        self.xdir = 1
    else
        self.xdir = -1
    end
    self.origin = {x = gameWidth/2+30*self.xdir, y = gameHeight-16}

    self.super.new(self, self.origin.x, self.origin.y, 32, 32, images.hands)
end


function Hand:update(dt, mouseX, mouseY)
    self.locked = false
    local target
    if (not game.computer.work:isPointInside(mouseX, mouseY)) and lume.sign(mouseX - gameWidth/2) == lume.sign(self.xdir) then
        self.locked = true
        target = {x = mouseX-16*self.xdir, y = mouseY-16}
    else
        target = self.origin
    end
    local norm = lume.distance(self.x, self.y, target.x, target.y)
    self.x = self.x+(target.x-self.x)/2
    self.y = self.y+(target.y-self.y)/2
end

function Hand:draw(earthquake)

    local x, y = self.x, self.y

    self.super.draw(self, earthquake and not self.locked, 0, 0, 1, 0, self.xdir, 1)
end
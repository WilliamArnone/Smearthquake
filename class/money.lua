Money = GameObject:extend()

function Money:new(value, color)
    self.super.new(self, 10, 20)
    self.targety = 40
    self.timer = 2
    self.value = value
    self.color = color
    sounds.money:play()
    if color == "red" then
        game.moneyspent = game.moneyspent + value
    end
end

function Money:update(dt)
    local dist = (self.y-self.targety)
    local step = dist*dt*2
    if math.abs(step)>math.abs(dist) then
        dist = step
    end
    if math.abs(dist) < 1 then
        self.y = self.targety
        step = 0
    end
    self.y = self.y - step
    self.timer = self.timer-dt
    if self.timer<=0 then
        game.moneyanim = nil
    end
end

function Money:draw()
    Print("$"..self.value, self.x, self.y, "number", self.color)
end
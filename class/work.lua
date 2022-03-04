Work = GameObject:extend()

function Work:new(x, y, width, height)
    self.super.new(self, x, y, width, height, images.work)
    self.word = randomWord()
    self.charindex = 0
end

function Work:keypressed(key)
    if key == string.sub(self.word, self.charindex+1, self.charindex+1) then
        self.charindex = self.charindex+1
    end
    if self.charindex>=string.len(self.word) then
        game.money = game.money + #self.word
        self.word = randomWord()
        self.charindex = 0
        game.moneyanim = Money(#self.word, "darkgreen")
    end
end

function Work:draw(dx, dy)
    self.super.draw(self, false, dx, dy)
    --love.graphics.setColor(1, 1, 1)
    Print(self.word, self.x + 5 + dx, self.y + 48 + dy, "type")
    if self.charindex>0 then
        Print(string.sub(self.word, 1, self.charindex), self.x + 5 + dx, self.y + 48 + dy, "type", "green")
    end

end
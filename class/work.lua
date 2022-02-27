Work = GameObject:extend()

function Work:new(x, y, width, height)
    self.super.new(self, x, y, width, height)
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
    end
end

function Work:draw(dx, dy)
    self.super.draw(self, false, 0.6, 0.6, 0.6, dx, dy)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.word, self.x + 5 + dx, self.y + 32 + dy)
    if self.charindex>0 then
        love.graphics.setColor(0, 1, 0)
        love.graphics.print(string.sub(self.word, 1, self.charindex), self.x + 5 + dx, self.y + 32 + dy)
    end

end
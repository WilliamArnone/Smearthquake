Shop = GameObject:extend()

function Shop:new(x, y, width, height)
    self.super.new(self, x, y, width, height)

    self.items = {randomDecoration(), randomDecoration(), randomPoster(), randomPoster()}
    self.buttons = {}

    for i = 1, 4 do
        table.insert(self.buttons, GameObject(self.x + (self.width-40*4)/2 + 40 * (i-1), self.y + 54, 32, 8))
    end

    for index, item in ipairs(self.items) do
        self:setOnUI(item, index)
    end
end

function Shop:mousepressed(x, y)
    for index, button in ipairs(self.buttons) do
        if button:isPointInside(x, y)then
            local item = self.items[index]
            if game.money >= item.price then
                game.money = game.money - item.price
                game:createBox(item)
                if index<3 then
                    self.items[index] = randomDecoration()
                else
                    self.items[index] = randomDecoration()
                end
                self:setOnUI(self.items[index], index)
            end
        end
    end
end

function Shop:setOnUI(item, index)
    item.x = self.x + (self.width-40*4)/2 + 40 * (index-1) + (32-item.width)/2
    item.y = self.y + 20 + (32-item.height)/2
end

function Shop:draw(dx, dy)
    self.super.draw(self, false, 0.6, 0.6, 0, dx, dy)
    --love.graphics.print("Shop", self.x + 5 + dx, self.y + 32 + dy)
    for index, item in ipairs(self.items) do
        item:draw(false, dx, dy)
        print(item.price, self.x + (self.width-33*4)/2 + 33 * (index-1) + (32-item.width)/2, self.y + 20)
    end
    for index, item in ipairs(self.buttons) do
        item:draw(false, 0, 1, 0, dx, dy)
    end
end
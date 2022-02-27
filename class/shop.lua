Shop = GameObject:extend()
local shelves_scale = 4

function Shop:new(x, y, width, height)
    self.super.new(self, x, y, width, height)

    self.items = {randomDecoration(), randomDecoration(), randomPoster(), randomPoster()}
    self.shelves = {Shelf(0, 0, 40/shelves_scale, 120),
        Shelf(0, 0, 70/shelves_scale, 200),
        Shelf(0, 0, 120/shelves_scale, 340),
        Shelf(0, 0, 150/shelves_scale, 400)
    }
    self.state = "amazon"
    self.amazonTab = GameObject(self.x+1, self.y+1, 10, 5)
    self.ikeaTab = GameObject(self.x+1+10, self.y+1, 10, 5)
    self.buttons = {}

    for i = 1, 4 do
        table.insert(self.buttons, GameObject(self.x + (self.width-40*4)/2 + 40 * (i-1), self.y + 58, 32, 8))
    end

    for index, item in ipairs(self.items) do
        self:setOnUI(item, index)
    end
    for index, item in ipairs(self.shelves) do
        self:setOnUI(item, index)
    end
end

function Shop:mousepressed(x, y)
    for index, button in ipairs(self.buttons) do
        if button:isPointInside(x, y)then
            local item
            if self.state == "amazon" then
                item = self.items[index]
            else
                item = self.shelves[index]
            end
            if game.money >= item.price then
                game.money = game.money - item.price
                if self.state == "amazon" then
                    game:createBox(item)
                    if index<3 then
                        self.items[index] = randomDecoration()
                    else
                        self.items[index] = randomPoster()
                    end
                    self:setOnUI(self.items[index], index)
                else
                    game:createBox(Shelf(0, 0, item.width*shelves_scale, 0))
                end
            end
        end
    end
    if self.amazonTab:isPointInside(x, y) then
        self.state = "amazon"
    elseif self.ikeaTab:isPointInside(x, y) then
        self.state = "ikea"
    end
end

function Shop:setOnUI(item, index)
    item.x = self.x + (self.width-40*4)/2 + 40 * (index-1) + (32-item.width)/2
    item.y = self.y + 10 + (32-item.height)/2
end

function Shop:draw(dx, dy)
    self.super.draw(self, false, 0.6, 0.6, 0, dx, dy)
    --love.graphics.print("Shop", self.x + 5 + dx, self.y + 32 + dy)
    self.amazonTab:draw(false, 1, 1, 1, dx, dy)
    self.ikeaTab:draw(false, 1, 1, 1, dx, dy)
    if self.state == "amazon" then
        for index, item in ipairs(self.items) do
            item:draw(false, 0.5, 0.5, 0.5, dx, dy)
            love.graphics.print('$'..item.price, self.x + (self.width-40*4)/2 + 40 * (index-1) + dx, self.y + 42 + dy)
        end
    else
        for index, item in ipairs(self.shelves) do
            item:draw(false, 0.5, 0.5, 0.5, dx, dy)
            love.graphics.print('$'..item.price, self.x + (self.width-40*4)/2 + 40 * (index-1) + dx, self.y + 42 + dy)
        end
    end
    for index, item in ipairs(self.buttons) do
        item:draw(false, 0, 1, 0, dx, dy)
    end
end
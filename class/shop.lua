Shop = GameObject:extend()
local shelves_scale = 4

function Shop:new(x, y, width, height)
    self.super.new(self, x, y, width, height, images.shop)

    self.items = {randomDecoration(), randomDecoration(), randomPoster(), randomPoster()}
    self.shelves = {Shelf(0, 0, 40/shelves_scale, 120),
        Shelf(0, 0, 70/shelves_scale, 200),
        Shelf(0, 0, 120/shelves_scale, 340),
        Shelf(0, 0, 150/shelves_scale, 400)
    }
    self.state = "amazon"
    self.amazonTab = Item(self.x+2, self.y+4, 59, 7)
    self.ikeaTab = Item(self.x+61, self.y+4, 39, 7)
    self.buttons = {}

    for i = 1, 4 do
        table.insert(self.buttons, GameObject(self.x + 11 + (10 + 32) * (i-1) , self.y + 68, 32, 6, images.buy))
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
    item.x = self.x + 11 + (10 + 32) * (index-1) + (32-item.width)/2
    item.y = self.y + 28 + (32-item.height)/2
end

function Shop:draw(dx, dy)
    --love.graphics.print("Shop", self.x + 5 + dx, self.y + 32 + dy)
    self.amazonTab:draw(false, dx, dy)
    self.ikeaTab:draw(false, dx, dy)
    local list
    if self.state == "amazon" then
        list = self.items
        self.super.draw(self, false, dx, dy, 1)
    else
        list = self.shelves
        self.super.draw(self, false, dx, dy, 2)
    end
    for index, item in ipairs(list) do
        item:draw(false, dx, dy)
        game:print('$'..item.price, self.x + 12 + (10 + 32) * (index-1) + dx, self.y + 61 + dy, "number", "black")
    end
    for index, gameobj in ipairs(self.buttons) do
        gameobj:draw(false, dx, dy)
        a=5
    end
end
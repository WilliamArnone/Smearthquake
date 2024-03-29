Shop = GameObject:extend()

function Shop:new(x, y, width, height)
    self.super.new(self, x, y, width, height, images.shop, 1)

    self.items = {randomDecoration(), randomDecoration(), randomPoster(), randomPoster()}
    self.shelves = {Shelf(12, 40, true, 1),
        Shelf(19, 60, true, 2),
        Shelf(28, 100, true, 3),
        Shelf(32, 160, true, 4)
    }
    self.state = "amazon"
    self.amazonTab = GameObject(self.x+1, self.y+3, 59, 7)
    self.ikeaTab = GameObject(self.x+60, self.y+3, 39, 7)
    self.buttons = {}

    for i = 1, 4 do
        table.insert(self.buttons, GameObject(self.x + 9 + (8 + 34) * (i-1) , self.y + 68, 34, 6, images.buy))
    end

    for index, item in ipairs(self.items) do
        self:setOnUI(item, index)
    end
    for index, item in ipairs(self.shelves) do
        item.img = images.shopshelf
        item.frame = index
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
                    game:createBox(item, 3)
                    if index<3 then
                        self.items[index] = randomDecoration()
                    else
                        self.items[index] = randomPoster()
                    end
                    self:setOnUI(self.items[index], index)
                else
                    game:createBox(Shelf(item.width*shelves_scale, item.price), 1)
                end
            end
        end
    end
    if self.amazonTab:isPointInside(x, y) then
        self.state = "amazon"
        self.frame = 1
    elseif self.ikeaTab:isPointInside(x, y) then
        self.state = "ikea"
        self.frame = 2
    end
end

function Shop:setOnUI(item, index)
    item.x = self.x + 8 + (8 + 34) * (index-1) + (34-item.width)/2
    item.y = self.y + 26 + (34-item.height)/2
end

function Shop:draw(dx, dy)
    --love.graphics.print("Shop", self.x + 5 + dx, self.y + 32 + dy)
    self.amazonTab:draw(false, dx, dy)
    self.ikeaTab:draw(false, dx, dy)
    local list
    if self.state == "amazon" then
        list = self.items
        self.super.draw(self, false, dx, dy)
    else
        list = self.shelves
    end
    self.super.draw(self, false, dx, dy)
    for index, item in ipairs(list) do
        item:draw(false, dx, dy)
        Print('$'..item.price, self.x + 11 + (8 + 34) * (index-1) + dx, self.y + 61 + dy, "number", "black")
    end
    for index, gameobj in ipairs(self.buttons) do
        gameobj:draw(false, dx, dy)
        a=5
    end
end
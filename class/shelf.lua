Shelf = Item:extend()

function Shelf:new(width, price, shop, frame)
    local img, frame = nil, nil
    if shop then
        img = images.shopshelf
        frame = frame
    end
    self.super.new(self, 0, 0, width, 7, img, frame, price, 0, 100, sounds.hard)
    self.items = {}
    self.shop = shop
end

function Shelf:add(item, x)
    local index = #self.items+1
    for i = 1, #self.items do
        if x<self.items[i].x then
            index = i
        end
    end
    item:place(true, x, self.y - item.height)
    table.insert(self.items, index, item)
end

function Shelf:availableX(item)
    local distance = 1000
    local obj = GameObject(item.x, self.y-item.height, item.width, item.height)
    if self:isPositionFree(obj) and self:xInside(item, obj.x) then return obj.x end

    if item.x < self.x then
        obj.x = self.x-item.width/2
    else
        obj.x = self.x+self.width-item.width/2
    end

    if self:isPositionFree(obj) then
        distance = math.abs(obj.x-item.x)
    else
        obj.x = nil
    end

    local xs = {}
    for index, value in ipairs(self.items) do
        table.insert(xs, {x = value.x, width = value.width})
    end

    for index, value in ipairs(xs) do
        local x = obj.x
        obj.x = value.x-obj.width
        if self:isPositionFree(obj) and math.abs(obj.x-item.x)<distance and self:xInside(item, obj.x) then
            distance = math.abs(obj.x-item.x)
        else
            obj.x = x
        end
    end
    for index, value in ipairs(xs) do
        local x = obj.x
        obj.x = value.x+value.width
        if self:isPositionFree(obj) and math.abs(obj.x-item.x)<distance and self:xInside(item, obj.x) then
            distance = math.abs(obj.x-item.x)
        else
            obj.x = x
        end
    end

    if obj.x then        
        return obj.x
    end

    return nil
end

function Shelf:isPositionFree(item)
    local proj = GameObject(item.x, self.y-item.height, item.width, item.height)
    for i, item in ipairs(game.placed) do
        if proj:collide(item) and item~=self then
            return false
        end
        if item:is(Shelf) then
            for j, decor in ipairs(item.items) do
                if proj:collide(decor) then
                    return false
                end
            end
        end
    end
    return true
end

function Shelf:update(dt, earthquake)
    for i = #self.items, 1, -1 do
        self.items[i]:update(dt, earthquake)
        if self.items[i].gravity>0 then
            table.insert(game.placed, self.items[i])
            table.remove(self.items, i)
        end
    end
    self.super.update(self, dt, false)
end

function Shelf:xInside(item, x)
    return x <= self.x+self.width-item.width/2 and x>=self.x-item.width/2
end

function Shelf:draw(earthquake, dx, dy)
    local x, y = self.x, self.y
    if earthquake then
        x = x + love.math.random(-2, 2)
        y = y + love.math.random(-2, 2)
    end
    if dx and dy then
        x = x + dx
        y = y + dy
    end

    if self.shop then
        love.graphics.draw(self.img.image, self.img.frames[self.frame], x, y)
    else
        love.graphics.draw(images.shelf.image, images.shelf.frames[1], x - 3, y - 4)
        love.graphics.draw(images.shelf.image, images.shelf.frames[2], x + 13, y - 4, 0, (self.width-26)/16, 1)
        love.graphics.draw(images.shelf.image, images.shelf.frames[1], x+self.width+3, y-4, 0, -1, 1)
    end
end

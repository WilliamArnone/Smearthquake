Shelf = Item:extend()

Shelf:implement(GameObject)

function Shelf:new(x, y, width, price, shop, frame)
    self.super.new(self, x, y, width, 7, price, 0, 100, nil, nil)
    self.items = {}
    self.shop = shop
    if shop then
        self.frame = frame
    end
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
end

function Shelf:xInside(item, x)
    return x <= self.x+self.width-item.width/2 and x>=self.x-item.width/2
end

function Shelf:draw(earthquake, dx, dy)

    if self.shop then
        --self.super.draw(earthquake, dx, dy)
    else
        --love.graphics.draw(images.shelf.image, images.shelf.frames[1], self.x - 3, self.y - 4)
        --love.graphics.draw(images.shelf.image, images.shelf.frames[2], self.x + 13, self.y - 4, 0, (self.width-32+6)/16, 1)
        love.graphics.draw(images.shelf.image, images.shelf.frames[1], self.x - 3, self.y - 4)

    end
end

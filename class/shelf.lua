Shelf = Item:extend()

Shelf:implement(GameObject)

function Shelf:new(x, y, width, height, price)
    self.super.new(self, x, y, width, height, price, 0, 100, "shelf", nil)
    self.items = {}
end

function Shelf:add(item, x)
    local index
    for i = 1, #self.items do
        if x<self.items[i].x then
            index = i
        end
    end
    item.x = x
    table.insert(self.items, index, item)
end

function Shelf:availableX(item)
    local obj = GameObject(item.x, self.y-item.height, item.width, item.height)
    local indexL = nil
    local indexR = nil
    for i, dec in ipairs(self.items) do
        if obj.collide(dec) and not indexL then
            indexL = i
        else
            indexR = i
        end
    end

    if not indexL then
        return obj.x
    elseif not indexR then
        indexR = indexL
    end
    local xl, xr
    repeat
        obj.x = self.items[indexL].x
        indexL = indexL-1
        if indexL>0 then
            if not item.collide(self.items[indexL]) and self.isPositionFree(obj) then
                indexL=0
                xl = obj.x
            end
        else
            if obj.x>self.x-obj.width and self.isPositionFree(obj)then
                xl = obj.x
            end
        end
    until indexL<1
    repeat
        obj.x = self.items[indexR].x+self.items[indexR].width
        indexR = indexR+1
        if indexL<=#self.items then
            if not item.collide(self.items[indexR]) and self.isPositionFree(obj) then
                indexR=#self.items+1
                xr = obj.x
            end
        else
            if obj.x<self.x+self.width-obj.width and self.isPositionFree(obj)then
                xr = obj.x
            end
        end
    until indexR>#self.items

    if xl and xr then
        if item.x-xl<xr-item.x then
            return xl
        else
            return xr
        end
    elseif xl then
        return xl
    else
        return xr
    end
end

function Shelf:isPositionFree(item)
    local proj = GameObject(item.x, self.y-item.height, item.width, item.height)
    for i, item in ipairs(game.placed) do
        if proj:collide(item) then
            return false
        end
        if item:is(Shelf) and item ~= self then
            for j, decor in ipairs(item.items) do
                if proj:collide(item) then
                    return false
                end
            end
        end
    end
    return true
end

function Shelf:update()
end

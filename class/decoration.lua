Decoration = Item:extend()

function Decoration:canBePlaced()
    for index, item in ipairs(game.placed) do
        if item:is(Shelf) and self:collide(item) then
            local x = item:availableX(self)
            if x then
                return {x = x, y = item.y-self.height, shelf = item}
            end
        end
    end
end

function Item:drawProjection(proj)
    if proj then
        x, y = self.x, self.y
        self.x, self.y = proj.x, proj.y 
        love.graphics.setColor(0.4, 1, 0.3, 0.7)
        self:draw()
        love.graphics.setColor(0.7, 0.7, 0.6, 0.7)
        self.x, self.y = x, y
    else
        love.graphics.setColor(1, 0.4, 0.3, 0.7)
    end
    self:draw()
    love.graphics.setColor(1, 1, 1)
end
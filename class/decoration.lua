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
        love.graphics.setColor(0.4, 1, 0.4, 0.7)
        self.super.draw(self, false, proj.x-self.x, proj.y-self.y)
        love.graphics.setColor(0.7, 0.7, 0.7, 0.7)
    else
        love.graphics.setColor(1, 0.4, 0.4, 0.7)
    end
    self:draw()
    love.graphics.setColor(1, 1, 1)
end
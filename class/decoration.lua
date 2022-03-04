Decoration = Item:extend()

function Decoration:new(width, height, price, happiness, instability, frame, sound)
    self.super.new(self, 0, 0, width, height, images.decoration, frame, price, happiness, instability, sound)
end

function Decoration:canBePlaced()
    for index, item in ipairs(game.placed) do
        if item:is(Shelf) then
            local shelfHit = GameObject(item.x, item.y-3, item.width, item.height+3)
            if self:collide(shelfHit) then
                local x = item:availableX(self)
                if x then
                    return {x = x, y = item.y-self.height, shelf = item}
                end
            end
        end
    end
end

function Decoration:drawProjection(proj)
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
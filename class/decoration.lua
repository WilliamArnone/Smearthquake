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

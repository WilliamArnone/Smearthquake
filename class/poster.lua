Poster = Item:extend()

function Poster:new(width, height, price, happiness, instability, frame, sound)
    self.super.new(self, 0, 0, width, height, images.poster, frame, price, happiness, instability, sound)
end
Poster = Item:extend()

function Poster:new(width, height, price, happiness, instability, frame, sound)
    self.super.new(self, width, height, price, happiness, instability, frame, sound)
    self.img = images.poster
end
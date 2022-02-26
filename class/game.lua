Game = Object:extend()

function Game:new()
    self.objects = {}
    self.earthquake = false
    table.insert(self.objects, GameObject(10, 10, 10, 10))
end


function Game:update(dt)
    if not self.earthquake then
        if love.math.random(0, 5) == 5 then 
            self.earthquake = true
            self.earthquakeTimer = 2
        end
    else
        self.earthquakeTimer = self.earthquakeTimer-dt
        if self.earthquakeTimer<=0 then
            self.earthquake = false
        end
    end

    for index, obj in ipairs(self.objects) do
        obj:update(dt)
    end
end


function Game:draw()
    for index, obj in ipairs(self.objects) do
        obj:draw(self.earthquake)
    end
end
Game = Object:extend()
local min_earthquake_time = 10
local max_earthquake_time = 3
local min_earthquake_duration = 2
local max_earthquake_duration = 5
local start_money = 400

function Game:createBox(item)
    table.insert(self.boxes, Box(love.math.random(64), love.math.random(gameHeight*2/3, gameHeight-32), item))
end


function Game:new()
    self.placed = {}
    self.boxes = {}
    self.dragging = {}
    self.earthquake = 0
    self.nextEarthquake = 12
    self.computer = Computer(96, 108, 196, 108)

    self.money = start_money
    self.happiness = 0
end


function Game:update(dt)
    self.happiness = 0

    --earthquake timer
    if self.earthquake > 0 then
        self.earthquake = self.earthquake-dt
    elseif self.nextEarthquake > 0 then
        self.nextEarthquake = self.nextEarthquake-dt
    else
        self.earthquake = love.math.random(min_earthquake_duration, max_earthquake_duration)
        self.nextEarthquake = love.math.random(min_earthquake_time, max_earthquake_time)
    end


    --update placed
    for i = #self.placed, 1, -1 do
        local placed = self.placed[i]
        self.happiness = self.happiness + placed.happiness
        placed:update(dt, self.earthquake>0)
        if placed:isDropped() then
            table.remove(self.placed, i)
        end
    end
    
    --update grabbed
    local grabobj = self.dragging.object
    local mouseX, mouseY = love.mouse.getX()/10*2, love.mouse.getY()/10*2
    if grabobj then
        self.happiness = self.happiness + grabobj.happiness
        grabobj.x = mouseX + self.dragging.dx
        grabobj.y = mouseY + self.dragging.dy
        self.dragging.proj = grabobj:canBePlaced()
    end
end

function Game:draw()
    local earthquake = self.earthquake>0

    self.computer:draw(earthquake)
    --drawobjs
    for index, item in ipairs(self.placed) do
        item:draw(earthquake, 0.5, 0.5, 0.5)
    end

    for index, box in ipairs(self.boxes) do
        box:draw(earthquake)
    end

    if self.dragging.object then
        self.dragging.object:drawProjection(self.dragging.proj)
    end

    love.graphics.print(self.money, 0, 0)
    love.graphics.print(self.happiness, gameWidth-50, 0)

    --print money, happiness
end

function Game:keypressed(key)
    if key=="space"then
        --table.insert(self.boxes, Box(love.math.random(gameWidth), love.math.random(gameHeight), randomDecoration()))
        --self:createBox("decoration", "doll")
        self:createBox(Shelf(0, 0, 60, 6, 100))
    end
    self.computer:keypressed(key)
end

function Game:mousepressed(x, y, button)
    if self.dragging.object then
        return
    end
    for i = #self.boxes, 1, -1 do
        local box = self.boxes[i]
        if box:isPointInside(x, y) then
            self.dragging.object=box.item
            table.remove(self.boxes, i)
            self.dragging.dx = - self.dragging.object.width/2
            self.dragging.dy = - self.dragging.object.height/2
            return
        end
    end
    for i = #self.placed, 1, -1 do
        local placed = self.placed[i]
        if placed:isPointInside(x, y) then
            self.dragging.object=placed
            table.remove(self.placed, i)
            self.dragging.dx = placed.x - x
            self.dragging.dy = placed.y - y
            return
        end
    end
    if self.computer:isPointInside(x, y) then
        self.computer:mousepressed(x, y)
    end
end

function Game:mousereleased(x, y, button)
    if self.dragging.object then
        if self.dragging.proj then
            self.dragging.object:place(true, self.dragging.proj.x, self.dragging.proj.y)
        else
            if self.dragging.object:is(Shelf) then
                return
            end
            self.dragging.object:place(false)
        end
        table.insert(self.placed, self.dragging.object)
        self.dragging.object = nil
    end
end
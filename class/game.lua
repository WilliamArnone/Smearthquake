Game = Object:extend()
local min_earthquake_time = 10
local max_earthquake_time = 3
local min_earthquake_duration = 2
local max_earthquake_duration = 5
local start_money = 400
local life_increase = 1
local life_decrease = 1
local life_total = 100
local life_start = 100
local low_happy = 50
local high_happy = 100

function Game:createBox(item)
    table.insert(self.boxes, Box(love.math.random(64), love.math.random(gameHeight*2/3, gameHeight-32), item))
    self.door:ordered()
end


function Game:new()
    self.placed = {}
    self.boxes = {}
    self.dragging = {}
    self.earthquake = 0
    self.nextEarthquake = 12
    self.computer = Computer(96, 98, 196, 108)
    self.door = Door()
    self.handdx = Hand(true)
    self.handsx = Hand(false)

    self.money = start_money
    self.happiness = 0
    self.life = life_start
    self.lifebar = Lifebar()
end


function Game:update(dt, x, y)
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
        if placed:is(Shelf) then
            for index, item in ipairs(placed.items) do
                self.happiness = self.happiness + item.happiness
            end
        end
    end
    
    --update grabbed
    local grabobj = self.dragging.object
    if grabobj then
        self.happiness = self.happiness + grabobj.happiness
        grabobj.x = x + self.dragging.dx
        grabobj.y = y + self.dragging.dy
        self.dragging.proj = grabobj:canBePlaced()
    end

    self.door:update(dt)
    self.computer:update(x, y)
    self.handdx:update(dt, x, y)
    self.handsx:update(dt, x, y)

    local lifeconst
    if self.happiness<low_happy then
        lifeconst = -dt*life_decrease
    elseif self.happiness<high_happy then
        lifeconst = 0
    else
        lifeconst = dt*life_increase
    end

    self.life = math.min(self.life+lifeconst, life_total)

    if self.life<= 0 then
        State = "Menu"
    end
end

function Game:draw(isOn)
    local earthquake = self.earthquake>0 and isOn

    love.graphics.draw(images.room, 0, 0)

    self.door:draw()
    self.computer:draw(earthquake)
    --drawobjs
    for index, item in ipairs(self.placed) do
        item:draw(earthquake, 0.5, 0.5, 0.5)
        if item:is(Shelf) then
            for _, dec in ipairs(item.items) do
                dec:draw(earthquake, 0, 1, 1)
            end
        end
    end

    for index, box in ipairs(self.boxes) do
        box:draw(earthquake)
    end

    if self.dragging.object then
        self.dragging.object:drawProjection(self.dragging.proj)
    end

    self.handdx:draw(earthquake)
    self.handsx:draw(earthquake)

    game:print(self.money, 0, 0, "number")
    --game:print(math.floor(self.life), gameWidth-50, 0, "number")

    --print money, happiness
    self.lifebar:draw(self.happiness, low_happy, high_happy, self.life, life_total)
end

function Game:keypressed(key)
    if key=="space"then
        --table.insert(self.boxes, Box(love.math.random(gameWidth), love.math.random(gameHeight), randomDecoration()))
        --self:createBox("decoration", "doll")
        --self:createBox(Shelf(0, 0, 60, 6, 100))
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
            if placed:is(Shelf)then
                return
                -- for i = #placed.items, 1, -1 do
                --     table.insert(self.placed, placed.items[i])
                --     placed.items[i]:place(false)
                -- end
                -- table.remove(placed.items, i)
            end
            self.dragging.object=placed
            table.remove(self.placed, i)
            self.dragging.dx = placed.x - x
            self.dragging.dy = placed.y - y
            return
        else
            if placed:is(Shelf) then
                for index, item in ipairs(placed.items) do
                    if item:isPointInside(x, y) then
                        self.dragging.object=item
                        table.remove(placed.items, index)
                        self.dragging.dx = item.x - x
                        self.dragging.dy = item.y - y
                        return
                    end
                end
            end
        end
    end
    if self.computer:isPointInside(x, y) then
        self.computer:mousepressed(x, y)
    end
end

function Game:mousereleased(x, y, button)
    if self.dragging.object then
        if self.dragging.proj then
            if self.dragging.object:is(Decoration)then
                self.dragging.proj.shelf:add(self.dragging.object, self.dragging.proj.x)
            else
                self.dragging.object:place(true, self.dragging.proj.x, self.dragging.proj.y)
                table.insert(self.placed, self.dragging.object)
            end
        else
            if self.dragging.object:is(Shelf) then
                return
            end
            self.dragging.object:place(false)
            table.insert(self.placed, self.dragging.object)
        end
        self.dragging.object = nil
    end
end

function Game:print(words, x, y, type, color)
    local size
    local font
    if color=="green" then
        love.graphics.setColor(0, 1, 0)
    elseif color=="red" then
        love.graphics.setColor(1, 0, 0)
    elseif color=="black" then
        love.graphics.setColor(0, 0, 0)
    end
    if type=="number" then
        size = 4
        font = images.price_font
    else
        size = 8
        font = images.type_font
    end

    for i = 1, string.len(words) do
        local letter = string.sub(words, i, i)
        local frame
        
        if type=="number" then
            if letter == "$" then
                frame = 11
            else
                frame = tonumber(letter)+1
            end
        else
            frame = (string.byte(letter))%32
        end

        love.graphics.draw(font.image, font.frames[frame], x+(i-1)*(size+size/4), y)
    end

    
    love.graphics.setColor(1, 1, 1)
end


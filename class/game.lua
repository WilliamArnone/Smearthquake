Game = Object:extend()
local min_earthquake_time = 3
local max_earthquake_time = 10
local min_earthquake_duration = 2
local max_earthquake_duration = 6
local start_money = 100
local life_increase = 1
local life_decrease = 1
local life_total = 100
local life_start = 100
local low_happy = 50
local high_happy = 100
shelves_scale = 4
inc_ratio = 1.6

function Game:createBox(item, frame)
    self.door:ordered()
    game.moneyanim = Money(item.price, "red")
    newbox = Box(love.math.random(64), love.math.random(gameHeight-36, gameHeight-25), item, frame)
    for index, box in ipairs(self.boxes) do
        if box.y > newbox.y then
            table.insert(self.boxes, index, newbox)
            return
        end
    end
    table.insert(self.boxes, newbox)
end


function Game:new()
    local shelf, item
    self.placed = {}
    shelf = Shelf(12*shelves_scale, 120, false, 1)
    table.insert(self.placed, shelf)
    shelf.x = 60
    shelf.y = 60
    item = decorations.vase()
    item.x = 56
    item.y = shelf.y-item.height
    table.insert(shelf.items, item)
    item = decorations.vase()
    item.x = 72
    item.y = shelf.y-item.height
    table.insert(shelf.items, item)
    item = decorations.vase()
    item.x = 100
    item.y = shelf.y-item.height
    table.insert(shelf.items, item)

    shelf = Shelf(12*shelves_scale, 120, false, 1)
    table.insert(self.placed, shelf)
    shelf.x = 250
    shelf.y = 90
    item = decorations.mario()
    item.x = 255
    item.y = shelf.y-item.height
    table.insert(shelf.items, item)

    item = posters.yellowspace()
    item.x = 130
    item.y = 2
    table.insert(self.placed, item)

    self.boxes = {}
    self.dragging = {}
    self.earthquake = 0
    self.nextEarthquake = 0
    self.computer = Computer(96, 98, 196, 108)
    self.door = Door()
    self.handdx = Hand(true)
    self.handsx = Hand(false)
    self.charCounter = {total = 0, correct = 0, streak = 0, maxstreak = 0}

    self.money = start_money
    self.happiness = 0
    self.life = life_start
    self.lifebar = Lifebar()
    self.time = 0
    self.moneyspent = 0
    self.dollar = GameObject(6, 16, 0, 0, images.money)
end


function Game:update(dt, x, y)
    self.time = self.time+dt
    self.happiness = 0

    --earthquake timer
    if self.earthquake > 0 then
        self.earthquake = self.earthquake-dt
    elseif self.nextEarthquake > 0 then
        self.nextEarthquake = self.nextEarthquake-dt
        sounds.earthquake:stop()
    else
        self.earthquake = love.math.random(min_earthquake_duration, max_earthquake_duration)
        self.nextEarthquake = love.math.random(min_earthquake_time, max_earthquake_time)
    end
    if self.earthquake>0 and not sounds.earthquake:isPlaying() then
        sounds.earthquake:play()
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

    for i = #self.boxes, 1, -1 do
        if self.boxes[i]:update(dt) then
            table.remove(self.boxes, i)
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

    if self.moneyanim then
        self.moneyanim:update(dt)
    end

    local lifeconst
    if self.happiness<low_happy+self.time*inc_ratio then
        lifeconst = -dt*life_decrease
    elseif self.happiness<high_happy+2*self.time*inc_ratio then
        lifeconst = 0
    else
        lifeconst = dt*life_increase
    end

    self.life = math.min(self.life+lifeconst, life_total)

    if self.life<= 0 then
        GameMenu:gameOver()
    end
end

function Game:draw(isOn)
    local earthquake = self.earthquake>0 and isOn

    love.graphics.draw(images.room, 0, 0)

    self.door:draw(earthquake)

    --drawobjs
    for index, item in ipairs(self.placed) do

        if item.instability < item.total_instability then
            local perc = 1-item.instability/item.total_instability
            love.graphics.setColor(1, 1*perc, 1*perc)
        end

        item:draw(earthquake)
        love.graphics.setColor(1, 1, 1)


        if item:is(Shelf) then
            for _, dec in ipairs(item.items) do
                if dec.instability < dec.total_instability then
                    local perc =  1-dec.instability/dec.total_instability
                    love.graphics.setColor(1, 1*perc, 1*perc)
                end

                dec:draw(earthquake)
                love.graphics.setColor(1, 1, 1)
            end
        end
    end

    for index, box in ipairs(self.boxes) do
        box:draw(earthquake)
    end

    self.computer:draw(earthquake)

    if self.dragging.object then
        self.dragging.object:drawProjection(self.dragging.proj)
    end

    self.handdx:draw(earthquake)
    self.handsx:draw(earthquake)

    --game:print(self.money, 0, 0, "number")
    --game:print(math.floor(self.life), gameWidth-50, 0, "number")

    --print money, happiness
    self.lifebar:draw(self.happiness, low_happy, high_happy, self.life, life_total)
    if self.moneyanim then
        self.moneyanim:draw()
    end
    self.dollar:draw()
    Print("$"..self.money, self.dollar.x+5, self.dollar.y+6, "number", "darkgreen", 1)
end

function Game:keypressed(key)
    if key=="space"then
        --table.insert(self.boxes, Box(love.math.random(gameWidth), love.math.random(gameHeight), randomDecoration()))
        --self:createBox("decoration", "doll")
        --self:createBox(Shelf(0, 0, 60, 6, 100))
    end
    if key == "tab" then
        if self.computer.state == "work" then
            self.computer.state = "shop"
        else
            self.computer.state = "work"
        end
    else
        self.handdx:type()
        self.computer:keypressed(key)
    end
    self.handsx:type()
end

function Game:mousepressed(x, y, button)
    if self.dragging.object then
        return
    end
    if self.computer:isPointInside(x, y) then
        self.computer:mousepressed(x, y)
        return
    end
    for i = #self.boxes, 1, -1 do
        local box = self.boxes[i]
        if box:isPointInside(x, y) and not box.isopen then
            self.dragging.object=box.item
            --table.remove(self.boxes, i)
            box:open()
            self.dragging.dx = - self.dragging.object.width/2
            self.dragging.dy = - self.dragging.object.height/2
            return
        end
    end
    for i = #self.placed, 1, -1 do
        local placed = self.placed[i]
        if placed:isPointInside(x, y)then
            if placed:is(Shelf) and #placed.items > 0 then
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
            self.dragging.object:place(false)
            table.insert(self.placed, self.dragging.object)
        end
        self.dragging.object = nil
    end
end

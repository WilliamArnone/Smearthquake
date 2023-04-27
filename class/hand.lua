Hand = GameObject:extend()
local speed =  15

function Hand:new(isRight)
    if isRight then
        self.xdir = 1
    else
        self.xdir = -1
    end
    self.origin = {x = gameWidth/2+26*self.xdir, y = gameHeight-16}
    self.typing = 0
    self.frame = 1
    self.reached = false;

    self.super.new(self, self.origin.x, self.origin.y, 32, 32, images.hands, 1)
end


function Hand:update(dt, mouseX, mouseY)
    self.locked = false
    local target
    if (not game.computer.work:isPointInside(mouseX, mouseY) or game.dragging.object) and lume.sign(mouseX - gameWidth/2) == lume.sign(self.xdir) then
        self.locked = true
        target = {x = mouseX-16*self.xdir, y = mouseY-16}
        self.typing = 0
        local obj = game.dragging.object
        local obj2 = game.dragging.proj
        if obj then
            self.frame = 8
            if not obj2 or true then
                obj2 = obj
            end
            target = {x = obj2.x+obj.width/2+(obj.width/2-16)*self.xdir, y = obj2.y+obj.height/2-16}
            self.x = target.x
            self.y = target.y
        elseif self:hoverItem(mouseX, mouseY) then
            self.frame = 7
        else
            self.frame = 6
        end

        self.reached = self.reached or (math.pow(self.x - target.x, 2) + math.pow(self.y - target.y, 2) < 4)
        
    else
        self.reached = false;
        target = self.origin
        self.typing = self.typing-dt
        if self.typing <=0 then
            self.frame = 1
        end
    end
    --local norm = lume.distance(self.x, self.y, target.x, target.y)
    local real_speed = speed
    if math.pow(self.x - target.x, 2) + math.pow(self.y - target.y, 2) < 1000 then
        real_speed = real_speed * 4
    end
    self.x = self.x+(target.x-self.x)*dt*real_speed
    self.y = self.y+(target.y-self.y)*dt*real_speed
    if self.reached then
        self.x = target.x
        self.y = target.y
    end
end

function Hand:type()
    if (not self.target) then
        self.typing = 0.5
        self.frame = love.math.random(2,5)
    end
end

function Hand:draw(earthquake)

    local x, y = self.x, self.y

    self.super.draw(self, earthquake and not self.locked, 0, 0, 0, self.xdir, 1)
end

function Hand:hoverItem(mouseX, mouseY)
    if not self.locked then return false end
    for _, obj in ipairs(game.placed) do
        if obj:is(Shelf) then
            if obj:isPointInside(mouseX, mouseY) and #obj.items == 0 then
                return true
            end
            for _, item in ipairs(obj.items) do
                if item:isPointInside(mouseX, mouseY) then
                    return true
                end
            end
        else
            if obj:isPointInside(mouseX, mouseY) then
                return true
            end
        end
    end
    for _, obj in ipairs(game.boxes) do
        if obj:isPointInside(mouseX, mouseY) then
            return true
        end
    end
end
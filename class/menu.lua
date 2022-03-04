Menu = Object:extend()

function Menu:new()
    self.visible = true
    self.pc = GameObject(0, 0, gameWidth, gameHeight, images.menu)
    self.pcTarget = 0
    self.logo = nil
    self.start = nil
    self.howToPlay = nil
    self.exit = nil
    self.quit = nil
    self.resume = nil
    self.flash = 0
    self.time = 0
    self.mouse = nil
end

function Menu:main()
    State = "Main"
    if not sounds.menu:isPlaying() then
        love.audio.stop()
        sounds.menu:play()
    end
    self.pcTarget = 0
    self.visible = true
    self.mouse = GameObject(0, 0, 0, 0, images.mouse)
    self.logo = GameObject(gameWidth/2-64, gameHeight/2-64, 128, 64, images.logo)
    self.start = GameObject(gameWidth/2-10/2*8, gameHeight/2+26, 10*8, 8)
    self.quit = GameObject(gameWidth/2-10/2*10, gameHeight/2+48, 10*10, 8)
end

function Menu:update(dt, x, y)
    local dist = (self.pc.y-self.pcTarget)
    local step = dist*dt*6
    if math.abs(step)>math.abs(dist) then
        dist = step
    end
    if math.abs(dist) < 1 then
        self.pc.y = self.pcTarget
        step = 0
    end
    if self.flash > 0 then
        self.flash = self.flash-dt
    end
    self.pc.y = self.pc.y - step
    self.visible = self.pc.y<gameHeight
    if self.visible then
        if self.mouse then
            self.mouse.x, self.mouse.y = x, y
        end
        
        if self.logo then
            self.logo.mouseOn =  self.logo:isPointInside(x,y)
        end
        if self.start then
            self.start.mouseOn =  self.start:isPointInside(x,y)
        end
        if self.howToPlay then
            self.howToPlay.mouseOn =  self.howToPlay:isPointInside(x,y)
        end
        if self.exit then
            self.exit.mouseOn =  self.exit:isPointInside(x,y)
        end
        if self.quit then
            self.quit.mouseOn =  self.quit:isPointInside(x,y)
        end
        if self.resume then
            self.resume.mouseOn =  self.resume:isPointInside(x,y)
        end
    end
end

function Menu:pause()
    State = "Pause"
    sounds.main:pause()
    sounds.earthquake:stop()
    sounds.menu:play()

    self.pcTarget = 0
    self.visible = true
    self.mouse = GameObject(0, 0, 0, 0, images.mouse)
    self.resume = GameObject(gameWidth/2-10/2*6, gameHeight/2+26, 10*6, 8)
    self.exit = GameObject(gameWidth/2-10/2*4, gameHeight/2+48, 10*4, 8)
end

function  Menu:gameOver()
    State = "GameOver"

    love.audio.stop()
    sounds.death:play()

    self.pcTarget = 0
    self.visible = true
    self.mouse = GameObject(0, 0, 0, 0, images.mouse)
    self.start = GameObject(gameWidth/2-10/2*8, gameHeight/2+26, 10*8, 8)
    self.exit = GameObject(gameWidth/2-10/2*4, gameHeight/2+48, 10*4, 8)
end

function Menu:offScreen(state)
    self.pcTarget = gameHeight+1
    self.logo = nil
    self.start = nil
    self.howToPlay = nil
    self.exit = nil
    self.quit = nil
    self.resume = nil
    self.mouse = nil
    State = state
end

function Menu:mousepressed(x, y)
    if not self.visible then
        return
    elseif self.start and self.start:isPointInside(x,y) then
        self:offScreen("New")
        game = nil
        love.audio.stop()
        sounds.main:play()
    elseif self.howToPlay and self.howToPlay:isPointInside(x,y) then
        self:offScreen("Tutorial")
    elseif self.exit and self.exit:isPointInside(x,y) then
        self.resume = nil
        self.exit = nil
        self:main()
    elseif self.quit and self.quit:isPointInside(x,y) then
        love.event.quit()
    elseif self.resume and self.resume:isPointInside(x,y) then
        self:offScreen("Game")
        sounds.menu:stop()
        sounds.main:play()
    end
end

function Menu:draw()
    if not self.visible then
        return
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.pc.x, self.pc.y+10, gameWidth, gameHeight-20)
    love.graphics.setColor(1, 1, 1)
    if self.pc.y == self.pcTarget then
        if self.logo then
            local dx, dy = 0, 0
            self.logo:draw(self.logo.mouseOn)
        end
        if self.start then
            local color = "white"
            local x, y = self.start.x, self.start.y
            if self.start.mouseOn then
                x = x + love.math.random(-2, 2)
                y = y + love.math.random(-2, 2)
                color = "green"
            end
            Print("new game", x, y, "type", color)
        end
        if self.howToPlay then
            local color = "white"
            local x, y = self.howToPlay.x, self.howToPlay.y
            if self.howToPlay.mouseOn then
                x = x + love.math.random(-2, 2)
                y = y + love.math.random(-2, 2)
                color = "green"
            end
            Print("how to play", x, y, "type", color)
        end
        if self.exit then
            local color = "white"
            local x, y = self.exit.x, self.exit.y
            if self.exit.mouseOn then
                x = x + love.math.random(-2, 2)
                y = y + love.math.random(-2, 2)
                color = "red"
            end
            Print("exit", x, y, "type", color)
        end
        if self.quit then
            local color = "white"
            local x, y = self.quit.x, self.quit.y 
            if self.quit.mouseOn then
                x = x + love.math.random(-2, 2)
                y = y + love.math.random(-2, 2)
                color = "red"
            end
            Print("close game", x, y, "type", color)
        end
        if self.resume then
            local color = "white"
            local x, y = self.resume.x, self.resume.y 
            if self.resume.mouseOn then
                x = x + love.math.random(-2, 2)
                y = y + love.math.random(-2, 2)
                color = "green"
            end
            Print("resume", x, y, "type", color)
        end
        if self.flash>0 then
            love.graphics.rectangle("fill", self.pc.x, self.pc.y+10, gameWidth, gameHeight-20)
        end
    end
    if self.mouse then
        self.mouse:draw()
    end
    self.pc:draw()
end
local launch_type = arg[2]
if launch_type == "test" or launch_type == "debug" then
    require "lldebugger"

    if launch_type == "debug" then
        ---@diagnostic disable-next-line: undefined-global
        lldebugger.start()
    end
end

function love.load()
    local o_ten_one = require "libraries.o-ten-one"
    lume = require "libraries.lume"
    Object = require "libraries.classic"
    --Camera = require 'libraries.Camera'
    require "class.game"
    require "class.gameObject"
    require "class.item"
    require "class.box"
    require "class.shop"
    require "class.work"
    require "class.computer"
    require "class.shelf"
    require "class.decoration"
    require "class.poster"
    require "class.lifebar"
    require "class.door"
    require "class.hand"
    require "class.menu"
    require "class.money"
    require "data.decorations"
    require "data.posters"
    require "data.words"

    splash = o_ten_one()
    State = "Splash"
    splash.onDone = function()
        GameMenu = Menu()
        GameMenu:main()
    end

    love.mouse.setVisible(false)

    gameWidth = 192*2
    gameHeight = 108*2
    scaleFactorX = love.graphics.getWidth()/gameWidth
    scaleFactorY = love.graphics.getHeight()/gameHeight

    loadImages()
    loadSongs()


    initDecorations()
    initPosters()
    initWords()

    --game = Game()
end

function love.update(dt)

    if State == "Splash" then
        splash:update(dt)
        return
    end

    local x, y = love.mouse.getX()/scaleFactorX, love.mouse.getY()/scaleFactorY
    GameMenu:update(dt, x, y)
    if State == "New"then
        if not game then
            game = Game()
        end
        if not GameMenu.visible then
            State = "Game"
        end
    elseif State == "Game" then
        game:update(dt, x, y)
    end
end

function love.draw()
    if State == "Splash" then
        splash:draw()
        return
    end
    love.graphics.scale(scaleFactorX,scaleFactorY)
    love.graphics.setDefaultFilter("nearest", "nearest")
    if game then
        game:draw(State == "Game")
    end
    --love.graphics.rectangle("line", 0, 0, gameWidth, gameHeight)
    --love.graphics.print("Hello Word")
    GameMenu:draw()
end

function love.mousepressed(x, y, button)
    x, y = x/scaleFactorX, y/scaleFactorY
    if State == "Game" then
        game:mousepressed(math.floor(x), math.floor(y), button)
    else
        GameMenu:mousepressed(x, y)
    end
end

function love.mousereleased(x, y, button, istouch)
    x, y = x/scaleFactorX, y/scaleFactorY
    if State =="Game" then
        game:mousereleased(math.floor(x), math.floor(y), button)
    end
end

function love.keypressed(key)
    if State == "Game" then
        if key == "escape" or key == "return" then
            GameMenu:pause()
        else
            game:keypressed(key)
        end
    end
end

function loadSongs()
    sounds = {}

    sounds.death = love.audio.newSource("sounds/death.wav", "stream")
    sounds.main = love.audio.newSource("sounds/main.wav", "stream")
    sounds.main:setLooping(true)
    sounds.menu = love.audio.newSource("sounds/menu.wav", "stream")
    sounds.menu:setLooping(true)

    sounds.earthquake = love.audio.newSource("sounds/earthquake.wav", "static")
    sounds.earthquake:setLooping(true)
    sounds.glass = love.audio.newSource("sounds/glass.wav", "static")
    sounds.hard = love.audio.newSource("sounds/hard.wav", "static")
    sounds.money = love.audio.newSource("sounds/money.wav", "static")
    sounds.order = love.audio.newSource("sounds/ringbell.wav", "static")

end

function loadImages()
    images = {}

    images.room = love.graphics.newImage("img/room.png")
    images.room:setFilter("nearest", "nearest")
    images.mouse = love.graphics.newImage("img/mouse.png")
    images.mouse:setFilter("nearest", "nearest")
    images.lifebar = love.graphics.newImage("img/lifebar.png")
    images.lifebar:setFilter("nearest", "nearest")
    images.buy = love.graphics.newImage("img/buy.png")
    images.buy:setFilter("nearest", "nearest")
    images.computer = love.graphics.newImage("img/computer.png")
    images.computer:setFilter("nearest", "nearest")
    images.work = love.graphics.newImage("img/work.png")
    images.work:setFilter("nearest", "nearest")
    images.money = love.graphics.newImage("img/money.png")
    images.money:setFilter("nearest", "nearest")
    images.logo = love.graphics.newImage("img/title.png")
    images.logo:setFilter("nearest", "nearest")
    images.menu = love.graphics.newImage("img/menu.png")
    images.menu:setFilter("nearest", "nearest")

    images.type_font = importSheet("img/type_font.png", 8, 8, 3, 9, 26)
    images.price_font = importSheet("img/price_font.png", 4, 6, 2, 6, 12)
    images.hands = importSheet("img/hands.png", 32, 32, 1, 8, 8)
    images.shop = importSheet("img/shop.png", 176, 89, 2, 1, 2)
    images.door = importSheet("img/door.png", 64, 108, 1, 5, 5)
    images.box = importSheet("img/boxes.png", 32, 32, 2, 2, 4)
    images.shelf = importSheet("img/shelf.png", 16, 16, 1, 2, 2)
    images.shopshelf = importSheet("img/shopshelf.png", 32, 8, 4, 1, 4)
    images.decoration = importSheet("img/decoration.png", 32, 32, 4, 4, 15)
    images.poster = importSheet("img/poster.png", 32, 32, 4, 3, 11)

end

function importSheet (image_name, width, height, rows, columns, max)
    local frames = {}
    local image = love.graphics.newImage(image_name)
    image:setFilter("nearest", "nearest")
    for i=0, rows-1 do
        for j=0, columns-1 do
            table.insert(frames, love.graphics.newQuad(j * width, i * height, width, height, image:getWidth(), image:getHeight()))
            if #frames == max then
                break
            end
        end
    end
    return {image = image, frames = frames}
end


function Print(words, x, y, type, color, s)
    if not s then
        s = 1
    end
    local size
    local font
    if color=="darkgreen" then
        love.graphics.setColor(13/255, 83/255, 2/255)
    elseif color=="green" then
        love.graphics.setColor(0, 1, 0)
    elseif color=="red" then
        love.graphics.setColor(1, 0, 0)
    elseif color=="black" then
        love.graphics.setColor(0, 0, 0)
    end
    if type=="number" then
        size = 4*s
        font = images.price_font
    else
        size = 8*s
        font = images.type_font
    end

    for i = 1, string.len(words) do
        local letter = string.sub(words, i, i)
        local frame
        
        if type=="number" then
            if letter == "$" then
                frame = 11
            elseif letter == "%" then
                frame = 12
            elseif letter == "." then
                frame = nil
            else
                frame = tonumber(letter)+1
            end
        else
            if letter == " " then
                frame = nil
            elseif letter == ":" then
                frame = nil
            else
                frame = (string.byte(letter))%32
            end
        end
        if frame then
            love.graphics.draw(font.image, font.frames[frame], x+(i-1)*(size+size/4), y, 0, s, s)
        end
    end

    
    love.graphics.setColor(1, 1, 1)
end

---@diagnostic disable-next-line: undefined-field
local love_errorhandler = love.errhand

function love.errorhandler(msg)
    ---@diagnostic disable-next-line: undefined-global
    if lldebugger then
        ---@diagnostic disable-next-line: undefined-global
        lldebugger.start()
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
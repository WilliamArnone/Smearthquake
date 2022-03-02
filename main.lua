local launch_type = arg[2]
if launch_type == "test" or launch_type == "debug" then
    require "lldebugger"

    if launch_type == "debug" then
        ---@diagnostic disable-next-line: undefined-global
        lldebugger.start()
    end
end

function love.load()
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
    require "data.decorations"
    require "data.posters"
    require "data.words"

    love.mouse.setVisible(false)

    gameWidth = 192*2
    gameHeight = 108*2
    scaleFactorX = love.graphics.getWidth()/gameWidth
    scaleFactorY = love.graphics.getHeight()/gameHeight

    State = "Game"

    loadImages()

    initDecorations()
    initPosters()
    initWords()

    game = Game()
end

function love.update(dt)
    local x, y = love.mouse.getX()/scaleFactorX, love.mouse.getY()/scaleFactorY
    if State == "Game"then
        game:update(dt, x, y)
    end
end

function love.draw()
    love.graphics.scale(scaleFactorX,scaleFactorY)
    love.graphics.setDefaultFilter("nearest", "nearest")
    game:draw(State == "Game")
    love.graphics.rectangle("line", 0, 0, gameWidth, gameHeight)
    --love.graphics.print("Hello Word")
end

function love.mousepressed(x, y, button)
    x, y = x/scaleFactorX, y/scaleFactorY
    if State == "Game" then
        game:mousepressed(math.floor(x), math.floor(y), button)
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
        game:keypressed(key)
    end
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

    images.type_font = importSheet("img/type_font.png", 8, 8, 3, 9, 26)
    images.price_font = importSheet("img/price_font.png", 4, 6, 2, 6, 11)
    images.hands = importSheet("img/hands.png", 32, 32, 1, 5, 5)
    images.shop = importSheet("img/shop.png", 178, 90, 2, 1, 2)
    images.door = importSheet("img/door.png", 64, 108, 1, 5, 5)

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
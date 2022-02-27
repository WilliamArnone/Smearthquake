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
    require "data.decorations"
    require "data.posters"
    require "data.words"

    gameWidth = 192*2
    gameHeight = 108*2

    State = "Game"

    initDecorations()
    initPosters()
    initWords()

    game = Game()
end

function love.update(dt)
    if State == "Game"then
        game:update(dt)
    end
end

function love.draw()
    love.graphics.scale(5,5)
    game:draw()
    love.graphics.rectangle("line", 0, 0, gameWidth, gameHeight)
    --love.graphics.print("Hello Word")
end

function love.mousepressed(x, y, button)
    if State == "Game" then
        game:mousepressed(math.floor(x/10*2), math.floor(y/10*2), button)
    end
end

function love.mousereleased(x, y, button, istouch)
    if State =="Game" then
        game:mousereleased(math.floor(x/10*2), math.floor(y/10*2), button)
    end
end

function love.keypressed(key)
    if State == "Game" then
        game:keypressed(key)
    end
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


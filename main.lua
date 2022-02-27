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

    initDecorations()
    initPosters()
    initWords()

    game = Game()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    love.graphics.scale(5,5)
    game:draw()
    love.graphics.rectangle("line", 0, 0, gameWidth, gameHeight)
    --love.graphics.print("Hello Word")
end

function love.mousepressed(x, y, button)
    game:mousepressed(x/10*2, y/10*2, button)
end

function love.mousereleased(x, y, button, istouch)
    game:mousereleased(x/10*2, y/10*2, button)
end

function love.keypressed(key)
    game:keypressed(key)
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


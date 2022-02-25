local launch_type = arg[2]
if launch_type == "test" or launch_type == "debug" then
    require "lldebugger"

    if launch_type == "debug" then
        ---@diagnostic disable-next-line: undefined-global
        lldebugger.start()
    end
end




function love.load()
    --love.window.setFullscreen( true )
    lume = require "lume"
    Object = require "classic"
    Camera = require 'Camera'
end

function love.update(dt)
    
end

function love.draw()
    love.graphics.print("Hello Word")
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
decorations = {}
decoration_ratio = {}


function initDecorations()
    decorations = {}
    --                                          width, height, price, happiness, instability, img, sound
    decorations["vase"] = function () return Decoration(18, 18, 10, 15, 10, 1, sounds.glass) end
    decorations["globe"] = function () return Decoration(24, 32, 15, 30, 15, 13, sounds.hard) end
    
    decorations["vault"] = function () return Decoration(18, 23, 20, 35, 15, 6, sounds.hard) end
    decorations["waterman"] = function () return Decoration(18, 23, 25, 40, 15, 7, sounds.hard) end
    decorations["cubeportal"] = function () return Decoration(27, 28, 25, 30, 25, 2, sounds.hard) end
    
    decorations["amongus"] = function () return Decoration(17, 27, 50, 90, 15, 15, sounds.glass) end
    decorations["tetris"] = function () return Decoration(29, 21, 60, 60, 30, 14, sounds.glass) end
    
    decorations["mario"] = function () return Decoration(16, 16, 90, 100, 40, 8, sounds.hard) end
    
    decorations["pop"] = function () return Decoration(28, 32, 200, 320, 15, 5, sounds.hard) end
    decorations["venusaur"] = function () return Decoration(24, 21, 200, 200, 15, 11, sounds.hard) end
    
    
    decorations["triforce"] = function () return Decoration(18, 10, 250, 350, 30, 10, sounds.hard) end
    decorations["layton"] = function () return Decoration(16, 13, 300, 400, 20, 9, sounds.hard) end
    decorations["sparasemi"] = function () return Decoration(22, 28, 350, 450, 10, 3, sounds.glass) end
    decorations["ds"] = function () return Decoration(22, 27, 400, 550, 10, 12, sounds.glass) end
    
    decorations["rubik"] = function () return Decoration(13, 12, 1, 5000, 5, 4, sounds.hard) end


    decoration_ratio = {}
    decoration_ratio["vase"] = 15
    decoration_ratio["cubeportal"] = 10
    decoration_ratio["sparasemi"] = 3
    decoration_ratio["rubik"] = 1
    decoration_ratio["pop"] = 5
    decoration_ratio["vault"] = 10
    decoration_ratio["waterman"] = 10
    decoration_ratio["mario"] = 7
    decoration_ratio["layton"] = 3
    decoration_ratio["triforce"] = 3
    decoration_ratio["venusaur"] = 5
    decoration_ratio["ds"] = 2
    decoration_ratio["globe"] = 15
    decoration_ratio["tetris"] = 9
    decoration_ratio["amongus"] = 9
end

function randomDecoration()
    local name = lume.weightedchoice(decoration_ratio)
    return decorations[name]()
end
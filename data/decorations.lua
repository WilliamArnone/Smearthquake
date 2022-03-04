decorations = {}
decoration_ratio = {}


function initDecorations()
    decorations = {}
    --                                          x, y, width, height, price, happiness, instability, img, sound
    decorations["doll"] = function () return Decoration(20, 25, 20, 10, 10, nil, sounds.hard) end
    decorations["candy"] = function () return Decoration(5, 5, 3, 10, 10, nil, sounds.glass) end


    decoration_ratio = {}
    decoration_ratio["doll"] = 1
    decoration_ratio["candy"] = 1
end

function randomDecoration()
    local name = lume.weightedchoice(decoration_ratio)
    return decorations[name]()
end
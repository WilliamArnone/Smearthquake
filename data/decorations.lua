decorations = {}
decoration_ratio = {}


function initDecorations()
    decorations = {}
    --                                          width, height, price, happiness, instability, img, sound
    decorations["vase"] = function () return Decoration(18, 18, 20, 5, 5, images.decoration.frames[1], sounds.glass) end
    decorations["candy"] = function () return Decoration(5, 5, 3, 10, 10, nil, sounds.glass) end


    decoration_ratio = {}
    decoration_ratio["vase"] = 2
    decoration_ratio["candy"] = 1
end

function randomDecoration()
    local name = lume.weightedchoice(decoration_ratio)
    return decorations[name]()
end
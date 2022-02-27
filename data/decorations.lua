decorations = {}
decoration_ratio = {}


function initDecotations()
    decorations = {}
    --                                          x, y, width, height, price, happiness, instability, img, sound
    decorations["doll"] = function () return Item(0, 0, 20, 25, 20, 10, 10, "doll.png", "solid") end
    decorations["candy"] = function () return Item(0, 0, 5, 5, 3, 10, 10, "candy.png", "tiny") end


    decoration_ratio = {}
    decoration_ratio["doll"] = 1
    decoration_ratio["candy"] = 1
end

function randomDecoration()
    return decorations[lume.weightedchoice(decoration_ratio)]()
end
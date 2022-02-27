posters = {}
posters_ratio = {}


function initPosters()
    posters = {}
    --                                          x, y, width, height, price, happiness, instability, img, sound
    posters["picasso"] = function () return Item(0, 0, 32, 32, 20, 10, 10, "picasso.png", "solid") end
    posters["monnalisa"] = function () return Item(0, 0, 32, 32, 300, 10, 10, "monnalisa.png", "solid") end


    posters_ratio = {}
    posters_ratio["picasso"] = 1
    posters_ratio["monnalisa"] = 1
end

function randomPoster()
    return posters[lume.weightedchoice(posters_ratio)]()
end
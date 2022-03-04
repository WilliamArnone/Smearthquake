posters = {}
posters_ratio = {}


function initPosters()
    posters = {}
    --                                          width, height, price, happiness, instability, img, sound
    posters["monnalisa"] = function () return Poster(26, 32, 400, 300, 45, 1, sounds.hard) end      --0.3
    posters["specchiodellebrame"] = function () return Poster(17, 32, 300, 240, 40, 2, sounds.glass) end  --0.34
    posters["munch"] = function () return Poster(30, 32, 350, 260, 45, 3, sounds.hard) end      --0.32

    posters["naruto"] = function () return Poster(32, 32, 30, 40, 15, 5, sounds.hard) end  --1
    posters["dnd"] = function () return Poster(25, 32, 30, 20, 30, 8, sounds.hard) end  --0.5

    posters["madmax"] = function () return Poster(32, 28, 60, 40, 50, 4, sounds.hard) end   --0.5
    posters["sonic"] = function () return Poster(32, 32, 60, 75, 30, 6, sounds.hard) end  --~1

    posters["scott"] = function () return Poster(28, 32, 80, 20, 300, 9, sounds.hard) end  --0.25

    local xspace, yspace, pricespace, happyspace, instabspace = 15, 13, 15, 5, 10            --0.3
    posters["yellowspace"] = function () return Poster(xspace, yspace, pricespace, happyspace, instabspace, 7, sounds.glass) end
    posters["redspace"] = function () return Poster(xspace, yspace, pricespace, happyspace, instabspace, 10, sounds.glass) end
    posters["purplespace"] = function () return Poster(xspace, yspace, pricespace, happyspace, instabspace, 11, sounds.glass) end

    local probspace = 5
    
    posters_ratio = {}
    posters_ratio["monnalisa"] = 1
    posters_ratio["specchiodellebrame"] = 3
    posters_ratio["munch"] = 2
    posters_ratio["madmax"] = 1
    posters_ratio["naruto"] = 7
    posters_ratio["sonic"] = 5
    posters_ratio["yellowspace"] = probspace
    posters_ratio["dnd"] = 7
    posters_ratio["scott"] = 8
    posters["redspace"] = probspace
    posters["purplespace"] = probspace
end

function randomPoster()
    return posters[lume.weightedchoice(posters_ratio)]()
end
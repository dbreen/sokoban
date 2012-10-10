function HSL(h, s, l, a)
    if s<=0 then return l,l,l,a end
    h, s, l = h/256*6, s/255, l/255
    local c = (1-math.abs(2*l-1))*s
    local x = (1-math.abs(h%2-1))*c
    local m,r,g,b = (l-.5*c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

-- fix this gross thing
Stars = {
    stars = {},
    create = function(n)
        for i = 1, n, 1 do
            Stars.stars[i] = {x = math.random(1, Media.screenx),
                        y = math.random(1, Media.screeny),
                        vx = math.random(50, 200), vy = math.random(5, 200),
                        rot = 0, rvel = math.random() * 3}
        end
    end,
    update = function(dt)
        for i = 1, #Stars.stars do
            Stars.stars[i].x = Stars.stars[i].x + Stars.stars[i].vx * dt
            if Stars.stars[i].x > Media.screenx + 100 then Stars.stars[i].x = -100 end
            Stars.stars[i].y = Stars.stars[i].y + Stars.stars[i].vy * dt
            if Stars.stars[i].y > Media.screeny + 100 then Stars.stars[i].y = -100 end
            Stars.stars[i].rot = Stars.stars[i].rot + Stars.stars[i].rvel * dt
        end
    end,
    draw = function()
        for _, star in ipairs(Stars.stars) do
            love.graphics.draw(Media.star, star.x, star.y, star.rot, 1, 1, 50, 50)
        end
    end
}

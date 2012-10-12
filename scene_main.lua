
main = Gamestate.new()

function main:init()
    camera = Camera()
    local p = love.graphics.newParticleSystem(Media.star, 300)
    p:setEmissionRate(100)
    p:setSpeed(300, 500)
    p:setSizes(.5, 1.5)
    p:setLifetime(2)
    p:setParticleLife(2)
    p:setDirection(0)
    p:setSpread(50)
    p:setSizeVariation(2)
    p:setRadialAcceleration(1, 2)
    p:stop()
    self.particles = p
end

function main:enter(previous)
    rescale()
    self.hue = 0
    self.is_winning = false
end

function main:update(dt)
    Timer.update(dt)
    Stars.update(dt)
    self.hue = self.hue + dt * 50
    if self.is_winning then
        self.particles:update(dt)
    end
end

function draw_quad(t, pos, ...)
    quad = Media[t]
    if table.find(raised, t) then
        height = -Media.height_top
    elseif table.find(blocks, t) then
        height = 0
    else
        height = -Media.height_top
    end
    local x = (pos.x - 1) * Media.tilex
    local y = (pos.y - 1) * Media.tiley - pos.y * Media.height_offset + height
    love.graphics.drawq(Media.tiles, quad, x, y, ...)
end

function main:draw()
    love.graphics.setBackgroundColor(HSL(main.hue % 255, 200, 200))
    Stars.draw()

    love.graphics.push()
    love.graphics.scale(camera.zoom)
    love.graphics.translate(offsetx, offsety)
    render()
    love.graphics.pop()

    love.graphics.setColorMode('modulate')

    if self.is_winning then
        love.graphics.draw(self.particles, Media.screenx / 2, Media.screeny / 2)
        love.graphics.setFont(Media.fonts.large)
        love.graphics.setColor(60, 60, 60)
        love.graphics.print("You did it!", Media.screenx / 2 - 225, Media.screeny / 2 - 45)
        love.graphics.setColor(255, 150, 150)
        love.graphics.print("You did it!", Media.screenx / 2 - 230, Media.screeny / 2 - 50)
    end

    love.graphics.setFont(Media.fonts.menu)
    love.graphics.setColorMode('modulate')
    love.graphics.setColor(60, 60, 60)
    love.graphics.print(Levels.levelno, 15, 15)
    love.graphics.setColor(255, 150, 150)
    love.graphics.print(Levels.levelno, 10, 10)
end

function render()
    local level = Levels.level
    local player = level.player
    love.graphics.setColorMode('replace')

    for y = 1, level.tiles_y do
        for x = 1, level.tiles_x do
            t = level.map[y][x]
            if table.find(extras, t) then
                draw_quad('grass', {x=x, y=y})
            end
            draw_quad(t, {x=x, y=y})
            for i, goal in ipairs(level.goals) do
                if x == level.tiles_x and goal.y == y then 
                    draw_quad('goal', goal)
                end
            end
            for i, block in ipairs(level.blocks) do
                if x == level.tiles_x and block.y == y then
                    draw_quad('block', block)
                end
            end
            if x == level.tiles_x and player.y == y then
                draw_quad('player', player)
            end
        end
    end
end

function rescale()
    local ratiox = Media.screenx / (Levels.level.tiles_x * Media.tilex)
    local ratioy = Media.screeny / (Levels.level.tiles_y * Media.tiley_a)
    camera.zoom = math.min(ratiox, ratioy) * .9
    offsetx = (Media.screenx - (Levels.level.tiles_x * Media.tilex) * camera.zoom) / 2
    offsety = (Media.screeny - (Levels.level.tiles_y * Media.tiley_a) * camera.zoom) / 2 + Media.height_offset
end

local function next_level()
    main.is_winning = true
    main.particles:start()
    Media:play_sound('goal')
    Timer.do_for(3, function(dt)

        end, function()
        main.is_winning = false
        main.particles:reset()
        main.particles:stop()
        Levels:next_level()
        rescale()
        Media:next_song()
    end)
end

function main:keypressed(key)
    if self.is_winning then return end

    if key == 'escape' then
        Gamestate.switch(menu)
    elseif key == 'w' then
        Gamestate.switch(win)
    elseif key == ' ' then
        next_level()
    elseif key == 'up' then
        Levels:move(0, -1, next_level)
    elseif key == 'down' then
        Levels:move(0, 1, next_level)
    elseif key == 'left' then
        Levels:move(-1, 0, next_level)
    elseif key == 'right' then
        Levels:move(1, 0, next_level)
    end
end

menu = Gamestate.new()

function menu:init()
    self.menu_level = Levels:load_level('levels/menu.txt')
    Media:start_music()
end

function menu:enter(previous)
    self.menu_rot = 0
    self.menu_dir = 1
    self.menu_max_angle = math.pi / 15
    self.menu_speed = .65
    self.switching = false
    self.selection = 2
    self.font_zoom = 1
    self.hue = 0
    self.player = {x = 6, y = 3}
    self.blocks = {
        {x=4, y=4},
        {x=6, y=4},
        {x=8, y=4}
    }
    self.hearts = {
        {x=100, y=80},
        {x=100, y=680},
        {x=1100, y=80},
        {x=1100, y=680}
    }
end

function menu:leave(previous)
end

function menu:update(dt)
    Timer.update(dt)
    Stars.update(dt)
    self.hue = self.hue + dt * 50
    
    if self.switching then return end

    if self.menu_rot > self.menu_max_angle or self.menu_rot < -self.menu_max_angle then
        self.menu_rot = self.menu_max_angle * self.menu_dir
        self.menu_dir = -self.menu_dir
    end
    self.menu_rot = self.menu_rot + math.pi * dt * self.menu_dir * self.menu_speed
end

function menu:print(text, x, y, selection, shadow)
    local sel = selection == self.selection
    local zoom = sel and self.font_zoom or 1
    love.graphics.setColor(60, 60, 60)
    love.graphics.print(text, x, y, sel and self.menu_rot or 0,
                        zoom, zoom, 13 * #text, 20)
    love.graphics.setColor(255, 150, 150)
    love.graphics.print(text, x - 5, y - 5, sel and self.menu_rot or 0,
                        zoom, zoom, 13 * #text, 20)
end

function menu:draw()
    love.graphics.push()

    love.graphics.setBackgroundColor(HSL(self.hue % 255, 200, 200))
    love.graphics.setColorMode('replace')
    Stars.draw()

    love.graphics.translate(50, 140)

    for y = 1, self.menu_level.tiles_y do
        for x = 1, self.menu_level.tiles_x do
            t = self.menu_level.map[y][x]
            if table.find(extras, t) then
                draw_quad('grass', {x=x, y=y})
            end
            draw_quad(t, {x=x, y=y})
        end
    end
    draw_quad('goal', {x=4, y=5})
    draw_quad('goal', {x=6, y=5})
    draw_quad('goal', {x=8, y=5})
    for _, block in ipairs(self.blocks) do
        draw_quad('block', block)
    end
    draw_quad('player', self.player)

    love.graphics.setColorMode('modulate')
    love.graphics.setFont(Media.fonts.menu)
    self:print('Levels', 350, 375, 1)
    self:print('Play', 555, 375, 2)
    self:print('Quit', 750, 375, 3)

    love.graphics.pop()

    for _, heart in ipairs(self.hearts) do
        love.graphics.draw(Media.heart, heart.x, heart.y, self.menu_rot, 1, 1, 50, 50)
    end
end

function menu:levels()
    self.player = {x = 6, y = 3}
    self.blocks[1].y = 4
    self.font_zoom = 1
    self.selection = 2
    self.switching = false
end

function menu:keypressed(key)
    if key == ' ' then
        Gamestate.switch(main)
    end
    if key == 'left' or key == 'right' then
        local dir = key == 'left' and -1 or 1
        new_selection = self.selection + dir
        if new_selection >= 1 and new_selection <= 3 then
            Media:play_sound('menu')
            self.selection = new_selection
            self.player.x = self.player.x + dir * 2
        end
    end
    if key == 'down' then
        self.player.y = self.player.y + 1
        self.blocks[self.selection].y = self.blocks[self.selection].y + 1
        local selection = self.selection
        self.switching = true
        if selection == 1 then
            --
        elseif selection == 2 then
            love.audio.stop()
            Media:play_sound('play')
            Media:next_song()
        elseif selection == 3 then
            love.audio.stop()
            Media:play_sound('quit')
        end

        Timer.add(2, function()
            if selection == 1 then self:levels() end
            if selection == 2 then Gamestate.switch(main) end
            if selection == 3 then love.event.push('quit') end
        end)
        Timer.do_for(2, function(dt)
            self.font_zoom = self.font_zoom * (1 + .03)
        end, function() end)
    end
end

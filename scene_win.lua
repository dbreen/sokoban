
win = Gamestate.new()

function win:init()
    self.menu_level = Levels:load_level('levels/win.txt')
end

function win:enter(previous)
    self.hue = 0
    self.winscale = 1
    self.windir = 1
    self.rot = 0
    self.rot_vel = 1.3
    self.num_hearts = 16
    self.player = {x = 6, y = 5}
end

function win:update(dt)
    self.rot = self.rot + self.rot_vel * dt
    Stars.update(dt)
    self.hue = self.hue + dt * 50
    if self.winscale >= 1.5 then
        self.winscale = 1.5
        self.windir = -self.windir
    end
    if self.winscale <= .8 then
        self.winscale = .8
        self.windir = -self.windir
    end
    self.winscale = self.winscale + 2.5 * dt * self.windir
end

function win:draw()
    love.graphics.setBackgroundColor(HSL(self.hue % 255, 200, 200))
    love.graphics.setColorMode('replace')
    Stars.draw()

    love.graphics.push()
    love.graphics.translate(50, 150)

    for y = 1, self.menu_level.tiles_y do
        for x = 1, self.menu_level.tiles_x do
            t = self.menu_level.map[y][x]
            if table.find(extras, t) then
                draw_quad('grass', {x=x, y=y})
            end
            draw_quad(t, {x=x, y=y})
        end
    end

    draw_quad('goal', self.player)
    draw_quad('player', self.player)

    love.graphics.pop()

    for i = 1, self.num_hearts do
        local d = (2*math.pi / self.num_hearts) * i
        love.graphics.draw(Media.heart,
            Media.screenx / 2 - 50 + 300 * math.sin(self.rot + d), 
            Media.screeny / 2 - 50 + 300 * math.cos(self.rot + d))
    end

    love.graphics.setColorMode('modulate')
    love.graphics.setFont(Media.fonts.large)
    love.graphics.setColor(60, 60, 60)
    love.graphics.print('YOU WIN!', 520, 300, 0, self.winscale, self.winscale, 150, 50)
    love.graphics.setColor(255, 150, 150)
    love.graphics.print('YOU WIN!', 515, 295, 0, self.winscale, self.winscale, 150, 50)
end

function win:keypressed(key)
    if key == ' ' then
        Levels:reset()
        Gamestate.switch(main)
    end
end

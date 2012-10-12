choose_level = Gamestate.new()

function choose_level:init()
    local p = love.graphics.newParticleSystem(Media.heart, 30)
    p:setDirection(3 * math.pi / 2)
    p:setGravity(200)
    p:setEmissionRate(3)
    p:setLifetime(-1)
    p:setParticleLife(5)
    p:setSpeed(500)
    p:setTangentialAcceleration(-100, 100)
    self.particles = p
end

function choose_level:enter()
    self.particles:start()
end

function choose_level:exit()
    self.particles:stop()
end

function choose_level:update(dt)
    self.particles:update(dt)
end

function choose_level:draw()
    love.graphics.setBackgroundColor(224, 176, 255)

    love.graphics.draw(self.particles, Media.screenx / 2, Media.screeny)

    love.graphics.setColorMode('modulate')
    love.graphics.setColor(245, 215, 225)
    love.graphics.setFont(Media.fonts.large)
    love.graphics.print('Come back later!', 200, 250)
    love.graphics.setFont(Media.fonts.menu)
    love.graphics.print('press escape to go back', 300, 450)
end

function choose_level:keypressed(key)
    if key == 'escape' then
        Gamestate.switch(menu)
    end
end

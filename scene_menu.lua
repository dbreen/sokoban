
menu = Gamestate.new()

function menu:init()
end

function menu:enter(previous)
end

function menu:leave(previous)
end

function menu:update(dt)
end

function menu:draw()
    love.graphics.print('MENU', 100, 100)
end

function menu:keypressed(key)
    if key == ' ' then
        Gamestate.switch(main)
    end
end

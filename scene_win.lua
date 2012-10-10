
win = Gamestate.new()

function win:enter(previous)

end

function win:update(dt)

end

function win:draw()
    love.graphics.print('WIN', 100, 100)
end

function win:keypressed(key)
    if key == ' ' then
        Levels:reset()
        Gamestate.switch(main)
    end
end

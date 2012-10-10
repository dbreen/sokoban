
Gamestate = require 'hump.gamestate'
Camera = require 'hump.camera'
require 'scene_main'
require 'scene_menu'
require 'scene_win'
require 'levels'
require 'media'

function love.load()
    love.graphics.setCaption('Sokodan')

    Media:load()
    Levels:load()

    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function table.find(t, val)
    for _, v in ipairs(t) do
        if val == v then return true end
    end
    return false
end

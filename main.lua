Gamestate = require 'hump.gamestate'
Camera = require 'hump.camera'
Timer = require 'hump.timer'
require 'utils'
require 'media'
require 'levels'
require 'scene_main'
require 'scene_menu'
require 'scene_win'

enable_music = true

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

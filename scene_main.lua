
main = Gamestate.new()
rot = 0

function main:init()
    camera = Camera()
    -- camera:lookAt(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function main:enter(previous)
    rescale()
    love.graphics.setBackgroundColor(200, 215, 225)
    Media:start_music()
end

function main:update(dt)
    Timer.update(dt)
end

local blocks = {"water", "grass", "wall", "gwall", "dirt", "stone"}
local raised = {"wall", "gwall"}
local extras = {"tree", "bush", "bug"}

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
    love.graphics.push()
    love.graphics.scale(camera.zoom)
    love.graphics.translate(offsetx, offsety)
    render()
    love.graphics.pop()
end

function render()
    local level = Levels.level
    player = level.player
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
    camera.zoom = math.min(ratiox, ratioy)
    offsetx = (Media.screenx - (Levels.level.tiles_x * Media.tilex) * camera.zoom) / 2
    offsety = (Media.screeny - (Levels.level.tiles_y * Media.tiley_a) * camera.zoom) / 2 + Media.height_offset
end

local function next_level()
    Levels:next_level()
    rescale()
    Media:next_song()
end

function main:keypressed(key)
    if key == 'esc' then
        Gamestate.switch(menu)
    end
    if key == ' ' then
        next_level()
    end
    if key == 'up' then
        Levels:move(0, -1, next_level)
    end
    if key == 'down' then
        Levels:move(0, 1, next_level)
    end
    if key == 'left' then
        Levels:move(-1, 0, next_level)
    end
    if key == 'right' then
        Levels:move(1, 0, next_level)
    end
end

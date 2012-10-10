Levels = {num_levels = 4}

function Levels:load()
    self.levels = {}
    self.levelno = 1
    for i = 1, Levels.num_levels do
        self.levels[i] = self:load_level(string.format("levels/%d.txt", i))
    end
    self.level = self.levels[1]
end

function Levels:next_level()
    self.levelno = self.levelno + 1
    if self.levelno > #self.levels then
        Gamestate.switch(win)
    end
    self.level = self.levels[self.levelno]
end

function Levels:reset()
    self.levelno = 1
    self.level = self.levels[1]
end

function Levels:load_level(file)
    local f = io.open(file)
    assert(f, "Could not find map: "..file)
    local lines = {}
    while true do
        local line = f:read()
        if line == nil then break end
        table.insert(lines, line)
    end
    f:close()
    local map, blocks, goals = {}, {}, {}
    for y, line in ipairs(lines) do
        map[y] = {}
        for x = 1, #line do
            char = line:sub(x, x)
            tile = 'grass'
            if char == '#' then
                tile = 'wall'
            elseif char == ' ' then
                tile = 'grass'
            elseif char == 'D' then
                tile = 'dirt'
            elseif char == 'S' then
                tile = 'stone'
            elseif char == '@' then
                tile = 'gwall'
            elseif char == '^' then
                tile = 'tree'
            elseif char == '*' then
                tile = 'bush'
            elseif char == 'B' then
                tile = 'bug'
            elseif char == '~' then
                tile = 'water'
            elseif char == 'P' then
                player = {x = x, y = y}
            elseif char == 'X' then
                table.insert(blocks, {x = x, y = y})
            elseif char == 'O' then
                table.insert(goals, {x = x, y = y})
            else
                assert(false, 'Map '..file..' has an unknown map character: '..char)
            end
            map[y][x] = tile
        end
    end
    assert(player, 'Map '..file..' did not specify a player position')
    assert(#blocks == #goals, 'Map '..file..' must have the same # of blocks as goals')
    return {
        map = map, player = player,
        goals = goals, blocks = blocks,
        tiles_x = #map[1], tiles_y = #map
    }
end

function Levels:goal_at(x, y)
    for i, goal in ipairs(self.level.goals) do
        if goal.x == x and goal.y == y then return true end
    end
    return false
end

function Levels:get_at(x, y)
    level = self.level
    if level.player.x == x and level.player.y == y then return 'player' end
    for i, block in ipairs(level.blocks) do
        if block.x == x and block.y == y then return 'block' end
    end
    for i, goal in ipairs(level.goals) do
        if goal.x == x and goal.y == y then return 'goal' end
    end
    if level.map[y][x] == 'grass' then return 'empty' end
    return 'wall'
end

function Levels:move_block(x, y, dx, dy)
    for i, block in ipairs(self.level.blocks) do
        if block.x == x and block.y == y then
            block.x = block.x + dx
            block.y = block.y + dy
        end
    end
end

function Levels:complete()
    for i, block in ipairs(self.level.blocks) do
        if not self:goal_at(block.x, block.y) then return false end
    end
    return true
end

function Levels:move(dx, dy, go_next)
    level = self.level
    local newx, newy = level.player.x + dx, level.player.y + dy
    local move = false
    local object = self:get_at(newx, newy)
    if object == 'empty' or object == 'goal' then
        move = true
    elseif object == 'block' then
        local after_block = self:get_at(newx + dx, newy + dy)
        if after_block == 'empty' or after_block == 'goal' then
            move = true
            self:move_block(newx, newy, dx, dy)
        end
    end
    if move then
        level.player.x = level.player.x + dx
        level.player.y = level.player.y + dy
        if dx ~= 0 and self.last_dx ~= dx then 
            Media.player:flip(true, false)
            self.last_dx = dx
        end
        if self:complete() then
            go_next()
        end
    end
end

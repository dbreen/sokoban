Media = {}
--Media.__index = Media

function Media:create_tile(x, y, size_x, size_y)
    return love.graphics.newQuad(x * size_x, y * size_y + 1, size_x, size_y, self.tiles:getWidth(), self.tiles:getHeight())
end

function Media:load()
    self.tilex, self.tiley = 101, 171
    self.height_top = 40
    self.height_offset = 90
    self.tiley_a = self.tiley - self.height_offset
    self.screenx, self.screeny = love.graphics.getWidth(), love.graphics.getHeight()

    self.tiles = love.graphics.newImage('media/images/tiles.png')
    self.grass = self:create_tile(1, 7, self.tilex, self.tiley)
    self.tree = self:create_tile(5, 7, self.tilex, self.tiley)
    self.bush = self:create_tile(5, 6, self.tilex, self.tiley)
    self.wall = self:create_tile(6, 5, self.tilex, self.tiley)
    self.gwall = self:create_tile(5, 5, self.tilex, self.tiley)
    self.water = self:create_tile(6, 3, self.tilex, self.tiley)
    self.player = self:create_tile(0, 2, self.tilex, self.tiley)
    self.block = self:create_tile(2, 7, self.tilex, self.tiley)
    self.block_goal = self:create_tile(4, 0, self.tilex, self.tiley)
    self.goal = self:create_tile(4, 0, self.tilex, self.tiley)

    self.music = {
        love.audio.newSource('media/music/pinball-spring.mp3'),
        love.audio.newSource('media/music/presenterator.mp3'),
        love.audio.newSource('media/music/silly-fun.mp3')
    }
end

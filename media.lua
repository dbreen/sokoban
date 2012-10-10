Media = {}

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
    self.dirt = self:create_tile(1, 0, self.tilex, self.tiley)
    self.stone = self:create_tile(2, 5, self.tilex, self.tiley)
    self.tree = self:create_tile(5, 7, self.tilex, self.tiley)
    self.bug = self:create_tile(1, 3, self.tilex, self.tiley)
    self.bush = self:create_tile(5, 6, self.tilex, self.tiley)
    self.wall = self:create_tile(6, 5, self.tilex, self.tiley)
    self.gwall = self:create_tile(5, 5, self.tilex, self.tiley)
    self.water = self:create_tile(6, 3, self.tilex, self.tiley)
    self.player = self:create_tile(0, 2, self.tilex, self.tiley)
    self.block = self:create_tile(2, 7, self.tilex, self.tiley)
    self.block_goal = self:create_tile(4, 0, self.tilex, self.tiley)
    self.goal = self:create_tile(4, 0, self.tilex, self.tiley)
    self.star = love.graphics.newImage('media/images/star.png')

    self.music = {
        love.audio.newSource('media/music/pinball-spring.mp3'),
        love.audio.newSource('media/music/presenterator.mp3'),
        love.audio.newSource('media/music/silly-fun.mp3')
    }
    for _, song in ipairs(self.music) do
        song:setVolume(.5)
    end
    self.sounds = {
        chimes = love.audio.newSource('media/sounds/chimes.mp3', 'static'),
        goal = love.audio.newSource('media/sounds/goal.mp3', 'static'),
        menu = love.audio.newSource('media/sounds/menu.mp3', 'static'),
        play = love.audio.newSource('media/sounds/play.wav', 'static'),
        quit = love.audio.newSource('media/sounds/quit.wav', 'static')
    }
    self.current_song = 1

    self.fonts = {
        menu = love.graphics.newFont('media/fonts/floralies.ttf', 48)
    }
end

function Media:start_music()
    if enable_music then
        love.audio.play(self.music[self.current_song])
    end
end

function Media:next_song()
    local volume = 1
    Timer.do_for(2, function(dt)
        volume = volume - .01
        love.audio.setVolume(volume)
    end, function()
        love.audio.stop()
        love.audio.setVolume(1)
        self.current_song = self.current_song + 1
        if self.current_song > #self.music then self.current_song = 1 end
        self:start_music()
    end)
end

function Media:play_sound(sound)
    love.audio.play(self.sounds[sound])
end

require 'Util'

require 'Player'

Map = class{}

TILE_BRICK = 1
TILE_EMPTY = -1
SKY = 4

CLOUD_LEFT = 6
CLOUD_RIGHT = 7

BUSH_LEFT = 2
BUSH_RIGHT = 3

PIPE_TOP = 10
PIPE_BOTTOM = 11

JUMP_BLOCK = 5
JUMP_BLOCK_HIT = 9

FLAG_POLE1 = 8 
FLAG_POLE2 = 12
FLAG_POLE3 = 16
FLAG1 = 13
FLAG2 = 14
FLAG3 = 15


local SCROLL_SPEED = 200

function Map:init()
    self.spritesheet = love.graphics.newImage('spritesheet1.png')
    self.moon = love.graphics.newImage('moon.png')
    self.sprites = generateQuads(self.spritesheet, 16, 16)
    self.moonpic = generateQuads(self.moon, 50,50)
    self.music = love.audio.newSource('theme.mp3', 'static')
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 200
    self.mapHeight = 28
    self.tiles = {}

    self.player = Player(self)

    self.camX = 0
    self.camY = 0

    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    

    

    for y = 1 , self.mapHeight /2 do
        for x = 1, self.mapWidth do
            self:setTile(x,y,TILE_EMPTY)
        end
    end

    
    for y = self.mapHeight/2 -6 , self.mapHeight/2  do
        for x = 130, 135  do
            self:setTile(x,y,TILE_BRICK)
            self:setTile(130,y-2,TILE_EMPTY)
            self:setTile(131,y-3,TILE_EMPTY)
            self:setTile(132,y-4,TILE_EMPTY)
            self:setTile(133,y-5,TILE_EMPTY)
            self:setTile(134,y-6,TILE_EMPTY)
        end
    end
    
    for y = self.mapHeight / 2 , self.mapHeight do
        for x = 1, self.mapWidth do
            self:setTile(x,y,TILE_BRICK)
        end
    end



    for y = self.mapHeight / 2 - 1 , self.mapHeight / 2 - 1 do
        for x = 1, self.mapWidth do
            self:setTile(15,y, PIPE_BOTTOM)
            self:setTile(15,y-1,PIPE_BOTTOM)
            self:setTile(15,y-2, PIPE_TOP)
            self:setTile(25,y, PIPE_BOTTOM)
            self:setTile(25,y-1,PIPE_BOTTOM)
            self:setTile(25,y-2, PIPE_TOP)
            self:setTile(45,y, PIPE_BOTTOM)
            self:setTile(45,y-1,PIPE_BOTTOM)
            self:setTile(45,y-2, PIPE_TOP)
            self:setTile(60,y, PIPE_BOTTOM)
            self:setTile(60,y-1,PIPE_BOTTOM)
            self:setTile(60,y-2, PIPE_TOP)
            self:setTile(75,y, PIPE_BOTTOM)
            self:setTile(75,y-1,PIPE_BOTTOM)
            self:setTile(75,y-2, PIPE_TOP)
            self:setTile(90,y, PIPE_BOTTOM)
            self:setTile(90,y-1,PIPE_BOTTOM)
            self:setTile(90,y-2, PIPE_TOP)
            self:setTile(110,y, PIPE_BOTTOM)
            self:setTile(110,y-1,PIPE_BOTTOM)
            self:setTile(110,y-2, PIPE_TOP)
            self:setTile(123,y, PIPE_BOTTOM)
            self:setTile(123,y-1,PIPE_BOTTOM)
            self:setTile(123,y-2, PIPE_TOP)
        end
    end

    for y = self.mapHeight / 2 - 1, self.mapHeight / 2 -1 do
        for x = 197 , 197 do
            self:setTile(x,y,FLAG_POLE3)
            self:setTile(x,y-1,FLAG_POLE2)
            self:setTile(x,y-2,FLAG_POLE1)
        end 
    end

    for y = self.mapHeight / 2 - 3, self.mapHeight / 2 -3 do
        for x = 197 , 197 do
            self:setTile(x+1,y ,FLAG1)
        end 
    end

    for y = self.mapHeight / 2 - 1 , self.mapHeight / 2 - 1 do
        for x = 1, self.mapWidth do
            self:setTile(10,y, BUSH_LEFT)
            self:setTile(11,y, BUSH_RIGHT)
            self:setTile(26,y, BUSH_LEFT)
            self:setTile(27,y, BUSH_RIGHT)
            self:setTile(32,y, BUSH_LEFT)
            self:setTile(33,y, BUSH_RIGHT)
            self:setTile(41,y, BUSH_LEFT)
            self:setTile(42,y, BUSH_RIGHT)
            self:setTile(71,y, BUSH_LEFT)
            self:setTile(72,y, BUSH_RIGHT)
            self:setTile(80,y, BUSH_LEFT)
            self:setTile(81,y, BUSH_RIGHT)
            self:setTile(85,y, BUSH_LEFT)
            self:setTile(86,y, BUSH_RIGHT)
            self:setTile(100,y, BUSH_LEFT)
            self:setTile(101,y, BUSH_RIGHT)
            self:setTile(120,y, BUSH_LEFT)
            self:setTile(121,y, BUSH_RIGHT)
            self:setTile(177,y, BUSH_LEFT)
            self:setTile(178,y, BUSH_RIGHT)
            self:setTile(185,y, BUSH_LEFT)
            self:setTile(186,y, BUSH_RIGHT)
            self:setTile(142,y, BUSH_LEFT)
            self:setTile(143,y, BUSH_RIGHT)
        end
    end

    


    for y = self.mapHeight / 2 - 5 , self.mapHeight / 2 - 5 do
        for x = 1, self.mapWidth do
            self:setTile(20,y-2, JUMP_BLOCK)
            self:setTile(21,y-2, JUMP_BLOCK)
            self:setTile(30,y-3, JUMP_BLOCK)
            self:setTile(51,y-2, JUMP_BLOCK)
            self:setTile(50,y-2, JUMP_BLOCK)
            self:setTile(65,y, JUMP_BLOCK)
            self:setTile(66,y, JUMP_BLOCK)
            self:setTile(128,y, JUMP_BLOCK)
            self:setTile(129,y, JUMP_BLOCK)
            self:setTile(151,y, JUMP_BLOCK)
            self:setTile(152,y, JUMP_BLOCK)
            self:setTile(155,y-1, JUMP_BLOCK)
            self:setTile(156,y-1, JUMP_BLOCK)
            self:setTile(160,y-3, JUMP_BLOCK)
            self:setTile(161,y-3, JUMP_BLOCK)
            self:setTile(162,y-3, JUMP_BLOCK)
            self:setTile(165,y, JUMP_BLOCK)
            
            
            


         end
    end

    for y = self.mapHeight / 2  , self.mapHeight  do
        for x = 1, self.mapWidth do
            self:setTile(48,y, TILE_EMPTY)
            self:setTile(49,y, TILE_EMPTY)
            self:setTile(50,y, TILE_EMPTY)
            self:setTile(51,y, TILE_EMPTY)
            self:setTile(52,y, TILE_EMPTY)
            self:setTile(53,y, TILE_EMPTY)
            self:setTile(54,y, TILE_EMPTY)
            self:setTile(65,y, TILE_EMPTY)
            self:setTile(66,y, TILE_EMPTY)
            self:setTile(67,y, TILE_EMPTY)
            self:setTile(68,y, TILE_EMPTY)
            self:setTile(126,y, TILE_EMPTY)
            self:setTile(127,y, TILE_EMPTY)
            self:setTile(128,y, TILE_EMPTY)
            self:setTile(129,y, TILE_EMPTY)
          

         end
    end
    for y = self.mapHeight / 2  , self.mapHeight  do
        for x = 150, 170 do
            self:setTile(x,y, TILE_EMPTY)
        end
    end

    self.music:setLooping(true)
    self.music:setVolume(0.25)
    self.music:play()
end


function Map:collides(tile)
    -- define our collidable tiles
    local collidables = {
        TILE_BRICK, JUMP_BLOCK, JUMP_BLOCK_HIT,
        PIPE_TOP, PIPE_BOTTOM
    }

    -- iterate and return true if our tile type matches
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end

-- function to update camera offset with delta time
function Map:update(dt)
    self.player:update(dt)
    self.player:reset()
    
    -- keep camera's X coordinate following the player, preventing camera from
    -- scrolling past 0 to the left and the map's width
    self.camX = math.max(0, math.min(self.player.x - VIRTUAL_WIDTH / 2,
        math.min(self.mapWidthPixels - VIRTUAL_WIDTH, self.player.x)))
end

-- gets the tile type at a given pixel coordinate
function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
    }
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, id)
    self.tiles[(y - 1) * self.mapWidth + x] = id
end




function Map:render()

    for y = 10,10 do
        for x = self.mapWidthPixels /2, self.mapWidthPixels/2 do
            love.graphics.draw(self.moon,self.moonpic[1], x , y)
        end
    end
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            local tile = self:getTile(x, y)
            if tile ~= TILE_EMPTY then
                love.graphics.draw(self.spritesheet, self.sprites[tile],
                    (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
            end
        end
    end


    self.player:render()
end


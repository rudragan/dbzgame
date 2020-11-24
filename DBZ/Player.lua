require 'Animation'


Player = class{}

local MOVE_SPEED = 100
local JUMP_VELOCITY = 400
local GRAVITY = 15


function Player:init(map)
    self.width = 36
    self.height = 57

    self.x = map.tileWidth * 1
    self.y = map.tileHeight * (map.mapHeight / 2 - 1) - self.height


    self.dx = 0
    self.dy = 0


    self.map = map

    self.currentFrame = nil

    self.texture = love.graphics.newImage('goku.png')

    largeFont = love.graphics.newFont('font.ttf', 16)
    smallFont = love.graphics.newFont('font.ttf',8)

    self.sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['hit'] = love.audio.newSource('hit.mp3', 'static')
    }
        
    self.frames = generateQuads(self.texture, 36,57)

    self.state = 'idle'

    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[8]
            },
            interval = 1
        },
        ['forward'] = Animation {
            texture =self.texture,
            frames = {
                self.frames[5]
            },
            interval = 1
        },
        ['backward'] = Animation{
            texture = self.texture,
            frames = {
                self.frames[1]
            },
            insterval = 1
        },
        ['jumping'] = Animation{
            texture = self.texture,
            frames = {
                self.frames[3]
            },
            interval = 1
        },
        ['jumpfront'] = Animation{
            texture = self.texture,
            frames = {
                self.frames[4]
            },
            interval = 1
        },
        ['jumpback'] = Animation{
            texture = self.texture,
            frames = {
                self.frames[2]
            },
            interval = 1
        },
        ['duck'] = Animation{
            texture = self.texture,
            frames = {
                self.frames[6]
            },
            interval = 1
        },
        ['win'] =Animation{
            texture = self.texture,
            frames = {
                self.frames[7]
            },
            interval= 1
        }
    }

    self.animation = self.animations['idle']
    

    self.behaviors = {
        ['idle'] = function(dt)
            if love.keyboard.wasPressed('w') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['jumping']
                self.sounds['jump']: play()
            elseif love.keyboard.isDown('a') then
                self.dx= - MOVE_SPEED
                self.state = 'backward'
                self.animation = self.animations['backward']
            elseif love.keyboard.isDown('d') then
                self.dx = MOVE_SPEED * 1.5
                self.state = 'forward'
                self.animation = self.animations['forward']
            elseif love.keyboard.isDown('s') then
                self.dx = 0
                self.animation = self.animations['duck']
            elseif self.y == self.map.tileHeight * (self.map.mapHeight / 2 - 1) - self.height and self.x == self.map.tileWidth * 195 or self.x == self.map.tileWidth * 196 or self.x == self.map.tileWidth * 197 then
                self.dy = 0
                self.dx = 0
                self.state = 'win'
                self.animation = self.animations['win']
        
            else
                self.dx=0
                self.animation = self.animations['idle']
            end
        end,
        ['forward'] = function(dt)
            if love.keyboard.wasPressed('w') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['jumping']
                self.sounds['jump']: play()
            elseif love.keyboard.isDown('d') then
                self.dx = MOVE_SPEED * 2.2
                self.animation = self.animations['forward']
            elseif love.keyboard.isDown('s') then
                self.dx = 0
                self.animation = self.animations['duck']
            elseif self.y == self.map.tileHeight * (self.map.mapHeight / 2 - 1) - self.height and self.x == self.map.tileWidth * 195 or self.x == self.map.tileWidth * 196 or self.x == self.map.tileWidth *197 then
                self.dy = 0
                self.dx = 0
                self.state = 'win'
                self.animation = self.animations['win']
            else
                self.dx=0
                self.state = 'idle'
                self.animation = self.animations['idle']
            end

            self:checkRightCollision()
            self:checkLeftCollision()

            -- check if there's a tile directly beneath us
            if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) and
                not self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                
                -- if so, reset velocity and position and change state
                self.state = 'jumping'
                self.animation = self.animations['jumping']
            end


        end,
        ['backward'] = function(dt)
            if love.keyboard.wasPressed('w') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['jumping']
                self.sounds['jump']: play()
            elseif love.keyboard.isDown('a') then
                self.dx= - MOVE_SPEED
                self.animation = self.animations['backward']
            elseif love.keyboard.isDown('s') then
                self.dx = 0
                self.animation = self.animations['duck']
            elseif self.y == self.map.tileHeight * (self.map.mapHeight / 2 - 1) - self.height and self.x == self.map.tileWidth * 195 or self.x == self.map.tileWidth * 196 or self.x == self.map.tileWidth * 197 then
                self.dy = 0
                self.dx = 0
                self.state = 'win'
                self.animation = self.animations['win']
            else
                self.dx=0
                self.state = 'idle'
                self.animation = self.animations['idle']
            end

            self:checkRightCollision()
            self:checkLeftCollision()

            -- check if there's a tile directly beneath us
            if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) and
                not self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                
                -- if so, reset velocity and position and change state
                self.state = 'jumping'
                self.animation = self.animations['jumping']
            end

        end,
        ['jumping'] = function(dt)
            if love.keyboard.isDown('a') then
                self.dx = -MOVE_SPEED 
                self.animation = self.animations['jumpback']
            elseif love.keyboard.isDown('d') then
                self.dx = MOVE_SPEED * 1.5
                self.animation = self.animations['jumpfront']
            elseif self.y == self.map.tileHeight * (self.map.mapHeight / 2 - 1) - self.height and self.x == self.map.tileWidth * 195 or self.x == self.map.tileWidth * 196 or self.x == self.map.tileWidth * 197 then
                self.dy = 0
                self.dx = 0
                self.state = 'win'
                self.animation = self.animations['win']
          
            end

            self.dy = self.dy + GRAVITY

            
            

            if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
                
                -- if so, reset velocity and position and change state
                self.dy = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
                self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * self.map.tileHeight - self.height
            end

            -- check for collisions moving left and right
            self:checkRightCollision()
            self:checkLeftCollision()
        end,
        ['ducking'] = function(dt)
            if love.keyboard.wasPressed('w') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['jumping']
            elseif love.keyboard.isDown('a') then
                self.dx= - MOVE_SPEED
                self.animation = self.animations['backward']
            elseif love.keyboard.isDown('d') then
                self.dx = MOVE_SPEED * 1.5
                self.animation = self.animations['forward']
            elseif self.y == self.map.tileHeight * (self.map.mapHeight / 2 - 1) - self.height and self.x == self.map.tileWidth * 195 or self.x == self.map.tileWidth * 196 or self.x == self.map.tileWidth * 197 then
                self.dy = 0
                self.dx = 0
                self.state = 'win'
                self.animation = self.animations['win']
            else
                self.dx=0
                self.animation = self.animations['duck']
            end
        end,
        ['win'] = function(dt)
            if self.y == self.map.tileHeight * (self.map.mapHeight / 2 - 1) - self.height and self.x == self.map.tileWidth * 195 or self.x == self.map.tileWidth * 196 or self.x == self.map.tileWidth * 197 then
                self.dy = 0
                self.dx = 0
                self.state = 'win'
                self.animation = self.animations['win']
            end
        end

    }
end
function Player:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.x = math.max(0,math.floor(self.x + self.dx * dt))

    -- if we have negative y velocity (jumping), check if we collide
    -- with any blocks above us
    if self.dy < 0 then
        if self.map:tileAt(self.x, self.y).id ~= TILE_EMPTY or
            self.map:tileAt(self.x + self.width - 1, self.y).id ~= TILE_EMPTY then
            -- reset y velocity
            self.dy = 0

            -- change block to different block
            if self.map:tileAt(self.x, self.y).id == JUMP_BLOCK then
                self.map:setTile(math.floor(self.x / self.map.tileWidth) + 1,
                    math.floor(self.y / self.map.tileHeight) + 1, JUMP_BLOCK_HIT)
                    self.sounds['hit']: play()
            end
            if self.map:tileAt(self.x + self.width - 1, self.y).id == JUMP_BLOCK then
                self.map:setTile(math.floor((self.x + self.width - 1) / self.map.tileWidth) + 1,
                    math.floor(self.y / self.map.tileHeight) + 1, JUMP_BLOCK_HIT)
                    self.sounds['hit']: play()
            end
        end
    end

    -- apply velocity
    self.y = self.y + self.dy * dt

end

    

 

function Player:checkLeftCollision()
    if self.dx < 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
            self.map:collides(self.map:tileAt(self.x - 1, self.y + self.height - 1)) then
            
            -- if so, reset velocity and position and change state
            self.dx = 0
            self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth
        end
    end
end

-- checks two tiles to our right to see if a collision occurred
function Player:checkRightCollision()
    if self.dx > 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width, self.y + self.height - 1)) then
            
            -- if so, reset velocity and position and change state
            self.dx = 0
            self.x = (self.map:tileAt(self.x + self.width, self.y).x - 1) * self.map.tileWidth - self.width
        end
    end
end

function Player:reset()
    if self.y > map.tileHeight * (map.mapHeight / 2 - 1) - self.height + 100 then
        self.x = map.tileWidth * 1
        self.y = map.tileHeight * (map.mapHeight / 2 - 1) - self.height
    end

    if self.state == 'win' then 
        if love.keyboard.isDown('space') then
            self.x = map.tileWidth * 1
            self.y = map.tileHeight * (map.mapHeight / 2 - 1) - self.height
            self.state = 'idle'
        end
    end
end
    


function Player:render()
    love.graphics.draw(self.texture,self.currentFrame,math.floor(self.x),math.floor(self.y))
    
    if self.state == 'win' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('You Win!',
            self.x - 100, self.y - 65 , VIRTUAL_WIDTH)
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Space To Restart!',
            self.x - 130 , self.y - 50 , VIRTUAL_WIDTH)
    end
end
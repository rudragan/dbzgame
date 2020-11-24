WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'

class = require 'class'
require 'Util'
require 'Map'
require 'Player'



function love.load()
    
    math.randomseed(os.time())

    largeFont = love.graphics.newFont('font.ttf', 16)
    smallFont = love.graphics.newFont('font.ttf',8)

    map = Map()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        resizable = false
    })


    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}

    love.window.setTitle("Goku's Adventure")
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end



function love.keyboard.wasReleased(key)
    return love.keyboard.keysReleased[key]
end


function love.update(dt)
    map:update(dt)

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
end

function love.draw()
    push:apply('start')
    love.graphics.translate(math.floor(-map.camX),math.floor(-map.camY))
    love.graphics.clear(0,0,0,1)
    map:render()
    push:apply('end')
end



function generateQuads(atlas, tileWidth, tileHeight)
    local sheetwidth = atlas:getWidth() / tileWidth
    local sheetheight = atlas:getHeight()/ tileHeight

    local sheetCounter = 1
    local quads = {}
    for y = 0 , sheetheight - 1 do
        for x = 0 , sheetwidth -  1 do
            quads[sheetCounter] = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())

            sheetCounter = sheetCounter + 1
        end
    end

    return quads

end
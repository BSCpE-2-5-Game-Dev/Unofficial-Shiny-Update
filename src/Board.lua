Board = Class{}

function Board:init(x, y)
    self.x = x
    self.y = y
    self.matches = {}
    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.random(6)))
        end
    end

    while self:calculateMatches() do

        self:initializeTiles()
    end
end

function Board:calculateMatches()
    local matches = {}
    local matchNum = 1

    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        for x = 2, 8 do
    
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color
                if matchNum >= 3 then
                    local match = {}
                    local deleteRow = false

                    for x2 = x - 1, x - matchNum, -1 do
                        if self.tiles[y][x2].shiny then  
                            deleteRow = true 
                            break
                        end 
                    end

                    if deleteRow then
                        match = self:deleteRow(y)
                    else
                        for x2 = x - 1, x- matchnum, -1 do
                            table.insrt(match, self.tiles[y][x2])

                        end
                    end
                    table.insert(matches, match)
                end

                matchNum = 1
                if x >= 7 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}
            local deleteRow = false

            for x = 8, 8 - matchNum + 1, -1 do
                if self.tiles[y][x].shiny then  
                    deleteRow = true 
                    break
                end
            end

            if deleteRow then
                match = self:deleteRow(y)
            else
                for x = 8, 8 - matchNum + 1, -1 do
                    table.insert(match, self.tiles[y][x])
                end
            end
            table.insert(matches, match)
        end
    end

    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}
                    local deleteCol = false

                    for y2 = y - 1, y - matchNum, -1 do
                        if self.tiles[y2][x].shiny then  
                            deleteCol = true 
                            break
                        end
                    end
                    if deleteCol then
                        match = self:deleteCol(x)
                    else
                        for y2 = y - 1, y- matchnum, -1 do
                            table.insert(match, self.tiles[y2][x])
                        end
                    end
                    table.insert(matches, match)
                end

                matchNum = 1

                if y >= 7 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}
            local deleteCol = false
            
            for y = 8, 8 - matchNum + 1, -1 do
                if self.tiles[y][x].shiny then  
                    deleteRow = true 
                    break
                end
            end
            if deleteCol then
                match = self:deleteCol(x)
            else
                for y = 8, 8 - matchNum + 1, -1 do
                    table.insert(match, self.tiles[y][x])
                end
            end

            table.insert(matches, match)
        end
    end

    self.matches = matches

    return #self.matches > 0 and self.matches or false
end

function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

function Board:getFallingTiles()
    local tweens = {}
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
      
            local tile = self.tiles[y][x]
            
            if space then
        
                if tile then
            
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    self.tiles[y][x] = nil

             
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    space = false
                    y = spaceY

                    spaceY = 0
                end
            elseif tile == nil then
                space = true

                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            if not tile then

                local tile = Tile(x, y, math.random(18), math.random(6))
                tile.y = -32
                self.tiles[y][x] = tile

                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:deleteRow(y)
    local match = {}
    for x = 1, 8 do
        table.insert(match, self.tiles[y][x])
    end
    
    return match
end

function Board:deleteCol(x)
    local match = {}
    for y = 1, 8 do
        table.insert(match, self.tiles[y][x])
    end
    
    return match
end

function Board:update(dt)
    for y = 1
    for x = 1
        self.tiles[y][x]:update(dt)
    end 
end 

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end
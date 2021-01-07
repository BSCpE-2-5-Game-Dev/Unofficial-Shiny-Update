Tile = Class{}

function Tile:init(x, y, color, variety)
    
    self.gridX = x
    self.gridY = y
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    self.color = color
    self.variety = variety
    self.shiny = (math.random(100) <= 5)

    self.psystem = love.graphics.newParticleSystem(gTextures['particles'], 32)
    self.psystem:setParticleLifetime(1,5)

    self.psystem:setAreaSpread('normal', 6, 6)

    self.psystem:setColors(251, 242, 54, 100, 251, 242, 54, 0)
    if self.shiny then
       Timer.every(0.1, function()
         self.self.psystem:emit(32)
        end)
    end
end

function Tile:update(dt)
    self.psystem.update(dt)
end

function Tile:render(x, y)
    
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)

    if self.shiny then
        love.graphics.draw(self.psystem, self.x + x + 16, self.y + y + 16)
    end
end
    
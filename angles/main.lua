local vector = require "../vector"

local pi = 3.14159265359
local tau = pi*2

function love.load()
  love.window.setMode(1024, 768, { fullscreen = true })
end

function love.draw()
  numPoints = math.floor(love.mouse.getX() / love.graphics.getWidth() * 1000)
  pointSize = math.floor(love.mouse.getY() / love.graphics.getHeight() * 100)

  centerX = love.graphics.getWidth() / 2
  centerY = love.graphics.getHeight() / 2

  love.graphics.setColor(1, .5, 0)

  a = tau / numPoints
  at = 0
  for i = 1, numPoints do
    love.graphics.circle('fill', centerX + math.cos(at) * 400, centerY + math.sin(at) * 400, pointSize)
    at = at + a
  end
end

function love.keypressed(key, scancode)
  if key == "escape" or key == "q" then
    love.event.quit()
  end
end

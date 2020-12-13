local vector = require "../vector"

function love.load()
  love.window.setMode(1024, 768, { fullscreen = true })
  love.mouse.setVisible(false)

  circlePos = vector(500, 800)
  circleRadius = 150
  mousePos = vector(0, 0)
  isCircleActivated = false
  playerPos = vector(1700, 600)
  playerVel = vector(0, 0)
  enemyPos = vector(1000, 1000)
  gunPos = playerPos:clone()
  isFacingEnemy = false

  familiarRelPos = vector(-60, -40)
end

function love.update(dt)
  mousePos = vector(love.mouse.getX(), love.mouse.getY())
  isCircleActivated = mousePos:dist(circlePos) < circleRadius

  playerPos = playerPos + playerVel

  gunDir = (mousePos - playerPos):normalized()
  gunPos = playerPos + gunDir * 20
  isFacingEnemy = gunDir * (enemyPos - playerPos):normalized() > 0.9
end

function love.draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  if isCircleActivated then
    love.graphics.setColor(0, 1, 0)
  else
    love.graphics.setColor(1, 0, 0)
  end
  love.graphics.circle('line', circlePos.x, circlePos.y, circleRadius)

  love.graphics.setColor(1, .5, 0)
  love.graphics.circle('fill', mousePos.x, mousePos.y, 10)

  love.graphics.setColor(1, 1, 0)
  love.graphics.circle('fill', playerPos.x, playerPos.y, 20)

  gunDirRotated = vector(-gunDir.y, gunDir.x)
  familiarAbsPos = playerPos + vector(familiarRelPos * gunDirRotated, familiarRelPos * gunDir)
  love.graphics.setColor(1, 0, 1)
  love.graphics.circle('fill', familiarAbsPos.x, familiarAbsPos.y, 15)

  love.graphics.setColor(.5, .5, .5)
  love.graphics.circle('fill', gunPos.x, gunPos.y, 7)

  if isFacingEnemy then
    love.graphics.setColor(0, 1, 0)
  else
    love.graphics.setColor(1, 0, 0)
  end
  love.graphics.circle('fill', enemyPos.x, enemyPos.y, 20)
end

function love.keypressed(key, scancode)
  if key == "escape" or key == "q" then
    love.event.quit()
  elseif key == "w" then
    playerVel.y = -10
  elseif key == "a" then
    playerVel.x = -10
  elseif key == "s" then
    playerVel.y = 10
  elseif key == "d" then
    playerVel.x = 10
  end
end

function love.keyreleased(key, scancode)
  if key == "w" or key == "s" then
    playerVel.y = 0
  elseif key == "a" or key =="d" then
    playerVel.x = 0
  end
end

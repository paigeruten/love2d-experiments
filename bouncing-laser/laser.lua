local vector = require "../vector"

local function intersectionPoint(line1, line2)
  local x1, y1, x2, y2 = line1[1].x, line1[1].y, line1[2].x, line1[2].y
  local x3, y3, x4, y4 = line2[1].x, line2[1].y, line2[2].x, line2[2].y

  local denom = (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4)
  if denom == 0 then
    return nil
  end

  local a = (x1*y2 - y1*x2)
  local b = (x3*y4 - y3*x4)
  local x_num = a*(x3 - x4) - (x1 - x2)*b
  local y_num = a*(y3 - y4) - (y1 - y2)*b

  return vector(x_num/denom, y_num/denom)
end

local function isPointOnSegment(p, line)
  local x1, y1, x2, y2 = line[1].x, line[1].y, line[2].x, line[2].y
  local min_x, min_y = math.min(x1, x2), math.min(y1, y2)
  local max_x, max_y = math.max(x1, x2), math.max(y1, y2)

  return p.x >= min_x and p.x <= max_x and p.y >= min_y and p.y <= max_y
end

local function isPointOnRay(p, origin, dir)
  return (p - origin) * dir > 0
end

local function normalOfLine(point1, point2)
  local vec = point1 - point2
  local vec_rotated = vector(vec.y, -vec.x)
  return vec_rotated:normalized()
end

local function raycast(world, origin, dir)
  local closest_hit = nil
  local closest_hit_dist2 = nil
  local closest_hit_idx = nil

  local line_start = nil
  for i, line_end in ipairs(world) do
    if line_start then
      world_line = { line_start, line_end }
      ray_line = { origin, origin + dir }
      intersect = intersectionPoint(world_line, ray_line)
      if intersect and isPointOnSegment(intersect, world_line) and isPointOnRay(intersect, origin, dir) then
        local dist2 = origin:dist2(intersect)
        if (closest_hit == nil or dist2 < closest_hit_dist2) and dist2 > 0.001 then
          closest_hit = intersect
          closest_hit_dist2 = dist2
          closest_hit_idx = i
        end
      end
    end
    line_start = line_end
  end

  local hit_normal = nil
  if closest_hit then
    hit_normal = normalOfLine(world[closest_hit_idx], world[closest_hit_idx - 1])
    if hit_normal * dir > 0 then
      hit_normal = -hit_normal
    end
  end

  return closest_hit_idx, closest_hit, hit_normal
end

local function reflect(origin, hitPoint, hitNormal)
  local height = (origin - hitPoint) * hitNormal
  local oppositePoint = (hitPoint - origin) + hitPoint + 2*height*hitNormal
  return (oppositePoint - hitPoint):normalized()
end

return {
  raycast = raycast,
  reflect = reflect,
  normalOfLine = normalOfLine
}

-- This is from:
--   https://github.com/y9san9/y9nika.nvim
-- by Alex Sokol (MIT)

local M = {}

-- =========================
-- Color space primitives
-- =========================

function M.hex_to_rgb(hex)
  hex = hex:gsub('#', '')
  return tonumber(hex:sub(1, 2), 16),
    tonumber(hex:sub(3, 4), 16),
    tonumber(hex:sub(5, 6), 16)
end

function M.rgb_to_hex(r, g, b)
  return string.format(
    '#%02x%02x%02x',
    math.min(255, math.max(0, r)),
    math.min(255, math.max(0, g)),
    math.min(255, math.max(0, b))
  )
end

function M.rgb_to_hsl(r, g, b)
  r, g, b = r / 255, g / 255, b / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local l = (max + min) / 2

  if max == min then return 0, 0, l end

  local d = max - min
  local s = l > 0.5 and d / (2 - max - min) or d / (max + min)

  local h
  if max == r then
    h = (g - b) / d + (g < b and 6 or 0)
  elseif max == g then
    h = (b - r) / d + 2
  else
    h = (r - g) / d + 4
  end

  return h / 6, s, l
end

function M.hsl_to_rgb(h, s, l)
  if s == 0 then
    local v = math.floor(l * 255)
    return v, v, v
  end

  local function f(p, q, t)
    if t < 0 then t = t + 1 end
    if t > 1 then t = t - 1 end
    if t < 1 / 6 then return p + (q - p) * 6 * t end
    if t < 1 / 2 then return q end
    if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
    return p
  end

  local q = l < 0.5 and l * (1 + s) or l + s - l * s
  local p = 2 * l - q

  return math.floor(f(p, q, h + 1 / 3) * 255),
    math.floor(f(p, q, h) * 255),
    math.floor(f(p, q, h - 1 / 3) * 255)
end

-- =========================
-- Generic color operations
-- =========================

function M.adjust_hsl(hex, dh, ds, dl)
  local h, s, l = M.rgb_to_hsl(M.hex_to_rgb(hex))
  return M.rgb_to_hex(
    M.hsl_to_rgb(
      (h + (dh or 0)) % 1,
      math.min(1, math.max(0, s + (ds or 0))),
      math.min(1, math.max(0, l + (dl or 0)))
    )
  )
end

--- Blend two colors in RGB space (semantic → background-safe)
function M.mix(hex_a, hex_b, t)
  local ar, ag, ab = M.hex_to_rgb(hex_a)
  local br, bg, bb = M.hex_to_rgb(hex_b)
  return M.rgb_to_hex(
    math.floor(ar + (br - ar) * t),
    math.floor(ag + (bg - ag) * t),
    math.floor(ab + (bb - ab) * t)
  )
end

return M

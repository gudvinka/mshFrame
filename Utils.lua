local addonName, ns = ...
local msh = ns
local cfg = msh.cfg

-- 1. БЕЗОПАСНОЕ СОКРАЩЕНИЕ ХП [cite: 2026-01-29]
function msh.FormatValue(val)
    -- Используем pcall, чтобы защищенные значения не "крашили" аддон [cite: 2026-01-29]
    local success, text = pcall(function()
        if not val or type(val) ~= "number" then return "---" end

        if val >= 1e6 then
            return string.format("%.1fM", val / 1e6)
        elseif val >= 1e3 then
            return string.format("%.1fK", val / 1e3)
        else
            return tostring(math.floor(val))
        end
    end)

    if success then
        return text
    else
        -- Специальный маркер для понимания, что сработал fallback [cite: 2026-01-29]
        return "eror"
    end
end

-- 2. ОБРЕЗКА СЕРВЕРА (уже проверено, оставляем) [cite: 2026-01-29]
function msh.GetShortName(unit)
    if not unit then return "Unknown" end
    local success, fullName = pcall(GetUnitName, unit, true)
    if success and type(fullName) == "string" then
        local shortName = string.match(fullName, "([^%-]+)")
        return shortName or fullName
    end
    return "Protected"
end

-- 3. ЦВЕТ КЛАССА [cite: 2026-01-29]
function msh.GetClassColor(unit)
    if not unit then return 1, 1, 1 end
    local _, class = UnitClass(unit)
    if class and RAID_CLASS_COLORS[class] then
        local c = RAID_CLASS_COLORS[class]
        return c.r, c.g, c.b
    end
    return 1, 1, 1
end

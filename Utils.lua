local addonName, ns = ...
local msh = ns

-- Обрезка сервера из имени
function msh.GetShortName(unit)
    local fullName = GetUnitName(unit, true)
    if fullName and type(fullName) == "string" then
        local shortName = string.match(fullName, "([^%-]+)")
        return shortName or fullName
    end
    return fullName
end

-- Получение цвета класса
function msh.GetClassColor(unit)
    if not unit then return 1, 1, 1 end
    local _, class = UnitClass(unit)
    if class and RAID_CLASS_COLORS[class] then
        local c = RAID_CLASS_COLORS[class]
        return c.r, c.g, c.b
    end
    return 1, 1, 1
end

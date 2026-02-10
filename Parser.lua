local addonName, ns = ...
local msh = ns

-- ОБРЕЗКА ИМЕНИ (UTF-8)
function msh.GetShortName(unit)
    if not unit then return "" end

    local name = GetUnitName(unit, false) or ""

    if UnitIsPlayer(unit) then
        name = Ambiguate(name, "none")
        name = name:gsub("%s*%(%*%)%s*", "")
        name = name:trim()
    end

    local cfg = ns.cfg
    if not cfg then return name end

    -- Обрезка
    if cfg.shortenNames then
        local maxChars = cfg.nameLength or 10
        if strlenutf8(name) > maxChars then
            local bytes, charCount, pos = #name, 0, 1
            while pos <= bytes and charCount < maxChars do
                local b = string.byte(name, pos)
                if not b then break end
                if b < 128 then
                    pos = pos + 1
                elseif b < 224 then
                    pos = pos + 2
                elseif b < 240 then
                    pos = pos + 3
                else
                    pos = pos + 4
                end
                charCount = charCount + 1
            end
            name = string.sub(name, 1, pos - 1)
        end
    end

    return name
end

local addonName, ns = ...
local msh = ns
local cfg = msh.cfg

-- СОКРАЩЕНИЕ ХП
function msh.FormatValue(val)
    if not val or val == "" then
        return ""
    end


    return tostring(val)
end

-- ОБРЕЗКА СЕРВЕРА
function msh.GetShortName(unit)
    if not unit then return "" end

    local name = GetUnitName(unit, true) or ""
    -- сервер
    name = string.match(name, "([^%-]+)") or name

    -- Обрезка
    if ns.cfg.shortenNames then
        local maxChars = ns.cfg.nameLength or 5

        -- Проверяем длину в СИМВОЛАХ
        if strlenutf8(name) > maxChars then
            local bytes = #name
            local charCount = 0
            local pos = 1

            -- Итерируем по байтам, пока не наберем нужное кол-во символов
            while pos <= bytes and charCount < maxChars do
                local b = string.byte(name, pos)
                if not b then break end

                if b < 128 then
                    pos = pos + 1 -- Латиница (1 байт)
                elseif b < 224 then
                    pos = pos + 2 -- Кириллица (2 байта)
                elseif b < 240 then
                    pos = pos + 3 -- Редкие символы (3 байта)
                else
                    pos = pos + 4 -- Эмодзи/прочее (4 байта)
                end
                charCount = charCount + 1
            end

            -- Обрезаем строку по найденной позиции байта
            name = string.sub(name, 1, pos - 1)
        end
    end

    return name
end

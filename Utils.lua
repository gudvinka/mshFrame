local addonName, ns = ...
local msh = ns
local cfg = msh.cfg

-- 1. БЕЗОПАСНОЕ СОКРАЩЕНИЕ ХП [cite: 2026-01-29]
function msh.FormatValue(val)
    -- val здесь — это уже готовая строка от Blizzard (например, "1.5M")
    if not val or val == "" then
        return ""
    end

    -- Просто возвращаем то, что дала игра, без всяких вычислений
    return tostring(val)
end

-- 2. ОБРЕЗКА СЕРВЕРА (уже проверено, оставляем) [cite: 2026-01-29]
-- Utils.lua
function msh.GetShortName(unit)
    if not unit then return "" end

    local name = GetUnitName(unit, true) or ""
    -- 1. Убираем сервер
    name = string.match(name, "([^%-]+)") or name

    -- 2. Обрезка
    if ns.cfg.shortenNames then
        local maxChars = ns.cfg.nameLength or 5

        -- Проверяем длину в СИМВОЛАХ (strlenutf8 всегда доступна в WoW)
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
            -- (Если хочешь убрать первый символ, можно сдвинуть начало обрезки)
            name = string.sub(name, 1, pos - 1)
        end
    end

    return name
end

local addonName, ns = ...
local msh = ns

function msh.CreateLayers(frame)
    local cfg = ns.cfg
    if not frame.mshLayersCreated then
        frame.mshName = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        if frame.name then frame.name:SetAlpha(0) end

        frame.mshHP = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        if frame.statusText then frame.statusText:SetAlpha(0) end

        frame.mshLayersCreated = true
    end

    frame.mshName:SetFont(cfg.font, cfg.fontSizeName, "OUTLINE")
    frame.mshName:SetPoint(cfg.namePoint, frame, cfg.nameX, cfg.nameY)

    frame.mshHP:SetFont(cfg.font, cfg.fontSizeStatus, "OUTLINE")
    frame.mshHP:SetPoint(cfg.statusPoint, frame, cfg.statusX, cfg.statusY)
end

function msh.UpdateLayers(frame)
    if not frame or not frame.mshLayersCreated then return end
    local unit = frame.displayedUnit or frame.unit
    if not unit or not UnitExists(unit) then return end

    -- 1. Имена обновляем всегда, они от режима HP не зависят
    if frame.mshName then
        frame.mshName:SetText(msh.GetShortName(unit))
    end

    -- 2. А вот для ХП проверяем конфиг
    if frame.mshHP then
        -- Если в конфиге NONE, просто ставим пустоту и не смотрим на Blizzard
        if ns.cfg.hpMode == "NONE" then
            frame.mshHP:SetText("")
        else
            -- В остальных случаях копируем как обычно
            local status = frame.statusText
            if status then
                frame.mshHP:SetText(status:GetText() or "")
            end
        end
    end
end

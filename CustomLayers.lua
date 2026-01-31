local addonName, ns = ...
local msh = ns

function msh.CreateLayers(frame)
    local cfg = ns.cfg
    if not frame.mshLayersCreated then
        -- 1. Создаем наше Имя
        frame.mshName = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        frame.mshName:SetDrawLayer("OVERLAY", 0)
        -- Прячем стандартное имя Blizzard (Alpha 0 надежнее, чем Hide, так как игра сама его показывает)
        if frame.name then frame.name:SetAlpha(0) end

        -- 2. Создаем наше ХП
        frame.mshHP = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        frame.mshHP:SetDrawLayer("OVERLAY", 0)
        -- Прячем стандартный текст статуса
        if frame.statusText then frame.statusText:SetAlpha(0) end

        -- 3. Иконка роли: фиксируем слой один раз при создании
        if frame.roleIcon then
            frame.roleIcon:SetParent(frame) -- Гарантируем родителя
            frame.roleIcon:SetDrawLayer("OVERLAY", 7)
        end

        frame.mshLayersCreated = true
    end

    -- Применяем настройки из конфига
    frame.mshName:SetFont(cfg.font, cfg.fontSizeName, "OUTLINE")
    frame.mshName:ClearAllPoints()
    frame.mshName:SetPoint(cfg.namePoint, frame, cfg.nameX, cfg.nameY)

    frame.mshHP:SetFont(cfg.font, cfg.fontSizeStatus, "OUTLINE")
    frame.mshHP:ClearAllPoints()
    frame.mshHP:SetPoint(cfg.statusPoint, frame, cfg.statusX, cfg.statusY)
end

function msh.UpdateLayers(frame)
    if not frame or not frame.mshLayersCreated then return end

    -- Используем displayedUnit (важно для техники и фазирования)
    local unit = frame.displayedUnit or frame.unit
    if not unit or not UnitExists(unit) then return end

    -- 1. Имена
    frame.mshName:SetText(msh.GetShortName(unit))

    -- 2. ХП (Копируем текст Blizzard, чтобы избежать ошибок "Protected Value")
    if ns.cfg.hpMode == "NONE" then
        frame.mshHP:SetText("")
    else
        if frame.statusText then
            -- statusText обновляется Blizzard автоматически, мы просто транслируем результат
            frame.mshHP:SetText(frame.statusText:GetText() or "")
        end
    end

    -- 3. КРИТИЧЕСКОЕ ИСПРАВЛЕНИЕ: Принудительный подъем иконки роли
    -- Blizzard часто сбрасывает DrawLayer при изменении состава группы
    if frame.roleIcon and frame.roleIcon:IsShown() then
        if frame.roleIcon:GetDrawLayer() ~= "OVERLAY" then
            frame.roleIcon:SetDrawLayer("OVERLAY", 7)
        end
    end
end

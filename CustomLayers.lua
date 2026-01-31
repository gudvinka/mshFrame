local addonName, ns = ...
local msh = ns

-- 1. СТИЛИЗАЦИЯ И ПОЗИЦИЯ АУР (Баффы и Дебаффы)
function msh.UpdateAuras(frame)
    if not frame or frame:IsForbidden() then return end
    local cfg = ns.cfg

    -- Настройки из конфига (с дефолтными значениями, чтобы не упало)
    local auraSettings = {
        {
            pool = frame.buffFrames,
            size = cfg.auraSize or 18,
            point = cfg.auraPoint or "TOPLEFT",
            x = cfg.auraX or 5,
            y = cfg.auraY or -15,
            grow = cfg.auraGrow or "RIGHT",
            space = cfg.auraSpacing or 2
        },
        {
            pool = frame.debuffFrames,
            size = cfg.debuffSize or 22,
            point = cfg.debuffPoint or "TOPRIGHT",
            x = cfg.debuffX or -5,
            y = cfg.debuffY or -15,
            grow = cfg.debuffGrow or "LEFT",
            space = cfg.debuffSpacing or 2
        }
    }

    for _, data in ipairs(auraSettings) do
        if data.pool then
            local previousIcon = nil
            for i = 1, #data.pool do
                local icon = data.pool[i]
                if icon and icon:IsShown() then
                    icon:SetSize(data.size, data.size)
                    icon:ClearAllPoints()

                    if i == 1 then
                        icon:SetPoint(data.point, frame, data.x, data.y)
                    else
                        local anchor, rel, offX
                        if data.grow == "LEFT" then
                            anchor, rel, offX = "RIGHT", "LEFT", -data.space
                        else
                            anchor, rel, offX = "LEFT", "RIGHT", data.space
                        end
                        icon:SetPoint(anchor, previousIcon, rel, offX, 0)
                    end
                    previousIcon = icon

                    -- Таймер
                    if icon.cooldown then
                        icon.cooldown:SetHideCountdownNumbers(not cfg.showAuraTimer)
                        local timer = icon.cooldown:GetRegions()
                        if timer and timer:GetObjectType() == "FontString" then
                            timer:SetFont(cfg.font, data.size * 0.6, "OUTLINE")
                        end
                    end
                end
            end
        end
    end
end

-- Хук для аур (чтобы они не прыгали)
hooksecurefunc("CompactUnitFrame_UpdateAuras", function(frame)
    if frame.mshLayersCreated then
        msh.UpdateAuras(frame)
    end
end)

-- 2. СОЗДАНИЕ СЛОЕВ
function msh.CreateLayers(frame)
    local cfg = ns.cfg
    if not frame.mshLayersCreated then
        -- Имя
        frame.mshName = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        if frame.name then frame.name:SetAlpha(0) end

        -- ХП
        frame.mshHP = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        if frame.statusText then frame.statusText:SetAlpha(0) end

        -- Роль
        if frame.roleIcon then
            frame.roleIcon:SetParent(frame)
            frame.roleIcon:SetDrawLayer("OVERLAY", 7)
            if not cfg.showRoleIcon then
                frame.roleIcon:Hide()
                frame.roleIcon.Show = function() end
            end
        end
        frame.mshLayersCreated = true
    end
end

-- 3. ОБНОВЛЕНИЕ ТЕКСТОВ И РОЛИ
function msh.UpdateLayers(frame)
    if not frame or not frame.mshLayersCreated then return end
    local unit = frame.displayedUnit or frame.unit
    if not unit or not UnitExists(unit) then return end

    local cfg = ns.cfg

    -- Обновляем Имя
    frame.mshName:SetFont(cfg.font, cfg.fontSizeName, "OUTLINE")
    frame.mshName:ClearAllPoints()
    frame.mshName:SetPoint(cfg.namePoint, frame, cfg.nameX, cfg.nameY)
    frame.mshName:SetText(msh.GetShortName(unit))

    -- Обновляем ХП
    frame.mshHP:SetFont(cfg.font, cfg.fontSizeStatus, "OUTLINE")
    frame.mshHP:ClearAllPoints()
    frame.mshHP:SetPoint(cfg.statusPoint, frame, cfg.statusX, cfg.statusY)
    if cfg.hpMode == "NONE" then
        frame.mshHP:SetText("")
    elseif frame.statusText then
        frame.mshHP:SetText(frame.statusText:GetText() or "")
    end

    -- ЗАЩИТА ИКОНКИ РОЛИ
    if frame.roleIcon and cfg.showRoleIcon then
        frame.roleIcon:SetSize(cfg.roleIconSize, cfg.roleIconSize)
        frame.roleIcon:ClearAllPoints()
        frame.roleIcon:SetPoint(cfg.roleIconPoint, frame, cfg.roleIconX, cfg.roleIconY)

        -- Если юнит в группе и имеет роль — принудительно показываем
        local role = UnitGroupRolesAssigned(unit)
        if role and role ~= "NONE" then
            frame.roleIcon:Show()
        else
            frame.roleIcon:Hide()
        end
    end

    -- Первичное обновление аур
    msh.UpdateAuras(frame)
end

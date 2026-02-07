local _, ns = ...
local msh = ns

function msh.CreateUnitLayers(frame)
    if frame.mshLayersCreated then return end

    frame.mshName = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    if frame.name then frame.name:SetAlpha(0) end

    frame.mshRole = frame:CreateTexture(nil, "OVERLAY", nil, 7)
    frame.mshRaidIcon = frame:CreateTexture(nil, "OVERLAY", nil, 7)

    frame.mshLayersCreated = true
end

function msh.UpdateUnitDisplay(frame)
    local cfg = ns.cfg
    local unit = frame.displayedUnit or frame.unit
    if not unit or not cfg or not frame.mshName then return end

    -- Имя
    local currentRawName = GetUnitName(unit, false)
    if not currentRawName then
        frame.mshName:SetText("")
        return
    end
    local unitGUID = UnitGUID(unit) or "no-guid"
    local cacheKey = currentRawName .. unitGUID .. (cfg.nameLength or "10") .. tostring(cfg.shortenNames)

    if frame.mshCachedKey ~= cacheKey then
        local name = msh.GetShortName(unit)
        frame.mshName:SetText(name)
        frame.mshCachedKey = cacheKey
    end

    frame.mshName:ClearAllPoints()
    frame.mshName:SetPoint(cfg.namePoint or "CENTER", frame, cfg.nameX or 0, cfg.nameY or 0)

    -- УСТАНОВКА ШРИФТА
    local fontPath = LibStub("LibSharedMedia-3.0"):Fetch("font", cfg.fontName)
    local fontSize = cfg.fontSizeName or 12
    local fontOutline = cfg.nameOutline or "OUTLINE"

    local ok = frame.mshName:SetFont(fontPath, fontSize, fontOutline)

    if frame.name then frame.name:SetAlpha(0) end


    -- 4. РОЛЬ
    local role = UnitGroupRolesAssigned(unit)

    if cfg.useBlizzRole then
        if frame.mshRole then frame.mshRole:Hide() end
        if frame.roleIcon then
            frame.roleIcon:SetAlpha(1)
        end
    else
        if frame.roleIcon then
            frame.roleIcon:Hide()
            frame.roleIcon:SetAlpha(0)
        end

        if cfg.showRoleIcon and role and role ~= "NONE" then
            if frame.mshRole then
                frame.mshRole:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]])

                local size = cfg.roleIconSize or 12
                frame.mshRole:SetSize(size, size)
                frame.mshRole:ClearAllPoints()
                frame.mshRole:SetPoint(cfg.roleIconPoint or "TOPLEFT", frame, cfg.roleIconX or 2, cfg.roleIconY or -2)

                if role == "TANK" then
                    frame.mshRole:SetTexCoord(0, 19 / 64, 22 / 64, 41 / 64)
                elseif role == "HEALER" then
                    frame.mshRole:SetTexCoord(20 / 64, 39 / 64, 1 / 64, 20 / 64)
                elseif role == "DAMAGER" then
                    frame.mshRole:SetTexCoord(20 / 64, 39 / 64, 22 / 64, 41 / 64)
                end
                frame.mshRole:Show()
            end
        else
            -- Если галочка "Показать нашу" снята
            if frame.mshRole then frame.mshRole:Hide() end
        end
    end

    -- 5. РЕЙДОВЫЕ МЕТКИ (Проверь, чтобы этот код шел СРАЗУ ПОСЛЕ блока ролей)
    local index = GetRaidTargetIndex(unit)
    if index then
        frame.mshRaidIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
        frame.mshRaidIcon:SetSize(cfg.raidMarkSize or 14, cfg.raidMarkSize or 14)
        frame.mshRaidIcon:ClearAllPoints()
        frame.mshRaidIcon:SetPoint(cfg.raidMarkPoint or "CENTER", frame, cfg.raidMarkX or 0, cfg.raidMarkY or 0)
        SetRaidTargetIconTexture(frame.mshRaidIcon, index)
        frame.mshRaidIcon:Show()
    else
        frame.mshRaidIcon:Hide()
    end

    -- Метка
    local index = GetRaidTargetIndex(unit)
    if index and cfg.showRaidMark then
        frame.mshRaidIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
        SetRaidTargetIconTexture(frame.mshRaidIcon, index)
        frame.mshRaidIcon:SetSize(cfg.raidMarkSize, cfg.raidMarkSize)
        frame.mshRaidIcon:ClearAllPoints()
        frame.mshRaidIcon:SetPoint(cfg.raidMarkPoint, frame, cfg.raidMarkX, cfg.raidMarkY)
        frame.mshRaidIcon:Show()
    else
        frame.mshRaidIcon:Hide()
    end
end

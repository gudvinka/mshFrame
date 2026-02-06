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
    local name = msh.GetShortName(unit)
    frame.mshName:SetText(name)

    local fontPath = LibStub("LibSharedMedia-3.0"):Fetch("font", cfg.fontName)
    frame.mshName:SetFont(fontPath, cfg.fontSize, cfg.fontOutline)
    frame.mshName:ClearAllPoints()
    frame.mshName:SetPoint(cfg.namePoint, frame, cfg.nameX, cfg.nameY)

    if frame.name then frame.name:SetAlpha(0) end


    -- Роль
    local role = UnitGroupRolesAssigned(unit)
    if cfg.showRole and role ~= "NONE" then
        frame.mshRole:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]])
        frame.mshRole:SetSize(cfg.roleIconSize, cfg.roleIconSize)
        frame.mshRole:ClearAllPoints()
        frame.mshRole:SetPoint(cfg.roleIconPoint, frame, cfg.roleIconX, cfg.roleIconY)

        if role == "TANK" then
            frame.mshRole:SetTexCoord(0, 19 / 64, 22 / 64, 41 / 64)
        elseif role == "HEALER" then
            frame.mshRole:SetTexCoord(20 / 64, 39 / 64, 1 / 64, 20 / 64)
        elseif role == "DAMAGER" then
            frame.mshRole:SetTexCoord(20 / 64, 39 / 64, 22 / 64, 41 / 64)
        end
        frame.mshRole:Show()
    else
        frame.mshRole:Hide()
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

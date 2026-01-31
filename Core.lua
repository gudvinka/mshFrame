local addonName, ns = ...
local msh = ns
local LSM = LibStub("LibSharedMedia-3.0", true)

local function ApplyMshStyle(frame)
    if not frame or frame:IsForbidden() or not frame.healthBar then return end

    local cfg = msh.cfg
    local fontPath = LSM:Fetch("font", cfg.font) or "Fonts\\FRIZQT__.TTF"
    local tex = LSM:Fetch("statusbar", cfg.texture) or "Interface\\TargetingFrame\\UI-StatusBar"
    local unit = frame.displayedUnit or frame.unit

    -- 1. Текстура полоски и цвет класса
    frame.healthBar:SetStatusBarTexture(tex)
    local r, g, b = msh.GetClassColor(unit)
    frame.healthBar:SetStatusBarColor(r, g, b)

    -- 2. Настройка Имени (используем Utils)
    if frame.name and unit then
        frame.name:SetText(msh.GetShortName(unit))
        frame.name:SetFont(fontPath, cfg.fontSizeName, "OUTLINE")
        frame.name:ClearAllPoints()
        frame.name:SetPoint(cfg.namePoint, frame, cfg.namePoint, cfg.nameX, cfg.nameY)
    end

    -- 3. Настройка Статуса (стандартный текст Blizzard)
    if frame.statusText then
        frame.statusText:SetFont(fontPath, cfg.fontSizeStatus, "OUTLINE")
        frame.statusText:ClearAllPoints()
        frame.statusText:SetPoint(cfg.statusPoint, frame, cfg.statusPoint, cfg.statusX, cfg.statusY)
    end
end

-- Хуки для применения стиля
hooksecurefunc("CompactUnitFrame_UpdateAll", ApplyMshStyle)
hooksecurefunc("CompactUnitFrame_UpdateStatusText", ApplyMshStyle)
hooksecurefunc("CompactUnitFrame_UpdateName", ApplyMshStyle)

-- Команда перезагрузки
SLASH_MSHFRAME1 = "/msh"
SlashCmdList["MSHFRAME"] = function() ReloadUI() end

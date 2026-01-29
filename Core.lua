local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then return end

-- 1. РЕГИСТРАЦИЯ МЕДИА
LSM:Register("font", "Montserrat SemiBold", [[Interface\AddOns\mshFrame\Media\Montserrat-SemiBold.ttf]])

-- 2. БЛОК НАСТРОЕК (CFG)
local CFG = {
    texture = "Flat",
    font = "Montserrat SemiBold",
    fontSizeName = 12,
    fontSizeStatus = 12,

    -- Координаты
    namePoint = "TOPLEFT",
    nameX = 22, -- Оставляем место под иконку роли [cite: 2026-01-29]
    nameY = -4,

    statusPoint = "RIGHT",
    statusX = -5,
    statusY = 0,
}

-- 3. ГЛАВНАЯ ФУНКЦИЯ (ApplyMshStyle)
local function ApplyMshStyle(frame)
    if not frame or frame:IsForbidden() or not frame.healthBar then return end

    local fontPath = LSM:Fetch("font", CFG.font) or "Fonts\\FRIZQT__.TTF"
    local tex = LSM:Fetch("statusbar", CFG.texture) or "Interface\\TargetingFrame\\UI-StatusBar"
    local unit = frame.displayedUnit or frame.unit

    -- Текстура и Цвет по классу
    frame.healthBar:SetStatusBarTexture(tex)
    if unit then
        local _, class = UnitClass(unit)
        if class and RAID_CLASS_COLORS[class] then
            local color = RAID_CLASS_COLORS[class]
            frame.healthBar:SetStatusBarColor(color.r, color.g, color.b)
        end
    end

    -- Настройка Имени (с защитой от nil и обрезкой сервера)
    if frame.name and unit then
        local fullName = GetUnitName(unit, true)
        if fullName then
            -- Оставляем только то, что ДО знака "-", убирая сервер [cite: 2026-01-29]
            local shortName = string.match(fullName, "([^%-]+)")
            if shortName then
                frame.name:SetText(shortName)
            end
        end

        frame.name:SetFont(fontPath, CFG.fontSizeName, "OUTLINE")
        frame.name:ClearAllPoints()
        frame.name:SetPoint(CFG.namePoint, frame, CFG.namePoint, CFG.nameX, CFG.nameY)
    end

    -- Настройка Статуса (ХП / % из настроек игры)
    if frame.statusText then
        frame.statusText:SetFont(fontPath, CFG.fontSizeStatus, "OUTLINE")
        frame.statusText:ClearAllPoints()
        frame.statusText:SetPoint(CFG.statusPoint, frame, CFG.statusPoint, CFG.statusX, CFG.statusY)
        frame.statusText:Show()
    end
end

-- 4. ХУКИ (Связываем наш код с игрой) [cite: 2026-01-29]
hooksecurefunc("CompactUnitFrame_UpdateAll", ApplyMshStyle)
hooksecurefunc("CompactUnitFrame_UpdateStatusText", ApplyMshStyle)
hooksecurefunc("CompactUnitFrame_UpdateName", ApplyMshStyle) -- Чтобы сервер не возвращался [cite: 2026-01-29]

SLASH_MSHFRAME1 = "/msh"
SlashCmdList["MSHFRAME"] = function()
    for i = 1, 40 do
        local rf = _G["CompactRaidFrame" .. i] or _G["CompactPartyFrameMember" .. i]
        if rf then ApplyMshStyle(rf) end
    end
    print("|cff00ff00mshFrame:|r Стиль применен, имена обрезаны!")
end

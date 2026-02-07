local _, ns = ...
local msh = ns
local LSM = LibStub("LibSharedMedia-3.0")

local isUpdating = false

function msh.CreateHealthLayers(frame)
    if frame.mshHealthCreated then return end

    -- Создаем наш кастомный текст
    frame.mshHP = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")

    -- Прячем стандартный текст, чтобы он не двоился
    if frame.statusText then frame.statusText:SetAlpha(0) end

    frame.mshHealthCreated = true
end

function msh.UpdateHealthDisplay(frame)
    if isUpdating or not frame or frame:IsForbidden() then return end

    local cfg = ns.cfg
    if not cfg or not frame.healthBar then return end

    isUpdating = true

    msh.CreateHealthLayers(frame)

    -- 1. Текстура полоски
    local texturePath = LSM:Fetch("statusbar", cfg.texture)
    if frame.healthBar:GetStatusBarTexture():GetTexture() ~= texturePath then
        frame.healthBar:SetStatusBarTexture(texturePath)
    end

    -- 2. Логика отображения ХП
    if cfg.hpMode == "NONE" then
        if frame.mshHP then frame.mshHP:Hide() end
    else
        -- Берем текст Blizzard
        local blizzText = frame.statusText and frame.statusText:GetText() or ""
        local font = LSM:Fetch("font", cfg.fontStatus)

        frame.mshHP:SetFont(font, cfg.fontSizeStatus, cfg.statusOutline)
        frame.mshHP:ClearAllPoints()
        frame.mshHP:SetPoint(cfg.statusPoint or "TOP", frame, cfg.statusX or 0, cfg.statusY or 0)

        frame.mshHP:SetText(blizzText)
        frame.mshHP:Show()
    end

    isUpdating = false -- Разблокируем для следующего обновления
end

local _, ns = ...
local msh = ns

function msh.CreateHealthLayers(frame)
    if frame.mshHealthCreated then return end

    -- Создаем наш кастомный текст
    frame.mshHP = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")

    -- Прячем стандартный текст, чтобы он не двоился
    if frame.statusText then frame.statusText:SetAlpha(0) end

    frame.mshHealthCreated = true
end

function msh.UpdateHealthDisplay(frame)
    local cfg = ns.cfg
    if not cfg or not frame.healthBar then return end
    msh.CreateHealthLayers(frame)

    -- 1. Текстура полоски
    local LSM = LibStub("LibSharedMedia-3.0")
    frame.healthBar:SetStatusBarTexture(LSM:Fetch("statusbar", cfg.texture))

    -- 2. Логика отображения ХП
    if cfg.hpMode == "NONE" then
        frame.mshHP:Hide()
    else
        -- Вместо вычислений просто берем то, что Blizzard уже подготовила в своем скрытом statusText
        local blizzText = frame.statusText and frame.statusText:GetText() or ""

        frame.mshHP:SetFont(LSM:Fetch("font", cfg.fontStatus), cfg.fontSizeStatus, cfg.statusOutline)
        frame.mshHP:ClearAllPoints()
        frame.mshHP:SetPoint(cfg.statusPoint or "BOTTOMRIGHT", frame, cfg.statusX or 0, cfg.statusY or 0)

        frame.mshHP:SetText(blizzText)
        frame.mshHP:Show()
    end
end

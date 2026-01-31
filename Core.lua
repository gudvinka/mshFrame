local addonName, ns = ...
local msh = ns
local LSM = LibStub("LibSharedMedia-3.0")

local function ApplyMshStyle(frame)
    if not frame or frame:IsForbidden() then return end

    -- Берем конфиг ПРЯМО ЗДЕСЬ
    local cfg = msh.cfg
    if not cfg then return end

    local frameName = frame:GetName() or ""
    if not (frameName:find("CompactRaid") or frameName:find("CompactParty")) or frameName:find("Pet") then
        return
    end

    local unit = frame.displayedUnit or frame.unit
    if not unit then return end

    -- 1. ТЕКСТУРА И ЦВЕТ
    if frame.healthBar then
        local tex = LSM:Fetch("statusbar", cfg.texture)
        frame.healthBar:SetStatusBarTexture(tex)

        local r, g, b
        if cfg.useClassColors then
            r, g, b = msh.GetClassColor(unit)
        else
            r, g, b = unpack(cfg.staticColor)
        end
        frame.healthBar:SetStatusBarColor(r, g, b)
    end

    -- 2. СЛОИ (Имена и ХП)
    msh.CreateLayers(frame)
    msh.UpdateLayers(frame)
end

local function SyncBlizzardSettings()
    local mode = ns.cfg.hpMode
    if not mode then return end

    -- 1. Устанавливаем CVar
    if mode == "VALUE" then
        SetCVar("raidFramesHealthText", "health")
    elseif mode == "NONE" then
        SetCVar("raidFramesHealthText", "none")
    elseif mode == "PERCENT" then
        SetCVar("raidFramesHealthText", "perc")
    end

    -- 2. Включаем текст
    SetCVar("statusText", "1")

    -- 3. Принудительно обновляем фреймы
    if CompactUnitFrameProfiles_ApplyCurrentSettings then
        CompactUnitFrameProfiles_ApplyCurrentSettings()
    elseif CompactRaidFrameManager_UpdateOptionsFlowContainer then
        CompactRaidFrameManager_UpdateOptionsFlowContainer()
    end
end

-- 1. Создаем скрытый фрейм для отслеживания событий
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")

-- 2. Вешаем выполнение функции на это событие
eventFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        -- Выполняем синхронизацию (теперь она сработает без задержки)
        SyncBlizzardSettings()

        -- Выводим принт (по желанию, можно потом удалить)
        print("|cff00ff00mshFrame:|r Настройки применены при логине.")

        -- Отключаем событие, чтобы оно не срабатывало лишний раз
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)

-- Хук на обновление Blizzard
hooksecurefunc("CompactUnitFrame_UpdateAll", function(frame)
    ApplyMshStyle(frame)
end)

-- Команда перезагрузки
SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = function() ReloadUI() end


-- Принт для проверки (он подтвердит, что до этой строки код дошел)
print("|cff00ff00mshFrame:|r Конфиг применен через /reload поставил " .. msh.cfg.hpMode)

-- Для принтов тоже используем полный путь msh.cfg
print("|cff00ff00mshFrame:|r Загружен. Режим цвета: " .. (msh.cfg.useClassColors and "Класс" or "Статичный"))

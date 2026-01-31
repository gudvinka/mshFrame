---@diagnostic disable: undefined-global
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

        -- own coloring frames
        -- local r, g, b
        -- if cfg.useClassColors then
        --     r, g, b = msh.GetClassColor(unit)
        -- else
        --     r, g, b = unpack(cfg.staticColor)
        -- end
        -- frame.healthBar:SetStatusBarColor(r, g, b)
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

    -- 2. Включаем текст (чтобы режимы VALUE/PERCENT работали)
    -- SetCVar("statusText", "1")

    -- 3. Принудительно просим Blizzard обновить все фреймы
    if CompactUnitFrameProfiles_ApplyCurrentSettings then
        CompactUnitFrameProfiles_ApplyCurrentSettings()
    end

    -- Дополнительный "пинок" для надежности
    if CompactRaidFrameContainer and CompactRaidFrameContainer.LayoutFrames then
        CompactRaidFrameContainer:LayoutFrames()
    end
end

-- 1. Создаем скрытый фрейм для отслеживания событий
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("UNIT_HEALTH")
eventFrame:RegisterEvent("UNIT_MAXHEALTH")
eventFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
eventFrame:RegisterEvent("UNIT_EXITED_VEHICLE")

-- 2. Обработка событий
eventFrame:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_LOGIN" then
        SyncBlizzardSettings()

        -- Принудительно обновляем все видимые фреймы один раз
        for i = 1, 40 do
            local frame = _G["CompactRaidFrame" .. i] or _G["CompactPartyFrameMember" .. i]
            if frame then msh.UpdateLayers(frame) end
        end
        self:UnregisterEvent("PLAYER_LOGIN")
    elseif unit then
        -- Самый быстрый способ найти фрейм в обход nil-функций
        -- Перебираем все возможные фреймы группы и рейда
        for i = 1, 5 do
            local pf = _G["CompactPartyFrameMember" .. i]
            if pf and (pf.displayedUnit == unit or pf.unit == unit) then
                msh.UpdateLayers(pf)
            end
        end
        for i = 1, 40 do
            local rf = _G["CompactRaidFrame" .. i]
            if rf and (rf.displayedUnit == unit or rf.unit == unit) then
                msh.UpdateLayers(rf)
            end
        end
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

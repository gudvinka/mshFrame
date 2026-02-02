---@diagnostic disable: undefined-global
local addonName, ns = ...
local msh = ns
local LSM = LibStub("LibSharedMedia-3.0")

-- ФУНКЦИЯ СТИЛИЗАЦИИ
local function ApplyMshStyle(frame)
    if not ns.cfg or not frame or frame:IsForbidden() then return end

    local frameName = frame:GetName() or ""
    if not (frameName:find("CompactRaid") or frameName:find("CompactParty")) or frameName:find("Pet") then
        return
    end

    -- Текстура полоски берется из конфига профиля
    if frame.healthBar then
        local tex = LSM:Fetch("statusbar", ns.cfg.texture)
        frame.healthBar:SetStatusBarTexture(tex)
    end

    -- Создание и обновление слоев
    msh.CreateLayers(frame)
    msh.UpdateLayers(frame)
end

-- СИНХРОНИЗАЦИЯ С НАСТРОЙКАМИ BLIZZARD
function msh.SyncBlizzardSettings()
    if not ns.cfg then return end
    local mode = ns.cfg.hpMode
    if not mode then return end

    if mode == "VALUE" then
        SetCVar("raidFramesHealthText", "health")
    elseif mode == "NONE" then
        SetCVar("raidFramesHealthText", "none")
    elseif mode == "PERCENT" then
        SetCVar("raidFramesHealthText", "perc")
    end

    SetCVar("raidFramesCenterBigDefensive", ns.cfg.showBigSave and "1" or "0")
    SetCVar("raidFramesDisplayDebuffs", ns.cfg.showDebuffs and "1" or "0")
    SetCVar("raidFramesDisplayOnlyDispellableDebuffs", ns.cfg.showOnlyDispellable and "1" or "0")

    if CompactUnitFrameProfiles_ApplyCurrentSettings then
        CompactUnitFrameProfiles_ApplyCurrentSettings()
    end
end

-- ОБРАБОТКА СОБЫТИЙ
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("UNIT_HEALTH")
eventFrame:RegisterEvent("UNIT_MAXHEALTH")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("RAID_TARGET_UPDATE")

eventFrame:SetScript("OnEvent", function(self, event, unit)
    -- Инициализация базы данных при загрузке аддона
    if event == "ADDON_LOADED" and unit == addonName then
        self.db = LibStub("AceDB-3.0"):New("mshFrameDB", ns.defaults, true)
        ns.cfg = self.db.profile


        LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, ns.options)
        LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, "mshFrame")


        SLASH_MSHFRAME1 = "/msh"
        SlashCmdList["MSHFRAME"] = function()
            LibStub("AceConfigDialog-3.0"):Open(addonName)
        end
    elseif event == "PLAYER_LOGIN" then
        msh.SyncBlizzardSettings()

        -- Обновление при смене меток или состава группы
    elseif event == "RAID_TARGET_UPDATE" or event == "GROUP_ROSTER_UPDATE" then
        -- Рейдовые фреймы
        if CompactRaidFrameContainer and CompactRaidFrameContainer.flowFrames then
            for _, frame in ipairs(CompactRaidFrameContainer.flowFrames) do
                if type(frame) == "table" and frame.mshLayersCreated then
                    msh.UpdateLayers(frame)
                end
            end
        end

        -- Прямой поиск по группам
        for g = 1, 8 do
            for m = 1, 5 do
                local frame = _G["CompactRaidGroup" .. g .. "Member" .. m]
                if frame and frame:IsShown() and frame.mshLayersCreated then
                    msh.UpdateLayers(frame)
                end
            end
        end

        -- Пати-фреймы
        for i = 1, 5 do
            local frame = _G["CompactPartyFrameMember" .. i]
            if frame and frame:IsShown() and frame.mshLayersCreated then
                msh.UpdateLayers(frame)
            end
        end

        -- Обновление конкретного юнита (Здоровье)
    elseif unit then
        if IsInRaid() then
            if CompactRaidFrameContainer and CompactRaidFrameContainer.flowFrames then
                for _, frame in ipairs(CompactRaidFrameContainer.flowFrames) do
                    if type(frame) == "table" and (frame.displayedUnit == unit or frame.unit == unit) then
                        msh.UpdateLayers(frame)
                        return
                    end
                end
            end

            local _, _, difficultyID = GetInstanceInfo()
            local numMembers = GetNumGroupMembers()
            local maxGroups = (difficultyID == 16) and 4 or math.ceil(numMembers / 5)

            for g = 1, maxGroups do
                for m = 1, 5 do
                    local frame = _G["CompactRaidGroup" .. g .. "Member" .. m]
                    if frame and (frame.displayedUnit == unit or frame.unit == unit) then
                        msh.UpdateLayers(frame)
                        return
                    end
                end
            end
        else
            for i = 1, 5 do
                local frame = _G["CompactPartyFrameMember" .. i]
                if frame and (frame.displayedUnit == unit or frame.unit == unit) then
                    msh.UpdateLayers(frame)
                    return
                end
            end
        end
    end
end)

-- Хук на обновление фреймов Blizzard
hooksecurefunc("CompactUnitFrame_UpdateAll", ApplyMshStyle)

-- Быстрая перезагрузка
SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = function() ReloadUI() end

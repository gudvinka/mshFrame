---@diagnostic disable: undefined-global
local addonName, ns = ...
local msh = ns
local LSM = LibStub("LibSharedMedia-3.0")

local function ApplyMshStyle(frame)
    if not frame or frame:IsForbidden() then return end

    local frameName = frame:GetName() or ""
    if not (frameName:find("CompactRaid") or frameName:find("CompactParty")) or frameName:find("Pet") then
        return
    end

    -- 1. ТЕКСТУРА
    if frame.healthBar then
        local tex = LSM:Fetch("statusbar", ns.cfg.texture)
        frame.healthBar:SetStatusBarTexture(tex)
    end

    -- 2. СЛОИ
    msh.CreateLayers(frame)
    msh.UpdateLayers(frame)
end

local function SyncBlizzardSettings()
    local mode = ns.cfg.hpMode
    if not mode then return end

    if mode == "VALUE" then
        SetCVar("raidFramesHealthText", "health")
    elseif mode == "NONE" then
        SetCVar("raidFramesHealthText", "none")
    elseif mode == "PERCENT" then
        SetCVar("raidFramesHealthText", "perc")
    end

    if CompactUnitFrameProfiles_ApplyCurrentSettings then
        CompactUnitFrameProfiles_ApplyCurrentSettings()
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("UNIT_HEALTH")
eventFrame:RegisterEvent("UNIT_MAXHEALTH")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

eventFrame:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_LOGIN" then
        SyncBlizzardSettings()
    elseif event == "GROUP_ROSTER_UPDATE" then
        -- Принудительное обновление всех фреймов при изменении состава группы/рейда
        if CompactRaidFrameContainer and CompactRaidFrameContainer.flowFrames then
            for _, frame in ipairs(CompactRaidFrameContainer.flowFrames) do
                if type(frame) == "table" then ApplyMshStyle(frame) end
            end
        end
    elseif unit then
        -- 1. ЕСЛИ МЫ В РЕЙДЕ
        if IsInRaid() then
            -- Сначала ищем через flowFrames (быстрый доступ Blizzard)
            if CompactRaidFrameContainer and CompactRaidFrameContainer.flowFrames then
                for _, frame in ipairs(CompactRaidFrameContainer.flowFrames) do
                    if type(frame) == "table" and (frame.displayedUnit == unit or frame.unit == unit) then
                        msh.UpdateLayers(frame)
                        return -- Нашли? Выходим
                    end
                end
            end

            -- Прямой поиск по группам с учетом сложности
            local _, _, difficultyID = GetInstanceInfo()
            local numMembers = GetNumGroupMembers()
            local maxGroups

            if difficultyID == 16 then
                -- Эпохальный режим: строго 20 человек (4 группы)
                maxGroups = 4
            else
                -- Остальные режимы: считаем по факту (21 человек = 5 групп)
                maxGroups = math.ceil(numMembers / 5)
            end

            -- Ищем в пределах рассчитанных групп
            for g = 1, maxGroups do
                for m = 1, 5 do
                    local frame = _G["CompactRaidGroup" .. g .. "Member" .. m]
                    if frame and (frame.displayedUnit == unit or frame.unit == unit) then
                        msh.UpdateLayers(frame)
                        return -- Нашли? Выходим
                    end
                end
            end

            -- 2. ЕСЛИ МЫ В ПАТИ ИЛИ СОЛО
        else
            for i = 1, 5 do
                local frame = _G["CompactPartyFrameMember" .. i]
                if frame and (frame.displayedUnit == unit or frame.unit == unit) then
                    msh.UpdateLayers(frame)
                    return -- Нашли? Выходим
                end
            end
        end
    end
end)

hooksecurefunc("CompactUnitFrame_UpdateAll", ApplyMshStyle)

SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = function() ReloadUI() end

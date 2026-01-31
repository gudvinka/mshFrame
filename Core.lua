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
        -- Принудительное обновление всех фреймов при изменении группы
        if CompactRaidFrameContainer and CompactRaidFrameContainer.flowFrames then
            for _, frame in ipairs(CompactRaidFrameContainer.flowFrames) do
                if type(frame) == "table" then ApplyMshStyle(frame) end
            end
        end
    elseif unit then
        -- Ищем фрейм, соответствующий юниту, в реальном времени
        if CompactRaidFrameContainer and CompactRaidFrameContainer.flowFrames then
            for _, frame in ipairs(CompactRaidFrameContainer.flowFrames) do
                if type(frame) == "table" and (frame.displayedUnit == unit or frame.unit == unit) then
                    msh.UpdateLayers(frame)
                end
            end
        end
        -- Проверка для пати
        for i = 1, 5 do
            local frame = _G["CompactPartyFrameMember" .. i]
            if frame and (frame.displayedUnit == unit or frame.unit == unit) then
                msh.UpdateLayers(frame)
            end
        end
    end
end)

hooksecurefunc("CompactUnitFrame_UpdateAll", ApplyMshStyle)

SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = function() ReloadUI() end

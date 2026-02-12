local _, ns = ...
local msh = ns
local LSM = LibStub("LibSharedMedia-3.0")

-- Блокировщик для предотвращения рекурсии
local isSetting = false

local function UpdateCooldownFont(button, fontPath, size)
    if button and button.cooldown then
        -- Находим текст таймера внутри кулдауна
        local cdText = button.cooldown:GetRegions()
        if cdText and cdText.SetFont then
            cdText:SetFont(fontPath, size, "OUTLINE")
        end
    end
end

function msh.UpdateAuras(frame)
    if not frame or frame:IsForbidden() or isSetting then return end

    local cfg = ns.cfg
    if not cfg then return end

    isSetting = true

    local globalFont = msh.db.profile.global.globalFontName
    local localFont = cfg.fontName
    local activeFont

    if localFont and localFont ~= "Default" and localFont ~= "" then
        activeFont = localFont
    else
        activeFont = (globalFont and globalFont ~= "") and globalFont or "Friz Quadrata TT"
    end
    local fontPath = LSM:Fetch("font", activeFont)

    -- Настройки для разных групп аур
    local auraSettings = {
        {
            pool = frame.buffFrames,
            enabled = cfg.showBuffs,
            isBlizz = cfg.useBlizzBuffs,
            isCustom = cfg.showCustomBuffs,
            size = cfg.buffSize,
            point = cfg.buffPoint,
            x = cfg.buffX,
            y = cfg.buffY,
            grow = cfg.buffGrow,
            space = cfg.buffSpacing,
            timer = cfg.showbuffTimer,
            scale = cfg.buffTextScale,
            showTooltip = cfg.showBuffsTooltip
        },
        {
            pool = frame.debuffFrames,
            enabled = cfg.showDebuffs,
            isBlizz = cfg.useBlizzDebuffs,
            isCustom = cfg.showCustomDebuffs,
            size = cfg.debuffSize,
            point = cfg.debuffPoint,
            x = cfg.debuffX,
            y = cfg.debuffY,
            grow = cfg.debuffGrow,
            space = cfg.debuffSpacing,
            timer = cfg.showDebuffTimer,
            scale = cfg.debuffTextScale,
            showTooltip = cfg.showDebuffsTooltip,
            bossScale = cfg.bossDebuffScale,
            isDebuffGroup = cfg.showBossDebuffs,
        },
        {
            pool = { frame.CenterDefensiveBuff or frame.centerStatusIcon },
            enabled = cfg.showBigSave,
            isBlizz = cfg.useBlizzBigSave,
            isCustom = cfg.showCustomBigSave,
            size = cfg.bigSaveSize,
            point = cfg.bigSavePoint,
            x = cfg.bigSaveX,
            y = cfg.bigSaveY,
            grow = "RIGHT",
            space = 0,
            timer = cfg.showBigSaveTimer,
            scale = cfg.bigSaveTextScale,
            showTooltip = cfg.showBigSaveTooltip
        },
        {
            pool = frame.dispelDebuffFrames,
            enabled = cfg.showDispel,
            isBlizz = cfg.useBlizzDispel,
            isCustom = cfg.showCustomDispel,
            size = cfg.dispelSize,
            point = cfg.dispelPoint,
            x = cfg.dispelX,
            y = cfg.dispelY,
            grow = "LEFT",
            space = 2,
            scale = 0.8,
            showTooltip = cfg.showDispelTooltip,
        }
    }

    for _, data in ipairs(auraSettings) do
        if data.pool then
            local previousIcon = nil
            local visibleCount = 0

            local currentIterationPools = {}
            local isBossEnabled = GetCVarBool("raidFramesDisplayLargerRoleSpecificDebuffs")

            if data.isDebuffGroup and isBossEnabled then
                table.insert(currentIterationPools, { p = frame.BossDebuffFrames, isBig = true })
                table.insert(currentIterationPools, { p = frame.debuffFrames, isBig = false })
            else
                table.insert(currentIterationPools, { p = data.pool, isBig = false })
            end


            for _, poolInfo in ipairs(currentIterationPools) do
                local activePool = poolInfo.p
                if activePool then
                    for i = 1, #activePool do
                        local icon = activePool[i]
                        if icon then
                            icon:EnableMouse(data.showTooltip or false)
                            if not data.enabled then
                                if icon:IsShown() then icon:Hide() end
                            elseif icon:IsShown() then
                                visibleCount = visibleCount + 1

                                -- Размер: обычный или увеличенный для босс-аур
                                local currentSize = data.size or 18
                                if poolInfo.isBig then
                                    currentSize = currentSize * (data.bossScale or 1.5)
                                end

                                icon:SetSize(currentSize, currentSize)

                                if data.isCustom then
                                    icon:ClearAllPoints()
                                    if visibleCount == 1 then
                                        icon:SetPoint(data.point or "CENTER", frame, data.x or 0, data.y or 0)
                                    elseif previousIcon then
                                        local anchor, rel = "LEFT", "RIGHT"
                                        local offX, offY = (data.space or 2), 0

                                        if data.grow == "LEFT" then
                                            anchor, rel, offX = "RIGHT", "LEFT", -(data.space or 2)
                                        elseif data.grow == "UP" then
                                            anchor, rel, offX, offY = "BOTTOM", "TOP", 0, (data.space or 2)
                                        elseif data.grow == "DOWN" then
                                            anchor, rel, offX, offY = "TOP", "BOTTOM", 0, -(data.space or 2)
                                        end

                                        -- Используем центровку для корректного отображения иконок разного размера
                                        icon:SetPoint(anchor, previousIcon, rel, offX, offY)
                                    end
                                    previousIcon = icon
                                end

                                if icon.cooldown then
                                    icon.cooldown:SetHideCountdownNumbers(not data.timer)
                                    local fontSize = currentSize * (data.scale or 0.8)
                                    UpdateCooldownFont(icon, fontPath, fontSize)
                                    if data.scale then icon.cooldown:SetScale(data.scale) end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    isSetting = false
end

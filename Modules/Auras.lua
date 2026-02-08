local _, ns = ...
local msh = ns
local LSM = LibStub("LibSharedMedia-3.0")

-- Блокировщик для предотвращения рекурсии
local isSetting = false

function msh.UpdateAuras(frame)
    if not frame or frame:IsForbidden() or isSetting then return end
    local cfg = ns.cfg
    isSetting = true


    -- Настройки для разных групп аур
    local auraSettings = {
        {
            pool = frame.buffFrames,
            enabled = cfg.showBuffs,
            isBlizz = cfg.useBlizzBuffs,
            isCustom = cfg.showCustomBuffs,
            size = cfg.auraSize,
            point = cfg.auraPoint,
            x = cfg.auraX,
            y = cfg.auraY,
            grow = cfg.auraGrow,
            space = cfg.auraSpacing,
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
            showTooltip = cfg.showDebuffsTooltip
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
            showBigSaveTooltip = cfg.showBigSaveTooltip
        },
        -- Диспел обычно либо включен (стандарт), либо нет
        { pool = frame.dispelDebuffFrames, enabled = cfg.showDispel, isCustom = true, size = cfg.dispelSize, point = cfg.dispelPoint, x = cfg.dispelX, y = cfg.dispelY, grow = "LEFT", space = 2, scale = 0.8 }
    }

    for _, data in ipairs(auraSettings) do
        if data.pool then
            local previousIcon = nil
            local visibleCount = 0
            for i = 1, #data.pool do
                local icon = data.pool[i]
                if icon then
                    icon:EnableMouse(data.showTooltip or data.showBigSaveTooltip or false)
                    if not data.enabled then
                        if icon:IsShown() then icon:Hide() end
                    elseif icon:IsShown() then
                        visibleCount = visibleCount + 1


                        icon:SetSize(data.size or 18, data.size or 18)


                        if data.isCustom then
                            icon:ClearAllPoints()
                            if visibleCount == 1 then
                                -- Первая иконка ставится в указанную в конфиге точку (Якорь)
                                icon:SetPoint(data.point or "CENTER", frame, data.x or 0, data.y or 0)
                            elseif previousIcon then
                                -- Логика направления роста для последующих иконок
                                local anchor, rel = "LEFT", "RIGHT"
                                local offX, offY = (data.space or 2), 0

                                if data.grow == "LEFT" then
                                    anchor, rel, offX = "RIGHT", "LEFT", -(data.space or 2)
                                elseif data.grow == "UP" then
                                    anchor, rel, offX, offY = "BOTTOM", "TOP", 0, (data.space or 2)
                                elseif data.grow == "DOWN" then
                                    anchor, rel, offX, offY = "TOP", "BOTTOM", 0, -(data.space or 2)
                                end

                                icon:SetPoint(anchor, previousIcon, rel, offX, offY)
                            end
                            previousIcon = icon
                        end

                        -- ТАЙМЕРЫ (всегда)
                        if icon.cooldown then
                            icon.cooldown:SetHideCountdownNumbers(not data.timer)
                            if data.scale then icon.cooldown:SetScale(data.scale) end
                        end
                    end
                end
            end
        end
    end
    isSetting = false
end

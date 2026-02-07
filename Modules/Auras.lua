local _, ns = ...
local msh = ns
local LSM = LibStub("LibSharedMedia-3.0")

-- Блокировщик для предотвращения рекурсии
local isSetting = false

function msh.UpdateAuras(frame)
    if not frame or frame:IsForbidden() or isSetting then return end
    local cfg = ns.cfg

    -- Настройки для разных групп аур
    local auraSettings = {
        { pool = frame.buffFrames,                                        enabled = cfg.showBuffs,   size = cfg.auraSize,    point = cfg.auraPoint,    x = cfg.auraX,    y = cfg.auraY,    grow = cfg.auraGrow,   space = cfg.auraSpacing,   timer = cfg.showbuffTimer,    scale = cfg.buffTextScale },
        { pool = frame.debuffFrames,                                      enabled = cfg.showDebuffs, size = cfg.debuffSize,  point = cfg.debuffPoint,  x = cfg.debuffX,  y = cfg.debuffY,  grow = cfg.debuffGrow, space = cfg.debuffSpacing, timer = cfg.showDebuffTimer,  scale = cfg.debuffTextScale },
        { pool = frame.dispelDebuffFrames,                                enabled = cfg.showDispel,  size = cfg.dispelSize,  point = cfg.dispelPoint,  x = cfg.dispelX,  y = cfg.dispelY,  grow = "LEFT",         space = 2,                 scale = 0.8 },
        { pool = { frame.CenterDefensiveBuff or frame.centerStatusIcon }, enabled = cfg.showBigSave, size = cfg.bigSaveSize, point = cfg.bigSavePoint, x = cfg.bigSaveX, y = cfg.bigSaveY, grow = "RIGHT",        space = 0,                 timer = cfg.showBigSaveTimer, scale = cfg.bigSaveTextScale }
    }

    isSetting = true
    for _, data in ipairs(auraSettings) do
        if data.pool then
            local previousIcon = nil
            local visibleCount = 0
            local targetSize = data.size or 18

            for i = 1, #data.pool do
                local icon = data.pool[i]
                if icon then
                    -- ПРОВЕРКА: Если группа отключена в конфиге — скрываем иконку
                    if not data.enabled then
                        if icon:IsShown() then icon:Hide() end
                    elseif icon:IsShown() then
                        -- Если иконка видна и включена — обрабатываем позицию
                        visibleCount = visibleCount + 1

                        -- ОПТИМИЗАЦИЯ: Меняем размер только если он реально изменился
                        if icon:GetWidth() ~= targetSize then
                            icon:SetSize(targetSize, targetSize)
                        end

                        -- СИЛОВОЕ ПОЗИЦИОНИРОВАНИЕ: Сбрасываем и ставим заново
                        icon:ClearAllPoints()

                        if visibleCount == 1 then
                            icon:SetPoint(data.point or "BOTTOMLEFT", frame, data.x or 0, data.y or 0)
                        else
                            local anchor, rel = "LEFT", "RIGHT"
                            local offX, offY = (data.space or 2), 0

                            -- Выбор направления роста
                            if data.grow == "LEFT" then
                                anchor, rel, offX = "RIGHT", "LEFT", -(data.space or 2)
                            elseif data.grow == "UP" then
                                anchor, rel, offX, offY = "BOTTOM", "TOP", 0, (data.space or 2)
                            elseif data.grow == "DOWN" then
                                anchor, rel, offX, offY = "TOP", "BOTTOM", 0, -(data.space or 2)
                            end

                            if previousIcon then
                                icon:SetPoint(anchor, previousIcon, rel, offX, offY)
                            end
                        end
                        previousIcon = icon

                        -- ОПТИМИЗАЦИЯ ТАЙМЕРОВ: Обновляем только при изменении настроек
                        if icon.cooldown then
                            if icon.mshLastTimerState ~= data.timer or icon.mshLastScale ~= (data.scale or 1) then
                                icon.cooldown:SetHideCountdownNumbers(not data.timer)
                                if data.scale then icon.cooldown:SetScale(data.scale) end

                                local timerText = icon.cooldown:GetRegions()
                                if timerText and timerText:GetObjectType() == "FontString" then
                                    local font = LSM:Fetch("font", cfg.fontName or "Arial Narrow")
                                    timerText:SetFont(font, (targetSize * 0.55), cfg.nameOutline or "OUTLINE")
                                end

                                icon.mshLastTimerState = data.timer
                                icon.mshLastScale = (data.scale or 1)
                            end
                        end
                    end
                end
            end
        end
    end
    isSetting = false
end

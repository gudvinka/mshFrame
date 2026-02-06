local _, ns = ...
local msh = ns
local LSM = LibStub("LibSharedMedia-3.0")

function msh.UpdateAuras(frame)
    if not frame or frame:IsForbidden() then return end
    local cfg = ns.cfg

    local auraSettings = {
        { -- БАФФЫ
            pool = frame.buffFrames,
            enabled = cfg.showBuffs,
            size = cfg.auraSize,
            point = cfg.auraPoint,
            x = cfg.auraX,
            y = cfg.auraY,
            grow = cfg.auraGrow,
            space = cfg.auraSpacing,
            timer = cfg.showbuffTimer,
            scale = cfg.buffTextScale
        },
        { -- ДЕБАФФЫ
            pool = frame.debuffFrames,
            enabled = true,
            size = cfg.debuffSize,
            point = cfg.debuffPoint,
            x = cfg.debuffX,
            y = cfg.debuffY,
            grow = cfg.debuffGrow,
            space = cfg.debuffSpacing,
            timer = cfg.showDebuffTimer,
            scale = cfg.debuffTextScale
        },
        { -- ИКОНКА ДИСПЕЛА
            pool = frame.dispelDebuffFrames,
            enabled = cfg.showDispel,
            size = cfg.dispelSize,
            point = cfg.dispelPoint,
            x = cfg.dispelX,
            y = cfg.dispelY,
            grow = "LEFT",
            space = 2,
            scale = 0.8
        },
        { -- СЕЙВ
            pool = { frame.CenterDefensiveBuff or frame.centerStatusIcon },
            enabled = cfg.showBigSave,
            size = cfg.bigSaveSize,
            point = cfg.bigSavePoint,
            x = cfg.bigSaveX,
            y = cfg.bigSaveY,
            grow = "RIGHT",
            space = 0,
            timer = cfg.showBigSaveTimer,
            scale = cfg.bigSaveTextScale
        }
    }

    for _, data in ipairs(auraSettings) do
        if data.pool then
            local previousIcon = nil
            local visibleCount = 0

            for i = 1, #data.pool do
                local icon = data.pool[i]
                if icon then
                    if data.enabled == false then
                        icon:SetAlpha(0)
                    elseif icon:IsShown() then
                        icon:SetAlpha(frame:GetAlpha())
                        visibleCount = visibleCount + 1
                        icon:SetSize(data.size or 18, data.size or 18)
                        icon:ClearAllPoints()

                        if visibleCount == 1 then
                            icon:SetPoint(data.point or "CENTER", frame, data.x or 0, data.y or 0)
                        else
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

                        -- РАБОТА С ТЕКСТОМ
                        if icon.cooldown then
                            if data.timer ~= nil then icon.cooldown:SetHideCountdownNumbers(not data.timer) end


                            if data.scale then icon.cooldown:SetScale(data.scale) end


                            local timerText = icon.cooldown:GetRegions()
                            if timerText and timerText:GetObjectType() == "FontString" then
                                local font = LSM:Fetch("font", cfg.fontName)
                                -- Размер шрифта привязан к размеру иконки * 0.6
                                timerText:SetFont(font, (data.size or 18) * 0.6, cfg.nameOutline or "OUTLINE")
                            end
                        end
                    end
                end
            end
        end
    end
end

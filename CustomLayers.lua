local addonName, ns = ...
local msh = ns
local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("font", "Montserrat-SemiBold", [[Interface\AddOns\mshFrame\Media\Montserrat-SemiBold.ttf]])

-- ФУНКЦИЯ ОБНОВЛЕНИЯ АУР
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

-- Хук, чтобы Близзарды не перехватывали позицию
hooksecurefunc("CompactUnitFrame_UpdateAuras", function(frame)
    if frame.mshLayersCreated then
        msh.UpdateAuras(frame)
    end
end)

-- СОЗДАНИЕ СЛОЕВ
function msh.CreateLayers(frame)
    local cfg = ns.cfg
    if not frame.mshLayersCreated then
        frame.mshName = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        if frame.name then frame.name:SetAlpha(0) end

        frame.mshHP = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        if frame.statusText then frame.statusText:SetAlpha(0) end

        frame.mshLayersCreated = true
    end
end

-- ОБНОВЛЕНИЕ ТЕКСТА И РОЛИ
function msh.UpdateLayers(frame)
    if not frame or not frame.mshLayersCreated then return end
    local unit = frame.displayedUnit or frame.unit
    if not unit or not UnitExists(unit) then return end
    local cfg = ns.cfg

    -- Имя
    local fontPathName = LSM:Fetch("font", cfg.fontName) or cfg.fontName or [[Fonts\FRIZQT__.TTF]]
    local nOutline = (cfg.nameOutline == "NONE") and "" or (cfg.nameOutline or "OUTLINE")
    frame.mshName:SetFont(fontPathName, cfg.fontSizeName or 12, nOutline)
    frame.mshName:ClearAllPoints()
    frame.mshName:SetPoint(cfg.namePoint, frame, cfg.nameX, cfg.nameY)
    frame.mshName:SetText(msh.GetShortName(unit))
    frame.mshName:SetAlpha(1)

    -- ХП
    local fontPathStatus = LSM:Fetch("font", cfg.fontStatus) or cfg.fontStatus or [[Fonts\FRIZQT__.TTF]]
    local sOutline = (cfg.statusOutline == "NONE") and "" or (cfg.statusOutline or "OUTLINE")
    frame.mshHP:SetFont(fontPathStatus, cfg.fontSizeStatus or 12, sOutline)
    frame.mshHP:ClearAllPoints()
    frame.mshHP:SetPoint(cfg.statusPoint, frame, cfg.statusX, cfg.statusY)
    frame.mshHP:SetAlpha(1)

    if cfg.hpMode == "NONE" then
        frame.mshHP:SetText("")
    elseif frame.statusText then
        frame.mshHP:SetText(frame.statusText:GetText() or "")
    end

    -- РОЛЬ
    if frame.roleIcon then
        frame.roleIcon:SetTexture(nil)
        frame.roleIcon:SetAlpha(0)
        frame.roleIcon:Hide()


        if not frame.roleIcon.mshHooked then
            hooksecurefunc(frame.roleIcon, "SetTexture", function(self, tex)
                if tex ~= nil then self:SetTexture(nil) end
            end)
            hooksecurefunc(frame.roleIcon, "Show", function(self) self:Hide() end)
            frame.roleIcon.mshHooked = true
        end
    end

    -- ИКОНКА РОЛИ
    if not frame.mshRole then
        frame.mshRole = frame:CreateTexture(nil, "OVERLAY")
    end

    if cfg.showRoleIcon then
        local role = UnitGroupRolesAssigned(unit)
        if role and role ~= "NONE" then
            frame.mshRole:SetSize(cfg.roleIconSize, cfg.roleIconSize)
            frame.mshRole:ClearAllPoints()
            frame.mshRole:SetPoint(cfg.roleIconPoint, frame, cfg.roleIconX, cfg.roleIconY)


            frame.mshRole:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]])
            if role == "TANK" then
                frame.mshRole:SetTexCoord(0, 19 / 64, 22 / 64, 41 / 64)
            elseif role == "HEALER" then
                frame.mshRole:SetTexCoord(20 / 64, 39 / 64, 1 / 64, 20 / 64)
            elseif role == "DAMAGER" then
                frame.mshRole:SetTexCoord(20 / 64, 39 / 64, 22 / 64, 41 / 64)
            end


            frame.mshRole:SetAlpha(frame:GetAlpha())
            frame.mshRole:Show()
        else
            frame.mshRole:Hide()
        end
    else
        frame.mshRole:Hide()
    end

    -- РЕЙДОВЫЕ МЕТКИ
    if not frame.mshRaidIcon then
        frame.mshRaidIcon = frame:CreateTexture(nil, "OVERLAY", nil, 7)
    end

    local rIcon = frame.mshRaidIcon
    local index = GetRaidTargetIndex(unit)

    if index and cfg.showRaidMark then
        rIcon:SetSize(cfg.raidMarkSize or 18, cfg.raidMarkSize or 18)
        rIcon:ClearAllPoints()
        rIcon:SetPoint(cfg.raidMarkPoint or "CENTER", frame, cfg.raidMarkX or 0, cfg.raidMarkY or 0)

        rIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
        SetRaidTargetIconTexture(rIcon, index)


        rIcon:SetAlpha(frame:GetAlpha())
        rIcon:Show()
    else
        rIcon:Hide()
    end

    msh.UpdateAuras(frame)
end

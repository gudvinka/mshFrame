local addonName, ns = ...

-- Инициализируем аддон через AceAddon, чтобы OnInitialize в Config.lua сработал
local msh = LibStub("AceAddon-3.0"):NewAddon(ns, addonName, "AceEvent-3.0")
-- Теперь ns и msh — это один и тот же объект аддона

function msh.ApplyStyle(frame)
    if not ns.cfg or not frame or frame:IsForbidden() then return end

    local frameName = frame:GetName() or ""
    if not (frameName:find("CompactRaid") or frameName:find("CompactParty")) or frameName:find("Pet") then
        return
    end

    -- Вызов функций из модулей
    if msh.CreateUnitLayers then msh.CreateUnitLayers(frame) end
    if msh.UpdateUnitDisplay then msh.UpdateUnitDisplay(frame) end
    if msh.UpdateHealthDisplay then msh.UpdateHealthDisplay(frame) end
    if msh.UpdateAuras then msh.UpdateAuras(frame) end
end

-- Основные хуки Blizzard
hooksecurefunc("CompactUnitFrame_UpdateAll", msh.ApplyStyle)
hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
    if frame.mshLayersCreated then msh.UpdateUnitDisplay(frame) end
end)
hooksecurefunc("CompactUnitFrame_UpdateStatusText", function(frame)
    if frame.mshLayersCreated then msh.UpdateHealthDisplay(frame) end
end)
hooksecurefunc("CompactUnitFrame_UpdateAuras", function(frame)
    if frame.mshLayersCreated then msh.UpdateAuras(frame) end
end)

-- Регистрация событий
function msh:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function()
        if msh.SyncBlizzardSettings then msh.SyncBlizzardSettings() end
    end)
end

-- Быстрая перезагрузка
SLASH_RL1 = "/rl"
SlashCmdList["RL"] = ReloadUI

local addonName, ns = ...
_G.msh = ns -- Делаем ns доступным как msh в других файлах

local LSM = LibStub("LibSharedMedia-3.0", true)
if not LSM then return end

-- Регистрация фонта
LSM:Register("font", "Montserrat SemiBold", [[Interface\AddOns\mshFrame\Media\Montserrat-SemiBold.ttf]])

-- Таблица настроек
ns.cfg = {
    font = "Montserrat SemiBold",
    fontSizeName = 12,
    fontSizeStatus = 12,
    texture = "Perl",

    -- Координаты имени
    namePoint = "TOPLEFT",
    nameX = 22,
    nameY = -4,

    -- Координаты статуса (ХП)
    statusPoint = "RIGHT",
    statusX = -5,
    statusY = 0,
}

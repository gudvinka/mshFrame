local addonName, ns = ...
local msh = ns

-- Создаем таблицу конфигурации внутри общего пространства ns
ns.cfg = {}

-- 1. ШРИФТЫ И ТЕКСТУРЫ
ns.cfg.font = [[Interface\AddOns\mshFrame\Media\Montserrat-SemiBold.ttf]]
ns.cfg.texture = "Perl" -- Название из SharedMedia

-- 2. НАСТРОЙКИ ИМЕНИ
ns.cfg.fontSizeName = 12
ns.cfg.namePoint = "TOPLEFT"
ns.cfg.nameX = 20
ns.cfg.nameY = -4
ns.cfg.nameLength = 6      -- До какого символа обрезать имя
ns.cfg.shortenNames = true -- enable cut

-- 3. НАСТРОЙКИ ХП (СТАТУСА)
ns.cfg.fontSizeStatus = 12
ns.cfg.statusPoint = "BOTTOMLEFT"
ns.cfg.statusX = 4
ns.cfg.statusY = 4

-- РЕЖИМ ОТОБРАЖЕНИЯ ХП
-- РЕЖИМ ХП: "PERCENT", "VALUE", "BOTH", "NONE"
ns.cfg.hpMode = "VALUE"

-- 5. ИКОНКИ РОЛЕЙ (ROLE ICON)
ns.cfg.showRoleIcon = true
ns.cfg.roleIconSize = 30
ns.cfg.roleIconPoint = "TOPLEFT"
ns.cfg.roleIconX = 4
ns.cfg.roleIconY = -4

-- 6. АУРЫ (БАФЫ И ДЕБАФЫ)
-- Общие настройки
ns.cfg.auraTextScale = 0.6 -- Множитель размера текста (от 0.1 до 1.0)
ns.cfg.showAuraTimer = true

-- Баффы
ns.cfg.auraSize = 20
ns.cfg.auraPoint = "TOPLEFT"
ns.cfg.auraX = 0
ns.cfg.auraY = 0
ns.cfg.auraGrow = "RIGHT" -- Куда растут: "RIGHT" (вправо) или "LEFT" (влево)
ns.cfg.auraSpacing = 2    -- Отступ между иконками

-- Дебаффы
ns.cfg.debuffSize = 20
ns.cfg.debuffPoint = "BOTTOMRIGHT"
ns.cfg.debuffX = 1
ns.cfg.debuffY = 1
ns.cfg.debuffGrow = "LEFT" -- Рост влево (навстречу баффам)
ns.cfg.debuffSpacing = 3



-- 7. ИНДИКАТОРЫ ДИСПЕЛА (Dispellable Debuffs)
ns.cfg.dispelSize = 30          -- Размер индикатора
ns.cfg.dispelPoint = "TOPRIGHT" -- Место привязки
ns.cfg.dispelX = -2             -- Смещение влево
ns.cfg.dispelY = 2              -- Смещение вверх
ns.cfg.dispelGrow = "LEFT"      -- Рост влево
ns.cfg.dispelSpacing = 2

-- 8. ЦЕНТРАЛЬНЫЙ СЕЙВ (Center Defensive Buff)
ns.cfg.bigDefSize = 30 -- Обычно его делают крупнее остальных
ns.cfg.bigDefPoint = "CENTER"
ns.cfg.bigDefX = 0
ns.cfg.bigDefY = 0

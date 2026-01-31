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

-- 3. НАСТРОЙКИ ХП (СТАТУСА)
ns.cfg.fontSizeStatus = 12
ns.cfg.statusPoint = "BOTTOMLEFT"
ns.cfg.statusX = 4
ns.cfg.statusY = 4

-- РЕЖИМ ОТОБРАЖЕНИЯ ХП
-- РЕЖИМ ХП: "PERCENT", "VALUE", "BOTH", "NONE"
ns.cfg.hpMode = "NONE"

-- 4. ЦВЕТА
ns.cfg.useClassColors = false
ns.cfg.staticColor = { 0.00, 1.00, 0.59 } -- monk

-- 5. ФОРМАТИРОВАНИЕ
ns.cfg.shortenNames = true -- Исправлено: теперь ns.cfg

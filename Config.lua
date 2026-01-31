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
-- Баффы
ns.cfg.auraSize = 60
ns.cfg.auraPoint = "TOPRIGHT"
ns.cfg.auraX = 0
ns.cfg.auraY = 0
ns.cfg.auraGrow = "LEFT" -- Куда растут: "RIGHT" (вправо) или "LEFT" (влево)
ns.cfg.auraSpacing = 2   -- Отступ между иконками

-- Дебаффы
ns.cfg.debuffSize = 50
ns.cfg.debuffPoint = "BOTTOMRIGHT"
ns.cfg.debuffX = -5
ns.cfg.debuffY = -15
ns.cfg.debuffGrow = "LEFT" -- Рост влево (навстречу баффам)
ns.cfg.debuffSpacing = 3

-- Общие настройки
ns.cfg.showAuraTimer = true

local addonName, ns = ...
local msh = ns
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

ns.needsReload = false

-- СПИСКИ ДЛЯ ВЫПАДАЮЩИХ МЕНЮ
local anchorPoints = {
    ["TOPLEFT"] = "Сверху слева",
    ["TOP"] = "Сверху",
    ["TOPRIGHT"] = "Сверху справа",
    ["LEFT"] = "Слева",
    ["CENTER"] = "Центр",
    ["RIGHT"] = "Справа",
    ["BOTTOMLEFT"] = "Снизу слева",
    ["BOTTOM"] = "Снизу",
    ["BOTTOMRIGHT"] = "Снизу справа",
}

local outlineModes = {
    ["NONE"] = "Нет", ["OUTLINE"] = "Тонкий", ["THICKOUTLINE"] = "Жирный", ["MONOCHROME"] = "Пиксельный",
}

-- Функция обновления фреймов при изменении настроек
local function Refresh()
    local function UpdateFrame(frame)
        -- Проверка: что это таблица, у нее есть метод IsForbidden и она не защищена Blizzard
        if type(frame) ~= "table" or not frame.IsForbidden or frame:IsForbidden() then
            return
        end

        -- Вызываем обновления только если функции существуют
        if msh.UpdateUnitDisplay then msh.UpdateUnitDisplay(frame) end
        if msh.UpdateHealthDisplay then msh.UpdateHealthDisplay(frame) end
        if msh.UpdateAuras then msh.UpdateAuras(frame) end
    end

    -- Перебор всех стандартных компактных фреймов рейда и пати
    -- (Именно здесь летела ошибка, если в итератор попадал мусор)
    for i = 1, 40 do
        local raidFrame = _G["CompactRaidFrame" .. i]
        if raidFrame then UpdateFrame(raidFrame) end

        local partyFrame = _G["CompactPartyFrameMember" .. i]
        if partyFrame then UpdateFrame(partyFrame) end
    end

    -- Также обновляем контейнеры, если они есть
    if CompactRaidFrameContainer then
        local children = { CompactRaidFrameContainer:GetChildren() }
        for _, frame in ipairs(children) do
            UpdateFrame(frame)
        end
    end
end

-- ДЕФОЛТНЫЕ НАСТРОЙКИ
ns.defaults = {
    profile = {
        texture = "Flat",
        fontName = "Montserrat-SemiBold",
        fontStatus = "Montserrat-SemiBold",
        fontSizeName = 12,
        nameOutline = "OUTLINE",

        -- Имя
        shortenNames = true,
        nameLength = 5,
        namePoint = "CENTER",
        nameX = 0,
        nameY = 0,

        -- Здоровье (CVars)
        fontSizeStatus = 10,
        statusOutline = "OUTLINE",
        statusPoint = "BOTTOMRIGHT",
        statusX = -2,
        statusY = 2,
        hpMode = "PERCENT",

        -- Роли и метки
        showRoleIcon = true,
        roleIconSize = 12,
        roleIconPoint = "TOPLEFT",
        roleIconX = 2,
        roleIconY = -2,

        showRaidMark = true,
        raidMarkSize = 14,
        raidMarkPoint = "TOP",
        raidMarkX = 0,
        raidMarkY = -2,

        -- Ауры (базовая часть)
        showBuffs = true,
        auraSize = 18,
        auraPoint = "BOTTOMLEFT",
        auraX = 2,
        auraY = 2,
        auraGrow = "RIGHT",
        auraSpacing = 2,
        showbuffTimer = true,
        useBlizzRole = false, -- по умолчанию выключено, используем наш кастом
    }
}

-- ТАБЛИЦА ОПЦИЙ (AceConfig)
ns.options = {
    name = "|cffffffffmsh|rFrames",
    type = "group",
    childGroups = "tab",
    args = {
        logo = {
            type = "description",
            name = " ",
            image = [[Interface\AddOns\mshFrame\Media\logo]],
            imageWidth = 150,
            imageHeight = 150,
            order = 0,
        },
        warning = {
            type = "description",
            name =
            "\n|cffff0000ВНИМАНИЕ:|r Вы изменили настройки, требующие перезагрузки интерфейса (|cffffff00/reload|r).",
            fontSize = "medium",
            order = 0.1,
            hidden = function() return not ns.needsReload end,
        },
        auraGroup = {
            name = "Ауры",
            type = "group",
            order = 7,
            childGroups = "tab",
            args = {
                buffs = {
                    name = "Баффы",
                    type = "group",
                    order = 1,
                    args = {
                        showBuffs = {
                            type = "toggle",
                            name = "Включить",
                            order = 1,
                            get = function()
                                return ns.cfg
                                    .showBuffs
                            end,
                            set = function(_, v)
                                ns.cfg.showBuffs = v; Refresh()
                            end
                        },
                        auraSize = {
                            type = "range",
                            name = "Размер",
                            order = 2,
                            min = 8,
                            max = 40,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.auraSize
                            end,
                            set = function(_, v)
                                ns.cfg.auraSize = v; Refresh()
                            end
                        },
                        auraPoint = {
                            type = "select",
                            name = "Якорь",
                            order = 3,
                            values = anchorPoints,
                            get = function()
                                return
                                    ns.cfg.auraPoint
                            end,
                            set = function(_, v)
                                ns.cfg.auraPoint = v; Refresh()
                            end
                        },
                        auraX = {
                            type = "range",
                            name = "X",
                            order = 4,
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.auraX
                            end,
                            set = function(_, v)
                                ns.cfg.auraX = v; Refresh()
                            end
                        },
                        auraY = {
                            type = "range",
                            name = "Y",
                            order = 5,
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.auraY
                            end,
                            set = function(_, v)
                                ns.cfg.auraY = v; Refresh()
                            end
                        },
                        auraGrow = {
                            type = "select",
                            name = "Рост",
                            order = 6,
                            values = { ["LEFT"] = "Влево", ["RIGHT"] = "Вправо", ["UP"] = "Вверх", ["DOWN"] = "Вниз" },
                            get = function()
                                return
                                    ns.cfg.auraGrow
                            end,
                            set = function(_, v)
                                ns.cfg.auraGrow = v; Refresh()
                            end
                        },
                        auraSpacing = {
                            type = "range",
                            name = "Отступ",
                            order = 7,
                            min = 0,
                            max = 10,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.auraSpacing
                            end,
                            set = function(_, v)
                                ns.cfg.auraSpacing = v; Refresh()
                            end
                        },
                        showbuffTimer = {
                            type = "toggle",
                            name = "Таймер",
                            order = 8,
                            get = function()
                                return ns.cfg
                                    .showbuffTimer
                            end,
                            set = function(_, v)
                                ns.cfg.showbuffTimer = v; Refresh()
                            end
                        },
                        buffTextScale = {
                            type = "range",
                            name = "Масштаб текста",
                            order = 9,
                            min = 0.5,
                            max = 2,
                            step = 0.1,
                            get = function()
                                return
                                    ns.cfg.buffTextScale
                            end,
                            set = function(_, v)
                                ns.cfg.buffTextScale = v; Refresh()
                            end
                        },
                    }
                },
                debuffs = {
                    name = "Дебаффы",
                    type = "group",
                    order = 2,
                    args = {
                        showDebuffs = {
                            type = "toggle",
                            name = "Включить",
                            order = 1,
                            get = function()
                                return ns.cfg
                                    .showDebuffs
                            end,
                            set = function(_, v)
                                ns.cfg.showDebuffs = v
                                if msh.SyncBlizzardSettings then
                                    msh.SyncBlizzardSettings()
                                end
                                ns.needsReload = true
                                Refresh()
                            end
                        },
                        showOnlyDispellable = {
                            type = "toggle",
                            name = "Только диспелы",
                            desc = "Показывать только те дебаффы, которые вы можете снять своим классом.",
                            order = 1.1,
                            disabled = function() return not ns.cfg.showDebuffs end,
                            get = function() return ns.cfg.showOnlyDispellable end,
                            set = function(_, v)
                                ns.cfg.showOnlyDispellable = v
                                if msh.SyncBlizzardSettings then msh.SyncBlizzardSettings() end
                                ns.needsReload = true
                                Refresh()
                            end,
                        },
                        debuffSize = {
                            type = "range",
                            name = "Размер",
                            order = 2,
                            min = 8,
                            max = 40,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.debuffSize
                            end,
                            set = function(_, v)
                                ns.cfg.debuffSize = v; Refresh()
                            end
                        },
                        debuffPoint = {
                            type = "select",
                            name = "Якорь",
                            order = 3,
                            values = anchorPoints,
                            get = function()
                                return
                                    ns.cfg.debuffPoint
                            end,
                            set = function(_, v)
                                ns.cfg.debuffPoint = v; Refresh()
                            end
                        },
                        debuffX = {
                            type = "range",
                            name = "X",
                            order = 4,
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.debuffX
                            end,
                            set = function(_, v)
                                ns.cfg.debuffX = v; Refresh()
                            end
                        },
                        debuffY = {
                            type = "range",
                            name = "Y",
                            order = 5,
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.debuffY
                            end,
                            set = function(_, v)
                                ns.cfg.debuffY = v; Refresh()
                            end
                        },
                        debuffGrow = {
                            type = "select",
                            name = "Рост",
                            order = 6,
                            values = { ["LEFT"] = "Влево", ["RIGHT"] = "Вправо" },
                            get = function()
                                return
                                    ns.cfg.debuffGrow
                            end,
                            set = function(_, v)
                                ns.cfg.debuffGrow = v; Refresh()
                            end
                        },
                        debuffSpacing = {
                            type = "range",
                            name = "Отступ",
                            order = 7,
                            min = 0,
                            max = 10,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.debuffSpacing
                            end,
                            set = function(_, v)
                                ns.cfg.debuffSpacing = v; Refresh()
                            end
                        },
                        showDebuffTimer = {
                            type = "toggle",
                            name = "Таймер",
                            order = 8,
                            get = function()
                                return
                                    ns.cfg.showDebuffTimer
                            end,
                            set = function(_, v)
                                ns.cfg.showDebuffTimer = v; Refresh()
                            end
                        },
                        debuffTextScale = {
                            type = "range",
                            name = "Масштаб текста",
                            order = 10,
                            min = 0.5,
                            max = 2,
                            step = 0.1,
                            get = function()
                                return
                                    ns.cfg.debuffTextScale
                            end,
                            set = function(_, v)
                                ns.cfg.debuffTextScale = v; Refresh()
                            end
                        },
                    }
                },
                dispel = {
                    name = "Диспел",
                    type = "group",
                    order = 3,
                    args = {
                        showDispel = {
                            type = "toggle",
                            name = "Включить",
                            order = 1,
                            get = function() return ns.cfg.showDispel end,
                            set = function(_, v)
                                ns.cfg.showDispel = v; Refresh()
                            end
                        },
                        dispelSize = {
                            type = "range",
                            name = "Размер",
                            order = 1,
                            min = 8,
                            max = 40,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.dispelSize
                            end,
                            set = function(_, v)
                                ns.cfg.dispelSize = v; Refresh()
                            end
                        },
                        dispelPoint = {
                            type = "select",
                            name = "Якорь",
                            order = 2,
                            values = anchorPoints,
                            get = function()
                                return
                                    ns.cfg.dispelPoint
                            end,
                            set = function(_, v)
                                ns.cfg.dispelPoint = v; Refresh()
                            end
                        },
                        dispelX = {
                            type = "range",
                            name = "X",
                            order = 3,
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.dispelX
                            end,
                            set = function(_, v)
                                ns.cfg.dispelX = v; Refresh()
                            end
                        },
                        dispelY = {
                            type = "range",
                            name = "Y",
                            order = 4,
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.dispelY
                            end,
                            set = function(_, v)
                                ns.cfg.dispelY = v; Refresh()
                            end
                        },
                    }
                },
                bigSave = {
                    name = "Сейв",
                    type = "group",
                    order = 4,
                    args = {
                        showBigSave = {
                            type = "toggle",
                            name = "Включить",
                            order = 1,
                            get = function() return ns.cfg.showBigSave end,
                            set = function(_, v)
                                ns.cfg.showBigSave = v;
                                if ns.SyncBlizzardSettings then
                                    ns.SyncBlizzardSettings()
                                end
                                ns.needsReload = true;
                                Refresh()
                            end
                        },
                        showBigSaveTimer = {
                            type = "toggle",
                            name = "Таймер",
                            order = 8,
                            get = function()
                                return
                                    ns.cfg.showBigSaveTimer
                            end,
                            set = function(_, v)
                                ns.cfg.showBigSaveTimer = v; Refresh()
                            end
                        },
                        bigSaveSize = {
                            type = "range",
                            name = "Размер",
                            order = 1,
                            min = 10,
                            max = 60,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.bigSaveSize
                            end,
                            set = function(_, v)
                                ns.cfg.bigSaveSize = v; Refresh()
                            end
                        },
                        bigSavePoint = {
                            type = "select",
                            name = "Якорь",
                            order = 2,
                            values = anchorPoints,
                            get = function()
                                return
                                    ns.cfg.bigSavePoint
                            end,
                            set = function(_, v)
                                ns.cfg.bigSavePoint = v; Refresh()
                            end
                        },
                        bigSaveX = {
                            type = "range",
                            name = "X",
                            order = 3,
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.bigSaveX
                            end,
                            set = function(_, v)
                                ns.cfg.bigSaveX = v; Refresh()
                            end
                        },
                        bigSaveY = {
                            type = "range",
                            name = "Y",
                            order = 4,
                            min = -100,
                            max = 100,
                            step = 1,
                            get = function()
                                return
                                    ns.cfg.bigSaveY
                            end,
                            set = function(_, v)
                                ns.cfg.bigSaveY = v; Refresh()
                            end
                        },
                        bigSaveTextScale = {
                            type = "range",
                            name = "Масштаб текста",
                            order = 10,
                            min = 0.5,
                            max = 2,
                            step = 0.1,
                            get = function()
                                return
                                    ns.cfg.bigSaveTextScale
                            end,
                            set = function(_, v)
                                ns.cfg.bigSaveTextScale = v; Refresh()
                            end
                        },
                    }
                },
            }
        },
        raidMarkGroup = {
            name = "Рейдовые метки",
            type = "group",
            order = 5,
            args = {
                showRaidMark = {
                    type = "toggle",
                    name = "Включить метки",
                    order = 1,
                    get = function() return ns.cfg.showRaidMark end,
                    set = function(_, v)
                        ns.cfg.showRaidMark = v; Refresh()
                    end,
                },
                raidMarkSize = {
                    type = "range",
                    name = "Размер",
                    order = 2,
                    min = 8,
                    max = 60,
                    step = 1,
                    get = function() return ns.cfg.raidMarkSize end,
                    set = function(_, v)
                        ns.cfg.raidMarkSize = v; Refresh()
                    end,
                },
                raidMarkPoint = {
                    type = "select",
                    name = "Якорь",
                    order = 3,
                    values = anchorPoints,
                    get = function() return ns.cfg.raidMarkPoint end,
                    set = function(_, v)
                        ns.cfg.raidMarkPoint = v; Refresh()
                    end,
                },
                raidMarkX = {
                    type = "range",
                    name = "Смещение X",
                    order = 4,
                    min = -100,
                    max = 100,
                    step = 1,
                    get = function() return ns.cfg.raidMarkX end,
                    set = function(_, v)
                        ns.cfg.raidMarkX = v; Refresh()
                    end,
                },
                raidMarkY = {
                    type = "range",
                    name = "Смещение Y",
                    order = 5,
                    min = -100,
                    max = 100,
                    step = 1,
                    get = function() return ns.cfg.raidMarkY end,
                    set = function(_, v)
                        ns.cfg.raidMarkY = v; Refresh()
                    end,
                },
            }
        },

        roleGroup = {
            name = "Иконки ролей",
            type = "group",
            order = 6,
            args = {
                useBlizzRole = {
                    type = "toggle",
                    name = "|cff00ff00Использовать стандарт (Blizzard)|r",
                    desc = "Полностью отключает кастомизацию ролей и возвращает родные иконки игры.",
                    order = 0,
                    get = function(_) return ns.cfg.useBlizzRole end,
                    set = function(_, v)
                        ns.cfg.useBlizzRole = v; Refresh()
                    end,
                },
                showRoleIcon = {
                    type = "toggle",
                    name = "Включить кастомные иконки ролей",
                    desc = "Отображает иконку танка, целителя или урона",
                    order = 1,
                    disabled = function() return ns.cfg.useBlizzRole end, -- Блокировка
                    get = function(_) return ns.cfg.showRoleIcon end,
                    set = function(_, v)
                        ns.cfg.showRoleIcon = v; Refresh()
                    end,
                },
                roleIconSize = {
                    type = "range",
                    name = "Размер",
                    order = 2,
                    min = 8,
                    max = 40,
                    step = 1,
                    disabled = function() return ns.cfg.useBlizzRole end, -- Блокировка
                    get = function() return ns.cfg.roleIconSize end,
                    set = function(_, v)
                        ns.cfg.roleIconSize = v; Refresh()
                    end,
                },
                roleIconPoint = {
                    type = "select",
                    name = "Якорь",
                    order = 3,
                    values = anchorPoints,
                    disabled = function() return ns.cfg.useBlizzRole end, -- Блокировка
                    get = function() return ns.cfg.roleIconPoint end,
                    set = function(_, v)
                        ns.cfg.roleIconPoint = v; Refresh()
                    end,
                },
                roleIconX = {
                    type = "range",
                    name = "Смещение X",
                    order = 4,
                    min = -50,
                    max = 50,
                    step = 1,
                    disabled = function() return ns.cfg.useBlizzRole end, -- Блокировка
                    get = function() return ns.cfg.roleIconX end,
                    set = function(_, v)
                        ns.cfg.roleIconX = v; Refresh()
                    end,
                },
                roleIconY = {
                    type = "range",
                    name = "Смещение Y",
                    order = 5,
                    min = -50,
                    max = 50,
                    step = 1,
                    disabled = function() return ns.cfg.useBlizzRole end, -- Блокировка
                    get = function() return ns.cfg.roleIconY end,
                    set = function(_, v)
                        ns.cfg.roleIconY = v; Refresh()
                    end,
                },
            }
        },
        general = {
            name = "Внешний вид",
            type = "group",
            order = 1,
            args = {
                texture = {
                    type = "select",
                    name = "Текстура",
                    order = 1,
                    dialogControl = "LSM30_Statusbar",
                    values = AceGUIWidgetLSMlists.statusbar,
                    get = function() return ns.cfg.texture end,
                    set = function(_, v)
                        ns.cfg.texture = v; Refresh()
                    end,
                },
            }
        },

        nameGroup = {
            name = "Имя",
            type = "group",
            order = 2,
            args = {
                fontName = {
                    type = "select",
                    name = "Шрифт имени",
                    order = 1,
                    values = function() return LibStub("LibSharedMedia-3.0"):HashTable("font") end,
                    dialogControl = "LSM30_Font",
                    get = function() return ns.cfg.fontName end,
                    set = function(_, v)
                        ns.cfg.fontName = v; Refresh()
                    end,
                },
                nameOutline = {
                    type = "select",
                    name = "Контур текста",
                    order = 1.1,
                    values = outlineModes,
                    get = function() return ns.cfg.nameOutline or "OUTLINE" end,
                    set = function(_, v)
                        ns.cfg.nameOutline = v; Refresh()
                    end,
                },
                fontSize = {
                    type = "range",
                    name = "Размер",
                    order = 2,
                    min = 6,
                    max = 32,
                    step = 1,
                    get = function() return ns.cfg.fontSizeName end,
                    set = function(_, v)
                        ns.cfg.fontSizeName = v; Refresh()
                    end,
                },

                shortenNames = {
                    type = "toggle",
                    name = "Обрезать имя",
                    desc = "Включает сокращение длинных имен",
                    order = 2.1,
                    get = function() return ns.cfg.shortenNames end,
                    set = function(_, v)
                        ns.cfg.shortenNames = v; Refresh()
                    end,
                },
                nameLength = {
                    type = "range",
                    name = "Длина имени",
                    desc = "Количество символов, если включена обрезка",
                    order = 2.2,
                    min = 2,
                    max = 20,
                    step = 1,
                    disabled = function() return not ns.cfg.shortenNames end,
                    get = function() return ns.cfg.nameLength end,
                    set = function(_, v)
                        ns.cfg.nameLength = v; Refresh()
                    end,
                },
                namePoint = {
                    type = "select",
                    name = "Точка привязки",
                    order = 3,
                    values = anchorPoints,
                    get = function() return ns.cfg.namePoint end,
                    set = function(_, v)
                        ns.cfg.namePoint = v; Refresh()
                    end,
                },
                nameX = {
                    type = "range",
                    name = "Смещение X",
                    order = 4,
                    min = -100,
                    max = 100,
                    step = 1,
                    get = function() return ns.cfg.nameX end,
                    set = function(_, v)
                        ns.cfg.nameX = v; Refresh()
                    end,
                },
                nameY = {
                    type = "range",
                    name = "Смещение Y",
                    order = 5,
                    min = -100,
                    max = 100,
                    step = 1,
                    get = function() return ns.cfg.nameY end,
                    set = function(_, v)
                        ns.cfg.nameY = v; Refresh()
                    end,
                },

            }
        },
        healthGroup = {
            name = "Здоровье",
            type = "group",
            order = 3,
            args = {
                fontStatus = {
                    type = "select",
                    name = "Шрифт",
                    order = 1,
                    values = function() return LibStub("LibSharedMedia-3.0"):HashTable("font") end,
                    dialogControl = "LSM30_Font",
                    get = function() return ns.cfg.fontStatus end,
                    set = function(_, v)
                        ns.cfg.fontStatus = v; Refresh()
                    end,
                },
                statusOutline = {
                    type = "select",
                    name = "Контур",
                    order = 1.1,
                    values = outlineModes,
                    get = function() return ns.cfg.statusOutline or "OUTLINE" end,
                    set = function(_, v)
                        ns.cfg.statusOutline = v; Refresh()
                    end,
                },
                fontSizeStatus = {
                    type = "range",
                    name = "Размер",
                    order = 2,
                    min = 6,
                    max = 32,
                    step = 1,
                    get = function() return ns.cfg.fontSizeStatus end,
                    set = function(_, v)
                        ns.cfg.fontSizeStatus = v; Refresh()
                    end,
                },
                hpMode = {
                    type = "select",
                    name = "Режим ХП",
                    order = 3,
                    values = {
                        ["VALUE"] = "Цифры",
                        ["PERCENT"] = "Проценты",
                        ["NONE"] = "Скрыть"
                    },
                    get = function() return ns.cfg.hpMode end,
                    set = function(_, v)
                        if ns.cfg.hpMode ~= v then
                            ns.cfg.hpMode = v;
                            if ns.SyncBlizzardSettings then ns.SyncBlizzardSettings() end
                            Refresh()
                        end
                    end,
                },
                statusPoint = {
                    type = "select",
                    name = "Якорь ХП",
                    order = 4,
                    values = anchorPoints,
                    get = function() return ns.cfg.statusPoint end,
                    set = function(_, v)
                        ns.cfg.statusPoint = v; Refresh()
                    end,
                },
                statusX = {
                    type = "range",
                    name = "X",
                    order = 5,
                    min = -100,
                    max = 100,
                    step = 1,
                    get = function()
                        return
                            ns.cfg.statusX
                    end,
                    set = function(_, v)
                        ns.cfg.statusX = v; Refresh()
                    end
                },
                statusY = {
                    type = "range",
                    name = "Y",
                    order = 6,
                    min = -100,
                    max = 100,
                    step = 1,
                    get = function()
                        return
                            ns.cfg.statusY
                    end,
                    set = function(_, v)
                        ns.cfg.statusY = v; Refresh()
                    end
                },
            }
        },
    }
}


-- ИНИЦИАЛИЗАЦИЯ (Запускается AceAddon-ом)
function msh:OnInitialize()
    local fontName = "Montserrat-SemiBold"
    local fontPath = "Interface\\AddOns\\mshFrame\\Media\\msh.ttf"
    LSM:Register("font", fontName, fontPath)

    -- 2. ПРИНУДИТЕЛЬНО ДОБАВЛЯЕМ В СПИСОК МЕНЮ (Ace3)
    -- Это заставит выпадающее меню увидеть шрифт даже без релоада
    if not AceGUIWidgetLSMlists.font[fontName] then
        AceGUIWidgetLSMlists.font[fontName] = fontName
    end


    -- Загружаем БД
    self.db = LibStub("AceDB-3.0"):New("mshFrameDB", ns.defaults, true)
    ns.cfg = self.db.profile

    -- Регистрируем меню
    AceConfig:RegisterOptionsTable("mshFrame", ns.options)
    self.optionsFrame = AceConfigDialog:AddToBlizOptions("mshFrame", "mshFrame")

    -- Регистрируем команду
    SLASH_MSH1 = "/msh"
    SlashCmdList["MSH"] = function() AceConfigDialog:Open("mshFrame") end

    print("|cff00ff00mshFrame v0.5 загружен!|r /msh для настроек.")
end

-- СИНХРОНИЗАЦИЯ С CVARS (Системные настройки)
function msh.SyncBlizzardSettings()
    if not ns.cfg then return end
    local mode = ns.cfg.hpMode
    if mode == "VALUE" then
        SetCVar("raidFramesHealthText", "health")
    elseif mode == "PERCENT" then
        SetCVar("raidFramesHealthText", "perc")
    else
        SetCVar("raidFramesHealthText", "none")
    end
end

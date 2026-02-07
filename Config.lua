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

-- Функция мгновенного обновления фреймов
local function Refresh()
    for i = 1, 40 do
        local rf = _G["CompactRaidFrame" .. i]
        if rf then msh.ApplyStyle(rf) end -- Вызываем всегда, ApplyStyle сам разберется

        local pf = _G["CompactPartyFrameMember" .. i]
        if pf then msh.ApplyStyle(pf) end
    end
end

-- Функция-шаблон для генерации вложенных групп
local function GetUnitGroups(path)
    return {
        general = {
            name = "Общие",
            type = "group",
            order = 1,
            args = {
                texture = {
                    name = "Текстура",
                    type = "select",
                    dialogControl = "LSM30_Statusbar",
                    order = 1,
                    values = AceGUIWidgetLSMlists.statusbar,
                    get = function() return path.texture end,
                    set = function(_, v)
                        path.texture = v; Refresh()
                    end,
                }
            }
        },
        names = {
            name = "Имена",
            type = "group",
            order = 2,
            args = {
                fontName = {
                    type = "select",
                    name = "Шрифт имени",
                    order = 1,
                    values = function() return LibStub("LibSharedMedia-3.0"):HashTable("font") end,
                    dialogControl = "LSM30_Font",
                    get = function() return path.fontName end,
                    set = function(_, v)
                        path.fontName = v; Refresh()
                    end,
                },
                nameOutline = {
                    type = "select",
                    name = "Контур текста",
                    order = 1.1,
                    values = outlineModes,
                    get = function() return path.nameOutline or "OUTLINE" end,
                    set = function(_, v)
                        path.nameOutline = v; Refresh()
                    end,
                },
                fontSize = {
                    type = "range",
                    name = "Размер",
                    order = 2,
                    min = 6,
                    max = 32,
                    step = 1,
                    get = function() return path.fontSizeName end,
                    set = function(_, v)
                        path.fontSizeName = v; Refresh()
                    end,
                },
                shortenNames = {
                    type = "toggle",
                    name = "Обрезать имя",
                    desc = "Включает сокращение длинных имен",
                    order = 2.1,
                    get = function() return path.shortenNames end,
                    set = function(_, v)
                        path.shortenNames = v; Refresh()
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
                    disabled = function() return not path.shortenNames end,
                    get = function() return path.nameLength end,
                    set = function(_, v)
                        path.nameLength = v; Refresh()
                    end,
                },
                namePoint = {
                    type = "select",
                    name = "Точка привязки",
                    order = 3,
                    values = anchorPoints,
                    get = function() return path.namePoint end,
                    set = function(_, v)
                        path.namePoint = v; Refresh()
                    end,
                },
                nameX = {
                    type = "range",
                    name = "Смещение X",
                    order = 4,
                    min = -100,
                    max = 100,
                    step = 1,
                    get = function() return path.nameX end,
                    set = function(_, v)
                        path.nameX = v; Refresh()
                    end,
                },
                nameY = {
                    type = "range",
                    name = "Смещение Y",
                    order = 5,
                    min = -100,
                    max = 100,
                    step = 1,
                    get = function() return path.nameY end,
                    set = function(_, v)
                        path.nameY = v; Refresh()
                    end,
                },
            }
        },
        hp = {
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
                    get = function() return path.fontStatus end,
                    set = function(_, v)
                        path.fontStatus = v; Refresh()
                    end,
                },
                statusOutline = {
                    type = "select",
                    name = "Контур",
                    order = 1.1,
                    values = outlineModes,
                    get = function() return path.statusOutline or "OUTLINE" end,
                    set = function(_, v)
                        path.statusOutline = v; Refresh()
                    end,
                },
                fontSizeStatus = {
                    type = "range",
                    name = "Размер",
                    order = 2,
                    min = 6,
                    max = 32,
                    step = 1,
                    get = function() return path.fontSizeStatus end,
                    set = function(_, v)
                        path.fontSizeStatus = v; Refresh()
                    end,
                },
                statusPoint = {
                    type = "select",
                    name = "Якорь ХП",
                    order = 4,
                    values = anchorPoints,
                    get = function() return path.statusPoint end,
                    set = function(_, v)
                        path.statusPoint = v; Refresh()
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
                            path.statusX
                    end,
                    set = function(_, v)
                        path.statusX = v; Refresh()
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
                            path.statusY
                    end,
                    set = function(_, v)
                        path.statusY = v; Refresh()
                    end
                },
            }
        },
        auras = {
            name = "Ауры",
            type = "group",
            order = 4,
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
                                return path
                                    .showBuffs
                            end,
                            set = function(_, v)
                                path.showBuffs = v; Refresh()
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
                                    path.auraSize
                            end,
                            set = function(_, v)
                                path.auraSize = v; Refresh()
                            end
                        },
                        auraPoint = {
                            type = "select",
                            name = "Якорь",
                            order = 3,
                            values = anchorPoints,
                            get = function()
                                return
                                    path.auraPoint
                            end,
                            set = function(_, v)
                                path.auraPoint = v; Refresh()
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
                                    path.auraX
                            end,
                            set = function(_, v)
                                path.auraX = v; Refresh()
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
                                    path.auraY
                            end,
                            set = function(_, v)
                                path.auraY = v; Refresh()
                            end
                        },
                        auraGrow = {
                            type = "select",
                            name = "Рост",
                            order = 6,
                            values = { ["LEFT"] = "Влево", ["RIGHT"] = "Вправо", ["UP"] = "Вверх", ["DOWN"] = "Вниз" },
                            get = function()
                                return
                                    path.auraGrow
                            end,
                            set = function(_, v)
                                path.auraGrow = v; Refresh()
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
                                    path.auraSpacing
                            end,
                            set = function(_, v)
                                path.auraSpacing = v; Refresh()
                            end
                        },
                        showbuffTimer = {
                            type = "toggle",
                            name = "Таймер",
                            order = 8,
                            get = function()
                                return path
                                    .showbuffTimer
                            end,
                            set = function(_, v)
                                path.showbuffTimer = v; Refresh()
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
                                    path.buffTextScale
                            end,
                            set = function(_, v)
                                path.buffTextScale = v; Refresh()
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
                                return path
                                    .showDebuffs
                            end,
                            set = function(_, v)
                                path.showDebuffs = v
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
                            disabled = function() return not path.showDebuffs end,
                            get = function() return msh.db.profile.global.showOnlyDispellable end,
                            set = function(_, v)
                                msh.db.profile.global.showOnlyDispellable = v
                                msh.SyncBlizzardSettings() -- Вызываем синхронизацию CVar
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
                                    path.debuffSize
                            end,
                            set = function(_, v)
                                path.debuffSize = v; Refresh()
                            end
                        },
                        debuffPoint = {
                            type = "select",
                            name = "Якорь",
                            order = 3,
                            values = anchorPoints,
                            get = function()
                                return
                                    path.debuffPoint
                            end,
                            set = function(_, v)
                                path.debuffPoint = v; Refresh()
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
                                    path.debuffX
                            end,
                            set = function(_, v)
                                path.debuffX = v; Refresh()
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
                                    path.debuffY
                            end,
                            set = function(_, v)
                                path.debuffY = v; Refresh()
                            end
                        },
                        debuffGrow = {
                            type = "select",
                            name = "Рост",
                            order = 6,
                            values = { ["LEFT"] = "Влево", ["RIGHT"] = "Вправо" },
                            get = function()
                                return
                                    path.debuffGrow
                            end,
                            set = function(_, v)
                                path.debuffGrow = v; Refresh()
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
                                    path.debuffSpacing
                            end,
                            set = function(_, v)
                                path.debuffSpacing = v; Refresh()
                            end
                        },
                        showDebuffTimer = {
                            type = "toggle",
                            name = "Таймер",
                            order = 8,
                            get = function()
                                return
                                    path.showDebuffTimer
                            end,
                            set = function(_, v)
                                path.showDebuffTimer = v; Refresh()
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
                                    path.debuffTextScale
                            end,
                            set = function(_, v)
                                path.debuffTextScale = v; Refresh()
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
                            get = function() return path.showDispel end,
                            set = function(_, v)
                                path.showDispel = v; Refresh()
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
                                    path.dispelSize
                            end,
                            set = function(_, v)
                                path.dispelSize = v; Refresh()
                            end
                        },
                        dispelPoint = {
                            type = "select",
                            name = "Якорь",
                            order = 2,
                            values = anchorPoints,
                            get = function()
                                return
                                    path.dispelPoint
                            end,
                            set = function(_, v)
                                path.dispelPoint = v; Refresh()
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
                                    path.dispelX
                            end,
                            set = function(_, v)
                                path.dispelX = v; Refresh()
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
                                    path.dispelY
                            end,
                            set = function(_, v)
                                path.dispelY = v; Refresh()
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
                            get = function() return path.showBigSave end,
                            set = function(_, v)
                                path.showBigSave = v;
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
                                    path.showBigSaveTimer
                            end,
                            set = function(_, v)
                                path.showBigSaveTimer = v; Refresh()
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
                                    path.bigSaveSize
                            end,
                            set = function(_, v)
                                path.bigSaveSize = v; Refresh()
                            end
                        },
                        bigSavePoint = {
                            type = "select",
                            name = "Якорь",
                            order = 2,
                            values = anchorPoints,
                            get = function()
                                return
                                    path.bigSavePoint
                            end,
                            set = function(_, v)
                                path.bigSavePoint = v; Refresh()
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
                                    path.bigSaveX
                            end,
                            set = function(_, v)
                                path.bigSaveX = v; Refresh()
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
                                    path.bigSaveY
                            end,
                            set = function(_, v)
                                path.bigSaveY = v; Refresh()
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
                                    path.bigSaveTextScale
                            end,
                            set = function(_, v)
                                path.bigSaveTextScale = v; Refresh()
                            end
                        },
                    }
                },

            }
        },
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
        raidMarks = {
            name = "Рейдовые метки",
            type = "group",
            order = 5,
            args = {
                showRaidMark = {
                    type = "toggle",
                    name = "Включить метки",
                    order = 1,
                    get = function() return path.showRaidMark end,
                    set = function(_, v)
                        path.showRaidMark = v; Refresh()
                    end,
                },
                raidMarkSize = {
                    type = "range",
                    name = "Размер",
                    order = 2,
                    min = 8,
                    max = 60,
                    step = 1,
                    get = function() return path.raidMarkSize end,
                    set = function(_, v)
                        path.raidMarkSize = v; Refresh()
                    end,
                },
                raidMarkPoint = {
                    type = "select",
                    name = "Якорь",
                    order = 3,
                    values = anchorPoints,
                    get = function() return path.raidMarkPoint end,
                    set = function(_, v)
                        path.raidMarkPoint = v; Refresh()
                    end,
                },
                raidMarkX = {
                    type = "range",
                    name = "Смещение X",
                    order = 4,
                    min = -100,
                    max = 100,
                    step = 1,
                    get = function() return path.raidMarkX end,
                    set = function(_, v)
                        path.raidMarkX = v; Refresh()
                    end,
                },
                raidMarkY = {
                    type = "range",
                    name = "Смещение Y",
                    order = 5,
                    min = -100,
                    max = 100,
                    step = 1,
                    get = function() return path.raidMarkY end,
                    set = function(_, v)
                        path.raidMarkY = v; Refresh()
                    end,
                },
            }
        },
        roles = {
            name = "Иконки ролей",
            type = "group",
            order = 6,
            args = {
                useBlizzRole = {
                    type = "toggle",
                    name = "|cff00ff00Использовать стандарт (Blizzard)|r",
                    desc = "Полностью отключает кастомизацию ролей и возвращает родные иконки игры.",
                    order = 0,
                    get = function(_) return path.useBlizzRole end,
                    set = function(_, v)
                        path.useBlizzRole = v; Refresh()
                    end,
                },
                showRoleIcon = {
                    type = "toggle",
                    name = "Включить кастомные иконки ролей",
                    desc = "Отображает иконку танка, целителя или урона",
                    order = 1,
                    disabled = function() return path.useBlizzRole end, -- Блокировка
                    get = function(_) return path.showRoleIcon end,
                    set = function(_, v)
                        path.showRoleIcon = v; Refresh()
                    end,
                },
                roleIconSize = {
                    type = "range",
                    name = "Размер",
                    order = 2,
                    min = 8,
                    max = 40,
                    step = 1,
                    disabled = function() return path.useBlizzRole end, -- Блокировка
                    get = function() return path.roleIconSize end,
                    set = function(_, v)
                        path.roleIconSize = v; Refresh()
                    end,
                },
                roleIconPoint = {
                    type = "select",
                    name = "Якорь",
                    order = 3,
                    values = anchorPoints,
                    disabled = function() return path.useBlizzRole end, -- Блокировка
                    get = function() return path.roleIconPoint end,
                    set = function(_, v)
                        path.roleIconPoint = v; Refresh()
                    end,
                },
                roleIconX = {
                    type = "range",
                    name = "Смещение X",
                    order = 4,
                    min = -50,
                    max = 50,
                    step = 1,
                    disabled = function() return path.useBlizzRole end, -- Блокировка
                    get = function() return path.roleIconX end,
                    set = function(_, v)
                        path.roleIconX = v; Refresh()
                    end,
                },
                roleIconY = {
                    type = "range",
                    name = "Смещение Y",
                    order = 5,
                    min = -50,
                    max = 50,
                    step = 1,
                    disabled = function() return path.useBlizzRole end, -- Блокировка
                    get = function() return path.roleIconY end,
                    set = function(_, v)
                        path.roleIconY = v; Refresh()
                    end,
                },
            }
        },
    }
end

-- Дефолты
local defaultProfile = {
    texture = "Flat",
    globalFontName = "Montserrat-SemiBold",
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

ns.defaults = {
    profile = {
        global = {
            hpMode = "PERCENT", -- Глобальный CVar формат
            showOnlyDispellable = false,
        },
        party = defaultProfile,
        raid = defaultProfile,
    }
}

-- Главное окно
ns.options = {
    type = "group",
    name = "mshFrame",
    args = {
        globalSettings = {
            name = "|cffffd100Global|r",
            type = "group",
            order = 1,
            args = {
                header = { name = "Системные настройки Blizzard", type = "header", order = 1 },
                hpMode = {
                    name = "Формат данных ХП",
                    desc = "Влияет на то, какие данные Blizzard готовит для отображения (CVar)",
                    type = "select",
                    order = 2,
                    values = {
                        ["VALUE"] = "Цифры",
                        ["PERCENT"] = "Проценты",
                        ["NONE"] = "Скрыть"
                    },
                    get = function() return msh.db.profile.global.hpMode end,
                    set = function(_, v)
                        msh.db.profile.global.hpMode = v
                        msh.SyncBlizzardSettings()
                        Refresh()
                    end,
                },
            }
        },
        partyTab = {
            name = "|cff00ff00Группа (Party)|r",
            type = "group",
            order = 2,
            childGroups = "tree", -- ВОТ ЗДЕСЬ ОНО ДОЛЖНО БЫТЬ
            args = {}
        },
        raidTab = {
            name = "|cff00ffffРейд (Raid)|r",
            type = "group",
            order = 3,
            childGroups = "tree", -- И ЗДЕСЬ
            args = {}
        },
    }
}

function msh:OnInitialize()
    -- Регистрация шрифта
    local fontName = "Montserrat-SemiBold"
    local fontPath = "Interface\\AddOns\\mshFrame\\Media\\msh.ttf"
    LSM:Register("font", fontName, fontPath)
    if not AceGUIWidgetLSMlists.font[fontName] then AceGUIWidgetLSMlists.font[fontName] = fontName end

    -- Загружаем БД
    self.db = LibStub("AceDB-3.0"):New("mshFrameDB", ns.defaults, true)

    -- Наполняем вкладки аргументами
    ns.options.args.partyTab.args = GetUnitGroups(self.db.profile.party)
    ns.options.args.raidTab.args = GetUnitGroups(self.db.profile.raid)

    -- Регистрация
    AceConfig:RegisterOptionsTable("mshFrame", ns.options)
    self.optionsFrame = AceConfigDialog:AddToBlizOptions("mshFrame", "mshFrame")

    SLASH_MSH1 = "/msh"
    SlashCmdList["MSH"] = function() AceConfigDialog:Open("mshFrame") end
end

-- СИНХРОНИЗАЦИЯ С CVARS (Системные настройки)
function msh.SyncBlizzardSettings()
    local db = msh.db and msh.db.profile.global
    if not db then return end
    local mode = db.hpMode
    -- Управление системным текстом ХП Blizzard
    if mode == "VALUE" then
        SetCVar("raidFramesHealthText", "health")
    elseif mode == "PERCENT" then
        SetCVar("raidFramesHealthText", "perc")
    else
        SetCVar("raidFramesHealthText", "none")
    end

    SetCVar("raidFramesDisplayOnlyDispellableDebuffs", db.showOnlyDispellable and "1" or "0")

    if CompactUnitFrameProfiles_ApplyCurrentSettings then
        CompactUnitFrameProfiles_ApplyCurrentSettings()
    end
end

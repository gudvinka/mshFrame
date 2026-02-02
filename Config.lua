local addonName, ns = ...
local msh = ns
local LSM = LibStub("LibSharedMedia-3.0")
ns.needsReload = false

-- СПИСКИ ДЛЯ ДРОПДАУНОВ
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
    ["NONE"] = "Нет",
    ["OUTLINE"] = "Тонкий",
    ["THICKOUTLINE"] = "Жирный",
    ["MONOCHROME"] = "Пиксельный",
}

local function Refresh()
    if CompactRaidFrameContainer and CompactRaidFrameContainer.flowFrames then
        for _, frame in ipairs(CompactRaidFrameContainer.flowFrames) do
            if type(frame) == "table" and frame.mshLayersCreated then msh.UpdateLayers(frame) end
        end
    end
    for i = 1, 5 do
        local frame = _G["CompactPartyFrameMember" .. i]
        if frame and frame:IsShown() and frame.mshLayersCreated then msh.UpdateLayers(frame) end
    end
end

ns.defaults = {
    profile = {
        texture = "Perl",
        fontName = "Montserrat-SemiBold",
        fontSizeName = 12,
        nameOutline = "OUTLINE",
        namePoint = "TOPLEFT",
        nameX = 20,
        nameY = -4,
        shortenNames = true,
        nameLength = 6,
        fontStatus = "Montserrat-SemiBold",
        fontSizeStatus = 12,
        statusOutline = "OUTLINE",
        statusPoint = "BOTTOMLEFT",
        statusX = 4,
        statusY = 4,
        hpMode = "VALUE",
        showRoleIcon = true,
        roleIconSize = 30,
        roleIconPoint = "TOPLEFT",
        roleIconX = 4,
        roleIconY = -4,
        raidMarkSize = 30,
        raidMarkPoint = "TOP",
        raidMarkX = 0,
        raidMarkY = -15,
        auraSize = 20,
        auraPoint = "TOPLEFT",
        auraX = 0,
        auraY = 0,
        auraGrow = "RIGHT",
        auraSpacing = 2,
        debuffSize = 20,
        debuffPoint = "BOTTOMRIGHT",
        debuffX = 1,
        debuffY = 1,
        buffTextScale = 0.6,
        debuffTextScale = 0.6,
        saveTextScale = 0.6,
        showBigSave = true,
        showbuffTimer = true,
        showDebuffTimer = true,
        showDispel = true,
        bigSaveSize = 40,
        bigSavePoint = "CENTER",
        bigSaveX = 0,
        bigSaveY = 0,
        bigSaveTextScale = 0.8,
        showBigSaveTimer = true,
        dispelPoint = "TOPRIGHT",
        dispelX = 0,
        dispelY = 0,
        dispelSize = 30,
        showOnlyDispellable = true,

    }
}

-- ОПЦИИ
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
                showRoleIcon = {
                    type = "toggle",
                    name = "Включить иконки ролей",
                    desc = "Отображает иконку танка, целителя или урона",
                    order = 1,
                    get = function() return ns.cfg.showRoleIcon end,
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
                    dialogControl = "LSM30_Font",
                    values = AceGUIWidgetLSMlists.font,
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
                fontSizeName = {
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
                    dialogControl = "LSM30_Font",
                    values = AceGUIWidgetLSMlists.font,
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
                            ns.needsReload = true;
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

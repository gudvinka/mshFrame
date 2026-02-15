local _, ns = ...
local msh = ns

function msh.GetShortName(unit, cfg)
    if not unit or not UnitExists(unit) then return "" end
    return GetUnitName(unit, not cfg.shortenNames) or ""
end

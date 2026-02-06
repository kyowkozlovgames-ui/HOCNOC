-- ===================================
-- FORMATTING MODULE
-- Gerencia formatação numérica
-- ===================================

local FormattingModule = {}

FormattingModule.units = {
    "k", "M", "B", "T", "Qa", "Qi", "Aa", "Ab", "Ac", "Ad",
    "Ae", "Af", "Ag", "Ah", "Ai", "Aj", "Ak", "Al", "Am", "An", "Ao", "Ap"
}

function FormattingModule:FormatNumber(num)
    if type(num) ~= "number" then return tostring(num) end
    if num < 1000 then return tostring(math.floor(num)) end
    
    local exp = math.log10(num)
    local order = math.floor(exp / 3)
    
    if order > 0 then
        if order <= #self.units then
            local unit = self.units[order]
            local scaled = num / (10 ^ (order * 3))
            local formatted = string.format("%.2f %s", scaled, unit)
            if order >= 13 then return "⚡ " .. formatted end
            return formatted
        else
            return "⚡ " .. string.format("%.2fe%.0f", num / (10 ^ exp), exp)
        end
    end
    
    return tostring(num)
end

return FormattingModule

-- ===================================
-- HELPERS MODULE
-- Funções auxiliares gerais
-- ===================================

local HelpersModule = {}

function HelpersModule:TryCatch(f, ...)
    local success, err = pcall(f, ...)
    if not success then
        warn("[SafeAutoTrain ERROR]:", err)
    end
end

function HelpersModule:GetNumericValue(inst)
    if inst and (inst:IsA("IntValue") or inst:IsA("NumberValue")) then
        return inst.Value
    elseif inst and inst:IsA("StringValue") then
        return tonumber(inst.Value)
    end
    return nil
end

function HelpersModule:FindPlayerStat(targetPlayer, statName)
    local containers = {
        targetPlayer:FindFirstChild("AttrConfig"),
        targetPlayer:FindFirstChild("leaderstats")
    }
    for _, folder in ipairs(containers) do
        if folder then
            for _, child in folder:GetChildren() do
                if child.Name == statName then
                    return self:GetNumericValue(child)
                end
            end
        end
    end
    return nil
end

function HelpersModule:FindEnemyPower(targetPlayer)
    local highestValue = 0
    local currentMaxHealth = 100
    
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        currentMaxHealth = targetPlayer.Character.Humanoid.MaxHealth
    end
    
    local containers = {
        targetPlayer:FindFirstChild("AttrConfig"),
        targetPlayer:FindFirstChild("leaderstats")
    }
    
    for _, folder in ipairs(containers) do
        if folder then
            for _, child in folder:GetChildren() do
                local val = self:GetNumericValue(child)
                if val and val > currentMaxHealth and val > highestValue then
                    highestValue = val
                end
            end
        end
    end
    
    return highestValue > 0 and highestValue or nil
end

function HelpersModule:GetReputationColor(targetPlayer, reputation)
    local MIN_REP_GRADIENT = 5000
    local MAX_REP_GRADIENT = 1000000
    local player = game:GetService("Players").LocalPlayer

    local dn = ""
    if targetPlayer and targetPlayer.DisplayName then
        dn = targetPlayer.DisplayName:upper()
    end

    if targetPlayer == player or string.find(dn, "KOZLOV") then
        return Color3.fromRGB(0, 150, 0) -- KOZLOV verde
    elseif string.find(dn, "NOTORIOUS") then
        return Color3.fromRGB(0, 150, 255) -- NOTORIOUS azul
    elseif reputation and reputation >= MIN_REP_GRADIENT then
        local ratio = math.min(1, (reputation - MIN_REP_GRADIENT) / (MAX_REP_GRADIENT - MIN_REP_GRADIENT))
        local r = 255
        local g = 150 * (1 - ratio)
        local b = 200 + 55 * ratio
        return Color3.fromRGB(r, g, b)
    else
        return Color3.new(1, 1, 1)
    end
end

function HelpersModule:GetDisplayLabelText(module)
    if not module then return "" end
    local icon = module.icon or ""
    local txt = module.text or ""
    if icon == "" then return txt end
    
    if string.find(txt, icon, 1, true) then
        return txt
    end
    
    return icon .. " " .. txt
end

return HelpersModule

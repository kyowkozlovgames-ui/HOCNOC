-- ===================================
-- TOGGLE MANAGER MODULE
-- Gerencia toggle logic para todas features
-- ===================================

local ToggleManager = {}

function ToggleManager:Initialize(features)
    self.features = features
    self.activeConnections = {}
end

function ToggleManager:HandleToggle(toggleName, isEnabled)
    -- Disconnect previous connection if exists
    if self.activeConnections[toggleName] then
        pcall(function() self.activeConnections[toggleName]:Disconnect() end)
        self.activeConnections[toggleName] = nil
    end

    if isEnabled then
        if toggleName == "Train" then
            self.features.training:Start()
            self.activeConnections[toggleName] = true
        elseif toggleName == "AntiAFK" then
            self.features.misc:StartAntiAFK()
            self.activeConnections[toggleName] = true
        elseif toggleName == "AntiFall" then
            self.features.antifall:Start()
            self.activeConnections[toggleName] = true
        elseif toggleName == "God" then
            self.features.misc:StartGod()
            self.activeConnections[toggleName] = true
        elseif toggleName == "ESP" then
            self.features.esp:Start()
            self.activeConnections[toggleName] = true
        elseif toggleName == "MinimalMode" then
            -- MinimalMode handleado por updateToggleVisuals
            self.activeConnections[toggleName] = true
        end
    else
        if toggleName == "Train" then
            self.features.training:Stop()
        elseif toggleName == "AntiAFK" then
            self.features.misc:StopAntiAFK()
        elseif toggleName == "AntiFall" then
            self.features.antifall:Stop()
        elseif toggleName == "God" then
            self.features.misc:StopGod()
        elseif toggleName == "ESP" then
            self.features.esp:Stop()
        elseif toggleName == "MinimalMode" then
            -- MinimalMode handleado por updateToggleVisuals
        end
    end
end

function ToggleManager:InitializeAllToggles()
    for name, value in pairs(getgenv().HNk) do
        if type(value) == "boolean" and name ~= "FOVMOUSECONTROL" then
            self:HandleToggle(name, value)
        end
    end
end

return ToggleManager

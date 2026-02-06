-- ===================================
-- SETTINGS MODULE
-- Gerencia toda a persistência e config
-- ===================================

local SettingsModule = {}

SettingsModule.FILE_NAME = "HNkTTF_config.json"

-- Estado global do HUB
SettingsModule.HNk = {
    ESP = true,
    God = true,
    Speed = false,
    Jump = false,
    Train = false,
    AntiAFK = true,
    AntiFall = true,
    PerformanceOverlay = true,
    FOV = 90,
    FOVMOUSECONTROL = false,
    MinimalMode = false,
    CurrentTheme = "Shadowcore"
}

-- Detecta suporte a arquivo
SettingsModule.isFileSupport = (pcall(function() readfile() end) and pcall(function() writefile() end)) or false

function SettingsModule:SaveConfig()
    if self.isFileSupport then
        local HttpService = game:GetService("HttpService")
        local data = HttpService:JSONEncode(self.HNk)
        writefile(self.FILE_NAME, data)
    end
end

function SettingsModule:LoadConfig()
    local HttpService = game:GetService("HttpService")
    local defaultTheme = self.HNk.CurrentTheme
    
    if self.isFileSupport and readfile(self.FILE_NAME) then
        local data = readfile(self.FILE_NAME)
        local success, decoded = pcall(HttpService.JSONDecode, HttpService, data)
        
        if success and type(decoded) == "table" then
            for k, v in pairs(decoded) do
                if self.HNk[k] ~= nil and type(self.HNk[k]) == type(v) then
                    self.HNk[k] = v
                end
            end
            if decoded.CurrentTheme then
                self.HNk.CurrentTheme = decoded.CurrentTheme
            end
            print("[HNk Config]: Configurations loaded successfully. Theme: " .. self.HNk.CurrentTheme)
        else
            warn("[HNk Config]: Failed to decode configurations, using defaults (AntiFall: ON, Theme: " .. defaultTheme .. ").")
        end
    else
        warn("[HNk Config]: Configuration file not found or file support unavailable, using defaults (AntiFall: ON, Theme: " .. defaultTheme .. ").")
    end
end

function SettingsModule:Get(key)
    return self.HNk[key]
end

function SettingsModule:Set(key, value)
    self.HNk[key] = value
    self:SaveConfig()
end

function SettingsModule:GetAll()
    return self.HNk
end

return SettingsModule

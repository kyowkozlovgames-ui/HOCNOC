-- ===================================
-- THEMES MODULE
-- Gerencia todos os temas disponíveis
-- ===================================

local ThemesModule = {}

ThemesModule.THEMES_CONFIG = {
    ["Shadowcore"] = {
        ACCENT_ON = Color3.fromRGB(255, 60, 60),
        ACCENT_OFF = Color3.fromRGB(80, 80, 80),
        PRIMARY_BG = Color3.fromRGB(15, 15, 15),
        DARK_BG = Color3.fromRGB(25, 25, 25),
    },
    ["CyberSynth"] = {
        ACCENT_ON = Color3.fromRGB(0, 255, 255),
        ACCENT_OFF = Color3.fromRGB(0, 100, 100),
        PRIMARY_BG = Color3.fromRGB(10, 10, 30),
        DARK_BG = Color3.fromRGB(20, 20, 40),
    },
    ["Solar Flare"] = {
        ACCENT_ON = Color3.fromRGB(255, 200, 0),
        ACCENT_OFF = Color3.fromRGB(100, 80, 0),
        PRIMARY_BG = Color3.fromRGB(40, 40, 40),
        DARK_BG = Color3.fromRGB(60, 60, 60),
    },
    ["Vaporwave"] = {
        ACCENT_ON = Color3.fromRGB(255, 0, 255),
        ACCENT_OFF = Color3.fromRGB(150, 0, 150),
        PRIMARY_BG = Color3.fromRGB(30, 0, 30),
        DARK_BG = Color3.fromRGB(40, 40, 60),
    },
    ["Forest Night"] = {
        ACCENT_ON = Color3.fromRGB(0, 255, 120),
        ACCENT_OFF = Color3.fromRGB(0, 100, 50),
        PRIMARY_BG = Color3.fromRGB(10, 20, 10),
        DARK_BG = Color3.fromRGB(20, 40, 20),
    },
    ["Monochrome"] = {
        ACCENT_ON = Color3.fromRGB(255, 255, 255),
        ACCENT_OFF = Color3.fromRGB(150, 150, 150),
        PRIMARY_BG = Color3.fromRGB(0, 0, 0),
        DARK_BG = Color3.fromRGB(20, 20, 20),
    },
}

function ThemesModule:GetTheme(themeName)
    return self.THEMES_CONFIG[themeName]
end

function ThemesModule:ThemeExists(themeName)
    return self.THEMES_CONFIG[themeName] ~= nil
end

function ThemesModule:AddCustomTheme(themeName, themeColors)
    self.THEMES_CONFIG[themeName] = themeColors
end

function ThemesModule:GetDefaultTheme()
    return "Shadowcore"
end

return ThemesModule

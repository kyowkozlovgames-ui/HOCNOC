-- ===================================
-- GUI THEMES MODULE
-- Gerencia criação de botões de tema na GUI
-- ===================================

local GUIThemes = {}

function GUIThemes:AddThemeButton(tabFrame, themeName, themeColors, onThemeSelect, colors)
    if not themeColors then return end

    local frame = Instance.new("Frame", tabFrame)
    frame.Name = themeName .. "Container"
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = #tabFrame:GetChildren() + 1

    local btn = Instance.new("TextButton", frame)
    btn.Name = "TextButton"
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = "🎨 " .. themeName
    btn.BackgroundColor3 = themeColors.ACCENT_ON
    btn.BackgroundTransparency = 0.5
    btn.TextColor3 = themeColors.PRIMARY_BG
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextSize = 16
    Instance.new("UIStroke", btn).Color = themeColors.ACCENT_ON

    btn.MouseButton1Click:Connect(function()
        onThemeSelect(themeName, themeColors)
    end)
end

function GUIThemes:CreateCustomTheme(tabFrame, themesConfig, onThemeSelect, colors)
    local idx = 1
    while themesConfig["CustomTheme" .. idx] do
        idx = idx + 1
    end
    local name = "CustomTheme" .. idx

    local function rnd() return math.random(60, 230) end
    local accent = Color3.fromRGB(rnd(), rnd(), rnd())
    local accentOff = Color3.fromRGB(
        math.clamp(math.floor(accent.R*255*0.4), 30, 200),
        math.clamp(math.floor(accent.G*255*0.4), 30, 200),
        math.clamp(math.floor(accent.B*255*0.4), 30, 200)
    )
    local primary = Color3.fromRGB(math.random(5, 60), math.random(5, 60), math.random(5, 60))
    local dark = Color3.fromRGB(
        math.clamp(math.floor(primary.R*255*1.5%255), 10, 120),
        math.clamp(math.floor(primary.G*255*1.5%255), 10, 120),
        math.clamp(math.floor(primary.B*255*1.5%255), 10, 120)
    )

    themesConfig[name] = {
        ACCENT_ON = accent,
        ACCENT_OFF = accentOff,
        PRIMARY_BG = primary,
        DARK_BG = dark,
    }

    self:AddThemeButton(tabFrame, name, themesConfig[name], onThemeSelect, colors)
end

return GUIThemes

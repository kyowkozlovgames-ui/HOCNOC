-- ===================================
-- HNk TTF AUTO-TRAIN + POWER ESP HUB v9.4.3
-- Modular Programming Edition
-- ===================================

-- Load external emotes script (optional, wrapped in pcall)

print("HNk TTF HUB v9.4.3 loading: Fixed duplicated emojis in tab labels.")

-- ===================================
-- LOAD ALL MODULES
-- ===================================

local function findModulesFolder()
    local Players = game:GetService("Players")
    if typeof(script) == "Instance" and script.Parent then
        local m = script.Parent:FindFirstChild("modules")
        if m then return m end
    end

    local searchPlaces = {
        game:GetService("CoreGui"),
        game:GetService("ReplicatedStorage"),
        game:GetService("StarterGui"),
        game:GetService("Workspace"),
        Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui") or nil,
    }

    for _, place in ipairs(searchPlaces) do
        if place and place.FindFirstChild then
            local m = place:FindFirstChild("modules")
            if m then return m end
            for _, child in ipairs(place:GetChildren()) do
                if child and child.FindFirstChild then
                    local m2 = child:FindFirstChild("modules")
                    if m2 then return m2 end
                end
            end
        end
    end

    for _, d in ipairs(game:GetService("CoreGui"):GetDescendants()) do
        if d.Name == "modules" then
            return d
        end
    end

    return nil
end

local modulePath = findModulesFolder()
if not modulePath then
    error("[HNk Main]: Não foi possível encontrar a pasta 'modules'. Verifique onde o script está inserido (deve haver uma pasta 'modules' dentro do container do hub).")
end

local Themes = require(modulePath.config.themes)
local Settings = require(modulePath.config.settings)
local ModulesData = require(modulePath.config.modulesData)

local Helpers = require(modulePath.utils.helpers)
local Formatting = require(modulePath.utils.formatting)

local Remotes = require(modulePath.services.remotes)

local GUIBuilder = require(modulePath.gui.builder)
local GUIThemes = require(modulePath.gui.themes)
local GUIVisuals = require(modulePath.gui.visuals)
local GUIElements = require(modulePath.gui.uiElements)
local PerformanceOverlay = require(modulePath.gui.performance)

local TrainingFeature = require(modulePath.features.training)
local ESPFeature = require(modulePath.features.esp)
local AntiFallFeature = require(modulePath.features.antifall)
local PlayerFeature = require(modulePath.features.player)
local MiscFeatures = require(modulePath.features.misc)
local CameraFeature = require(modulePath.features.camera)
local ToggleManager = require(modulePath.features.toggleManager)

-- ===================================
-- SERVICES
-- ===================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- ===================================
-- INITIALIZE SETTINGS
-- ===================================

getgenv().HNk = Settings.HNk
Settings:LoadConfig()

-- ===================================
-- SETUP COLORS FROM THEME
-- ===================================

local themeConfig = Themes:GetTheme(getgenv().HNk.CurrentTheme)
local ACCENT_ON = themeConfig.ACCENT_ON
local ACCENT_OFF = themeConfig.ACCENT_OFF
local PRIMARY_BG = themeConfig.PRIMARY_BG
local DARK_BG = themeConfig.DARK_BG

GUIBuilder:SetColors(ACCENT_ON, ACCENT_OFF, PRIMARY_BG, DARK_BG)

-- ===================================
-- INITIALIZE FEATURES
-- ===================================

Remotes:Initialize()

local features = {
    training = TrainingFeature,
    esp = ESPFeature,
    antifall = AntiFallFeature,
    player = PlayerFeature,
    misc = MiscFeatures,
    camera = CameraFeature
}

-- Initialize all features
TrainingFeature:Initialize(Remotes)
ESPFeature:Initialize(Helpers, Formatting)
AntiFallFeature:Initialize()
PlayerFeature:Initialize(Remotes)
MiscFeatures:Initialize()
CameraFeature:Initialize()

-- Initialize ToggleManager
local toggleManager = ToggleManager
toggleManager:Initialize(features)

-- Initialize PerformanceOverlay
local performanceOverlay = PerformanceOverlay
performanceOverlay:Initialize(CoreGui, GUIBuilder:GetColors())
performanceOverlay:Create()
GUIBuilder.performanceOverlayLabel = performanceOverlay.performanceLabel

-- ===================================
-- SETUP GUI
-- ===================================

local sg = GUIBuilder:CreateMainFrame(CoreGui)

-- Create Title Bar
local title, titleText, titleAccent = GUIBuilder:CreateTitleBar(getgenv().HNk.CurrentTheme)

-- Create Navigation and Content Frames
GUIBuilder:CreateNavFrame()
GUIBuilder:CreateContentFrame()

-- ===================================
-- BUILD TABS
-- ===================================

local modulesData = ModulesData:GetModulesData()
local tabOrder = ModulesData:GetTabOrder()

local function switchTab(tabName, tabButton)
    if GUIBuilder.navFrame then
        for _, btn in ipairs(GUIBuilder.navFrame:GetChildren()) do
            if btn and btn:IsA and btn:IsA("TextButton") then
                btn.BackgroundColor3 = DARK_BG
                btn.BackgroundTransparency = 0.5
                btn.TextColor3 = ACCENT_OFF
                local stroke = btn:FindFirstChild("UIStroke")
                if stroke then stroke:Destroy() end
            end
        end
    end

    for name, frame in pairs(GUIBuilder.tabContents) do
        if frame then frame.Visible = (name == tabName) end
    end

    if tabButton and tabButton.Parent then
        tabButton.BackgroundColor3 = ACCENT_ON
        tabButton.BackgroundTransparency = 0.8
        tabButton.TextColor3 = PRIMARY_BG
        local stroke = tabButton:FindFirstChild("UIStroke") or Instance.new("UIStroke", tabButton)
        stroke.Color = ACCENT_ON
        stroke.Thickness = 1
        stroke.Transparency = 0
    end
end
for order, tabName in ipairs(tabOrder) do
    local modules = modulesData[tabName]

    local tabFrame = GUIElements:CreateTabFrame(GUIBuilder.contentFrame, GUIBuilder:GetColors())
    tabFrame.Name = tabName:gsub(" ", "") .. "Tab"
    GUIBuilder.tabContents[tabName] = tabFrame

    local tabButton = GUIElements:CreateTabButton(GUIBuilder.navFrame, tabName, order, GUIBuilder:GetColors())

    if tabName == "Themas" then
        -- Create custom theme button
        local createContainer = Instance.new("Frame", tabFrame)
        createContainer.Size = UDim2.new(1, -10, 0, 40)
        createContainer.BackgroundTransparency = 1
        createContainer.LayoutOrder = 1

        local createBtn = Instance.new("TextButton", createContainer)
        createBtn.Size = UDim2.new(1, 0, 1, 0)
        createBtn.Text = "➕ Create Custom Theme"
        createBtn.Font = Enum.Font.SourceSansBold
        createBtn.TextSize = 16
        createBtn.BackgroundColor3 = ACCENT_ON
        createBtn.TextColor3 = PRIMARY_BG
        Instance.new("UICorner", createBtn).CornerRadius = UDim.new(0, 5)
        createBtn.MouseButton1Click:Connect(function()
            GUIThemes:CreateCustomTheme(tabFrame, Themes.THEMES_CONFIG, function(themeName, themeColors)
                -- Apply theme
                ACCENT_ON = themeColors.ACCENT_ON
                ACCENT_OFF = themeColors.ACCENT_OFF
                PRIMARY_BG = themeColors.PRIMARY_BG
                DARK_BG = themeColors.DARK_BG

                getgenv().HNk.CurrentTheme = themeName
                Settings:SaveConfig()
                GUIBuilder:SetColors(ACCENT_ON, ACCENT_OFF, PRIMARY_BG, DARK_BG)

                -- Update all visuals
                pcall(function()
                    if GUIBuilder.fr then GUIBuilder.fr.BackgroundColor3 = PRIMARY_BG end
                    for name, el in pairs(GUIBuilder.toggleElements) do
                        GUIVisuals:UpdateToggleVisuals(name, el)
                    end
                end)
            end, GUIBuilder:GetColors())
        end)

        -- Add existing themes
        for themeName, _ in pairs(Themes.THEMES_CONFIG) do
            GUIThemes:AddThemeButton(tabFrame, themeName, Themes.THEMES_CONFIG[themeName], function(selectedThemeName, themeColors)
                ACCENT_ON = themeColors.ACCENT_ON
                ACCENT_OFF = themeColors.ACCENT_OFF
                PRIMARY_BG = themeColors.PRIMARY_BG
                DARK_BG = themeColors.DARK_BG

                getgenv().HNk.CurrentTheme = selectedThemeName
                Settings:SaveConfig()
                GUIBuilder:SetColors(ACCENT_ON, ACCENT_OFF, PRIMARY_BG, DARK_BG)

                pcall(function()
                    if GUIBuilder.fr then GUIBuilder.fr.BackgroundColor3 = PRIMARY_BG end
                    for name, el in pairs(GUIBuilder.toggleElements) do
                        GUIVisuals:UpdateToggleVisuals(name, el)
                    end
                    if GUIBuilder.fovSliderElement then
                        local fovModule = nil
                        for _, m in ipairs(modules) do
                            if m.name == "FOV" then fovModule = m break end
                        end
                        if fovModule then
                            GUIVisuals:UpdateFOVSliderVisuals(getgenv().HNk.FOV, fovModule)
                        end
                    end
                end)
            end, GUIBuilder:GetColors())
        end
    else
        -- Create toggles and sliders
        local moduleOrder = 1
        for _, module in ipairs(modules) do
            local modName = module.name

            if module.type == "Toggle" then
                local element = GUIElements:CreateToggle(tabFrame, module, GUIBuilder:GetColors(), Helpers, function(toggleName)
                    Settings:SaveConfig()
                    toggleManager:HandleToggle(toggleName, getgenv().HNk[toggleName])
                    local el = GUIBuilder.toggleElements[toggleName]
                    if el then GUIVisuals:UpdateToggleVisuals(toggleName, el) end
                    print("HNk Status: " .. toggleName .. " is now " .. tostring(getgenv().HNk[toggleName]))
                end)
                
                GUIBuilder.toggleElements[modName] = element
                GUIVisuals:UpdateToggleVisuals(modName, element)

            elseif module.type == "Slider" then
                GUIBuilder.fovSliderElement = GUIElements:CreateSlider(tabFrame, module, GUIBuilder:GetColors(), Helpers, function(newValue, ratio)
                    if getgenv().HNk.FOV ~= newValue then
                        getgenv().HNk.FOV = newValue
                        Settings:SaveConfig()

                        local sliderFill = GUIBuilder.fovSliderElement:FindFirstChild("SliderBar") 
                            and GUIBuilder.fovSliderElement.SliderBar:FindFirstChild("SliderFill")
                        local sliderButton = GUIBuilder.fovSliderElement:FindFirstChild("SliderBar") 
                            and GUIBuilder.fovSliderElement.SliderBar:FindFirstChild("SliderButton")
                        local textLabel = GUIBuilder.fovSliderElement:FindFirstChild("TextLabel")

                        if sliderFill then sliderFill.Size = UDim2.new(ratio, 0, 1, 0) end
                        if sliderButton then
                            pcall(function()
                                sliderButton.Position = UDim2.new(ratio, -sliderButton.Size.X.Offset/2, 0.5, -sliderButton.Size.Y.Offset/2)
                            end)
                        end
                        if textLabel then
                            textLabel.Text = Helpers:GetDisplayLabelText(module) .. " [" .. tostring(math.floor(newValue)) .. "]"
                        end

                        if workspace.CurrentCamera then
                            workspace.CurrentCamera.FieldOfView = newValue
                        end
                    end
                end)

                spawn(function()
                    task.wait(0.05)
                    GUIVisuals:UpdateFOVSliderVisuals(getgenv().HNk.FOV, module)
                end)
            end

            moduleOrder = moduleOrder + 1
        end
    end

    tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabFrame.UIListLayout.AbsoluteContentSize.Y + 10)

    tabButton.MouseButton1Click:Connect(function()
        switchTab(tabName, tabButton)
    end)
end

-- Show default tab
local defaultBtn = (GUIBuilder.navFrame and GUIBuilder.navFrame:FindFirstChild("ShadowCoreNavBtn")) or nil
switchTab("Shadow Core", defaultBtn)

-- Create close button
local close = Instance.new("TextButton", title)
close.Size = UDim2.new(0, 25, 1, 0)
close.Position = UDim2.new(1, -25, 0, 0)
close.Text = "X"
close.BackgroundColor3 = PRIMARY_BG
close.TextColor3 = ACCENT_ON
close.BackgroundTransparency = 0.8
close.Font = Enum.Font.SourceSansBold
close.TextSize = 16
Instance.new("UIStroke", close).Color = ACCENT_ON
Instance.new("UIStroke", close).Thickness = 1
close.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Create minimize button
local minimize = Instance.new("TextButton", title)
minimize.Size = UDim2.new(0, 25, 1, 0)
minimize.Position = UDim2.new(1, -50, 0, 0)
minimize.Text = "—"
minimize.BackgroundColor3 = PRIMARY_BG
minimize.TextColor3 = ACCENT_OFF
minimize.BackgroundTransparency = 0.8
minimize.Font = Enum.Font.SourceSansBold
minimize.TextSize = 16
Instance.new("UIStroke", minimize).Color = ACCENT_OFF
Instance.new("UIStroke", minimize).Thickness = 1

local isMinimized = false
minimize.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if GUIBuilder.fr then
        if isMinimized then
            GUIBuilder.fr.Size = UDim2.new(0, 320, 0, GUIBuilder.MINIMIZED_HEIGHT)
            if GUIBuilder.navFrame then GUIBuilder.navFrame.Visible = false end
            if GUIBuilder.contentFrame then GUIBuilder.contentFrame.Visible = false end
            minimize.Text = "+"
        else
            GUIBuilder.fr.Size = UDim2.new(0, GUIBuilder.INITIAL_WIDTH, 0, GUIBuilder.INITIAL_HEIGHT)
            if GUIBuilder.navFrame then GUIBuilder.navFrame.Visible = true end
            if GUIBuilder.contentFrame then GUIBuilder.contentFrame.Visible = true end
            minimize.Text = "—"
        end
    end
end)
-- ===================================
-- INITIALIZE FEATURES
-- ===================================

toggleManager:InitializeAllToggles()

-- Start camera heartbeat for FOV
CameraFeature:StartHeartbeat()
CameraFeature:SetupMouseScroll()

-- Start player feature updates
PlayerFeature:Start()

-- Camera updates
RunService.Heartbeat:Connect(function()
    CameraFeature:UpdateFOV(getgenv().HNk.FOV)
end)

-- Garbage collection
task.spawn(function()
    while task.wait(60) do
        collectgarbage("collect")
    end
end)

-- ESP power cache update
task.spawn(function()
    while task.wait(0.3) do
        if getgenv().HNk.ESP then
            ESPFeature:UpdatePowerCache()
        end
    end
end)

print("HNk TTF HUB v9.4.3 FINAL ACTIVE! GUI fully initialized and stable.")
print("All features are modularized and ready for maintenance & updates!")

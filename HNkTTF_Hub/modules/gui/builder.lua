-- ===================================
-- GUI BUILDER MODULE
-- Gerencia construção dos elementos da GUI
-- ===================================

local GUIBuilder = {}

-- Referências globais da GUI
GUIBuilder.fr = nil
GUIBuilder.navFrame = nil
GUIBuilder.contentFrame = nil
GUIBuilder.tabContents = {}
GUIBuilder.toggleElements = {}
GUIBuilder.fovSliderElement = nil
GUIBuilder.performanceOverlayLabel = nil

-- Cores (será setadas pelo main)
GUIBuilder.ACCENT_ON = nil
GUIBuilder.ACCENT_OFF = nil
GUIBuilder.PRIMARY_BG = nil
GUIBuilder.DARK_BG = nil

GUIBuilder.INITIAL_WIDTH = 450
GUIBuilder.INITIAL_HEIGHT = 380
GUIBuilder.TAB_WIDTH = 130
GUIBuilder.MINIMIZED_HEIGHT = 25

function GUIBuilder:SetColors(accentOn, accentOff, primaryBg, darkBg)
    self.ACCENT_ON = accentOn
    self.ACCENT_OFF = accentOff
    self.PRIMARY_BG = primaryBg
    self.DARK_BG = darkBg
end

function GUIBuilder:CreateMainFrame(CoreGui)
    local sg = Instance.new("ScreenGui")
    sg.Name = "HNkTTF_V9_Shadowcore_Tabbed"
    sg.Parent = CoreGui
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    self.fr = Instance.new("Frame", sg)
    self.fr.Size = UDim2.new(0, self.INITIAL_WIDTH, 0, self.INITIAL_HEIGHT)
    self.fr.Position = UDim2.new(1, -700, 0, 10)
    self.fr.BackgroundColor3 = self.PRIMARY_BG
    self.fr.BackgroundTransparency = 0.9
    self.fr.BorderSizePixel = 0
    self.fr.Active = true
    self.fr.Draggable = true
    Instance.new("UICorner", self.fr).CornerRadius = UDim.new(0, 5)
    
    if not self.fr:FindFirstChildOfClass("UIStroke") then
        local s = Instance.new("UIStroke", self.fr)
        s.Color = self.ACCENT_ON
    end

    local glowFrame = Instance.new("Frame", self.fr)
    glowFrame.Size = UDim2.new(1, 0, 1, 0)
    glowFrame.BackgroundTransparency = 0.8
    glowFrame.BackgroundColor3 = self.ACCENT_ON
    Instance.new("UICorner", glowFrame).CornerRadius = UDim.new(0, 5)

    local innerFrame = Instance.new("Frame", self.fr)
    innerFrame.Size = UDim2.new(1, -2, 1, -2)
    innerFrame.Position = UDim2.new(0, 1, 0, 1)
    innerFrame.BackgroundColor3 = self.PRIMARY_BG
    innerFrame.BackgroundTransparency = 0.2
    Instance.new("UICorner", innerFrame).CornerRadius = UDim.new(0, 4)

    return sg
end

function GUIBuilder:CreateTitleBar(currentTheme)
    local title = Instance.new("Frame", self.fr)
    title.Size = UDim2.new(1, 0, 0, self.MINIMIZED_HEIGHT)
    title.BackgroundColor3 = self.DARK_BG
    title.BackgroundTransparency = 0.1
    title.ClipsDescendants = true

    local titleText = Instance.new("TextLabel", title)
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 5, 0, 0)
    titleText.Text = "HNk | " .. currentTheme:upper() .. " [V9.4.3]"
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = self.ACCENT_ON
    titleText.Font = Enum.Font.SourceSansBold
    titleText.TextSize = 16
    titleText.TextXAlignment = Enum.TextXAlignment.Left

    local titleAccent = Instance.new("Frame", title)
    titleAccent.Size = UDim2.new(1, 0, 0, 3)
    titleAccent.Position = UDim2.new(0, 0, 1, -3)
    titleAccent.BackgroundColor3 = self.ACCENT_ON
    titleAccent.BackgroundTransparency = 0.5

    return title, titleText, titleAccent
end

function GUIBuilder:CreateCloseButton()
    local close = Instance.new("TextButton", self.fr:FindFirstChild("Frame") or self.fr)
    close.Size = UDim2.new(0, 25, 0, self.MINIMIZED_HEIGHT)
    close.Position = UDim2.new(1, -25, 0, 0)
    close.Text = "X"
    close.BackgroundColor3 = self.PRIMARY_BG
    close.TextColor3 = self.ACCENT_ON
    close.BackgroundTransparency = 0.8
    close.Font = Enum.Font.SourceSansBold
    close.TextSize = 16
    Instance.new("UIStroke", close).Color = self.ACCENT_ON
    Instance.new("UIStroke", close).Thickness = 1
    
    return close
end

function GUIBuilder:CreateMinimizeButton()
    local minimize = Instance.new("TextButton", self.fr:FindFirstChild("Frame") or self.fr)
    minimize.Size = UDim2.new(0, 25, 0, self.MINIMIZED_HEIGHT)
    minimize.Position = UDim2.new(1, -50, 0, 0)
    minimize.Text = "—"
    minimize.BackgroundColor3 = self.PRIMARY_BG
    minimize.TextColor3 = self.ACCENT_OFF
    minimize.BackgroundTransparency = 0.8
    minimize.Font = Enum.Font.SourceSansBold
    minimize.TextSize = 16
    Instance.new("UIStroke", minimize).Color = self.ACCENT_OFF
    Instance.new("UIStroke", minimize).Thickness = 1
    
    return minimize
end

function GUIBuilder:CreateNavFrame()
    self.navFrame = Instance.new("Frame", self.fr)
    self.navFrame.Size = UDim2.new(0, self.TAB_WIDTH, 1, -25)
    self.navFrame.Position = UDim2.new(0, 0, 0, 25)
    self.navFrame.BackgroundColor3 = self.DARK_BG
    self.navFrame.BackgroundTransparency = 0.1
    self.navFrame.ClipsDescendants = true
    
    Instance.new("UIStroke", self.navFrame).Color = self.ACCENT_OFF
    Instance.new("UIStroke", self.navFrame).Thickness = 1
    Instance.new("UIStroke", self.navFrame).Transparency = 0.5
    
    local navLayout = Instance.new("UIListLayout", self.navFrame)
    navLayout.Padding = UDim.new(0, 2)
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
end

function GUIBuilder:CreateContentFrame()
    self.contentFrame = Instance.new("Frame", self.fr)
    self.contentFrame.Size = UDim2.new(1, -(self.TAB_WIDTH + 5), 1, -35)
    self.contentFrame.Position = UDim2.new(0, self.TAB_WIDTH + 5, 0, 30)
    self.contentFrame.BackgroundColor3 = self.PRIMARY_BG
    self.contentFrame.BackgroundTransparency = 1
    self.contentFrame.ClipsDescendants = true
end

function GUIBuilder:GetColors()
    return {
        accentOn = self.ACCENT_ON,
        accentOff = self.ACCENT_OFF,
        primaryBg = self.PRIMARY_BG,
        darkBg = self.DARK_BG
    }
end

return GUIBuilder

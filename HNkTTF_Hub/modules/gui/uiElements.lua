-- ===================================
-- GUI ELEMENTS MODULE
-- Cria e gerencia elementos específicos da GUI
-- ===================================

local GUIElements = {}

function GUIElements:CreateTabButton(parent, tabName, order, colors)
    local tabButton = Instance.new("TextButton", parent)
    tabButton.Name = tabName:gsub(" ", "") .. "NavBtn"
    tabButton.LayoutOrder = order
    tabButton.Size = UDim2.new(1, -10, 0, 30)
    tabButton.Position = UDim2.new(0, 5, 0, 0)
    tabButton.Text = tabName:upper()
    tabButton.BackgroundColor3 = colors.darkBg
    tabButton.BackgroundTransparency = 0.5
    tabButton.TextColor3 = colors.accentOff
    tabButton.Font = Enum.Font.SourceSansBold
    tabButton.TextSize = 16
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 5)
    
    return tabButton
end

function GUIElements:CreateTabFrame(parent, colors)
    local tabFrame = Instance.new("ScrollingFrame", parent)
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 5
    tabFrame.Visible = false
    tabFrame.ScrollBarImageColor3 = colors.accentOn
    
    local tabLayout = Instance.new("UIListLayout", tabFrame)
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    return tabFrame
end

function GUIElements:CreateToggle(parent, module, colors, helpers, onToggle)
    local frame = Instance.new("Frame", parent)
    frame.Name = "ToggleContainer"
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = #parent:GetChildren() + 1

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Name = "TextLabel"
    textLabel.Size = UDim2.new(1, -60, 0, 40)
    textLabel.Position = UDim2.new(0, 5, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = colors.accentOff
    textLabel.Font = Enum.Font.SourceSansSemibold
    textLabel.TextSize = 16
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Text = helpers:GetDisplayLabelText(module)

    local btn = Instance.new("TextButton", frame)
    btn.Name = "ToggleBtn"
    btn.Size = UDim2.new(0, 50, 0, 20)
    btn.Position = UDim2.new(1, -55, 0.5, -10)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    local toggleBar = Instance.new("Frame", btn)
    toggleBar.Name = "ToggleBar"
    toggleBar.Size = UDim2.new(1, 0, 1, 0)
    toggleBar.BackgroundColor3 = colors.darkBg
    toggleBar.BorderSizePixel = 0
    Instance.new("UICorner", toggleBar).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", toggleBar).Color = colors.accentOn

    local toggleCircle = Instance.new("Frame", btn)
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Size = UDim2.new(0, 20, 1, 0)
    toggleCircle.BackgroundColor3 = colors.accentOff
    toggleCircle.BorderSizePixel = 0
    Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(0, 10)

    local element = {
        Frame = frame,
        TextLabel = textLabel,
        ToggleBar = toggleBar,
        ToggleCircle = toggleCircle
    }

    btn.MouseButton1Click:Connect(function()
        local modName = module.name
        getgenv().HNk[modName] = not getgenv().HNk[modName]
        onToggle(modName)
    end)

    return element
end

function GUIElements:CreateSlider(parent, module, colors, helpers, onSliderChange)
    local frame = Instance.new("Frame", parent)
    frame.Name = "SliderContainer"
    frame.Size = UDim2.new(1, -10, 0, 60)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = #parent:GetChildren() + 1

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Name = "TextLabel"
    textLabel.Size = UDim2.new(1, -60, 0, 20)
    textLabel.Position = UDim2.new(0, 5, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = colors.accentOff
    textLabel.Font = Enum.Font.SourceSansSemibold
    textLabel.TextSize = 16
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Text = helpers:GetDisplayLabelText(module)

    local slider = Instance.new("Frame", frame)
    slider.Name = "SliderBar"
    slider.Size = UDim2.new(1, -60, 0, 10)
    slider.Position = UDim2.new(0.5, -30, 0.5, 20)
    slider.AnchorPoint = Vector2.new(0.5, 0.5)
    slider.BackgroundColor3 = colors.darkBg
    slider.BorderSizePixel = 0
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", slider).Color = colors.accentOff

    local sliderFill = Instance.new("Frame", slider)
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = colors.accentOn
    sliderFill.BorderSizePixel = 0

    local sliderButton = Instance.new("TextButton", slider)
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new(0.5, -10, 0.5, 0)
    sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderButton.BackgroundColor3 = colors.accentOn
    sliderButton.Text = ""
    sliderButton.BorderSizePixel = 0
    Instance.new("UICorner", sliderButton).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", sliderButton).Color = colors.primaryBg

    local isDragging = false
    local minVal = module.min
    local maxVal = module.max

    local function updateSlider(xPos)
        if not slider or not slider.AbsolutePosition or not slider.AbsoluteSize then return end
        local relativeX = xPos - slider.AbsolutePosition.X
        local ratio = math.clamp(relativeX / math.max(1, slider.AbsoluteSize.X), 0, 1)
        local newValue = math.floor(minVal + ratio * (maxVal - minVal))
        
        onSliderChange(newValue, ratio)
    end

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
        end
    end)

    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)

    return frame
end

return GUIElements

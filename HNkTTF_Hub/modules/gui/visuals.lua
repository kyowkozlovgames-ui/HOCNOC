-- ===================================
-- GUI VISUALS MODULE
-- Gerencia atualização visual dos elementos
-- ===================================

local GUIVisuals = {}

function GUIVisuals:Initialize(guiBuilder, tweenService)
    self.guiBuilder = guiBuilder
    self.tweenService = tweenService
    self.tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

function GUIVisuals:UpdateToggleVisuals(name, element)
    if not element then return end
    
    local state = getgenv().HNk and getgenv().HNk[name] or false
    local colors = self.guiBuilder:GetColors()
    local primaryColor = state and colors.accentOn or colors.accentOff
    
    if element.TextLabel then
        element.TextLabel.TextColor3 = primaryColor
    end
    
    if element.ToggleBar then
        element.ToggleBar.BackgroundColor3 = state and colors.accentOn or colors.darkBg
    end
    
    if element.ToggleCircle then
        element.ToggleCircle.BackgroundColor3 = state and colors.darkBg or colors.accentOff
        pcall(function()
            self.tweenService:Create(element.ToggleCircle, 
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = state and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0)}
            ):Play()
        end)
    end

    local stroke = element.Frame and element.Frame:FindFirstChild("UIStroke")
    if not stroke and element.Frame then
        stroke = Instance.new("UIStroke", element.Frame)
    end
    if stroke then
        stroke.Color = primaryColor
        stroke.Thickness = state and 1 or 0.5
        stroke.Transparency = 0.3
    end

    if name == "MinimalMode" and self.guiBuilder.fr then
        if state then
            pcall(function()
                self.guiBuilder.fr.Size = UDim2.new(0, 320, 0, self.guiBuilder.MINIMIZED_HEIGHT)
                if self.guiBuilder.navFrame then self.guiBuilder.navFrame.Visible = false end
                if self.guiBuilder.contentFrame then self.guiBuilder.contentFrame.Visible = false end
            end)
        else
            pcall(function()
                self.guiBuilder.fr.Size = UDim2.new(0, self.guiBuilder.INITIAL_WIDTH, 0, self.guiBuilder.INITIAL_HEIGHT)
                if self.guiBuilder.navFrame then self.guiBuilder.navFrame.Visible = true end
                if self.guiBuilder.contentFrame then self.guiBuilder.contentFrame.Visible = true end
            end)
        end
    end
end

function GUIVisuals:UpdateFOVSliderVisuals(newValue, module)
    if not self.guiBuilder.fovSliderElement then return end
    if not module then return end

    local minVal = module.min
    local maxVal = module.max
    local ratio = math.clamp((newValue - minVal) / (maxVal - minVal), 0, 1)

    local sliderFill = self.guiBuilder.fovSliderElement:FindFirstChild("SliderBar") 
        and self.guiBuilder.fovSliderElement.SliderBar:FindFirstChild("SliderFill")
    local sliderButton = self.guiBuilder.fovSliderElement:FindFirstChild("SliderBar") 
        and self.guiBuilder.fovSliderElement.SliderBar:FindFirstChild("SliderButton")
    local textLabel = self.guiBuilder.fovSliderElement:FindFirstChild("TextLabel")
    
    local colors = self.guiBuilder:GetColors()
    
    if sliderFill and sliderButton and textLabel then
        sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        pcall(function()
            sliderButton.Position = UDim2.new(ratio, -sliderButton.Size.X.Offset/2, 0.5, -sliderButton.Size.Y.Offset/2)
        end)
        textLabel.Text = getDisplayLabelText(module) .. " [" .. tostring(math.floor(newValue)) .. "]"
        textLabel.TextColor3 = colors.accentOn
        sliderFill.BackgroundColor3 = colors.accentOn
        if sliderButton.ImageColor3 then sliderButton.ImageColor3 = colors.accentOn end
    end
end

function GUIVisuals:UpdatePerformanceOverlay(fps, ping, isVisible)
    if not self.guiBuilder.performanceOverlayLabel then return end
    
    self.guiBuilder.performanceOverlayLabel.Visible = isVisible
    local colors = self.guiBuilder:GetColors()
    self.guiBuilder.performanceOverlayLabel.BackgroundColor3 = colors.primaryBg
    self.guiBuilder.performanceOverlayLabel.TextColor3 = colors.accentOn
    self.guiBuilder.performanceOverlayLabel.Text = string.format("FPS: %d\nPING: %d ms", fps, ping)
end

return GUIVisuals

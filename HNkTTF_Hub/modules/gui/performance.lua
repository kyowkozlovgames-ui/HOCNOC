-- ===================================
-- PERFORMANCE OVERLAY MODULE
-- Gerencia overlay de FPS e PING
-- ===================================

local PerformanceOverlay = {}

function PerformanceOverlay:Initialize(coreGui, colors)
    self.coreGui = coreGui
    self.colors = colors
    self.displayGui = nil
    self.performanceLabel = nil
    self.fps = 0
    self.frameCount = 0
    self.lastFPSTime = tick()
    self.FPS_INTERVAL = 0.5
    self.renderConnection = nil
    self.updateConnection = nil
end

function PerformanceOverlay:Create()
    local displayGui = Instance.new("ScreenGui")
    displayGui.Name = "HNkPerformanceOverlay"
    displayGui.Parent = self.coreGui
    displayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("TextLabel", displayGui)
    frame.Size = UDim2.new(0, 150, 0, 40)
    frame.Position = UDim2.new(1, -160, 0, 10)
    frame.BackgroundTransparency = 0.8
    frame.BackgroundColor3 = self.colors.primaryBg
    frame.TextColor3 = self.colors.accentOn
    frame.Font = Enum.Font.SourceSansBold
    frame.TextSize = 14
    frame.TextXAlignment = Enum.TextXAlignment.Left
    frame.TextYAlignment = Enum.TextYAlignment.Top
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)

    self.displayGui = displayGui
    self.performanceLabel = frame
    self.performanceLabel.Visible = getgenv().HNk.PerformanceOverlay

    self.renderConnection = game:GetService("RunService").RenderStepped:Connect(function()
        self.frameCount = self.frameCount + 1
        local now = tick()
        local elapsed = now - self.lastFPSTime
        if elapsed >= self.FPS_INTERVAL then
            self.fps = math.floor(self.frameCount / elapsed + 0.5)
            self.frameCount = 0
            self.lastFPSTime = now
        end
    end)

    self.updateConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if getgenv().HNk.PerformanceOverlay and self.performanceLabel and self.performanceLabel.Visible then
            local pingMs = 0
            local ok, pingVal = pcall(function() 
                return game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer:GetNetworkPing() 
            end)
            
            if ok and type(pingVal) == "number" then
                pingMs = math.floor(pingVal * 1000 + 0.5)
            end
            
            self.performanceLabel.Text = string.format("FPS: %d\nPING: %d ms", self.fps, pingMs)
        end
    end)

    print("[HNk Performance]: Overlay initialized")
end

function PerformanceOverlay:SetVisible(visible)
    if self.performanceLabel then
        self.performanceLabel.Visible = visible
    end
end

function PerformanceOverlay:Destroy()
    if self.renderConnection then
        pcall(function() self.renderConnection:Disconnect() end)
        self.renderConnection = nil
    end
    if self.updateConnection then
        pcall(function() self.updateConnection:Disconnect() end)
        self.updateConnection = nil
    end
    if self.displayGui then
        self.displayGui:Destroy()
    end
end

return PerformanceOverlay

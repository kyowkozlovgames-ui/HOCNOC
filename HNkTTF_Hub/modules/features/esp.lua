-- ===================================
-- ESP FEATURE MODULE
-- Gerencia visualização de inimigos
-- ===================================

local ESPFeature = {}

function ESPFeature:Initialize(helpers, formatting)
    self.helpers = helpers
    self.formatting = formatting
    self.players = game:GetService("Players")
    self.espPlayers = {}
    self.powerCache = {}
    self.repCache = {}
    self.player = self.players.LocalPlayer
    self.runService = game:GetService("RunService")
    self.activeConnection = nil
end

function ESPFeature:UpdatePowerCache()
    local pGui = self.player:FindFirstChild("PlayerGui")
    local myPowerText = "0"
    
    if pGui then
        local targetLabel = pGui:FindFirstChild("MainGui")
            and pGui.MainGui:FindFirstChild("LeftFrame")
            and pGui.MainGui.LeftFrame:FindFirstChild("LeftButtonArea")
            and pGui.MainGui.LeftFrame.LeftButtonArea:FindFirstChild("PowerArea")
            and pGui.MainGui.LeftFrame.LeftButtonArea.PowerArea:FindFirstChild("PowerButton")
            and pGui.MainGui.LeftFrame.LeftButtonArea.PowerArea.PowerButton:FindFirstChild("PowerNum")
        
        if targetLabel and targetLabel:IsA("TextLabel") then
            myPowerText = targetLabel.Text
        end
    end
    
    self.powerCache[self.player] = myPowerText

    for _, p in self.players:GetPlayers() do
        if p ~= self.player then
            local val = self.helpers:FindEnemyPower(p)
            if val then
                self.powerCache[p] = self.formatting:FormatNumber(val)
            else
                self.powerCache[p] = "FAIL"
            end
        end
        
        local repVal = self.helpers:FindPlayerStat(p, "Respect")
        self.repCache[p] = repVal or 0
    end
end

function ESPFeature:Start()
    if self.activeConnection then return end
    
    self.activeConnection = self.runService.Heartbeat:Connect(function()
        self:UpdateESP()
    end)
    
    print("[HNk ESP]: ESP started")
end

function ESPFeature:UpdateESP()
    for _, p in self.players:GetPlayers() do
        if not p.Character or not p.Character:FindFirstChild("Head") then
            if self.espPlayers[p] and self.espPlayers[p].billboard then
                self.espPlayers[p].billboard:Destroy()
            end
            self.espPlayers[p] = nil
            continue
        end

        local data = self.espPlayers[p]
        if not data then
            local head = p.Character.Head
            local bill = Instance.new("BillboardGui", head)
            bill.Name = "HNkESP"
            bill.Size = UDim2.new(0, 200, 0, 70)
            bill.StudsOffset = Vector3.new(0, 3, 0)
            bill.AlwaysOnTop = true

            local name = Instance.new("TextLabel", bill)
            name.Size = UDim2.new(1, 0, 0.5, 0)
            name.Position = UDim2.new(0, 0, 0, 0)
            name.BackgroundTransparency = 1
            name.Text = p.DisplayName
            name.TextColor3 = Color3.new(1, 1, 1)
            name.Font = Enum.Font.GothamBold
            name.TextSize = 16
            name.TextStrokeTransparency = 0
            name.TextStrokeColor3 = Color3.new(0, 0, 0)

            local power = Instance.new("TextLabel", bill)
            power.Size = UDim2.new(1, 0, 0.5, 0)
            power.Position = UDim2.new(0, 0, 0.5, 0)
            power.BackgroundTransparency = 1
            power.Text = "0"
            power.TextColor3 = Color3.fromRGB(255, 100, 100)
            power.Font = Enum.Font.GothamBold
            power.TextSize = 18

            self.espPlayers[p] = {billboard = bill, power = power, name = name}
            data = self.espPlayers[p]
        end

        local playerReputation = self.repCache[p] or 0
        local nameColor = self.helpers:GetReputationColor(p, playerReputation)

        if data.name then
            data.name.TextColor3 = nameColor
        end

        if data and data.power and self.powerCache[p] then
            local pText = self.powerCache[p]
            data.power.Text = pText
            if string.find(pText, "⚡") then
                data.power.TextStrokeTransparency = 0
                data.power.TextStrokeColor3 = Color3.new(0, 0, 0)
            else
                data.power.TextStrokeTransparency = 1
            end
        end
    end
end

function ESPFeature:Stop()
    if self.activeConnection then
        pcall(function() self.activeConnection:Disconnect() end)
        self.activeConnection = nil
    end
    
    for _, data in pairs(self.espPlayers) do
        if data.billboard then
            data.billboard:Destroy()
        end
    end
    self.espPlayers = {}
    
    print("[HNk ESP]: ESP stopped")
end

return ESPFeature

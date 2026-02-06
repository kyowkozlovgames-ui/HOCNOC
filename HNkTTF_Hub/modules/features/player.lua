-- ===================================
-- PLAYER FEATURE MODULE
-- Gerencia modificações do player
-- ===================================

local PlayerFeature = {}

function PlayerFeature:Initialize(remotes)
    self.player = game:GetService("Players").LocalPlayer
    self.runService = game:GetService("RunService")
    self.remotes = remotes
    self.heartbeatConnection = nil
end

function PlayerFeature:Start()
    if self.heartbeatConnection then return end
    
    self.heartbeatConnection = self.runService.Heartbeat:Connect(function()
        self:UpdatePlayer()
    end)
    
    print("[HNk Player]: Player features initialized")
end

function PlayerFeature:UpdatePlayer()
    if not self.player.Character then return end
    
    local char = self.player.Character
    local hum = char:FindFirstChild("Humanoid")
    
    if hum then
        -- Speed hack
        local speedEnabled = getgenv().HNk and getgenv().HNk.Speed or false
        hum.WalkSpeed = speedEnabled and 120 or 16
        
        -- Jump hack
        local jumpEnabled = getgenv().HNk and getgenv().HNk.Jump or false
        hum.JumpPower = jumpEnabled and 150 or 50

        -- Anti-fall integration
        local godEnabled = getgenv().HNk and getgenv().HNk.God or false
        local antiFallEnabled = getgenv().HNk and getgenv().HNk.AntiFall or false
        
        if not godEnabled then
            if antiFallEnabled then
                hum.BreakJointsOnDeath = false
            else
                hum.BreakJointsOnDeath = true
            end
        end
    end
    
    -- Train or Speed: trigger speed remote
    local trainEnabled = getgenv().HNk and getgenv().HNk.Train or false
    local speedEnabled = getgenv().HNk and getgenv().HNk.Speed or false
    
    if trainEnabled or speedEnabled then
        self.remotes:FireSpeedRemote()
    end
end

function PlayerFeature:Stop()
    if self.heartbeatConnection then
        pcall(function() self.heartbeatConnection:Disconnect() end)
        self.heartbeatConnection = nil
    end
    print("[HNk Player]: Player features stopped")
end

return PlayerFeature

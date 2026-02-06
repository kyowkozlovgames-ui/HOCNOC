-- ===================================
-- MISC FEATURES MODULE
-- Gerencia pequenas features (God, AntiAFK, etc)
-- ===================================

local MiscFeatures = {}

function MiscFeatures:Initialize()
    self.player = game:GetService("Players").LocalPlayer
    self.runService = game:GetService("RunService")
    self.godConnection = nil
    self.antiAfkConnection = nil
end

function MiscFeatures:StartGod()
    if self.godConnection then return end
    
    self.godConnection = self.runService.Heartbeat:Connect(function()
        if self.player.Character then
            local hum = self.player.Character:FindFirstChild("Humanoid")
            if hum then
                hum.Health = hum.MaxHealth
                hum.BreakJointsOnDeath = false
            end
        end
    end)
    
    print("[HNk God]: God mode activated")
end

function MiscFeatures:StopGod()
    if self.godConnection then
        pcall(function() self.godConnection:Disconnect() end)
        self.godConnection = nil
    end
    print("[HNk God]: God mode deactivated")
end

function MiscFeatures:StartAntiAFK()
    if self.antiAfkConnection then return end
    
    self.antiAfkConnection = self.player.Idled:Connect(function()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
    
    print("[HNk AntiAFK]: Anti-AFK activated")
end

function MiscFeatures:StopAntiAFK()
    if self.antiAfkConnection then
        pcall(function() self.antiAfkConnection:Disconnect() end)
        self.antiAfkConnection = nil
    end
    print("[HNk AntiAFK]: Anti-AFK deactivated")
end

return MiscFeatures

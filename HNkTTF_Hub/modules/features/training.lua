-- ===================================
-- TRAINING FEATURE MODULE
-- Gerencia automático treino
-- ===================================

local TrainingFeature = {}

function TrainingFeature:Initialize(remotes)
    self.remotes = remotes
    self.activeConnection = nil
end

function TrainingFeature:Start()
    if self.activeConnection then return end
    
    local RunService = game:GetService("RunService")
    self.activeConnection = RunService.Heartbeat:Connect(function()
        self.remotes:InvokeTakeUp()
        self.remotes:InvokeStatEffect()
        self.remotes:InvokeBoostEffect()
    end)
    
    print("[HNk Training]: Training started")
end

function TrainingFeature:Stop()
    if self.activeConnection then
        pcall(function() self.activeConnection:Disconnect() end)
        self.activeConnection = nil
    end
    print("[HNk Training]: Training stopped")
end

function TrainingFeature:IsActive()
    return self.activeConnection ~= nil
end

return TrainingFeature

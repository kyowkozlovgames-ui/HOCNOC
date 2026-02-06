-- ===================================
-- REMOTES MODULE
-- Gerencia todas as conexões com o servidor
-- ===================================

local RemotesModule = {}

RemotesModule.trainEquipment = nil
RemotesModule.trainSystem = nil
RemotesModule.takeUp = nil
RemotesModule.statEffect = nil
RemotesModule.boostEffect = nil
RemotesModule.speedRemote = nil

function RemotesModule:Initialize()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    self.trainEquipment = ReplicatedStorage:WaitForChild("TrainEquipment", 15):WaitForChild("Remote", 15)
    self.trainSystem = ReplicatedStorage:WaitForChild("TrainSystem", 15):WaitForChild("Remote", 15)
    
    self.takeUp = self.trainEquipment:WaitForChild("ApplyTakeUpStationaryTrainEquipment", 15)
    self.statEffect = self.trainEquipment:WaitForChild("ApplyBindingTrainingEffect", 15)
    self.boostEffect = self.trainEquipment:WaitForChild("ApplyBindingTrainingBoostEffect", 15)
    self.speedRemote = self.trainSystem:WaitForChild("TrainSpeedHasChanged", 15)
    
    print("[HNk Remotes]: All remotes loaded successfully")
end

function RemotesModule:InvokeTakeUp()
    pcall(function() self.takeUp:InvokeServer(true) end)
end

function RemotesModule:InvokeStatEffect()
    pcall(function() self.statEffect:InvokeServer() end)
end

function RemotesModule:InvokeBoostEffect()
    pcall(function() self.boostEffect:InvokeServer() end)
end

function RemotesModule:FireSpeedRemote()
    pcall(function() self.speedRemote:FireServer(9999) end)
end

return RemotesModule

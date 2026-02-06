-- ===================================
-- CAMERA FEATURE MODULE
-- Gerencia FOV e controle de câmera
-- ===================================

local CameraFeature = {}

function CameraFeature:Initialize()
    self.camera = workspace.CurrentCamera
    self.userInput = game:GetService("UserInputService")
    self.runService = game:GetService("RunService")
    self.cameraConnection = nil
    self.mouseScrollConnection = nil
end

function CameraFeature:UpdateFOV(fovValue)
    if self.camera and self.camera.CameraType ~= Enum.CameraType.Scriptable then
        self.camera.FieldOfView = fovValue
    end
end

function CameraFeature:SetupMouseScroll()
    if self.mouseScrollConnection then return end
    
    self.mouseScrollConnection = self.userInput.InputChanged:Connect(function(input)
        if not getgenv().HNk or not getgenv().HNk.FOVMOUSECONTROL then return end
        if input.UserInputType ~= Enum.UserInputType.MouseWheel then return end
        if self.camera.CameraType == Enum.CameraType.Scriptable then return end

        local delta = input.Position.Z
        local fovChange = -delta * 5
        local currentFOV = getgenv().HNk.FOV
        local newFOV = math.floor(math.clamp(currentFOV + fovChange, 70, 120) + 0.5)
        
        if newFOV ~= currentFOV then
            getgenv().HNk.FOV = newFOV
            self:UpdateFOV(newFOV)
        end
    end)
end

function CameraFeature:StartHeartbeat()
    if self.cameraConnection then return end
    
    self.cameraConnection = self.runService.Heartbeat:Connect(function()
        if self.camera and getgenv().HNk and getgenv().HNk.FOV then
            if self.camera.FieldOfView ~= getgenv().HNk.FOV then
                if self.camera.CameraType ~= Enum.CameraType.Custom and self.camera.CameraType ~= Enum.CameraType.Watch then
                    self.camera.CameraType = Enum.CameraType.Custom
                end
                self.camera.FieldOfView = getgenv().HNk.FOV
            end
        end
    end)
end

function CameraFeature:Stop()
    if self.cameraConnection then
        pcall(function() self.cameraConnection:Disconnect() end)
        self.cameraConnection = nil
    end
    if self.mouseScrollConnection then
        pcall(function() self.mouseScrollConnection:Disconnect() end)
        self.mouseScrollConnection = nil
    end
end

return CameraFeature

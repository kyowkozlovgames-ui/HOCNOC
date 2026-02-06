-- ===================================
-- ANTI-FALL FEATURE MODULE
-- Gerencia proteção contra quedas
-- ===================================

local AntiFallFeature = {}

function AntiFallFeature:Initialize()
    self.player = game:GetService("Players").LocalPlayer
    self.runService = game:GetService("RunService")
    self.activeConnection = nil
    self.airtimeTracker = {}
    self.lastY = {}
end

function AntiFallFeature:Start()
    if self.activeConnection then return end
    
    self.activeConnection = self.runService.Heartbeat:Connect(function(dt)
        self:CheckFall(dt)
    end)
    
    print("[HNk AntiFall]: Anti-fall detection started")
end

function AntiFallFeature:CheckFall(dt)
    local char = self.player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    -- Track airtime per character
    local onGround = false
    pcall(function() onGround = (hum.FloorMaterial ~= Enum.Material.Air) end)

    if not self.airtimeTracker[self.player] then
        self.airtimeTracker[self.player] = 0
    end
    
    if onGround then
        self.airtimeTracker[self.player] = 0
    else
        self.airtimeTracker[self.player] = self.airtimeTracker[self.player] + dt
    end

    -- Stuck detection
    local velY = hrp.Velocity and hrp.Velocity.Y or 0
    if not self.lastY[self.player] then
        self.lastY[self.player] = velY
    end

    if self.airtimeTracker[self.player] > 2 and math.abs(velY) < 1 then
        -- Recovery attempt
        pcall(function()
            if hum and hum.Health > 0 then
                hum.Health = hum.MaxHealth
            end
            if hrp and hrp:IsA("BasePart") then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z)
            end
        end)
        self.airtimeTracker[self.player] = 0
    end

    -- FallingDown state detection
    pcall(function()
        if hum:GetState() == Enum.HumanoidStateType.FallingDown then
            if hum and hum.Health > 0 then
                hum.Health = hum.MaxHealth
            end
            if hrp and hrp:IsA("BasePart") then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
            end
        end
    end)

    self.lastY[self.player] = velY
end

function AntiFallFeature:Stop()
    if self.activeConnection then
        pcall(function() self.activeConnection:Disconnect() end)
        self.activeConnection = nil
    end
    print("[HNk AntiFall]: Anti-fall detection stopped")
end

return AntiFallFeature

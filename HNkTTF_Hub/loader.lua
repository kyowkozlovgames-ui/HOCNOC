-- ===================================
-- HNk TTF AUTO-TRAIN + POWER ESP HUB v9.4.3
-- Modular Programming Edition - CONSOLIDATED FOR LOADSTRING
-- Funciona perfeitamente com loadstring e Xeno
-- ===================================

print("HNk TTF HUB v9.4.3 loading: Fixed duplicated emojis in tab labels.")

-- ===================================
-- SERVICES (Global)
-- ===================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===================================
-- THEMES MODULE (Inline)
-- ===================================

local Themes = {
    THEMES_CONFIG = {
        ["Shadowcore"] = {
            ACCENT_ON = Color3.fromRGB(255, 60, 60),
            ACCENT_OFF = Color3.fromRGB(80, 80, 80),
            PRIMARY_BG = Color3.fromRGB(15, 15, 15),
            DARK_BG = Color3.fromRGB(25, 25, 25),
        },
        ["CyberSynth"] = {
            ACCENT_ON = Color3.fromRGB(0, 255, 255),
            ACCENT_OFF = Color3.fromRGB(0, 100, 100),
            PRIMARY_BG = Color3.fromRGB(10, 10, 30),
            DARK_BG = Color3.fromRGB(20, 20, 40),
        },
        ["Solar Flare"] = {
            ACCENT_ON = Color3.fromRGB(255, 200, 0),
            ACCENT_OFF = Color3.fromRGB(100, 80, 0),
            PRIMARY_BG = Color3.fromRGB(40, 40, 40),
            DARK_BG = Color3.fromRGB(60, 60, 60),
        },
        ["Vaporwave"] = {
            ACCENT_ON = Color3.fromRGB(255, 0, 255),
            ACCENT_OFF = Color3.fromRGB(150, 0, 150),
            PRIMARY_BG = Color3.fromRGB(30, 0, 30),
            DARK_BG = Color3.fromRGB(40, 40, 60),
        },
        ["Forest Night"] = {
            ACCENT_ON = Color3.fromRGB(0, 255, 120),
            ACCENT_OFF = Color3.fromRGB(0, 100, 50),
            PRIMARY_BG = Color3.fromRGB(10, 20, 10),
            DARK_BG = Color3.fromRGB(20, 40, 20),
        },
        ["Monochrome"] = {
            ACCENT_ON = Color3.fromRGB(255, 255, 255),
            ACCENT_OFF = Color3.fromRGB(150, 150, 150),
            PRIMARY_BG = Color3.fromRGB(0, 0, 0),
            DARK_BG = Color3.fromRGB(20, 20, 20),
        },
    }
}

function Themes:GetTheme(themeName)
    return self.THEMES_CONFIG[themeName]
end

-- ===================================
-- SETTINGS MODULE (Inline)
-- ===================================

local Settings = {
    FILE_NAME = "HNkTTF_config.json",
    HNk = {
        ESP = true, God = true, Speed = false, Jump = false, Train = false,
        AntiAFK = true, AntiFall = true, PerformanceOverlay = true,
        FOV = 90, FOVMOUSECONTROL = false, MinimalMode = false,
        CurrentTheme = "Shadowcore"
    },
    isFileSupport = (pcall(function() readfile() end) and pcall(function() writefile() end)) or false
}

function Settings:SaveConfig()
    if self.isFileSupport then
        local data = HttpService:JSONEncode(self.HNk)
        writefile(self.FILE_NAME, data)
    end
end

function Settings:LoadConfig()
    if self.isFileSupport and readfile(self.FILE_NAME) then
        local data = readfile(self.FILE_NAME)
        local success, decoded = pcall(HttpService.JSONDecode, HttpService, data)
        if success and type(decoded) == "table" then
            for k, v in pairs(decoded) do
                if self.HNk[k] ~= nil and type(self.HNk[k]) == type(v) then
                    self.HNk[k] = v
                end
            end
            print("[HNk Config]: Configurations loaded successfully. Theme: " .. self.HNk.CurrentTheme)
        end
    end
end

-- ===================================
-- HELPERS MODULE (Inline)
-- ===================================

local Helpers = {}

function Helpers:TryCatch(f, ...)
    local success, err = pcall(f, ...)
    if not success then warn("[SafeAutoTrain ERROR]:", err) end
end

function Helpers:GetNumericValue(inst)
    if inst and (inst:IsA("IntValue") or inst:IsA("NumberValue")) then
        return inst.Value
    elseif inst and inst:IsA("StringValue") then
        return tonumber(inst.Value)
    end
    return nil
end

function Helpers:FindPlayerStat(targetPlayer, statName)
    local containers = {targetPlayer:FindFirstChild("AttrConfig"), targetPlayer:FindFirstChild("leaderstats")}
    for _, folder in ipairs(containers) do
        if folder then
            for _, child in folder:GetChildren() do
                if child.Name == statName then return self:GetNumericValue(child) end
            end
        end
    end
    return nil
end

function Helpers:FindEnemyPower(targetPlayer)
    local highestValue = 0
    local currentMaxHealth = 100
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        currentMaxHealth = targetPlayer.Character.Humanoid.MaxHealth
    end
    local containers = {targetPlayer:FindFirstChild("AttrConfig"), targetPlayer:FindFirstChild("leaderstats")}
    for _, folder in ipairs(containers) do
        if folder then
            for _, child in folder:GetChildren() do
                local val = self:GetNumericValue(child)
                if val and val > currentMaxHealth and val > highestValue then highestValue = val end
            end
        end
    end
    return highestValue > 0 and highestValue or nil
end

function Helpers:GetReputationColor(targetPlayer, reputation)
    local MIN_REP_GRADIENT = 5000
    local MAX_REP_GRADIENT = 1000000
    local dn = ""
    if targetPlayer and targetPlayer.DisplayName then dn = targetPlayer.DisplayName:upper() end
    if targetPlayer == player or string.find(dn, "KOZLOV") then
        return Color3.fromRGB(0, 150, 0)
    elseif string.find(dn, "NOTORIOUS") then
        return Color3.fromRGB(0, 150, 255)
    elseif reputation and reputation >= MIN_REP_GRADIENT then
        local ratio = math.min(1, (reputation - MIN_REP_GRADIENT) / (MAX_REP_GRADIENT - MIN_REP_GRADIENT))
        local r, g, b = 255, 150 * (1 - ratio), 200 + 55 * ratio
        return Color3.fromRGB(r, g, b)
    else
        return Color3.new(1, 1, 1)
    end
end

function Helpers:GetDisplayLabelText(module)
    if not module then return "" end
    local icon = module.icon or ""
    local txt = module.text or ""
    if icon == "" then return txt end
    if string.find(txt, icon, 1, true) then return txt end
    return icon .. " " .. txt
end

-- ===================================
-- FORMATTING MODULE (Inline)
-- ===================================

local Formatting = {
    units = {"k", "M", "B", "T", "Qa", "Qi", "Aa", "Ab", "Ac", "Ad", "Ae", "Af", "Ag", "Ah", "Ai", "Aj", "Ak", "Al", "Am", "An", "Ao", "Ap"}
}

function Formatting:FormatNumber(num)
    if type(num) ~= "number" then return tostring(num) end
    if num < 1000 then return tostring(math.floor(num)) end
    local exp = math.log10(num)
    local order = math.floor(exp / 3)
    if order > 0 then
        if order <= #self.units then
            local unit = self.units[order]
            local scaled = num / (10 ^ (order * 3))
            local formatted = string.format("%.2f %s", scaled, unit)
            if order >= 13 then return "⚡ " .. formatted end
            return formatted
        else
            return "⚡ " .. string.format("%.2fe%.0f", num / (10 ^ exp), exp)
        end
    end
    return tostring(num)
end

-- ===================================
-- REMOTES MODULE (Inline)
-- ===================================

local Remotes = {
    trainEquipment = nil, trainSystem = nil, takeUp = nil,
    statEffect = nil, boostEffect = nil, speedRemote = nil
}

function Remotes:Initialize()
    self.trainEquipment = ReplicatedStorage:WaitForChild("TrainEquipment", 15):WaitForChild("Remote", 15)
    self.trainSystem = ReplicatedStorage:WaitForChild("TrainSystem", 15):WaitForChild("Remote", 15)
    self.takeUp = self.trainEquipment:WaitForChild("ApplyTakeUpStationaryTrainEquipment", 15)
    self.statEffect = self.trainEquipment:WaitForChild("ApplyBindingTrainingEffect", 15)
    self.boostEffect = self.trainEquipment:WaitForChild("ApplyBindingTrainingBoostEffect", 15)
    self.speedRemote = self.trainSystem:WaitForChild("TrainSpeedHasChanged", 15)
    print("[HNk Remotes]: All remotes loaded successfully")
end

function Remotes:InvokeTakeUp()
    pcall(function() self.takeUp:InvokeServer(true) end)
end

function Remotes:InvokeStatEffect()
    pcall(function() self.statEffect:InvokeServer() end)
end

function Remotes:InvokeBoostEffect()
    pcall(function() self.boostEffect:InvokeServer() end)
end

function Remotes:FireSpeedRemote()
    pcall(function() self.speedRemote:FireServer(9999) end)
end

-- ===================================
-- FEATURES: TRAINING (Inline)
-- ===================================

local TrainingFeature = {activeConnection = nil}

function TrainingFeature:Start(remotes)
    if self.activeConnection then return end
    self.activeConnection = RunService.Heartbeat:Connect(function()
        remotes:InvokeTakeUp()
        remotes:InvokeStatEffect()
        remotes:InvokeBoostEffect()
    end)
    print("[HNk Training]: Training started")
end

function TrainingFeature:Stop()
    if self.activeConnection then pcall(function() self.activeConnection:Disconnect() end) end
    self.activeConnection = nil
end

-- ===================================
-- FEATURES: ESP (Inline)
-- ===================================

local ESPFeature = {espPlayers = {}, powerCache = {}, repCache = {}, activeConnection = nil}

function ESPFeature:Initialize()
    self.player = Players.LocalPlayer
end

function ESPFeature:UpdatePowerCache()
    local pGui = player:FindFirstChild("PlayerGui")
    local myPowerText = "0"
    if pGui then
        local targetLabel = pGui:FindFirstChild("MainGui")
            and pGui.MainGui:FindFirstChild("LeftFrame")
            and pGui.MainGui.LeftFrame:FindFirstChild("LeftButtonArea")
            and pGui.MainGui.LeftFrame.LeftButtonArea:FindFirstChild("PowerArea")
            and pGui.MainGui.LeftFrame.LeftButtonArea.PowerArea:FindFirstChild("PowerButton")
            and pGui.MainGui.LeftFrame.LeftButtonArea.PowerArea.PowerButton:FindFirstChild("PowerNum")
        if targetLabel and targetLabel:IsA("TextLabel") then myPowerText = targetLabel.Text end
    end
    self.powerCache[player] = myPowerText

    for _, p in Players:GetPlayers() do
        if p ~= player then
            local val = Helpers:FindEnemyPower(p)
            if val then self.powerCache[p] = Formatting:FormatNumber(val) else self.powerCache[p] = "FAIL" end
        end
        local repVal = Helpers:FindPlayerStat(p, "Respect")
        self.repCache[p] = repVal or 0
    end
end

function ESPFeature:Start()
    if self.activeConnection then return end
    self.activeConnection = RunService.Heartbeat:Connect(function() self:UpdateESP() end)
    print("[HNk ESP]: ESP started")
end

function ESPFeature:UpdateESP()
    for _, p in Players:GetPlayers() do
        if not p.Character or not p.Character:FindFirstChild("Head") then
            if self.espPlayers[p] and self.espPlayers[p].billboard then self.espPlayers[p].billboard:Destroy() end
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
        local nameColor = Helpers:GetReputationColor(p, playerReputation)
        if data.name then data.name.TextColor3 = nameColor end
        if data and data.power and self.powerCache[p] then
            local pText = self.powerCache[p]
            data.power.Text = pText
            if string.find(pText, "⚡") then
                data.power.TextStrokeTransparency = 0
            else
                data.power.TextStrokeTransparency = 1
            end
        end
    end
end

function ESPFeature:Stop()
    if self.activeConnection then pcall(function() self.activeConnection:Disconnect() end) end
    self.activeConnection = nil
    for _, data in pairs(self.espPlayers) do
        if data.billboard then data.billboard:Destroy() end
    end
    self.espPlayers = {}
end

-- ===================================
-- FEATURES: ANTI-FALL (Inline)
-- ===================================

local AntiFallFeature = {activeConnection = nil, airtimeTracker = {}, lastY = {}}

function AntiFallFeature:Start()
    if self.activeConnection then return end
    self.activeConnection = RunService.Heartbeat:Connect(function(dt) self:CheckFall(dt) end)
    print("[HNk AntiFall]: Anti-fall detection started")
end

function AntiFallFeature:CheckFall(dt)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    local onGround = false
    pcall(function() onGround = (hum.FloorMaterial ~= Enum.Material.Air) end)
    if not self.airtimeTracker[player] then self.airtimeTracker[player] = 0 end
    if onGround then self.airtimeTracker[player] = 0 else self.airtimeTracker[player] = self.airtimeTracker[player] + dt end

    local velY = hrp.Velocity and hrp.Velocity.Y or 0
    if not self.lastY[player] then self.lastY[player] = velY end

    if self.airtimeTracker[player] > 2 and math.abs(velY) < 1 then
        pcall(function()
            if hum and hum.Health > 0 then hum.Health = hum.MaxHealth end
            if hrp and hrp:IsA("BasePart") then hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z) end
        end)
        self.airtimeTracker[player] = 0
    end

    pcall(function()
        if hum:GetState() == Enum.HumanoidStateType.FallingDown then
            if hum and hum.Health > 0 then hum.Health = hum.MaxHealth end
            if hrp and hrp:IsA("BasePart") then hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z) end
        end
    end)
    self.lastY[player] = velY
end

function AntiFallFeature:Stop()
    if self.activeConnection then pcall(function() self.activeConnection:Disconnect() end) end
    self.activeConnection = nil
end

-- ===================================
-- FEATURES: MISC (Inline)
-- ===================================

local MiscFeatures = {godConnection = nil, antiAfkConnection = nil}

function MiscFeatures:StartGod()
    if self.godConnection then return end
    self.godConnection = RunService.Heartbeat:Connect(function()
        if player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum then
                hum.Health = hum.MaxHealth
                hum.BreakJointsOnDeath = false
            end
        end
    end)
    print("[HNk God]: God mode activated")
end

function MiscFeatures:StopGod()
    if self.godConnection then pcall(function() self.godConnection:Disconnect() end) end
    self.godConnection = nil
end

function MiscFeatures:StartAntiAFK()
    if self.antiAfkConnection then return end
    self.antiAfkConnection = player.Idled:Connect(function()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
    print("[HNk AntiAFK]: Anti-AFK activated")
end

function MiscFeatures:StopAntiAFK()
    if self.antiAfkConnection then pcall(function() self.antiAfkConnection:Disconnect() end) end
    self.antiAfkConnection = nil
end

-- ===================================
-- FEATURES: PLAYER (Inline)
-- ===================================

local PlayerFeature = {heartbeatConnection = nil}

function PlayerFeature:Start(remotes)
    if self.heartbeatConnection then return end
    self.heartbeatConnection = RunService.Heartbeat:Connect(function()
        if not player.Character then return end
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = (getgenv().HNk.Speed and 120 or 16)
            hum.JumpPower = (getgenv().HNk.Jump and 150 or 50)
            if not getgenv().HNk.God then
                hum.BreakJointsOnDeath = (not getgenv().HNk.AntiFall)
            end
        end
        if getgenv().HNk.Train or getgenv().HNk.Speed then remotes:FireSpeedRemote() end
    end)
    print("[HNk Player]: Player features initialized")
end

function PlayerFeature:Stop()
    if self.heartbeatConnection then pcall(function() self.heartbeatConnection:Disconnect() end) end
    self.heartbeatConnection = nil
end

-- ===================================
-- FEATURES: CAMERA (Inline)
-- ===================================

local CameraFeature = {cameraConnection = nil, mouseScrollConnection = nil}

function CameraFeature:UpdateFOV(fovValue)
    if Camera and Camera.CameraType ~= Enum.CameraType.Scriptable then
        Camera.FieldOfView = fovValue
    end
end

function CameraFeature:SetupMouseScroll()
    if self.mouseScrollConnection then return end
    self.mouseScrollConnection = UserInputService.InputChanged:Connect(function(input)
        if not getgenv().HNk or not getgenv().HNk.FOVMOUSECONTROL then return end
        if input.UserInputType ~= Enum.UserInputType.MouseWheel then return end
        if Camera.CameraType == Enum.CameraType.Scriptable then return end

        local delta = input.Position.Z
        local fovChange = -delta * 5
        local currentFOV = getgenv().HNk.FOV
        local newFOV = math.floor(math.clamp(currentFOV + fovChange, 70, 120) + 0.5)
        if newFOV ~= currentFOV then
            getgenv().HNk.FOV = newFOV
            self:UpdateFOV(newFOV)
            Settings:SaveConfig()
        end
    end)
end

function CameraFeature:StartHeartbeat()
    if self.cameraConnection then return end
    self.cameraConnection = RunService.Heartbeat:Connect(function()
        if Camera and getgenv().HNk and getgenv().HNk.FOV then
            if Camera.FieldOfView ~= getgenv().HNk.FOV then
                if Camera.CameraType ~= Enum.CameraType.Custom and Camera.CameraType ~= Enum.CameraType.Watch then
                    Camera.CameraType = Enum.CameraType.Custom
                end
                Camera.FieldOfView = getgenv().HNk.FOV
            end
        end
    end)
end

-- ===================================
-- TOGGLE MANAGER (Inline)
-- ===================================

local ToggleManager = {}

function ToggleManager:HandleToggle(toggleName, isEnabled, remotes)
    if isEnabled then
        if toggleName == "Train" then
            TrainingFeature:Start(remotes)
        elseif toggleName == "AntiAFK" then
            MiscFeatures:StartAntiAFK()
        elseif toggleName == "AntiFall" then
            AntiFallFeature:Start()
        elseif toggleName == "God" then
            MiscFeatures:StartGod()
        elseif toggleName == "ESP" then
            ESPFeature:Start()
        end
    else
        if toggleName == "Train" then
            TrainingFeature:Stop()
        elseif toggleName == "AntiAFK" then
            MiscFeatures:StopAntiAFK()
        elseif toggleName == "AntiFall" then
            AntiFallFeature:Stop()
        elseif toggleName == "God" then
            MiscFeatures:StopGod()
        elseif toggleName == "ESP" then
            ESPFeature:Stop()
        end
    end
end

-- ===================================
-- MODULES DATA (Inline)
-- ===================================

local ModulesData = {
    data = {
        ["Shadow Core"] = {
            {name = "Train", type = "Toggle", text = "CORE: DARK TRAINING (STAT/BOOST)", icon = "⚔️"},
            {name = "AntiAFK", type = "Toggle", text = "ANTI-AFK (SOUL LOCK)", icon = "⏳"},
            {name = "AntiFall", type = "Toggle", text = "ANTI-DEATH (VOID RESCUE)", icon = "💀"},
        },
        ["Visuals"] = {
            {name = "ESP", type = "Toggle", text = "SHADOW ESP (POWER ANALYSE)", icon = "👁️‍🗨️"},
            {name = "PerformanceOverlay", type = "Toggle", text = "OVERLAY: STATUS DE LUTA", icon = "📊"},
            {name = "FOVMouseControl", type = "Toggle", text = "FOV: CONTROLE DO MOUSE (SCROLL)", icon = "🖱️"},
            {name = "MinimalMode", type = "Toggle", text = "MINIMAL MODE (COMPACT GUI)", icon = "🔲"},
            {name = "FOV", type = "Slider", text = "VISÃO: ANÁLISE DE CAMPO", min = 70, max = 120, default = 90, icon = "🔭"},
        },
        ["Player"] = {
            {name = "God", type = "Toggle", text = "HEALTH MAX", icon = "🛡️"},
            {name = "Speed", type = "Toggle", text = "SPEED HACK", icon = "🏃‍♂️"},
            {name = "Jump", type = "Toggle", text = "JUMP HACK", icon = "⬆️"},
        },
        ["Themas"] = {},
    },
    tabOrder = {"Shadow Core", "Visuals", "Player", "Themas"}
}

-- ===================================
-- GUI INITIALIZATION
-- ===================================

Settings:LoadConfig()
getgenv().HNk = Settings.HNk

local themeConfig = Themes:GetTheme(getgenv().HNk.CurrentTheme)
local ACCENT_ON = themeConfig.ACCENT_ON
local ACCENT_OFF = themeConfig.ACCENT_OFF
local PRIMARY_BG = themeConfig.PRIMARY_BG
local DARK_BG = themeConfig.DARK_BG

local INITIAL_WIDTH = 450
local INITIAL_HEIGHT = 380
local TAB_WIDTH = 130
local MINIMIZED_HEIGHT = 25

local fr, navFrame, contentFrame, tabContents = nil, nil, nil, {}
local toggleElements = {}
local fovSliderElement = nil
local performanceOverlayLabel = nil

-- Initialize Remotes
Remotes:Initialize()

-- Initialize Features
ESPFeature:Initialize()
PlayerFeature:Start(Remotes)
CameraFeature:SetupMouseScroll()
CameraFeature:StartHeartbeat()

-- Create GUI
local sg = Instance.new("ScreenGui")
sg.Name = "HNkTTF_V9_Shadowcore_Tabbed"
sg.Parent = CoreGui
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

fr = Instance.new("Frame", sg)
fr.Size = UDim2.new(0, INITIAL_WIDTH, 0, INITIAL_HEIGHT)
fr.Position = UDim2.new(1, -700, 0, 10)
fr.BackgroundColor3 = PRIMARY_BG
fr.BackgroundTransparency = 0.9
fr.BorderSizePixel = 0
fr.Active = true
fr.Draggable = true
Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 5)
local s = Instance.new("UIStroke", fr)
s.Color = ACCENT_ON

local glowFrame = Instance.new("Frame", fr)
glowFrame.Size = UDim2.new(1, 0, 1, 0)
glowFrame.BackgroundTransparency = 0.8
glowFrame.BackgroundColor3 = ACCENT_ON
Instance.new("UICorner", glowFrame).CornerRadius = UDim.new(0, 5)

local innerFrame = Instance.new("Frame", fr)
innerFrame.Size = UDim2.new(1, -2, 1, -2)
innerFrame.Position = UDim2.new(0, 1, 0, 1)
innerFrame.BackgroundColor3 = PRIMARY_BG
innerFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", innerFrame).CornerRadius = UDim.new(0, 4)

local title = Instance.new("Frame", fr)
title.Size = UDim2.new(1, 0, 0, MINIMIZED_HEIGHT)
title.BackgroundColor3 = DARK_BG
title.BackgroundTransparency = 0.1
title.ClipsDescendants = true

local titleText = Instance.new("TextLabel", title)
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 5, 0, 0)
titleText.Text = "HNk | " .. getgenv().HNk.CurrentTheme:upper() .. " [V9.4.3]"
titleText.BackgroundTransparency = 1
titleText.TextColor3 = ACCENT_ON
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left

local titleAccent = Instance.new("Frame", title)
titleAccent.Size = UDim2.new(1, 0, 0, 3)
titleAccent.Position = UDim2.new(0, 0, 1, -3)
titleAccent.BackgroundColor3 = ACCENT_ON
titleAccent.BackgroundTransparency = 0.5

navFrame = Instance.new("Frame", fr)
navFrame.Size = UDim2.new(0, TAB_WIDTH, 1, -25)
navFrame.Position = UDim2.new(0, 0, 0, 25)
navFrame.BackgroundColor3 = DARK_BG
navFrame.BackgroundTransparency = 0.1
navFrame.ClipsDescendants = true
Instance.new("UIStroke", navFrame).Color = ACCENT_OFF
Instance.new("UIStroke", navFrame).Thickness = 1
Instance.new("UIStroke", navFrame).Transparency = 0.5
local navLayout = Instance.new("UIListLayout", navFrame)
navLayout.Padding = UDim.new(0, 2)
navLayout.SortOrder = Enum.SortOrder.LayoutOrder

contentFrame = Instance.new("Frame", fr)
contentFrame.Size = UDim2.new(1, -(TAB_WIDTH + 5), 1, -35)
contentFrame.Position = UDim2.new(0, TAB_WIDTH + 5, 0, 30)
contentFrame.BackgroundColor3 = PRIMARY_BG
contentFrame.BackgroundTransparency = 1
contentFrame.ClipsDescendants = true

local function switchTab(tabName, tabButton)
    for _, btn in navFrame:GetChildren() do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = DARK_BG
            btn.BackgroundTransparency = 0.5
            btn.TextColor3 = ACCENT_OFF
            local str = btn:FindFirstChild("UIStroke")
            if str then str:Destroy() end
        end
    end
    for name, frame in pairs(tabContents) do frame.Visible = (name == tabName) end
    if tabButton then
        tabButton.BackgroundColor3 = ACCENT_ON
        tabButton.BackgroundTransparency = 0.8
        tabButton.TextColor3 = PRIMARY_BG
        local str = tabButton:FindFirstChild("UIStroke") or Instance.new("UIStroke", tabButton)
        str.Color = ACCENT_ON
        str.Thickness = 1
        str.Transparency = 0
    end
end

local function updateToggleVisuals(name, element)
    if not element then return end
    local state = getgenv().HNk[name]
    local primaryColor = state and ACCENT_ON or ACCENT_OFF
    if element.TextLabel then element.TextLabel.TextColor3 = primaryColor end
    if element.ToggleBar then element.ToggleBar.BackgroundColor3 = state and ACCENT_ON or DARK_BG end
    if element.ToggleCircle then
        element.ToggleCircle.BackgroundColor3 = state and DARK_BG or ACCENT_OFF
        pcall(function()
            TweenService:Create(element.ToggleCircle, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = state and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0)
            }):Play()
        end)
    end
    local str = element.Frame and element.Frame:FindFirstChild("UIStroke")
    if not str and element.Frame then str = Instance.new("UIStroke", element.Frame) end
    if str then
        str.Color = primaryColor
        str.Thickness = state and 1 or 0.5
        str.Transparency = 0.3
    end
    if name == "MinimalMode" and fr then
        if state then
            pcall(function()
                fr.Size = UDim2.new(0, 320, 0, MINIMIZED_HEIGHT)
                if navFrame then navFrame.Visible = false end
                if contentFrame then contentFrame.Visible = false end
            end)
        else
            pcall(function()
                fr.Size = UDim2.new(0, INITIAL_WIDTH, 0, INITIAL_HEIGHT)
                if navFrame then navFrame.Visible = true end
                if contentFrame then contentFrame.Visible = true end
            end)
        end
    end
end

-- Build tabs
for order, tabName in ipairs(ModulesData.tabOrder) do
    local modules = ModulesData.data[tabName]
    local tabFrame = Instance.new("ScrollingFrame", contentFrame)
    tabFrame.Name = tabName:gsub(" ", "") .. "Tab"
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 5
    tabFrame.Visible = false
    tabFrame.ScrollBarImageColor3 = ACCENT_ON
    local tabLayout = Instance.new("UIListLayout", tabFrame)
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabContents[tabName] = tabFrame

    local tabButton = Instance.new("TextButton", navFrame)
    tabButton.Name = tabName:gsub(" ", "") .. "NavBtn"
    tabButton.LayoutOrder = order
    tabButton.Size = UDim2.new(1, -10, 0, 30)
    tabButton.Position = UDim2.new(0, 5, 0, 0)
    tabButton.Text = tabName:upper()
    tabButton.BackgroundColor3 = DARK_BG
    tabButton.BackgroundTransparency = 0.5
    tabButton.TextColor3 = ACCENT_OFF
    tabButton.Font = Enum.Font.SourceSansBold
    tabButton.TextSize = 16
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 5)

    if tabName == "Themas" then
        local createContainer = Instance.new("Frame", tabFrame)
        createContainer.Size = UDim2.new(1, -10, 0, 40)
        createContainer.BackgroundTransparency = 1
        createContainer.LayoutOrder = 1

        local createBtn = Instance.new("TextButton", createContainer)
        createBtn.Size = UDim2.new(1, 0, 1, 0)
        createBtn.Text = "➕ Create Custom Theme"
        createBtn.Font = Enum.Font.SourceSansBold
        createBtn.TextSize = 16
        createBtn.BackgroundColor3 = ACCENT_ON
        createBtn.TextColor3 = PRIMARY_BG
        Instance.new("UICorner", createBtn).CornerRadius = UDim.new(0, 5)
        createBtn.MouseButton1Click:Connect(function()
            local idx = 1
            while Themes.THEMES_CONFIG["CustomTheme" .. idx] do idx = idx + 1 end
            local name = "CustomTheme" .. idx
            local function rnd() return math.random(60, 230) end
            local accent = Color3.fromRGB(rnd(), rnd(), rnd())
            Themes.THEMES_CONFIG[name] = {
                ACCENT_ON = accent,
                ACCENT_OFF = Color3.fromRGB(math.clamp(accent.R*255*0.4, 30, 200), math.clamp(accent.G*255*0.4, 30, 200), math.clamp(accent.B*255*0.4, 30, 200)),
                PRIMARY_BG = Color3.fromRGB(math.random(5, 60), math.random(5, 60), math.random(5, 60)),
                DARK_BG = Color3.fromRGB(math.random(10, 120), math.random(10, 120), math.random(10, 120)),
            }
        end)

        for themeName, _ in pairs(Themes.THEMES_CONFIG) do
            local frame = Instance.new("Frame", tabFrame)
            frame.Name = themeName .. "Container"
            frame.Size = UDim2.new(1, -10, 0, 40)
            frame.BackgroundTransparency = 1
            frame.LayoutOrder = #tabFrame:GetChildren() + 1

            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.Text = "🎨 " .. themeName
            btn.BackgroundColor3 = Themes.THEMES_CONFIG[themeName].ACCENT_ON
            btn.BackgroundTransparency = 0.5
            btn.TextColor3 = Themes.THEMES_CONFIG[themeName].PRIMARY_BG
            btn.Font = Enum.Font.SourceSansSemibold
            btn.TextSize = 16
            Instance.new("UIStroke", btn).Color = Themes.THEMES_CONFIG[themeName].ACCENT_ON

            btn.MouseButton1Click:Connect(function()
                local tc = Themes.THEMES_CONFIG[themeName]
                ACCENT_ON, ACCENT_OFF, PRIMARY_BG, DARK_BG = tc.ACCENT_ON, tc.ACCENT_OFF, tc.PRIMARY_BG, tc.DARK_BG
                getgenv().HNk.CurrentTheme = themeName
                Settings:SaveConfig()
                if fr then fr.BackgroundColor3 = PRIMARY_BG end
                for n, el in pairs(toggleElements) do updateToggleVisuals(n, el) end
            end)
        end
    else
        for _, module in ipairs(modules) do
            local modName = module.name
            if module.type == "Toggle" then
                local frame = Instance.new("Frame", tabFrame)
                frame.Name = "ToggleContainer"
                frame.Size = UDim2.new(1, -10, 0, 40)
                frame.BackgroundTransparency = 1
                frame.LayoutOrder = #tabFrame:GetChildren() + 1

                local textLabel = Instance.new("TextLabel", frame)
                textLabel.Name = "TextLabel"
                textLabel.Size = UDim2.new(1, -60, 0, 40)
                textLabel.Position = UDim2.new(0, 5, 0, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = ACCENT_OFF
                textLabel.Font = Enum.Font.SourceSansSemibold
                textLabel.TextSize = 16
                textLabel.TextXAlignment = Enum.TextXAlignment.Left
                textLabel.Text = Helpers:GetDisplayLabelText(module)

                local btn = Instance.new("TextButton", frame)
                btn.Name = "ToggleBtn"
                btn.Size = UDim2.new(0, 50, 0, 20)
                btn.Position = UDim2.new(1, -55, 0.5, -10)
                btn.BackgroundTransparency = 1
                btn.Text = ""

                local toggleBar = Instance.new("Frame", btn)
                toggleBar.Name = "ToggleBar"
                toggleBar.Size = UDim2.new(1, 0, 1, 0)
                toggleBar.BackgroundColor3 = DARK_BG
                toggleBar.BorderSizePixel = 0
                Instance.new("UICorner", toggleBar).CornerRadius = UDim.new(0, 10)
                Instance.new("UIStroke", toggleBar).Color = ACCENT_ON

                local toggleCircle = Instance.new("Frame", btn)
                toggleCircle.Name = "ToggleCircle"
                toggleCircle.Size = UDim2.new(0, 20, 1, 0)
                toggleCircle.BackgroundColor3 = ACCENT_OFF
                toggleCircle.BorderSizePixel = 0
                Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(0, 10)

                local element = {Frame = frame, TextLabel = textLabel, ToggleBar = toggleBar, ToggleCircle = toggleCircle}
                toggleElements[modName] = element

                btn.MouseButton1Click:Connect(function()
                    getgenv().HNk[modName] = not getgenv().HNk[modName]
                    Settings:SaveConfig()
                    ToggleManager:HandleToggle(modName, getgenv().HNk[modName], Remotes)
                    updateToggleVisuals(modName, element)
                    print("HNk Status: " .. modName .. " is now " .. tostring(getgenv().HNk[modName]))
                end)

                updateToggleVisuals(modName, element)
            end
        end
    end

    tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
    tabButton.MouseButton1Click:Connect(function() switchTab(tabName, tabButton) end)
end

switchTab("Shadow Core", navFrame:FindFirstChild("ShadowCoreNavBtn"))

-- Close and Minimize buttons
local close = Instance.new("TextButton", title)
close.Size = UDim2.new(0, 25, 1, 0)
close.Position = UDim2.new(1, -25, 0, 0)
close.Text = "X"
close.BackgroundColor3 = PRIMARY_BG
close.TextColor3 = ACCENT_ON
close.BackgroundTransparency = 0.8
close.Font = Enum.Font.SourceSansBold
close.TextSize = 16
Instance.new("UIStroke", close).Color = ACCENT_ON
Instance.new("UIStroke", close).Thickness = 1
close.MouseButton1Click:Connect(function() sg:Destroy() end)

local minimize = Instance.new("TextButton", title)
minimize.Size = UDim2.new(0, 25, 1, 0)
minimize.Position = UDim2.new(1, -50, 0, 0)
minimize.Text = "—"
minimize.BackgroundColor3 = PRIMARY_BG
minimize.TextColor3 = ACCENT_OFF
minimize.BackgroundTransparency = 0.8
minimize.Font = Enum.Font.SourceSansBold
minimize.TextSize = 16
Instance.new("UIStroke", minimize).Color = ACCENT_OFF
Instance.new("UIStroke", minimize).Thickness = 1

local isMinimized = false
minimize.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        fr.Size = UDim2.new(0, 320, 0, MINIMIZED_HEIGHT)
        navFrame.Visible = false
        contentFrame.Visible = false
        minimize.Text = "+"
    else
        fr.Size = UDim2.new(0, INITIAL_WIDTH, 0, INITIAL_HEIGHT)
        navFrame.Visible = true
        contentFrame.Visible = true
        minimize.Text = "—"
    end
end)

-- Performance Overlay
task.spawn(function()
    local displayGui = Instance.new("ScreenGui")
    displayGui.Name = "HNkPerformanceOverlay"
    displayGui.Parent = CoreGui
    displayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("TextLabel", displayGui)
    frame.Size = UDim2.new(0, 150, 0, 40)
    frame.Position = UDim2.new(1, -160, 0, 10)
    frame.BackgroundTransparency = 0.8
    frame.BackgroundColor3 = PRIMARY_BG
    frame.TextColor3 = ACCENT_ON
    frame.Font = Enum.Font.SourceSansBold
    frame.TextSize = 14
    frame.TextXAlignment = Enum.TextXAlignment.Left
    frame.TextYAlignment = Enum.TextYAlignment.Top
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)

    performanceOverlayLabel = frame
    performanceOverlayLabel.Visible = getgenv().HNk.PerformanceOverlay

    local fps, frameCount, lastFPSTime, FPS_INTERVAL = 0, 0, tick(), 0.5

    local renderConn = RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = tick()
        if now - lastFPSTime >= FPS_INTERVAL then
            fps = math.floor(frameCount / (now - lastFPSTime) + 0.5)
            frameCount = 0
            lastFPSTime = now
        end
    end)

    while task.wait(0.3) do
        if getgenv().HNk.PerformanceOverlay and performanceOverlayLabel and performanceOverlayLabel.Visible then
            local pingMs = 0
            local ok, pingVal = pcall(function() return Players.LocalPlayer:GetNetworkPing() end)
            if ok and type(pingVal) == "number" then pingMs = math.floor(pingVal * 1000 + 0.5) end
            performanceOverlayLabel.Text = string.format("FPS: %d\nPING: %d ms", fps, pingMs)
        end
    end

    if renderConn then pcall(function() renderConn:Disconnect() end) end
end)

-- Garbage Collection
task.spawn(function() while task.wait(60) do collectgarbage("collect") end end)

-- ESP Power Cache Update
task.spawn(function()
    while task.wait(0.3) do
        if getgenv().HNk.ESP then ESPFeature:UpdatePowerCache() end
    end
end)

-- Initialize all toggles
for name, value in pairs(getgenv().HNk) do
    if type(value) == "boolean" and name ~= "FOVMOUSECONTROL" then
        ToggleManager:HandleToggle(name, value, Remotes)
    end
end

print("HNk TTF HUB v9.4.3 FINAL ACTIVE! GUI fully initialized and stable.")
print("All features are modularized and ready for maintenance & updates!")

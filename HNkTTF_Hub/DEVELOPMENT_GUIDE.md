# 🚀 Guia de Desenvolvimento - Expandindo o HNk Hub

Este guia mostra como adicionar novas features ao Hub mantendo a arquitetura modular.

---

## Exemplo 1: Adicionar um Toggle Simples (Anti-Lag)

### Passo 1: Criar o módulo da feature

Crie o arquivo `modules/features/antilag.lua`:

```lua
-- ===================================
-- ANTI-LAG FEATURE MODULE
-- Reduz drawcalls e melhora performance
-- ===================================

local AntiLagFeature = {}

function AntiLagFeature:Initialize()
    self.player = game:GetService("Players").LocalPlayer
    self.connection = nil
end

function AntiLagFeature:Start()
    if self.connection then return end
    
    self.connection = game:GetService("RunService").Heartbeat:Connect(function()
        self:OptimizeGraphics()
    end)
    
    print("[HNk AntiLag]: Anti-lag optimization enabled")
end

function AntiLagFeature:OptimizeGraphics()
    -- Desativa partículas distantes
    for _, part in pairs(workspace:FindPartBoundsInRadius(self.player.Character.Head.Position, 50)) do
        if part:IsA("BasePart") and part.Name:find("Particle") then
            part.CanCollide = false
        end
    end
end

function AntiLagFeature:Stop()
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end
    print("[HNk AntiLag]: Anti-lag optimization disabled")
end

return AntiLagFeature
```

### Passo 2: Adicionar à ModulesData

Edite `modules/config/modulesData.lua`:

```lua
["Visuals"] = {
    -- ... features existentes
    {name = "AntiLag", type = "Toggle", text = "ANTI-LAG (OPTIMIZATION)", icon = "⚡"},
}
```

### Passo 3: Carregar no main.lua

Em `main.lua`, após as requires:

```lua
local AntiLagFeature = require(modulePath.features.antilag)
```

Em features:

```lua
local features = {
    -- ... features existentes
    antilag = AntiLagFeature
}
```

Inicialize:

```lua
AntiLagFeature:Initialize()
```

Em ToggleManager.lua, adicione:

```lua
elseif toggleName == "AntiLag" then
    self.features.antilag:Start()
    -- ...
elseif toggleName == "AntiLag" then
    self.features.antilag:Stop()
```

---

## Exemplo 2: Adicionar um Slider (Effect Multiplier)

### Passo 1: Criar o módulo

`modules/features/effects.lua`:

```lua
local EffectsFeature = {}

function EffectsFeature:Initialize()
    self.player = game:GetService("Players").LocalPlayer
    self.multiplier = 1
    self.connection = nil
end

function EffectsFeature:Start()
    if self.connection then return end
    
    self.connection = game:GetService("RunService").Heartbeat:Connect(function()
        self:ApplyEffects()
    end)
end

function EffectsFeature:SetMultiplier(value)
    self.multiplier = value
end

function EffectsFeature:ApplyEffects()
    -- Aplica o multiplicador de efeitos
    if self.player.Character then
        -- Sua lógica aqui
    end
end

function EffectsFeature:Stop()
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end
end

return EffectsFeature
```

### Passo 2: Adicionar à ModulesData

```lua
["Player"] = {
    -- ... existing
    {name = "EffectMultiplier", type = "Slider", text = "EFFECT MULTIPLIER", min = 1, max = 5, default = 1, icon = "✨"},
}
```

### Passo 3: Manejar o Slider

No evento de slider em `main.lua`:

```lua
function(newValue, ratio)
    if getgenv().HNk.EffectMultiplier ~= newValue then
        getgenv().HNk.EffectMultiplier = newValue
        Settings:SaveConfig()
        
        -- Seu code aqui
        features.effects:SetMultiplier(newValue)
    end
end
```

---

## Exemplo 3: Adicionar um Novo Tema

### Opção A: Adicionar ao themes.lua

Edite `modules/config/themes.lua`:

```lua
ThemesModule.THEMES_CONFIG = {
    -- ... themes existentes
    ["Neon Night"] = {
        ACCENT_ON = Color3.fromRGB(0, 255, 200),
        ACCENT_OFF = Color3.fromRGB(0, 100, 100),
        PRIMARY_BG = Color3.fromRGB(10, 30, 30),
        DARK_BG = Color3.fromRGB(20, 50, 50),
    },
}
```

### Opção B: Criar dinamicamente na GUI

O hub já suporta! Clique em "➕ Create Custom Theme" na aba Themes.

---

## Exemplo 4: Adicionar uma Nova Aba

### Passo 1: Atualizar ModulesData

```lua
ModulesData.data = {
    -- ... abas existentes
    ["Utilities"] = {
        {name = "Radar", type = "Toggle", text = "PLAYER RADAR", icon = "📡"},
        {name = "ChatLogger", type = "Toggle", text = "CHAT LOGGER", icon = "💬"},
    },
}

ModulesData.tabOrder = {"Shadow Core", "Visuals", "Player", "Utilities", "Themas"}
```

### Passo 2: Criar os módulos

Crie `modules/features/radar.lua` e `modules/features/chatlogger.lua`

### Passo 3: Carregar e registrar

```lua
local RadarFeature = require(modulePath.features.radar)
local ChatLoggerFeature = require(modulePath.features.chatlogger)

local features = {
    -- ... existing
    radar = RadarFeature,
    chatlogger = ChatLoggerFeature
}
```

---

## Padrão de Estrutura para Novas Features

Toda feature deve seguir este padrão:

```lua
-- ===================================
-- FEATURE NAME MODULE
-- Brief description
-- ===================================

local FeatureName = {}

function FeatureName:Initialize(...)
    -- Setup inicial, guardar referências, conectar serviços
    self.player = game:GetService("Players").LocalPlayer
    self.connection = nil
end

function FeatureName:Start()
    -- Ativar a feature
    if self.connection then return end
    
    self.connection = game:GetService("RunService").Heartbeat:Connect(function()
        self:Update()
    end)
    
    print("[HNk FeatureName]: Started")
end

function FeatureName:Update()
    -- Lógica principal da feature
end

function FeatureName:Stop()
    -- Desativar a feature
    if self.connection then
        pcall(function() self.connection:Disconnect() end)
        self.connection = nil
    end
    
    print("[HNk FeatureName]: Stopped")
end

-- Funções auxiliares (opcional)
function FeatureName:SomeHelper()
    -- Helper methods
end

return FeatureName
```

---

## Checklist para Adicionar Feature

- [ ] Criar arquivo `modules/features/myfeature.lua`
- [ ] Implementar `Initialize()`, `Start()`, `Stop()`
- [ ] Adicionar à ModulesData em `modules/config/modulesData.lua`
- [ ] Importar em `main.lua`
- [ ] Adicionar ao objeto `features`
- [ ] Chamar `Initialize()`
- [ ] Adicionar lógica ao `ToggleManager:HandleToggle()`
- [ ] Testar ativação/desativação
- [ ] Testar persistência (se necessário)

---

## Dicas de Desenvolvimento

### 1. Use TryCatch para segurança
```lua
local Helpers = require(modulePath.utils.helpers)
Helpers:TryCatch(function()
    -- Seu código que pode dar erro
end)
```

### 2. Persistência automática
```lua
-- Qualquer toggle/slider atualiza automaticamente
Settings:SaveConfig()
```

### 3. Debug no console
```lua
print("[HNk MyFeature]: Event happened")
warn("[HNk MyFeature]: Warning message")
```

### 4. Acessar config global
```lua
local isEnabled = getgenv().HNk.MyFeature
local themeName = getgenv().HNk.CurrentTheme
```

### 5. Trabalhar com Colors
```lua
local colors = GUIBuilder:GetColors()
-- colors.accentOn, colors.accentOff, colors.primaryBg, colors.darkBg
```

---

## Estrutura de UI Element

Se precisar criar um novo elemento UI:

```lua
local GUIElements = require(modulePath.gui.uiElements)

-- Para Toggle
local element = GUIElements:CreateToggle(parentFrame, module, colors, helpers, onToggle)

-- Para Slider
local frame = GUIElements:CreateSlider(parentFrame, module, colors, helpers, onSliderChange)

-- Para Tab Button
local button = GUIElements:CreateTabButton(navFrame, "TabName", order, colors)
```

---

## Performance

- **Evite loops desnecessários**: Use Heartbeat ou Stepped
- **Desconecte conexões**: Sempre implemente `Stop()`
- **Limpeza de recursos**: Destrua instances quando não usar
- **Garbage collection**: Já incluído no script principal

---

**Pronto para expandir! 🚀**

# HNk TTF AUTO-TRAIN + POWER ESP HUB v9.4.3
## Modular Programming Edition

Um hub Roblox completo com features de treinamento automático, ESP, e modificações de player - agora com **arquitetura modular** para fácil manutenção e expansão!

---

## 📂 Estrutura do Projeto

```
HNkTTF_Hub/
├── main.lua                 # Arquivo principal (EXECUTAR ESTE)
├── init.lua                 # Script de inicialização alternativo
├── modules/
│   ├── config/              # Configurações e dados
│   │   ├── themes.lua       # Definição de temas
│   │   ├── settings.lua     # Persistência e config global
│   │   └── modulesData.lua  # Estrutura de módulos da GUI
│   │
│   ├── utils/               # Funções utilitárias
│   │   ├── helpers.lua      # Helpers gerais (busca de stats, cores, etc)
│   │   └── formatting.lua   # Formatação numérica
│   │
│   ├── services/            # Serviços e conexões com servidor
│   │   └── remotes.lua      # Gerenciamento de Remotes
│   │
│   ├── gui/                 # Interface gráfica
│   │   ├── builder.lua      # Construção dos elementos base da GUI
│   │   ├── themes.lua       # Gerenciamento de temas na GUI
│   │   ├── visuals.lua      # Atualização visual dos elementos
│   │   ├── uiElements.lua   # Criação de botões, sliders, toggles
│   │   └── performance.lua  # Overlay de FPS e PING
│   │
│   └── features/            # Features do hub
│       ├── training.lua     # Treinamento automático
│       ├── esp.lua          # Shadow ESP
│       ├── antifall.lua     # Proteção contra quedas
│       ├── player.lua       # Modificações do player (Speed, Jump, God mode)
│       ├── misc.lua         # Misc features (God, AntiAFK)
│       ├── camera.lua       # FOV e controle de câmera
│       └── toggleManager.lua# Gerenciador central de toggles
```

---

## 🚀 Como Usar

### Opção 1: Loadstring (Recomendado)
```lua
loadstring(game:HttpGet("https://seu-host.com/HNkTTF_Hub/main.lua"))()
```

### Opção 2: Local (Se hospedado localmente)
1. Coloque a pasta `HNkTTF_Hub` em um local acessível
2. Execute `main.lua` via comando local ou loadstring

---

## 🎯 Módulos Disponíveis

### Configuration Modules
- **Themes**: Gerencia 6 temas padrão + temas customizados
- **Settings**: Persistência de configurações em arquivo
- **ModulesData**: Define estrutura de todos os módulos da GUI

### Utility Modules
- **Helpers**: Busca de stats, cores de reputação, formatação de labels
- **Formatting**: Converte números grandes em K, M, B, T, etc

### Service Modules
- **Remotes**: Gerencia todas as conexões com o servidor

### GUI Modules
- **Builder**: Cria a estrutura base da interface
- **Themes**: Adiciona/seleciona temas dinamicamente
- **Visuals**: Atualiza cores e animações dos elementos
- **UIElements**: Cria toggles, sliders e botões
- **Performance**: Overlay de FPS/PING em tempo real

### Feature Modules
- **Training**: Treino automático de stats com boost
- **ESP**: Visualização de inimigos com power display
- **AntiFall**: Proteção inteligente contra quedas/stuck
- **Player**: Speed hack, Jump hack, integração com God mode
- **Misc**: God mode e Anti-AFK
- **Camera**: FOV customizável com controle por mouse scroll
- **ToggleManager**: Gerencia ativação/desativação central

---

## 🔧 Adicionando Novas Features

### Exemplo: Adicionar uma nova feature "Teleport"

1. **Criar o módulo** (`modules/features/teleport.lua`):
```lua
local TeleportFeature = {}

function TeleportFeature:Initialize()
    self.player = game:GetService("Players").LocalPlayer
    self.connection = nil
end

function TeleportFeature:Start()
    if self.connection then return end
    self.connection = game:GetService("RunService").Heartbeat:Connect(function()
        -- Teleport logic aqui
    end)
    print("[HNk Teleport]: Started")
end

function TeleportFeature:Stop()
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end
end

return TeleportFeature
```

2. **Adicionar ao main.lua**:
```lua
local TeleportFeature = require(modulePath.features.teleport)
-- ... em Initialize Features
local features = {
    -- ... features existentes
    teleport = TeleportFeature
}
TeleportFeature:Initialize()
```

3. **Adicionar ao ModulesData** (`modules/config/modulesData.lua`):
```lua
["Player"] = {
    -- ... módulos existentes
    {name = "Teleport", type = "Toggle", text = "TELEPORT HACK", icon = "🌀"},
}
```

4. **Adicionar ao ToggleManager** (`modules/features/toggleManager.lua`):
```lua
elseif toggleName == "Teleport" then
    self.features.teleport:Start()
    -- ...
elseif toggleName == "Teleport" then
    self.features.teleport:Stop()
```

---

## 📝 Principais Mudanças vs Original

✅ **Código organizado em módulos lógicos**
- Cada feature é independente
- Fácil de debugar e testar
- Reutilizável em outros projetos

✅ **Melhor manutenção**
- Adicionar features é trivial
- Alterar configurações sem tocar em código
- Temas podem ser adicionados dinamicamente

✅ **Separação de responsabilidades**
- Utils: Funções auxiliares
- Services: Conexões com servidor
- Features: Lógica de features
- GUI: Interface gráfica

✅ **Escalável**
- Suporta N temas customizados
- Suporta N features facilmente
- Sistema de moduleData centralizado

---

## 🎨 Temas Disponíveis

1. **Shadowcore** (Padrão) - Vermelho e escuro
2. **CyberSynth** - Ciano e escuro futurista
3. **Solar Flare** - Amarelo/ouro
4. **Vaporwave** - Magenta/retro
5. **Forest Night** - Verde floresta
6. **Monochrome** - Preto e branco

Crie temas customizados na GUI com o botão "➕ Create Custom Theme"

---

## 🐛 Troubleshooting

### "Cannot load module"
- Certifique-se que a estrutura de pastas está correta
- Verifique que todos os arquivos estão no local certo

### Features não ativam
- Verifique console para mensagens de erro
- Certifique-se que los remotes estão carregados
- Aguarde 15 segundos para remotes foram encontrados

### GUI não aparece
- Verifique se CoreGui não está bloqueado
- Procure erros no console do Roblox
- Tente fechar/abrir a GUI com o botão X

---

## 📊 Features Implementadas

| Feature | Status | Módulo |
|---------|--------|--------|
| Training | ✅ | training.lua |
| Anti-AFK | ✅ | misc.lua |
| Anti-Fall | ✅ | antifall.lua |
| ESP | ✅ | esp.lua |
| God Mode | ✅ | misc.lua |
| Speed Hack | ✅ | player.lua |
| Jump Hack | ✅ | player.lua |
| FOV Control | ✅ | camera.lua |
| Performance Overlay | ✅ | performance.lua |
| Minimal Mode | ✅ | visuals.lua |
| Custom Themes | ✅ | themes.lua |
| Config Persistence | ✅ | settings.lua |

---

## 📌 Versão

**v9.4.3 - Modular Edition**
- Arquitetura completamente refatorada
- 100% compatível com versão anterior
- Funcionalidades preservadas
- Pronto para manutenção e expansão

---

## ⚠️ Disclaimer

Use este script por sua conta e risco. Roblox pode banir contas por uso de exploits. Use com cuidado e responsavelmente.

---

**Desenvolvido com ❤️ pela comunidade HNk TTF**

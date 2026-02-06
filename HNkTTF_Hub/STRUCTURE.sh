#!/bin/bash
# Structure Overview - HNk TTF Hub Modular
# Executar: bash this_file.sh

echo "📁 HNk TTF Hub - Estrutura Completa"
echo "===================================="
echo ""

tree_output="
HNkTTF_Hub/
├── 📄 main.lua                       │ Executável principal
├── 📄 init.lua                       │ Script de inicialização
├── 📄 README_MODULAR.md              │ Documentação completa
├── 📄 DEVELOPMENT_GUIDE.md           │ Guia de desenvolvimento
├── 📄 QUICKSTART.md                  │ Início rápido
│
├── 📁 modules/
│   │
│   ├── 📁 config/
│   │   ├── themes.lua                │ 6 temas + customização
│   │   ├── settings.lua              │ Persistência de dados
│   │   └── modulesData.lua           │ Estrutura dos módulos
│   │
│   ├── 📁 utils/
│   │   ├── helpers.lua               │ Funções auxiliares
│   │   └── formatting.lua            │ Formatação numérica
│   │
│   ├── 📁 services/
│   │   └── remotes.lua               │ Gerenciamento de Remotes
│   │
│   ├── 📁 gui/
│   │   ├── builder.lua               │ Construção base
│   │   ├── themes.lua                │ Gerenciamento de temas
│   │   ├── visuals.lua               │ Atualizações visuais
│   │   ├── uiElements.lua            │ Toggles, sliders, botões
│   │   └── performance.lua           │ Overlay FPS/PING
│   │
│   └── 📁 features/
│       ├── training.lua              │ Treino automático
│       ├── esp.lua                   │ Shadow ESP
│       ├── antifall.lua              │ Anti-quedas
│       ├── player.lua                │ Speed, Jump, Player mods
│       ├── misc.lua                  │ God, Anti-AFK
│       ├── camera.lua                │ FOV e controle câmera
│       └── toggleManager.lua         │ Gerenciador central
"

echo "$tree_output"
echo ""
echo "📊 Estatísticas:"
echo "  • 20 arquivos Lua"
echo "  • 7 módulos principais"
echo "  • 100% funcional"
echo "  • Pronto para expansão"
echo ""
echo "🚀 Execute: loadstring(game:HttpGet('...main.lua'))()"

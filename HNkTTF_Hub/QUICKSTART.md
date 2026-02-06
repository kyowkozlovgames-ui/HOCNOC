# ⚡ INÍCIO RÁPIDO - HNk TTF Hub Modular

## 🎯 Como Executar

### Via Loadstring (Mais fácil)
```lua
loadstring(game:HttpGet("https://seu-url/HNkTTF_Hub/main.lua"))()
```

### Local (Se tiver acesso ao arquivo)
```lua
local scriptFolder = script.Parent -- caminho para HNkTTF_Hub
loadstring(game:GetService("HttpService"):GetAsync(scriptFolder.main.Source))()
```

---

## 📋 Estrutura Rápida

| Pasta | Função |
|-------|--------|
| `config/` | Temas, configurações, dados |
| `utils/` | Helpers, formatação |
| `services/` | Remotes, serviços |
| `gui/` | Interface gráfica |
| `features/` | Treino, ESP, velocidade, etc |

---

## 🎮 Features Disponíveis

### Shadow Core
- ⚔️ Dark Training (automático)
- ⏳ Anti-AFK (anti dormir)
- 💀 Anti-Fall (não cair/morrer)

### Visuals
- 👁️ Shadow ESP (ver inimigos)
- 📊 Performance Overlay (FPS/PING)
- 🖱️ FOV Mouse Control (scroll)
- 🔲 Minimal Mode (GUI pequena)
- 🔭 FOV Slider (70-120)

### Player
- 🛡️ Health Max (imortal)
- 🏃 Speed Hack
- ⬆️ Jump Hack

### Themes
- 🎨 6 temas pré-definidos
- ➕ Criar temas customizados
- 💾 Salva tema automaticamente

---

## 🔧 Quick Tips

1. **Ativar/desativar features**: Clique nos toggles
2. **Ajustar FOV**: Use o slider ou scroll do mouse (ativado)
3. **Trocar tema**: Vá na aba "Themas" e escolha
4. **Criar tema**: Clique "➕ Create Custom Theme"
5. **Minimizar GUI**: Clique no botão "—"
6. **Fechar GUI**: Clique no botão "X"

---

## 📁 Arquivos Principais

- **main.lua** ← Execute este
- **README_MODULAR.md** - Documentação completa
- **DEVELOPMENT_GUIDE.md** - Como adicionar features

---

## ⚙️ Arquitetura

```
main.lua
  ├─→ Carrega todos os módulos
  ├─→ Inicializa features
  ├─→ Constrói GUI
  └─→ Conecta eventos
```

Cada módulo é **independente** e pode ser:
- ✅ Testado separadamente
- ✅ Modificado sem afetar outros
- ✅ Reutilizado em outros projetos
- ✅ Facilmente expandido

---

## 🚀 Próximos Passos

1. Leia `README_MODULAR.md` para documentação completa
2. Explore `DEVELOPMENT_GUIDE.md` para adicionar features
3. Modifique `modules/config/modulesData.lua` para customizar
4. Crie novos módulos em `modules/features/` conforme necessário

---

## 🐛 Se houver problemas

```
❌ Script não carrega
→ Verifique console do Roblox (F9)
→ Confirme que os remotes existem no jogo

❌ GUI não aparece
→ Procure por "Shadowcore" no console
→ Verifique se CoreGui não está bloqueado

❌ Feature não funciona
→ Procure entrada [HNk FeatureName]:
→ Verifique se toggle está ativado
```

---

## 📊 100% Funcional

✅ Todas as features originais preservadas
✅ Arquivo de config persiste
✅ Temas funcionam perfeitamente  
✅ GUI responsiva e rápida
✅ Pronto para expansão

---

**Bom uso! Qualquer dúvida, veja os arquivos .md no root** 🎉

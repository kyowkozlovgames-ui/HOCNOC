# 🚀 GUIA DE USO - HNk TTF Hub v9.4.3

## ⚡ Uso Rápido (Xeno, Synapse, etc)

### Para qualquer executor com loadstring:

```lua
loadstring(game:HttpGet("https://seu-host/HNkTTF_Hub/loader.lua"))()
```

**Pronto!** O hub carregará completo e funcional.

---

## 📋 Opções de Deploy

### Opção 1: Arquivo Único (RECOMENDADO PARA XENO)
**Arquivo:** `loader.lua`
- ✅ Funciona com qualquer executor (Xeno, Synapse, etc)
- ✅ Sem dependências externas
- ✅ Carrega instantaneamente
- ✅ Código modular internamente mantido

```lua
loadstring(game:HttpGet("https://seu-host/HNkTTF_Hub/loader.lua"))()
```

---

### Opção 2: Estrutura Modular (Para RBXStudio/Dev)
**Pasta:** `HNkTTF_Hub/modules/`
- ✅ Código bem organizado
- ✅ Fácil manutenção
- ✅ Ideal para desenvolvimento
- ✅ Função: `require()` do Lua

```lua
-- Dentro do Roblox Studio:
local main = require(game.ServerScriptService.HNkTTF_Hub.main)
```

---

### Opção 3: Documentação Completa
**Arquivo:** `README_MODULAR.md`
- Documentação completa da arquitetura
- Guia para adicionar novas features
- Estrutura de folders explicada

---

## 🎯 Para Xeno Especificamente

1. **Copie o conteúdo de `loader.lua`**
2. **Cole no console do Xeno**
3. **Pronto!**

Não requer nenhuma configuração especial. O arquivo `loader.lua` foi criado especificamente para funcionar com executores que usam `loadstring`.

---

## 🛠️ Personalização

### Tema Padrão
Abra `loader.lua` e altere esta linha:

```lua
CurrentTheme = "Shadowcore"  -- Altere para: CyberSynth, Solar Flare, etc
```

### Desabilitar Features por Padrão
```lua
ESP = false,          -- Desativar ESP
Speed = false,        -- Desativar Speed
Train = false,        -- Desativar Training
-- etc
```

---

## 📊 Comparação de Arquivos

| Arquivo | Para | Tamanho | Compatibilidade |
|---------|------|---------|-----------------|
| `loader.lua` | Xeno, Synapse, etc | ~35KB | ✅ 100% |
| `main.lua` + `modules/` | Studio, Dev | ~50KB total | ✅ Via `require()` |
| `README_MODULAR.md` | Documentação | ~10KB | 📖 Referência |

---

## ✨ Features Ativas

- ✅ Training Automático
- ✅ Shadow ESP
- ✅ Anti-Fall (Proteção contra quedas)
- ✅ God Mode
- ✅ Speed Hack
- ✅ Jump Hack  
- ✅ FOV Customizável (mouse scroll)
- ✅ Anti-AFK
- ✅ Performance Overlay (FPS/PING)
- ✅ 6+ Temas Customizáveis
- ✅ Minimal Mode
- ✅ Persistência de Config

---

## 🐛 Solução de Problemas

### "Comando não encontrado"
→ Verifique se está usando um executor que suporta `loadstring`

### GUI não aparece
→ Aguarde 3 segundos para carregar
→ Verifique console para erros

### Features não funcionam
→ Aguarde remotes carregarem (até 15 segundos)
→ Verifique se no jogo certo

### Erro ao carregar
→ Use `loader.lua` (arquivo único)
→ Não use `main.lua` diretamente com loadstring

---

## 📝 Changelog v9.4.3

- ✅ Refatorado para Modular Programming
- ✅ Corrigido erro de `WaitForChild` em loadstring
- ✅ Criado `loader.lua` para compatibilidade com Xeno
- ✅ Mantida 100% das funcionalidades
- ✅ Melhorada organização do código
- ✅ Adicionada documentação completa

---

## 🔗 Links Úteis

- **Main File:** `loader.lua` (use este!)
- **Documentação:** `README_MODULAR.md`
- **Módulos:** Pasta `modules/` (para devs)

---

**Desenvolvido com ❤️ para a comunidade**

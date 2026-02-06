#!/bin/bash
# Script para sincronizar automaticamente com GitHub

cd /workspaces/HOCNOC

echo "🔄 Sincronizando com GitHub..."

# Adicionar todas as mudanças
git add -A

# Verificar se há mudanças
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ Nenhuma mudança para sincronizar"
    exit 0
fi

# Criar commit
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
git commit -m "Auto-sync: Changes at $TIMESTAMP"

# Fazer push
if git push origin main; then
    echo "✅ Sincronizado com sucesso no GitHub!"
else
    echo "❌ Erro ao sincronizar"
    exit 1
fi

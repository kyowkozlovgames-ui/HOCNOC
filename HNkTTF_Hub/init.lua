-- ===================================
-- INIT SCRIPT
-- Execute este arquivo para carregar o HUB
-- ===================================

-- Este arquivo deve estar em ServerScriptService ou ser executado via loadstring
-- da seguinte forma:

-- loadstring(game:HttpGet("URL_DO_ARQUIVO_main.lua"))()

-- OU, se preferir usar estrutura local:

local root = script.Parent -- ou outro caminho para a pasta HNkTTF_Hub

-- Carrega o main.lua
loadstring(game:GetService("HttpService"):GetAsync(root.main.Source))()

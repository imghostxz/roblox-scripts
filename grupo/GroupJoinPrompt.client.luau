-- GroupJoinPrompt (LocalScript)
-- Onde colocar: StarterPlayer > StarterPlayerScripts
--
-- Alguns segundos depois de entrar no mapa, abre a janela do Roblox
-- pedindo para o jogador entrar no seu grupo. Quem já é membro não recebe o pedido.

local Players = game:GetService("Players")
local GroupService = game:GetService("GroupService")

local GROUP_ID = 0 -- troque pelo ID do seu grupo (o número que aparece no link do grupo)
local WAIT_SECONDS = 8 -- tempo para o jogador carregar antes do pedido

if GROUP_ID == 0 then
	warn("[GroupJoinPrompt] Coloque o ID do seu grupo em GROUP_ID")
	return
end

local player = Players.LocalPlayer
task.wait(WAIT_SECONDS)

-- Não incomoda quem já está no grupo
local ok, isMember = pcall(player.IsInGroup, player, GROUP_ID)
if ok and isMember then
	return
end

local success, result = pcall(GroupService.PromptJoinAsync, GroupService, GROUP_ID)
if not success then
	warn("[GroupJoinPrompt] Não foi possível abrir o convite:", result)
end

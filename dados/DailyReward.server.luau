-- DailyReward (Script)
-- Onde colocar: ServerScriptService (precisa do PlayerData)
--
-- Dá moedas uma vez a cada 24 horas quando o jogador entra.
-- Usa os.time() (relógio do servidor), então não dá para burlar mudando a hora do PC.

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerData = require(ServerScriptService:WaitForChild("PlayerData"))

local REWARD = 100
local COOLDOWN = 24 * 60 * 60 -- 24 horas em segundos

local function check(player)
	local data = PlayerData.waitFor(player)
	if not data then
		return
	end

	local now = os.time()
	if now - data.LastDaily < COOLDOWN then
		return -- ainda não passou um dia
	end

	PlayerData.set(player, "LastDaily", now)
	PlayerData.increment(player, "Coins", REWARD)
	-- Dica: dispare um RemoteEvent aqui para mostrar uma mensagem na tela
	print(`[DailyReward] {player.Name} recebeu {REWARD} moedas`)
end

Players.PlayerAdded:Connect(check)
for _, player in Players:GetPlayers() do
	task.spawn(check, player)
end

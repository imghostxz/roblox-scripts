-- Leaderstats (Script)
-- Onde colocar: ServerScriptService (precisa do PlayerData lá também)
--
-- Mostra os valores do PlayerData na lista de jogadores (canto da tela)
-- e atualiza sozinho quando eles mudam.

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerData = require(ServerScriptService:WaitForChild("PlayerData"))

local SHOW = { "Coins", "Level" } -- nomes que aparecem na lista

local function setup(player)
	local data = PlayerData.waitFor(player)
	if not data then
		return
	end

	local folder = Instance.new("Folder")
	folder.Name = "leaderstats" -- tem que ser exatamente esse nome
	for _, key in SHOW do
		local value = Instance.new("IntValue")
		value.Name = key
		value.Value = data[key] or 0
		value.Parent = folder
	end
	folder.Parent = player
end

PlayerData.Changed:Connect(function(player, key, value)
	local folder = player:FindFirstChild("leaderstats")
	local stat = folder and folder:FindFirstChild(key)
	if stat then
		stat.Value = value
	end
end)

Players.PlayerAdded:Connect(setup)
for _, player in Players:GetPlayers() do
	task.spawn(setup, player)
end

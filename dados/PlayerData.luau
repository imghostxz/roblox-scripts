-- PlayerData (ModuleScript)
-- Onde colocar: ServerScriptService
--
-- Carrega e salva os dados de cada jogador com DataStore, do jeito seguro:
--   • tenta de novo quando o Roblox falha (pcall + novas tentativas)
--   • nunca salva por cima com dados vazios se o carregamento falhou
--   • salva ao sair, a cada 2 minutos e quando o servidor fecha
--
-- Como usar em outro script do servidor:
--   local PlayerData = require(game.ServerScriptService.PlayerData)
--   local data = PlayerData.waitFor(player)      -- espera carregar
--   PlayerData.increment(player, "Coins", 50)    -- soma e avisa quem estiver ouvindo

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local STORE_NAME = "PlayerData_v1" -- mude o _v1 só se quiser começar do zero
local AUTOSAVE_SECONDS = 120
local MAX_TRIES = 5

-- Tudo que um jogador novo recebe. Campos novos aparecem sozinhos para quem já tinha save.
local TEMPLATE = {
	Coins = 0,
	Level = 1,
	LastDaily = 0,
	Inventory = {},
	Purchases = {}, -- usado pelo DevProducts para não entregar a mesma compra duas vezes
}

local store = DataStoreService:GetDataStore(STORE_NAME)
local profiles = {} -- [Player] = tabela de dados
local changed = Instance.new("BindableEvent")

local PlayerData = {}
PlayerData.Changed = changed.Event -- (player, chave, valor)

local function copy(value)
	if type(value) ~= "table" then
		return value
	end
	local result = {}
	for key, item in value do
		result[key] = copy(item)
	end
	return result
end

local function fillMissing(data)
	for key, value in TEMPLATE do
		if data[key] == nil then
			data[key] = copy(value)
		end
	end
	return data
end

-- Repete a chamada se o Roblox falhar, esperando um pouco mais a cada vez
local function try(callback)
	for attempt = 1, MAX_TRIES do
		local ok, result = pcall(callback)
		if ok then
			return true, result
		end
		warn(`[PlayerData] tentativa {attempt} falhou: {result}`)
		task.wait(attempt * 2)
	end
	return false, nil
end

local function keyOf(player)
	return "Player_" .. player.UserId
end

local function load(player)
	local ok, data = try(function()
		return store:GetAsync(keyOf(player))
	end)

	if not player:IsDescendantOf(Players) then
		return -- saiu enquanto carregava
	end

	if not ok then
		-- Se a pessoa jogasse com dados vazios, ao sair eles apagariam o save verdadeiro.
		player:Kick("Não foi possível carregar seus dados. Entre novamente.")
		return
	end

	profiles[player] = fillMissing(data or {})
end

local function save(player)
	local data = profiles[player]
	if not data then
		return false -- só salva quem carregou certo
	end
	local ok = try(function()
		store:UpdateAsync(keyOf(player), function()
			return data
		end)
	end)
	return ok
end

-- ===== Funções para os outros scripts =====

function PlayerData.get(player)
	return profiles[player]
end

function PlayerData.waitFor(player)
	while player:IsDescendantOf(Players) and profiles[player] == nil do
		task.wait(0.1)
	end
	return profiles[player]
end

function PlayerData.set(player, key, value)
	local data = profiles[player]
	if not data then
		return
	end
	data[key] = value
	changed:Fire(player, key, value)
end

function PlayerData.increment(player, key, amount)
	local data = profiles[player]
	if not data then
		return nil
	end
	local value = (data[key] or 0) + amount
	PlayerData.set(player, key, value)
	return value
end

-- Salva agora (use depois de algo importante, como uma compra)
function PlayerData.saveNow(player)
	return save(player)
end

-- ===== Eventos =====

Players.PlayerAdded:Connect(load)
for _, player in Players:GetPlayers() do
	task.spawn(load, player)
end

Players.PlayerRemoving:Connect(function(player)
	save(player)
	profiles[player] = nil
end)

-- O servidor espera os saves terminarem antes de fechar
game:BindToClose(function()
	local remaining = 0
	for player in profiles do
		remaining += 1
		task.spawn(function()
			save(player)
			remaining -= 1
		end)
	end
	while remaining > 0 do
		task.wait()
	end
end)

task.spawn(function()
	while true do
		task.wait(AUTOSAVE_SECONDS)
		for player in profiles do
			task.spawn(save, player)
		end
	end
end)

return PlayerData

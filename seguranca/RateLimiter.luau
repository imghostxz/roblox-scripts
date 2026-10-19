-- RateLimiter (ModuleScript)
-- Onde colocar: ServerScriptService
--
-- Protege RemoteEvents contra spam (exploiters disparando o evento milhares de vezes).
--
-- Exemplo:
--   local RateLimiter = require(game.ServerScriptService.RateLimiter)
--   local limiter = RateLimiter.new(5, 1) -- no máximo 5 vezes por segundo
--
--   remote.OnServerEvent:Connect(function(player, ...)
--       if not limiter:allow(player) then
--           return -- ignorado: rápido demais
--       end
--       -- seu código aqui
--   end)
--
-- Lembre: o servidor nunca deve confiar no que o cliente manda (preço, dano, quantidade).

local Players = game:GetService("Players")

local RateLimiter = {}
RateLimiter.__index = RateLimiter

function RateLimiter.new(maxCalls, perSeconds)
	local self = setmetatable({
		max = maxCalls,
		window = perSeconds,
		calls = {}, -- [Player] = lista de horários
	}, RateLimiter)

	-- Limpa a memória quando o jogador sai
	Players.PlayerRemoving:Connect(function(player)
		self.calls[player] = nil
	end)

	return self
end

-- true = pode continuar | false = está mandando rápido demais
function RateLimiter:allow(player)
	local now = os.clock()
	local list = self.calls[player]
	if not list then
		list = {}
		self.calls[player] = list
	end

	-- Remove os registros que já saíram da janela de tempo
	while list[1] and now - list[1] > self.window do
		table.remove(list, 1)
	end

	if #list >= self.max then
		return false
	end
	table.insert(list, now)
	return true
end

return RateLimiter

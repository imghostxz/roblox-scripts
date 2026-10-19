-- DevProducts (Script)
-- Onde colocar: ServerScriptService (precisa do PlayerData)
--
-- Entrega Developer Products (itens que dá para comprar várias vezes, como moedas).
-- O jeito certo:
--   • cada compra tem um PurchaseId; guardamos ele nos dados do jogador
--   • se o Roblox mandar a mesma compra de novo, ela não é entregue duas vezes
--   • só respondemos "PurchaseGranted" depois que os dados foram salvos
-- Só pode existir UM ProcessReceipt no jogo inteiro. Coloque todos os produtos aqui.

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerData = require(ServerScriptService:WaitForChild("PlayerData"))

local KEEP_LAST = 50 -- quantas compras recentes ficam guardadas por jogador

-- [ID do produto] = função que entrega. Troque os IDs pelos seus.
local PRODUCTS = {
	[0000001] = function(player)
		PlayerData.increment(player, "Coins", 100)
	end,
	[0000002] = function(player)
		PlayerData.increment(player, "Coins", 500)
	end,
}

MarketplaceService.ProcessReceipt = function(receipt)
	local player = Players:GetPlayerByUserId(receipt.PlayerId)
	local data = player and PlayerData.get(player)
	local give = PRODUCTS[receipt.ProductId]

	-- Jogador saiu ou dados não carregaram: o Roblox tenta de novo depois
	if not data or not give then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Mesma compra chegando de novo: já foi entregue
	if table.find(data.Purchases, receipt.PurchaseId) then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	local ok, err = pcall(give, player)
	if not ok then
		warn("[DevProducts] erro ao entregar:", err)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	table.insert(data.Purchases, receipt.PurchaseId)
	if #data.Purchases > KEEP_LAST then
		table.remove(data.Purchases, 1)
	end

	-- Só confirma para o Roblox depois de salvar
	if PlayerData.saveNow(player) then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

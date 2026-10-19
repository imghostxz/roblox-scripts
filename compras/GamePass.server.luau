-- GamePass (Script)
-- Onde colocar: ServerScriptService
--
-- Dá o benefício do GamePass para quem já tem e para quem compra durante a partida.
-- Exemplo de benefício: atributo "VIP" e mais velocidade.
-- Para abrir a compra a partir de um botão (LocalScript):
--   game:GetService("MarketplaceService"):PromptGamePassPurchase(game.Players.LocalPlayer, PASS_ID)

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local PASS_ID = 0 -- troque pelo ID do seu GamePass
local VIP_SPEED = 24

local function owns(player)
	local ok, result = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, PASS_ID)
	return ok and result
end

local function giveBenefit(player)
	if player:GetAttribute("VIP") then
		return -- já recebeu
	end
	player:SetAttribute("VIP", true)

	local function onCharacter(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = VIP_SPEED
	end

	if player.Character then
		onCharacter(player.Character)
	end
	player.CharacterAdded:Connect(onCharacter)
end

Players.PlayerAdded:Connect(function(player)
	if owns(player) then
		giveBenefit(player)
	end
end)

-- Comprou agora, dentro do jogo
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
	if purchased and passId == PASS_ID then
		giveBenefit(player)
	end
end)

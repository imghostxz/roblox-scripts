-- GroupReward (Script)
-- Onde colocar: ServerScriptService
--
-- Dá um bônus para quem é membro do grupo: aqui, mais velocidade e o atributo "GroupMember"
-- (que você pode usar em outros scripts, por exemplo para uma tag no chat).
-- Observação: o Roblox guarda a resposta do grupo durante a partida, então quem entrar
-- no grupo agora recebe o bônus na próxima vez que entrar no mapa.

local Players = game:GetService("Players")

local GROUP_ID = 0 -- troque pelo ID do seu grupo
local MIN_RANK = 1 -- 1 = membro comum; aumente para dar só a cargos maiores
local BONUS_SPEED = 20 -- velocidade normal do Roblox é 16

local function giveBonus(player)
	player:SetAttribute("GroupMember", true)

	local function onCharacter(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = BONUS_SPEED
	end

	if player.Character then
		onCharacter(player.Character)
	end
	player.CharacterAdded:Connect(onCharacter)
end

local function check(player)
	if GROUP_ID == 0 then
		return
	end
	local ok, rank = pcall(player.GetRankInGroup, player, GROUP_ID)
	if ok and rank >= MIN_RANK then
		giveBonus(player)
	end
end

Players.PlayerAdded:Connect(check)
for _, player in Players:GetPlayers() do
	task.spawn(check, player)
end

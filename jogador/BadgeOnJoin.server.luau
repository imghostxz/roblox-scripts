-- BadgeOnJoin (Script)
-- Onde colocar: ServerScriptService
--
-- Dá uma insígnia (badge) de "bem-vindo" na primeira vez que a pessoa entra.
-- A badge precisa estar criada e ativada na página do seu jogo.

local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")

local BADGE_ID = 0 -- troque pelo ID da sua badge

local function award(player)
	if BADGE_ID == 0 then
		return
	end

	local ok, hasBadge = pcall(BadgeService.UserHasBadgeAsync, BadgeService, player.UserId, BADGE_ID)
	if not ok then
		warn("[BadgeOnJoin] não deu para verificar a badge:", hasBadge)
		return
	end
	if hasBadge then
		return
	end

	local awarded, err = pcall(BadgeService.AwardBadge, BadgeService, player.UserId, BADGE_ID)
	if not awarded then
		warn("[BadgeOnJoin] não deu para entregar a badge:", err)
	end
end

Players.PlayerAdded:Connect(award)
for _, player in Players:GetPlayers() do
	task.spawn(award, player)
end

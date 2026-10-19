-- Sprint (LocalScript)
-- Onde colocar: StarterPlayer > StarterPlayerScripts
--
-- Segure Shift (ou L3 no controle) para correr. No celular aparece um botão "Correr" sozinho.

local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")

local WALK_SPEED = 16
local RUN_SPEED = 26

local player = Players.LocalPlayer

local function onSprint(_, state)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return Enum.ContextActionResult.Pass
	end

	if state == Enum.UserInputState.Begin then
		humanoid.WalkSpeed = RUN_SPEED
	elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
		humanoid.WalkSpeed = WALK_SPEED
	end
	return Enum.ContextActionResult.Sink
end

-- true = cria o botão no celular
ContextActionService:BindAction("Sprint", onSprint, true, Enum.KeyCode.LeftShift, Enum.KeyCode.ButtonL3)
ContextActionService:SetTitle("Sprint", "Correr")
ContextActionService:SetPosition("Sprint", UDim2.new(1, -170, 1, -170))

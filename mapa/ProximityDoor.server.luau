-- ProximityDoor (Script)
-- Onde colocar: dentro da Part da porta
--
-- Aperte E perto da porta para abrir e fechar. Ela gira pela lateral (como uma porta de verdade)
-- e fecha sozinha depois de alguns segundos.

local TweenService = game:GetService("TweenService")

local door = script.Parent
local OPEN_ANGLE = 90 -- graus (use -90 para abrir para o outro lado)
local TIME = 0.5
local AUTO_CLOSE = 4 -- segundos; 0 = não fecha sozinha

door.Anchored = true

local prompt = door:FindFirstChildOfClass("ProximityPrompt") or Instance.new("ProximityPrompt")
prompt.ObjectText = "Porta"
prompt.ActionText = "Abrir"
prompt.Parent = door

-- Calcula a posição aberta girando em volta da borda esquerda da porta
local closedCFrame = door.CFrame
local hinge = closedCFrame * CFrame.new(-door.Size.X / 2, 0, 0)
local openCFrame = hinge * CFrame.Angles(0, math.rad(OPEN_ANGLE), 0) * CFrame.new(door.Size.X / 2, 0, 0)

local info = TweenInfo.new(TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local isOpen = false
local busy = false

local function setOpen(open)
	busy = true
	isOpen = open
	prompt.ActionText = if open then "Fechar" else "Abrir"
	local tween = TweenService:Create(door, info, { CFrame = if open then openCFrame else closedCFrame })
	tween:Play()
	tween.Completed:Wait()
	busy = false
end

prompt.Triggered:Connect(function()
	if busy then
		return
	end
	setOpen(not isOpen)

	if isOpen and AUTO_CLOSE > 0 then
		task.delay(AUTO_CLOSE, function()
			if isOpen and not busy then
				setOpen(false)
			end
		end)
	end
end)

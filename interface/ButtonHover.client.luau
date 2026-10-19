-- ButtonHover (LocalScript)
-- Onde colocar: dentro de um TextButton ou ImageButton
--
-- Faz o botão crescer um pouco quando o mouse passa e "afundar" quando clica.
-- Usa UIScale, então não bagunça o tamanho nem a posição que você definiu.

local TweenService = game:GetService("TweenService")

local button = script.Parent
local HOVER = 1.06
local PRESS = 0.94

local scale = button:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
scale.Parent = button

local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function tweenTo(value)
	TweenService:Create(scale, info, { Scale = value }):Play()
end

button.MouseEnter:Connect(function()
	tweenTo(HOVER)
end)
button.MouseLeave:Connect(function()
	tweenTo(1)
end)
button.MouseButton1Down:Connect(function()
	tweenTo(PRESS)
end)
button.MouseButton1Up:Connect(function()
	tweenTo(HOVER)
end)

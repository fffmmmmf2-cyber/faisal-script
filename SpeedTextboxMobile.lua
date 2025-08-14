-- سكربت بسيط لتغيير السرعة للجوال
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- إنشاء واجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local TextBox = Instance.new("TextBox")
TextBox.Parent = ScreenGui
TextBox.Size = UDim2.new(0, 250, 0, 70)
TextBox.Position = UDim2.new(0.5, -125, 0.8, -35)
TextBox.PlaceholderText = "اكتب السرعة (1 - 100)"
TextBox.Text = ""
TextBox.TextScaled = true
TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = TextBox

-- تغيير السرعة عند الكتابة
TextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local speed = tonumber(TextBox.Text)
		if speed and speed >= 1 and speed <= 100 then
			humanoid.WalkSpeed = speed
		else
			TextBox.Text = "❌ رقم غير صحيح"
		end
	end
end)

-- تحديث المرجع إذا تولد اللاعب من جديد
player.CharacterAdded:Connect(function(newChar)
	humanoid = newChar:WaitForChild("Humanoid")
end)

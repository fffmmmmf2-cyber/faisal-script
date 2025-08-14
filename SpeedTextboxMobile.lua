-- سكربت تغيير السرعة للجوال
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- إنشاء واجهة
local ScreenGui = Instance.new("ScreenGui")
local TextBox = Instance.new("TextBox")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- إعدادات الـ TextBox
TextBox.Parent = ScreenGui
TextBox.Size = UDim2.new(0, 250, 0, 70)
TextBox.Position = UDim2.new(0.5, -125, 0.8, -35) -- أسفل الشاشة
TextBox.PlaceholderText = "اكتب السرعة (1 - 100)"
TextBox.Text = ""
TextBox.TextScaled = true
TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = TextBox

-- تغيير السرعة عند الكتابة
TextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local speed = tonumber(TextBox.Text)
		if speed and speed >= 1 and speed <= 100 then
			char:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
		else
			TextBox.Text = "❌ رقم غير صحيح"
		end
	end
end)

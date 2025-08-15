local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- ضبط الدم الابتدائي
humanoid.Health = 5000
humanoid.MaxHealth = 5000

-- إنشاء نص فوق الشاشة لعرض الدم
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local HealthLabel = Instance.new("TextLabel")
HealthLabel.Parent = ScreenGui
HealthLabel.Size = UDim2.new(0, 300, 0, 50)
HealthLabel.Position = UDim2.new(0.5, -150, 0.1, 0)
HealthLabel.TextScaled = true
HealthLabel.BackgroundTransparency = 1
HealthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
HealthLabel.Text = "دمك = "..humanoid.Health

-- زيادة الدم كل 3 ثواني
while true do
    wait(3)
    if humanoid and humanoid.Parent then
        humanoid.Health = humanoid.Health + 200
        if humanoid.Health > 5000 then
            humanoid.Health = 5000 -- الحد الأقصى
        end
        HealthLabel.Text = "دمك = "..math.floor(humanoid.Health)
    end
end

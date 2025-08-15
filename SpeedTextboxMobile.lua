local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- ضبط الصحة الأولية
humanoid.MaxHealth = 5000
humanoid.Health = 5000

-- زيادة الصحة كل ثانية بمقدار 100
task.spawn(function()
    while task.wait(1) do
        humanoid.Health = math.min(humanoid.Health + 100, humanoid.MaxHealth)
    end
end)

-- إشعار النظام
game.StarterGui:SetCore("SendNotification", {
    Title = "✅",
    Text = "صحتك الان 5000 وتزيد كل ثانيه +100",
    Duration = 5
})

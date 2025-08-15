local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- ضبط الصحة الابتدائية
humanoid.Health = 100

-- اشعار النظام بإيموجي ✅ فقط
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅";
    Text = "";
    Duration = 3,
})

-- زيادة الدم كل 0.01 ثانية بمقدار 100
task.spawn(function()
    while task.wait(0.01) do
        humanoid.Health = humanoid.Health + 100
        -- لضمان عدم تجاوز الحد الأعلى الافتراضي
        if humanoid.Health > humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end
end)

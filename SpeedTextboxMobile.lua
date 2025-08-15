local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- ضبط الصحة الأولية
humanoid.MaxHealth = 5000
humanoid.Health = 5000

-- منع نقصان الدم نهائيًا + زيادة 100 كل نص ثانية
task.spawn(function()
    while task.wait(0.5) do
        humanoid.Health = math.max(humanoid.Health, 5000)
    end
end)

-- إشعار النظام
game.StarterGui:SetCore("SendNotification", {
    Title = "✅ السكربت اشتغل",
    Text = "صحتك ثابتة 5000 ولا تنقص",
    Duration = 5
})

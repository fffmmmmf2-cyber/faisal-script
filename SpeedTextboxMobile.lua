local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- رسالة تفعيل
game.StarterGui:SetCore("SendNotification", {
    Title = "God Mode",
    Text = "✅ مفعل",
    Duration = 2
})

-- تحديث الصحة كل 0.01 ثانية بدون تجاوز 101
spawn(function()
    while true do
        if humanoid and humanoid.Parent then
            humanoid.Health = math.min(humanoid.Health + 100, 101)
        end
        wait(0.01)
    end
end)

-- إعادة تعيين المرجع عند تولد الشخصية
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
end)

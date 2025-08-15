local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- رسالة عند تشغيل السكربت
game.StarterGui:SetCore("SendNotification", {
    Title = "Script Active",
    Text = "السكربت اشتغل",
    Duration = 3
})

-- منع نقص الدم
spawn(function()
    while true do
        if humanoid and humanoid.Health > 0 then
            humanoid.Health = 100
        end
        wait(0.01)
    end
end)

-- تحديث إذا الشخصية ماتت أو أعيدت
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = char:WaitForChild("Humanoid")
end)

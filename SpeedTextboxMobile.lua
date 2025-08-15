-- Server Script
local Players = game:GetService("Players")

local function enableGodMode(player)
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end

    -- GUI للاعب
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HealthDisplay"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(0, 300, 0, 50)
    healthLabel.Position = UDim2.new(0.5, -150, 0.05, 0)
    healthLabel.TextScaled = true
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    healthLabel.Parent = screenGui

    -- تحديث الدم كل 0.01 ثانية
    spawn(function()
        while humanoid.Parent do
            local currentHealth = humanoid.Health

            -- الحد الأقصى للدم 101
            if currentHealth < 101 then
                humanoid.Health = 101
                currentHealth = 101
            end

            -- تحديث النص
            healthLabel.Text = "دمك = "..math.floor(currentHealth)

            -- رسالة نظام عند انخفاض الدم إلى 50 أو أقل
            if currentHealth <= 50 then
                player:SendNotification({
                    Title = "تنبيه",
                    Text = "انتبه دمك 50!",
                    Duration = 2
                })
            end

            wait(0.01)
        end
    end)
end

-- تفعيل لكل اللاعبين الحاليين والجدد
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        enableGodMode(player)
    end)
end)

for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        enableGodMode(player)
    end
end

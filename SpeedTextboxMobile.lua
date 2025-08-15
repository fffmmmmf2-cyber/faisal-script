-- LocalScript: جعل كل لاعب جسمه مربع أحمر فاتح مع اسمه

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

-- لون المربع
local enemyColor = Color3.fromRGB(255,100,100)

-- دالة لتغيير شكل اللاعب
local function makeEnemy(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local char = player.Character

    -- إزالة أي أجزاء سابقة
    if char:FindFirstChild("EnemyOverlay") then
        char.EnemyOverlay:Destroy()
    end

    -- إنشاء نموذج يغطي جسم اللاعب
    local overlay = Instance.new("Model")
    overlay.Name = "EnemyOverlay"
    overlay.Parent = char

    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local box = Instance.new("Part")
            box.Size = part.Size
            box.CFrame = part.CFrame
            box.Anchored = true
            box.CanCollide = false
            box.Transparency = 0.3
            box.Color = enemyColor
            box.Parent = overlay

            -- تحديث موقع البارت مع اللاعب
            RunService.RenderStepped:Connect(function()
                if part and box then
                    box.CFrame = part.CFrame
                end
            end)
        end
    end

    -- إضافة اسم فوق اللاعب
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = char:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0,100,0,50)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.fromRGB(255,0,0)
    label.TextScaled = true
    label.Parent = billboard
end

-- تطبيق لكل اللاعبين عند دخول اللعبة
for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        makeEnemy(player)
    end
end

-- عند دخول لاعب جديد
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if player ~= Players.LocalPlayer then
            makeEnemy(player)
        end
    end)
end)

-- تحديث اللاعبين الحاليين عند تغير شخصيتهم
for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        player.CharacterAdded:Connect(function()
            makeEnemy(player)
        end)
    end
end

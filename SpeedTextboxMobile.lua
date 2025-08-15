-- LocalScript: جسم أحمر Neon + اسم + شريط دم لكل اللاعبين

local Players = game:GetService("Players")

local function createHealthGui(player, humanoid)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not humanoid then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0,150,0,40)
    billboard.StudsOffset = Vector3.new(0,4,0)
    billboard.AlwaysOnTop = true
    billboard.Name = "EnemyBillboard"
    billboard.Parent = player.Character

    -- اسم اللاعب
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0.5,0)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255,0,0)
    nameLabel.TextScaled = true
    nameLabel.Parent = billboard

    -- شريط الدم
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1,0,0.3,0)
    healthBar.Position = UDim2.new(0,0,0.6,0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthBar.BorderSizePixel = 1
    healthBar.Parent = billboard

    -- تحديث الدم باستمرار
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        healthBar.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,0.3,0)
    end)
end

local function applyEnemyEffect(player)
    if player == Players.LocalPlayer then return end -- تجاهل نفسك

    local function onCharacter(char)
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        -- إزالة أي Highlight سابق
        if char:FindFirstChild("EnemyHighlight") then
            char.EnemyHighlight:Destroy()
        end
        if char:FindFirstChild("EnemyBillboard") then
            char.EnemyBillboard:Destroy()
        end

        -- Highlight أحمر Neon
        local highlight = Instance.new("Highlight")
        highlight.Name = "EnemyHighlight"
        highlight.Adornee = char
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- يظهر من خلف الجدران
        highlight.FillColor = Color3.fromRGB(255,0,0) -- أحمر فاقع
        highlight.FillTransparency = 0
        highlight.OutlineTransparency = 0.7
        highlight.Parent = char

        -- إنشاء اسم وشريط الدم
        createHealthGui(player, humanoid)
    end

    if player.Character then
        onCharacter(player.Character)
    end
    player.CharacterAdded:Connect(onCharacter)
end

-- تطبيق على اللاعبين الحاليين
for _, player in pairs(Players:GetPlayers()) do
    applyEnemyEffect(player)
end

-- تطبيق على أي لاعب يدخل لاحقًا
Players.PlayerAdded:Connect(applyEnemyEffect)

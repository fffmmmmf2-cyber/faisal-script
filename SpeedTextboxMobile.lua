-- LocalScript: GUI Toggle + RedEnemy + NoClip آمن

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- ==========================
-- إنشاء ScreenGui
-- ==========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- ==========================
-- دوال اللون الأحمر على اللاعبين
-- ==========================
local function createHealthGui(playerToApply, humanoid)
    local hrp = playerToApply.Character and playerToApply.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not humanoid then return end

    -- إزالة أي Billboard سابق
    local old = playerToApply.Character:FindFirstChild("EnemyBillboard")
    if old then old:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.StudsOffset = Vector3.new(0,4,0)
    billboard.AlwaysOnTop = true
    billboard.Name = "EnemyBillboard"
    billboard.Parent = playerToApply.Character

    -- اسم اللاعب
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0.5,0)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = playerToApply.Name
    nameLabel.TextColor3 = Color3.fromRGB(255,0,0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Parent = billboard

    -- شريط الدم
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,0.3,0)
    healthBar.Position = UDim2.new(0,0,0.6,0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthBar.BorderSizePixel = 1
    healthBar.Parent = billboard

    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        healthBar.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,0.3,0)
    end)
end

local function applyEnemyEffect(playerToApply)
    if playerToApply == player then return end

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
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Color3.fromRGB(255,0,0)
        highlight.FillTransparency = 0
        highlight.OutlineTransparency = 0.7
        highlight.Parent = char

        -- إنشاء اسم وشريط الدم
        createHealthGui(playerToApply, humanoid)
    end

    if playerToApply.Character then
        onCharacter(playerToApply.Character)
    end
    playerToApply.CharacterAdded:Connect(onCharacter)
end

-- ==========================
-- Toggle variables
-- ==========================
local redEnabled = false
local noclipEnabled = false

-- ==========================
-- دالة إنشاء الزر
-- ==========================
local function createButton(name, positionY, initialColor, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0,200,0,50)
    button.Position = UDim2.new(0.5,-100,0,positionY)
    button.BackgroundColor3 = initialColor
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.TextScaled = true
    button.Text = name
    button.Parent = screenGui

    button.MouseButton1Click:Connect(function()
        callback(button)
    end)
end

-- ==========================
-- الخانة الأولى: اللون الأحمر على اللاعبين
-- ==========================
createButton("تفعيل اللون الأحمر", 100, Color3.fromRGB(255,0,0), function(button)
    redEnabled = not redEnabled
    if redEnabled then
        button.BackgroundColor3 = Color3.fromRGB(0,255,0)
        for _, p in pairs(Players:GetPlayers()) do
            applyEnemyEffect(p)
        end
        Players.PlayerAdded:Connect(function(newPlayer)
            applyEnemyEffect(newPlayer)
        end)
    else
        button.BackgroundColor3 = Color3.fromRGB(255,0,0)
        -- إزالة أي تأثير موجود
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local char = p.Character
                if char:FindFirstChild("EnemyHighlight") then
                    char.EnemyHighlight:Destroy()
                end
                if char:FindFirstChild("EnemyBillboard") then
                    char.EnemyBillboard:Destroy()
                end
            end
        end
    end
end)

-- ==========================
-- الخانة الثانية: NoClip آمن
-- ==========================
createButton("تفعيل NoClip", 160, Color3.fromRGB(255,0,0), function(button)
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        button.BackgroundColor3 = Color3.fromRGB(0,255,0)
    else
        button.BackgroundColor3 = Color3.fromRGB(255,0,0)
    end
end)

-- ==========================
-- NoClip loop
-- ==========================
RunService.RenderStepped:Connect(function()
    if noclipEnabled then
        local char = player.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

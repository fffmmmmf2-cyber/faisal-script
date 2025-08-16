-- خدمات
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- إنشاء واجهة المستخدم
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimuGUI"
screenGui.Parent = Player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.8, 0, 0.3, 0) -- يمين الشاشة
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.BackgroundTransparency = 0.3
frame.Parent = screenGui

-- زر إخفاء/إظهار
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(1, -35, 0, 5)
toggleBtn.Text = "-"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
toggleBtn.Parent = frame

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- الخانة 1: Enemy ESP
local button1 = Instance.new("TextButton")
button1.Size = UDim2.new(0, 180, 0, 40)
button1.Position = UDim2.new(0, 10, 0, 10)
button1.Text = "Enemy ESP"
button1.TextColor3 = Color3.fromRGB(255,255,255)
button1.BackgroundColor3 = Color3.fromRGB(255,0,0)
button1.Parent = frame

-- الخانة 2: فاضية مؤقتاً
local button2 = Instance.new("TextButton")
button2.Size = UDim2.new(0, 180, 0, 40)
button2.Position = UDim2.new(0, 10, 0, 60)
button2.Text = "Coming Soon"
button2.TextColor3 = Color3.fromRGB(255,255,255)
button2.BackgroundColor3 = Color3.fromRGB(0,0,255)
button2.Parent = frame

-- تفعيل سكربت الـ ESP عند الضغط على الخانة 1
local enemyESPScript = [[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function createHealthGui(player, humanoid)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not humanoid then return end
    local old = player.Character:FindFirstChild("EnemyBillboard")
    if old then old:Destroy() end
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0,150,0,40)
    billboard.StudsOffset = Vector3.new(0,4,0)
    billboard.AlwaysOnTop = true
    billboard.Name = "EnemyBillboard"
    billboard.Parent = player.Character

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0.5,0)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255,0,0)
    nameLabel.TextScaled = true
    nameLabel.Parent = billboard

    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1,0,0.3,0)
    healthBar.Position = UDim2.new(0,0,0.6,0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthBar.BorderSizePixel = 1
    healthBar.Parent = billboard

    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        healthBar.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,0.3,0)
    end)
end

local function applyEnemyEffect(player)
    if player == Players.LocalPlayer then return end
    local function onCharacter(char)
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if char:FindFirstChild("EnemyHighlight") then
            char.EnemyHighlight:Destroy()
        end
        local highlight = Instance.new("Highlight")
        highlight.Name = "EnemyHighlight"
        highlight.Adornee = char
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Color3.fromRGB(255,0,0)
        highlight.FillTransparency = 0
        highlight.OutlineTransparency = 0.7
        highlight.Parent = char
        createHealthGui(player, humanoid)
    end
    if player.Character then
        onCharacter(player.Character)
    end
    player.CharacterAdded:Connect(onCharacter)
end

for _, player in pairs(Players:GetPlayers()) do
    applyEnemyEffect(player)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        applyEnemyEffect(player)
    end)
end)

while true do
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            applyEnemyEffect(player)
        end
    end
    wait(5)
end
]]

button1.MouseButton1Click:Connect(function()
    loadstring(enemyESPScript)()
end)

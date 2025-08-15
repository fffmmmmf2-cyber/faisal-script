-- خدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

-- واجهة
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0,400,0,300)
frame.Position = UDim2.new(0,50,0,50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0

-- زر الإخفاء
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1,0,0,30)
toggleBtn.Position = UDim2.new(0,0,0,0)
toggleBtn.Text = "⬆ إخفاء/إظهار"
toggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.TextScaled = true

-- GridLayout 8x2
local gridFrame = Instance.new("Frame", frame)
gridFrame.Size = UDim2.new(1,-10,1,-40)
gridFrame.Position = UDim2.new(0,5,0,35)
gridFrame.BackgroundTransparency = 1

local grid = Instance.new("UIGridLayout", gridFrame)
grid.CellSize = UDim2.new(0,180,0,60)
grid.CellPadding = UDim2.new(0,10,0,10)

-- الحالة لكل ميزة
local states = {
    speed = false,
    jump = false,
    fly = false,
    handSize = false,
    legSize = false
}

-- قائمة الخيارات مع ألوان مختلفة
local options = {
    {Name="⚡ سرعة اللاعب", Color=Color3.fromRGB(0,200,0), Func=function()
        states.speed = not states.speed
        humanoid.WalkSpeed = states.speed and 100 or 16
    end},
    {Name="⬆ قوة القفز", Color=Color3.fromRGB(0,150,255), Func=function()
        states.jump = not states.jump
        humanoid.JumpPower = states.jump and 120 or 50
    end},
    {Name="🕊️ طيران", Color=Color3.fromRGB(255,200,0), Func=function()
        states.fly = not states.fly
        humanoid.PlatformStand = states.fly
    end},
    {Name="⛑️ صحة كاملة", Color=Color3.fromRGB(255,0,0), Func=function()
        humanoid.Health = humanoid.MaxHealth
    end},
    {Name="✖ إلغاء الطيران", Color=Color3.fromRGB(100,100,100), Func=function()
        states.fly = false
        humanoid.PlatformStand = false
    end},
    {Name="🖐 تكبير اليد", Color=Color3.fromRGB(255,0,255), Func=function()
        states.handSize = not states.handSize
        local hand = char:FindFirstChild("RightHand") or char:FindFirstChild("LeftHand")
        if hand then
            hand.Size = states.handSize and Vector3.new(2,2,2) or Vector3.new(1,1,1)
        end
    end},
    {Name="🦵 تكبير الرجل", Color=Color3.fromRGB(0,255,255), Func=function()
        states.legSize = not states.legSize
        local leg = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("LeftLowerLeg")
        if leg then
            leg.Size = states.legSize and Vector3.new(2,2,2) or Vector3.new(1,1,1)
        end
    end},
    {Name="🔄 إعادة ضبط", Color=Color3.fromRGB(255,150,0), Func=function()
        -- إعادة كل الإعدادات
        states.speed = false
        states.jump = false
        states.fly = false
        states.handSize = false
        states.legSize = false
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        humanoid.PlatformStand = false
        local hand = char:FindFirstChild("RightHand") or char:FindFirstChild("LeftHand")
        if hand then hand.Size = Vector3.new(1,1,1) end
        local leg = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("LeftLowerLeg")
        if leg then leg.Size = Vector3.new(1,1,1) end
    end}
}

-- إنشاء الأزرار
for _, option in pairs(options) do
    local btn = Instance.new("TextButton", gridFrame)
    btn.Size = UDim2.new(0,180,0,60)
    btn.Text = option.Name
    btn.BackgroundColor3 = option.Color
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    
    btn.MouseButton1Click:Connect(function()
        option.Func()
    end)
end

-- زر إخفاء/إظهار الواجهة
local hidden = false
toggleBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    local goal = {}
    goal.Size = hidden and UDim2.new(0,0,0,0) or UDim2.new(0,400,0,300)
    TweenService:Create(frame, TweenInfo.new(0.3), goal):Play()
end)

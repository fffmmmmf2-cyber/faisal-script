local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ScreenGui رئيسي
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- زر الإخفاء/الإظهار
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 12, 0, 12)
ToggleButton.Text = ""
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ToggleButton.Active = true
ToggleButton.Draggable = true

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 25)
UICornerBtn.Parent = ToggleButton

-- المربع القابل للسحب
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 180, 0, 320)
MainFrame.Position = UDim2.new(0.5, -90, 0.3, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

-- ScrollFrame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.CanvasSize = UDim2.new(0,0,0,500)
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.BackgroundTransparency = 1

local visible = true
ToggleButton.MouseButton1Click:Connect(function()
    visible = not visible
    MainFrame.Visible = visible
    ToggleButton.BackgroundColor3 = visible and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- 1️⃣ السرعة
local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = ScrollFrame
SpeedBox.Position = UDim2.new(0, 10, 0, 10)
SpeedBox.Size = UDim2.new(0, 160, 0, 40)
SpeedBox.PlaceholderText = "السرعة (1-1000)"
SpeedBox.Text = ""
SpeedBox.TextScaled = true
SpeedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local UICornerSpeed = Instance.new("UICorner")
UICornerSpeed.CornerRadius = UDim.new(0, 8)
UICornerSpeed.Parent = SpeedBox

SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local s = tonumber(SpeedBox.Text)
        if s and s >= 1 and s <= 1000 then
            humanoid.WalkSpeed = s
        else
            SpeedBox.Text = "❌"
        end
    end
end)

-- 2️⃣ القفز اللا نهائي
local InfJumpButton = Instance.new("TextButton")
InfJumpButton.Parent = ScrollFrame
InfJumpButton.Position = UDim2.new(0, 10, 0, 60)
InfJumpButton.Size = UDim2.new(0, 160, 0, 40)
InfJumpButton.Text = "قفز لا نهائي"
InfJumpButton.TextScaled = true
InfJumpButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
InfJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local UICornerJump = Instance.new("UICorner")
UICornerJump.CornerRadius = UDim.new(0, 8)
UICornerJump.Parent = InfJumpButton

local infiniteJumpEnabled = false
InfJumpButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    InfJumpButton.BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 3️⃣ اختراق الجدران ذكي مع رسالة
local ClipButton = Instance.new("TextButton")
ClipButton.Parent = ScrollFrame
ClipButton.Position = UDim2.new(0, 10, 0, 110)
ClipButton.Size = UDim2.new(0, 120, 0, 40)
ClipButton.Text = "اختراق الجدران"
ClipButton.TextScaled = true
ClipButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local UICornerClip = Instance.new("UICorner")
UICornerClip.CornerRadius = UDim.new(0, 8)
UICornerClip.Parent = ClipButton

local clipping = false
ClipButton.MouseButton1Click:Connect(function()
    clipping = not clipping
    ClipButton.BackgroundColor3 = clipping and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    
    -- إشعار achievement
    local notif = Instance.new("TextLabel")
    notif.Parent = ScrollFrame
    notif.Size = UDim2.new(0, 180, 0, 30)
    notif.Position = UDim2.new(0, 10, 0, 80)
    notif.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    notif.TextColor3 = Color3.fromRGB(255,255,255)
    notif.Text = "❌ لا يمكنك اختراق كل شيء"
    notif.TextScaled = true
    notif.BackgroundTransparency = 0.5
    notif.TextXAlignment = Enum.TextXAlignment.Center
    notif.ZIndex = 10
    game:GetService("Debris"):AddItem(notif, 2)
end)

-- 4️⃣ منع نقص الدم
local GodModeButton = Instance.new("TextButton")
GodModeButton.Parent = ScrollFrame
GodModeButton.Position = UDim2.new(0, 10, 0, 160)
GodModeButton.Size = UDim2.new(0, 160, 0, 40)
GodModeButton.Text = "منع نقص الدم"
GodModeButton.TextScaled = true
GodModeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
GodModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local UICornerGod = Instance.new("UICorner")
UICornerGod.CornerRadius = UDim.new(0, 8)
UICornerGod.Parent = GodModeButton

local godModeEnabled = false
GodModeButton.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    GodModeButton.BackgroundColor3 = godModeEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

spawn(function()
    while true do
        if godModeEnabled then
            humanoid.Health = 100
        end
        wait(0.10)
    end
end)

-- 5️⃣ زر الطيران (Ashley's Script)
local FlyButton = Instance.new("TextButton")
FlyButton.Parent = ScrollFrame
FlyButton.Position = UDim2.new(0, 10, 0, 210)
FlyButton.Size = UDim2.new(0, 160, 0, 40)
FlyButton.Text = "طيران"
FlyButton.TextScaled = true
FlyButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120) -- رمادي
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local flyActive = false
FlyButton.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    if flyActive then
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Flyv2-30617"))()
    end
end)

-- تحديث المرجع عند تولد اللاعب
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
end)

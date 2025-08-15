local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 🟢 ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- زر إظهار/إخفاء GUI
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0,50,0,50)
ToggleButton.Position = UDim2.new(0,12,0,12)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
ToggleButton.Text = ""
ToggleButton.Active = true
ToggleButton.Draggable = true
local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0,25)
UICornerBtn.Parent = ToggleButton

-- 🟢 Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0,180,0,300)
MainFrame.Position = UDim2.new(0.5,-90,0.3,-150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
MainFrame.Active = true
MainFrame.Draggable = true
local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0,12)
UICornerMain.Parent = MainFrame

local visible = true
ToggleButton.MouseButton1Click:Connect(function()
    visible = not visible
    MainFrame.Visible = visible
    ToggleButton.BackgroundColor3 = visible and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

-- 🟢 Scroll Frame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1,-10,1,-10)
ScrollFrame.Position = UDim2.new(0,5,0,5)
ScrollFrame.CanvasSize = UDim2.new(0,0,1,0)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.BackgroundTransparency = 1

-- 🟢 UIListLayout داخل ScrollFrame
local UIList = Instance.new("UIListLayout")
UIList.Parent = ScrollFrame
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0,5)

-- 🟢 1️⃣ السرعة
local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = ScrollFrame
SpeedBox.Size = UDim2.new(1,0,0,40)
SpeedBox.PlaceholderText = "السرعة (1-1000)"
SpeedBox.Text = ""
SpeedBox.TextScaled = true
SpeedBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
SpeedBox.TextColor3 = Color3.fromRGB(255,255,255)
local UICornerSpeed = Instance.new("UICorner")
UICornerSpeed.CornerRadius = UDim.new(0,8)
UICornerSpeed.Parent = SpeedBox

SpeedBox.FocusLost:Connect(function(enter)
    if enter then
        local s = tonumber(SpeedBox.Text)
        if s and s>=1 and s<=1000 then
            humanoid.WalkSpeed = s
        else
            SpeedBox.Text = "❌"
        end
    end
end)

-- 🟢 2️⃣ القفز اللانهائي
local InfJumpButton = Instance.new("TextButton")
InfJumpButton.Parent = ScrollFrame
InfJumpButton.Size = UDim2.new(1,0,0,40)
InfJumpButton.Text = "قفز لا نهائي"
InfJumpButton.TextScaled = true
InfJumpButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
InfJumpButton.TextColor3 = Color3.fromRGB(255,255,255)
local UICornerJump = Instance.new("UICorner")
UICornerJump.CornerRadius = UDim.new(0,8)
UICornerJump.Parent = InfJumpButton

local infiniteJumpEnabled = false
InfJumpButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    InfJumpButton.BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 🟢 3️⃣ اختراق الجدران
local ClipButton = Instance.new("TextButton")
ClipButton.Parent = ScrollFrame
ClipButton.Size = UDim2.new(1,0,0,40)
ClipButton.Text = "اختراق الجدران"
ClipButton.TextScaled = true
ClipButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
ClipButton.TextColor3 = Color3.fromRGB(255,255,255)
local UICornerClip = Instance.new("UICorner")
UICornerClip.CornerRadius = UDim.new(0,8)
UICornerClip.Parent = ClipButton

local clipping = false
ClipButton.MouseButton1Click:Connect(function()
    clipping = not clipping
    ClipButton.BackgroundColor3 = clipping and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

RunService.Heartbeat:Connect(function()
    if clipping then
        for _,part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 🟢 4️⃣ منع نقص الدم
local GodModeButton = Instance.new("TextButton")
GodModeButton.Parent = ScrollFrame
GodModeButton.Size = UDim2.new(1,0,0,40)
GodModeButton.Text = "منع نقص الدم"
GodModeButton.TextScaled = true
GodModeButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
GodModeButton.TextColor3 = Color3.fromRGB(255,255,255)
local UICornerGod = Instance.new("UICorner")
UICornerGod.CornerRadius = UDim.new(0,8)
UICornerGod.Parent = GodModeButton

local godModeEnabled = false
GodModeButton.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    GodModeButton.BackgroundColor3 = godModeEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

spawn(function()
    while true do
        if godModeEnabled then
            humanoid.Health = humanoid.MaxHealth
        end
        wait(0.1)
    end
end)

-- 🟢 5️⃣ الطيران (Ashley Fly)
local FlyButton = Instance.new("TextButton")
FlyButton.Parent = ScrollFrame
FlyButton.Size = UDim2.new(1,0,0,40)
FlyButton.Text = "طيران"
FlyButton.TextScaled = true
FlyButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
FlyButton.TextColor3 = Color3.fromRGB(255,255,255)
local UICornerFly = Instance.new("UICorner")
UICornerFly.CornerRadius = UDim.new(0,8)
UICornerFly.Parent = FlyButton

local flyActive = false
local flyScript

FlyButton.MouseButton1Click:Connect(function()
    if not flyActive then
        flyScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/AshleyCanis/Qq/refs/heads/main/Ashley"))()
        flyActive = true
        FlyButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
    else
        flyActive = false
        FlyButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
        -- إيقاف الطيران (إذا السكربت يدعم دالة إيقاف داخلياً)
        pcall(function()
            if flyScript and type(flyScript) == "function" then
                flyScript()
            end
        end)
    end
end)

-- تحديث المرجع عند تولد اللاعب
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
end)

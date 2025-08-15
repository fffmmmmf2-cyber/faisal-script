local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- إنشاء ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- زر الإخفاء/الإظهار
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0,50,0,50)
ToggleButton.Position = UDim2.new(0,12,0,12)
ToggleButton.Text = ""
ToggleButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
ToggleButton.Active = true
ToggleButton.Draggable = true
local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0,25)
UICornerBtn.Parent = ToggleButton

-- المربع الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0,180,0,400) -- خليته أطول عشان السكرول
MainFrame.Position = UDim2.new(0.5,-90,0.3,-130)
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

-- ScrollFrame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1,0,1,0)
ScrollFrame.CanvasSize = UDim2.new(0,0,0,600) -- أطول على تحت
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.BackgroundTransparency = 1

-- دالة مساعدة لإنشاء الأزرار
local function CreateButton(name,text,parent,color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = parent
    btn.Size = UDim2.new(0,160,0,40)
    btn.Position = UDim2.new(0,10,0,#parent:GetChildren()*50)
    btn.Text = text
    btn.TextScaled = true
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    local uc = Instance.new("UICorner")
    uc.CornerRadius = UDim.new(0,8)
    uc.Parent = btn
    return btn
end

-- 1️⃣ السرعة
local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = ScrollFrame
SpeedBox.Position = UDim2.new(0,10,0,10)
SpeedBox.Size = UDim2.new(0,160,0,40)
SpeedBox.PlaceholderText = "السرعة (1-1000)"
SpeedBox.Text = ""
SpeedBox.TextScaled = true
SpeedBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
SpeedBox.TextColor3 = Color3.fromRGB(255,255,255)
local UICornerSpeed = Instance.new("UICorner")
UICornerSpeed.CornerRadius = UDim.new(0,8)
UICornerSpeed.Parent = SpeedBox

SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local s = tonumber(SpeedBox.Text)
        if s and s>=1 and s<=1000 then
            if humanoid and humanoid.Parent then
                humanoid.WalkSpeed = s
            end
        else
            SpeedBox.Text = "❌"
        end
    end
end)

-- 2️⃣ القفز اللانهائي
local InfJumpButton = CreateButton("InfJump","قفز لا نهائي",ScrollFrame,Color3.fromRGB(200,0,0))
local infiniteJumpEnabled = false
InfJumpButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    InfJumpButton.BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 3️⃣ اختراق الجدران
local ClipButton = CreateButton("Clip","اختراق الجدران",ScrollFrame,Color3.fromRGB(200,0,0))
local clipping = false
ClipButton.MouseButton1Click:Connect(function()
    clipping = not clipping
    ClipButton.BackgroundColor3 = clipping and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

RunService.Heartbeat:Connect(function()
    if char then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                if clipping then
                    if part.Position.Y >= rootPart.Position.Y then
                        part.CanCollide = false
                    else
                        part.CanCollide = true
                    end
                else
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- 4️⃣ منع نقص الدم
local GodModeButton = CreateButton("GodMode","منع نقص الدم",ScrollFrame,Color3.fromRGB(200,0,0))
local godModeEnabled = false
GodModeButton.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    GodModeButton.BackgroundColor3 = godModeEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

spawn(function()
    while true do
        if godModeEnabled and humanoid then
            humanoid.Health = 100
        end
        wait(0.10)
    end
end)

-- 5️⃣ الطيران (زر رمادي + يشتغل سكربت آشلي مباشرة)
local FlyButton = CreateButton("Fly","طيران",ScrollFrame,Color3.fromRGB(128,128,128))
FlyButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Flyv2-30617"))()
end)

-- تحديث عند تولد اللاعب
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
end)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true

-- المربع القابل للسحب
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 180, 0, 280)
MainFrame.Position = UDim2.new(0.5, -90, 0.3, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

-- ScrollFrame لكل الأزرار
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- تحديث حجم Canvas تلقائي
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

local buttonColor = Color3.fromRGB(255,255,255)

-- دالة لإنشاء TextBox
local function CreateTextBox(placeholder, parent)
    local box = Instance.new("TextBox")
    box.Parent = parent
    box.Size = UDim2.new(1, 0, 0, 40)
    box.TextScaled = true
    box.PlaceholderText = placeholder
    box.BackgroundColor3 = buttonColor
    box.TextColor3 = Color3.fromRGB(0,0,0)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    return box
end

-- دالة لإنشاء زر
local function CreateButton(text, parent)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text
    btn.TextScaled = true
    btn.BackgroundColor3 = buttonColor
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

-- السرعة
local SpeedBox = CreateTextBox("السرعة (1-1000)", ScrollFrame)
SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local s = tonumber(SpeedBox.Text)
        if s and s >=1 and s <=1000 then
            humanoid.WalkSpeed = s
        else
            SpeedBox.Text = "❌"
        end
    end
end)

-- القفز اللا نهائي
local InfJumpButton = CreateButton("قفز لا نهائي", ScrollFrame)
local infiniteJumpEnabled = false
InfJumpButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
end)
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- اختراق الجدران
local ClipButton = CreateButton("اختراق الجدران", ScrollFrame)
local clipping = false
ClipButton.MouseButton1Click:Connect(function()
    clipping = not clipping
end)
RunService.Heartbeat:Connect(function()
    if char then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not clipping
            end
        end
    end
end)

-- منع نقص الدم
local GodModeButton = CreateButton("منع نقص الدم", ScrollFrame)
local godModeEnabled = false
GodModeButton.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
end)
spawn(function()
    while true do
        if godModeEnabled then
            humanoid.Health = 100
        end
        wait(0.01)
    end
end)

-- الطيران
local FlyButton = CreateButton("طيران", ScrollFrame)
local flyingEnabled = false
FlyButton.MouseButton1Click:Connect(function()
    flyingEnabled = not flyingEnabled
    if flyingEnabled then
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Flyv2-30617"))()
    end
end)

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
end)

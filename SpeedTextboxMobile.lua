local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- المربع القابل للسحب
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 180, 0, 320)
MainFrame.Position = UDim2.new(0.5, -90, 0.3, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

-- 1️⃣ السرعة (أبيض دائم)
local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = MainFrame
SpeedBox.Position = UDim2.new(0, 10, 0, 10)
SpeedBox.Size = UDim2.new(0, 160, 0, 40)
SpeedBox.PlaceholderText = "السرعة (1-1000)"
SpeedBox.Text = ""
SpeedBox.TextScaled = true
SpeedBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.TextColor3 = Color3.fromRGB(0, 0, 0)

local UICornerSpeed = Instance.new("UICorner")
UICornerSpeed.CornerRadius = UDim.new(0, 8)
UICornerSpeed.Parent = SpeedBox

SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local s = tonumber(SpeedBox.Text)
        if s and s >= 1 and s <= 1000 then
            if humanoid and humanoid.Parent then
                humanoid.WalkSpeed = s
            end
        else
            SpeedBox.Text = "❌"
        end
    end
end)

-- 2️⃣ القفز اللا نهائي
local InfJumpButton = Instance.new("TextButton")
InfJumpButton.Parent = MainFrame
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
    if infiniteJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 3️⃣ اختراق الجدران
local ClipButton = Instance.new("TextButton")
ClipButton.Parent = MainFrame
ClipButton.Position = UDim2.new(0, 10, 0, 110)
ClipButton.Size = UDim2.new(0, 160, 0, 40)
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
local GodModeButton = Instance.new("TextButton")
GodModeButton.Parent = MainFrame
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
        if godModeEnabled and humanoid then
            humanoid.Health = 100
        end
        wait(0.10)
    end
end)

-- 5️⃣ الطيران (أبيض دائم)
local FlyButton = Instance.new("TextButton")
FlyButton.Parent = MainFrame
FlyButton.Position = UDim2.new(0, 10, 0, 210)
FlyButton.Size = UDim2.new(0, 160, 0, 40)
FlyButton.Text = "طيران"
FlyButton.TextScaled = true
FlyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextColor3 = Color3.fromRGB(0, 0, 0)

local UICornerFly = Instance.new("UICorner")
UICornerFly.CornerRadius = UDim.new(0, 8)
UICornerFly.Parent = FlyButton

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

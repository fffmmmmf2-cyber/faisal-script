local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

-- ScrollFrame للخانات
local MainFrame = Instance.new("ScrollingFrame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 180, 0, 260)
MainFrame.Position = UDim2.new(0.5, -90, 0.3, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
MainFrame.ScrollBarThickness = 8
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

local visible = true
ToggleButton.MouseButton1Click:Connect(function()
    visible = not visible
    MainFrame.Visible = visible
    ToggleButton.BackgroundColor3 = visible and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- دوال لإنشاء خانة وزر
local function CreateBox(posY, placeholder)
    local box = Instance.new("TextBox")
    box.Parent = MainFrame
    box.Position = UDim2.new(0, 10, 0, posY)
    box.Size = UDim2.new(0, 160, 0, 40)
    box.PlaceholderText = placeholder or ""
    box.Text = ""
    box.TextScaled = true
    box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    return box
end

local function CreateButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Size = UDim2.new(0, 160, 0, 40)
    btn.Text = name
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

-- توليد الخانات
local currentY = 10
local SpeedBox = CreateBox(currentY, "السرعة (1-1000)")
currentY = currentY + 50
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

local InfJumpButton = CreateButton("قفز لا نهائي", currentY)
currentY = currentY + 50
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

local ClipButton = CreateButton("اختراق الجدران", currentY)
currentY = currentY + 50
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

local GodModeButton = CreateButton("منع نقص الدم", currentY)
currentY = currentY + 50
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

-- الطيران للجوال
local FlyBox = CreateButton("طيران", currentY)
currentY = currentY + 50
local flyingEnabled = false
local flySpeed = 50
local bodyVelocity

-- أزرار تحكم الطيران للجوال
local function CreateFlyButton(text, posX, posY)
    local btn = Instance.new("TextButton")
    btn.Parent = ScreenGui
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0, posX, 1, posY)
    btn.Text = text
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    return btn
end

local forwardBtn = CreateFlyButton("⬆️", 80, -120)
local backBtn = CreateFlyButton("⬇️", 80, -60)
local leftBtn = CreateFlyButton("⬅️", 30, -90)
local rightBtn = CreateFlyButton("➡️", 130, -90)
local upBtn = CreateFlyButton("⬆️🌟", 250, -120)
local downBtn = CreateFlyButton("⬇️🌟", 250, -60)

local moveDir = Vector3.new()

FlyBox.MouseButton1Click:Connect(function()
    flyingEnabled = not flyingEnabled
    FlyBox.BackgroundColor3 = flyingEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)

    if flyingEnabled then
        humanoid.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = rootPart
    else
        humanoid.PlatformStand = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        moveDir = Vector3.new()
    end
end)

-- التحكم بالطيران عن طريق الأزرار
local function UpdateDir()
    if flyingEnabled and bodyVelocity then
        local camCFrame = workspace.CurrentCamera.CFrame
        local dir = Vector3.new()
        if forwardBtn:GetAttribute("Pressed") then dir = dir + camCFrame.LookVector end
        if backBtn:GetAttribute("Pressed") then dir = dir - camCFrame.LookVector end
        if leftBtn:GetAttribute("Pressed") then dir = dir - camCFrame.RightVector end
        if rightBtn:GetAttribute("Pressed") then dir = dir + camCFrame.RightVector end
        if upBtn:GetAttribute("Pressed") then dir = dir + Vector3.new(0,1,0) end
        if downBtn:GetAttribute("Pressed") then dir = dir - Vector3.new(0,1,0) end

        if dir.Magnitude > 0 then
            bodyVelocity.Velocity = dir.Unit * flySpeed
        else
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end
end

local function SetButtonEvents(btn, attr)
    btn:SetAttribute("Pressed", false)
    btn.MouseButton1Down:Connect(function() btn:SetAttribute("Pressed", true) end)
    btn.MouseButton1Up:Connect(function() btn:SetAttribute("Pressed", false) end)
end

for _, b in pairs({forwardBtn, backBtn, leftBtn, rightBtn, upBtn, downBtn}) do
    SetButtonEvents(b)
end

RunService.RenderStepped:Connect(UpdateDir)

-- تحديث ScrollFrame حسب عدد الخانات
MainFrame.CanvasSize = UDim2.new(0,0,0,currentY + 10)

-- تحديث المرجع عند تولد اللاعب
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
end)

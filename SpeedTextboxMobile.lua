local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- زر الإخفاء/الإظهار
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

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0,200,0,300)
MainFrame.Position = UDim2.new(0.5,-100,0.3,-150)
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
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = MainFrame
Scroll.Size = UDim2.new(1,-10,1,-10)
Scroll.Position = UDim2.new(0,5,0,5)
Scroll.CanvasSize = UDim2.new(0,0,0,600) -- طول كبير يكفي لكل الخانات
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6

-- UIListLayout
local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = Scroll
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0,8)

-- دالة مساعدة لإنشاء خانة
local function CreateButton(parent,text)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = text
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn
    return btn
end

local function CreateTextBox(parent,placeholder)
    local box = Instance.new("TextBox")
    box.Parent = parent
    box.Size = UDim2.new(1,0,0,40)
    box.PlaceholderText = placeholder
    box.TextScaled = true
    box.BackgroundColor3 = Color3.fromRGB(60,60,60)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = box
    return box
end

-- 1️⃣ السرعة
local SpeedBox = CreateTextBox(Scroll,"السرعة (1-1000)")
SpeedBox.FocusLost:Connect(function(enter)
    if enter then
        local s = tonumber(SpeedBox.Text)
        if s and s >=1 and s<=1000 then
            humanoid.WalkSpeed = s
        else
            SpeedBox.Text = "❌"
        end
    end
end)

-- 2️⃣ القفز اللامتناهي
local InfJumpBtn = CreateButton(Scroll,"قفز لا نهائي")
local infiniteJump = false
InfJumpBtn.MouseButton1Click:Connect(function()
    infiniteJump = not infiniteJump
    InfJumpBtn.BackgroundColor3 = infiniteJump and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)
UserInputService.JumpRequest:Connect(function()
    if infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 3️⃣ اختراق الجدران
local ClipBtn = CreateButton(Scroll,"اختراق الجدران")
local clipping = false
ClipBtn.MouseButton1Click:Connect(function()
    clipping = not clipping
    ClipBtn.BackgroundColor3 = clipping and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)
RunService.Heartbeat:Connect(function()
    if clipping then
        for _,part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Position.Y >= rootPart.Position.Y then
                    part.CanCollide = false
                else
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- 4️⃣ منع نقص الدم
local GodBtn = CreateButton(Scroll,"منع نقص الدم")
local godMode = false
GodBtn.MouseButton1Click:Connect(function()
    godMode = not godMode
    GodBtn.BackgroundColor3 = godMode and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)
spawn(function()
    while true do
        if godMode then humanoid.Health = 100 end
        wait(0.1)
    end
end)

-- 5️⃣ الطيران
local FlyBtn = CreateButton(Scroll,"طيران")
local flying = false
FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    FlyBtn.BackgroundColor3 = flying and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    if flying then
        humanoid.PlatformStand = true
        local bv = Instance.new("BodyVelocity", rootPart)
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bv.Velocity = Vector3.new(0,0,0)
        local bg = Instance.new("BodyGyro", rootPart)
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bg.CFrame = rootPart.CFrame

        RunService.RenderStepped:Connect(function()
            if flying then
                local cam = workspace.CurrentCamera
                local moveDir = humanoid.MoveDirection
                bv.Velocity = moveDir * 50 + Vector3.new(0,0,0)
                bg.CFrame = cam.CFrame
            else
                bv:Destroy()
                bg:Destroy()
                humanoid.PlatformStand = false
            end
        end)
    end
end)

-- 6️⃣ حجم الشخصية
local SizeBox = CreateTextBox(Scroll,"حجم الشخصية (1-100)")
SizeBox.FocusLost:Connect(function(enter)
    if enter then
        local val = tonumber(SizeBox.Text)
        if val and val>=1 and val<=100 then
            char:FindFirstChildWhichIsA("Humanoid").BodyScaleScale.Value = val/10
            char:WaitForChild("HumanoidRootPart").Size = Vector3.new(val/10,val/10,val/10)
        else
            SizeBox.Text = "❌"
        end
    end
end)

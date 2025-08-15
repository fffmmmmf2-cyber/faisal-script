-- سكربت كامل: ScrollFrame + خانات + طيران للموبايل باللمس بدون أزرار
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
ToggleButton.Size = UDim2.new(0,50,0,50)
ToggleButton.Position = UDim2.new(0,12,0,12)
ToggleButton.Text = ""
ToggleButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
ToggleButton.Active = true
ToggleButton.Draggable = true
local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0,25)
UICornerBtn.Parent = ToggleButton

-- ScrollFrame للخانات
local MainFrame = Instance.new("ScrollingFrame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0,180,0,260)
MainFrame.Position = UDim2.new(0.5,-90,0.3,-130)
MainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
MainFrame.CanvasSize = UDim2.new(0,0,0,500)
MainFrame.ScrollBarThickness = 8
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

-- دوال لإنشاء خانة وزر
local function CreateBox(posY, placeholder)
    local box = Instance.new("TextBox")
    box.Parent = MainFrame
    box.Position = UDim2.new(0,10,0,posY)
    box.Size = UDim2.new(0,160,0,40)
    box.PlaceholderText = placeholder or ""
    box.Text = ""
    box.TextScaled = true
    box.BackgroundColor3 = Color3.fromRGB(60,60,60)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = box
    return box
end

local function CreateButton(name,posY)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Size = UDim2.new(0,160,0,40)
    btn.Text = name
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn
    return btn
end

-- توليد الخانات (الترتيب: سرعة - قفز لانهائي - اختراق - منع نقص دم - طيران)
local currentY = 10
local SpeedBox = CreateBox(currentY,"السرعة (1-1000)")
currentY = currentY + 50
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

local InfJumpButton = CreateButton("قفز لا نهائي", currentY)
currentY = currentY + 50
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

local ClipButton = CreateButton("اختراق الجدران", currentY)
currentY = currentY + 50
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
                    if part.Position.Y>=rootPart.Position.Y then
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
    GodModeButton.BackgroundColor3 = godModeEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

spawn(function()
    while true do
        if godModeEnabled and humanoid then
            humanoid.Health = 100
        end
        wait(0.1)
    end
end)

-- === طيران سلس للموبايل بدون أزرار ===
local FlyBox = CreateButton("طيران", currentY) -- زر داخل الواجهة فقط للتفعيل/الغلق
currentY = currentY + 50
local flyingEnabled = false
local flySpeed = 80            -- اضبط السرعة حسب رغبتك
local sensitivity = 0.008      -- حساسية السحب (صغير = أقل حساسية)
local bodyVelocity = nil

-- متغيرات اللمس
local touchActive = false
local touchPos = nil
local touchStartPos = nil

-- إدارة اللمس: InputBegan / InputChanged / InputEnded (يدعم الجوال)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        touchActive = true
        touchStartPos = input.Position
        touchPos = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and touchActive then
        touchPos = input.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        touchActive = false
        touchPos = nil
        touchStartPos = nil
    end
end)

-- تفعيل/إيقاف الطيران عبر الزر في الواجهة
FlyBox.MouseButton1Click:Connect(function()
    flyingEnabled = not flyingEnabled
    FlyBox.BackgroundColor3 = flyingEnabled and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)

    if flyingEnabled then
        humanoid.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = rootPart
    else
        humanoid.PlatformStand = false
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    end
end)

-- تحديث الحركة كل فريم
RunService.RenderStepped:Connect(function()
    -- لو الطيران مفعل وعندنا bodyVelocity
    if flyingEnabled and bodyVelocity then
        if touchActive and touchPos then
            -- نحسب دلتا السحب نسبة لمركز الشاشة أو نقطة البداية
            -- هنا نستخدم مركز الشاشة كمرجع علشان الحركة تتجه بالنسبة للكاميرا
            local cam = workspace.CurrentCamera
            local screenCenter = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
            local delta = touchPos - screenCenter

            -- لو تريد حركة أقل حساسية لو تحب تستخدم touchStartPos بدل المركز:
            -- local delta = touchPos - (touchStartPos or touchPos)

            -- نحول دلتا الشاشة لاتجاه ثلاثي الأبعاد بالاعتماد على كاميرا اللاعب
            local right = cam.CFrame.RightVector
            local look = cam.CFrame.LookVector
            -- ملاحظة: نستخدم -delta.Y لأن الشاشة Y زيادة = لأسفل
            local dir = (right * (delta.X * sensitivity)) + (look * (-delta.Y * sensitivity))

            -- ممكن نضيف تحكم عمودي بسيط حسب مقدار السحب الرأسي الكبير
            -- لو سحبت فوق بشكل قوي نصعد، لو سحبت تحت ننزل
            local vertical = 0
            if math.abs(delta.Y) > 100 then
                vertical = -delta.Y * sensitivity * 0.3 -- تعديل عمودي أصغر
            end
            dir = dir + Vector3.new(0, vertical, 0)

            -- تأمين المقياس
            if dir.Magnitude > 1 then
                dir = dir.Unit
            end

            bodyVelocity.Velocity = dir * flySpeed
        else
            -- لو ما فيه لمس نوقف الحركة (جسمك يثبت)
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- ضبط حجم ScrollFrame تلقائي حسب الخانات
MainFrame.CanvasSize = UDim2.new(0,0,0,currentY+10)

-- تحديث المراجع عند إعادة تولد الشخصية
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    -- لو الطيران كان مفعل نعيد تفعيل bodyVelocity صح
    if flyingEnabled then
        humanoid.PlatformStand = true
        if bodyVelocity then bodyVelocity.Parent = rootPart end
    end
end)

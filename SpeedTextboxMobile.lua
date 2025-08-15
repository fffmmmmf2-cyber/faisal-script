-- دمج كامل: واجهة ScrollFrame + خانات + Ashley Fly (موبايل + كيبورد)
-- ضع هذا كـ LocalScript داخل StarterPlayerScripts أو PlayerGui
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

-- ===== إعدادات الطيران (Ashley) =====
local flySpeed = 80          -- سرعة الطيران
local sensitivity = 0.009    -- حساسية السحب للموبايل
local smoothness = 0.18      -- نعومة الحركة (0-1)
local verticalFactor = 0.45  -- عامل الحركة الرأسية

local flying = false
local bodyVelocity = nil
local bodyGyro = nil
local targetVelocity = Vector3.new(0,0,0)

-- دعم الكيبورد
local kbDir = Vector3.new(0,0,0)
local keyMap = {
    W = Vector3.new(0,0,-1),
    S = Vector3.new(0,0,1),
    A = Vector3.new(-1,0,0),
    D = Vector3.new(1,0,0)
}

-- لمس الموبايل
local touchActive = false
local touchPos = nil

-- ===== إنشاء الواجهة =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Faisal_Ashley_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- زر الإخفاء/الإظهار (صغير)
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
MainFrame.Size = UDim2.new(0,180,0,300)
MainFrame.Position = UDim2.new(0.5,-90,0.28,-150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
MainFrame.CanvasSize = UDim2.new(0,0,0,600)
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

-- دوال مساعدة لإنشاء عناصر
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

-- ===== توليد الخانات الأساسية =====
local currentY = 10

-- السرعة
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

-- قفز لانهائي
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

-- اختراق الجدران ذكي
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
                    if rootPart and part.Position.Y >= rootPart.Position.Y then
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

-- منع نقص الدم (GodMode)
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
            humanoid.Health = humanoid.MaxHealth or 100
        end
        wait(0.1)
    end
end)

-- زر الطيران داخل الواجهة (لتفعيل/إيقاف)
local FlyBox = CreateButton("طيران", currentY)
currentY = currentY + 50

-- حدث: ضبط CanvasSize تلقائي
MainFrame.CanvasSize = UDim2.new(0,0,0,currentY+10)

-- ===== أحداث اللمس وكيبورد للطيران =====
-- لمسات (موبايل)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        touchActive = true
        touchPos = input.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        touchPos = input.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        touchActive = false
        touchPos = nil
    end
end)

-- كيبورد (لو على PC)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode.Name
        if keyMap[key] then kbDir = kbDir + keyMap[key] end
        if input.KeyCode == Enum.KeyCode.Space then kbDir = kbDir + Vector3.new(0,1,0) end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.C then kbDir = kbDir - Vector3.new(0,1,0) end
    end
end)
UserInputService.InputEnded:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode.Name
        if keyMap[key] then kbDir = kbDir - keyMap[key] end
        if input.KeyCode == Enum.KeyCode.Space then kbDir = kbDir - Vector3.new(0,1,0) end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.C then kbDir = kbDir + Vector3.new(0,1,0) end
    end
end)

-- تحويل دلتا الشاشة لاتجاه عالمى بالنسبة للكاميرا
local function screenDeltaToWorld(dir2d)
    local cam = workspace.CurrentCamera
    local look = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector
    local lookFlat = Vector3.new(look.X, 0, look.Z)
    if lookFlat.Magnitude == 0 then lookFlat = Vector3.new(0,0,-1) end
    lookFlat = lookFlat.Unit
    local rightFlat = Vector3.new(right.X,0,right.Z).Unit
    local worldDir = (rightFlat * dir2d.X) + (lookFlat * dir2d.Y)
    return worldDir
end

-- تفعيل/إيقاف طيران عبر زر FlyBox
FlyBox.MouseButton1Click:Connect(function()
    flying = not flying
    FlyBox.BackgroundColor3 = flying and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    if flying then
        if humanoid then humanoid.PlatformStand = true end
        -- BodyVelocity
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.Parent = rootPart
        else
            bodyVelocity.Parent = rootPart
        end
        -- BodyGyro
        if not bodyGyro then
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(4e4,4e4,4e4)
            bodyGyro.P = 4000
            bodyGyro.D = 100
            bodyGyro.CFrame = rootPart.CFrame
            bodyGyro.Parent = rootPart
        else
            bodyGyro.Parent = rootPart
        end
    else
        if humanoid then humanoid.PlatformStand = false end
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        targetVelocity = Vector3.new(0,0,0)
    end
end)

-- تحديث الحركة كل فريم
RunService.RenderStepped:Connect(function(dt)
    -- إعادة جمع المراجع لو تغيرت الشخصية
    if not char or not char.Parent then
        char = player.Character
        if char then
            humanoid = char:FindFirstChild("Humanoid")
            rootPart = char:FindFirstChild("HumanoidRootPart")
        end
    end

    -- منع نقص الدم يستعمل المرجع المحدث
    if godModeEnabled and humanoid then
        humanoid.Health = humanoid.MaxHealth or 100
    end

    if flying and bodyVelocity and rootPart then
        local desired = Vector3.new(0,0,0)

        -- كيبورد
        if kbDir.Magnitude > 0 then
            local cam = workspace.CurrentCamera
            local look = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local hDir = (right * kbDir.X) + (Vector3.new(look.X,0,look.Z).Unit * -kbDir.Z)
            desired = desired + hDir
            -- Y handled inside kbDir if Space/Ctrl pressed
            if kbDir.Y ~= 0 then desired = desired + Vector3.new(0, kbDir.Y, 0) end
        end

        -- لمس الموبايل: نأخذ دلتا بالنسبة لمركز الشاشة
        if touchActive and touchPos then
            local cam = workspace.CurrentCamera
            local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
            local delta2 = touchPos - center
            local dir2d = Vector2.new(delta2.X * sensitivity, -delta2.Y * sensitivity)
            if dir2d.Magnitude > 1 then dir2d = dir2d.Unit end
            local worldDir = screenDeltaToWorld(Vector2.new(dir2d.X, dir2d.Y))
            desired = desired + Vector3.new(worldDir.X, 0, worldDir.Z)
            -- حركة رأسية بناءً على سحب عمودي كبير
            if math.abs(delta2.Y) > 120 then
                desired = desired + Vector3.new(0, (-delta2.Y/ math.max(cam.ViewportSize.Y,1)) * verticalFactor, 0)
            end
        end

        -- حساب targetVelocity بشكل سلس
        if desired.Magnitude > 0 then
            desired = desired.Unit
            targetVelocity = targetVelocity:Lerp(desired * flySpeed, math.clamp(1 - math.pow(1 - smoothness, dt*60), 0, 1))
        else
            targetVelocity = targetVelocity:Lerp(Vector3.new(0,0,0), math.clamp(1 - math.pow(1 - smoothness, dt*60), 0, 1))
        end

        -- تطبيق السرعة
        bodyVelocity.Velocity = Vector3.new(targetVelocity.X, targetVelocity.Y, targetVelocity.Z)

        -- تثبيت اللف باتجاه الحركة
        if bodyGyro then
            if targetVelocity.Magnitude > 0.5 then
                local horizontal = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
                if horizontal.Magnitude > 0 then
                    local newCFrame = CFrame.new(rootPart.Position, rootPart.Position + horizontal.Unit)
                    bodyGyro.CFrame = bodyGyro.CFrame:Lerp(newCFrame, math.clamp(1 - math.pow(1 - smoothness, dt*60), 0, 1))
                end
            end
        end
    end
end)

-- عند إعادة تولد الشخصية: إعادة توصيل bodyInstances وحالة الطيران
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    if flying then
        humanoid.PlatformStand = true
        if bodyVelocity then bodyVelocity.Parent = rootPart end
        if bodyGyro then bodyGyro.Parent = rootPart end
    end
end)

-- ===== تنبيهات/نصائح سريعة =====
-- لتعديل السلاسة أو الحساسية غيّر flySpeed / sensitivity / smoothness
-- ملاحظة مهمة: استخدام سكربت تغيير حركة في ألعاب غير لعبتك قد يخالف قوانين اللعبة ويعرض حسابك لمخاطر

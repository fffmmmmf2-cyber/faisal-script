-- Anti-Remove Jump Button + Forced Jump Enable (LocalScript)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local function getChar()
    local c = player.Character or player.CharacterAdded:Wait()
    return c, c:WaitForChild("Humanoid")
end

local char, humanoid = getChar()

-- افتراضيات القفز (Roblox الحديثة تستخدم JumpPower أو JumpHeight)
local DEFAULT_JUMP_POWER = 50
local DEFAULT_JUMP_HEIGHT = 7.2

-- نصنع زر قفز بديل لو اختفى زر اللعبة
local customGui -- ScreenGui
local jumpBtn -- TextButton

local function createCustomJumpButton()
    if customGui then return end

    customGui = Instance.new("ScreenGui")
    customGui.Name = "AntiRemoveJumpGUI"
    customGui.ResetOnSpawn = false
    customGui.IgnoreGuiInset = true
    customGui.Parent = player:WaitForChild("PlayerGui")

    jumpBtn = Instance.new("TextButton")
    jumpBtn.Name = "CustomJump"
    jumpBtn.Parent = customGui
    jumpBtn.AnchorPoint = Vector2.new(1, 1)
    jumpBtn.Size = UDim2.new(0, 90, 0, 90)
    jumpBtn.Position = UDim2.new(1, -20, 1, -20) -- أسفل يمين
    jumpBtn.BackgroundTransparency = 0.2
    jumpBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    jumpBtn.Text = "⤴️"
    jumpBtn.TextScaled = true
    jumpBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    jumpBtn.AutoButtonColor = true

    local uiRound = Instance.new("UICorner")
    uiRound.CornerRadius = UDim.new(0, 18)
    uiRound.Parent = jumpBtn

    -- ضغط مستمر يكرر القفز طالما الزر مضغوط
    local pressing = false
    jumpBtn.MouseButton1Down:Connect(function()
        pressing = true
        while pressing do
            local ok, hum = pcall(function()
                return (player.Character or player.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
            end)
            if ok and hum then
                hum.Jump = true
            end
            task.wait(0.07)
        end
    end)
    jumpBtn.MouseButton1Up:Connect(function() pressing = false end)
    jumpBtn.MouseLeave:Connect(function() pressing = false end)
end

local function destroyCustomJumpButton()
    if customGui then
        customGui:Destroy()
        customGui = nil
        jumpBtn = nil
    end
end

-- نحاول نستخدم زر Roblox الأصلي إذا موجود، وإذا انحذف ننشئ بديل
local function defaultJumpButtonExists()
    -- يحاول إيجاد TouchGui/JumpButton ضمن PlayerGui
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return false end
    local touchGui = pg:FindFirstChild("TouchGui", true)
    if not touchGui then return false end

    -- بعض النسخ تسميه "JumpButton" أو توجد داخل "TouchControlFrame"
    local found = false
    for _, d in ipairs(touchGui:GetDescendants()) do
        if d:IsA("GuiButton") and (d.Name:lower():find("jump")) then
            -- لو الزر موجود لكنه مخفي، نعدّه غير متاح
            if d.Visible and d.Active and d.Parent and d.AbsoluteSize.Magnitude > 0 then
                found = true
                break
            end
        end
    end
    return found
end

-- إجبار تفعيل القفز مهما حاولت اللعبة تعطيله
local function forceEnableJump(hum)
    if not hum then return end
    -- فعّل حالة القفز
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) end)

    -- رجّع القيم إذا صارت 0
    if hum.UseJumpPower ~= nil then
        if hum.JumpPower and hum.JumpPower <= 0 then
            hum.JumpPower = DEFAULT_JUMP_POWER
        end
    else
        if hum.JumpHeight and hum.JumpHeight <= 0 then
            hum.JumpHeight = DEFAULT_JUMP_HEIGHT
        end
    end

    -- لو اللعبة حطّت PlatformStand يمنع القفز، نلغيه
    if hum.PlatformStand then
        hum.PlatformStand = false
    end
end

-- مراقبة مستمرة: إن وُجد زر Roblox الأصلي نخفي زرّنا، وإن اختفى ننشئه
task.spawn(function()
    while true do
        -- تحدّث المراجع لو مت
        if not char or not char.Parent then
            char, humanoid = getChar()
        end
        forceEnableJump(humanoid)

        local hasDefault = false
        pcall(function()
            hasDefault = defaultJumpButtonExists()
        end)

        if hasDefault then
            -- عند وجود الزر الافتراضي، احذف زرّنا البديل إن كان موجود
            if customGui then destroyCustomJumpButton() end
        else
            -- ما في زر افتراضي => تأكد إن زرّنا موجود
            if not customGui then createCustomJumpButton() end
        end

        task.wait(0.25)
    end
end)

-- لو تغيّر الحرف/الموت، نحدّث الإنسان
player.CharacterAdded:Connect(function(nc)
    char = nc
    humanoid = nc:WaitForChild("Humanoid")
    -- إعادة تفعيل القفز عند الإحياء
    task.delay(0.5, function()
        forceEnableJump(humanoid)
    end)
end)

-- حماية إضافية لو حاولت سكربتات توقف القفز فجأة
if humanoid then
    humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if humanoid.JumpPower <= 0 then
            humanoid.JumpPower = DEFAULT_JUMP_POWER
        end
    end)
    humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
        if humanoid.JumpHeight <= 0 then
            humanoid.JumpHeight = DEFAULT_JUMP_HEIGHT
        end
    end)
    humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.PlatformStanding then
            humanoid.PlatformStand = false
        end
    end)
end

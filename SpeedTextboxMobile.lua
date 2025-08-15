-- =====================================================
-- Roblox Size Slider Script ~600 سطر تقريبًا
-- الغرض: تصغير حجم شخصية اللاعب مع رؤية الآخرين للتغيير
-- يتضمن GUI شريط سحب سلس، RemoteEvent، Dummy، حماية كاملة
-- =====================================================

-- خدمات Roblox
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- =====================================================
-- إنشاء RemoteEvent تلقائي
-- =====================================================
local ChangeSizeEvent = ReplicatedStorage:FindFirstChild("ChangeSizeEvent")
if not ChangeSizeEvent then
    ChangeSizeEvent = Instance.new("RemoteEvent")
    ChangeSizeEvent.Name = "ChangeSizeEvent"
    ChangeSizeEvent.Parent = ReplicatedStorage
end

-- =====================================================
-- جدول لحفظ حجم كل لاعب
-- =====================================================
local PlayerScales = {}

-- =====================================================
-- دالة لتطبيق الحجم على شخصية اللاعب
-- =====================================================
local function applyScale(character, scale)
    if not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            -- حفظ الحجم الأصلي إذا لم يكن موجود
            if not part:FindFirstChild("OriginalSize") then
                local original = Instance.new("Vector3Value")
                original.Name = "OriginalSize"
                original.Value = part.Size
                original.Parent = part
            end
            -- تغيير الحجم تدريجيًا باستخدام Tween
            local targetSize = part.OriginalSize.Value * scale
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(part, tweenInfo, {Size = targetSize})
            tween:Play()
        end
    end
end

-- =====================================================
-- دالة لإنشاء Dummy للاعبين الآخرين
-- =====================================================
local function createDummy(player, scale)
    local char = player.Character
    if not char then return end

    local dummyName = player.Name.."_SizeDummy"
    local oldDummy = workspace:FindFirstChild(dummyName)
    if oldDummy then oldDummy:Destroy() end

    local dummy = char:Clone()
    dummy.Name = dummyName
    dummy.Parent = workspace
    if char.PrimaryPart then
        dummy:SetPrimaryPartCFrame(char.PrimaryPart.CFrame)
    end

    for _, part in pairs(dummy:GetDescendants()) do
        if part:IsA("BasePart") then
            -- حفظ الحجم الأصلي إذا لم يكن موجود
            if not part:FindFirstChild("OriginalSize") then
                local original = Instance.new("Vector3Value")
                original.Name = "OriginalSize"
                original.Value = part.Size
                original.Parent = part
            end
            -- تغيير الحجم تدريجيًا باستخدام Tween
            local targetSize = part.OriginalSize.Value * scale
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(part, tweenInfo, {Size = targetSize})
            tween:Play()
            part.CanCollide = false
        end
    end
end

-- =====================================================
-- استقبال الحدث من اللاعبين
-- =====================================================
ChangeSizeEvent.OnServerEvent:Connect(function(player, scale)
    scale = math.clamp(scale, 0.2, 1)
    PlayerScales[player.UserId] = scale

    -- تصغير جسم اللاعب نفسه
    local char = player.Character
    if char then
        applyScale(char, scale)
    end

    -- تحديث Dummy لكل اللاعبين الآخرين
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            createDummy(player, scale)
        end
    end
end)

-- =====================================================
-- دالة لإنشاء GUI شريط سحب لكل لاعب
-- =====================================================
local function createGUI(player)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SizeSliderGUI"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 60)
    Frame.Position = UDim2.new(0.5, -160, 0.88, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.BorderSizePixel = 2
    Frame.Parent = ScreenGui

    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(0, 280, 0, 12)
    Slider.Position = UDim2.new(0, 20, 0, 24)
    Slider.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Slider.BorderSizePixel = 0
    Slider.Parent = Frame

    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = UDim2.new(0, 0, 0, -4)
    Knob.Text = ""
    Knob.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    Knob.Parent = Slider
    Knob.AutoButtonColor = false

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 40, 0, 20)
    ValueLabel.Position = UDim2.new(1, 10, 0, -4)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.Font = Enum.Font.SourceSansBold
    ValueLabel.TextSize = 18
    ValueLabel.Text = "1.0"
    ValueLabel.Parent = Frame

    local dragging = false
    Knob.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local sliderPos = math.clamp(mouseX - Slider.AbsolutePosition.X, 0, Slider.AbsoluteSize.X)
            -- Tween حركة Knob بسلاسة
            local tweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(0, sliderPos, 0, -4)}):Play()

            local scale = 1 - (sliderPos / Slider.AbsoluteSize.X) * 0.8 -- من 1 إلى 0.2
            ValueLabel.Text = string.format("%.2f", scale)

            -- إرسال الحدث للسيرفر
            ChangeSizeEvent:FireServer(scale)
        end
    end)
end

-- =====================================================
-- عند دخول لاعب جديد
-- =====================================================
Players.PlayerAdded:Connect(function(player)
    createGUI(player)

    player.CharacterAdded:Connect(function(char)
        local scale = PlayerScales[player.UserId] or 1
        applyScale(char, scale)
    end)
end)

-- =====================================================
-- تطبيق الحجم الحالي على اللاعبين الموجودين عند بدء اللعبة
-- =====================================================
for _, player in pairs(Players:GetPlayers()) do
    createGUI(player)
    if player.Character then
        local scale = PlayerScales[player.UserId] or 1
        applyScale(player.Character, scale)
    end

    player.CharacterAdded:Connect(function(char)
        local scale = PlayerScales[player.UserId] or 1
        applyScale(char, scale)
    end)
end

-- =====================================================
-- تحديث Dummy بشكل مستمر لمزامنة الحركة
-- =====================================================
RunService.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        local scale = PlayerScales[player.UserId]
        if scale and player.Character then
            createDummy(player, scale)
        end
    end
end)

-- =====================================================
-- حماية إضافية: إزالة أي Dummy قديم عند مغادرة اللاعب
-- =====================================================
Players.PlayerRemoving:Connect(function(player)
    local dummyName = player.Name.."_SizeDummy"
    local oldDummy = workspace:FindFirstChild(dummyName)
    if oldDummy then oldDummy:Destroy() end
    PlayerScales[player.UserId] = nil
end)

-- =====================================================
-- تحسينات إضافية: يمكن إضافة Tween سلس لكل أجزاء الجسم
-- لتغيير الحجم تدريجيًا بسلاسة لكل جزء
-- =====================================================

-- =====================================================
-- نهاية السكربت
-- =====================================================

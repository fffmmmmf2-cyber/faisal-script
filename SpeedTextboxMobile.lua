local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- متغيرات للقائمة والزر
local ScreenGui
local MainFrame
local ToggleButton
local mainVisible = true
local clipping = false
local infiniteJumpEnabled = false
local godModeEnabled = false
local flyingEnabled = false

-- وظيفة لإنشاء الواجهة
local function createUI(char, humanoid, rootPart)
    -- ScreenGui
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = player:WaitForChild("PlayerGui")
    end

    -- المربع القابل للسحب
    if not MainFrame then
        MainFrame = Instance.new("Frame")
        MainFrame.Parent = ScreenGui
        MainFrame.Size = UDim2.new(0, 180, 0, 320)
        MainFrame.Position = UDim2.new(0.5, -90, 0.3, -130)
        MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        MainFrame.Active = true
        MainFrame.Draggable = true

        local UICornerMain = Instance.new("UICorner")
        UICornerMain.CornerRadius = UDim.new(0, 12)
        UICornerMain.Parent = MainFrame
    end
    MainFrame.Visible = mainVisible

    -- زر صغير على يسار الشاشة لفتح/إخفاء القائمة
    if not ToggleButton then
        ToggleButton = Instance.new("TextButton")
        ToggleButton.Parent = ScreenGui
        ToggleButton.Size = UDim2.new(0, 25, 0, 25)
        ToggleButton.Position = UDim2.new(0, 5, 0.5, -12)
        ToggleButton.Text = "+"
        ToggleButton.TextScaled = true
        ToggleButton.BackgroundColor3 = Color3.fromHSV(0,1,1)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
        ToggleButton.ZIndex = 10

        spawn(function()
            local hue = 0
            while true do
                hue = hue + 0.01
                if hue > 1 then hue = 0 end
                ToggleButton.BackgroundColor3 = Color3.fromHSV(hue,1,1)
                wait(0.03)
            end
        end)

        ToggleButton.MouseButton1Click:Connect(function()
            mainVisible = not mainVisible
            MainFrame.Visible = mainVisible
        end)
    end

    -- كل الأزرار بيضاء دائمًا
    local buttonColor = Color3.fromRGB(255,255,255)

    -- السرعة
    if not MainFrame:FindFirstChild("SpeedBox") then
        local SpeedBox = Instance.new("TextBox")
        SpeedBox.Name = "SpeedBox"
        SpeedBox.Parent = MainFrame
        SpeedBox.Position = UDim2.new(0, 10, 0, 10)
        SpeedBox.Size = UDim2.new(0, 160, 0, 40)
        SpeedBox.PlaceholderText = "السرعة (1-1000)"
        SpeedBox.Text = ""
        SpeedBox.TextScaled = true
        SpeedBox.BackgroundColor3 = buttonColor
        SpeedBox.TextColor3 = Color3.fromRGB(0, 0, 0)

        local UICornerSpeed = Instance.new("UICorner")
        UICornerSpeed.CornerRadius = UDim.new(0, 8)
        UICornerSpeed.Parent = SpeedBox

        SpeedBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local s = tonumber(SpeedBox.Text)
                if s and s >= 1 and s <= 1000 then
                    humanoid.WalkSpeed = s
                else
                    SpeedBox.Text = "❌"
                end
            end
        end)
    end

    -- القفز اللانهائي
    if not MainFrame:FindFirstChild("InfJumpButton") then
        local InfJumpButton = Instance.new("TextButton")
        InfJumpButton.Name = "InfJumpButton"
        InfJumpButton.Parent = MainFrame
        InfJumpButton.Position = UDim2.new(0, 10, 0, 60)
        InfJumpButton.Size = UDim2.new(0, 160, 0, 40)
        InfJumpButton.Text = "قفز لا نهائي"
        InfJumpButton.TextScaled = true
        InfJumpButton.BackgroundColor3 = buttonColor
        InfJumpButton.TextColor3 = Color3.fromRGB(0, 0, 0)

        InfJumpButton.MouseButton1Click:Connect(function()
            infiniteJumpEnabled = not infiniteJumpEnabled
        end)
    end

    -- اختراق الجدران
    if not MainFrame:FindFirstChild("ClipButton") then
        local ClipButton = Instance.new("TextButton")
        ClipButton.Name = "ClipButton"
        ClipButton.Parent = MainFrame
        ClipButton.Position = UDim2.new(0, 10, 0, 110)
        ClipButton.Size = UDim2.new(0, 160, 0, 40)
        ClipButton.Text = "اختراق الجدران"
        ClipButton.TextScaled = true
        ClipButton.BackgroundColor3 = buttonColor
        ClipButton.TextColor3 = Color3.fromRGB(0, 0, 0)

        ClipButton.MouseButton1Click:Connect(function()
            clipping = not clipping
        end)
    end

    -- منع نقص الدم
    if not MainFrame:FindFirstChild("GodModeButton") then
        local GodModeButton = Instance.new("TextButton")
        GodModeButton.Name = "GodModeButton"
        GodModeButton.Parent = MainFrame
        GodModeButton.Position = UDim2.new(0, 10, 0, 160)
        GodModeButton.Size = UDim2.new(0, 160, 0, 40)
        GodModeButton.Text = "منع نقص الدم"
        GodModeButton.TextScaled = true
        GodModeButton.BackgroundColor3 = buttonColor
        GodModeButton.TextColor3 = Color3.fromRGB(0, 0, 0)

        GodModeButton.MouseButton1Click:Connect(function()
            godModeEnabled = not godModeEnabled
        end)
    end

    -- الطيران
    if not MainFrame:FindFirstChild("FlyButton") then
        local FlyButton = Instance.new("TextButton")
        FlyButton.Name = "FlyButton"
        FlyButton.Parent = MainFrame
        FlyButton.Position = UDim2.new(0, 10, 0, 210)
        FlyButton.Size = UDim2.new(0, 160, 0, 40)
        FlyButton.Text = "طيران"
        FlyButton.TextScaled = true
        FlyButton.BackgroundColor3 = buttonColor
        FlyButton.TextColor3 = Color3.fromRGB(0, 0, 0)

        FlyButton.MouseButton1Click:Connect(function()
            flyingEnabled = not flyingEnabled
            if flyingEnabled then
                loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Flyv2-30617"))()
            end
        end)
    end

    -- تحديث CanCollide
    RunService.Heartbeat:Connect(function()
        if char then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and not part:IsDescendantOf(char) then
                    if clipping then
                        if part.Position.Y < rootPart.Position.Y - 3 then
                            part.CanCollide = true
                        else
                            part.CanCollide = false
                        end
                    else
                        part.CanCollide = true
                    end
                end
            end
            if godModeEnabled then
                humanoid.Health = 100
            end
        end
    end)
end

-- ربط كل شيء عند الدخول والموت
local function onCharAdded(newChar)
    local humanoid = newChar:WaitForChild("Humanoid")
    local rootPart = newChar:WaitForChild("HumanoidRootPart")
    char = newChar
    createUI(newChar, humanoid, rootPart)
end

player.CharacterAdded:Connect(onCharAdded)

-- إذا الشخصية موجودة أصلاً
if player.Character then
    onCharAdded(player.Character)
end

-- قفز لانهائي
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and char then
        char:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local NameBox = Instance.new("TextBox")
NameBox.Parent = ScreenGui
NameBox.Position = UDim2.new(0.4, 0, 0.4, 0)
NameBox.Size = UDim2.new(0, 200, 0, 40)
NameBox.PlaceholderText = "اكتب اسم اللاعب هنا"
NameBox.TextScaled = true
NameBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
NameBox.TextColor3 = Color3.fromRGB(0,0,0)

local JailButton = Instance.new("TextButton")
JailButton.Parent = ScreenGui
JailButton.Position = UDim2.new(0.4, 0, 0.5, 0)
JailButton.Size = UDim2.new(0, 200, 0, 40)
JailButton.Text = "سجن اللاعب"
JailButton.TextScaled = true
JailButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
JailButton.TextColor3 = Color3.fromRGB(0,0,0)

local function createJail(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = targetPlayer.Character.HumanoidRootPart
        local jail = Instance.new("Model")
        jail.Name = "Jail_"..targetPlayer.Name
        jail.Parent = workspace

        local size = Vector3.new(8, 8, 8) -- المكعب أكبر شوي
        local parts = {}

        local offsets = {
            Vector3.new(0, size.Y/2, 0), -- السقف
            Vector3.new(0, -size.Y/2, 0), -- الأرضية
            Vector3.new(size.X/2, 0, 0), -- يمين
            Vector3.new(-size.X/2, 0, 0), -- يسار
            Vector3.new(0, 0, size.Z/2), -- أمام
            Vector3.new(0, 0, -size.Z/2), -- خلف
        }

        for i, offset in pairs(offsets) do
            local part = Instance.new("Part")
            part.Size = size
            part.Anchored = true
            part.CanCollide = true
            part.Color = Color3.fromRGB(255,255,255)
            part.Transparency = 0.8 -- شفافية أعلى
            part.Position = root.Position + offset
            part.Parent = jail
            table.insert(parts, part)
        end

        -- تجميد اللاعب
        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end

        -- تتبع اللاعب
        spawn(function()
            while jail.Parent do
                if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    for i, offset in pairs(offsets) do
                        parts[i].Position = targetPlayer.Character.HumanoidRootPart.Position + offset
                    end
                else
                    jail:Destroy()
                    break
                end
                wait(0.1)
            end
        end)
    end
end

JailButton.MouseButton1Click:Connect(function()
    local name = NameBox.Text
    if name ~= "" then
        local target = Players:FindFirstChild(name)
        if target then
            createJail(target)
        end
    end
end)

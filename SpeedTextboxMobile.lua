local player = game.Players.LocalPlayer
local Players = game:GetService("Players")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- التكست بوكس لكتابة اسم اللاعب
local NameBox = Instance.new("TextBox")
NameBox.Parent = ScreenGui
NameBox.Position = UDim2.new(0.4, 0, 0.4, 0)
NameBox.Size = UDim2.new(0, 200, 0, 40)
NameBox.PlaceholderText = "اكتب اسم اللاعب هنا"
NameBox.TextScaled = true
NameBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
NameBox.TextColor3 = Color3.fromRGB(0,0,0)

-- زر التفعيل
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

        local size = Vector3.new(6, 6, 6) -- حجم المكعب
        local offset = Vector3.new(0, size.Y/2, 0)

        local parts = {}
        local positions = {
            Vector3.new(0,0,0), -- الوسط
            Vector3.new(size.X/2,0,0),
            Vector3.new(-size.X/2,0,0),
            Vector3.new(0,0,size.Z/2),
            Vector3.new(0,0,-size.Z/2),
        }

        for i, pos in pairs(positions) do
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = true
            part.Size = size
            part.Position = root.Position + pos
            part.Transparency = 0.5
            part.Color = Color3.fromRGB(255,255,255)
            part.Parent = jail
            table.insert(parts, part)
        end
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

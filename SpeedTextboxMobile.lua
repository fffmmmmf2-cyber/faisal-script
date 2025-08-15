-- خدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- واجهة
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0,250,0,400)
frame.Position = UDim2.new(0,50,0,50)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)

-- ScrollFrame
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,-10,1,-10)
scroll.Position = UDim2.new(0,5,0,5)
scroll.BackgroundColor3 = Color3.fromRGB(30,30,30)
scroll.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout", scroll)
UIListLayout.Padding = UDim.new(0,5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- قائمة القدرات المفيدة
local abilities = {
    {Name="⚡ سرعة خارقة", Func=function() humanoid.WalkSpeed = 100 end},
    {Name="⬆ قفزة عالية", Func=function() humanoid.JumpPower = 120 end},
    {Name="🕊️ طيران", Func=function() humanoid.PlatformStand = true end},
    {Name="✖ إلغاء الطيران", Func=function() humanoid.PlatformStand = false end},
    {Name="👻 اختراق الجدران", Func=function()
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end},
    {Name="🛡️ تفعيل الجدار", Func=function()
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end},
    {Name="💨 مشي فوق الهواء", Func=function()
        local bodyVel = Instance.new("BodyVelocity", root)
        bodyVel.MaxForce = Vector3.new(0,4000,0)
        bodyVel.Velocity = Vector3.new(0,0,0)
        -- يمكن تحركه حسب مفاتيح الحركة
    end},
    {Name="🔄 إعادة ضبط", Func=function()
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        humanoid.PlatformStand = false
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end}
}

-- إنشاء الأزرار
for i, ability in ipairs(abilities) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.Text = ability.Name
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    
    btn.MouseButton1Click:Connect(function()
        ability.Func()
    end)
end

-- تحديث CanvasSize تلقائي
RunService.RenderStepped:Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y + 10)
end)

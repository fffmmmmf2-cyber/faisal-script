-- LocalPlayer
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- إنشاء ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GridGUI"
screenGui.Parent = playerGui

-- الإطار الرئيسي للمربع
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 260) -- صغر الحجم
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- اللون أسود
mainFrame.Parent = screenGui

-- دالة لإنشاء خانة صغيرة
local function createCell(parent, posX, posY)
    local cell = Instance.new("Frame")
    cell.Size = UDim2.new(0, 100, 0, 50) -- حجم أصغر
    cell.Position = UDim2.new(0, posX, 0, posY)
    cell.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- خانات داكنة سوداء
    cell.BorderSizePixel = 2
    cell.BorderColor3 = Color3.fromRGB(80, 80, 80) -- حدود خفيفة
    cell.Parent = parent
end

-- إنشاء 2x4 خانات صغيرة
for row = 0, 3 do
    for col = 0, 1 do
        createCell(mainFrame, col * 110, row * 60)
    end
end

-- زر فتح وإغلاق المربع
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0.5, -60, 1, 10)
toggleButton.Text = "فتح/إغلاق"
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui

local isOpen = true
toggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)

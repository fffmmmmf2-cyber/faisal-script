local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- إنشاء ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GridGUI"
screenGui.Parent = playerGui

-- الإطار الأسود الخلفية (الخلفية العامة للمربع)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 320) -- مناسب للجوال
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- دالة لإنشاء الخانات الصغيرة داخل الخلفية السوداء
local function createCell(parent, posX, posY)
    local cell = Instance.new("Frame")
    cell.Size = UDim2.new(0, 100, 0, 60) -- حجم مناسب للخلفية
    cell.Position = UDim2.new(0, posX, 0, posY)
    cell.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- خانة داكنة
    cell.BorderSizePixel = 2
    cell.BorderColor3 = Color3.fromRGB(80, 80, 80)
    cell.Parent = parent
end

-- إنشاء 2x4 خانات بشكل مرتب داخل الخلفية
for row = 0, 3 do
    for col = 0, 1 do
        createCell(mainFrame, col * 110, row * 70)
    end
end

-- زر فتح/إغلاق المربع
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 50)
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

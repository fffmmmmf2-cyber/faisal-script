-- LocalPlayer
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GridGUI"
screenGui.Parent = playerGui

-- الإطار الرئيسي للمربع (صغير جداً)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 120, 0, 160) -- صغير للجوال
mainFrame.Position = UDim2.new(0.5, -60, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- أسود
mainFrame.Parent = screenGui

-- دالة لإنشاء خانة صغيرة جدًا
local function createCell(parent, posX, posY)
    local cell = Instance.new("Frame")
    cell.Size = UDim2.new(0, 50, 0, 30) -- حجم مناسب للجوال
    cell.Position = UDim2.new(0, posX, 0, posY)
    cell.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- داكن
    cell.BorderSizePixel = 1
    cell.BorderColor3 = Color3.fromRGB(80, 80, 80)
    cell.Parent = parent
end

-- إنشاء 2x4 خانات صغيرة جدًا
for row = 0, 3 do
    for col = 0, 1 do
        createCell(mainFrame, col * 60, row * 40)
    end
end

-- زر فتح/إغلاق صغير
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 80, 0, 30)
toggleButton.Position = UDim2.new(0.5, -40, 1, 10)
toggleButton.Text = "فتح/إغلاق"
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui

local isOpen = true
toggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)

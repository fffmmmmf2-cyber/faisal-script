-- LocalPlayer
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GridGUI"
screenGui.Parent = playerGui

-- الإطار الرئيسي للمربع (ضعف الحجم السابق)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 320) -- ضعف الحجم السابق
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- أسود
mainFrame.Parent = screenGui

-- دالة لإنشاء خانة أكبر
local function createCell(parent, posX, posY)
    local cell = Instance.new("Frame")
    cell.Size = UDim2.new(0, 100, 0, 60) -- ضعف الحجم السابق
    cell.Position = UDim2.new(0, posX, 0, posY)
    cell.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- داكن
    cell.BorderSizePixel = 2
    cell.BorderColor3 = Color3.fromRGB(80, 80, 80)
    cell.Parent = parent
end

-- إنشاء 2x4 خانات أكبر
for row = 0, 3 do
    for col = 0, 1 do
        createCell(mainFrame, col * 120, row * 80)
    end
end

-- زر فتح/إغلاق أكبر
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

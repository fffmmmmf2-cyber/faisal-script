-- LocalPlayer
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- إنشاء ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GridGUI"
screenGui.Parent = playerGui

-- إنشاء الإطار الرئيسي للمربع
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 480) -- مناسب لـ 2x4 خانات
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
mainFrame.Parent = screenGui

-- دالة لإنشاء خانة
local function createCell(parent, posX, posY)
    local cell = Instance.new("Frame")
    cell.Size = UDim2.new(0, 200, 0, 100) -- كل خانة أعرض
    cell.Position = UDim2.new(0, posX, 0, posY)
    cell.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    cell.BorderSizePixel = 2
    cell.Parent = parent
end

-- إنشاء 2x4 خانات
for row = 0, 3 do
    for col = 0, 1 do
        createCell(mainFrame, col * 210, row * 120)
    end
end

-- إنشاء زر فتح وإغلاق المربع
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(0.5, -60, 1, 10)
toggleButton.Text = "فتح/إغلاق المربع"
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
toggleButton.Parent = screenGui

local isOpen = true
toggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)

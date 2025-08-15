local player = game.Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- زر الإظهار/الإخفاء
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 12, 0, 12)
ToggleButton.Text = ""
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ToggleButton.Active = true
ToggleButton.Draggable = true

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 25)
UICornerBtn.Parent = ToggleButton

-- المربع الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 200)
MainFrame.Position = UDim2.new(0.5, -100, 0.3, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

local visible = true
ToggleButton.MouseButton1Click:Connect(function()
    visible = not visible
    MainFrame.Visible = visible
    ToggleButton.BackgroundColor3 = visible and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- إنشاء شبكة 4x4
local gridRows, gridCols = 4, 4
local padding = 5
local cellSize = (MainFrame.Size.X.Offset - padding * (gridCols + 1)) / gridCols

for i = 0, gridRows - 1 do
    for j = 0, gridCols - 1 do
        local cell = Instance.new("Frame")
        cell.Parent = MainFrame
        cell.Size = UDim2.new(0, cellSize, 0, cellSize)
        cell.Position = UDim2.new(0, padding + j * (cellSize + padding), 0, padding + i * (cellSize + padding))
        cell.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        local UICornerCell = Instance.new("UICorner")
        UICornerCell.CornerRadius = UDim.new(0, 4)
        UICornerCell.Parent = cell
    end
end

-- خدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")

-- واجهة
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 400)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", scroll)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- دالة تحديث القائمة
local function updateList()
    scroll:ClearAllChildren()
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    local yOffset = 0
    
    -- هنا تختار من وين تجيب الأسماء
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Position = UDim2.new(0, 5, 0, yOffset)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            
            btn.MouseButton1Click:Connect(function()
                local targetChar = p.Character
                if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                    rootPart.CFrame = targetChar.HumanoidRootPart.CFrame
                end
            end)
            
            yOffset = yOffset + 35
        end
    end
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- تحديث تلقائي كل ثانية
RunService.RenderStepped:Connect(updateList)

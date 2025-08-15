-- خدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")

-- واجهة
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0,300,0,400)
frame.Position = UDim2.new(0,50,0,50)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BorderSizePixel = 0

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,-10,1,-10)
scroll.Position = UDim2.new(0,5,0,5)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout", scroll)
UIListLayout.Padding = UDim.new(0,5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- تحديث القائمة كل ثانية
local function updateList()
    scroll:ClearAllChildren()
    local yOffset = 0

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            -- Container لكل لاعب
            local container = Instance.new("Frame", scroll)
            container.Size = UDim2.new(1,-10,0,35)
            container.Position = UDim2.new(0,5,0,yOffset)
            container.BackgroundTransparency = 1

            -- زر الاسم
            local nameLabel = Instance.new("TextLabel", container)
            nameLabel.Size = UDim2.new(0.4,0,1,0)
            nameLabel.Position = UDim2.new(0,0,0,0)
            nameLabel.Text = p.Name
            nameLabel.BackgroundColor3 = Color3.fromRGB(70,70,70)
            nameLabel.TextColor3 = Color3.fromRGB(255,255,255)

            -- زر أخضر → ينقلك لعند اللاعب
            local goToBtn = Instance.new("TextButton", container)
            goToBtn.Size = UDim2.new(0.3,0,1,0)
            goToBtn.Position = UDim2.new(0.45,0,0,0)
            goToBtn.Text = "➡"
            goToBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
            goToBtn.TextColor3 = Color3.fromRGB(255,255,255)

            goToBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    rootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end)

            -- زر أحمر → ينقل اللاعب لعندك
            local bringBtn = Instance.new("TextButton", container)
            bringBtn.Size = UDim2.new(0.25,0,1,0)
            bringBtn.Position = UDim2.new(0.75,0,0,0)
            bringBtn.Text = "⬅"
            bringBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
            bringBtn.TextColor3 = Color3.fromRGB(255,255,255)

            bringBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.CFrame = rootPart.CFrame
                end
            end)

            yOffset = yOffset + 40
        end
    end

    scroll.CanvasSize = UDim2.new(0,0,yOffset/scroll.AbsoluteSize.Y,0)
end

RunService.RenderStepped:Connect(updateList)

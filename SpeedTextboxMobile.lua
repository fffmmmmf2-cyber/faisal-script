-- LocalScript للجوال لإنشاء Part والتحكم فيه

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local workspace = game:GetService("Workspace")

-- إنشاء ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobilePartGUI"
screenGui.Parent = playerGui

-- زر إنشاء Part
local button = Instance.new("TextButton")
button.Size = UDim2.new(0,120,0,50)
button.Position = UDim2.new(1,-140,0.5,-25) -- يمين وسط الشاشة
button.Text = "إنشاء Part"
button.BackgroundColor3 = Color3.fromRGB(50,150,255)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Parent = screenGui

-- شريط السحب للتحكم بالحجم
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0,200,0,40)
sliderFrame.Position = UDim2.new(1,-220,0.6,0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(100,100,100)
sliderFrame.Parent = screenGui
sliderFrame.Visible = false

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0,180,0,10)
sliderBar.Position = UDim2.new(0,10,0,15)
sliderBar.BackgroundColor3 = Color3.fromRGB(200,200,200)
sliderBar.Parent = sliderFrame

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0,20,0,20)
knob.Position = UDim2.new(0,0,0,-5)
knob.BackgroundColor3 = Color3.fromRGB(255,0,0)
knob.Parent = sliderBar

-- متغير للاحتفاظ بالـPart
local myPart = nil
local dragging = false

-- إنشاء Part عند الضغط على الزر
button.MouseButton1Click:Connect(function()
    if not myPart then
        myPart = Instance.new("Part")
        myPart.Size = Vector3.new(4,1,4)
        if player.Character and player.Character.PrimaryPart then
            myPart.Position = player.Character.PrimaryPart.Position + Vector3.new(0,5,0)
        else
            myPart.Position = Vector3.new(0,5,0)
        end
        myPart.Anchored = true
        myPart.Color = Color3.fromRGB(255,0,0)
        myPart.Parent = workspace
        sliderFrame.Visible = true
    end
end)

-- لمس السلايدر
knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

knob.InputEnded:Connect(function(input)
    dragging = false
end)

knob.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local localPos = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X,0,sliderBar.AbsoluteSize.X)
        knob.Position = UDim2.new(0,localPos,0,-5)
        local scale = localPos/sliderBar.AbsoluteSize.X
        if myPart then
            myPart.Size = Vector3.new(1 + scale*10, 1 + scale*10, 1 + scale*10) -- تغيير الحجم متناسب
        end
    end
end)

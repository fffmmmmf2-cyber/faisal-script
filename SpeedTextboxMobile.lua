-- LocalScript: Advanced Mobile Studio-like Part Editor (تحت القدم)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

-- إنشاء ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileAdvancedStudioGUI"
screenGui.Parent = playerGui

-- زر إنشاء Part
local createButton = Instance.new("TextButton")
createButton.Size = UDim2.new(0,120,0,50)
createButton.Position = UDim2.new(1,-140,0.5,-25)
createButton.Text = "إنشاء Part"
createButton.BackgroundColor3 = Color3.fromRGB(50,150,255)
createButton.TextColor3 = Color3.fromRGB(255,255,255)
createButton.Parent = screenGui

-- جدول لحفظ كل Part وأدواته
local partTools = {}

-- دالة لإنشاء Handles حول Part
local function createHandles(part)
    local handles = {}

    local offsets = {
        right = Vector3.new(0.5,0,0),
        left = Vector3.new(-0.5,0,0),
        top = Vector3.new(0,0.5,0),
        bottom = Vector3.new(0,-0.5,0),
        front = Vector3.new(0,0,0.5),
        back = Vector3.new(0,0,-0.5),
    }

    for name, offset in pairs(offsets) do
        local handle = Instance.new("TextButton")
        handle.Size = UDim2.new(0,25,0,25)
        handle.Position = UDim2.new(0.5,0,0.5,0) -- سيتم تحديثه لاحقًا
        handle.AnchorPoint = Vector2.new(0.5,0.5)
        handle.BackgroundColor3 = Color3.fromRGB(255,255,0)
        handle.Text = ""
        handle.Parent = screenGui
        handles[name] = handle
    end
    return handles
end

-- دالة لتحديث موقع Handles على الشاشة
local function updateHandles(part, handles)
    local camera = workspace.CurrentCamera
    for name, handle in pairs(handles) do
        local offset = Vector3.new()
        if name=="right" then offset = Vector3.new(part.Size.X/2,0,0)
        elseif name=="left" then offset = Vector3.new(-part.Size.X/2,0,0)
        elseif name=="top" then offset = Vector3.new(0,part.Size.Y/2,0)
        elseif name=="bottom" then offset = Vector3.new(0,-part.Size.Y/2,0)
        elseif name=="front" then offset = Vector3.new(0,0,part.Size.Z/2)
        elseif name=="back" then offset = Vector3.new(0,0,-part.Size.Z/2)
        end
        local worldPos = part.Position + offset
        local screenPos, onScreen = camera:WorldToViewportPoint(worldPos)
        if onScreen then
            handle.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
            handle.Visible = true
        else
            handle.Visible = false
        end
    end
end

-- متغير لتتبع Handle الذي يتم سحبه
local draggingHandle = nil
local activePart = nil

-- دالة لإنشاء Part جديد أسفل قدمي اللاعب
local function createPart()
    local newPart = Instance.new("Part")
    newPart.Size = Vector3.new(4,4,4)

    if player.Character and player.Character.PrimaryPart then
        local footY = player.Character.PrimaryPart.Position.Y - player.Character.PrimaryPart.Size.Y/2
        newPart.Position = Vector3.new(player.Character.PrimaryPart.Position.X, footY - newPart.Size.Y/2, player.Character.PrimaryPart.Position.Z)
    else
        newPart.Position = Vector3.new(0,0,0)
    end

    newPart.Anchored = true
    newPart.Color = Color3.fromRGB(255,0,0)
    newPart.Parent = workspace

    local handles = createHandles(newPart)
    partTools[newPart] = handles

    activePart = newPart
end

-- عند الضغط على زر إنشاء Part
createButton.MouseButton1Click:Connect(function()
    createPart()
end)

-- لمس Handles
for _, handleGroup in pairs(partTools) do
    for name, handle in pairs(handleGroup) do
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingHandle = {part=activePart, side=name}
            end
        end)
        handle.InputEnded:Connect(function(input)
            draggingHandle = nil
        end)
    end
end

-- تحديث كل جزء في RenderStepped
RunService.RenderStepped:Connect(function()
    -- تحديث موقع كل Handles
    for part, handles in pairs(partTools) do
        updateHandles(part, handles)
    end

    -- التحكم بالسحب
    if draggingHandle then
        local part = draggingHandle.part
        local side = draggingHandle.side
        local delta = UserInputService:GetMouseDelta() -- أو TouchDelta
        local size = part.Size

        if side=="right" then size = size + Vector3.new(delta.X/10,0,0)
        elseif side=="left" then size = size + Vector3.new(-delta.X/10,0,0)
        elseif side=="top" then size = size + Vector3.new(0,delta.Y/10,0)
        elseif side=="bottom" then size = size + Vector3.new(0,-delta.Y/10,0)
        elseif side=="front" then size = size + Vector3.new(0,0,delta.X/10)
        elseif side=="back" then size = size + Vector3.new(0,0,-delta.X/10)
        end

        part.Size = Vector3.new(
            math.clamp(size.X,0.5,100),
            math.clamp(size.Y,0.5,100),
            math.clamp(size.Z,0.5,100)
        )
    end
end)

-- خدمات
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- إنشاء RemoteEvent تلقائي إذا مش موجود
local ChangeSizeEvent = ReplicatedStorage:FindFirstChild("ChangeSizeEvent")
if not ChangeSizeEvent then
    ChangeSizeEvent = Instance.new("RemoteEvent")
    ChangeSizeEvent.Name = "ChangeSizeEvent"
    ChangeSizeEvent.Parent = ReplicatedStorage
end

-- سكربت السيرفر (ServerScriptService) تلقائي
if game:GetService("RunService"):IsStudio() or game:GetService("RunService"):IsClient() then
    -- نسوي سيرفر سكربت مؤقت
    local ServerScriptService = game:GetService("ServerScriptService")
    if not ServerScriptService:FindFirstChild("AutoSizeServer") then
        local serverScript = Instance.new("Script")
        serverScript.Name = "AutoSizeServer"
        serverScript.Source = [[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChangeSizeEvent = ReplicatedStorage:WaitForChild("ChangeSizeEvent")

ChangeSizeEvent.OnServerEvent:Connect(function(player, scale)
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local clampedScale = math.clamp(scale, 0.2, 1)
            
            if not humanoid:FindFirstChild("BodyHeightScale") then
                local bhs = Instance.new("NumberValue")
                bhs.Name = "BodyHeightScale"
                bhs.Value = 1
                bhs.Parent = humanoid
            end
            if not humanoid:FindFirstChild("BodyWidthScale") then
                local bws = Instance.new("NumberValue")
                bws.Name = "BodyWidthScale"
                bws.Value = 1
                bws.Parent = humanoid
            end
            if not humanoid:FindFirstChild("BodyDepthScale") then
                local bds = Instance.new("NumberValue")
                bds.Name = "BodyDepthScale"
                bds.Value = 1
                bds.Parent = humanoid
            end

            humanoid.BodyHeightScale.Value = clampedScale
            humanoid.BodyWidthScale.Value = clampedScale
            humanoid.BodyDepthScale.Value = clampedScale
        end
    end
end)
]]
        serverScript.Parent = ServerScriptService
    end
end

-- إنشاء GUI تلقائي
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 50)
Frame.Position = UDim2.new(0.5, -110, 0.9, 0)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui

for i = 1, 10 do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 18, 0, 40)
    Button.Position = UDim2.new(0, (i-1)*20, 0, 0)
    Button.Text = tostring(i)
    Button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Button.Parent = Frame

    Button.MouseButton1Click:Connect(function()
        local scale = 1 - (i * 0.08)
        ChangeSizeEvent:FireServer(scale)
    end)
end

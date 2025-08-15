-- خدمات
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- إنشاء RemoteEvent تلقائي إذا مش موجود
local ChangeSizeEvent = ReplicatedStorage:FindFirstChild("ChangeSizeEvent")
if not ChangeSizeEvent then
    ChangeSizeEvent = Instance.new("RemoteEvent")
    ChangeSizeEvent.Name = "ChangeSizeEvent"
    ChangeSizeEvent.Parent = ReplicatedStorage
end

-- إنشاء ServerScript تلقائي إذا مش موجود
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
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local dummyName = player.Name.."_SizeDummy"
                local oldDummy = workspace:FindFirstChild(dummyName)
                if oldDummy then oldDummy:Destroy() end

                local dummy = character:Clone()
                dummy.Name = dummyName
                dummy.Parent = workspace
                dummy:SetPrimaryPartCFrame(character.PrimaryPart.CFrame)

                for _, part in pairs(dummy:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Size = part.Size * scale
                    end
                end
            end
        end
    end
end)
]]
    serverScript.Parent = ServerScriptService
end

-- إنشاء GUI
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
        
        -- يصغر جسمك عندك
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * scale
            end
        end
        
        -- يرسل للاعبين الآخرين
        ChangeSizeEvent:FireServer(scale)
    end)
end

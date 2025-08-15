-- سكربت واحد يتحكم بالـ GUI والطرد
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- إنشاء RemoteEvent للطرد إذا ما موجود
local KickEvent = ReplicatedStorage:FindFirstChild("KickEvent")
if not KickEvent then
    KickEvent = Instance.new("RemoteEvent")
    KickEvent.Name = "KickEvent"
    KickEvent.Parent = ReplicatedStorage
end

-- عند استلام طلب الطرد
KickEvent.OnServerEvent:Connect(function(playerWhoSent, targetName)
    local targetPlayer = Players:FindFirstChild(targetName)
    if targetPlayer and targetPlayer ~= playerWhoSent then
        targetPlayer:Kick("انقلع")
    end
end)

-- إنشاء GUI لكل لاعب عند دخول اللعبة
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        local playerGui = player:WaitForChild("PlayerGui")

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = playerGui

        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 200, 0, 100)
        MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
        MainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
        MainFrame.Parent = ScreenGui

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0,10)
        UICorner.Parent = MainFrame

        local TextBox = Instance.new("TextBox")
        TextBox.Size = UDim2.new(0, 180, 0, 30)
        TextBox.Position = UDim2.new(0,10,0,10)
        TextBox.PlaceholderText = "اكتب اسم اللاعب"
        TextBox.TextScaled = true
        TextBox.Parent = MainFrame

        local KickButton = Instance.new("TextButton")
        KickButton.Size = UDim2.new(0, 180, 0, 40)
        KickButton.Position = UDim2.new(0,10,0,50)
        KickButton.Text = "طرد"
        KickButton.TextScaled = true
        KickButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
        KickButton.TextColor3 = Color3.fromRGB(255,255,255)
        KickButton.Parent = MainFrame

        KickButton.MouseButton1Click:Connect(function()
            local targetName = TextBox.Text
            if targetName ~= "" then
                KickEvent:FireServer(targetName)
            end
        end)
    end)
end)

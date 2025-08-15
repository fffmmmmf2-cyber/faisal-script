-- خدمات
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local humanoidRoot = char:WaitForChild("HumanoidRootPart")

-- زر في الشاشة
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", screenGui)
btn.Size = UDim2.new(0,150,0,50)
btn.Position = UDim2.new(0,50,0,50)
btn.Text = "☠ شوف التأثير"
btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
btn.TextColor3 = Color3.fromRGB(255,255,255)

btn.MouseButton1Click:Connect(function()
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            -- نجعل الجزء يتحرك بشكل غريب
            spawn(function()
                for i = 1, 30 do
                    part.CFrame = part.CFrame * CFrame.new(
                        math.random(-2,2)/10,
                        math.random(-2,2)/10,
                        math.random(-2,2)/10
                    ) * CFrame.Angles(
                        math.rad(math.random(-15,15)),
                        math.rad(math.random(-15,15)),
                        math.rad(math.random(-15,15))
                    )
                    wait(0.05)
                end
            end)
        end
    end
end)

-- خدمات
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- زر لتفعيل التأثير
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", screenGui)
btn.Size = UDim2.new(0,150,0,50)
btn.Position = UDim2.new(0,50,0,50)
btn.Text = "🔮 تأثير التشوه"
btn.BackgroundColor3 = Color3.fromRGB(150,0,200)
btn.TextColor3 = Color3.fromRGB(255,255,255)

local active = false

btn.MouseButton1Click:Connect(function()
    active = not active
end)

-- تحديث مستمر
game:GetService("RunService").RenderStepped:Connect(function()
    if active then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                -- نحرك الجزء بشكل عشوائي قليل لكن نسبة لجسمك
                local offset = Vector3.new(
                    math.random(-20,20)/50,
                    math.random(-20,20)/50,
                    math.random(-20,20)/50
                )
                local rot = CFrame.Angles(
                    math.rad(math.random(-30,30)),
                    math.rad(math.random(-30,30)),
                    math.rad(math.random(-30,30))
                )
                part.CFrame = root.CFrame * CFrame.new(offset) * rot
            end
        end
    end
end)

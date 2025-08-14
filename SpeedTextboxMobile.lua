-- واجهة صغيرة للجوال: سرعة + طيران + اختراق الجدار
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- خدمات
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- زر الإخفاء/الإظهار (دائرة كبيرة)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 70, 0, 70)
ToggleButton.Position = UDim2.new(0, 12, 0, 12)
ToggleButton.Text = ""
ToggleButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
ToggleButton.Active = true
ToggleButton.Draggable = true

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0,35)
UICornerBtn.Parent = ToggleButton

-- المربع الصغير القابل للسحب
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0,180,0,220)
MainFrame.Position = UDim2.new(0.5, -90, 0.3, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0,12)
UICornerMain.Parent = MainFrame

local visible = true
ToggleButton.MouseButton1Click:Connect(function()
	visible = not visible
	MainFrame.Visible = visible
	ToggleButton.BackgroundColor3 = visible and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
end)

-- 1️⃣ السرعة
local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = MainFrame
SpeedBox.Position = UDim2.new(0,10,0,10)
SpeedBox.Size = UDim2.new(0,160,0,40)
SpeedBox.PlaceholderText = "1-100"
SpeedBox.Text = ""
SpeedBox.TextScaled = true
SpeedBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
SpeedBox.TextColor3 = Color3.fromRGB(255,255,255)

local UICornerSpeed = Instance.new("UICorner")
UICornerSpeed.CornerRadius = UDim.new(0,8)
UICornerSpeed.Parent = SpeedBox

SpeedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local s = tonumber(SpeedBox.Text)
		if s and s >=1 and s <=100 then
			if humanoid and humanoid.Parent then
				humanoid.WalkSpeed = s
			end
		else
			SpeedBox.Text = "❌"
		end
	end
end)

-- 2️⃣ الطيران (دائرة)
local FlyButton = Instance.new("TextButton")
FlyButton.Parent = MainFrame
FlyButton.Position = UDim2.new(0,60,0,60)
FlyButton.Size = UDim2.new(0,60,0,60)
FlyButton.Text = ""
FlyButton.BackgroundColor3 = Color3.fromRGB(200,0,0) -- أحمر في البداية
FlyButton.TextScaled = true

local UICornerFly = Instance.new("UICorner")
UICornerFly.CornerRadius = UDim.new(0,30)
UICornerFly.Parent = FlyButton

local flying = false
local flySpeed = 50
local bodyVelocity

FlyButton.MouseButton1Click:Connect(function()
	flying = not flying
	FlyButton.BackgroundColor3 = flying and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
	if flying then
		if char:FindFirstChild("HumanoidRootPart") then
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(400000,400000,400000)
			bodyVelocity.Velocity = Vector3.new(0,0,0)
			bodyVelocity.Parent = char.HumanoidRootPart
		end
	else
		if bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if flying and bodyVelocity and char:FindFirstChild("HumanoidRootPart") then
		local camCF = workspace.CurrentCamera.CFrame
		local moveDir = Vector3.new(0,0,0)
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
		if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * flySpeed else moveDir = Vector3.new(0,0,0) end
		bodyVelocity.Velocity = Vector3.new(moveDir.X,0,moveDir.Z)
	end
end)

-- 3️⃣ اختراق الجدار (لا يلمس الأرض)
local ClipButton = Instance.new("TextButton")
ClipButton.Parent = MainFrame
ClipButton.Position = UDim2.new(0,10,0,150)
ClipButton.Size = UDim2.new(0,160,0,40)
ClipButton.Text = "اختراق الجدار"
ClipButton.TextScaled = true
ClipButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
ClipButton.TextColor3 = Color3.fromRGB(255,255,255)

local UICornerClip = Instance.new("UICorner")
UICornerClip.CornerRadius = UDim.new(0,8)
UICornerClip.Parent = ClipButton

local clipping = false
ClipButton.MouseButton1Click:Connect(function()
	clipping = not clipping
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "Feet" then
			part.CanCollide = not clipping
		end
	end
end)

-- تحديث المرجع عند تولد اللاعب
player.CharacterAdded:Connect(function(newChar)
	humanoid = newChar:WaitForChild("Humanoid")
end)

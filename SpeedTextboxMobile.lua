-- سكربت واجهة الجوال للخانات الثلاثة (سرعة - طيران - اختراق الجدار)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- إنشاء واجهة رئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- زر الإخفاء/الإظهار
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 62, 0, 62)
ToggleButton.Position = UDim2.new(0, 12, 0, 12)
ToggleButton.Text = "⚙"
ToggleButton.TextScaled = true
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Active = true
ToggleButton.Draggable = true

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0,14)
UICornerBtn.Parent = ToggleButton

-- واجهة الخانات الكبيرة (قابلة للسحب)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.3, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0,12)
UICornerMain.Parent = MainFrame

-- وظيفة تغيير لون الزر حسب حالة الواجهة
local visible = true
local function updateButtonColor()
	if visible then
		ToggleButton.BackgroundColor3 = Color3.fromRGB(0,200,0) -- أخضر
	else
		ToggleButton.BackgroundColor3 = Color3.fromRGB(200,0,0) -- أحمر
	end
end
updateButtonColor()

ToggleButton.MouseButton1Click:Connect(function()
	visible = not visible
	MainFrame.Visible = visible
	updateButtonColor()
end)

-- **الخانة 1: السرعة**
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = MainFrame
SpeedLabel.Position = UDim2.new(0,10,0,10)
SpeedLabel.Size = UDim2.new(0,230,0,25)
SpeedLabel.Text = "السرعة"
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextScaled = true

local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = MainFrame
SpeedBox.Position = UDim2.new(0,10,0,40)
SpeedBox.Size = UDim2.new(0,230,0,40)
SpeedBox.PlaceholderText = "1 - 100"
SpeedBox.Text = ""
SpeedBox.TextScaled = true
SpeedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
SpeedBox.TextColor3 = Color3.fromRGB(255,255,255)

local UICornerSpeed = Instance.new("UICorner")
UICornerSpeed.CornerRadius = UDim.new(0,8)
UICornerSpeed.Parent = SpeedBox

SpeedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local speed = tonumber(SpeedBox.Text)
		if speed and speed >= 1 and speed <= 100 then
			if humanoid and humanoid.Parent then
				humanoid.WalkSpeed = speed
			end
		else
			SpeedBox.Text = "❌"
		end
	end
end)

-- **الخانة 2: الطيران**
local FlyLabel = Instance.new("TextLabel")
FlyLabel.Parent = MainFrame
FlyLabel.Position = UDim2.new(0,10,0,90)
FlyLabel.Size = UDim2.new(0,230,0,25)
FlyLabel.Text = "الطيران"
FlyLabel.TextColor3 = Color3.fromRGB(255,255,255)
FlyLabel.BackgroundTransparency = 1
FlyLabel.TextScaled = true

local FlyButton = Instance.new("TextButton")
FlyButton.Parent = MainFrame
FlyButton.Position = UDim2.new(0,10,0,120)
FlyButton.Size = UDim2.new(0,230,0,40)
FlyButton.Text = "تشغيل/إيقاف الطيران"
FlyButton.TextScaled = true
FlyButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
FlyButton.TextColor3 = Color3.fromRGB(255,255,255)

local UICornerFlyBtn = Instance.new("UICorner")
UICornerFlyBtn.CornerRadius = UDim.new(0,8)
UICornerFlyBtn.Parent = FlyButton

local FlySpeedLabel = Instance.new("TextLabel")
FlySpeedLabel.Parent = MainFrame
FlySpeedLabel.Position = UDim2.new(0,10,0,170)
FlySpeedLabel.Size = UDim2.new(0,230,0,25)
FlySpeedLabel.Text = "سرعة الطيران"
FlySpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
FlySpeedLabel.BackgroundTransparency = 1
FlySpeedLabel.TextScaled = true

local FlySpeedBox = Instance.new("TextBox")
FlySpeedBox.Parent = MainFrame
FlySpeedBox.Position = UDim2.new(0,10,0,200)
FlySpeedBox.Size = UDim2.new(0,230,0,40)
FlySpeedBox.PlaceholderText = "1 - 100"
FlySpeedBox.Text = ""
FlySpeedBox.TextScaled = true
FlySpeedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
FlySpeedBox.TextColor3 = Color3.fromRGB(255,255,255)

local UICornerFlySpeed = Instance.new("UICorner")
UICornerFlySpeed.CornerRadius = UDim.new(0,8)
UICornerFlySpeed.Parent = FlySpeedBox

-- متغير الطيران
local flying = false
local flySpeed = 50

FlySpeedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local s = tonumber(FlySpeedBox.Text)
		if s and s >= 1 and s <= 100 then
			flySpeed = s
		else
			FlySpeedBox.Text = "❌"
		end
	end
end)

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local bodyVelocity

FlyButton.MouseButton1Click:Connect(function()
	flying = not flying
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
		moveDir = moveDir.Unit * flySpeed
		if moveDir.Magnitude ~= moveDir.Magnitude then moveDir = Vector3.new(0,0,0) end
		bodyVelocity.Velocity = Vector3.new(moveDir.X,0,moveDir.Z)
	end
end)

-- **الخانة 3: اختراق الجدار**
local ClipButton = Instance.new("TextButton")
ClipButton.Parent = MainFrame
ClipButton.Position = UDim2.new(0,10,0,250)
ClipButton.Size = UDim2.new(0,230,0,40)
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
	if clipping then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	else
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end)

-- تحديث المرجع إذا تولد اللاعب من جديد
player.CharacterAdded:Connect(function(newChar)
	humanoid = newChar:WaitForChild("Humanoid")
end)

-- LocalScript: TextLabels على كل بارتات الماب فقط

local workspace = game:GetService("Workspace")

-- دالة لإنشاء TextLabel على جانب Part
local function createLabel(part, offset, text)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,100,0,50)
    billboard.Adornee = part
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = offset
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,0,0)
    label.TextScaled = true
    label.Parent = billboard
end

-- تطبيق على كل بارت موجود في Workspace الآن
for _, part in pairs(workspace:GetDescendants()) do
    if part:IsA("BasePart") then
        createLabel(part, Vector3.new(part.Size.X/2,0,0), "زق زق زق زق") -- يمين
        createLabel(part, Vector3.new(-part.Size.X/2,0,0), "زق زق زق زق") -- يسار
        createLabel(part, Vector3.new(0,part.Size.Y/2,0), "زق زق زق زق") -- أعلى
        createLabel(part, Vector3.new(0,-part.Size.Y/2,0), "زق زق زق زق") -- أسفل
        createLabel(part, Vector3.new(0,0,part.Size.Z/2), "زق زق زق زق") -- أمام
        createLabel(part, Vector3.new(0,0,-part.Size.Z/2), "زق زق زق زق") -- خلف
    end
end

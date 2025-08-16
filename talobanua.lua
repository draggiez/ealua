--// Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// GUI Setup
local CoreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleTeleporter"
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.5, -125, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Talobanua"
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Tombol Teleport
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(1, -20, 0, 40)
teleportBtn.Position = UDim2.new(0, 10, 0, 40)
teleportBtn.Text = "Start Teleport"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 14
teleportBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleportBtn.Parent = frame
Instance.new("UICorner", teleportBtn).CornerRadius = UDim.new(0, 6)

-- Fungsi cek tanah
local function isGroundLoaded(targetPos, checkRadius)
	for _, part in ipairs(workspace:GetPartBoundsInRadius(targetPos, checkRadius)) do
		if part.CanCollide then
			return true
		end
	end
	return false
end

-- Fungsi Safe Teleport
local function safeTeleport(pos)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		-- tunggu sampai ada tanah termuat
		local tries = 0
		while not isGroundLoaded(pos, 10) and tries < 50 do
			task.wait(0.1)
			tries += 1
		end
		
		char:MoveTo(pos)
		task.wait(1) -- jeda sebentar biar stabil
	end
end

teleportBtn.MouseButton1Click:Connect(function()
	teleportBtn.Text = "Teleporting..."
	
	-- Koordinat target
	local coords = {
		Vector3.new(-3367.69, 4009.88, 3196.02),
		Vector3.new(-3633.83, 5056.50, 3706.65)
	}
	
	for _, pos in ipairs(coords) do
		safeTeleport(pos)
	end
	
	teleportBtn.Text = "Done!"
	task.delay(1.5, function()
		teleportBtn.Text = "Start Teleport"
	end)
end)

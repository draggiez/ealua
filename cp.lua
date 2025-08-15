--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

--// GUI Setup
local CoreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoordinateTeleporter"
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Coordinate Teleporter"
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

-- Label koordinat realtime
local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(1, -20, 0, 20)
coordLabel.Position = UDim2.new(0, 10, 0, 40)
coordLabel.Text = "Coordinates: Loading..."
coordLabel.BackgroundTransparency = 1
coordLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
coordLabel.Font = Enum.Font.Gotham
coordLabel.TextSize = 14
coordLabel.TextXAlignment = Enum.TextXAlignment.Left
coordLabel.Parent = frame

-- Tombol Copy
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 140, 0, 25)
copyBtn.Position = UDim2.new(0, 10, 0, 70)
copyBtn.Text = "Copy Coordinates"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 12
copyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
copyBtn.Parent = frame
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)

copyBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local pos = char.HumanoidRootPart.Position
		local coordString = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
		if setclipboard then
			setclipboard(coordString)
			copyBtn.Text = "Copied!"
			task.delay(1, function()
				copyBtn.Text = "Copy Coordinates"
			end)
		else
			copyBtn.Text = "Clipboard Not Supported"
			task.delay(1.5, function()
				copyBtn.Text = "Copy Coordinates"
			end)
		end
	end
end)

-- Input koordinat manual
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -20, 0, 25)
inputBox.Position = UDim2.new(0, 10, 0, 105)
inputBox.PlaceholderText = "Enter coordinates: X, Y, Z"
inputBox.Text = ""
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 12
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputBox.ClearTextOnFocus = false
inputBox.Parent = frame
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)

-- Tombol Safe Teleport
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(1, -20, 0, 25)
teleportBtn.Position = UDim2.new(0, 10, 0, 135)
teleportBtn.Text = "Safe Teleport"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 12
teleportBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleportBtn.Parent = frame
Instance.new("UICorner", teleportBtn).CornerRadius = UDim.new(0, 6)

local function isGroundLoaded(targetPos, checkRadius)
	for _, part in ipairs(workspace:GetPartBoundsInRadius(targetPos, checkRadius)) do
		if part.CanCollide and not part:IsDescendantOf(player.Character) then
			return true
		end
	end
	return false
end

teleportBtn.MouseButton1Click:Connect(function()
	local coords = {}
	for num in string.gmatch(inputBox.Text, "[-%d%.]+") do
		table.insert(coords, tonumber(num))
	end

	if #coords == 3 then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local targetPos = Vector3.new(coords[1], coords[2], coords[3])

			-- Tunggu sampai tanah di area tersebut termuat
			local tries = 0
			while not isGroundLoaded(targetPos, 10) and tries < 50 do
				task.wait(0.1)
				tries += 1
			end

			char:MoveTo(targetPos)
			teleportBtn.Text = "Teleported!"
			task.delay(1, function()
				teleportBtn.Text = "Safe Teleport"
			end)
		end
	else
		teleportBtn.Text = "Invalid Input"
		task.delay(1, function()
			teleportBtn.Text = "Safe Teleport"
		end)
	end
end)

-- Update koordinat realtime
RunService.RenderStepped:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local pos = char.HumanoidRootPart.Position
		coordLabel.Text = string.format("Coordinates: %.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
	end
end)

--// Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// Workspace checkpoints
local checkpointsFolder = workspace:WaitForChild("Checkpoints")
local summit = workspace:WaitForChild("SummitPart")

--// Simpan semua checkpoint ke dalam table
local checkpoints = {}
for i = 1, 5 do
	local cp = checkpointsFolder:WaitForChild("CP"..i):WaitForChild("TouchPart")
	table.insert(checkpoints, cp)
end
table.insert(checkpoints, summit)

--// FireTouch function
local function fireTouch(part1, part2)
	firetouchinterest(part1, part2, 0)
	firetouchinterest(part1, part2, 1)
end

--// GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheckpointGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0, 20, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = screenGui

-- header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
header.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Checkpoint Toucher"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.Parent = header

-- minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 1, 0)
minBtn.Position = UDim2.new(1, -60, 0, 0)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 14
minBtn.Parent = header

-- content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1
content.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
listLayout.Parent = content

-- tombol Start
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1, -10, 0, 30)
startBtn.Text = "Start Loop"
startBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.SourceSansBold
startBtn.TextSize = 16
startBtn.Parent = content

-- tombol Stop
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, -10, 0, 30)
stopBtn.Text = "Stop Loop"
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 60)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 16
stopBtn.Parent = content

-- log box (1 baris)
local logBox = Instance.new("TextLabel")
logBox.Size = UDim2.new(1, -10, 0, 30)
logBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
logBox.TextColor3 = Color3.new(1,1,1)
logBox.Font = Enum.Font.Code
logBox.TextSize = 14
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Center
logBox.Text = "Log: Ready"
logBox.Parent = content

-- loop state
local loopRunning = false

-- fungsi loop
local function runLoop()
	loopRunning = true
	while loopRunning do
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")

		for _, cp in ipairs(checkpoints) do
			if not loopRunning then break end
			fireTouch(hrp, cp)

			local msg = "FireTouch ke " .. (cp.Parent.Name or cp.Name)
			print(msg)
			logBox.Text = msg

			task.wait(1) -- delay antar CP
		end
	end
end

-- event button
startBtn.MouseButton1Click:Connect(function()
	if not loopRunning then
		task.spawn(runLoop)
	end
end)

stopBtn.MouseButton1Click:Connect(function()
	loopRunning = false
	logBox.Text = "Loop dihentikan"
end)

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
	content.Visible = not content.Visible
end)

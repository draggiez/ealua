-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

--// Workspace checkpoints
local checkpointsFolder = workspace:FindFirstChild("Checkpoints")
local summit = workspace:FindFirstChild("SummitPart")

-- Fungsi FireTouch
local function fireTouch(part1, part2)
	firetouchinterest(part1, part2, 0)
	firetouchinterest(part1, part2, 1)
end

local function killCharacter()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
        print("Karakter dibunuh paksa, respawn...")
    end
end

--// GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheckpointGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0, 20, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "Checkpoint Toucher"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.5, -15, 0, 30)
startBtn.Position = UDim2.new(0, 10, 0, 40)
startBtn.Text = "Start Loop"
startBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.SourceSansBold
startBtn.TextSize = 16
startBtn.Parent = frame

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.5, -15, 0, 30)
stopBtn.Position = UDim2.new(0.5, 5, 0, 40)
stopBtn.Text = "Stop Loop"
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 60)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 16
stopBtn.Parent = frame

local logBox = Instance.new("TextLabel")
logBox.Size = UDim2.new(1, -20, 0, 30)
logBox.Position = UDim2.new(0, 10, 0, 90)
logBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
logBox.TextColor3 = Color3.new(1,1,1)
logBox.Font = Enum.Font.Code
logBox.TextSize = 14
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.Text = "Log: Ready"
logBox.Parent = frame

-- State loop
local loopRunning = false

-- Loop function
local function runLoop()
	loopRunning = true
	while loopRunning do
		
			-- CP1
			local cp1 = workspace:WaitForChild("Checkpoints"):WaitForChild("CP1"):WaitForChild("TouchPart") 
			fireTouch(hrp, cp1)
			local msg1 = "FireTouch ke " .. (cp1.Parent.Name or cp1.Name)
			logBox.Text = msg1
			killCharacter()
			task.wait(5)
			
			-- CP2
			local cp2 = workspace:WaitForChild("Checkpoints"):WaitForChild("CP2"):WaitForChild("TouchPart") 
			fireTouch(hrp, cp2)
			local msg2 = "FireTouch ke " .. (cp2.Parent.Name or cp2.Name)
			logBox.Text = msg2
			killCharacter()
			task.wait(5)
		
			-- CP3
			local cp3 = workspace:WaitForChild("Checkpoints"):WaitForChild("CP3"):WaitForChild("TouchPart") 
			fireTouch(hrp, cp3)
			local msg3 = "FireTouch ke " .. (cp3.Parent.Name or cp3.Name)
			logBox.Text = msg3
			killCharacter()
			task.wait(5)

			-- CP4
			local cp4 = workspace:WaitForChild("Checkpoints"):WaitForChild("CP4"):WaitForChild("TouchPart") 
			fireTouch(hrp, cp4)
			local msg4 = "FireTouch ke " .. (cp4.Parent.Name or cp4.Name)
			logBox.Text = msg4
			killCharacter()
			task.wait(5)

			-- CP5
			local cp5 = workspace:WaitForChild("Checkpoints"):WaitForChild("CP5"):WaitForChild("TouchPart") 
			fireTouch(hrp, cp5)
			local msg5 = "FireTouch ke " .. (cp5.Parent.Name or cp5.Name)
			logBox.Text = msg5
			killCharacter()
			task.wait(5)

	end
end

-- Event tombol
startBtn.MouseButton1Click:Connect(function()
	if not loopRunning then
		task.spawn(runLoop)
	end
end)

stopBtn.MouseButton1Click:Connect(function()
	loopRunning = false
	logBox.Text = "Loop dihentikan"
end)

-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// Workspace checkpoints
local checkpointsFolder = workspace:FindFirstChild("Checkpoints")
local summit = workspace:FindFirstChild("SummitPart")

-- Kumpulin CP (hanya yang ada)
local checkpoints = {}
if checkpointsFolder then
	for i = 1, 5 do
		local cp = checkpointsFolder:FindFirstChild("CP"..i)
		if cp and cp:FindFirstChild("TouchPart") then
			table.insert(checkpoints, cp.TouchPart)
			print("✅ Masukin", cp.Name)
		else
			warn("⚠️ CP"..i.." atau TouchPart tidak ketemu, dilewati")
		end
	end
end
if summit then
	table.insert(checkpoints, summit)
	print("✅ SummitPart dimasukkan")
end

-- Fungsi FireTouch
local function fireTouch(part1, part2)
	firetouchinterest(part1, part2, 0)
	firetouchinterest(part1, part2, 1)
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
-- Fungsi untuk ambil checkpoints terbaru
local function getCheckpoints()
	local cps = {}
	local folder = workspace:FindFirstChild("Checkpoints")
	if folder then
		for i = 1, 5 do
			local cp = folder:FindFirstChild("CP"..i)
			if cp and cp:FindFirstChild("TouchPart") then
				table.insert(cps, cp.TouchPart)
			end
		end
	end
	local summit = workspace:FindFirstChild("SummitPart")
	if summit then
		table.insert(cps, summit)
	end
	return cps
end

-- Loop function
local function runLoop()
	loopRunning = true

	for i = 1, 6 do -- 5 CP + Summit
		if not loopRunning then break end

		-- scan ulang CP
		local cps = getCheckpoints()
		local cp = cps[i]
		if cp then
			-- pastikan character ready
			local char = player.Character or player.CharacterAdded:Wait()
			local hrp = char:WaitForChild("HumanoidRootPart")

			-- sentuh CP
			fireTouch(hrp, cp)
			local msg = "Scan & Touch -> " .. (cp.Parent.Name or cp.Name)
			print(msg)
			logBox.Text = msg
		else
			logBox.Text = "⚠️ CP"..i.." tidak ditemukan"
			warn("Checkpoint "..i.." tidak ditemukan")
		end

		-- respawn setelah CP
		player:LoadCharacter()
		char.Humanoid.Health = 0
		logBox.Text = "Respawning..."
		print("Respawning...")

		-- tunggu karakter baru ready
		player.CharacterAdded:Wait()

		task.wait(1) -- jeda supaya stabil
	end

	loopRunning = false
	logBox.Text = "✅ Semua CP selesai discan"
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

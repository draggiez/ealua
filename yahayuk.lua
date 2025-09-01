--// Services
local Players = game:GetService("Players")

--// Player
local player = Players.LocalPlayer

--// Variabel
local loopRunning = false
local respawnWait = 1
local touchWait = 5
local runner
local minimized = false

--================= AUTO LEAVE PART =================--
local blacklist = {
  "KLT_KILAT", -- Bagus
  "YinnSTier", -- Yin
	"zyuuo00", -- Izaki
	"ziiKT7", -- Zii
	"dikaading", -- Akid
	"EclairEcr", -- Ecr
	"exARTHA", -- Artha
	"lelekrecing", -- Lelek
	"yudhaprihardana", -- Dika
	"sudrajad69",
	"sudrajad"
}

-- Player Join Listener
Players.PlayerAdded:Connect(function(p)
    if p ~= player and table.find(blacklist, p.Name) then
        warn("Keluar karena " .. p.Name .. " join!")
        player:Kick("Keluar karena " .. p.Name .. " join!") 
    end
end)

-- Cek Player yang sudah ada
local function cekPlayer()
	for _, p in pairs(Players:GetPlayers()) do
	    if p ~= player then
		    if table.find(blacklist, p.Name) then
        		addLog("Keluar karena " .. p.Name .. " join!", "🚨")
        		player:Kick("Keluar karena " .. p.Name .. " join!") -- kick ke menu	
			end
		end
	end
end	
--====================================================--
-- Fungsi Respawn
local function respawnAndWait()
	task.wait(respawnWait)
	if player and player.Character then
		local ok = pcall(function()
			player:LoadCharacter()
		end)
		if not ok then
			local char = player.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then hum.Health = 0 end
			end
		end
	else
		player.CharacterAdded:Wait()
	end
	local char = player.Character or player.CharacterAdded:Wait()
	char:WaitForChild("HumanoidRootPart")
	task.wait(2)
end

-- Fungsi FireTouch
local function touchPart(part)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	if part and part:IsA("BasePart") then
		firetouchinterest(hrp, part, 0)
		task.wait(0.1)
		firetouchinterest(hrp, part, 1)
	end
end

-- Fungsi Run Checkpoints
local function runCheckpoints()
	local checkpointsFolder = workspace:WaitForChild("Checkpoints")
	local summit = workspace:WaitForChild("SummitPart")

	local checkpoints = {}
	for i = 1, 5 do
		local cp = checkpointsFolder:WaitForChild("CP"..i):WaitForChild("TouchPart")
		table.insert(checkpoints, cp)
	end

	for i, cp in ipairs(checkpoints) do
		if not loopRunning then return end
		logLabel.Text = string.format("Touching CP%d...", i)
		touchPart(cp)
		task.wait(touchWait)
		respawnAndWait()
	end

	logLabel.Text = "Touching Summit..."
	touchPart(summit)
	respawnAndWait()
	logLabel.Text = "Finished cycle!"
end

--====================================================--
-- GUI SETUP
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "CheckpointGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0, 50, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "⚡ Checkpoint Runner"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local btnClose = Instance.new("TextButton", frame)
btnClose.Size = UDim2.new(0, 30, 0, 20)
btnClose.Position = UDim2.new(1, -35, 0, 5)
btnClose.Text = "X"
btnClose.TextColor3 = Color3.new(1,1,1)
btnClose.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
btnClose.Font = Enum.Font.GothamBold
btnClose.TextScaled = true
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 5)

-- Minimize Button
local btnMin = Instance.new("TextButton", frame)
btnMin.Size = UDim2.new(0, 30, 0, 20)
btnMin.Position = UDim2.new(1, -70, 0, 5)
btnMin.Text = "-"
btnMin.TextColor3 = Color3.new(1,1,1)
btnMin.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
btnMin.Font = Enum.Font.GothamBold
btnMin.TextScaled = true
Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0, 5)

-- Log Label
logLabel = Instance.new("TextLabel", frame)
logLabel.Size = UDim2.new(0.9, 0, 0, 30)
logLabel.Position = UDim2.new(0.05, 0, 0, 50)
logLabel.BackgroundTransparency = 1
logLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
logLabel.Font = Enum.Font.Gotham
logLabel.TextSize = 14
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.Text = "Press Start..."

-- Start/Stop Button
local btnStart = Instance.new("TextButton", frame)
btnStart.Size = UDim2.new(0.9, 0, 0, 35)
btnStart.Position = UDim2.new(0.05, 0, 0, 100)
btnStart.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
btnStart.TextColor3 = Color3.new(1,1,1)
btnStart.Font = Enum.Font.GothamBold
btnStart.TextScaled = true
btnStart.Text = "Start"
Instance.new("UICorner", btnStart).CornerRadius = UDim.new(0, 8)

--====================================================--
-- BUTTON HANDLERS

btnStart.MouseButton1Click:Connect(function()
	if loopRunning then
		loopRunning = false
		btnStart.Text = "Start"
		btnStart.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
		logLabel.Text = "Stopped."
	else
		loopRunning = true
		btnStart.Text = "Stop"
		btnStart.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		logLabel.Text = "Running..."
		runner = coroutine.create(function()
			while loopRunning do
				runCheckpoints()
			end
		end)
		coroutine.resume(runner)
	end
end)

btnClose.MouseButton1Click:Connect(function()
	loopRunning = false
	screenGui:Destroy()
end)

btnMin.MouseButton1Click:Connect(function()
	if minimized then
		frame.Size = UDim2.new(0, 280, 0, 180)
		minimized = false
	else
		frame.Size = UDim2.new(0, 280, 0, 40)
		minimized = true
	end
end)

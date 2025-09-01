--// Services
local Players = game:GetService("Players")

--// Player
local player = Players.LocalPlayer

--// Variables
local loopRunning = false
local respawnWait = 1
local touchWait = 5
local runner
local minimized = false
local logLabel

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
-- Respawn Function
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

-- FireTouch Function
local function touchPart(part)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	if part and part:IsA("BasePart") then
		firetouchinterest(hrp, part, 0)
		task.wait(0.1)
		firetouchinterest(hrp, part, 1)
	end
end

--====================================================--
-- GUI Setup
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "CheckpointGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 280, 0, 200)
frame.Position = UDim2.new(0, 50, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -70, 0, 30)
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
logLabel.Position = UDim2.new(0.05, 0, 0, 45)
logLabel.BackgroundTransparency = 1
logLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
logLabel.Font = Enum.Font.Gotham
logLabel.TextSize = 14
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.Text = "Press Start..."

-- Respawn Delay Input
local respawnLabel = Instance.new("TextLabel", frame)
respawnLabel.Size = UDim2.new(0.45, -10, 0, 20)
respawnLabel.Position = UDim2.new(0.05, 0, 0, 80)
respawnLabel.BackgroundTransparency = 1
respawnLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
respawnLabel.Font = Enum.Font.Gotham
respawnLabel.TextSize = 13
respawnLabel.Text = "Respawn Delay (s):"
respawnLabel.TextXAlignment = Enum.TextXAlignment.Left

local respawnInput = Instance.new("TextBox", frame)
respawnInput.Size = UDim2.new(0.4, 0, 0, 20)
respawnInput.Position = UDim2.new(0.52, 0, 0, 80)
respawnInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
respawnInput.TextColor3 = Color3.fromRGB(230, 230, 230)
respawnInput.Font = Enum.Font.Gotham
respawnInput.TextSize = 13
respawnInput.TextXAlignment = Enum.TextXAlignment.Center
respawnInput.Text = tostring(respawnWait)
respawnInput.ClearTextOnFocus = false
Instance.new("UICorner", respawnInput).CornerRadius = UDim.new(0, 5)

-- Touch Delay Input
local touchLabel = Instance.new("TextLabel", frame)
touchLabel.Size = UDim2.new(0.45, -10, 0, 20)
touchLabel.Position = UDim2.new(0.05, 0, 0, 105)
touchLabel.BackgroundTransparency = 1
touchLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
touchLabel.Font = Enum.Font.Gotham
touchLabel.TextSize = 13
touchLabel.Text = "Touch Delay (s):"
touchLabel.TextXAlignment = Enum.TextXAlignment.Left

local touchInput = Instance.new("TextBox", frame)
touchInput.Size = UDim2.new(0.4, 0, 0, 20)
touchInput.Position = UDim2.new(0.52, 0, 0, 105)
touchInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
touchInput.TextColor3 = Color3.fromRGB(230, 230, 230)
touchInput.Font = Enum.Font.Gotham
touchInput.TextSize = 13
touchInput.TextXAlignment = Enum.TextXAlignment.Center
touchInput.Text = tostring(touchWait)
touchInput.ClearTextOnFocus = false
Instance.new("UICorner", touchInput).CornerRadius = UDim.new(0, 5)

-- Start/Stop Button
local btnStart = Instance.new("TextButton", frame)
btnStart.Size = UDim2.new(0.9, 0, 0, 35)
btnStart.Position = UDim2.new(0.05, 0, 0, 140)
btnStart.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
btnStart.TextColor3 = Color3.new(1,1,1)
btnStart.Font = Enum.Font.GothamBold
btnStart.TextScaled = true
btnStart.Text = "Start"
Instance.new("UICorner", btnStart).CornerRadius = UDim.new(0, 8)

--====================================================--
-- BUTTON HANDLERS

respawnInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local val = tonumber(respawnInput.Text)
		if val and val >= 0 then
			respawnWait = val
			logLabel.Text = ("Respawn delay = %ds"):format(respawnWait)
		else
			respawnInput.Text = tostring(respawnWait)
		end
	end
end)

touchInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local val = tonumber(touchInput.Text)
		if val and val >= 0 then
			touchWait = val
			logLabel.Text = ("Touch delay = %ds"):format(touchWait)
		else
			touchInput.Text = tostring(touchWait)
		end
	end
end)

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
				logLabel.Text = "Touching CP1"
				local cp = workspace:WaitForChild("Checkpoints") 
				local cp1 = cp:WaitForChild("CP1"):WaitForChild("TouchPart") 
				local cp2 = cp:WaitForChild("CP2"):WaitForChild("TouchPart") 
				local cp3 = cp:WaitForChild("CP3"):WaitForChild("TouchPart") 
				local cp4 = cp:WaitForChild("CP4"):WaitForChild("TouchPart") 
				local cp5 = cp:WaitForChild("CP5"):WaitForChild("TouchPart") 
				local summit = workspace:WaitForChild("SummitPart")
				
				logLabel.Text = "Touching CP1"
				touchPart(cp1)
				task.wait(touchWait)
				respawnAndWait()
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
		frame.Size = UDim2.new(0, 280, 0, 200)
		minimized = false
	else
		frame.Size = UDim2.new(0, 280, 0, 40)
		minimized = true
	end
end)

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--// Player Setup
local player = Players.LocalPlayer

-- local teleportPos = Vector3.new(152.98, 82.87, 103.76)
local basePos = Vector3.new(61, 94, -113)
local teleportPos = CFrame.new(61, 93, -113)
local loopRunning = false

-- CP
local pos1 = Vector3.new(-782.99, 87.03, -650.32) -- cp1
local pos2 = Vector3.new(-985.72, 182.07, -81.32) -- cp2
local pos3 = Vector3.new(-952.87, 178.25, 809.87) -- cp3
local pos4 = Vector3.new(797.29, 184.63, 875.85)  -- cp4
local pos5 = Vector3.new(973.33, 97.97, 135.15)   -- cp5
local pos6 = Vector3.new(980.60, 112.06, -535.60) -- cp6
local pos7 = Vector3.new(402.23, 121.33, -229.17) -- cp7

-- Default
local tweenSpeed = 30
local touchDelay = 20

-- Lama nunggu di tiap titik (detik)
local renderWait = 2

--================= AUTO LEAVE PART =================--
-- [Blacklist]
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

-- [Player Join Listener]
Players.PlayerAdded:Connect(function(p)
    if p ~= player and table.find(blacklist, p.Name) then
        warn("Keluar karena " .. p.Name .. " join!")
        player:Kick("Keluar karena " .. p.Name .. " join!") 
    end
end)

-- [Get Player List]
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

--================= HRP =================--
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    return hrp, humanoid, char
end
--=============== KILL =================--
local function killCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end

--=============== TOUCH =================--
local function fireTouch(part1, part2)
	firetouchinterest(part1, part2, 0)
	task.wait(0.1)
	firetouchinterest(part1, part2, 1)
	task.wait(touchDelay)
end

--============== RENDER =================--
local function renderAtPosition(pos)
	local hrp = getHRP()
	local duration = renderWait  -- lama waktu render (detik)
    local startTime = tick()

    -- Loop per-frame
    while tick() - startTime < duration do
        RunService.RenderStepped:Wait()
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 10, 0))
    end
end

--============== TWEEN =================--
local function tweenHRP(hrp, targetCFrame)
	local tweenInfo = TweenInfo.new(tweenSpeed,  Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
end

--============== FREEZE ===============--
local function freezeCharacter()
	local hrp, humanoid = getHRP()
    hrp.Anchored = true
    humanoid.PlatformStand = true
end

local function unfreezeCharacter()
	local hrp, humanoid = getHRP()
    hrp.Anchored = false
    humanoid.PlatformStand = false
end

local rev = "✨ Ravika Push v1.1   "
--============ GUI ==================--
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheckpointGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0, 20, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = rev
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 10) -- geser kanan 10 pixel
padding.Parent = title

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

-- Tambahkan tombol Close dan Minimize
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
closeBtn.Parent = frame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = frame

-- Tween Speed Input
local tweenBox = Instance.new("TextBox")
tweenBox.Size = UDim2.new(0.5, -15, 0, 25)
tweenBox.Position = UDim2.new(0, 10, 0, 130)
tweenBox.PlaceholderText = "Tween Speed (detik)"
tweenBox.Text = tostring(tweenSpeed)
tweenBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tweenBox.TextColor3 = Color3.new(1,1,1)
tweenBox.Font = Enum.Font.Code
tweenBox.TextSize = 14
tweenBox.Parent = frame

-- Touch Delay Input
local touchBox = Instance.new("TextBox")
touchBox.Size = UDim2.new(0.5, -15, 0, 25)
touchBox.Position = UDim2.new(0.5, 5, 0, 130)
touchBox.PlaceholderText = "Touch Delay (detik)"
touchBox.Text = tostring(touchDelay)
touchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
touchBox.TextColor3 = Color3.new(1,1,1)
touchBox.Font = Enum.Font.Code
touchBox.TextSize = 14
touchBox.Parent = frame

-- State loop
local loopRunning = false

-- Loop function
local function runLoop()
	loopRunning = true
	while loopRunning do
		local hrp = getHRP()
		logBox.Text = "Teleporting"
		tweenHRP(hrp, teleportPos)
		task.wait(2)
		
		-- CP Function
		local function scanCheckpoint(cpName, pos, waitTime)
			while loopRunning do
				local cpFolder = workspace:FindFirstChild("CheckPoint")
				local cp = cpFolder and cpFolder:FindFirstChild(cpName)
				
				if cp and cp:IsA("BasePart") then
					local hrp = getHRP()
					logBox.Text = "FireTouch ke " .. cpName
					fireTouch(hrp, cp)
					break
				else
					logBox.Text = "Rendering " .. cpName
					freezeCharacter()
					renderAtPosition(pos)
					renderAtPosition(basePos)
					unfreezeCharacter()
					task.wait(1)
				end
			end
		end
		
		-- Pemanggilan satu-satu
		scanCheckpoint("CheckPoint1", pos1, 20)
		scanCheckpoint("CheckPoint2", pos2, 20)
		scanCheckpoint("CheckPoint3", pos3, 20)
		scanCheckpoint("CheckPoint4", pos4, 20)
		scanCheckpoint("CheckPoint5", pos5, 20)
		scanCheckpoint("CheckPoint6", pos6, 20)
		scanCheckpoint("CheckPoint7", pos7, 20)
		
		--=================================================================== SUMMIT
		hrp = getHRP()
		local summit = workspace:WaitForChild("CheckPoint"):WaitForChild("Summit") 
		fireTouch(hrp, summit)
		logBox.Text = "FireTouch ke Summit"
		task.wait(2)

		--=================================================================== SPAWN
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

-- Close GUI
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Minimize GUI (toggle frame visibility except title bar)
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in ipairs(frame:GetChildren()) do
        if child ~= title and child ~= closeBtn and child ~= minimizeBtn then
            child.Visible = not minimized
        end
    end
    -- Optional: adjust frame size when minimized
    if minimized then
        frame.Size = UDim2.new(0, 300, 0, 35)
    else
        frame.Size = UDim2.new(0, 300, 0, 180)
    end
end)

-- Make frame draggable
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragging and dragStart then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
end)

-- Update value pas di-enter
tweenBox.FocusLost:Connect(function(enter)
	if enter then
		local val = tonumber(tweenBox.Text)
		if val and val > 0 then
			tweenSpeed = val
			logBox.Text = "Tween Speed diubah ke " .. tweenSpeed
		else
			tweenBox.Text = tostring(tweenSpeed)
		end
	end
end)

touchBox.FocusLost:Connect(function(enter)
	if enter then
		local val = tonumber(touchBox.Text)
		if val and val > 0 then
			touchDelay = val
			logBox.Text = "Touch Delay diubah ke " .. touchDelay
		else
			touchBox.Text = tostring(touchDelay)
		end
	end
end)

task.spawn(function()
    while true do
		cekPlayer()
		task.wait(1)
	end
end)

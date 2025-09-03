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
	firetouchinterest(part1, part2, 1)
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
	local tweenInfo = TweenInfo.new(30,  Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
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

local rev = "Checkpoint touch v0.5.1 "
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
minimizeBtn.Text = "_"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = frame

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

		-- CP1
		logBox.Text = "Rendering"
		freezeCharacter()
		renderAtPosition(pos1)  -- tiap titik ditahan selama renderWait detik
		renderAtPosition(basePos)  -- tiap titik ditahan selama renderWait detik
		unfreezeCharacter()
		hrp = getHRP()
		local cp1 = workspace:WaitForChild("CheckPoint"):WaitForChild("CheckPoint1") 
		fireTouch(hrp, cp1)
		logBox.Text = "FireTouch ke " .. (cp1.Parent.Name or cp1.Name).."1"
		-- task.wait(20)
		killCharacter()
		task.wait(5)

		-- -- CP2
		-- logBox.Text = "Rendering"
		-- freezeCharacter()
		-- renderAtPosition(pos2)  -- tiap titik ditahan selama renderWait detik
		-- renderAtPosition(basePos)  -- tiap titik ditahan selama renderWait detik
		-- unfreezeCharacter()
		-- hrp = getHRP()
		-- local cp2 = workspace:WaitForChild("CheckPoint"):WaitForChild("CheckPoint2") 
		-- fireTouch(hrp, cp2)
		-- logBox.Text = "FireTouch ke " .. (cp2.Parent.Name or cp2.Name).."2"
		-- task.wait(20)
		
		-- -- CP3
		-- logBox.Text = "Rendering"
		-- freezeCharacter()
		-- renderAtPosition(pos3)  -- tiap titik ditahan selama renderWait detik
		-- renderAtPosition(basePos)  -- tiap titik ditahan selama renderWait detik
		-- unfreezeCharacter()
		-- hrp = getHRP()
		-- local cp3 = workspace:WaitForChild("CheckPoint"):WaitForChild("CheckPoint3") 
		-- fireTouch(hrp, cp3)
		-- logBox.Text = "FireTouch ke " .. (cp3.Parent.Name or cp3.Name).."3"
		-- task.wait(20)
		
		-- -- CP4
		-- logBox.Text = "Rendering"
		-- freezeCharacter()
		-- renderAtPosition(pos4)  -- tiap titik ditahan selama renderWait detik
		-- renderAtPosition(basePos)  -- tiap titik ditahan selama renderWait detik
		-- unfreezeCharacter()
		-- hrp = getHRP()
		-- local cp4 = workspace:WaitForChild("CheckPoint"):WaitForChild("CheckPoint4") 
		-- fireTouch(hrp, cp4)
		-- logBox.Text = "FireTouch ke " .. (cp4.Parent.Name or cp4.Name).."4"
		-- task.wait(20)
		
		-- -- CP5
		-- logBox.Text = "Rendering"
		-- freezeCharacter()
		-- renderAtPosition(pos5)  -- tiap titik ditahan selama renderWait detik
		-- renderAtPosition(basePos)  -- tiap titik ditahan selama renderWait detik
		-- unfreezeCharacter()
		-- hrp = getHRP()
		-- local cp5 = workspace:WaitForChild("CheckPoint"):WaitForChild("CheckPoint5") 
		-- fireTouch(hrp, cp5)
		-- logBox.Text = "FireTouch ke " .. (cp5.Parent.Name or cp5.Name).."5"
		-- task.wait(20)
		
		-- -- CP6
		-- logBox.Text = "Rendering"
		-- freezeCharacter()
		-- renderAtPosition(pos6)  -- tiap titik ditahan selama renderWait detik
		-- renderAtPosition(basePos)  -- tiap titik ditahan selama renderWait detik
		-- unfreezeCharacter()
		-- hrp = getHRP()
		-- local cp6 = workspace:WaitForChild("CheckPoint"):WaitForChild("CheckPoint6") 
		-- fireTouch(hrp, cp6)
		-- logBox.Text = "FireTouch ke " .. (cp6.Parent.Name or cp6.Name).."6"
		-- task.wait(20)
		
		-- -- CP7
		-- logBox.Text = "Rendering"
		-- freezeCharacter()
		-- renderAtPosition(pos7)  -- tiap titik ditahan selama renderWait detik
		-- renderAtPosition(basePos)  -- tiap titik ditahan selama renderWait detik
		-- unfreezeCharacter()
		-- hrp = getHRP()
		-- local cp7 = workspace:WaitForChild("CheckPoint"):WaitForChild("CheckPoint7") 
		-- fireTouch(hrp, cp7)
		-- logBox.Text = "FireTouch ke " .. (cp7.Parent.Name or cp7.Name).."7"
		-- task.wait(20)
		
		-- -- Summit
		-- hrp = getHRP()
		-- local summit = workspace:WaitForChild("CheckPoint"):WaitForChild("Summit") 
		-- fireTouch(hrp, summit)
		-- logBox.Text = "FireTouch ke Summit"
		-- task.wait(2)
		-- killCharacter()
		-- task.wait(5)
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

task.spawn(function()
    while true do
		cekPlayer()
		task.wait(1)
	end
end)

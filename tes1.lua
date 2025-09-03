--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--// Player Setup
local player = Players.LocalPlayer

-- local teleportPos = Vector3.new(152.98, 82.87, 103.76)
local loopRunning = false
local tweenSpeed = 0.5

-- CP
local pos1 = CFrame.new(284.17, 14.01, 318.61)
local pos2 = CFrame.new(208.22, 50.83, 456.21)
local pos3 = CFrame.new(-28.80, 54.71, 315.69)
local pos4 = CFrame.new(-332.00, 65.60, 214.00)
local pos5 = CFrame.new(-592.00, 99.76, -78.00)
local pos6 = CFrame.new(-992.00, 99.50, -4.00)
local pos7 = CFrame.new(-1464.00, 126.45, 318.00)
local pos8 = CFrame.new(-1648.14, 203.53, 167.78)
local summit = CFrame.new(-2011.51, 289.82, 84.62)

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

--============== TWEEN =================--
local function tweenHRP(hrp, targetCFrame)
	local tweenInfo = TweenInfo.new(tweenSpeed,  Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
end

local rev = "✨ Mount Momo v0.1  "
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

local positions = {
    pos1, pos2, pos3, pos4,
    pos5, pos6, pos7, pos8
}

-- State loop
local loopRunning = false

-- Loop function
local function runLoop()
	loopRunning = true
	while loopRunning do
    
    --=================================================================== BEGIN
		local hrp = getHRP()
		
		-- looping tiap posisi
		for i, pos in ipairs(positions) do
		    hrp = getHRP()
			logBox.Text = "Pos" .. i
		    tweenHRP(hrp, pos)
		    task.wait(1)
		end
    
    	hrp = getHRP()
    	logBox.Text = "To Summit"
		tweenHRP(hrp, summit)
		task.wait(1)

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

task.spawn(function()
    while true do
		cekPlayer()
		task.wait(1)
	end
end)

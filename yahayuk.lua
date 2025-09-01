-- LocalScript (StarterPlayerScripts)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// Workspace checkpoints
local checkpointsFolder = workspace:FindFirstChild("Checkpoints")

-- Fungsi FireTouch
local function fireTouch(part1, part2)
	firetouchinterest(part1, part2, 0)
	firetouchinterest(part1, part2, 1)
end

local function killCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
        print("Karakter dibunuh paksa, respawn...")
    end
end

local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart"), char
end

local function tweenHRP(hrp, targetCFrame)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait() -- tunggu selesai sebelum lanjut
end

--================= AUTO LEAVE PART =================--
local blacklist = {
    "kigenteji", 
    "Parasite954", 
	"gynessey",
	"8ululf",
	"nevada233445", 
	"FERNRIRSTARBOY999",
	"GAV1NSKIE", 
	"NotHuman1149", 
	"WakRians88",
	"OwenLeins",
	"Ramoy_0404"
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
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

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
			logBox.Text = "Teleporting"
			local hrp, char = getHRP()
	       	tweenHRP(hrp, CFrame.new(-92.47, 48.39, 116.86))
		
			-- CP1
			task.wait(10)
			hrp, char = getHRP()
			local cp1 = workspace:WaitForChild("Checkpoints"):WaitForChild("CP1"):WaitForChild("TouchPart") 
			fireTouch(hrp, cp1)
			logBox.Text = "FireTouch ke " .. (cp1.Parent.Name or cp1.Name)
			task.wait(60)
			
			-- CP2
			hrp, char = getHRP()
			local cp2 = workspace:WaitForChild("Checkpoints"):WaitForChild("CP2"):WaitForChild("TouchPart") 
			fireTouch(hrp, cp2)
			logBox.Text = "FireTouch ke " .. (cp2.Parent.Name or cp2.Name)
			task.wait(30)
		
			-- CP3
			hrp, char = getHRP()
			local cp3 = workspace:WaitForChild("Checkpoints"):WaitForChild("CP3"):WaitForChild("TouchPart") 
			fireTouch(hrp, cp3)
			logBox.Text = "FireTouch ke " .. (cp3.Parent.Name or cp3.Name)
			task.wait(30)

			-- CP4
			hrp, char = getHRP()
			local cp4 = workspace:WaitForChild("Checkpoints"):WaitForChild("CP4"):WaitForChild("TouchPart") 
			fireTouch(hrp, cp4)
			logBox.Text = "FireTouch ke " .. (cp4.Parent.Name or cp4.Name)
			task.wait(60)

			-- CP5
			hrp, char = getHRP()	
			local cp5 = workspace:WaitForChild("Checkpoints"):WaitForChild("CP5"):WaitForChild("TouchPart") 
			fireTouch(hrp, cp5)
			task.wait(2)
			logBox.Text = "FireTouch ke " .. (cp5.Parent.Name or cp5.Name)
			
			hrp, char = getHRP()
	       	tweenHRP(hrp, CFrame.new(-805.50, 379.81, -217.39))
			task.wait(60)
		
			-- Summit
			hrp, char = getHRP()	
			local summit = workspace:FindFirstChild("SummitPart")
			fireTouch(hrp, summit)
			logBox.Text = "FireTouch ke Summit"
			task.wait(2)
			killCharacter()
			task.wait(10)
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

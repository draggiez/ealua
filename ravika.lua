--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--// Player Setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- local teleportPos = Vector3.new(61, 93, -113)
local teleportPos = Vector3.new(152.98, 82.87, 103.76)
local loopRunning = false

-- CP
local checkpointsCamera = {
    Vector3.new(-782.99, 87.03, -650.32), -- cp1
    Vector3.new(-985.72, 182.07, -81.32), -- cp2
    Vector3.new(-952.87, 178.25, 809.87),-- cp3
    Vector3.new(797.29, 184.63, 875.85),-- cp4
    Vector3.new(973.33, 97.97, 135.15),-- cp5
	Vector3.new(980.60, 112.06, -535.60),-- cp6
	Vector3.new(402.23, 121.33, -229.17),-- cp7
}

-- Lama nunggu di tiap titik (detik)
local renderWait = 5

-- Default delay values (seconds)
local respawnWait = 2
local touchWait = 90

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

-- Respawn function with delay
local function respawnAndWait()
    task.wait(respawnWait)
    if player and player.Character then
        local success = pcall(function()
            player:LoadCharacter()
        end)
        if not success then
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
        end
    else
        player.CharacterAdded:Wait()
    end
    local char = player.Character or player.CharacterAdded:Wait()
    char:WaitForChild("HumanoidRootPart")
    task.wait(5)
end

local function touchPart(part)
    if part and part:IsA("BasePart") and hrp then
        -- mulai sentuh
        firetouchinterest(hrp, part, 0)
        task.wait(0.1)
        -- akhiri sentuh
        firetouchinterest(hrp, part, 1)
        return true
    end
    return false
end

-- Touch part with delay
-- local function touchPart(part)
--     if part and part:IsA("BasePart") then
--         local hrp, _ = getHRP()
--         if hrp then
--             firetouchinterest(hrp, part, 0)
-- 			task.wait(0.1)
--             firetouchinterest(hrp, part, 1)
--             return true
--         end
--     end
--     return false
-- end

local function renderAtPosition(pos, index, total)
    local flying = true
    local conn

    conn = RunService.RenderStepped:Connect(function()
        if flying then
            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 10, 0))
        end
    end)

    task.wait(renderWait)

    flying = false
    conn:Disconnect()
end

-- Run checkpoint + summit sequence
local function runCheckpoints()
    local checkpointsFolder = workspace:FindFirstChild("Checkpoints")
    if not checkpointsFolder then
        return false, "No 'Checkpoints' folder found!"
    end

    local checkpoints = {}
    for _, cp in pairs(checkpointsFolder:GetChildren()) do
        if cp:IsA("BasePart") and cp.Name:lower():find("checkpoint") then
            table.insert(checkpoints, cp)
        end
    end

    table.sort(checkpoints, function(a,b)
        local numA = tonumber(a.Name:match("%d+")) or 0
        local numB = tonumber(b.Name:match("%d+")) or 0
        return numA < numB
    end)
	
    for i, cp in ipairs(checkpoints) do
        touchPart(cp)
        task.spawn(function()
            logLabel.Text = string.format("Touched %s (%d/%d)", cp.Name, i, #checkpoints)
        end)
		task.wait(touchWait)
    end
	local summit = workspace:FindFirstChild("SummitTrigger")
	if summit and summit:IsA("BasePart") then
	    touchPart(summit)
		task.spawn(function()
			logLabel.Text = "SummitTrigger touched! Sequence complete."
		end)
		task.wait(0.5)
	else
		task.spawn(function()
			logLabel.Text = "SummitTrigger not found!"
		end)
	end	
    return true
end

local function freezeCharacter()
    hrp.Anchored = true
    humanoid.PlatformStand = true
end

local function unfreezeCharacter()
    hrp.Anchored = false
    humanoid.PlatformStand = false
end

-- GUI Setup (Dark Mode)
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "GodGPT_LoopGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 260, 0, 160)
frame.Position = UDim2.new(0, 0, 0, 130)
frame.AnchorPoint = Vector2.new(0, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Name = "MainFrame"
frame.ClipsDescendants = true


local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

local titleShadow = Instance.new("TextLabel", frame)
titleShadow.Size = UDim2.new(1, -20, 0, 28)
titleShadow.Position = UDim2.new(0, 11, 0, 6)
titleShadow.BackgroundTransparency = 1
titleShadow.Text = "⚡ Ravika Push"
titleShadow.TextXAlignment = Enum.TextXAlignment.Left
titleShadow.TextColor3 = Color3.new(0, 0, 0)
titleShadow.TextTransparency = 0.6
titleShadow.TextScaled = true
titleShadow.Font = Enum.Font.GothamBold
titleShadow.ZIndex = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 28)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "⚡ Ravika Push"
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.ZIndex = 1

logLabel = Instance.new("TextLabel", frame)
logLabel.Size = UDim2.new(1, -20, 0, 28)
logLabel.Position = UDim2.new(0, 10, 0, 38)
logLabel.BackgroundTransparency = 1
logLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.Font = Enum.Font.Gotham
logLabel.TextSize = 15
logLabel.TextWrapped = true
logLabel.Text = "Press Start to begin..."

local btnStartStop = Instance.new("TextButton", frame)
btnStartStop.Size = UDim2.new(0.9, 0, 0, 30)
btnStartStop.Position = UDim2.new(0.05, 0, 0, 70)
btnStartStop.BackgroundColor3 = Color3.fromRGB(10, 130, 220)
btnStartStop.TextColor3 = Color3.new(1,1,1)
btnStartStop.Font = Enum.Font.GothamBold
btnStartStop.TextScaled = true
btnStartStop.Text = "Start"
btnStartStop.BorderSizePixel = 0
btnStartStop.ClipsDescendants = true
local btnCorner = Instance.new("UICorner", btnStartStop)
btnCorner.CornerRadius = UDim.new(0, 6)

local btnClose = Instance.new("TextButton", frame)
btnClose.Size = UDim2.new(0.15, 0, 0, 22)
btnClose.Position = UDim2.new(0.82, 0, 0, 6)
btnClose.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
btnClose.BackgroundTransparency = 0.15
btnClose.TextColor3 = Color3.new(1,1,1)
btnClose.Font = Enum.Font.GothamBold
btnClose.TextScaled = true
btnClose.Text = "X"
btnClose.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner", btnClose)
closeCorner.CornerRadius = UDim.new(0, 6)

local respawnLabel = Instance.new("TextLabel", frame)
respawnLabel.Size = UDim2.new(0.45, -10, 0, 18)
respawnLabel.Position = UDim2.new(0.05, 0, 0, 105)
respawnLabel.BackgroundTransparency = 1
respawnLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
respawnLabel.Font = Enum.Font.Gotham
respawnLabel.TextSize = 13
respawnLabel.Text = "Respawn Delay (s):"
respawnLabel.TextXAlignment = Enum.TextXAlignment.Left

local respawnInput = Instance.new("TextBox", frame)
respawnInput.Size = UDim2.new(0.4, 0, 0, 18)
respawnInput.Position = UDim2.new(0.52, 0, 0, 105)
respawnInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
respawnInput.TextColor3 = Color3.fromRGB(230, 230, 230)
respawnInput.Font = Enum.Font.Gotham
respawnInput.TextSize = 13
respawnInput.TextXAlignment = Enum.TextXAlignment.Center
respawnInput.Text = tostring(respawnWait)
respawnInput.ClearTextOnFocus = false
respawnInput.ClipsDescendants = true
local respawnCorner = Instance.new("UICorner", respawnInput)
respawnCorner.CornerRadius = UDim.new(0, 5)

local touchLabel = Instance.new("TextLabel", frame)
touchLabel.Size = UDim2.new(0.45, -10, 0, 18)
touchLabel.Position = UDim2.new(0.05, 0, 0, 125)
touchLabel.BackgroundTransparency = 1
touchLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
touchLabel.Font = Enum.Font.Gotham
touchLabel.TextSize = 13
touchLabel.Text = "Touch Delay (s):"
touchLabel.TextXAlignment = Enum.TextXAlignment.Left

local touchInput = Instance.new("TextBox", frame)
touchInput.Size = UDim2.new(0.4, 0, 0, 18)
touchInput.Position = UDim2.new(0.52, 0, 0, 125)
touchInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
touchInput.TextColor3 = Color3.fromRGB(230, 230, 230)
touchInput.Font = Enum.Font.Gotham
touchInput.TextSize = 13
touchInput.TextXAlignment = Enum.TextXAlignment.Center
touchInput.Text = tostring(touchWait)
touchInput.ClearTextOnFocus = false
touchInput.ClipsDescendants = true
local touchCorner = Instance.new("UICorner", touchInput)
touchCorner.CornerRadius = UDim.new(0, 5)

-- Update delay variables on input
respawnInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(respawnInput.Text)
        if val and val >= 0 then
            respawnWait = val
            task.spawn(function()
                logLabel.Text = ("Respawn delay set to %.2f seconds"):format(respawnWait)
            end)
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
            task.spawn(function()
                logLabel.Text = ("Touch delay set to %.2f seconds"):format(touchWait)
            end)
        else
            touchInput.Text = tostring(touchWait)
        end
    end
end)

local runner

btnStartStop.MouseButton1Click:Connect(function()
    if loopRunning then
        loopRunning = false
        btnStartStop.Text = "Start"
        task.spawn(function() logLabel.Text = "Loop stopped." end)
        runner = nil
    else
        loopRunning = true
        btnStartStop.Text = "Stop"
        runner = coroutine.create(function()
            while loopRunning do
				local start = workspace:FindFirstChild("StartTimeTrigger")
				if start and start:IsA("BasePart") then
	    			touchPart(start)
					task.spawn(function()
						logLabel.Text = "StartTimeTrigger touched! Sequence start."
					end)
					task.wait(0.5)
				else
					task.spawn(function()
						logLabel.Text = "StartTimeTrigger not found!"
					end)
				end

				task.wait(0.5)
                task.spawn(function() logLabel.Text = "Teleporting..." end)

				local tweenInfo = TweenInfo.new(
    				1, -- durasi (2 detik)
    				Enum.EasingStyle.Quad, -- gaya animasi
    				Enum.EasingDirection.Out
				)
				local goal = {CFrame = CFrame.new(teleportPos)}
                if hrp then
					local tween = TweenService:Create(hrp, tweenInfo, goal)
					tween.Completed:Connect(function()
    					print("Tween selesai!")
    					print("Posisi HRP baru:", hrp.Position)
    					print("CFrame HRP baru:", hrp.CFrame)
					end)
					tween:Play()
                else
                    task.spawn(function() logLabel.Text = "Waiting for character..." end)
                    char = player.Character or player.CharacterAdded:Wait()
                    char:WaitForChild("HumanoidRootPart")
                end
				
				local originalCFrame = hrp.CFrame
				freezeCharacter()
				for i, pos in ipairs(checkpointsCamera) do
    				renderAtPosition(pos)
				end
				unfreezeCharacter()		
				hrp.CFrame = originalCFrame
				
                task.spawn(function() logLabel.Text = "Waiting for Checkpoint to load..." end)
				task.wait(1)
				
				local checkpoints = {}
				while loopRunning do
				    local checkpointsFolder = workspace:FindFirstChild("Checkpoints")
				    if checkpointsFolder then
				        local allFound = true
				        checkpoints = {}
				        for i = 1, 7 do
				            local cp = checkpointsFolder:FindFirstChild("Checkpoint"..i)
				            if not cp then
				                allFound = false
				                break
				            end
				            checkpoints[i] = cp
				        end
				        if allFound then break end
				    end
				    task.wait(0.5)
				end
                task.spawn(function() logLabel.Text = "All Checkpoints found! Touching checkpoints..." end)
                local success, msg = pcall(runCheckpoints)
                if not success then
                    task.spawn(function() logLabel.Text = "Error: "..tostring(msg) end)
                end

				task.spawn(function() logLabel.Text = "Respawning..." end)
                respawnAndWait()
				
                task.spawn(function() logLabel.Text = "Cycle complete. Looping..." end)
                task.wait(0.5)
            end
        end)
        coroutine.resume(runner)
    end
end)

btnClose.MouseButton1Click:Connect(function()
    loopRunning = false
    runner = nil
    screenGui:Destroy()
end)

task.spawn(function()
    while true do
		cekPlayer()
		task.wait(1)
	end
end)

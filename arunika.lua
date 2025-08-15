local Players = game:GetService("Players")
local player = Players.LocalPlayer

local teleportPos = Vector3.new(104.05, 162.43, -39.15)
local loopRunning = false

-- Default delay values (seconds)
local respawnWait = 10
local touchWait = 2
local touchRadius = 25 -- radius touch (baru)

-- Utility to get HumanoidRootPart safely
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart"), char
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

-- Touch part with delay
local function touchPart(part)
    if part and part:IsA("BasePart") then
        local hrp, _ = getHRP()
        if hrp then
            firetouchinterest(hrp, part, 0)
            task.wait(0.1)
            firetouchinterest(hrp, part, 1)
            return true
        end
    end
    return false
end

-- Run checkpoint + summit sequence (modif: tambah radius touch)
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
        -- Touch part checkpoint langsung
        touchPart(cp)

        -- Tambahan: Touch semua part di radius
        local nearbyParts = workspace:GetPartBoundsInRadius(cp.Position, touchRadius)
        for _, part in ipairs(nearbyParts) do
            touchPart(part)
        end

        task.spawn(function()
            logLabel.Text = string.format("Touched %s + radius (%d/%d)", cp.Name, i, #checkpoints)
        end)
        task.wait(touchWait)
    end

    local summit = workspace:FindFirstChild("SummitTrigger")
    if summit and summit:IsA("BasePart") then
        touchPart(summit)
        local nearbyParts = workspace:GetPartBoundsInRadius(summit.Position, touchRadius)
        for _, part in ipairs(nearbyParts) do
            touchPart(part)
        end
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

-- GUI Setup (Dark Mode)
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "GodGPT_LoopGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 260, 0, 180) -- tinggi diperbesar
frame.Position = UDim2.new(0.5, -130, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Name = "MainFrame"
frame.ClipsDescendants = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

local titleShadow = Instance.new("TextLabel", frame)
titleShadow.Size = UDim2.new(1, -20, 0, 28)
titleShadow.Position = UDim2.new(0, 11, 0, 6)
titleShadow.BackgroundTransparency = 1
titleShadow.Text = "⚡ Arunika Push"
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
title.Text = "⚡ Arunika Push"
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

-- Respawn delay label & input
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
local respawnCorner = Instance.new("UICorner", respawnInput)
respawnCorner.CornerRadius = UDim.new(0, 5)

-- Touch delay label & input
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
local touchCorner = Instance.new("UICorner", touchInput)
touchCorner.CornerRadius = UDim.new(0, 5)

-- Touch radius label & input (baru)
local radiusLabel = Instance.new("TextLabel", frame)
radiusLabel.Size = UDim2.new(0.45, -10, 0, 18)
radiusLabel.Position = UDim2.new(0.05, 0, 0, 145)
radiusLabel.BackgroundTransparency = 1
radiusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
radiusLabel.Font = Enum.Font.Gotham
radiusLabel.TextSize = 13
radiusLabel.Text = "Touch Radius:"
radiusLabel.TextXAlignment = Enum.TextXAlignment.Left

local radiusInput = Instance.new("TextBox", frame)
radiusInput.Size = UDim2.new(0.4, 0, 0, 18)
radiusInput.Position = UDim2.new(0.52, 0, 0, 145)
radiusInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
radiusInput.TextColor3 = Color3.fromRGB(230, 230, 230)
radiusInput.Font = Enum.Font.Gotham
radiusInput.TextSize = 13
radiusInput.TextXAlignment = Enum.TextXAlignment.Center
radiusInput.Text = tostring(touchRadius)
radiusInput.ClearTextOnFocus = false
local radiusCorner = Instance.new("UICorner", radiusInput)
radiusCorner.CornerRadius = UDim.new(0, 5)

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

radiusInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(radiusInput.Text)
        if val and val >= 0 then
            touchRadius = val
            task.spawn(function()
                logLabel.Text = ("Touch radius set to %.2f studs"):format(touchRadius)
            end)
        else
            radiusInput.Text = tostring(touchRadius)
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
                task.spawn(function() logLabel.Text = "Teleporting..." end)
                local hrp, char = getHRP()
                if hrp then
                    hrp.CFrame = CFrame.new(teleportPos)
                else
                    task.spawn(function() logLabel.Text = "Waiting for character..." end)
                    char = player.Character or player.CharacterAdded:Wait()
                    char:WaitForChild("HumanoidRootPart")
                end

                task.spawn(function() logLabel.Text = "Waiting for Checkpoint5 to load..." end)
                local checkpointsFolder
                local cp5
                while loopRunning do
                    checkpointsFolder = workspace:FindFirstChild("Checkpoints")
                    if checkpointsFolder then
                        cp5 = checkpointsFolder:FindFirstChild("Checkpoint5")
                        if cp5 then break end
                    end
                    task.wait(0.5)
                end

                task.spawn(function() logLabel.Text = "Checkpoint5 found! Running checkpoints..." end)
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

--// Services
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

--// GUI Setup
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "TeleportGui"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 121) -- Tinggi diperkecil
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel")
title.Text = "Mount Daun Push"
title.Size = UDim2.new(1, -40, 0, 30) -- Tinggi title diperkecil
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16 -- Ukuran teks diperkecil
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 10, 0, 0)
title.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 3)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = mainFrame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
toggleButton.Position = UDim2.new(0.05, 0, 0, 35)
toggleButton.Text = "▶ START"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = mainFrame
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 8)

-- Log Label (maksimal 2 baris)
local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(0.9, 0, 0, 35) -- tinggi cukup untuk 2 baris
logLabel.Position = UDim2.new(0.05, 0, 0, 71)
logLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
logLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
logLabel.Font = Enum.Font.Gotham
logLabel.TextSize = 12
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.TextYAlignment = Enum.TextYAlignment.Top
logLabel.TextWrapped = true -- aktifkan word wrap
logLabel.Text = "💤 Siap digunakan..."
logLabel.Parent = mainFrame
Instance.new("UICorner", logLabel).CornerRadius = UDim.new(0, 8)

-- Fungsi Log
local function addLog(text, emoji)
    logLabel.Text = (emoji or "ℹ️") .. " " .. os.date("[%H:%M:%S] ") .. text
end

-- Antilag
game:GetService("RunService").RenderStepped:Connect(function()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and (obj.PrimaryPart and (player.Character and (player.Character.PrimaryPart and (player.Character.PrimaryPart.Position - obj.PrimaryPart.Position).Magnitude > 500))) then
            obj:Destroy()
        end
    end
end)

-- AntiIdle
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

-- Variabel kontrol
local running = false

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

-- Fungsi Game
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart"), char
end

local function waitForRespawn()
    if not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
        player.CharacterAdded:Wait()
        task.wait(4)
    end
end

local function isGroundLoaded(targetPos, checkRadius)
    for _, part in ipairs(workspace:GetPartBoundsInRadius(targetPos, checkRadius)) do
        if part.CanCollide and part:IsA("BasePart") and part.Anchored then
            return true
        end
    end
    return false
end

local function safeTeleport(pos)
    if not running then return end
    addLog("Teleport ke " .. tostring(pos), "📍")
    waitForRespawn()
    local hrp, char = getHRP()
    local humanoid = char:WaitForChild("Humanoid")

    pcall(function()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end)

    local platform = Instance.new("Part")
    platform.Anchored = true
    platform.Size = Vector3.new(10, 1, 10)
    platform.Position = pos + Vector3.new(0, 3, 0)
    platform.Transparency = 1
    platform.CanCollide = true
    platform.Parent = workspace

    hrp.CFrame = platform.CFrame + Vector3.new(0, 3, 0)

    local timeout = 1
    local startTime = tick()
    while tick() - startTime < timeout do
        if isGroundLoaded(pos, 15) then
            break
        end
        task.wait(0.2)
    end

    for y = platform.Position.Y, pos.Y + 3, -2 do
        if not running then break end
        hrp.CFrame = CFrame.new(pos.X, y, pos.Z)
        task.wait(0.05)
    end

    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    platform:Destroy()

    pcall(function()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    end)
end

local function walkToCoordinate(targetPos)
    if not running then return end
    addLog("Jalan ke " .. tostring(targetPos), "📍")
    waitForRespawn()
    local hrp, char = getHRP()
    local humanoid = char:WaitForChild("Humanoid")

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 2
    })

    path:ComputeAsync(hrp.Position, targetPos)

    if path.Status == Enum.PathStatus.Success then
        for _, waypoint in ipairs(path:GetWaypoints()) do
            if not running then break end
            humanoid:MoveTo(waypoint.Position)
            local reached = humanoid.MoveToFinished:Wait(2)
            if not reached then
                addLog("Waypoint gagal, fallback teleport.")
                safeTeleport(targetPos)
                return
            end
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                humanoid.Jump = true
            end
        end
    else
        addLog("Path gagal, fallback teleport.")
        safeTeleport(targetPos)
    end
end

-- Loop perjalanan
local function startSequence()
    running = true
    while running do
        addLog("Loop dimulai", "🚀")
        safeTeleport(Vector3.new(-621.72, 241.65, -383.89))
        task.wait(0.5)
        safeTeleport(Vector3.new(-1203.19, 257.56, -487.08))
        task.wait(0.5)
        safeTeleport(Vector3.new(-1399.29, 574.22, -949.93))
        task.wait(0.5)
        safeTeleport(Vector3.new(-1701.05, 812.52, -1399.99))
        task.wait(0.5)
        --safeTeleport(Vector3.new(-1971.53, 842.13, -1671.81))
        --task.wait(0.5)
        local summitGate = workspace:FindFirstChild("SummitGate")
	    if summitGate and summitGate:IsA("BasePart") then
	        touchPart(summitGate)
		    addLog("Found summitGate", "📍")
		    task.wait(0.5)
	    else
		    addLog("summitGate not found", "📍")
	    end	
        task.wait(0.5)
        --walkToCoordinate(Vector3.new(-1767.20, 815.87, -1426.06))
        --walkToCoordinate(Vector3.new(-1787.36, 821.48, -1446.14))
        --walkToCoordinate(Vector3.new(-1882.56, 770.27, -1445.49))
        --walkToCoordinate(Vector3.new(-1833.57, 736.70, -1524.41))
        --walkToCoordinate(Vector3.new(-2007.21, 853.96, -1661.20))
        --task.wait(1)
        --walkToCoordinate(Vector3.new(-2040.03, 883.36, -1769.31))
        --safeTeleport(Vector3.new(-2183.18, 888.60, -1756.31))
        --task.wait(1)
        safeTeleport(Vector3.new(-3231.33, 1718.79, -2590.81))
        task.wait(0.5)

        addLog("Respawn...", "💀")
        local hrp, char = getHRP()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
        task.wait(4)
    end
    addLog("Loop dihentikan", "🛑")
end

-- Toggle Button
toggleButton.MouseButton1Click:Connect(function()
    if not running then
        toggleButton.Text = "⏹ STOP"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        startSequence()
    else
        running = false
        toggleButton.Text = "▶ START"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    running = false
    screenGui:Destroy()
end)

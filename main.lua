--// Services
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

--// GUI Setup
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "TeleportGui"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 121) -- lebih kecil karena no scroll
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel")
title.Text = "Mount Yagataw Push"
title.Size = UDim2.new(1, -40, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
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
logLabel.Text = "💤 Menunggu..."
logLabel.Parent = mainFrame
Instance.new("UICorner", logLabel).CornerRadius = UDim.new(0, 8)

-- Fungsi Log
local function addLog(text, emoji)
    logLabel.Text = (emoji or "ℹ️") .. " " .. os.date("[%H:%M:%S] ") .. text
end

-- Variabel kontrol
local running = false

--================= SEMUA FUNGSI ASLI =================--
-- (dari kode kamu, tidak diubah)
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
    platform.Position = pos + Vector3.new(0, 20, 0)
    platform.Transparency = 1
    platform.CanCollide = true
    platform.Parent = workspace

    hrp.CFrame = platform.CFrame + Vector3.new(0, 3, 0)

    local timeout = 5
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

-- Loop perjalanan asli
local function startSequence()
    running = true
    addLog("Loop dimulai", "🚀")

    while running do
        addLog("Mulai perjalanan baru...", "🗺️")
		
		-- Begin
		walkToCoordinate(Vector3.new(-5964.52, -158.99, -16.99))
		
		-- Camp1
		task.wait(150)
        safeTeleport(Vector3.new(-3719.05, 225.01, 235.91))
		task.wait(5)
		walkToCoordinate(Vector3.new(-3700.50, 228.78, 249.11))
		
		-- Camp2
        task.wait(200)
        safeTeleport(Vector3.new(1789.10, 105.45, -137.75))
		task.wait(5)
		walkToCoordinate(Vector3.new(1779.74, 105.47, -151.16))
		
		-- Camp3
        task.wait(300)
        safeTeleport(Vector3.new(5890.47, 321.01, -18.91))
		task.wait(5)
		walkToCoordinate(Vector3.new(5874.21, 321.01, -15.99))

        -- Camp4
        task.wait(300)
        safeTeleport(Vector3.new(8992.67, 595.64, 102.70))
		task.wait(5)
		walkToCoordinate(Vector3.new(8985.52, 597.06, 85.23))

		-- End
        task.wait(300)
        safeTeleport(Vector3.new(10995.21, 549.17, 114.78))
		task.wait(5)
		walkToCoordinate(Vector3.new(10978.99, 549.19, 124.23))

        addLog("Respawn...", "💀")
        local hrp, char = getHRP()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
        task.wait(8)
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

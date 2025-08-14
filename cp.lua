--// Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Pastikan folder Checkpoints ada
local checkpointsFolder = workspace:FindFirstChild("Checkpoints")
if not checkpointsFolder then
    warn("Folder Checkpoints tidak ditemukan di workspace!")
    return
end

--// GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheckpointFinder"
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.Text = "Checkpoint Finder"
title.TextSize = 20
title.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -40)
scrollingFrame.Position = UDim2.new(0, 0, 0, 40)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.Parent = mainFrame

--// Fungsi untuk menambah tombol checkpoint
local function addCheckpointButton(cp)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, #scrollingFrame:GetChildren() * 35)
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    button.Text = cp.Name
    button.Parent = scrollingFrame

    button.MouseButton1Click:Connect(function()
        -- Teleport ke checkpoint
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp and cp:IsA("BasePart") then
            hrp.CFrame = cp.CFrame + Vector3.new(0, 5, 0)
        elseif hrp and cp:FindFirstChild("TouchPart") then
            hrp.CFrame = cp.TouchPart.CFrame + Vector3.new(0, 5, 0)
        end
    end)
end

--// Scan semua checkpoint
local yOffset = 0
for _, cp in ipairs(checkpointsFolder:GetChildren()) do
    if cp:IsA("BasePart") or cp:IsA("Model") then
        addCheckpointButton(cp)
        yOffset += 35
    end
end

-- Sesuaikan ukuran canvas scroll
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)

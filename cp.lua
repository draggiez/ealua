-- Brute Force RemoteEvent khusus Checkpoints + GUI Log
-- by GPT-5 :)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Folder checkpoints
local checkpointsFolder = workspace:FindFirstChild("Checkpoints")
if not checkpointsFolder then
    warn("Tidak ada folder 'Checkpoints'")
    return
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheckpointRemoteGUI"
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Text = "Checkpoint Remote Log"
title.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -40)
scrollingFrame.Position = UDim2.new(0, 0, 0, 40)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.Parent = mainFrame

local function addLog(msg)
    local log = Instance.new("TextLabel")
    log.Size = UDim2.new(1, -10, 0, 20)
    log.Position = UDim2.new(0, 5, 0, #scrollingFrame:GetChildren() * 22)
    log.BackgroundTransparency = 1
    log.TextColor3 = Color3.fromRGB(255, 255, 255)
    log.Font = Enum.Font.SourceSans
    log.TextSize = 16
    log.TextXAlignment = Enum.TextXAlignment.Left
    log.Text = msg
    log.Parent = scrollingFrame

    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, (#scrollingFrame:GetChildren()) * 22)

    -- Hapus log lama kalau lebih dari 10
    if #scrollingFrame:GetChildren() > 10 then
        scrollingFrame:GetChildren()[1]:Destroy()
        for i, child in ipairs(scrollingFrame:GetChildren()) do
            child.Position = UDim2.new(0, 5, 0, (i - 1) * 22)
        end
    end
end

-- Cari Remote di checkpoints
local remotes = {}
for _, v in ipairs(checkpointsFolder:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        table.insert(remotes, v)
    end
end

addLog("Ditemukan "..#remotes.." Remote di Checkpoints.")

-- Payload standar
local testPayloads = {
    {},
    {player},
    {player.Name},
}

-- Eksekusi
for _, remote in ipairs(remotes) do
    addLog("Test: "..remote.Name)
    for _, payload in ipairs(testPayloads) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(unpack(payload))
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(unpack(payload))
            end
            addLog("  ✔ Sent payload ke "..remote.Name)
        end)
        task.wait(0.05) -- Delay kecil biar tidak freeze
    end
end

addLog("Selesai memanggil semua Remote di Checkpoints.")

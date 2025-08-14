-- Full RemoteEvent / RemoteFunction Brute Force for Checkpoint Progress + GUI Log
-- by GPT-5 :)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteBruteForceGUI"
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
title.Text = "Remote Brute Force Log"
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

-- Cari semua remote
local remotes = {}
local function scan(obj)
    for _, v in ipairs(obj:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(remotes, v)
        end
    end
end

for _, service in ipairs(game:GetChildren()) do
    scan(service)
end

addLog("Ditemukan "..#remotes.." RemoteEvent/Function.")

-- Ambil total stage dari leaderstats (kalau ada)
local leaderstats = player:FindFirstChild("leaderstats")
local stageValue = nil
if leaderstats then
    for _, v in ipairs(leaderstats:GetChildren()) do
        if v:IsA("IntValue") or v:IsA("NumberValue") then
            if string.find(string.lower(v.Name), "stage") or string.find(string.lower(v.Name), "progress") then
                stageValue = v
                addLog("Progress: "..v.Name.." = "..v.Value)
                break
            end
        end
    end
end

-- Fungsi untuk cek progress penuh
local function isProgressFull()
    if stageValue and stageValue.Value >= 999 then -- ubah sesuai max stage
        return true
    end
    return false
end

-- Daftar payload percobaan
local testPayloads = {
    {},
    {player},
    {player.Name},
    {Vector3.new(0, 0, 0)},
    {"Checkpoint1"},
    {player, "Checkpoint1"},
}

-- Eksekusi brute force
for _, remote in ipairs(remotes) do
    if isProgressFull() then
        addLog("Progress penuh, berhenti.")
        break
    end

    addLog("Test: "..remote:GetFullName())

    for _, payload in ipairs(testPayloads) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(unpack(payload))
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(unpack(payload))
            end
            addLog("  ✔ Sent payload ke "..remote.Name)
        end)
        task.wait(0.1)

        if isProgressFull() then
            addLog("Progress penuh, brute force berhenti.")
            return
        end
    end
end

addLog("Brute force selesai.")

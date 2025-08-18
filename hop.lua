--// Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

--// Buat GUI indikator
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HopIndicatorGui"
screenGui.Parent = game.CoreGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 180, 0, 30)
label.Position = UDim2.new(1, -190, 0, 10) -- pojok kanan atas
label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 16
label.Text = "AutoHop: Loading..."
label.Parent = screenGui

-- Utility: update teks + warna
local function updateLabel(text, color)
    label.Text = text
    label.BackgroundColor3 = color
end

--// Fungsi cari server sepi
local function findServerWithOnePlayer()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local response = game:HttpGet(url)
    local data = HttpService:JSONDecode(response)

    for _, server in ipairs(data.data) do
        if server.playing <= 1 and server.id ~= game.JobId then
            return server.id
        end
    end
    return nil
end

--// Fungsi cek dan hop
local function checkAndHop()
    while task.wait(20) do -- cek tiap 20 detik
        local playerCount = #Players:GetPlayers()
        if playerCount > 2 then
            updateLabel("Cari server sepi...", Color3.fromRGB(200, 50, 50)) -- merah
            local serverId = findServerWithOnePlayer()
            if serverId then
                updateLabel("Teleport...", Color3.fromRGB(200, 50, 50)) -- merah
                TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, player)
                break
            else
                updateLabel("Tidak ada server sepi", Color3.fromRGB(230, 200, 50)) -- kuning
            end
        else
            updateLabel("Server Aman (" .. playerCount .. " player)", Color3.fromRGB(50, 200, 50)) -- hijau
        end
    end
end

-- Mulai otomatis
task.spawn(checkAndHop)

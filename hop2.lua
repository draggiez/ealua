--// Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

--// GUI indikator
local CoreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HopIndicator"
screenGui.Parent = CoreGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 180, 0, 25)
statusLabel.Position = UDim2.new(1, -185, 0, 10)
statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.BorderSizePixel = 0
statusLabel.Text = "🔄 Checking servers..."
statusLabel.Parent = screenGui

--// Cari server kosong (0 player)
local function findEmptyServer()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local response = game:HttpGet(url)
    local data = HttpService:JSONDecode(response)

    for _, server in ipairs(data.data) do
        if server.playing == 0 and server.id ~= game.JobId then
            return server.id
        end
    end
    return nil
end

--// Cari server dengan max 1 player
local function findLowServer()
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

--// Fungsi cek player & auto hop
local function checkAndHop()
    local playerCount = #Players:GetPlayers()
    if playerCount > 1 then
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        statusLabel.Text = "⚠️ Server ramai (" .. playerCount .. ")"

        local serverId = findEmptyServer()
        if not serverId then
            serverId = findLowServer()
        end

        if serverId then
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            statusLabel.Text = "✅ Pindah ke server sepi..."
            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, player)
        else
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            statusLabel.Text = "❌ Server sepi tidak ada, retry..."
            task.delay(5, checkAndHop)
        end
    else
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        statusLabel.Text = "✅ Server aman (1 player)"
    end
end

--// Cek langsung saat mulai
checkAndHop()

--// Cek lagi saat ada player join
Players.PlayerAdded:Connect(function()
    checkAndHop()
end)

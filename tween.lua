--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

--// GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoordinateTeleporter"
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 190)
frame.Position = UDim2.new(0.5, -150, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Coordinate Teleporter"
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

--// Scroll untuk list koordinat
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -130)
scrollFrame.Position = UDim2.new(0, 10, 0, 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = frame

local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0, 5)

--// List Koordinat
local positions = {
	["Puncak Atin"] = Vector3.new(781.14, 2165.46, 3921.42)
}

--// Tween Teleport Function
local function tweenTo(pos)
	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")

	local tween = TweenService:Create(
		root,
		TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{CFrame = CFrame.new(pos)}
	)
	tween:Play()
end

--// Buat tombol per posisi
for name, pos in pairs(positions) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Text = name .. " (" .. math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z) .. ")"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Parent = scrollFrame

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(function()
		tweenTo(pos)
	end)
end

-- Update canvas size otomatis
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

--// Fungsi cari server kosong
local function findEmptyServer()
	local servers = {}
	local cursor = ""

	while true do
		local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"..(cursor ~= "" and "&cursor="..cursor or ""))
		local data = HttpService:JSONDecode(req)

		for _, server in ipairs(data.data) do
			if type(server.playing) == "number" and type(server.maxPlayers) == "number" then
				if server.playing < server.maxPlayers and server.id ~= game.JobId then
					table.insert(servers, server)
				end
			end
		end

		if data.nextPageCursor then
			cursor = data.nextPageCursor
		else
			break
		end
	end

	-- cari server dengan player paling sedikit
	table.sort(servers, function(a,b)
		return a.playing < b.playing
	end)

	return servers[1] -- ambil server terkosong
end

--// Tombol Rejoin Server sama
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(1, -20, 0, 35)
rejoinBtn.Position = UDim2.new(0, 10, 1, -85)
rejoinBtn.Text = "🔄 Rejoin Current Server"
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = 14
rejoinBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
rejoinBtn.Parent = frame
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 6)

rejoinBtn.MouseButton1Click:Connect(function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

--// Tombol Rejoin Empty Server
local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(1, -20, 0, 35)
hopBtn.Position = UDim2.new(0, 10, 1, -45)
hopBtn.Text = "🌐 Rejoin Empty Server"
hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hopBtn.Font = Enum.Font.GothamBold
hopBtn.TextSize = 14
hopBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
hopBtn.Parent = frame
Instance.new("UICorner", hopBtn).CornerRadius = UDim.new(0, 6)

hopBtn.MouseButton1Click:Connect(function()
	local targetServer = findEmptyServer()
	if targetServer then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, player)
	else
		warn("Tidak ada server kosong yang ditemukan")
	end
end)

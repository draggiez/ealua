-----------------------------------------------------
-- CONFIG
-----------------------------------------------------
local API_URL = "https://english-word-suggestion.vercel.app/suggest?word="

-----------------------------------------------------
-- SERVICES
-----------------------------------------------------
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

-----------------------------------------------------
-- GUI CREATION
-----------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "AutoCompleteGUI"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 260)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -10, 0, 40)
input.Position = UDim2.new(0, 5, 0, 5)
input.PlaceholderText = "Type English word..."
input.TextColor3 = Color3.fromRGB(255,255,255)
input.BackgroundColor3 = Color3.fromRGB(35,35,35)
input.Font = Enum.Font.Gotham
input.TextSize = 16
input.Parent = frame

Instance.new("UICorner", input).CornerRadius = UDim.new(0,5)

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -10, 1, -55)
list.Position = UDim2.new(0, 5, 0, 50)
list.BackgroundColor3 = Color3.fromRGB(30,30,30)
list.ScrollBarThickness = 4
list.CanvasSize = UDim2.new(0,0,0,0)
list.Parent = frame

Instance.new("UICorner", list).CornerRadius = UDim.new(0,5)

local template = Instance.new("TextButton")
template.Size = UDim2.new(1, -10, 0, 28)
template.BackgroundColor3 = Color3.fromRGB(50,50,50)
template.Font = Enum.Font.Gotham
template.TextColor3 = Color3.new(1,1,1)
template.TextSize = 14
template.Visible = false

Instance.new("UICorner", template).CornerRadius = UDim.new(0,4)

-----------------------------------------------------
-- CLEAR LIST
-----------------------------------------------------
local function ClearList()
	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
end

-----------------------------------------------------
-- FETCH API
-----------------------------------------------------
local function GetSuggestions(word)
	if word == "" then return {} end

	local url = API_URL .. HttpService:UrlEncode(word)
	print("Fetching:", url)

	local ok, res = pcall(function()
		return HttpService:GetAsync(url)
	end)

	if not ok then
		warn("API ERROR:", res)
		return {}
	end

	print("API response:", res)

	local success, json = pcall(function()
		return HttpService:JSONDecode(res)
	end)

	if not success then
		warn("JSON decode error:", json)
		return {}
	end

	-- json HARUS table array-string
	print("Decoded table length:", #json)

	return json
end

-----------------------------------------------------
-- SHOW RESULTS
-----------------------------------------------------
local function ShowResults(results)
	ClearList()

	local y = 0
	for _, word in ipairs(results) do
		local btn = template:Clone()
		btn.Visible = true
		btn.Text = "  " .. word
		btn.Position = UDim2.new(0, 5, 0, y)
		btn.Parent = list

		btn.MouseButton1Click:Connect(function()
			input.Text = word
			ClearList()
		end)

		y += 30
	end

	list.CanvasSize = UDim2.new(0,0,0,y)
end

-----------------------------------------------------
-- TEXT CHANGE EVENT
-----------------------------------------------------
input:GetPropertyChangedSignal("Text"):Connect(function()
	local text = input.Text
	local words = GetSuggestions(text)
	ShowResults(words)
end)

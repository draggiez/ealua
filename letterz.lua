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
-- GUI
-----------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = Player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 260)
frame.Position = UDim2.new(0.5, -160, 0.4, -130)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.ZIndex = 10
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 0, 40)
input.Position = UDim2.new(0, 10, 0, 10)
input.PlaceholderText = "Type English word..."
input.BackgroundColor3 = Color3.fromRGB(40,40,40)
input.TextColor3 = Color3.new(1,1,1)
input.Font = Enum.Font.Gotham
input.TextSize = 16
input.ClearTextOnFocus = false
input.ZIndex = 11
input.Parent = frame
Instance.new("UICorner", input).CornerRadius = UDim.new(0,5)

-----------------------------------------------------
-- LIST AREA
-----------------------------------------------------
local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 1, -60)
list.Position = UDim2.new(0, 10, 0, 55)
list.BackgroundColor3 = Color3.fromRGB(30,30,30)
list.BorderSizePixel = 0
list.ScrollBarThickness = 6
list.CanvasSize = UDim2.new(0,0,0,0)
list.ClipsDescendants = true
list.ZIndex = 11
list.Parent = frame
Instance.new("UICorner", list).CornerRadius = UDim.new(0,8)

-----------------------------------------------------
-- TEMPLATE
-----------------------------------------------------
local template = Instance.new("TextButton")
template.Size = UDim2.new(1, -10, 0, 28)
template.BackgroundColor3 = Color3.fromRGB(50,50,50)
template.TextColor3 = Color3.new(1,1,1)
template.Font = Enum.Font.Gotham
template.TextSize = 14
template.BorderSizePixel = 0
template.Visible = false
template.ZIndex = 12
Instance.new("UICorner", template).CornerRadius = UDim.new(0,5)

-----------------------------------------------------
-- CLEAR LIST
-----------------------------------------------------
local function ClearList()
	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
end

-----------------------------------------------------
-- FETCH FROM API
-----------------------------------------------------
local function GetSuggestions(word)
	if word == "" then return {} end

	local url = API_URL .. HttpService:UrlEncode(word)
	print("Fetching:", url)

	local ok, res = pcall(function()
		return HttpService:GetAsync(url)
	end)

	if not ok then
		warn("API error:", res)
		return {}
	end

	local success, data = pcall(function()
		return HttpService:JSONDecode(res)
	end)

	if not success then
		warn("JSON decode error")
		return {}
	end

	print("Suggestions:", #data)

	return data
end

-----------------------------------------------------
-- DISPLAY RESULTS
-----------------------------------------------------
local function ShowResults(results)
	ClearList()

	local y = 0
	for _, word in ipairs(results) do
		local btn = template:Clone()
		btn.Visible = true
		btn.Text = "  " .. word
		btn.Parent = list
		btn.Position = UDim2.new(0, 5, 0, y)
		btn.ZIndex = 12

		btn.MouseButton1Click:Connect(function()
			input.Text = word
			ClearList()
		end)

		y += 32
	end

	list.CanvasSize = UDim2.new(0,0,0,y)
end

-----------------------------------------------------
-- ON TYPE
-----------------------------------------------------
input:GetPropertyChangedSignal("Text"):Connect(function()
	local text = input.Text
	local results = GetSuggestions(text)
	ShowResults(results)
end)

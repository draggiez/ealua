-----------------------------------------------------
-- AUTO-COMPLETE GUI + API AUTOGENERATE
-----------------------------------------------------
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AutoCompleteGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-----------------------------------------------------
-- API URL
-----------------------------------------------------
local API_URL = "https://english-word-suggestion.vercel.app/suggest?word="


-----------------------------------------------------
-- MAIN FRAME
-----------------------------------------------------
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 50)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner1 = Instance.new("UICorner", frame)
corner1.CornerRadius = UDim.new(0, 10)

-----------------------------------------------------
-- INPUT BOX
-----------------------------------------------------
local input = Instance.new("TextBox")
input.Parent = frame
input.Size = UDim2.new(1, -10, 0, 40)
input.Position = UDim2.new(0, 5, 0, 5)
input.PlaceholderText = "Type English word..."
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(40,40,40)
input.Font = Enum.Font.Gotham
input.TextSize = 16

local corner2 = Instance.new("UICorner", input)
corner2.CornerRadius = UDim.new(0, 6)

-----------------------------------------------------
-- SUGGESTION LIST PANEL
-----------------------------------------------------
local listFrame = Instance.new("Frame")
listFrame.Parent = frame
listFrame.Size = UDim2.new(1, 0, 0, 220)
listFrame.Position = UDim2.new(0, 0, 0, 48)
listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
listFrame.Visible = true

local lfCorner = Instance.new("UICorner", listFrame)
lfCorner.CornerRadius = UDim.new(0, 6)

local scrolling = Instance.new("ScrollingFrame", listFrame)
scrolling.Size = UDim2.new(1, -10, 1, -10)
scrolling.Position = UDim2.new(0, 5, 0, 5)
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolling.ScrollBarThickness = 4
scrolling.BackgroundTransparency = 1

-----------------------------------------------------
-- SUGGESTION TEMPLATE
-----------------------------------------------------
local suggestionTemplate = Instance.new("TextButton")
suggestionTemplate.Size = UDim2.new(1, -8, 0, 26)
suggestionTemplate.BackgroundColor3 = Color3.fromRGB(50,50,50)
suggestionTemplate.BorderSizePixel = 0
suggestionTemplate.TextColor3 = Color3.new(1,1,1)
suggestionTemplate.Font = Enum.Font.Gotham
suggestionTemplate.TextSize = 14
suggestionTemplate.Visible = false

local sugCorner = Instance.new("UICorner", suggestionTemplate)
sugCorner.CornerRadius = UDim.new(0, 4)

-----------------------------------------------------
-- FUNCTION: CLEAR LIST
-----------------------------------------------------
local function ClearSuggestions()
	for _, c in ipairs(scrolling:GetChildren()) do
		if c:IsA("TextButton") then
			c:Destroy()
		end
	end
end

-----------------------------------------------------
-- FUNCTION: FETCH API AUTOCOMPLETE
-----------------------------------------------------
local function GetSuggestions(query)
	if query == "" then return {} end

	local url = API_URL .. HttpService:UrlEncode(query)

	local ok, res = pcall(function()
		return HttpService:GetAsync(url)
	end)

	if not ok then
		warn("API Error:", res)
		return {}
	end

	local decoded
	local success, data = pcall(function()
		return HttpService:JSONDecode(res)
	end)

	if success then
		decoded = data
	else
		decoded = {}
	end

	return decoded
end

-----------------------------------------------------
-- SHOW SUGGESTIONS
-----------------------------------------------------
local function Show(list)
	ClearSuggestions()

	local y = 0
	for _, word in ipairs(list) do
		local btn = suggestionTemplate:Clone()
		btn.Visible = true
		btn.Text = "  " .. word
		btn.Position = UDim2.new(0, 4, 0, y)
		btn.Parent = scrolling

		btn.MouseButton1Click:Connect(function()
			input.Text = word
			ClearSuggestions()
		end)

		y += 28
	end

	scrolling.CanvasSize = UDim2.new(0, 0, 0, y)
end

-----------------------------------------------------
-- EVENT: UPDATE ON TYPE
-----------------------------------------------------
input:GetPropertyChangedSignal("Text"):Connect(function()
	local text = input.Text
	local suggestions = GetSuggestions(text)
	Show(suggestions)
end)

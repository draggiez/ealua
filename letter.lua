---------------------------------------------------------
-- AUTOCOMPLETE ENGLISH WORD (GUI FIXED)
---------------------------------------------------------

local HttpService = game:GetService("HttpService")

-- ==== KONTAINER AUTOCOMPLETE ====
local autoFrame = Instance.new("Frame")
autoFrame.Size = UDim2.new(0, 240, 0, 140)
autoFrame.Position = UDim2.new(0, 10, 0, 180)
autoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
autoFrame.Parent = frame
autoFrame.ZIndex = 50
Instance.new("UICorner", autoFrame).CornerRadius = UDim.new(0, 10)

local titleAuto = Instance.new("TextLabel", autoFrame)
titleAuto.Size = UDim2.new(1, 0, 0, 20)
titleAuto.BackgroundTransparency = 1
titleAuto.Text = "Autocomplete Word"
titleAuto.TextColor3 = Color3.fromRGB(255, 255, 255)
titleAuto.Font = Enum.Font.GothamBold
titleAuto.TextSize = 14
titleAuto.ZIndex = 51

local autoInput = Instance.new("TextBox", autoFrame)
autoInput.Size = UDim2.new(1, -10, 0, 22)
autoInput.Position = UDim2.new(0, 5, 0, 25)
autoInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
autoInput.TextColor3 = Color3.new(1,1,1)
autoInput.PlaceholderText = "Type English word..."
autoInput.Font = Enum.Font.Gotham
autoInput.TextSize = 14
autoInput.ClearTextOnFocus = false
autoInput.ZIndex = 51
Instance.new("UICorner", autoInput).CornerRadius = UDim.new(0, 6)

local listFrame = Instance.new("ScrollingFrame", autoFrame)
listFrame.Size = UDim2.new(1, -10, 1, -55)
listFrame.Position = UDim2.new(0, 5, 0, 50)
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ScrollBarThickness = 5
listFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
listFrame.ZIndex = 50
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 8)

local suggestionTemplate = Instance.new("TextButton")
suggestionTemplate.Size = UDim2.new(1, -10, 0, 22)
suggestionTemplate.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
suggestionTemplate.TextColor3 = Color3.new(1,1,1)
suggestionTemplate.Font = Enum.Font.Gotham
suggestionTemplate.TextSize = 13
suggestionTemplate.Visible = false
suggestionTemplate.BorderSizePixel = 0
suggestionTemplate.ZIndex = 52
Instance.new("UICorner", suggestionTemplate).CornerRadius = UDim.new(0, 5)


---------------------------------------------------------
-- FUNCTION: GET SUGGESTIONS
---------------------------------------------------------
local function getSuggestions(word)
	if word == "" then return {} end
	
	local url = "https://api.datamuse.com/sug?s=" .. HttpService:UrlEncode(word)

	local ok, res = pcall(function()
		return HttpService:GetAsync(url)
	end)

	if not ok then
		warn("Autocomplete error:", res)
		return {}
	end

	local data = HttpService:JSONDecode(res)
	local out = {}

	for i, item in ipairs(data) do
		if i > 15 then break end
		table.insert(out, item.word)
	end

	return out
end


---------------------------------------------------------
-- FUNCTION: SHOW LIST
---------------------------------------------------------
local function showList(words)
	for _, c in ipairs(listFrame:GetChildren()) do
		if c ~= suggestionTemplate then c:Destroy() end
	end

	local y = 0
	for _, word in ipairs(words) do
		local btn = suggestionTemplate:Clone()
		btn.Visible = true
		btn.Text = word
		btn.Parent = listFrame
		btn.Position = UDim2.new(0, 5, 0, y)
		btn.ZIndex = 52

		btn.MouseButton1Click:Connect(function()
			autoInput.Text = word
		end)

		y += 24
	end

	listFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end


---------------------------------------------------------
-- EVENT: WHEN TYPING
---------------------------------------------------------
autoInput:GetPropertyChangedSignal("Text"):Connect(function()
	local text = autoInput.Text

	task.spawn(function()
		local list = getSuggestions(text)
		showList(list)
	end)
end)

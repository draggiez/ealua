---------------------------------------------------------
-- AUTOCOMPLETE WORD (ENGLISH)
---------------------------------------------------------

local HttpService = game:GetService("HttpService")

-- ===== GUI ELEMENTS =====
local autoFrame = Instance.new("Frame", frame)
autoFrame.Size = UDim2.new(0.9, 0, 0, 120)
autoFrame.Position = UDim2.new(0.05, 0, 0, 150)
autoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
autoFrame.BorderSizePixel = 0
Instance.new("UICorner", autoFrame).CornerRadius = UDim.new(0, 8)

local autoInput = Instance.new("TextBox", autoFrame)
autoInput.Size = UDim2.new(1, -10, 0, 24)
autoInput.Position = UDim2.new(0, 5, 0, 5)
autoInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoInput.TextColor3 = Color3.new(1,1,1)
autoInput.Font = Enum.Font.Gotham
autoInput.TextSize = 14
autoInput.ClearTextOnFocus = false
autoInput.PlaceholderText = "Type English word..."
Instance.new("UICorner", autoInput).CornerRadius = UDim.new(0, 6)

local listFrame = Instance.new("ScrollingFrame", autoFrame)
listFrame.Size = UDim2.new(1, -10, 1, -40)
listFrame.Position = UDim2.new(0, 5, 0, 35)
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ScrollBarThickness = 4
listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
listFrame.BorderSizePixel = 0
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)

local suggestionTemplate = Instance.new("TextButton")
suggestionTemplate.Size = UDim2.new(1, -10, 0, 22)
suggestionTemplate.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
suggestionTemplate.TextColor3 = Color3.new(1,1,1)
suggestionTemplate.Font = Enum.Font.Gotham
suggestionTemplate.TextSize = 13
suggestionTemplate.Visible = false
suggestionTemplate.BorderSizePixel = 0
Instance.new("UICorner", suggestionTemplate).CornerRadius = UDim.new(0, 4)


-- ===== FUNCTION: FETCH SUGGESTIONS =====
local function getSuggestions(word)
	if word == "" then return {} end

	local url = "https://api.datamuse.com/sug?s=" .. HttpService:UrlEncode(word)

	local ok, res = pcall(function()
		return HttpService:GetAsync(url)
	end)

	if not ok then return {} end

	local decoded = HttpService:JSONDecode(res)
	local list = {}

	for i, item in ipairs(decoded) do
		if i > 20 then break end -- limit 20
		table.insert(list, item.word)
	end

	return list
end


-- ===== FUNCTION: SHOW SUGGESTIONS =====
local function showList(words)
	-- clear old items
	for _, x in ipairs(listFrame:GetChildren()) do
		if x ~= suggestionTemplate then x:Destroy() end
	end

	local y = 0
	for _, word in ipairs(words) do
		local clone = suggestionTemplate:Clone()
		clone.Text = word
		clone.Visible = true
		clone.Parent = listFrame
		clone.Position = UDim2.new(0, 5, 0, y)

		clone.MouseButton1Click:Connect(function()
			autoInput.Text = word
		end)

		y += 24
	end

	listFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end


-- ===== EVENT: WHEN USER TYPES =====
autoInput:GetPropertyChangedSignal("Text"):Connect(function()
	local text = autoInput.Text
	task.spawn(function()
		local list = getSuggestions(text)
		showList(list)
	end)
end)

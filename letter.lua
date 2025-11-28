---------------------------------------------------------
-- SETUP GUI
---------------------------------------------------------
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local gui = Instance.new("ScreenGui")
gui.Name = "AutoCompleteGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.ZIndex = 10
frame.Parent = gui

---------------------------------------------------------
-- TEXTBOX UTAMA (versi lama)
---------------------------------------------------------
local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(1, -10, 0, 30)
textbox.Position = UDim2.new(0, 5, 0, 5)
textbox.PlaceholderText = "Type English word..."
textbox.BackgroundColor3 = Color3.fromRGB(50,50,50)
textbox.TextColor3 = Color3.new(1,1,1)
textbox.ZIndex = 11
textbox.Parent = frame

local suggestion = Instance.new("TextLabel")
suggestion.Size = UDim2.new(1, -10, 0, 30)
suggestion.Position = UDim2.new(0, 5, 0, 40)
suggestion.BackgroundColor3 = Color3.fromRGB(80,80,80)
suggestion.TextColor3 = Color3.new(1,1,1)
suggestion.ZIndex = 11
suggestion.Text = "Suggestion: -"
suggestion.Parent = frame

local localWords = {"apple","banana","car","cat","dog","dragon","fast","hello","world","water","game","roblox"}

textbox:GetPropertyChangedSignal("Text"):Connect(function()
    local input = textbox.Text:lower()
    local found = "-"

    for _, w in ipairs(localWords) do
        if w:sub(1, #input) == input then
            found = w
            break
        end
    end

    suggestion.Text = "Suggestion: " .. found
end)

---------------------------------------------------------
-- AUTOCOMPLETE API PANEL
---------------------------------------------------------
local autoFrame = Instance.new("Frame")
autoFrame.Size = UDim2.new(0, 240, 0, 120)
autoFrame.Position = UDim2.new(0, 30, 0, 80)
autoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
autoFrame.ZIndex = 50
autoFrame.Parent = frame
Instance.new("UICorner", autoFrame).CornerRadius = UDim.new(0, 10)

local titleAuto = Instance.new("TextLabel", autoFrame)
titleAuto.Size = UDim2.new(1, 0, 0, 20)
titleAuto.BackgroundTransparency = 1
titleAuto.Text = "API Suggestions"
titleAuto.TextColor3 = Color3.fromRGB(255, 255, 255)
titleAuto.Font = Enum.Font.GothamBold
titleAuto.TextSize = 14
titleAuto.ZIndex = 51

local autoInput = textbox  -- pakai textbox utama sebagai input

local listFrame = Instance.new("ScrollingFrame", autoFrame)
listFrame.Size = UDim2.new(1, -10, 1, -30)
listFrame.Position = UDim2.new(0, 5, 0, 25)
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
-- API SUGGESTION FUNCTION
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
-- SHOW LIST IN UI
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
-- EVENT TYPING
---------------------------------------------------------
autoInput:GetPropertyChangedSignal("Text"):Connect(function()
	local text = autoInput.Text

	task.spawn(function()
		local list = getSuggestions(text)
		showList(list)
	end)
end)

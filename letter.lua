local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AutoCompleteGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.ZIndex = 10
frame.Parent = gui

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

local words = {"apple","banana","car","cat","dog","dragon","fast","hello","world","water","game","roblox"}

textbox:GetPropertyChangedSignal("Text"):Connect(function()
    local input = textbox.Text:lower()
    local found = "-"

    for _, w in ipairs(words) do
        if w:sub(1, #input) == input then
            found = w
            break
        end
    end

    suggestion.Text = "Suggestion: " .. found
end)

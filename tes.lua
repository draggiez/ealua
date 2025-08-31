--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

--// Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Posisi asli
local originalCFrame = hrp.CFrame

-- Daftar koordinat (contoh beberapa titik)
local checkpoints = {
    Vector3.new(-782.99, 87.03, -650.32), -- cp1
    Vector3.new(-985.72, 182.07, -81.32), -- cp2
    Vector3.new(-952.87, 178.25, 809.87),-- cp3
    Vector3.new(797.29, 184.63, 875.85),-- cp4
    Vector3.new(973.33, 97.97, 135.15),-- cp5
	Vector3.new(980.60, 112.06, -535.60),-- cp6
	Vector3.new(402.23, 121.33, -229.17)-- cp7
}

local renderWait = 3 -- lama nunggu tiap titik

--// GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RenderProgressGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 80)
frame.Position = UDim2.new(0.5, -150, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.6, 0)
label.Position = UDim2.new(0, 0, 0, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 20
label.Text = "Render Progress"
label.Parent = frame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 0.3, 0)
progressBar.Position = UDim2.new(0, 0, 0.65, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = frame

-- Fungsi render ke titik
local function flyTo(pos, index, total)
    local flying = true
    local conn

    label.Text = string.format("(%d/%d) Render: %s", index, total, tostring(pos))
    progressBar.Size = UDim2.new(index/total, 0, 0.3, 0)

    conn = RunService.RenderStepped:Connect(function()
        if flying then
            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 10, 0))
        end
    end)

    task.wait(renderWait)

    flying = false
    conn:Disconnect()
end

-- Loop semua koordinat
for i, pos in ipairs(checkpoints) do
    flyTo(pos, i, #checkpoints)
end

-- Balik ke posisi asli
hrp.CFrame = originalCFrame

label.Text = "Selesai render semua titik!"
task.wait(2)
screenGui:Destroy()

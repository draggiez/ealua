--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Simpan posisi asli
local originalCFrame = hrp.CFrame

-- Daftar koordinat untuk render
local checkpoints = {
    Vector3.new(-782.99, 87.03, -650.32), -- cp1
    Vector3.new(-985.72, 182.07, -81.32), -- cp2
    Vector3.new(-952.87, 178.25, 809.87),-- cp3
    Vector3.new(797.29, 184.63, 875.85),-- cp4
    Vector3.new(973.33, 97.97, 135.15),-- cp5
	Vector3.new(980.60, 112.06, -535.60),-- cp6
	Vector3.new(402.23, 121.33, -229.17)-- cp7
}

local renderWait = 3 -- waktu tunggu di tiap koordinat

--// GUI Setup
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 320, 0, 100)
frame.Position = UDim2.new(0.5, -160, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 0.5, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 20
label.Text = "Render Progress"

local progressBarBg = Instance.new("Frame", frame)
progressBarBg.Size = UDim2.new(1, -10, 0.25, 0)
progressBarBg.Position = UDim2.new(0, 5, 0.65, 0)
progressBarBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
progressBarBg.BorderSizePixel = 0

local progressBar = Instance.new("Frame", progressBarBg)
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
progressBar.BorderSizePixel = 0

--// Freeze & Unfreeze biar anti fall damage
local function freezeCharacter()
    hrp.Anchored = true
    humanoid.PlatformStand = true
end

local function unfreezeCharacter()
    hrp.Anchored = false
    humanoid.PlatformStand = false
end

--// Render Function
local function flyTo(pos, index, total)
    local flying = true
    local conn

    label.Text = string.format("(%d/%d) Rendering: %s", index, total, tostring(pos))
    progressBar:TweenSize(UDim2.new(index/total, 0, 1, 0), "Out", "Quad", 0.5, true)

    print(string.format("[DEBUG] (%d/%d) Fly ke %s", index, total, tostring(pos)))

    conn = RunService.RenderStepped:Connect(function()
        if flying then
            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 10, 0))
        end
    end)

    task.wait(renderWait)

    flying = false
    conn:Disconnect()
end

--// Jalankan proses render
freezeCharacter()
for i, pos in ipairs(checkpoints) do
    flyTo(pos, i, #checkpoints)
end
unfreezeCharacter()

-- Kembali ke posisi asli
hrp.CFrame = originalCFrame
label.Text = "Selesai Render!"
progressBar:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.5, true)

task.wait(2)
screenGui:Destroy()
print("[DEBUG] Render selesai dan balik ke posisi awal")

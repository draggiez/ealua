--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Simpan posisi asli (server-side tetap)
local originalCFrame = hrp.CFrame

-- Daftar koordinat render (isi sesuai map)
local checkpoints = {
    Vector3.new(-782.99, 87.03, -650.32), -- cp1
    Vector3.new(-985.72, 182.07, -81.32), -- cp2
    Vector3.new(-952.87, 178.25, 809.87),-- cp3
    Vector3.new(797.29, 184.63, 875.85),-- cp4
    Vector3.new(973.33, 97.97, 135.15),-- cp5
	  Vector3.new(980.60, 112.06, -535.60),-- cp6
	  Vector3.new(402.23, 121.33, -229.17),-- cp7
}

-- Lama nunggu di tiap titik (detik)
local renderWait = 5

-- Fungsi render ke titik
local function renderAtPosition(pos)
    local flying = true
    local conn

    -- Pasang loop RenderStepped
    conn = RunService.RenderStepped:Connect(function()
        if flying then
            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0)) -- +5 biar ga nembus tanah
        end
    end)

    -- Tunggu map kebuka
    task.wait(renderWait)

    -- Stop fly
    flying = false
    conn:Disconnect()
end

-- Jalankan render ke semua koordinat
for _, pos in ipairs(checkpoints) do
    renderAtPosition(pos)
end

-- Terakhir balik ke posisi awal
hrp.CFrame = originalCFrame

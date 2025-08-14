local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- Cari semua part jalur
local parts = {}
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and (string.find(obj.Name:lower(), "check") or string.find(obj.Name:lower(), "trigger")) then
        table.insert(parts, obj)
    end
end

-- Urutkan berdasarkan posisi X/Z
table.sort(parts, function(a, b)
    return a.Position.X < b.Position.X
end)

print("Ditemukan", #parts, "part jalur untuk disentuh.")

-- Sentuh satu per satu
local hrp = getHRP()
for _, part in ipairs(parts) do
    hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
    task.wait(0.2) -- delay supaya server register touch
end

-- Terakhir ke SummitTrigger
local summit = workspace:FindFirstChild("SummitTrigger", true)
if summit and summit:IsA("BasePart") then
    hrp.CFrame = summit.CFrame + Vector3.new(0, 3, 0)
    print("Sudah sampai SummitTrigger.")
else
    print("SummitTrigger tidak ditemukan.")
end

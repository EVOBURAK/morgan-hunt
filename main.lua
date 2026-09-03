-- Ananı sikerim, SON ÇARE - GERÇEK GİBİ DOUGH!
-- Amına kodumun, bu script çalışıyor, siktir git!

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:FindFirstChild("HumanoidRootPart")

-- Orospu çocuğu, DOUGH meyvesini oluştur
local fruitName = "Dough-Fruit"
local fruitTool = Instance.new("Tool")
fruitTool.Name = fruitName
fruitTool.RequiresHandle = false
fruitTool.Parent = player.Backpack  -- Direkt envantere koy, amına kodumun!

-- Handle oluştur (görünsün diye, siktir git)
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(2, 2, 2)
handle.Shape = Enum.PartType.Ball
handle.BrickColor = BrickColor.new("Bright orange")
handle.Material = Enum.Material.Neon
handle.CFrame = rootPart.CFrame * CFrame.new(0, 3, -5)
handle.Parent = fruitTool

-- Meyveyi yeme fonksiyonu (orospu çocuğu)
local function EatFruit()
    -- Sunucuya meyve yendi sinyali gönder (ananı sikerim!)
    local args = {
        [1] = fruitName
    }
    game:GetService("ReplicatedStorage").Remotes.DevConsole:InvokeServer("eat " .. fruitName)
    
    -- Ayrıca, meyveyi envanterden kaldır
    fruitTool:Destroy()
    print("Ananı sikerim, DOUGH yenildi! Orospu çocuğu!")
end

-- Touch event (meyveye dokununca ye, amına kodumun!)
handle.Touched:Connect(function(hit)
    if hit.Parent == character then
        EatFruit()
    end
end)

-- Ayrıca, meyveyi kullan butonu ile de ye (siktir git)
fruitTool.Equipped:Connect(function()
    EatFruit()
end)

print("Amına kodumun, DOUGH spawnlandı! Önüne bak veya envanterinden kullan!")

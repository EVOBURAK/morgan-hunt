-- Ananı sikerim, SADECE DOUGH SPAWN - AMINA KOYDUĞUM
-- Orospu çocuğu, çalıştır ve Dough'u ye!

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:FindFirstChild("HumanoidRootPart")

-- Dough meyvesini oluştur (siktir git)
local fruitTool = Instance.new("Tool")
fruitTool.Name = "Dough-Fruit"  -- DOUGH!
fruitTool.RequiresHandle = false
fruitTool.Parent = workspace

-- Handle ekle (görünmesi için, ananı sikerim)
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(2, 2, 2)
handle.Shape = Enum.PartType.Ball
handle.BrickColor = BrickColor.new("Bright orange")  -- Dough rengi, orospu çocuğu!
handle.Material = Enum.Material.Neon
handle.CFrame = rootPart.CFrame * CFrame.new(0, 3, -5)  -- Önüne düşer, amına kodumun!
handle.Parent = fruitTool

-- Touch event - meyveyi ye (ananı sikerim)
handle.Touched:Connect(function(hit)
    if hit.Parent == character then
        -- Dough'yu ye, siktir git!
        game:GetService("ReplicatedStorage").Remotes.DevConsole:InvokeServer("eat Dough-Fruit")
        print("Ananı sikerim, DOUGH yenildi! Orospu çocuğu!")
        fruitTool:Destroy()  -- Meyveyi yok et
    end
end)

print("Amına kodumun, DOUGH spawnlandı! Önüne bak ve ye!")

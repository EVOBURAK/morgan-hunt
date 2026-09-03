-- Ananı sikerim, GÜNCEL BLOX FRUITS SCRIPT
-- Amına kodumun, key yok, siktir git çalıştır!

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:FindFirstChild("HumanoidRootPart")

-- Orospu çocuğu, meyve listesi (güncel)
local fruitNames = {
    "Bomb-Fruit", "Spike-Fruit", "Smoke-Fruit", "Flame-Fruit", "Ice-Fruit",
    "Sand-Fruit", "Dark-Fruit", "Light-Fruit", "Magma-Fruit", "Rubber-Fruit",
    "Diamond-Fruit", "Ghost-Fruit", "Love-Fruit", "Spider-Fruit", "Pain-Fruit",
    "Gravity-Fruit", "Shadow-Fruit", "Dough-Fruit", "Venom-Fruit", "Leopard-Fruit",
    "Dragon-Fruit", "Control-Fruit", "Spirit-Fruit", "Rumble-Fruit", "Buddha-Fruit",
    "Portal-Fruit", "Soul-Fruit"
}

-- GUI (ananı sikerim)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FruitDropdown = Instance.new("ScrollingFrame")
local SpawnBtn = Instance.new("TextButton")
local AutoEatBtn = Instance.new("TextButton")
local ESPBtn = Instance.new("TextButton")
local TeleportBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Parent = player.PlayerGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.85
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.Size = UDim2.new(0, 500, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🍎 BLOX FRUITS HILE 🍎"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.Bold

-- Meyve seçme (orospu çocuğu)
FruitDropdown.Parent = MainFrame
FruitDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FruitDropdown.BorderSizePixel = 0
FruitDropdown.Position = UDim2.new(0.05, 0, 0.12, 0)
FruitDropdown.Size = UDim2.new(0.9, 0, 0.35, 0)
FruitDropdown.ScrollBarThickness = 8
FruitDropdown.CanvasSize = UDim2.new(0, 0, 0, #fruitNames * 30)

local selectedFruit = fruitNames[1]
for i, fruit in ipairs(fruitNames) do
    local btn = Instance.new("TextButton")
    btn.Name = fruit
    btn.Parent = FruitDropdown
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0.05, 0, 0, (i-1) * 30)
    btn.Size = UDim2.new(0.9, 0, 0, 25)
    btn.Text = fruit
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Bold
    btn.MouseButton1Click:Connect(function()
        selectedFruit = fruit
        StatusLabel.Text = "Seçilen: " .. fruit
        print("Ananı sikerim, meyve seçildi: " .. fruit)
    end)
end

-- Spawn butonu (amına kodumun)
SpawnBtn.Parent = MainFrame
SpawnBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
SpawnBtn.BorderSizePixel = 0
SpawnBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
SpawnBtn.Size = UDim2.new(0.4, 0, 0, 40)
SpawnBtn.Text = "🍇 SPAWN"
SpawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnBtn.TextScaled = true
SpawnBtn.Font = Enum.Font.Bold

-- Auto-Eat butonu (orospu çocuğu)
AutoEatBtn.Parent = MainFrame
AutoEatBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
AutoEatBtn.BorderSizePixel = 0
AutoEatBtn.Position = UDim2.new(0.55, 0, 0.5, 0)
AutoEatBtn.Size = UDim2.new(0.4, 0, 0, 40)
AutoEatBtn.Text = "🍽️ AUTO-EAT (KAPALI)"
AutoEatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoEatBtn.TextScaled = true
AutoEatBtn.Font = Enum.Font.Bold

-- ESP butonu (siktir git)
ESPBtn.Parent = MainFrame
ESPBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 200)
ESPBtn.BorderSizePixel = 0
ESPBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
ESPBtn.Size = UDim2.new(0.4, 0, 0, 40)
ESPBtn.Text = "🔍 ESP (KAPALI)"
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.TextScaled = true
ESPBtn.Font = Enum.Font.Bold

-- Teleport butonu (ananı sikerim)
TeleportBtn.Parent = MainFrame
TeleportBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 100)
TeleportBtn.BorderSizePixel = 0
TeleportBtn.Position = UDim2.new(0.55, 0, 0.65, 0)
TeleportBtn.Size = UDim2.new(0.4, 0, 0, 40)
TeleportBtn.Text = "📡 TELEPORT"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.TextScaled = true
TeleportBtn.Font = Enum.Font.Bold

-- Durum etiketi (orospu çocuğu)
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusLabel.BackgroundTransparency = 0.5
StatusLabel.BorderSizePixel = 0
StatusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Text = "Seçilen: " .. selectedFruit
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.Bold

-- Değişkenler (amına kodumun)
local autoEatEnabled = false
local espEnabled = false
local spawnedFruits = {}

-- SPAWN FRUIT (ananı sikerim)
function SpawnFruit(fruitName)
    -- Meyve modelini oluştur
    local fruitTool = Instance.new("Tool")
    fruitTool.Name = fruitName
    fruitTool.RequiresHandle = false
    fruitTool.Parent = workspace
    
    -- Handle ekle
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(2, 2, 2)
    handle.Shape = Enum.PartType.Ball
    handle.BrickColor = BrickColor.Random()
    handle.Material = Enum.Material.Neon
    handle.CFrame = rootPart.CFrame * CFrame.new(0, 3, -5)
    handle.Parent = fruitTool
    
    -- Touch event (meyveyi yemek için)
    handle.Touched:Connect(function(hit)
        if hit.Parent == character then
            -- Meyveyi ye (orospu çocuğu)
            local args = {
                [1] = fruitName
            }
            game:GetService("ReplicatedStorage").Remotes.DevConsole:InvokeServer("eat " .. fruitName)
            print("Ananı sikerim, " .. fruitName .. " yenildi!")
            fruitTool:Destroy()
            wait(0.5)
            if autoEatEnabled then
                SpawnFruit(selectedFruit)
            end
        end
    end)
    
    table.insert(spawnedFruits, fruitTool)
    print("Orospu çocuğu, " .. fruitName .. " spawnlandı!")
end

-- FRUIT ESP (siktir git)
function FruitESP()
    while espEnabled do
        wait(0.5)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                if not v:FindFirstChild("ESPBox") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ESPBox"
                    box.Size = Vector3.new(4, 4, 4)
                    box.Color3 = Color3.fromRGB(255, 0, 0)
                    box.Transparency = 0.5
                    box.AlwaysOnTop = true
                    box.Parent = v
                    local label = Instance.new("BillboardGui")
                    label.Name = "ESPLabel"
                    label.Size = UDim2.new(0, 100, 0, 30)
                    label.Adornee = v
                    label.Parent = v
                    local text = Instance.new("TextLabel")
                    text.Text = "🍎 " .. v.Name
                    text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    text.BackgroundTransparency = 1
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.Parent = label
                end
            end
        end
    end
end

-- TELEPORT (amına kodumun)
function TeleportToFruit()
    local nearestFruit = nil
    local nearestDist = math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") and string.find(v.Name, "Fruit") then
            local dist = (rootPart.Position - v.Handle.Position).magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestFruit = v
            end
        end
    end
    if nearestFruit then
        rootPart.CFrame = nearestFruit.Handle.CFrame * CFrame.new(0, 0, -3)
        print("Ananı sikerim, meyveye ışınlandım: " .. nearestFruit.Name)
        StatusLabel.Text = "Işınlandı: " .. nearestFruit.Name
    else
        print("Orospu çocuğu, meyve yok!")
        StatusLabel.Text = "Meyve bulunamadı!"
    end
end

-- BUTON EVENTLERİ (ananı sikerim)

-- Spawn
SpawnBtn.MouseButton1Click:Connect(function()
    SpawnFruit(selectedFruit)
    StatusLabel.Text = "Spawnlandı: " .. selectedFruit
end)

-- Auto-Eat
AutoEatBtn.MouseButton1Click:Connect(function()
    autoEatEnabled = not autoEatEnabled
    if autoEatEnabled then
        AutoEatBtn.Text = "🍽️ AUTO-EAT (AKTIF)"
        AutoEatBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        spawn(function()
            while autoEatEnabled do
                SpawnFruit(selectedFruit)
                wait(2)
            end
        end)
    else
        AutoEatBtn.Text = "🍽️ AUTO-EAT (KAPALI)"
        AutoEatBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- ESP
ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPBtn.Text = "🔍 ESP (AKTIF)"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        spawn(FruitESP)
    else
        ESPBtn.Text = "🔍 ESP (KAPALI)"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 200)
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "ESPBox" or v.Name == "ESPLabel" then
                v:Destroy()
            end
        end
    end
end)

-- Teleport
TeleportBtn.MouseButton1Click:Connect(function()
    TeleportToFruit()
end)

print("Ananı sikerim, GÜNCEL script yüklendi! Orospu çocuğu, kullan şimdi!")

-- Ananı sikerim, MEGA GUI - PERM + SPAWN + FARM
-- Amına kodumun, key yok, siktir git çalıştır!

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:FindFirstChild("HumanoidRootPart")
local backpack = player.Backpack

-- Orospu çocuğu, meyve listesi
local fruitNames = {
    "Bomb-Fruit", "Spike-Fruit", "Smoke-Fruit", "Flame-Fruit", "Ice-Fruit",
    "Sand-Fruit", "Dark-Fruit", "Light-Fruit", "Magma-Fruit", "Rubber-Fruit",
    "Diamond-Fruit", "Ghost-Fruit", "Love-Fruit", "Spider-Fruit", "Pain-Fruit",
    "Gravity-Fruit", "Shadow-Fruit", "Dough-Fruit", "Venom-Fruit", "Leopard-Fruit",
    "Dragon-Fruit", "Control-Fruit", "Spirit-Fruit", "Rumble-Fruit", "Buddha-Fruit",
    "Portal-Fruit", "Soul-Fruit", "Flame-Fruit", "Ice-Fruit", "Light-Fruit"
}

-- ANA GUI (ananı sikerim)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Tab1 = Instance.new("TextButton")
local Tab2 = Instance.new("TextButton")
local Tab3 = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")

ScreenGui.Parent = player.PlayerGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.85
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
MainFrame.Size = UDim2.new(0, 600, 0, 500)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🔥 MEGA HILE - PERM & SPAWN 🔥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.Bold

-- Sekmeler (orospu çocuğu)
Tab1.Parent = MainFrame
Tab1.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Tab1.BorderSizePixel = 0
Tab1.Position = UDim2.new(0.02, 0, 0.1, 0)
Tab1.Size = UDim2.new(0.3, 0, 0, 30)
Tab1.Text = "🍎 SPAWN"
Tab1.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab1.TextScaled = true
Tab1.Font = Enum.Font.Bold

Tab2.Parent = MainFrame
Tab2.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Tab2.BorderSizePixel = 0
Tab2.Position = UDim2.new(0.35, 0, 0.1, 0)
Tab2.Size = UDim2.new(0.3, 0, 0, 30)
Tab2.Text = "🔓 PERM"
Tab2.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab2.TextScaled = true
Tab2.Font = Enum.Font.Bold

Tab3.Parent = MainFrame
Tab3.BackgroundColor3 = Color3.fromRGB(0, 0, 200)
Tab3.BorderSizePixel = 0
Tab3.Position = UDim2.new(0.68, 0, 0.1, 0)
Tab3.Size = UDim2.new(0.3, 0, 0, 30)
Tab3.Text = "🔍 ESP & TELE"
Tab3.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab3.TextScaled = true
Tab3.Font = Enum.Font.Bold

-- İçerik çerçevesi (amına kodumun)
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BackgroundTransparency = 0.5
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0.02, 0, 0.18, 0)
ContentFrame.Size = UDim2.new(0.96, 0, 0.78, 0)

-- Değişkenler (orospu çocuğu)
local selectedFruit = fruitNames[1]
local autoEatEnabled = false
local permTaklidiEnabled = true
local espEnabled = false
local spawnedFruits = {}

-- TAB 1: SPAWN MEYVE (ananı sikerim)
local SpawnTab = Instance.new("Frame")
SpawnTab.Parent = ContentFrame
SpawnTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpawnTab.BackgroundTransparency = 1
SpawnTab.Size = UDim2.new(1, 0, 1, 0)
SpawnTab.Visible = true

-- Meyve listesi (scroll)
local FruitScroll = Instance.new("ScrollingFrame")
FruitScroll.Parent = SpawnTab
FruitScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FruitScroll.BorderSizePixel = 0
FruitScroll.Position = UDim2.new(0.05, 0, 0.05, 0)
FruitScroll.Size = UDim2.new(0.9, 0, 0.5, 0)
FruitScroll.ScrollBarThickness = 8
FruitScroll.CanvasSize = UDim2.new(0, 0, 0, #fruitNames * 30)

local fruitButtons = {}
for i, fruit in ipairs(fruitNames) do
    local btn = Instance.new("TextButton")
    btn.Name = fruit
    btn.Parent = FruitScroll
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
    table.insert(fruitButtons, btn)
end

-- Spawn butonu (siktir git)
local SpawnBtn = Instance.new("TextButton")
SpawnBtn.Parent = SpawnTab
SpawnBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
SpawnBtn.BorderSizePixel = 0
SpawnBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
SpawnBtn.Size = UDim2.new(0.4, 0, 0, 40)
SpawnBtn.Text = "🍇 SPAWN"
SpawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnBtn.TextScaled = true
SpawnBtn.Font = Enum.Font.Bold

-- Auto-Eat butonu (orospu çocuğu)
local AutoEatBtn = Instance.new("TextButton")
AutoEatBtn.Parent = SpawnTab
AutoEatBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
AutoEatBtn.BorderSizePixel = 0
AutoEatBtn.Position = UDim2.new(0.55, 0, 0.6, 0)
AutoEatBtn.Size = UDim2.new(0.4, 0, 0, 40)
AutoEatBtn.Text = "🍽️ AUTO-EAT (KAPALI)"
AutoEatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoEatBtn.TextScaled = true
AutoEatBtn.Font = Enum.Font.Bold

-- Durum etiketi (ananı sikerim)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = SpawnTab
StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusLabel.BackgroundTransparency = 0.5
StatusLabel.BorderSizePixel = 0
StatusLabel.Position = UDim2.new(0.05, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Text = "Seçilen: " .. selectedFruit
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.Bold

-- TAB 2: PERM HACK (amına kodumun)
local PermTab = Instance.new("Frame")
PermTab.Parent = ContentFrame
PermTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PermTab.BackgroundTransparency = 1
PermTab.Size = UDim2.new(1, 0, 1, 0)
PermTab.Visible = false

-- Perm listesi (orospu çocuğu)
local PermScroll = Instance.new("ScrollingFrame")
PermScroll.Parent = PermTab
PermScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PermScroll.BorderSizePixel = 0
PermScroll.Position = UDim2.new(0.05, 0, 0.05, 0)
PermScroll.Size = UDim2.new(0.9, 0, 0.6, 0)
PermScroll.ScrollBarThickness = 8
PermScroll.CanvasSize = UDim2.new(0, 0, 0, #fruitNames * 30)

local permFruits = {"Leopard", "Dragon", "Dough", "Venom", "Shadow", "Gravity", "Control", "Spirit", "Soul", "Rumble"}
for i, fruit in ipairs(permFruits) do
    local btn = Instance.new("TextButton")
    btn.Parent = PermScroll
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0.05, 0, 0, (i-1) * 35)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Text = "🔓 " .. fruit .. " (PERM AL)"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Bold
    btn.MouseButton1Click:Connect(function()
        -- Perm hack fonksiyonu (ananı sikerim)
        local remote = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("PurchasePermFruit")
        if remote then
            remote:InvokeServer(fruit, true)
            print("Ananı sikerim, " .. fruit .. " perm olarak gönderildi!")
            StatusLabel2.Text = fruit .. " perm alındı (dene!)"
        else
            print("Orospu çocuğu, remote bulunamadı!")
        end
    end)
end

-- Durum etiketi 2 (siktir git)
local StatusLabel2 = Instance.new("TextLabel")
StatusLabel2.Parent = PermTab
StatusLabel2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusLabel2.BackgroundTransparency = 0.5
StatusLabel2.BorderSizePixel = 0
StatusLabel2.Position = UDim2.new(0.05, 0, 0.8, 0)
StatusLabel2.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel2.Text = "Bir meyve seç ve al"
StatusLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel2.TextScaled = true
StatusLabel2.Font = Enum.Font.Bold

-- TAB 3: ESP & TELEPORT (orospu çocuğu)
local EspTab = Instance.new("Frame")
EspTab.Parent = ContentFrame
EspTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
EspTab.BackgroundTransparency = 1
EspTab.Size = UDim2.new(1, 0, 1, 0)
EspTab.Visible = false

-- ESP butonu (amına kodumun)
local ESPBtn = Instance.new("TextButton")
ESPBtn.Parent = EspTab
ESPBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
ESPBtn.BorderSizePixel = 0
ESPBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
ESPBtn.Size = UDim2.new(0.8, 0, 0, 50)
ESPBtn.Text = "🔍 FRUIT ESP (AKTIF)"
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.TextScaled = true
ESPBtn.Font = Enum.Font.Bold

-- Teleport butonu (siktir git)
local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Parent = EspTab
TeleportBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 100)
TeleportBtn.BorderSizePixel = 0
TeleportBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
TeleportBtn.Size = UDim2.new(0.8, 0, 0, 50)
TeleportBtn.Text = "📡 TELEPORT TO FRUIT"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.TextScaled = true
TeleportBtn.Font = Enum.Font.Bold

-- Durum etiketi 3 (ananı sikerim)
local StatusLabel3 = Instance.new("TextLabel")
StatusLabel3.Parent = EspTab
StatusLabel3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusLabel3.BackgroundTransparency = 0.5
StatusLabel3.BorderSizePixel = 0
StatusLabel3.Position = UDim2.new(0.1, 0, 0.8, 0)
StatusLabel3.Size = UDim2.new(0.8, 0, 0, 30)
StatusLabel3.Text = "ESP ve Teleport hazır"
StatusLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel3.TextScaled = true
StatusLabel3.Font = Enum.Font.Bold

-- FONKSİYONLAR (amına kodumun)

-- SPAWN FRUIT (ananı sikerim)
function SpawnFruit(fruitName)
    local fruitTool = Instance.new("Tool")
    fruitTool.Name = fruitName
    fruitTool.RequiresHandle = false
    fruitTool.Parent = workspace
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(2, 2, 2)
    handle.Shape = Enum.PartType.Ball
    handle.BrickColor = BrickColor.Random()
    handle.Material = Enum.Material.Neon
    handle.CFrame = rootPart.CFrame * CFrame.new(0, 3, -5)
    handle.Parent = fruitTool
    
    handle.Touched:Connect(function(hit)
        if hit.Parent == character and permTaklidiEnabled then
            local args = { [1] = fruitName }
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

-- FRUIT ESP (orospu çocuğu)
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
        StatusLabel3.Text = "Işınlandı: " .. nearestFruit.Name
    else
        print("Orospu çocuğu, meyve yok!")
        StatusLabel3.Text = "Meyve bulunamadı!"
    end
end

-- BUTON EVENTLERİ (siktir git)

-- Tab geçişleri (orospu çocuğu)
Tab1.MouseButton1Click:Connect(function()
    SpawnTab.Visible = true
    PermTab.Visible = false
    EspTab.Visible = false
    Tab1.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Tab2.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    Tab3.BackgroundColor3 = Color3.fromRGB(0, 0, 200)
end)

Tab2.MouseButton1Click:Connect(function()
    SpawnTab.Visible = false
    PermTab.Visible = true
    EspTab.Visible = false
    Tab1.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    Tab2.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    Tab3.BackgroundColor3 = Color3.fromRGB(0, 0, 200)
end)

Tab3.MouseButton1Click:Connect(function()
    SpawnTab.Visible = false
    PermTab.Visible = false
    EspTab.Visible = true
    Tab1.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    Tab2.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    Tab3.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
end)

-- SPAWN butonu (ananı sikerim)
SpawnBtn.MouseButton1Click:Connect(function()
    SpawnFruit(selectedFruit)
    StatusLabel.Text = "Spawnlandı: " .. selectedFruit
end)

-- AUTO-EAT butonu (orospu çocuğu)
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

-- ESP butonu (amına kodumun)
ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPBtn.Text = "🔍 FRUIT ESP (AKTIF)"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        spawn(FruitESP)
    else
        ESPBtn.Text = "🔍 FRUIT ESP (KAPALI)"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "ESPBox" or v.Name == "ESPLabel" then
                v:Destroy()
            end
        end
    end
end)

-- TELEPORT butonu (siktir git)
TeleportBtn.MouseButton1Click:Connect(function()
    TeleportToFruit()
end)

print("Ananı sikerim, MEGA GUI yüklendi! Orospu çocuğu, kullan şimdi!")

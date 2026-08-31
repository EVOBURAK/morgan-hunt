-- =============================================================
-- 🌿 MORGAN HUB – ULTRA COOL DEFINITIVE EDITION (FIXED) 🌿
-- =============================================================

if not table.find({2753915549, 4442272183, 7449423635}, game.PlaceId) then
    game:GetService("Players").LocalPlayer:Kick("Lütfen Blox Fruits sunucusuna girin!")
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Anti-AFK Koruması
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)

-- Eski GUI Varsa Temizle
if player.PlayerGui:FindFirstChild("MorganHubUltra") then
    player.PlayerGui.MorganHubUltra:Destroy()
end

-- =============================================================
-- CREAZIONE HUB CON GLASSMORPHISM + GLOW
-- =============================================================
local hub = Instance.new("ScreenGui")
hub.Name = "MorganHubUltra"
hub.ResetOnSpawn = false
hub.Parent = player.PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 460, 0, 520)
main.Position = UDim2.new(0.5, -230, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(10, 20, 10)
main.BackgroundTransparency = 0.25
main.BorderSizePixel = 0
main.ClipsDescendants = false
main.Active = true
main.Draggable = true
main.Parent = hub

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 22)
corner.Parent = main

local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, 12, 1, 12)
glow.Position = UDim2.new(0, -6, 0, -6)
glow.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
glow.BackgroundTransparency = 0.65
glow.BorderSizePixel = 0
glow.ZIndex = 0
glow.Parent = main

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 26)
glowCorner.Parent = glow

local glow2 = Instance.new("Frame")
glow2.Size = UDim2.new(1, 8, 1, 8)
glow2.Position = UDim2.new(0, -4, 0, -4)
glow2.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
glow2.BackgroundTransparency = 0.8
glow2.BorderSizePixel = 0
glow2.ZIndex = 0
glow2.Parent = main

local glowCorner2 = Instance.new("UICorner")
glowCorner2.CornerRadius = UDim.new(0, 24)
glowCorner2.Parent = glow2

-- LOGO & BAŞLIK
local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0.7, 0, 0, 40)
logo.Position = UDim2.new(0.05, 0, 0.03, 0)
logo.BackgroundTransparency = 1
logo.Text = "🌿 MORGAN HUB"
logo.TextColor3 = Color3.fromRGB(0, 255, 150)
logo.TextSize = 26
logo.Font = Enum.Font.GothamBold
logo.TextXAlignment = Enum.TextXAlignment.Left
logo.Parent = main

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(0.6, 0, 0, 20)
sub.Position = UDim2.new(0.05, 0, 0.10, 0)
sub.BackgroundTransparency = 1
sub.Text = "by Morgan ✦ Ultra Edition (Fixed)"
sub.TextColor3 = Color3.fromRGB(0, 210, 120)
sub.TextSize = 13
sub.Font = Enum.Font.Gotham
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 32, 0, 32)
close.Position = UDim2.new(1, -40, 0, 12)
close.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
close.BorderSizePixel = 0
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(0, 255, 130)
close.TextSize = 18
close.Font = Enum.Font.GothamBold
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = close
close.MouseButton1Click:Connect(function() hub:Destroy() end)

-- =============================================================
-- TOGGLE FONKSİYONU
-- =============================================================
local function createToggle(parent, yPos, labelText, defaultState)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.9, 0, 0, 48)
    card.Position = UDim2.new(0.05, 0, yPos, 0)
    card.BackgroundColor3 = Color3.fromRGB(15, 28, 15)
    card.BackgroundTransparency = 0.35
    card.BorderSizePixel = 1
    card.BorderColor3 = Color3.fromRGB(0, 220, 90)
    card.Parent = parent

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 12)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(170, 255, 200)
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local toggleBg = Instance.new("TextButton")
    toggleBg.Size = UDim2.new(0, 50, 0, 26)
    toggleBg.Position = UDim2.new(0.82, 0, 0.22, 0)
    toggleBg.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 70) or Color3.fromRGB(35, 65, 35)
    toggleBg.AutoButtonColor = false
    toggleBg.Text = ""
    toggleBg.Parent = card

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 13)
    toggleCorner.Parent = toggleBg

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = defaultState and UDim2.new(0.55, 0, 0.12, 0) or UDim2.new(0.08, 0, 0.12, 0)
    knob.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    knob.Parent = toggleBg

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 10)
    knobCorner.Parent = knob

    local state = defaultState or false

    local function updateToggle(newState)
        state = newState
        if state then
            toggleBg.BackgroundColor3 = Color3.fromRGB(0, 200, 70)
            knob.Position = UDim2.new(0.55, 0, 0.12, 0)
        else
            toggleBg.BackgroundColor3 = Color3.fromRGB(35, 65, 35)
            knob.Position = UDim2.new(0.08, 0, 0.12, 0)
        end
    end

    toggleBg.MouseButton1Click:Connect(function() updateToggle(not state) end)

    return {
        get = function() return state end,
        set = function(newState) updateToggle(newState) end
    }
end

-- DÜĞMELER
local yStart = 0.16
local spacing = 0.11

local autoFarm = createToggle(main, yStart, "🚀 Auto-Farm Level (Otomatik)", false)
local autoAttack = createToggle(main, yStart + spacing, "⚔️ Fast Attack (Hızlı Saldırı)", false)
local speedHack = createToggle(main, yStart + spacing * 2, "🏃 Speed Hack (Hızlı Yürüme)", false)
local flyMode = createToggle(main, yStart + spacing * 3, "🕊️ Fly Hack (Uçma Modu)", false)

-- BUTONLAR
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0.42, 0, 0, 42)
teleportBtn.Position = UDim2.new(0.05, 0, yStart + spacing * 4 + 0.02, 0)
teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 40)
teleportBtn.BorderSizePixel = 0
teleportBtn.Text = "🌀 Teleport En Yakın Mob"
teleportBtn.TextColor3 = Color3.fromRGB(150, 255, 200)
teleportBtn.TextSize = 12
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.Parent = main
local teleCorner = Instance.new("UICorner")
teleCorner.CornerRadius = UDim.new(0, 10)
teleCorner.Parent = teleportBtn

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.42, 0, 0, 42)
resetBtn.Position = UDim2.new(0.53, 0, yStart + spacing * 4 + 0.02, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(70, 20, 20)
resetBtn.BorderSizePixel = 0
resetBtn.Text = "🔄 Durdur / Reset"
resetBtn.TextColor3 = Color3.fromRGB(255, 160, 160)
resetBtn.TextSize = 12
resetBtn.Font = Enum.Font.GothamBold
resetBtn.Parent = main
local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 10)
resetCorner.Parent = resetBtn

-- STATÜ PANELİ
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 36)
status.Position = UDim2.new(0.05, 0, yStart + spacing * 4 + 0.14, 0)
status.BackgroundColor3 = Color3.fromRGB(10, 25, 10)
status.BackgroundTransparency = 0.3
status.BorderSizePixel = 1
status.BorderColor3 = Color3.fromRGB(0, 255, 100)
status.Text = "🔴 DURUM: Hazır"
status.TextColor3 = Color3.fromRGB(160, 255, 190)
status.TextSize = 13
status.Font = Enum.Font.GothamMedium
status.Parent = main
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = status

-- =============================================================
-- LOGIC & GAMEPLAY FIXES (DÜZELTİLEN MEKANİKLER)
-- =============================================================

-- En Yakın Düşmanı Bulma (Çökme Yapmayan Güvenli Tarama)
local function getNearestEnemy()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart

    local nearest, maxDist = nil, 2000
    local enemiesFolder = Workspace:FindFirstChild("Enemies")

    if enemiesFolder then
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                local dist = (root.Position - enemy.HumanoidRootPart.Position).Magnitude
                if dist < maxDist then
                    maxDist = dist
                    nearest = enemy
                end
            end
        end
    end
    return nearest
end

-- Uçma Mantığı (Noclip + BodyVelocity)
local flyVelocity = nil
local function toggleFly(enable)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if enable then
        if not flyVelocity then
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
            flyVelocity.Velocity = Vector3.zero
            flyVelocity.Parent = root
        end
    else
        if flyVelocity then
            flyVelocity:Destroy()
            flyVelocity = nil
        end
    end
end

-- DÖNGÜ (Loop)
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local root = char.HumanoidRootPart
            local hum = char:FindFirstChildOfClass("Humanoid")

            -- Speed Hack
            if speedHack.get() and hum then
                hum.WalkSpeed = 70
            elseif hum and not speedHack.get() then
                hum.WalkSpeed = 16
            end

            -- Fly Hack
            toggleFly(flyMode.get())
            if flyMode.get() and flyVelocity then
                local camCFrame = Workspace.CurrentCamera.CFrame
                local moveDir = Vector3.zero
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCFrame.RightVector end
                
                flyVelocity.Velocity = moveDir * 80
            end

            -- Auto Attack (Tıklama Gönderir)
            if autoAttack.get() then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(500, 500))
            end

            -- Auto Farm
            if autoFarm.get() then
                local target = getNearestEnemy()
                if target and target:FindFirstChild("HumanoidRootPart") then
                    root.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    status.Text = "⚔️ SALDIRILIYOR: " .. target.Name
                    
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(500, 500))
                else
                    status.Text = "🔍 Düşman aranıyor..."
                end
            end
        end)
    end
end)

-- TELEPORT
teleportBtn.MouseButton1Click:Connect(function()
    local target = getNearestEnemy()
    if target and target:FindFirstChild("HumanoidRootPart") and player.Character then
        player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        status.Text = "🌀 Işınlanıldı: " .. target.Name
    else
        status.Text = "❌ Yakında düşman bulunamadı!"
    end
end)

-- RESET
resetBtn.MouseButton1Click:Connect(function()
    autoFarm.set(false)
    autoAttack.set(false)
    speedHack.set(false)
    flyMode.set(false)
    toggleFly(false)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
    status.Text = "🔴 DURUM: Tüm hileler kapatıldı"
end)

-- NOTİFİKASYON
game.StarterGui:SetCore("SendNotification", {
    Title = "🌿 MORGAN HUB",
    Text = "Script başarıyla yüklendi ve aktifleştirildi!",
    Duration = 3
})

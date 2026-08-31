-- =============================================================
-- 🌿 MORGAN HUB V5.0 (ESP + AIMBOT + AUTO PLAYER HUNT) 🌿
-- =============================================================

if not table.find({2753915549, 4442272183, 7449423635}, game.PlaceId) then
    game:GetService("Players").LocalPlayer:Kick("Lütfen Blox Fruits sunucusuna girin!")
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Anti-AFK
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
end)

-- Temizlik
if player.PlayerGui:FindFirstChild("MorganHubV5") then
    player.PlayerGui.MorganHubV5:Destroy()
end

-- =============================================================
-- AYARLAR VE STATE (DURUM) YÖNETİMİ
-- =============================================================
local Settings = {
    ESP = false,
    Aimbot = false,
    AutoHunt = false,
    SkillMode = "1", -- "1" veya "2"
    TargetPlayer = nil
}

-- =============================================================
-- GUI MİMARİSİ
-- =============================================================
local hub = Instance.new("ScreenGui")
hub.Name = "MorganHubV5"
hub.ResetOnSpawn = false
hub.Parent = player.PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 480, 0, 360)
main.Position = UDim2.new(0.5, -240, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(15, 18, 24)
main.Active = true
main.Draggable = true
main.Parent = hub

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌿 MORGAN HUB V5.0 (HUNT + AIM)"
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 26, 0, 26)
close.Position = UDim2.new(1, -32, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.Parent = main
close.MouseButton1Click:Connect(function() hub:Destroy() end)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -55)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 4
container.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = container

local function addToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.98, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(22, 27, 36)
    frame.Parent = container

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 6)
    fc.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0.04, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 230, 240)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 46, 0, 22)
    btn.Position = UDim2.new(0.85, 0, 0.2, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 50, 65)
    btn.Text = ""
    btn.Parent = frame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 11)
    bc.Parent = btn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0.08, 0, 0.12, 0)
    circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    circle.Parent = btn

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = circle

    local st = false
    btn.MouseButton1Click:Connect(function()
        st = not st
        btn.BackgroundColor3 = st and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 50, 65)
        circle.Position = st and UDim2.new(0.55, 0, 0.12, 0) or UDim2.new(0.08, 0, 0.12, 0)
        pcall(callback, st)
    end)
end

-- MENÜ BUTONLARI
addToggle("👁️ ESP (Oyuncu Kutuları & İsimler)", function(v) Settings.ESP = v end)
addToggle("🎯 Silent Aimbot (Otomatik Nişan)", function(v) Settings.Aimbot = v end)
addToggle("⚔️ Auto Player Hunt (Oyuncuları Avla)", function(v) Settings.AutoHunt = v end)

-- =============================================================
-- ESP SİSTEMİ
-- =============================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MorganESP"
ESPFolder.Parent = CoreGui

local function createESP(plr)
    if plr == player then return end
    
    local Highlight = Instance.new("Highlight")
    Highlight.Name = plr.Name
    Highlight.FillColor = Color3.fromRGB(255, 50, 50)
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 0.5
    Highlight.OutlineTransparency = 0
    Highlight.Parent = ESPFolder

    RunService.RenderStepped:Connect(function()
        if Settings.ESP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            Highlight.Adornee = plr.Character
            Highlight.Enabled = true
        else
            Highlight.Enabled = false
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)

-- =============================================================
-- SKİLL VE TUŞ BASMA MEKANİZMASI (1 ve 2 TUŞLARI)
-- =============================================================
local VirtualInputManager = game:GetService("VirtualInputManager")

local function pressKey(key)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

-- Tuş Dinleyici (1 ve 2 Tuşları)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.One then
        Settings.SkillMode = "1"
        game.StarterGui:SetCore("SendNotification", {Title = "Skill Modu", Text = "Mod 1 (Z, X, C) Seçildi", Duration = 2})
    elseif input.KeyCode == Enum.KeyCode.Two then
        Settings.SkillMode = "2"
        game.StarterGui:SetCore("SendNotification", {Title = "Skill Modu", Text = "Mod 2 (C, X, Z, F) Seçildi", Duration = 2})
    end
end)

local function castSkills()
    if Settings.SkillMode == "1" then
        pressKey("Z") task.wait(0.3)
        pressKey("X") task.wait(0.3)
        pressKey("C") task.wait(0.3)
    elseif Settings.SkillMode == "2" then
        pressKey("C") task.wait(0.3)
        pressKey("X") task.wait(0.3)
        pressKey("Z") task.wait(0.3)
        pressKey("F") task.wait(0.3)
    end
end

-- =============================================================
-- KIRMIZI YAZI / KORUMA VE ÖLÜM KONTROLÜ
-- =============================================================
local function checkRedTextOrSafeZone()
    -- Oyundaki bildirim/hata yazılarını kontrol et (Safe Zone vb.)
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextLabel") and gui.Visible and gui.TextColor3.R > 0.8 and gui.TextColor3.G < 0.2 then
                if gui.Text:lower():find("died") or gui.Text:lower():find("safe") or gui.Text:lower():find("pvp") then
                    return true
                end
            end
        end
    end
    return false
end

-- =============================================================
-- OYUNCU TAKİP VE SALDIRI DÖNGÜSÜ (AUTO HUNT & AIMBOT)
-- =============================================================
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local root = char.HumanoidRootPart

            -- AIMBOT VE HUNT İÇİN HEDEF BULMA
            if Settings.AutoHunt or Settings.Aimbot then
                local target = Settings.TargetPlayer
                
                -- Hedef Geçersizse Yeni Hedef Seç
                if not target or not target.Character or not target.Character:FindFirstChild("Humanoid") or target.Character.Humanoid.Health <= 0 or checkRedTextOrSafeZone() then
                    Settings.TargetPlayer = nil
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            Settings.TargetPlayer = p
                            target = p
                            break
                        end
                    end
                end

                -- Hedef Varsa Saldırı/Takip Et
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = target.Character.HumanoidRootPart

                    -- Aimbot: Kamerayı Hedefe Kilitle
                    if Settings.Aimbot then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetRoot.Position)
                    end

                    -- Auto Hunt: Yanına Uç ve Vur
                    if Settings.AutoHunt then
                        -- Hedefin arkasında/üstünde dur
                        root.CFrame = targetRoot.CFrame * CFrame.new(0, 3, 3)
                        
                        -- Otomatik Tıklama + Yetenekler
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(500, 500))
                        
                        castSkills()
                    end
                end
            end
        end)
    end
end)

-- BİLDİRİM
game.StarterGui:SetCore("SendNotification", {
    Title = "🌿 MORGAN HUB V5.0",
    Text = "ESP, Aimbot ve Auto Hunt Hazır! (1 ve 2 Tuşlarını Kullanabilirsin)",
    Duration = 4
})

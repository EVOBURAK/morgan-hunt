-- =============================================================
-- 🌿 MORGAN HUB V1.0 (FIXED: INFINITE ESP + SKELETON + FOV AIM) 🌿
-- =============================================================

if not table.find({2753915549, 4442272183, 7449423635}, game.PlaceId) then
    game:GetService("Players").LocalPlayer:Kick("Lütfen Blox Fruits sunucusuna girin!")
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Anti-AFK Koruması
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
end)

-- Eski GUI Temizliği
if player.PlayerGui:FindFirstChild("MorganHubV1") then
    player.PlayerGui.MorganHubV1:Destroy()
end
if CoreGui:FindFirstChild("MorganESP") then
    CoreGui.MorganESP:Destroy()
end

-- AYARLAR
local Settings = {
    ESP = false,
    Aimbot = false,
    AutoHunt = false,
    SkillMode = "1",
    TargetPlayer = nil,
    FlySpeed = 75
}

-- GUI MİMARİSİ
local hub = Instance.new("ScreenGui")
hub.Name = "MorganHubV1"
hub.ResetOnSpawn = false
hub.Parent = player.PlayerGui

-- MENÜ LOGOSU (AÇ/KAPAT TOGGLE)
local toggleLogo = Instance.new("TextButton")
toggleLogo.Name = "MorganToggleLogo"
toggleLogo.Size = UDim2.new(0, 50, 0, 50)
toggleLogo.Position = UDim2.new(0, 15, 0.15, 0)
toggleLogo.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
toggleLogo.BorderSizePixel = 0
toggleLogo.Text = "🌿"
toggleLogo.TextSize = 26
toggleLogo.Active = true
toggleLogo.Draggable = true
toggleLogo.Parent = hub

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = toggleLogo

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(0, 255, 150)
logoStroke.Thickness = 2
logoStroke.Parent = toggleLogo

-- ANA MENÜ PENCERESİ
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

toggleLogo.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌿 MORGAN HUB V1.0 (ULTIMATE)"
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
close.MouseButton1Click:Connect(function() main.Visible = false end)

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

addToggle("👁️ ESP (Sonsuz Mesafe Kutu + İskelet)", function(v) Settings.ESP = v end)
addToggle("🎯 Aimbot (En Yakın Oyuncuyu Kilitle)", function(v) Settings.Aimbot = v end)
addToggle("🕊️ Auto Player Hunt (Süzülerek Avla)", function(v) Settings.AutoHunt = v end)

-- =============================================================
-- SONSUZ MESAFELİ ADVANCED ESP & SKELETON SİSTEMİ
-- =============================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MorganESP"
ESPFolder.Parent = CoreGui

local function drawESP(targetPlayer)
    if targetPlayer == player then return end

    local boxOutline = Drawing.new("Square")
    boxOutline.Visible = false
    boxOutline.Color = Color3.fromRGB(0, 0, 0)
    boxOutline.Thickness = 3
    boxOutline.Filled = false

    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 50, 50)
    box.Thickness = 1
    box.Filled = false

    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Size = 14
    nameTag.Center = true
    nameTag.Outline = true

    RunService.RenderStepped:Connect(function()
        if Settings.ESP and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer.Character:FindFirstChild("Humanoid") and targetPlayer.Character.Humanoid.Health > 0 then
            local root = targetPlayer.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

            if onScreen then
                local sizeY = (Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0)).Y)
                local sizeX = sizeY / 1.5

                boxOutline.Size = Vector2.new(sizeX, sizeY)
                boxOutline.Position = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2)
                boxOutline.Visible = true

                box.Size = Vector2.new(sizeX, sizeY)
                box.Position = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2)
                box.Visible = true

                nameTag.Text = targetPlayer.Name .. " [" .. math.floor(targetPlayer.Character.Humanoid.Health) .. " HP]"
                nameTag.Position = Vector2.new(pos.X, pos.Y - (sizeY / 2) - 15)
                nameTag.Visible = true
            else
                boxOutline.Visible = false
                box.Visible = false
                nameTag.Visible = false
            end
        else
            boxOutline.Visible = false
            box.Visible = false
            nameTag.Visible = false
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do drawESP(p) end
Players.PlayerAdded:Connect(drawESP)

-- =============================================================
-- EN YAKIN OYUNCUYU BULMA (AIMBOT VE HUNT İÇİN)
-- =============================================================
local function getClosestPlayer()
    local closest, maxDistance = nil, math.huge
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < maxDistance then
                maxDistance = dist
                closest = p
            end
        end
    end
    return closest
end

-- =============================================================
-- SKİLL VE TUŞ BASMA SİSTEMİ
-- =============================================================
local VirtualInputManager = game:GetService("VirtualInputManager")

local function pressKey(key)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.One then
        Settings.SkillMode = "1"
        game.StarterGui:SetCore("SendNotification", {Title = "Skill Modu", Text = "Mod 1 (Z, X, C) Aktif", Duration = 2})
    elseif input.KeyCode == Enum.KeyCode.Two then
        Settings.SkillMode = "2"
        game.StarterGui:SetCore("SendNotification", {Title = "Skill Modu", Text = "Mod 2 (C, X, Z, F) Aktif", Duration = 2})
    end
end)

local function castSkills()
    if Settings.SkillMode == "1" then
        pressKey("Z") task.wait(0.2)
        pressKey("X") task.wait(0.2)
        pressKey("C") task.wait(0.2)
    elseif Settings.SkillMode == "2" then
        pressKey("C") task.wait(0.2)
        pressKey("X") task.wait(0.2)
        pressKey("Z") task.wait(0.2)
        pressKey("F") task.wait(0.2)
    end
end

-- =============================================================
-- YAVAŞ VE DÜZGÜN UÇUŞ FİZİĞİ
-- =============================================================
local flyVelocity = nil
local flyGyro = nil

local function updateFlyPhysics(enable)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if enable then
        if not flyVelocity then
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.MaxForce = Vector3.new(1,1,1) * 1000000
            flyVelocity.Velocity = Vector3.zero
            flyVelocity.Parent = root
        end
        if not flyGyro then
            flyGyro = Instance.new("BodyGyro")
            flyGyro.MaxTorque = Vector3.new(1,1,1) * 1000000
            flyGyro.CFrame = root.CFrame
            flyGyro.Parent = root
        end
    else
        if flyVelocity then flyVelocity:Destroy() flyVelocity = nil end
        if flyGyro then flyGyro:Destroy() flyGyro = nil end
    end
end

-- =============================================================
-- ANA TAKİP VE SALDIRI DÖNGÜSÜ
-- =============================================================
task.spawn(function()
    while task.wait(0.03) do
        pcall(function()
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local root = char.HumanoidRootPart

            local target = getClosestPlayer()

            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = target.Character.HumanoidRootPart

                -- AIMBOT (En yakın adamın kafasına kilitleme)
                if Settings.Aimbot then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetRoot.Position)
                end

                -- AUTO HUNT (Uçarak gitme ve saldırma)
                if Settings.AutoHunt then
                    updateFlyPhysics(true)
                    local targetPos = targetRoot.Position + Vector3.new(0, 3, 0)
                    local dir = (targetPos - root.Position)
                    local dist = dir.Magnitude

                    if dist > 8 then
                        flyVelocity.Velocity = dir.Unit * Settings.FlySpeed
                        flyGyro.CFrame = CFrame.new(root.Position, targetPos)
                    else
                        flyVelocity.Velocity = Vector3.zero
                        flyGyro.CFrame = CFrame.new(root.Position, targetPos)

                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(500, 500))
                        castSkills()
                    end
                else
                    updateFlyPhysics(false)
                end
            else
                updateFlyPhysics(false)
            end
        end)
    end
end)

-- BİLDİRİM
game.StarterGui:SetCore("SendNotification", {
    Title = "🌿 MORGAN HUB V1.0",
    Text = "Düzeltmeler yapıldı, ESP sonsuz mesafe ve Aimbot en yakına kilitlendi!",
    Duration = 4
})

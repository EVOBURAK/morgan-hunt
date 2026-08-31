-- =============================================================
-- 🌿 MORGAN HUB V1.0 (PRO DEFINITIVE - CFRAME FLY FIX) 🌿
-- =============================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end)

-- Eski GUI Temizliği
if CoreGui:FindFirstChild("MorganHubV1") then CoreGui.MorganHubV1:Destroy() end

-- AYARLAR
local Settings = {
    ESP = false,
    Aimbot = false,
    AutoHunt = false,
    SkillMode = "1",
    FlySpeed = 2.5 -- CFrame Kayma Hızı
}

-- =============================================================
-- GUI MİMARİSİ
-- =============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV1"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- LOGO BUTTON (AÇ / KAPAT)
local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 45, 0, 45)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(15, 22, 18)
ToggleLogo.BorderSizePixel = 0
ToggleLogo.Text = "🌿"
ToggleLogo.TextSize = 24
ToggleLogo.Active = true
ToggleLogo.Draggable = true
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = ToggleLogo

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(0, 255, 120)
LogoStroke.Thickness = 2
LogoStroke.Parent = ToggleLogo

-- ANA MENÜ PENCERESİ
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 320)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 120)
MainStroke.Transparency = 0.6
MainStroke.Parent = MainFrame

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🌿 MORGAN HUB V1.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Container

local function addToggle(text, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(18, 24, 32)
    card.BorderSizePixel = 0
    card.Parent = Container

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 225, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(0.86, 0, 0.24, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 45, 58)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 11)
    btnCorner.Parent = btn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0.08, 0, 0.13, 0)
    circle.BackgroundColor3 = Color3.fromRGB(180, 190, 200)
    circle.BorderSizePixel = 0
    circle.Parent = btn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 8)
    circleCorner.Parent = circle

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 190, 100) or Color3.fromRGB(35, 45, 58)
        circle.Position = state and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
        pcall(callback, state)
    end)
end

addToggle("👁️ Sonsuz ESP (Kutu + İsim)", function(v) Settings.ESP = v end)
addToggle("🎯 Aimbot (En Yakın Oyuncu)", function(v) Settings.Aimbot = v end)
addToggle("🕊️ CFrame Auto Hunt (Uçarak Takip)", function(v) Settings.AutoHunt = v end)

-- =============================================================
-- DRAWING ESP SİSTEMİ
-- =============================================================
local ESPCache = {}

local function createESP(targetPlayer)
    if targetPlayer == LocalPlayer then return end

    local boxOutline = Drawing.new("Square")
    boxOutline.Thickness = 3
    boxOutline.Color = Color3.fromRGB(0, 0, 0)
    boxOutline.Filled = false
    boxOutline.Visible = false

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 40, 40)
    box.Filled = false
    box.Visible = false

    local text = Drawing.new("Text")
    text.Size = 14
    text.Center = true
    text.Outline = true
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Visible = false

    ESPCache[targetPlayer] = {BoxOutline = boxOutline, Box = box, Text = text}
end

local function removeESP(targetPlayer)
    if ESPCache[targetPlayer] then
        ESPCache[targetPlayer].BoxOutline:Remove()
        ESPCache[targetPlayer].Box:Remove()
        ESPCache[targetPlayer].Text:Remove()
        ESPCache[targetPlayer] = nil
    end
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for targetPlayer, esp in pairs(ESPCache) do
        local char = targetPlayer.Character
        if Settings.ESP and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local root = char.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

            if onScreen then
                local head = char:FindFirstChild("Head")
                local headPos = head and head.Position or (root.Position + Vector3.new(0, 2, 0))
                local legPos = root.Position - Vector3.new(0, 3, 0)

                local topScreen = Camera:WorldToViewportPoint(headPos + Vector3.new(0, 1, 0))
                local bottomScreen = Camera:WorldToViewportPoint(legPos)

                local height = math.abs(topScreen.Y - bottomScreen.Y)
                local width = height / 1.6

                esp.BoxOutline.Size = Vector2.new(width, height)
                esp.BoxOutline.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                esp.BoxOutline.Visible = true

                esp.Box.Size = Vector2.new(width, height)
                esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                esp.Box.Visible = true

                esp.Text.Text = targetPlayer.Name .. " [" .. math.floor(char.Humanoid.Health) .. " HP]"
                esp.Text.Position = Vector2.new(pos.X, pos.Y - (height / 2) - 16)
                esp.Text.Visible = true
            else
                esp.BoxOutline.Visible = false
                esp.Box.Visible = false
                esp.Text.Visible = false
            end
        else
            esp.BoxOutline.Visible = false
            esp.Box.Visible = false
            esp.Text.Visible = false
        end
    end
end)

-- =============================================================
-- EN YAKIN OYUNCU BULUCU
-- =============================================================
local function getClosestPlayer()
    local closest, minDistance = nil, math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < minDistance then
                minDistance = dist
                closest = p
            end
        end
    end
    return closest
end

-- =============================================================
-- SKİLL VE SALDIRI MEKANİZMASI
-- =============================================================
local VirtualInputManager = game:GetService("VirtualInputManager")

local function pressKey(key)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.wait(0.08)
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
-- CFRAME BAZLI TAKİP VE DÖNGÜ (ANTİ-CHEAT BOSH)
-- =============================================================
RunService.Heartbeat:Connect(function()
    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
        local root = myChar.HumanoidRootPart

        local target = getClosestPlayer()

        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = target.Character.HumanoidRootPart

            -- AIMBOT
            if Settings.Aimbot then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetRoot.Position)
            end

            -- AUTO HUNT (CFrame Fly - Anti-Cheat Engeline Takılmaz)
            if Settings.AutoHunt then
                myChar.Humanoid.PlatformStand = true -- Havada takılmama için fiziği devreden çıkarır
                
                local targetPos = targetRoot.Position + Vector3.new(0, 2, 0)
                local distance = (targetPos - root.Position).Magnitude

                if distance > 6 then
                    -- Adama doğru pürüzsüz CFrame kayması
                    root.CFrame = CFrame.lookAt(root.Position, targetPos) * CFrame.new(0, 0, -Settings.FlySpeed)
                else
                    root.CFrame = CFrame.lookAt(root.Position, targetPos)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(500, 500))
                    castSkills()
                end
            else
                myChar.Humanoid.PlatformStand = false
            end
        else
            if Settings.AutoHunt then
                myChar.Humanoid.PlatformStand = false
            end
        end
    end)
end)

-- BİLDİRİM
game.StarterGui:SetCore("SendNotification", {
    Title = "🌿 MORGAN HUB V1.0",
    Text = "Uçuş mekanizması CFrame ile yenilendi! Artık takılmadan adama gidecek.",
    Duration = 5
})

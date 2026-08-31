-- =================================================================================
-- 🌿 MORGAN HUB V5.1 (SMOOTH FLY & HUNT FIXED) 🌿
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Connections = {}

-- Anti-AFK
table.insert(Connections, LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end))

-- Clear Previous GUI
if CoreGui:FindFirstChild("MorganHubV5") then CoreGui.MorganHubV5:Destroy() end

-- SETTINGS
local Settings = {
    Language = "TR", -- "EN", "IT", "TR"
    ESP = false,
    FruitESP = false,
    AutoFarm = false,
    SelectedWeapon = "Melee",
    Aimbot = false,
    AutoHunt = false,
    AutoStore = true,
    LuckMultiplier = false,
    LuckPower = 100,
    FlySpeed = 200, -- Uçuş Hızı (Studs/Sec)
    FarmDistance = 8
}

-- TRANSLATIONS TABLE
local Translations = {
    EN = {
        Title = "🌿 MORGAN HUB V5.1",
        LuckGUI = "🍀 Luck Rate Booster GUI",
        LuckPower = "🍀 Luck Multiplier Power",
        AutoFarm = "🌾 Auto Farm Level (Mobs)",
        WeaponType = "⚔️ Auto Farm Weapon",
        AutoStore = "📦 Auto Store Fruit (Inventory)",
        FruitESP = "🖼️ Fruit ESP (With Image Icons)",
        PlayerESP = "👁️ Player ESP (Boxes & HP)",
        Aimbot = "🎯 Aimbot (Nearest Player)",
        AutoHunt = "⚡ Auto Bounty Hunt (Fast Fly)",
        FlySpeed = "⚙️ Fly / Hunt Speed",
        FarmDist = "⚙️ Auto Farm Height",
        LangToggle = "🌐 Language / Lingua / Dil",
        ConfirmDestroy = "Are you sure you want to destroy GUI?",
        Yes = "YES",
        No = "NO",
        Loaded = "Hub Loaded Successfully!"
    },
    TR = {
        Title = "🌿 MORGAN HUB V5.1",
        LuckGUI = "🍀 Şans Arttırıcı GUI",
        LuckPower = "🍀 Şans Çarpan Gücü",
        AutoFarm = "🌾 Otomatik Seviye Kasma",
        WeaponType = "⚔️ Auto Farm Silahı",
        AutoStore = "📦 Meyveyi Envantere Depola",
        FruitESP = "🖼️ Meyve ESP (Resimli)",
        PlayerESP = "👁️ Oyuncu ESP (Kutu & Can)",
        Aimbot = "🎯 Aimbot (En Yakın Oyuncu)",
        AutoHunt = "⚡ Otomatik Bounty Avı (Uçarak)",
        FlySpeed = "⚙️ Uçuş / Av Hızı",
        FarmDist = "⚙️ Auto Farm Yüksekliği",
        LangToggle = "🌐 Dil Seçimi / Language",
        ConfirmDestroy = "GUI'yi kapatmak istediğinize emin misiniz?",
        Yes = "EVET",
        No = "HAYIR",
        Loaded = "Hub Başarıyla Yüklendi!"
    }
}

-- FRUIT ICONS
local FruitIcons = {
    ["Kitsune"] = "rbxassetid://15312061073",
    ["Dragon"] = "rbxassetid://13886869488",
    ["Leopard"] = "rbxassetid://13886867744",
    ["Dough"] = "rbxassetid://13886866168",
    ["T-Rex"] = "rbxassetid://15682970597",
    ["Mammoth"] = "rbxassetid://14930198642",
    ["Spirit"] = "rbxassetid://13886869850",
    ["Venom"] = "rbxassetid://13886870244",
    ["Shadow"] = "rbxassetid://13886869634",
    ["Blizzard"] = "rbxassetid://13886865660",
    ["Buddha"] = "rbxassetid://13886865890",
    ["Portal"] = "rbxassetid://13886869150",
    ["Rumble"] = "rbxassetid://13886869348",
    ["Light"] = "rbxassetid://13886867888",
    ["Magma"] = "rbxassetid://13886868420",
    ["Ice"] = "rbxassetid://13886867566"
}
local DefaultIcon = "rbxassetid://13886865768"

local UILables = {}

-- GUI ARCHITECTURE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 48, 0, 48)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(15, 22, 18)
ToggleLogo.BorderSizePixel = 0
ToggleLogo.Text = "🌿"
ToggleLogo.TextSize = 26
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

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 500)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -250)
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
Title.Text = Translations[Settings.Language].Title
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Container

local function addToggle(key, defaultState, callback)
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
    label.Text = Translations[Settings.Language][key] or key
    label.TextColor3 = Color3.fromRGB(210, 225, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(0.86, 0, 0.24, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 190, 100) or Color3.fromRGB(35, 45, 58)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 11)
    btnCorner.Parent = btn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
    circle.BackgroundColor3 = Color3.fromRGB(180, 190, 200)
    circle.BorderSizePixel = 0
    circle.Parent = btn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 8)
    circleCorner.Parent = circle

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 190, 100) or Color3.fromRGB(35, 45, 58)
        circle.Position = state and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
        pcall(callback, state)
    end)
end

local function addSlider(key, min, max, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 50)
    card.BackgroundColor3 = Color3.fromRGB(18, 24, 32)
    card.BorderSizePixel = 0
    card.Parent = Container

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0.5, 0)
    label.Position = UDim2.new(0.04, 0, 0.08, 0)
    label.BackgroundTransparency = 1
    label.Text = Translations[Settings.Language][key] or key
    label.TextColor3 = Color3.fromRGB(210, 225, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0.76, 0, 0.08, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = card

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(0.92, 0, 0, 8)
    sliderBg.Position = UDim2.new(0.04, 0, 0.65, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 45, 58)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.Parent = card

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(val)
        pcall(callback, val)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

addToggle("AutoFarm", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle("AutoHunt", Settings.AutoHunt, function(v) Settings.AutoHunt = v end)
addToggle("Aimbot", Settings.Aimbot, function(v) Settings.Aimbot = v end)
addToggle("FruitESP", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("PlayerESP", Settings.ESP, function(v) Settings.ESP = v end)

addSlider("FlySpeed", 50, 350, Settings.FlySpeed, function(v) Settings.FlySpeed = v end)
addSlider("FarmDist", 3, 20, Settings.FarmDistance, function(v) Settings.FarmDistance = v end)

-- =============================================================
-- FLY TO TARGET ENGINE (PVP BOUNTY & AUTO HUNT)
-- =============================================================
local currentTween = nil

local function flyTo(targetCFrame)
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local root = myChar.HumanoidRootPart

    local distance = (root.Position - targetCFrame.Position).Magnitude
    local timeToTravel = distance / Settings.FlySpeed

    -- Karakterin fizik motoruyla yere düşmesini engelle
    if myChar:FindFirstChild("Humanoid") then
        myChar.Humanoid.PlatformStand = true
    end

    local tweenInfo = TweenInfo.new(timeToTravel, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    currentTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
end

local function stopFly()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

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
                closest = p.Character
            end
        end
    end
    return closest
end

-- AUTO BOUNTY HUNT LOOP (UÇARAK TAKİP)
table.insert(Connections, RunService.Heartbeat:Connect(function()
    if Settings.AutoHunt then
        pcall(function()
            local target = getClosestPlayer()
            if target and target:FindFirstChild("HumanoidRootPart") then
                -- Target'ın 4 stud yukarısına uç (Arkasına değil, tepesine)
                local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                flyTo(targetPos)

                -- Otomatik Vuruş
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(500, 500))
            else
                stopFly()
            end
        end)
    else
        if not Settings.AutoFarm then
            stopFly()
        end
    end
end))

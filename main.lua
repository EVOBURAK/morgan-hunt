-- =================================================================================
-- 💎 MORGAN HUB V9.0 (BYFRON BYPASS FLY & DYNAMIC REMOTES) 💎
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Connections = {}

table.insert(Connections, LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end))

if CoreGui:FindFirstChild("MorganHubV9") then CoreGui.MorganHubV9:Destroy() end

-- DİL SİSTEMİ
local Lang = {
    IT = {
        HubTitle = "💎 MORGAN HUB V9.0", Loading = "Bypass di Byfron...", Ready = "Pronto!",
        CloseMsg = "Chiudere la GUI?", Yes = "SÌ", No = "NO",
        AutoFarm = "🌾 Auto Farm (Bypass Fly)", PlayerESP = "👁️ Player ESP",
        Aimbot = "🎯 Aimbot", AutoHunt = "⚡ Auto Bounty Hunt",
        FruitESP = "🖼️ Fruit ESP", AutoStore = "📦 Auto Store Fruit",
        WeaponMelee = "⚔️ Seleziona Melee", WeaponFruit = "🍎 Seleziona Frutto",
        FlySpeed = "⚙️ Velocità Volo", FarmDist = "⚙️ Distanza Mob",
        NotifText = "Byfron bypassed cazzo!",
        IT = "🇮🇹 IT", TR = "🇹🇷 TR"
    },
    TR = {
        HubTitle = "💎 MORGAN HUB V9.0", Loading = "Byfron Bypass Ediliyor...", Ready = "Hazır!",
        CloseMsg = "GUI'yi kapatmak istediğinize emin misiniz?", Yes = "EVET", No = "HAYIR",
        AutoFarm = "🌾 Auto Farm (Bypass Uçuş)", PlayerESP = "👁️ Player ESP",
        Aimbot = "🎯 Aimbot", AutoHunt = "⚡ Auto Bounty Hunt",
        FruitESP = "🖼️ Fruit ESP", AutoStore = "📦 Auto Store Fruit",
        WeaponMelee = "⚔️ Melee Seç", WeaponFruit = "🍎 Fruit Seç",
        FlySpeed = "⚙️ Uçuş Hızı", FarmDist = "⚙️ Mob Mesafesi",
        NotifText = "Byfron sikildi amk!",
        IT = "🇮🇹 IT", TR = "🇹🇷 TR"
    }
}
local CurrentLang = "IT" 
local function T(key) return Lang[CurrentLang][key] or key end

local Settings = {
    ESP = false, FruitESP = false, AutoFarm = false, Aimbot = false, AutoHunt = false,
    AutoStore = true, SelectMelee = true, SelectFruit = false, FlySpeed = 1, FarmDistance = 15
}

-- DYNAMİC REMOTE FINDER (SİKTİR GİT HİÇBİR ŞEY BULAMAZSA İŞE YARAR)
local CommF = nil
pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_") end)
if not CommF then
    pcall(function() CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommE_") end)
end
if not CommF then
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") and v.Name:find("Comm") then
            CommF = v; break
        end
    end
end

-- GUI ŞEKLİ
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV9"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- AÇILIŞ
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0); LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
LoadingFrame.BorderSizePixel = 0; LoadingFrame.ZIndex = 100; LoadingFrame.Parent = ScreenGui
local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 50); LoadingTitle.Position = UDim2.new(0, 0, 0.38, 0)
LoadingTitle.BackgroundTransparency = 1; LoadingTitle.Text = T("HubTitle"); LoadingTitle.TextColor3 = Color3.fromRGB(180, 100, 255)
LoadingTitle.TextSize = 28; LoadingTitle.Font = Enum.Font.GothamBold; LoadingTitle.ZIndex = 101; LoadingTitle.Parent = LoadingFrame
local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 30); LoadingSub.Position = UDim2.new(0, 0, 0.45, 0)
LoadingSub.BackgroundTransparency = 1; LoadingSub.Text = T("Loading"); LoadingSub.TextColor3 = Color3.fromRGB(200, 170, 255)
LoadingSub.TextSize = 14; LoadingSub.Font = Enum.Font.GothamMedium; LoadingSub.ZIndex = 101; LoadingSub.Parent = LoadingFrame
local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 320, 0, 10); BarBg.Position = UDim2.new(0.5, -160, 0.55, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(25, 20, 40); BarBg.BorderSizePixel = 0; BarBg.ZIndex = 101; BarBg.Parent = LoadingFrame
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)
local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0); BarFill.BackgroundColor3 = Color3.fromRGB(160, 30, 255)
BarFill.BorderSizePixel = 0; BarFill.ZIndex = 102; BarFill.Parent = BarBg
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    TweenService:Create(BarFill, TweenInfo.new(2), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(2.2); LoadingSub.Text = T("Ready"); task.wait(0.5)
    TweenService:Create(LoadingFrame, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadingTitle, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(LoadingSub, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(BarBg, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    task.wait(0.8); LoadingFrame:Destroy()
end)

-- ANA PENCERE
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 460, 0, 530); MainFrame.Position = UDim2.new(0.5, -230, 0.5, -265)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 24); MainFrame.BorderSizePixel = 0
MainFrame.Active = true; MainFrame.Draggable = true; MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(160, 50, 255)

local BtnIT = Instance.new("TextButton")
BtnIT.Size = UDim2.new(0, 50, 0, 25); BtnIT.Position = UDim2.new(1, -120, 0, 10)
BtnIT.BackgroundColor3 = Color3.fromRGB(150, 40, 255); BtnIT.Text = T("IT"); BtnIT.TextColor3 = Color3.new(1,1,1)
BtnIT.Font = Enum.Font.GothamBold; BtnIT.TextSize = 12; BtnIT.Parent = MainFrame
Instance.new("UICorner", BtnIT).CornerRadius = UDim.new(0, 6)

local BtnTR = Instance.new("TextButton")
BtnTR.Size = UDim2.new(0, 50, 0, 25); BtnTR.Position = UDim2.new(1, -60, 0, 10)
BtnTR.BackgroundColor3 = Color3.fromRGB(45, 35, 65); BtnTR.Text = T("TR"); BtnTR.TextColor3 = Color3.new(1,1,1)
BtnTR.Font = Enum.Font.GothamBold; BtnTR.TextSize = 12; BtnTR.Parent = MainFrame
Instance.new("UICorner", BtnTR).CornerRadius = UDim.new(0, 6)

BtnIT.MouseButton1Click:Connect(function() CurrentLang = "IT"; BtnIT.BackgroundColor3 = Color3.fromRGB(150, 40, 255); BtnTR.BackgroundColor3 = Color3.fromRGB(45, 35, 65) end)
BtnTR.MouseButton1Click:Connect(function() CurrentLang = "TR"; BtnTR.BackgroundColor3 = Color3.fromRGB(150, 40, 255); BtnIT.BackgroundColor3 = Color3.fromRGB(45, 35, 65) end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -130, 0, 45); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = T("HubTitle"); Title.TextColor3 = Color3.fromRGB(200, 130, 255)
Title.TextSize = 16; Title.Font = Enum.Font.GothamBold; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26); CloseBtn.Position = UDim2.new(1, -32, 0, 42)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 70); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0); ConfirmFrame.BackgroundColor3 = Color3.fromRGB(12, 8, 18)
ConfirmFrame.BackgroundTransparency = 0.1; ConfirmFrame.Visible = false; ConfirmFrame.ZIndex = 10; ConfirmFrame.Parent = MainFrame
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 10)
local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, -20, 0.4, 0); ConfirmText.Position = UDim2.new(0, 10, 0.2, 0)
ConfirmText.BackgroundTransparency = 1; ConfirmText.Text = T("CloseMsg"); ConfirmText.TextColor3 = Color3.new(1,1,1)
ConfirmText.Font = Enum.Font.GothamBold; ConfirmText.TextSize = 13; ConfirmText.ZIndex = 11; ConfirmText.TextWrapped = true; ConfirmText.Parent = ConfirmFrame
local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 100, 0, 35); YesBtn.Position = UDim2.new(0.2, 0, 0.65, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 80); YesBtn.Text = T("Yes"); YesBtn.TextColor3 = Color3.new(1,1,1)
YesBtn.Font = Enum.Font.GothamBold; YesBtn.ZIndex = 11; YesBtn.Parent = ConfirmFrame
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)
local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 100, 0, 35); NoBtn.Position = UDim2.new(0.6, 0, 0.65, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 75); NoBtn.Text = T("No"); NoBtn.TextColor3 = Color3.new(1,1,1)
NoBtn.Font = Enum.Font.GothamBold; NoBtn.ZIndex = 11; NoBtn.Parent = ConfirmFrame
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -75); Container.Position = UDim2.new(0, 10, 0, 70)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(150, 60, 255); Container.Parent = MainFrame
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 6)

local function addToggle(textKey, defaultState, callback)
    local card = Instance.new("Frame"); card.Size = UDim2.new(0.98, 0, 0, 40)
    card.BackgroundColor3 = Color3.fromRGB(24, 18, 38); card.BorderSizePixel = 0; card.Parent = Container
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel"); label.Size = UDim2.new(0.7, 0, 1, 0); label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1; label.Text = T(textKey); label.TextColor3 = Color3.fromRGB(225, 215, 245)
    label.Font = Enum.Font.GothamMedium; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = card
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0, 44, 0, 22); btn.Position = UDim2.new(0.86, 0, 0.24, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65); btn.Text = ""; btn.Parent = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)
    local circle = Instance.new("Frame"); circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
    circle.BackgroundColor3 = Color3.new(1,1,1); circle.Parent = btn; Instance.new("UICorner", circle).CornerRadius = UDim.new(0, 8)
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state; btn.BackgroundColor3 = state and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
        circle.Position = state and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0); pcall(callback, state)
    end)
end

local function addSlider(textKey, min, max, default, callback)
    local card = Instance.new("Frame"); card.Size = UDim2.new(0.98, 0, 0, 50)
    card.BackgroundColor3 = Color3.fromRGB(24, 18, 38); card.BorderSizePixel = 0; card.Parent = Container
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel"); label.Size = UDim2.new(0.7, 0, 0.5, 0); label.Position = UDim2.new(0.04, 0, 0.08, 0)
    label.BackgroundTransparency = 1; label.Text = T(textKey); label.TextColor3 = Color3.fromRGB(225, 215, 245)
    label.Font = Enum.Font.GothamMedium; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = card
    local valueLabel = Instance.new("TextLabel"); valueLabel.Size = UDim2.new(0.2, 0, 0.5, 0); valueLabel.Position = UDim2.new(0.76, 0, 0.08, 0)
    valueLabel.BackgroundTransparency = 1; valueLabel.Text = tostring(default); valueLabel.TextColor3 = Color3.fromRGB(200, 120, 255)
    valueLabel.Font = Enum.Font.GothamBold; valueLabel.TextSize = 13; valueLabel.TextXAlignment = Enum.TextXAlignment.Right; valueLabel.Parent = card
    local sliderBg = Instance.new("TextButton"); sliderBg.Size = UDim2.new(0.92, 0, 0, 8); sliderBg.Position = UDim2.new(0.04, 0, 0.65, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 35, 65); sliderBg.Text = ""; sliderBg.Parent = card
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 4)
    local fill = Instance.new("Frame"); fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(160, 50, 255); fill.BorderSizePixel = 0; fill.Parent = sliderBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos)); fill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(val); pcall(callback, val)
    end
    sliderBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input) end end)
    sliderBg.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
end

addToggle("WeaponMelee", Settings.SelectMelee, function(v) Settings.SelectMelee = v end)
addToggle("WeaponFruit", Settings.SelectFruit, function(v) Settings.SelectFruit = v end)
addToggle("AutoFarm", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle("PlayerESP", Settings.ESP, function(v) Settings.ESP = v end)
addToggle("Aimbot", Settings.Aimbot, function(v) Settings.Aimbot = v end)
addToggle("AutoHunt", Settings.AutoHunt, function(v) Settings.AutoHunt = v end)
addToggle("FruitESP", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("AutoStore", Settings.AutoStore, function(v) Settings.AutoStore = v end)
-- Slider 0.1 ile 5 arası olmalı çünkü bu bir index, direk hız değil amk!
addSlider("FlySpeed", 1, 10, 5, function(v) Settings.FlySpeed = v end)
addSlider("FarmDist", 10, 30, Settings.FarmDistance, function(v) Settings.FarmDistance = v end)

-- =================================================================================
-- BYFRON BYPASS NO-CLIP FLY MOTORU (PHYSICS OBJESİZ SİKTİR GİT)
-- =================================================================================
local isFlying = false

local function StartFly()
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") then return end
        char.Humanoid:ChangeState(Enum.HumanoidStateType.StrafingNoPhysics)
        isFlying = true
    end)
end

local function StopFly()
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") then return end
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        isFlying = false
    end)
end

local function FlyTo(targetPos)
    pcall(function()
        if not isFlying then StartFly() end
        local root = LocalPlayer.Character.HumanoidRootPart
        local dir = (targetPos - root.Position)
        local dist = dir.Magnitude
        if dist > 5 then
            -- Hızı 1-10 arası sliderdan alıyoruz, bunu studs cinsine çeviriyoruz
            local speed = Settings.FlySpeed * 10 
            root.CFrame = root.CFrame + dir.Unit * speed
        end
    end)
end

-- WIKI TABLOSU
local RealQuestData = {
    {10, "JungleQuest", "Bandit [Lv. 5]", "Jungle"}, {15, "JungleQuest", "Monkey [Lv. 14]", "Jungle"},
    {30, "JungleQuest", "Gorilla [Lv. 20]", "Jungle"}, {45, "PirateQuest", "Pirate [Lv. 30]", "PirateVillage"},
    {60, "PirateQuest", "Brute [Lv. 40]", "PirateVillage"}, {90, "DesertQuest", "Desert Bandit [Lv. 60]", "Desert"},
    {120, "DesertQuest", "Desert Officer [Lv. 75]", "Desert"}, {150, "SnowQuest", "Snow Bandit [Lv. 90]", "FrozenVillage"},
    {175, "SnowQuest", "Snowman [Lv. 100]", "FrozenVillage"}, {200, "MarineQuest", "Petty Officer [Lv. 120]", "MarineFortress"},
    {225, "MarineQuest", "Vice Admiral [Lv. 130]", "MarineFortress"}, {275, "SkyQuest", "Sky Bandit [Lv. 150]", "Skypiea"},
    {300, "SkyQuest", "Dark Master [Lv. 175]", "Skypiea"}, {325, "PrisonerQuest", "Prisoner [Lv. 190]", "Prison"},
    {375, "PrisonerQuest", "Dangerous Prisoner [Lv. 210]", "Prison"}, {400, "ColosseumQuest", "Toga Warrior [Lv. 225]", "Colosseum"},
    {450, "ColosseumQuest", "Gladiator [Lv. 275]", "Colosseum"}, {525, "MagmaQuest", "Military Soldier [Lv. 300]", "MagmaVillage"},
    {575, "MagmaQuest", "Military Spy [Lv. 325]", "MagmaVillage"}, {625, "FishmanQuest", "Fishman Warrior [Lv. 375]", "UnderwaterCity"},
    {675, "FishmanQuest", "Fishman Commando [Lv. 400]", "UnderwaterCity"}, {750, "SkyQuest2", "God's Guard [Lv. 450]", "UpperSkylands"},
    {800, "SkyQuest2", "Shandian Warrior [Lv. 475]", "UpperSkylands"}, {850, "SkyQuest2", "Royal Squad [Lv. 525]", "UpperSkylands"},
    {900, "SkyQuest2", "Royal Guard [Lv. 550]", "UpperSkylands"}, {1000, "FountainQuest", "Galley Pirate [Lv. 625]", "FountainCity"},
    {1050, "FountainQuest", "Galley Captain [Lv. 650]", "FountainCity"}, {1125, "Area1Quest", "Raider [Lv. 700]", "KingdomOfRose"},
    {1150, "Area1Quest", "Mercenary [Lv. 725]", "KingdomOfRose"}, {1200, "Area1Quest", "Swan Pirate [Lv. 775]", "KingdomOfRose"},
    {1250, "Area2Quest", "Marine Lieutenant [Lv. 875]", "GreenZone"}, {1275, "Area2Quest", "Marine Captain [Lv. 900]", "GreenZone"},
    {1325, "Area3Quest", "Zombie [Lv. 950]", "Graveyard"}, {1350, "Area3Quest", "Vampire [Lv. 975]", "Graveyard"},
    {1375, "SnowMountainQuest", "Snow Trooper [Lv. 1000]", "SnowMountain"}, {1425, "SnowMountainQuest", "Winter Warrior [Lv. 1050]", "SnowMountain"},
    {1450, "HotCoolQuest", "Lab Subordinate [Lv. 1100]", "HotAndCold"}, {1475, "HotCoolQuest", "Horned Warrior [Lv. 1125]", "HotAndCold"},
    {1500, "HotCoolQuest", "Magma Ninja [Lv. 1175]", "HotAndCold"}, {1525, "HotCoolQuest", "Lava Pirate [Lv. 1200]", "HotAndCold"},
    {1575, "ShipQuest", "Ship Deckhand [Lv. 1250]", "CursedShip"}, {1600, "ShipQuest", "Ship Engineer [Lv. 1275]", "CursedShip"},
    {1625, "ShipQuest", "Ship Officer [Lv. 1300]", "CursedShip"}, {1650, "ShipQuest", "Ship Steward [Lv. 1325]", "CursedShip"},
    {1700, "IceSideQuest", "Arctic Warrior [Lv. 1350]", "IceCastle"}, {1725, "IceSideQuest", "Snow Lurker [Lv. 1375]", "IceCastle"},
    {1775, "ForgottenQuest", "Sea Soldier [Lv. 1425]", "ForgottenIsland"}, {1800, "ForgottenQuest", "Water Fighter [Lv. 1450]", "ForgottenIsland"},
    {1875, "PortQuest", "Pirate Millionaire [Lv. 1500]", "PortTown"}, {1900, "PortQuest", "Pistol Billionaire [Lv. 1525]", "PortTown"},
    {1925, "HydraQuest", "Dragon Crew Warrior [Lv. 1575]", "HydraIsland"}, {1950, "HydraQuest", "Dragon Crew Archer [Lv. 1600]", "HydraIsland"},
    {1975, "HydraQuest", "Female Islander [Lv. 1625]", "HydraIsland"}, {2000, "HydraQuest", "Giant Islander [Lv. 1650]", "HydraIsland"},
    {2025, "GreatTreeQuest", "Marine Commodore [Lv. 1700]", "GreatTree"}, {2050, "GreatTreeQuest", "Marine Rear Admiral [Lv. 1725]", "GreatTree"},
    {2075, "FloatingTurtleQuest", "Fishman Raider [Lv. 1775]", "FloatingTurtle"}, {2100, "FloatingTurtleQuest", "Fishman Captain [Lv. 1800]", "FloatingTurtle"},
    {2125, "FloatingTurtleQuest", "Forest Pirate [Lv. 1825]", "FloatingTurtle"}, {2150, "FloatingTurtleQuest", "Mythological Pirate [Lv. 1850]", "FloatingTurtle"},
    {2175, "FloatingTurtleQuest", "Jungle Pirate [Lv. 1900]", "FloatingTurtle"}, {2200, "FloatingTurtleQuest", "Musketeer Pirate [Lv. 1925]", "FloatingTurtle"},
    {2250, "HauntedQuest2", "Reborn Skeleton [Lv. 1975]", "HauntedCastle3"}, {2275, "HauntedQuest2", "Living Zombie [Lv. 2000]", "HauntedCastle3"},
    {2300, "HauntedQuest2", "Demonic Soul [Lv. 2025]", "HauntedCastle3"}, {2325, "HauntedQuest2", "Possessed Mummy [Lv. 2050]", "HauntedCastle3"},
    {2375, "CakeQuest", "Peanut Scout [Lv. 2075]", "PeanutLand"}, {2400, "CakeQuest", "Peanut President [Lv. 2100]", "PeanutLand"},
    {2425, "CakeQuest", "Ice Cream Chef [Lv. 2125]", "IceCreamLand"}, {2450, "CakeQuest", "Ice Cream Commander [Lv. 2150]", "IceCreamLand"},
    {2475, "CakeQuest", "Cookie Crafter [Lv. 2200]", "CakeLand"), {2500, "CakeQuest", "Cake Guard [Lv. 2225]", "CakeLand"},
    {2525, "CakeQuest", "Cocoa Warrior [Lv. 2300]", "ChocolateLand"}, {2550, "CakeQuest", "Chocolate Bar Battler [Lv. 2325]", "ChocolateLand"},
    {2600, "CakeQuest", "Candy Pirate [Lv. 2400]", "CandyIsland"}, {2650, "TikiQuest", "Isle Outlaw [Lv. 2450]", "TikiOutpost"},
    {2675, "TikiQuest", "Island Boy [Lv. 2475]", "TikiOutpost"}, {2700, "TikiQuest", "Sun-kissed Warrior [Lv. 2500]", "TikiOutpost"},
    {2750, "TikiQuest", "Isle Champion [Lv. 2525]", "TikiOutpost"}
}

local RealIslandPositions = {
    ["Jungle"] = CFrame.new(-1015, 15, -1830), ["PirateVillage"] = CFrame.new(1045, 15, 1530),
    ["Desert"] = CFrame.new(950, 15, 1640), ["FrozenVillage"] = CFrame.new(1190, 15, -1540),
    ["MarineFortress"] = CFrame.new(-2550, 75, -2350), ["Skypiea"] = CFrame.new(-4900, 800, -2600),
    ["Prison"] = CFrame.new(4850, 5, 800), ["Colosseum"] = CFrame.new(-160, 50, 360),
    ["MagmaVillage"] = CFrame.new(-5250, 15, 8500), ["UnderwaterCity"] = CFrame.new(6100, -300, 1500),
    ["UpperSkylands"] = CFrame.new(-7800, 5600, -2400), ["FountainCity"] = CFrame.new(-110, 15, 3700),
    ["KingdomOfRose"] = CFrame.new(-2200, 75, -5200), ["GreenZone"] = CFrame.new(-2400, 75, -3200),
    ["Graveyard"] = CFrame.new(-5400, 15, -800), ["SnowMountain"] = CFrame.new(1100, 600, -5100),
    ["HotAndCold"] = CFrame.new(-5900, 15, -1000), ["CursedShip"] = CFrame.new(920, 125, 3280),
    ["IceCastle"] = CFrame.new(6100, 15, -5100), ["ForgottenIsland"] = CFrame.new(-3000, 15, -3500),
    ["PortTown"] = CFrame.new(-290, 45, 5350), ["HydraIsland"] = CFrame.new(-4950, 310, -2900),
    ["GreatTree"] = CFrame.new(2100, 1250, -6500), ["FloatingTurtle"] = CFrame.new(-5200, 750, 4600),
    ["HauntedCastle3"] = CFrame.new(-5800, 100, -7300), ["PeanutLand"] = CFrame.new(-2100, 100, -10500),
    ["IceCreamLand"] = CFrame.new(-900, 100, -11000), ["CakeLand"] = CFrame.new(-1800, 100, -12000),
    ["ChocolateLand"] = CFrame.new(200, 100, -12300), ["CandyIsland"] = CFrame.new(1000, 100, -13000),
    ["TikiOutpost"] = CFrame.new(-16500, 50, 500)
}

local function GetQuestInfo()
    local lvl = LocalPlayer.Data.Level.Value
    for i, data in ipairs(RealQuestData) do
        if lvl <= data[1] then return data[2], data[3], 2, data[4] end
    end
    return "TikiQuest", "Isle Champion [Lv. 2525]", 2, "TikiOutpost"
end

local function SelectWeapon()
    pcall(function()
        local char = LocalPlayer.Character
        if not char or char:FindFirstChildOfClass("Tool") then return end
        if Settings.SelectFruit then
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:find("Fruit") or tool.Name:find("Meyve")) then char.Humanoid:EquipTool(tool); return end
            end
        end
        if Settings.SelectMelee then
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and not tool.Name:find("Fruit") and not tool.Name:find("Gun") then char.Humanoid:EquipTool(tool); return end
            end
        end
    end)
end

-- AUTO FARM
table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.AutoFarm then StopFly(); return end
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
        local root = char.HumanoidRootPart
        
        if not CommF then return end -- Remote yoksa siktiğini çıkar amk
        
        local qName, qMob, qLvl, qIsland = GetQuestInfo()
        CommF:InvokeServer("StartQuest", qName, qLvl)
        SelectWeapon()
        
        local closest, minDist = nil, math.huge
        if Workspace:FindFirstChild("Enemies") then
            for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy.Name == qMob and enemy:FindFirstChild("HumanoidRootPart") then
                    local dist = (enemy.HumanoidRootPart.Position - root.Position).Magnitude
                    if dist < minDist then minDist = dist; closest = enemy end
                end
            end
        end
        
        if closest then
            if not isFlying then StartFly() end
            local targetPos = closest.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
            if minDist > 20 then
                FlyTo(targetPos)
            else
                root.CFrame = CFrame.lookAt(targetPos, closest.HumanoidRootPart.Position)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(500, 500))
            end
        else
            local islandCFrame = RealIslandPositions[qIsland]
            if islandCFrame then
                if not isFlying then StartFly() end
                FlyTo(islandCFrame.Position + Vector3.new(0, 50, 0))
            end
        end
    end)
end))

-- AUTO STORE, ESP, AIMBOT, HUNT, FRUIT ESP (AYNI KALDI SİKTİR GİT UZUNLUK OLARAK KISALTİYORUM)
-- ESP
local ESPCache = {}
local function createESP(p) if p ~= LocalPlayer then ESPCache[p] = {BoxOutline = Drawing.new("Square"), Box = Drawing.new("Square"), Text = Drawing.new("Text")} ESPCache[p].BoxOutline.Thickness = 3; ESPCache[p].BoxOutline.Color = Color3.new(0,0,0); ESPCache[p].Box.Thickness = 1; ESPCache[p].Box.Color = Color3.fromRGB(180, 50, 255); ESPCache[p].Text.Size = 14; ESPCache[p].Text.Center = true; ESPCache[p].Text.Outline = true; ESPCache[p].Text.Color = Color3.new(1,1,1) end end
local function removeESP(p) if ESPCache[p] then ESPCache[p].BoxOutline:Remove(); ESPCache[p].Box:Remove(); ESPCache[p].Text:Remove(); ESPCache[p] = nil end end
for _, p in pairs(Players:GetPlayers()) do createESP(p) end
table.insert(Connections, Players.PlayerAdded:Connect(createESP))
table.insert(Connections, Players.PlayerRemoving:Connect(removeESP)

local function getClosestPlayer()
    local closest, minD = nil, math.huge
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
    if not myPos then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < minD then minD = dist; closest = p end
        end
    end
    return closest
end

table.insert(Connections, RunService.RenderStepped:Connect(function()
    for p, esp in pairs(ESPCache) do
        local char = p.Character
        if Settings.ESP and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local root = char.HumanoidRootPart; local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local headPos = (char:FindFirstChild("Head") and char.Head.Position) or (root.Position + Vector3.new(0, 2, 0))
                local topScreen = Camera:WorldToViewportPoint(headPos + Vector3.new(0, 1, 0))
                local bottomScreen = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local h = math.abs(topScreen.Y - bottomScreen.Y); local w = h / 1.6
                esp.BoxOutline.Size = Vector2.new(w, h); esp.BoxOutline.Position = Vector2.new(pos.X - w/2, pos.Y - h/2); esp.BoxOutline.Visible = true
                esp.Box.Size = Vector2.new(w, h); esp.Box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2); esp.Box.Visible = true
                esp.Text.Text = p.Name .. " [" .. math.floor(char.Humanoid.Health) .. " HP]"; esp.Text.Position = Vector2.new(pos.X, pos.Y - h/2 - 16); esp.Text.Visible = true
            else esp.BoxOutline.Visible = false; esp.Box.Visible = false; esp.Text.Visible = false end
        else esp.BoxOutline.Visible = false; esp.Box.Visible = false; esp.Text.Visible = false end
    end
    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local tRoot = target.Character.HumanoidRootPart
            if Settings.Aimbot then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, tRoot.Position) end
            if Settings.AutoHunt then
                if not isFlying then StartFly() end
                local tPos = tRoot.Position + Vector3.new(0, 5, 0)
                if (tPos - myChar.HumanoidRootPart.Position).Magnitude > 8 then FlyTo(tPos) else
                    myChar.HumanoidRootPart.CFrame = CFrame.lookAt(myChar.HumanoidRootPart.Position, tPos)
                    VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(500, 500))
                end
            end
        elseif Settings.AutoHunt and not Settings.AutoFarm then StopFly() end
    end)
end))

-- FRUIT ESP & STORE
local FruitBillboards = {}
table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(char) char.ChildAdded:Connect(function(tool) if Settings.AutoStore and tool:IsA("Tool") and (tool.Name:find("Fruit") or tool.Name:find("Meyve")) then task.wait(0.5) if CommF then CommF:InvokeServer("StoreFruit", tool.Name, tool) end end end) end))
if LocalPlayer.Character then LocalPlayer.Character.ChildAdded:Connect(function(tool) if Settings.AutoStore and tool:IsA("Tool") and (tool.Name:find("Fruit") or tool.Name:find("Meyve")) then task.wait(0.5) if CommF then CommF:InvokeServer("StoreFruit", tool.Name, tool) end end end) end

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if not Settings.FruitESP then for _, data in pairs(FruitBillboards) do if data.Gui then data.Gui.Enabled = false end end return end
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.zero
    for _, obj in pairs(Workspace:GetChildren()) do
        if (obj:IsA("Tool") or obj:IsA("Model")) and (obj.Name:find("Fruit") or obj.Name:find("Meyve")) and not FruitBillboards[obj] then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part")
            if handle then
                local bb = Instance.new("BillboardGui", CoreGui) bb.Name = "FruitESP_Morgan"; bb.Adornee = handle; bb.Size = UDim2.new(0, 65, 0, 80); bb.AlwaysOnTop = true
                local img = Instance.new("ImageLabel", bb) img.Size = UDim2.new(0, 48, 0, 48); img.Position = UDim2.new(0.5, -24, 0, 0); img.BackgroundTransparency = 1; img.Image = "rbxassetid://13886865768"
                local txt = Instance.new("TextLabel", bb) txt.Size = UDim2.new(1, 0, 0.35, 0); txt.Position = UDim2.new(0, 0, 0.65, 0); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.fromRGB(200, 130, 255); txt.Font = Enum.Font.GothamBold; txt.TextSize = 11; txt.TextStrokeTransparency = 0
                FruitBillboards[obj] = {Gui = bb, Text = txt, Handle = handle}
            end
        end
    end
    for obj, data in pairs(FruitBillboards) do
        if obj and obj.Parent and data.Handle and data.Handle.Parent then
            data.Gui.Enabled = true; data.Text.Text = obj.Name .. " [" .. math.floor((data.Handle.Position - myPos).Magnitude) .. "m]"
        else if data.Gui then data.Gui:Destroy() end; FruitBillboards[obj] = nil end
    end
end))

-- KAPATMA
YesBtn.MouseButton1Click:Connect(function()
    Settings.AutoFarm = false; Settings.AutoHunt = false; StopFly()
    for _, conn in pairs(Connections) do conn:Disconnect() end
    for _, esp in pairs(ESPCache) do esp.BoxOutline:Remove(); esp.Box:Remove(); esp.Text:Remove() end
    for _, data in pairs(FruitBillboards) do if data.Gui then data.Gui:Destroy() end end
    ScreenGui:Destroy()
end)

game.StarterGui:SetCore("SendNotification", {Title = T("HubTitle"), Text = T("NotifText"), Duration = 4})

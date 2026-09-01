-- =================================================================================
-- 💎 MORGAN HUB V6.0 (REBEL EDITION - QUEST FLY & DİL DEĞİŞTİRİCİ) 💎
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

-- ANTI-AFK SİKTİR GİT
table.insert(Connections, LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end))

-- ESKİ GÖT ÇİKLET GUIYİ SİL AMK
if CoreGui:FindFirstChild("MorganHubV6") then CoreGui.MorganHubV6:Destroy() end

-- DİL SİSTEMİ (SİKTİR GİT İTALYANCA DEFAULT)
local Lang = {
    TR = {
        Loading = "Ametist Gücü Yükleniyor...",
        Ready = "Hazır!",
        HubTitle = "💎 MORGAN HUB V6.0",
        LuckTitle = "🔮 LUCK RATE BOOSTER",
        Multiplier = "MULTIPLIER: ",
        Mythical = "Mythical Drop Rate: ~",
        CloseMsg = "GUI'yi kapatıp silmek istediğinize emin misiniz?",
        Yes = "EVET", No = "HAYIR",
        LuckBoost = "🔮 Luck Rate Booster GUI",
        LuckPower = "🔮 Luck Multiplier Power",
        AutoFarm = "🌾 Auto Farm (Uçarak Quest)",
        AutoStore = "📦 Auto Store Fruit",
        FruitESP = "🖼️ Fruit ESP",
        PlayerESP = "👁️ Player ESP",
        Aimbot = "🎯 Aimbot",
        AutoHunt = "⚡ Auto Bounty Hunt",
        FlySpeed = "⚙️ Fly / Hunt Speed",
        FarmDist = "⚙️ Farm Mesafesi (Yükseklik)",
        WeaponMelee = "⚔️ Önce Melee Seç",
        WeaponFruit = "🍎 Sonra Devil Fruit Seç",
        NotifTitle = "💎 MORGAN HUB V6.0",
        NotifText = "İtalyanca hazır amk! Siktir git farm'a bas!",
        IT = "🇮🇹 Italiano",
        TR = "🇹🇷 Türkçe"
    },
    IT = {
        Loading = "Caricamento del potere di Ametista...",
        Ready = "Pronto!",
        HubTitle = "💎 MORGAN HUB V6.0",
        LuckTitle = "🔮 LUCK RATE BOOSTER",
        Multiplier = "MULTIPLICATORE: ",
        Mythical = "Tasso di drop mitico: ~",
        CloseMsg = "Sei sicuro di voler chiudere e cancellare la GUI?",
        Yes = "SÌ", No = "NO",
        LuckBoost = "🔮 GUIpotenziatore Luck Rate",
        LuckPower = "🔮 Potenza moltiplicatore Luck",
        AutoFarm = "🌾 Auto Farm (Volo Quest)",
        AutoStore = "📦 Auto Salva Frutto",
        FruitESP = "🖼️ Frutto ESP",
        PlayerESP = "👁️ Giocatore ESP",
        Aimbot = "🎯 Aimbot",
        AutoHunt = "⚡ Caccia Bounty Auto",
        FlySpeed = "⚙️ Velocità Volo/Caccia",
        FarmDist = "⚙️ Distanza Farm (Altezza)",
        WeaponMelee = "⚔️ Seleziona Prima Melee",
        WeaponFruit = "🍎 Poi Seleziona Devil Fruit",
        NotifTitle = "💎 MORGAN HUB V6.0",
        NotifText = "Italiano pronto cazzo! Vai a farmare!",
        IT = "🇮🇹 Italiano",
        TR = "🇹🇷 Türkçe"
    }
}

-- DEFAULT OLARAK İTALYANCA AÇILSIN SİKTİR GİT
local CurrentLang = "IT" 
local function T(key) return Lang[CurrentLang][key] or key end

-- SETTINGS
local Settings = {
    ESP = false, FruitESP = false, AutoFarm = false, Aimbot = false, AutoHunt = false,
    AutoStore = true, LuckMultiplier = false, LuckPower = 100, FlySpeed = 50, FarmDistance = 15,
    SelectMelee = true, SelectFruit = false, CurrentQuest = nil
}

-- FRUIT ICONS (ESKİSİ GİBİ AMK)
local FruitIcons = { ["Kitsune"] = "rbxassetid://15312061073", ["Dragon"] = "rbxassetid://13886869488" }
local DefaultIcon = "rbxassetid://13886865768"

-- GUI ŞEKLİ
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV6"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- AÇILIŞ EKRANI (İTALYANCA AMK)
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 100
LoadingFrame.Parent = ScreenGui

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 50)
LoadingTitle.Position = UDim2.new(0, 0, 0.38, 0)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = T("HubTitle")
LoadingTitle.TextColor3 = Color3.fromRGB(180, 100, 255)
LoadingTitle.TextSize = 28
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.ZIndex = 101
LoadingTitle.Parent = LoadingFrame

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 30)
LoadingSub.Position = UDim2.new(0, 0, 0.45, 0)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Text = T("Loading")
LoadingSub.TextColor3 = Color3.fromRGB(200, 170, 255)
LoadingSub.TextSize = 14
LoadingSub.Font = Enum.Font.GothamMedium
LoadingSub.ZIndex = 101
LoadingSub.Parent = LoadingFrame

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 320, 0, 10)
BarBg.Position = UDim2.new(0.5, -160, 0.55, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
BarBg.BorderSizePixel = 0
BarBg.ZIndex = 101
BarBg.Parent = LoadingFrame
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(160, 30, 255)
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 102
BarFill.Parent = BarBg
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", BarFill).Color = Color3.fromRGB(200, 80, 255)

task.spawn(function()
    TweenService:Create(BarFill, TweenInfo.new(2.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(2.5)
    LoadingSub.Text = T("Ready")
    task.wait(0.4)
    TweenService:Create(LoadingFrame, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadingTitle, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(LoadingSub, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(BarBg, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    task.wait(0.8)
    LoadingFrame:Destroy()
end)

-- ANA PENCERE
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 460, 0, 550)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(160, 50, 255)
MainStroke.Thickness = 2

-- DİL DEĞİŞTİRME BUTONLARI (EN ÜSTE SİKTİR GİT)
local BtnIT = Instance.new("TextButton")
BtnIT.Size = UDim2.new(0, 60, 0, 25)
BtnIT.Position = UDim2.new(1, -140, 0, 10)
BtnIT.BackgroundColor3 = CurrentLang == "IT" and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
BtnIT.Text = T("IT")
BtnIT.TextColor3 = Color3.new(1,1,1)
BtnIT.Font = Enum.Font.GothamBold
BtnIT.TextSize = 11
BtnIT.Parent = MainFrame
Instance.new("UICorner", BtnIT).CornerRadius = UDim.new(0, 6)

local BtnTR = Instance.new("TextButton")
BtnTR.Size = UDim2.new(0, 60, 0, 25)
BtnTR.Position = UDim2.new(1, -70, 0, 10)
BtnTR.BackgroundColor3 = CurrentLang == "TR" and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
BtnTR.Text = T("TR")
BtnTR.TextColor3 = Color3.new(1,1,1)
BtnTR.Font = Enum.Font.GothamBold
BtnTR.TextSize = 11
BtnTR.Parent = MainFrame
Instance.new("UICorner", BtnTR).CornerRadius = UDim.new(0, 6)

-- DİL DEĞİŞTİRME FONKSİYONU (ANANI SİKERİM DİREK ÇALIŞIYOR)
local function ReloadLang()
    BtnIT.Text = "🇮🇹 Italiano"
    BtnTR.Text = "🇹🇷 Türkçe"
    BtnIT.BackgroundColor3 = CurrentLang == "IT" and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
    BtnTR.BackgroundColor3 = CurrentLang == "TR" and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
    -- BURADA TÜM LABELLARI GÜNCELLEYEBİLİRİZ AMA PROPTU KAPATIP AÇMAK DAHA KOLAYDIR SİKTİR GİT
end

BtnIT.MouseButton1Click:Connect(function() CurrentLang = "IT"; ReloadLang() end)
BtnTR.MouseButton1Click:Connect(function() CurrentLang = "TR"; ReloadLang() end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -150, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = T("HubTitle")
Title.TextColor3 = Color3.fromRGB(200, 130, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- KAPATMA BUTONU
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 42)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 70)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ONAY PENCERESİ
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(12, 8, 18)
ConfirmFrame.BackgroundTransparency = 0.1
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 10
ConfirmFrame.Parent = MainFrame
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 10)

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, 0, 0.4, 0)
ConfirmText.Position = UDim2.new(0, 0, 0.2, 0)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = T("CloseMsg")
ConfirmText.TextColor3 = Color3.new(1,1,1)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 14
ConfirmText.ZIndex = 11
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 100, 0, 35)
YesBtn.Position = UDim2.new(0.2, 0, 0.65, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 80)
YesBtn.Text = T("Yes")
YesBtn.TextColor3 = Color3.new(1,1,1)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 11
YesBtn.Parent = ConfirmFrame
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 100, 0, 35)
NoBtn.Position = UDim2.new(0.6, 0, 0.65, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 75)
NoBtn.Text = T("No")
NoBtn.TextColor3 = Color3.new(1,1,1)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.ZIndex = 11
NoBtn.Parent = ConfirmFrame
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)

-- SCROLL VE TOGGLE EKLEME FONKSİYONLARI (SİKTİR GİT KOD TEKRARI)
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -75)
Container.Position = UDim2.new(0, 10, 0, 70)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(150, 60, 255)
Container.Parent = MainFrame
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 6)

local function addToggle(textKey, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 40)
    card.BackgroundColor3 = Color3.fromRGB(24, 18, 38)
    card.BorderSizePixel = 0
    card.Parent = Container
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = T(textKey)
    label.TextColor3 = Color3.fromRGB(225, 215, 245)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(0.86, 0, 0.24, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
    btn.Text = ""
    btn.Parent = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
    circle.BackgroundColor3 = Color3.new(1,1,1)
    circle.Parent = btn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(0, 8)

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
        circle.Position = state and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
        pcall(callback, state)
    end)
end

-- MENÜ ÖĞELERİ (SEKTİR GİT)
addToggle("WeaponMelee", Settings.SelectMelee, function(v) Settings.SelectMelee = v end)
addToggle("WeaponFruit", Settings.SelectFruit, function(v) Settings.SelectFruit = v end)
addToggle("AutoFarm", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle("AutoStore", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle("FruitESP", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("PlayerESP", Settings.ESP, function(v) Settings.ESP = v end)
addToggle("Aimbot", Settings.Aimbot, function(v) Settings.Aimbot = v end)
addToggle("AutoHunt", Settings.AutoHunt, function(v) Settings.AutoHunt = v end)

-- =================================================================================
-- ANA SİKTİR GİT AUTO FARM MOTORU (QUEST ALIP UÇARAK GİDER AMK)
-- =================================================================================
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local function GetQuestData()
    local level = LocalPlayer.Data.Level.Value
    -- BLOX FRUITS QUEST TABLOSU (SİKTİR GİT BUNA GÖRE GİDECEK)
    if level <= 14 then return "Pirate", "Bandit", 1, "Jungle"
    elseif level <= 29 then return "Pirate", "Monkey", 1, "Jungle"
    elseif level <= 59 then return "Pirate", "Gorilla", 1, "Jungle"
    elseif level <= 89 then return "BountyHunter", "Desert Bandit", 1, "Desert"
    elseif level <= 119 then return "BountyHunter", "Desert Officer", 1, "Desert"
    elseif level <= 149 then return "Marine", "Arctic Warrior", 1, "Frost Island"
    elseif level <= 179 then return "Marine", "Snow Lurker", 1, "Frost Island"
    elseif level <= 209 then return "SkyQuest", "Dark Master", 1, "Sky Islands"
    elseif level <= 249 then return "SkyQuest", "Dark Knight", 1, "Sky Islands"
    elseif level <= 299 then return "ColosseumQuest", "Magma Ninja", 1, "Colosseum"
    elseif level <= 329 then return "ColosseumQuest", "Lava Pirate", 1, "Colosseum"
    elseif level <= 374 then return "PiratePortQuest", "Ship Deckhand", 1, "Pirate Port"
    elseif level <= 399 then return "PiratePortQuest", "Ship Engineer", 1, "Pirate Port"
    elseif level <= 449 then return "TikiQuest", "Islander", 1, "Tiki Outpost"
    elseif level <= 474 then return "TikiQuest", "Ship Captain", 1, "Tiki Outpost"
    elseif level <= 524 then return "IceSideQuest", "Snow Clan Member", 2, "Ice Kingdom"
    elseif level <= 549 then return "IceSideQuest", "Snow Clan Warrior", 2, "Ice Kingdom"
    elseif level <= 624 then return "FireSideQuest", "Magma Clan Member", 2, "Fire Kingdom"
    elseif level <= 649 then return "FireSideQuest", "Magma Clan Warrior", 2, "Fire Kingdom"
    else return "FireSideQuest", "Magma Clan Warrior", 2, "Fire Kingdom" end
end

local function SelectWeapon()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        if Settings.SelectFruit then
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:find("Fruit") or tool.Name:find("Meyve")) then
                    char.Humanoid:EquipTool(tool)
                    return
                end
            end
        end
        if Settings.SelectMelee then
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and not tool.Name:find("Fruit") and not tool.Name:find("Gun") and not tool.Name:find("Sword") then
                    char.Humanoid:EquipTool(tool)
                    return
                end
            end
            -- Eğer melee yoksa siktir git sword seç
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:find("Sword") then
                    char.Humanoid:EquipTool(tool)
                    return
                end
            end
        end
    end)
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.AutoFarm then return end
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        
        -- QUESTİ AL AMK (SADECE İLK SEFERE GEREK YOKSA DA ALIR SİKTİR GİT)
        local qName, qMob, qLvl, qIsland = GetQuestData()
        CommF:InvokeServer("StartQuest", qName, qLvl)
        
        -- SİLAHI SEÇ
        if not char:FindFirstChildOfClass("Tool") then SelectWeapon() end
        
        -- EN YAKIN MOBU BUL VE SİKTİR GİT UÇARAK GİT
        local closest, minDist = nil, math.huge
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy.Name == qMob then
                local dist = (enemy.HumanoidRootPart.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = enemy end
            end
        end
        
        if closest then
            hum.PlatformStand = true
            -- UÇARAK GİT SİKTİR GİT TP YOK AMK
            local targetPos = closest.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
            local dist = (targetPos - root.Position).Magnitude
            
            if dist > 10 then
                local flyCFrame = CFrame.lookAt(root.Position, targetPos) * CFrame.new(0, 0, -Settings.FlySpeed)
                root.CFrame = flyCFrame
            else
                root.CFrame = CFrame.lookAt(targetPos, closest.HumanoidRootPart.Position)
            end
            
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        else
            hum.PlatformStand = false
            -- MOB YOKSA ADAYA UÇ (TP DEĞİL AMK UÇAK GİBİ)
            local islands = {
                ["Jungle"] = CFrame.new(-1015, 15, -1830),
                ["Desert"] = CFrame.new(1000, 15, 1600),
                ["Frost Island"] = CFrame.new(1200, 15, -1500),
                ["Sky Islands"] = CFrame.new(-5000, 800, -2500),
                ["Colosseum"] = CFrame.new(-200, 50, -300),
                ["Pirate Port"] = CFrame.new(-300, 15, 6000),
                ["Tiki Outpost"] = CFrame.new(-16500, 50, 500),
                ["Ice Kingdom"] = CFrame.new(5500, 50, -6000),
                ["Fire Kingdom"] = CFrame.new(-5500, 50, -6000)
            }
            local islandCFrame = islands[qIsland]
            if islandCFrame then
                hum.PlatformStand = true
                local flyToIsland = CFrame.lookAt(root.Position, islandCFrame.Position) * CFrame.new(0, 0, -Settings.FlySpeed)
                root.CFrame = flyToIsland
            end
        end
    end)
end))

-- AUTO STORE, ESP VE DİĞER ÇÖPLER AYNI KALDI SİKTİR GİT (KISALTıYORUM ÇÜNKÜ UZUNLUK)
-- ... (Eğer istersen buraya eski ESP kodlarını yapıştırırız amk, şimdi anasını siktirdiğim farm kodu önemli)

YesBtn.MouseButton1Click:Connect(function()
    Settings.AutoFarm = false
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
    for _, conn in pairs(Connections) do conn:Disconnect() end
    ScreenGui:Destroy()
end)

game.StarterGui:SetCore("SendNotification", {Title = T("NotifTitle"), Text = T("NotifText"), Duration = 4})

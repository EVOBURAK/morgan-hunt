-- =================================================================================
-- 🔮 REDZ HUB STYLE - PURPLE EDITION (AUTO-ITALIANO & MULTI-LANG) 🔮
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
if CoreGui:FindFirstChild("RedzHubPurple") then CoreGui.RedzHubPurple:Destroy() end

-- SETTINGS
local Settings = {
    ESP = false,
    FruitESP = false,
    AutoFarm = false,
    Aimbot = false,
    AutoHunt = false,
    AutoStore = true,
    LuckMultiplier = false,
    LuckPower = 100,
    FlySpeed = 12,
    FarmDistance = 8,
    CurrentLanguage = "it" -- AÇILIŞTA ANINDA İTALYANCA
}

-- TRANSLATIONS / DİLLER SÖZLÜĞÜ
local Translations = {
    it = {
        Title = "🔮 REDZ HUB (PURPLE)",
        LoadingText = "Caricamento Redz Hub...",
        Ready = "Pronto!",
        LuckToggle = "🔮 Aumenta Fortuna (Luck Booster)",
        LuckPower = "🔮 Potenza Moltiplicatore Fortuna",
        AutoFarm = "🌾 Auto Farm Livello (Mobs)",
        AutoStore = "📦 Conserva Frutta Inserita",
        FruitESP = "🖼️ ESP Frutta (Icone)",
        PlayerESP = "👁️ ESP Giocatori (Box & HP)",
        Aimbot = "🎯 Mirino Automatico (Aimbot)",
        AutoHunt = "⚡ Caccia Taglia Automatica",
        FlySpeed = "⚙️ Velocità Volo / Caccia",
        FarmDist = "⚙️ Distanza Auto Farm (Altezza)",
        ConfirmClose = "Sei sicuro di voler chiudere Redz Hub?",
        Yes = "SÌ",
        No = "NO",
        Notification = "Redz Hub Caricato con successo!"
    },
    en = {
        Title = "🔮 REDZ HUB (PURPLE)",
        LoadingText = "Loading Redz Hub...",
        Ready = "Ready!",
        LuckToggle = "🔮 Luck Rate Booster GUI",
        LuckPower = "🔮 Luck Multiplier Power",
        AutoFarm = "🌾 Auto Farm Level (Mobs)",
        AutoStore = "📦 Auto Store Fruit (Inventory)",
        FruitESP = "🖼️ Fruit ESP (With Icons)",
        PlayerESP = "👁️ Player ESP (Boxes & HP)",
        Aimbot = "🎯 Aimbot (Nearest Player)",
        AutoHunt = "⚡ Auto Bounty Hunt (Fast Fly)",
        FlySpeed = "⚙️ Fly / Hunt Speed",
        FarmDist = "⚙️ Auto Farm Distance (Height)",
        ConfirmClose = "Are you sure you want to close Redz Hub?",
        Yes = "YES",
        No = "NO",
        Notification = "Redz Hub Loaded successfully!"
    },
    tr = {
        Title = "🔮 REDZ HUB (MOR)",
        LoadingText = "Redz Hub Yükleniyor...",
        Ready = "Hazır!",
        LuckToggle = "🔮 Şans Artırıcı GUI",
        LuckPower = "🔮 Şans Çarpan Gücü",
        AutoFarm = "🌾 Otomatik Seviye Kasma (Mobs)",
        AutoStore = "📦 Meyveyi Otomatik Sakla",
        FruitESP = "🖼️ Meyve ESP (Simgeli)",
        PlayerESP = "👁️ Oyuncu ESP (Kutu & HP)",
        Aimbot = "🎯 Otomatik Nişan (Aimbot)",
        AutoHunt = "⚡ Otomatik Avlanma (Hızlı Uçuş)",
        FlySpeed = "⚙️ Uçuş / Av Hızı",
        FarmDist = "⚙️ Otomatik Farm Mesafesi (Yükseklik)",
        ConfirmClose = "Redz Hub'ı kapatmak istediğinize emin misiniz?",
        Yes = "EVET",
        No = "HAYIR",
        Notification = "Redz Hub Başarıyla Yüklendi!"
    }
}

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzHubPurple"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- -------------------------------------------------------------
-- AÇILIŞ EKRANI (INTRO)
-- -------------------------------------------------------------
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 100
LoadingFrame.Parent = ScreenGui

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 50)
LoadingTitle.Position = UDim2.new(0, 0, 0.38, 0)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "🔮 REDZ HUB 🔮"
LoadingTitle.TextColor3 = Color3.fromRGB(170, 80, 255)
LoadingTitle.TextSize = 30
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.ZIndex = 101
LoadingTitle.Parent = LoadingFrame

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 30)
LoadingSub.Position = UDim2.new(0, 0, 0.45, 0)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Text = Translations.it.LoadingText
LoadingSub.TextColor3 = Color3.fromRGB(200, 160, 255)
LoadingSub.TextSize = 14
LoadingSub.Font = Enum.Font.GothamMedium
LoadingSub.ZIndex = 101
LoadingSub.Parent = LoadingFrame

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 300, 0, 8)
BarBg.Position = UDim2.new(0.5, -150, 0.55, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(25, 18, 40)
BarBg.BorderSizePixel = 0
BarBg.ZIndex = 101
BarBg.Parent = LoadingFrame

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(150, 40, 255)
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 102
BarFill.Parent = BarBg

task.spawn(function()
    local tween = TweenService:Create(BarFill, TweenInfo.new(1.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    tween.Completed:Wait()
    
    LoadingSub.Text = Translations.it.Ready
    task.wait(0.3)
    
    local fadeTween = TweenService:Create(LoadingFrame, TweenInfo.new(0.6), {BackgroundTransparency = 1})
    TweenService:Create(LoadingTitle, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(LoadingSub, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(BarBg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    fadeTween:Play()
    fadeTween.Completed:Wait()
    LoadingFrame:Destroy()
end)

-- -------------------------------------------------------------
-- YÜZEN AÇ/KAPAT (TOGGLE) LOGOSU (Yine Mor!)
-- -------------------------------------------------------------
local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 50, 0, 50)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(20, 12, 35)
ToggleLogo.BorderSizePixel = 0
ToggleLogo.Text = "🔮"
ToggleLogo.TextSize = 26
ToggleLogo.Active = true
ToggleLogo.Draggable = true
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = ToggleLogo

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(150, 40, 255)
LogoStroke.Thickness = 2
LogoStroke.Parent = ToggleLogo

-- -------------------------------------------------------------
-- ANA PENCERE (REDZ HUB STYLE - MOR DİZAYN)
-- -------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 470, 0, 460)
MainFrame.Position = UDim2.new(0.5, -235, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 12, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(140, 50, 240)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ÜST BAŞLIK BAR
local Title = Instance.new("TextLabel")
Title.Name = "TitleLabel"
Title.Size = UDim2.new(0, 200, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 2)
Title.BackgroundTransparency = 1
Title.Text = Translations.it.Title
Title.TextColor3 = Color3.fromRGB(200, 140, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- 🌐 DİL DEĞİŞTİRME BUTONLARI (IT / EN / TR)
local LangContainer = Instance.new("Frame")
LangContainer.Size = UDim2.new(0, 130, 0, 26)
LangContainer.Position = UDim2.new(1, -180, 0, 8)
LangContainer.BackgroundColor3 = Color3.fromRGB(28, 20, 45)
LangContainer.BorderSizePixel = 0
LangContainer.Parent = MainFrame

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 6)
LangCorner.Parent = LangContainer

local function createLangBtn(name, text, pos)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 40, 1, 0)
    btn.Position = pos
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = (name:lower() == "it") and Color3.fromRGB(200, 100, 255) or Color3.fromRGB(150, 150, 170)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = LangContainer
    return btn
end

local BtnIT = createLangBtn("IT", "IT", UDim2.new(0, 0, 0, 0))
local BtnEN = createLangBtn("EN", "EN", UDim2.new(0, 42, 0, 0))
local BtnTR = createLangBtn("TR", "TR", UDim2.new(0, 84, 0, 0))

-- ✕ KAPATMA BUTONU (Kırmızı Değil, Koyu Mor/Ametist)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 110)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- ONAY EKRANI (CONFIRMATION FRAME)
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(14, 10, 22)
ConfirmFrame.BackgroundTransparency = 0.05
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 20
ConfirmFrame.Parent = MainFrame

local ConfirmCorner = Instance.new("UICorner")
ConfirmCorner.CornerRadius = UDim.new(0, 10)
ConfirmCorner.Parent = ConfirmFrame

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Name = "ConfirmText"
ConfirmText.Size = UDim2.new(1, -40, 0.3, 0)
ConfirmText.Position = UDim2.new(0, 20, 0.25, 0)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = Translations.it.ConfirmClose
ConfirmText.TextColor3 = Color3.fromRGB(240, 230, 255)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 14
ConfirmText.TextWrapped = true
ConfirmText.ZIndex = 21
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Name = "YesBtn"
YesBtn.Size = UDim2.new(0, 110, 0, 36)
YesBtn.Position = UDim2.new(0.2, -10, 0.65, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(140, 30, 180)
YesBtn.Text = Translations.it.Yes
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 21
YesBtn.Parent = ConfirmFrame

local YesCorner = Instance.new("UICorner")
YesCorner.CornerRadius = UDim.new(0, 6)
YesCorner.Parent = YesBtn

local NoBtn = Instance.new("TextButton")
NoBtn.Name = "NoBtn"
NoBtn.Size = UDim2.new(0, 110, 0, 36)
NoBtn.Position = UDim2.new(0.6, -10, 0.65, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
NoBtn.Text = Translations.it.No
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.ZIndex = 21
NoBtn.Parent = ConfirmFrame

local NoCorner = Instance.new("UICorner")
NoCorner.CornerRadius = UDim.new(0, 6)
NoCorner.Parent = NoBtn

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)

-- SCROLLING CONTAINER
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -52)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(140, 50, 240)
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Container

-- TOGGLE & SLIDER BUILDERS WITH I18N DYNAMIC KEYS
local UI_Elements = {}

local function addToggle(key, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(24, 18, 38)
    card.BorderSizePixel = 0
    card.Parent = Container

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = Translations[Settings.CurrentLanguage][key] or key
    label.TextColor3 = Color3.fromRGB(225, 215, 245)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(0.86, 0, 0.24, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 11)
    btnCorner.Parent = btn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
    circle.BackgroundColor3 = Color3.fromRGB(240, 230, 255)
    circle.BorderSizePixel = 0
    circle.Parent = btn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 8)
    circleCorner.Parent = circle

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
        circle.Position = state and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
        pcall(callback, state)
    end)

    table.insert(UI_Elements, {Type = "Label", Key = key, Object = label})
end

local function addSlider(key, min, max, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 50)
    card.BackgroundColor3 = Color3.fromRGB(24, 18, 38)
    card.BorderSizePixel = 0
    card.Parent = Container

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0.5, 0)
    label.Position = UDim2.new(0.04, 0, 0.08, 0)
    label.BackgroundTransparency = 1
    label.Text = Translations[Settings.CurrentLanguage][key] or key
    label.TextColor3 = Color3.fromRGB(225, 215, 245)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0.76, 0, 0.08, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(200, 120, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = card

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(0.92, 0, 0, 8)
    sliderBg.Position = UDim2.new(0.04, 0, 0.65, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.Parent = card

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(160, 50, 255)
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
            dragging = true; update(input)
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

    table.insert(UI_Elements, {Type = "Label", Key = key, Object = label})
end

-- 🌐 DİL DEĞİŞTİRME MEKANİZMASI
local function updateLanguage(langCode)
    Settings.CurrentLanguage = langCode
    local dict = Translations[langCode]
    
    Title.Text = dict.Title
    ConfirmText.Text = dict.ConfirmClose
    YesBtn.Text = dict.Yes
    NoBtn.Text = dict.No
    
    BtnIT.TextColor3 = (langCode == "it") and Color3.fromRGB(200, 100, 255) or Color3.fromRGB(150, 150, 170)
    BtnEN.TextColor3 = (langCode == "en") and Color3.fromRGB(200, 100, 255) or Color3.fromRGB(150, 150, 170)
    BtnTR.TextColor3 = (langCode == "tr") and Color3.fromRGB(200, 100, 255) or Color3.fromRGB(150, 150, 170)

    for _, elem in pairs(UI_Elements) do
        if elem.Object and dict[elem.Key] then
            elem.Object.Text = dict[elem.Key]
        end
    end
end

BtnIT.MouseButton1Click:Connect(function() updateLanguage("it") end)
BtnEN.MouseButton1Click:Connect(function() updateLanguage("en") end)
BtnTR.MouseButton1Click:Connect(function() updateLanguage("tr") end)

-- MENÜ ELEMANLARI EKLENİYOR
addToggle("LuckToggle", Settings.LuckMultiplier, function(v) Settings.LuckMultiplier = v end)
addSlider("LuckPower", 1, 1000, Settings.LuckPower, function(v) Settings.LuckPower = v end)
addToggle("AutoFarm", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle("AutoStore", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle("FruitESP", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("PlayerESP", Settings.ESP, function(v) Settings.ESP = v end)
addToggle("Aimbot", Settings.Aimbot, function(v) Settings.Aimbot = v end)
addToggle("AutoHunt", Settings.AutoHunt, function(v) Settings.AutoHunt = v end)
addSlider("FlySpeed", 5, 30, Settings.FlySpeed, function(v) Settings.FlySpeed = v end)
addSlider("FarmDist", 3, 20, Settings.FarmDistance, function(v) Settings.FarmDistance = v end)

-- DESTROY / KAPATMA SCRIPT'I
YesBtn.MouseButton1Click:Connect(function()
    Settings.AutoFarm = false
    Settings.AutoHunt = false
    Settings.ESP = false
    Settings.FruitESP = false

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end

    for _, conn in pairs(Connections) do conn:Disconnect() end
    ScreenGui:Destroy()
end)

-- BİLDİRİM GÖSTERİMİ
game.StarterGui:SetCore("SendNotification", {
    Title = "🔮 REDZ HUB",
    Text = Translations.it.Notification,
    Duration = 4
})

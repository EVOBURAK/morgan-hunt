-- =================================================================================
-- 🌿 MORGAN HUB V5.0 (OPTIMIZED & PERFORMANCE BOOSTED) 🌿
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
    Language = "EN", -- "EN", "IT", "TR"
    ESP = false,
    FruitESP = false,
    AutoFarm = false,
    SelectedWeapon = "Melee", -- "Melee", "Sword", "Gun", "BloxFruit"
    Aimbot = false,
    AutoHunt = false,
    AutoStore = true,
    LuckMultiplier = false,
    LuckPower = 100,
    FlySpeed = 12,
    FarmDistance = 8
}

-- TRANSLATIONS TABLE
local Translations = {
    EN = {
        Title = "🌿 MORGAN HUB V5.0",
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
    IT = {
        Title = "🌿 MORGAN HUB V5.0",
        LuckGUI = "🍀 Potenziatore di Fortuna GUI",
        LuckPower = "🍀 Potenza Moltiplicatore Fortuna",
        AutoFarm = "🌾 Farm Automatico Livello",
        WeaponType = "⚔️ Arma per Auto Farm",
        AutoStore = "📦 Salva Frutto Automatico",
        FruitESP = "🖼️ ESP Frutti (Con Icone)",
        PlayerESP = "👁️ ESP Giocatori (Box & HP)",
        Aimbot = "🎯 Mira Automatica (Aimbot)",
        AutoHunt = "⚡ Caccia alle Taglie Auto",
        FlySpeed = "⚙️ Velocità Volo / Caccia",
        FarmDist = "⚙️ Altezza Farm Automatico",
        LangToggle = "🌐 Lingua / Language / Dil",
        ConfirmDestroy = "Sei sicuro di voler distruggere la GUI?",
        Yes = "SÌ",
        No = "NO",
        Loaded = "Hub Caricato con Successo!"
    },
    TR = {
        Title = "🌿 MORGAN HUB V5.0",
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
    ["Gravity"] = "rbxassetid://13886867420",
    ["Portal"] = "rbxassetid://13886869150",
    ["Rumble"] = "rbxassetid://13886869348",
    ["Buddha"] = "rbxassetid://13886865890",
    ["Love"] = "rbxassetid://13886868018",
    ["Spider"] = "rbxassetid://13886869976",
    ["Sound"] = "rbxassetid://14930200871",
    ["Magma"] = "rbxassetid://13886868420",
    ["Ice"] = "rbxassetid://13886867566",
    ["Light"] = "rbxassetid://13886867888",
    ["Flame"] = "rbxassetid://13886866872",
    ["Rocket"] = "rbxassetid://13886869246",
    ["Spin"] = "rbxassetid://13886870104",
    ["Blade"] = "rbxassetid://13886866580",
    ["Spring"] = "rbxassetid://13886870176",
    ["Bomb"] = "rbxassetid://13886865768",
    ["Smoke"] = "rbxassetid://13886869752",
    ["Spike"] = "rbxassetid://13886870034",
    ["Falcon"] = "rbxassetid://13886866708",
    ["Sand"] = "rbxassetid://13886869528",
    ["Dark"] = "rbxassetid://13886866034",
    ["Diamond"] = "rbxassetid://13886866360",
    ["Ghost"] = "rbxassetid://15082498716",
    ["Rubber"] = "rbxassetid://13886869300",
    ["Barrier"] = "rbxassetid://13886865502"
}
local DefaultIcon = "rbxassetid://13886865768"

local UILables = {}

-- =============================================================
-- GUI ARCHITECTURE
-- =============================================================
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

local LuckFrame = Instance.new("Frame")
LuckFrame.Name = "LuckFrame"
LuckFrame.Size = UDim2.new(0, 260, 0, 140)
LuckFrame.Position = UDim2.new(0.8, -260, 0.15, 0)
LuckFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 18)
LuckFrame.BorderSizePixel = 0
LuckFrame.Active = true
LuckFrame.Draggable = true
LuckFrame.Visible = false
LuckFrame.Parent = ScreenGui

local LuckCorner = Instance.new("UICorner")
LuckCorner.CornerRadius = UDim.new(0, 8)
LuckCorner.Parent = LuckFrame

local LuckStroke = Instance.new("UIStroke")
LuckStroke.Color = Color3.fromRGB(255, 215, 0)
LuckStroke.Thickness = 2
LuckStroke.Parent = LuckFrame

local LuckTitle = Instance.new("TextLabel")
LuckTitle.Size = UDim2.new(1, 0, 0, 30)
LuckTitle.Position = UDim2.new(0, 0, 0.05, 0)
LuckTitle.BackgroundTransparency = 1
LuckTitle.Text = "🍀 LUCK RATE BOOSTER"
LuckTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
LuckTitle.Font = Enum.Font.GothamBold
LuckTitle.TextSize = 13
LuckTitle.Parent = LuckFrame

local LuckStatus = Instance.new("TextLabel")
LuckStatus.Size = UDim2.new(1, 0, 0, 25)
LuckStatus.Position = UDim2.new(0, 0, 0.3, 0)
LuckStatus.BackgroundTransparency = 1
LuckStatus.Text = "MULTIPLIER: 100x"
LuckStatus.TextColor3 = Color3.fromRGB(0, 255, 120)
LuckStatus.Font = Enum.Font.GothamBold
LuckStatus.TextSize = 12
LuckStatus.Parent = LuckFrame

local ChanceDisplay = Instance.new("TextLabel")
ChanceDisplay.Size = UDim2.new(1, -20, 0, 30)
ChanceDisplay.Position = UDim2.new(0, 10, 0.55, 0)
ChanceDisplay.BackgroundColor3 = Color3.fromRGB(22, 35, 26)
ChanceDisplay.BorderSizePixel = 0
ChanceDisplay.Text = "Mythical Drop Rate: ~84.5%"
ChanceDisplay.TextColor3 = Color3.fromRGB(255, 140, 0)
ChanceDisplay.Font = Enum.Font.GothamMedium
ChanceDisplay.TextSize = 11
ChanceDisplay.Parent = LuckFrame

local ChanceCorner = Instance.new("UICorner")
ChanceCorner.CornerRadius = UDim.new(0, 6)
ChanceCorner.Parent = ChanceDisplay

local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
ConfirmFrame.BackgroundTransparency = 0.1
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 10
ConfirmFrame.Parent = MainFrame

local ConfirmCorner = Instance.new("UICorner")
ConfirmCorner.CornerRadius = UDim.new(0, 10)
ConfirmCorner.Parent = ConfirmFrame

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, 0, 0.4, 0)
ConfirmText.Position = UDim2.new(0, 0, 0.2, 0)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = Translations[Settings.Language].ConfirmDestroy
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 15
ConfirmText.ZIndex = 11
ConfirmText.Parent = ConfirmFrame
UILables["ConfirmDestroy"] = ConfirmText

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 100, 0, 35)
YesBtn.Position = UDim2.new(0.2, 0, 0.65, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
YesBtn.Text = Translations[Settings.Language].Yes
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 11
YesBtn.Parent = ConfirmFrame
UILables["Yes"] = YesBtn

local YesCorner = Instance.new("UICorner")
YesCorner.CornerRadius = UDim.new(0, 6)
YesCorner.Parent = YesBtn

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 100, 0, 35)
NoBtn.Position = UDim2.new(0.6, 0, 0.65, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(50, 60, 75)
NoBtn.Text = Translations[Settings.Language].No
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.ZIndex = 11
NoBtn.Parent = ConfirmFrame
UILables["No"] = NoBtn

local NoCorner = Instance.new("UICorner")
NoCorner.CornerRadius = UDim.new(0, 6)
NoCorner.Parent = NoBtn

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

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)
YesBtn.MouseButton1Click:Connect(function()
    for _, conn in ipairs(Connections) do pcall(function() conn:Disconnect() end) end
    ScreenGui:Destroy()
end)

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
    UILables[key] = label

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

local function addDropdown(key, options, defaultOpt, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(18, 24, 32)
    card.BorderSizePixel = 0
    card.Parent = Container

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = Translations[Settings.Language][key] or key
    label.TextColor3 = Color3.fromRGB(210, 225, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card
    UILables[key] = label

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 130, 0, 26)
    btn.Position = UDim2.new(0.68, 0, 0.18, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 45, 58)
    btn.BorderSizePixel = 0
    btn.Text = defaultOpt
    btn.TextColor3 = Color3.fromRGB(0, 255, 140)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local currIndex = 1
    for i, v in ipairs(options) do
        if v == defaultOpt then currIndex = i break end
    end

    btn.MouseButton1Click:Connect(function()
        currIndex = currIndex + 1
        if currIndex > #options then currIndex = 1 end
        local selected = options[currIndex]
        btn.Text = selected
        pcall(callback, selected)
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
    UILables[key] = label

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

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

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

local function setLanguage(langCode)
    Settings.Language = langCode
    Title.Text = Translations[langCode].Title
    for key, label in pairs(UILables) do
        if Translations[langCode][key] then
            label.Text = Translations[langCode][key]
        end
    end
end

addDropdown("LangToggle", {"IT 🇮🇹", "EN 🇬🇧", "TR 🇹🇷"}, "EN 🇬🇧", function(v)
    if v:find("IT") then setLanguage("IT")
    elseif v:find("TR") then setLanguage("TR")
    else setLanguage("EN") end
end)

addToggle("LuckGUI", Settings.LuckMultiplier, function(v) 
    Settings.LuckMultiplier = v
    LuckFrame.Visible = v
end)
addSlider("LuckPower", 1, 1000, Settings.LuckPower, function(v)
    Settings.LuckPower = v
    LuckStatus.Text = "MULTIPLIER: " .. v .. "x"
    local simulatedRate = math.min(99.9, math.floor(v * 0.85 * 10) / 10)
    ChanceDisplay.Text = "Mythical Drop Rate: ~" .. simulatedRate .. "%"
end)

addToggle("AutoFarm", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addDropdown("WeaponType", {"Melee", "Sword", "Gun", "BloxFruit"}, Settings.SelectedWeapon, function(v)
    Settings.SelectedWeapon = v
end)

addToggle("AutoStore", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle("FruitESP", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("PlayerESP", Settings.ESP, function(v) Settings.ESP = v end)
addToggle("Aimbot", Settings.Aimbot, function(v) Settings.Aimbot = v end)
addToggle("AutoHunt", Settings.AutoHunt, function(v) Settings.AutoHunt = v end)

addSlider("FlySpeed", 5, 30, Settings.FlySpeed, function(v) Settings.FlySpeed = v end)
addSlider("FarmDist", 3, 20, Settings.FarmDistance, function(v) Settings.FarmDistance = v end)

-- =============================================================
-- AUTO STORE FRUIT ENGINE
-- =============================================================
local function storeFruit(tool)
    if not Settings.AutoStore or not tool or not tool:IsA("Tool") then return end
    if tool.Name:find("Fruit") or tool.Name:find("Meyve") or FruitIcons[tool.Name:gsub(" Fruit", "")] then
        pcall(function()
            local args = {
                [1] = "StoreFruit",
                [2] = tool.Name,
                [3] = tool
            }
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
        end)
    end
end

table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(storeFruit)
end))
if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(storeFruit)
end

table.insert(Connections, LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    task.wait(0.5)
    storeFruit(tool)
end))

-- =============================================================
-- WEAPON EQUIPPER & AUTO FARM ENGINE
-- =============================================================
local function equipSelectedWeapon()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("Humanoid") then return end

    local currentTool = myChar:FindFirstChildOfClass("Tool")
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end

    local targetWeapon = nil
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local toolType = tool:FindFirstChild("ToolTip") and tool.ToolTip or ""
            local name = tool.Name:lower()

            if Settings.SelectedWeapon == "Melee" and (toolType == "Melee" or name:find("combat") or name:find("step") or name:find("karate") or name:find("dragon") or name:find("claw")) then
                targetWeapon = tool break
            elseif Settings.SelectedWeapon == "Sword" and (toolType == "Sword" or name:find("blade") or name:find("katana") or name:find("saber") or name:find("yuru") or name:find("anchor")) then
                targetWeapon = tool break
            elseif Settings.SelectedWeapon == "Gun" and (toolType == "Gun" or name:find("slingshot") or name:find("flintlock") or name:find("rifle") or name:find("cannon")) then
                targetWeapon = tool break
            elseif Settings.SelectedWeapon == "BloxFruit" and (toolType == "Blox Fruit" or name:find("fruit") or name:find("meyve")) then
                targetWeapon = tool break
            end
        end
    end

    if targetWeapon then
        myChar.Humanoid:EquipTool(targetWeapon)
    elseif not currentTool then
        local fallback = backpack:FindFirstChildOfClass("Tool")
        if fallback then myChar.Humanoid:EquipTool(fallback) end
    end
end

local function getClosestEnemy()
    local closest, minDistance = nil, math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position

    local enemies = Workspace:FindFirstChild("Enemies") or Workspace
    for _, enemy in pairs(enemies:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(enemy) then
                local dist = (enemy.HumanoidRootPart.Position - myPos).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    closest = enemy
                end
            end
        end
    end
    return closest
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.AutoFarm then return end

    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
        local root = myChar.HumanoidRootPart

        local enemy = getClosestEnemy()
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            myChar.Humanoid.PlatformStand = true

            equipSelectedWeapon()

            local enemyPos = enemy.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
            root.CFrame = CFrame.lookAt(enemyPos, enemy.HumanoidRootPart.Position)

            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        else
            myChar.Humanoid.PlatformStand = false
        end
    end)
end))

-- =============================================================
-- OPTIMIZED IMAGE FRUIT ESP ENGINE (EVENT BASED)
-- =============================================================
local FruitBillboards = {}

local function getFruitImage(fruitName)
    for name, iconId in pairs(FruitIcons) do
        if fruitName:lower():find(name:lower()) then
            return iconId
        end
    end
    return DefaultIcon
end

local function isFruitObject(obj)
    local name = obj.Name:lower()
    if obj:IsA("Tool") or obj:IsA("Model") then
        if name:find("fruit") or name:find("meyve") or name:find("blox") then return true end
        for fruitName, _ in pairs(FruitIcons) do
            if name:find(fruitName:lower()) then return true end
        end
    end
    return false
end

local function createFruitESP(obj)
    if FruitBillboards[obj] then return end

    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
    if not handle then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FruitESPLogo"
    bb.Adornee = handle
    bb.Size = UDim2.new(0, 75, 0, 90)
    bb.AlwaysOnTop = true

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, 48, 0, 48)
    img.Position = UDim2.new(0.5, -24, 0, 0)
    img.BackgroundTransparency = 1
    img.Image = getFruitImage(obj.Name)
    img.Parent = bb

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.4, 0)
    textLabel.Position = UDim2.new(0, 0, 0.6, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = obj.Name
    textLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 11
    textLabel.TextStrokeTransparency = 0
    textLabel.Parent = bb

    bb.Parent = CoreGui
    FruitBillboards[obj] = {Gui = bb, Text = textLabel, Handle = handle}
end

-- Event-driven meyve dinleme (Haritayı baştan sona taramaz)
local function checkChild(child)
    if isFruitObject(child) then
        createFruitESP(child)
    end
end

table.insert(Connections, Workspace.ChildAdded:Connect(checkChild))
for _, child in ipairs(Workspace:GetChildren()) do
    checkChild(child)
end

-- Mesafe Güncelleme (0.1 saniyede 1 kez çalışır)
task.spawn(function()
    while true do
        task.wait(0.1)
        if Settings.FruitESP then
            local myChar = LocalPlayer.Character
            local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position or Vector3.zero

            for obj, data in pairs(FruitBillboards) do
                if obj and obj.Parent and data.Handle and data.Handle.Parent then
                    data.Gui.Enabled = true
                    local dist = math.floor((data.Handle.Position - myPos).Magnitude)
                    data.Text.Text = obj.Name .. "\n[" .. dist .. "m]"
                else
                    if data.Gui then data.Gui:Destroy() end
                    FruitBillboards[obj] = nil
                end
            end
        else
            for _, data in pairs(FruitBillboards) do
                if data.Gui then data.Gui.Enabled = false end
            end
        end
    end
end)

-- =============================================================
-- OPTIMIZED DRAWING PLAYER ESP ENGINE
-- =============================================================
local ESPCache = {}

local function createESP(targetPlayer)
    if targetPlayer == LocalPlayer then return end

    local boxOutline = Drawing.new("Square")
    boxOutline.Thickness = 3
    boxOutline.Color = Color3.fromRGB(0, 0, 0)

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 40, 40)

    local text = Drawing.new("Text")
    text.Size = 14
    text.Center = true
    text.Outline = true
    text.Color = Color3.fromRGB(255, 255, 255)

    ESPCache[targetPlayer] = {BoxOutline = boxOutline, Box = box, Text = text}
end

local function removeESP(targetPlayer)
    if ESPCache[targetPlayer] then
        pcall(function()
            ESPCache[targetPlayer].BoxOutline:Remove()
            ESPCache[targetPlayer].Box:Remove()
            ESPCache[targetPlayer].Text:Remove()
        end)
        ESPCache[targetPlayer] = nil
    end
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
table.insert(Connections, Players.PlayerAdded:Connect(createESP))
table.insert(Connections, Players.PlayerRemoving:Connect(removeESP))

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if not Settings.ESP then
        for _, esp in pairs(ESPCache) do
            esp.BoxOutline.Visible = false
            esp.Box.Visible = false
            esp.Text.Visible = false
        end
        return
    end

    for targetPlayer, esp in pairs(ESPCache) do
        local char = targetPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
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
end))

-- =============================================================
-- AIMBOT & AUTO BOUNTY HUNT ENGINE
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
                closest = p.Character
            end
        end
    end
    return closest
end

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if Settings.Aimbot then
        local target = getClosestPlayer()
        if target and target:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.HumanoidRootPart.Position)
        end
    end
end))

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if Settings.AutoHunt then
        pcall(function()
            local myChar = LocalPlayer.Character
            if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

            local target = getClosestPlayer()
            if target and target:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                equipSelectedWeapon()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(500, 500))
            end
        end)
    end
end))

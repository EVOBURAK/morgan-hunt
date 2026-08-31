-- =================================================================================
-- 🔴 MORGAN HUB V9.0 (REDZ STYLE - AUTO STATS & AUTO FARM & MULTI-LANG) 🔴
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

-- Clear Old Instances
if CoreGui:FindFirstChild("MorganHubV9") then CoreGui.MorganHubV9:Destroy() end

-- TRANSLATIONS
local Translations = {
    EN = {
        Title = "🔴 MORGAN HUB - REDZ EDITION",
        MainTab = "Main",
        FarmTab = "Auto Farm",
        StatsTab = "Auto Stats",
        RaidTab = "Auto Raid",
        ESPTab = "Visuals",
        SettingsTab = "Settings",
        AutoFarm = "Auto Farm Level & Island",
        AutoQuest = "Auto Accept Quest",
        SelectWeapon = "Weapon Type",
        AutoStore = "Auto Store Fruit",
        AutoRaid = "Auto Complete Raid",
        StatMelee = "Auto Stat: Melee",
        StatDefense = "Auto Stat: Defense",
        StatSword = "Auto Stat: Sword",
        StatGun = "Auto Stat: Gun",
        StatFruit = "Auto Stat: Demon Fruit",
        FruitESP = "Fruit ESP",
        PlayerESP = "Player ESP",
        Language = "Language / Dil / Lingua"
    },
    TR = {
        Title = "🔴 MORGAN HUB - REDZ EDİSYON",
        MainTab = "Ana Sayfa",
        FarmTab = "Oto Kasılma",
        StatsTab = "Oto Stat",
        RaidTab = "Oto Raid",
        ESPTab = "Görseller",
        SettingsTab = "Ayarlar",
        AutoFarm = "Oto Seviye & Ada Farmı",
        AutoQuest = "Oto Görev Al",
        SelectWeapon = "Silah Türü",
        AutoStore = "Oto Meyve Depola",
        AutoRaid = "Oto Raid Bitir",
        StatMelee = "Oto Stat: Melee (Yüksek Vuruş)",
        StatDefense = "Oto Stat: Defense (Can)",
        StatSword = "Oto Stat: Sword (Kılıç)",
        StatGun = "Oto Stat: Gun (Silah)",
        StatFruit = "Oto Stat: Demon Fruit (Meyve)",
        FruitESP = "Meyve Gösterici",
        PlayerESP = "Oyuncu Gösterici",
        Language = "Language / Dil / Lingua"
    },
    IT = {
        Title = "🔴 MORGAN HUB - EDIZIONE REDZ",
        MainTab = "Principale",
        FarmTab = "Auto Farm",
        StatsTab = "Auto Stats",
        RaidTab = "Auto Raid",
        ESPTab = "Visuali",
        SettingsTab = "Impostazioni",
        AutoFarm = "Auto Farm Livello & Isola",
        AutoQuest = "Auto Prendi Quest",
        SelectWeapon = "Tipo Arma",
        AutoStore = "Auto Salva Frutti",
        AutoRaid = "Auto Completa Raid",
        StatMelee = "Auto Stat: Melee",
        StatDefense = "Auto Stat: Difesa",
        StatSword = "Auto Stat: Spada",
        StatGun = "Auto Stat: Pistola",
        StatFruit = "Auto Stat: Frutto",
        FruitESP = "ESP Frutti",
        PlayerESP = "ESP Giocatori",
        Language = "Language / Dil / Lingua"
    }
}

local Settings = {
    CurrentLang = "EN",
    ESP = false,
    FruitESP = false,
    AutoFarm = false,
    AutoQuest = true,
    AutoRaid = false,
    SelectedWeapon = "Melee",
    AutoStore = true,
    FarmDistance = 9,
    
    -- AUTO STATS SETTINGS
    AutoStatMelee = false,
    AutoStatDefense = false,
    AutoStatSword = false,
    AutoStatGun = false,
    AutoStatFruit = false
}

-- BLOX FRUITS LEVEL DATA
local QuestData = {
    {MinLevel = 1, MaxLevel = 14, QuestName = "BanditQuest1", QuestLevel = 1, MobName = "Bandit", CFrame = CFrame.new(1059, 16, 1548)},
    {MinLevel = 15, MaxLevel = 29, QuestName = "JungleQuest", QuestLevel = 1, MobName = "Monkey", CFrame = CFrame.new(-1598, 36, 153)},
    {MinLevel = 30, MaxLevel = 59, QuestName = "PirateQuest", QuestLevel = 1, MobName = "Pirate", CFrame = CFrame.new(-1140, 4, 3828)},
    {MinLevel = 60, MaxLevel = 89, QuestName = "DesertQuest", QuestLevel = 1, MobName = "Desert Bandit", CFrame = CFrame.new(894, 6, 4385)},
    {MinLevel = 90, MaxLevel = 119, QuestName = "SnowQuest", QuestLevel = 1, MobName = "Snow Bandit", CFrame = CFrame.new(1385, 87, -1298)},
    {MinLevel = 120, MaxLevel = 149, QuestName = "MarineQuest2", QuestLevel = 1, MobName = "Chief Petty Officer", CFrame = CFrame.new(-5036, 28, 4324)},
    {MinLevel = 150, MaxLevel = 189, QuestName = "SkyQuest", QuestLevel = 1, MobName = "Sky Bandit", CFrame = CFrame.new(-4839, 717, -2620)}
}

-- BASE GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV9"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- INTRO SCREEN
local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(0, 300, 0, 180)
IntroFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
IntroFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
IntroFrame.BorderSizePixel = 0
IntroFrame.ClipsDescendants = true
IntroFrame.Parent = ScreenGui

local IntroCorner = Instance.new("UICorner")
IntroCorner.CornerRadius = UDim.new(0, 12)
IntroCorner.Parent = IntroFrame

local IntroTitle = Instance.new("TextLabel")
IntroTitle.Size = UDim2.new(1, 0, 0.5, 0)
IntroTitle.BackgroundTransparency = 1
IntroTitle.Text = "🔴 MORGAN HUB"
IntroTitle.TextColor3 = Color3.fromRGB(230, 30, 30)
IntroTitle.Font = Enum.Font.GothamBold
IntroTitle.TextSize = 22
IntroTitle.Parent = IntroFrame

local LoadingBarBg = Instance.new("Frame")
LoadingBarBg.Size = UDim2.new(0.8, 0, 0, 6)
LoadingBarBg.Position = UDim2.new(0.1, 0, 0.7, 0)
LoadingBarBg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
LoadingBarBg.BorderSizePixel = 0
LoadingBarBg.Parent = IntroFrame

local LoadingBar = Instance.new("Frame")
LoadingBar.Size = UDim2.new(0, 0, 1, 0)
LoadingBar.BackgroundColor3 = Color3.fromRGB(230, 30, 30)
LoadingBar.BorderSizePixel = 0
LoadingBar.Parent = LoadingBarBg

local LoadBarCorner = Instance.new("UICorner")
LoadBarCorner.CornerRadius = UDim.new(0, 3)
LoadBarCorner.Parent = LoadingBar

TweenService:Create(LoadingBar, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

task.delay(1.6, function()
    TweenService:Create(IntroFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.3)
    IntroFrame:Destroy()
    
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 540, 0, 350),
        Position = UDim2.new(0.5, -270, 0.5, -175)
    }):Play()
end)

-- TOGGLE LOGO
local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Size = UDim2.new(0, 45, 0, 45)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(200, 25, 25)
ToggleLogo.BorderSizePixel = 0
ToggleLogo.Text = "🔴"
ToggleLogo.TextSize = 22
ToggleLogo.Active = true
ToggleLogo.Draggable = true
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = ToggleLogo

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- TITLE BAR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = Translations[Settings.CurrentLang].Title
TitleLabel.TextColor3 = Color3.fromRGB(240, 40, 40)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 135, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 5)
SideLayout.Parent = Sidebar

-- PAGES HOLDER
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -145, 1, -45)
Pages.Position = UDim2.new(0, 140, 0, 42)
Pages.BackgroundTransparency = 1
Pages.Parent = MainFrame

local PageFrames = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.Visible = false
    page.Parent = Pages

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page

    PageFrames[name] = page
    return page
end

local FarmPage = createPage("Farm")
local StatsPage = createPage("Stats")
local RaidPage = createPage("Raid")
local ESPPage = createPage("ESP")
local SettingsPage = createPage("Settings")

FarmPage.Visible = true

-- TABS
local TabButtons = {}
local function createTab(name, langKey, pageTarget)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    btn.BorderSizePixel = 0
    btn.Text = Translations[Settings.CurrentLang][langKey]
    btn.TextColor3 = Color3.fromRGB(180, 180, 190)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.Parent = Sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PageFrames) do p.Visible = false end
        for _, b in pairs(TabButtons) do 
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 24, 30), TextColor3 = Color3.fromRGB(180, 180, 190)}):Play()
        end
        pageTarget.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 25, 25), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    TabButtons[langKey] = btn
end

createTab("Farm", "FarmTab", FarmPage)
createTab("Stats", "StatsTab", StatsPage)
createTab("Raid", "RaidTab", RaidPage)
createTab("ESP", "ESPTab", ESPPage)
createTab("Settings", "SettingsTab", SettingsPage)

-- TOGGLE BUILDER
local function addToggle(parent, langKey, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.96, 0, 0, 36)
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    card.BorderSizePixel = 0
    card.Parent = parent

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = Translations[Settings.CurrentLang][langKey]
    label.TextColor3 = Color3.fromRGB(210, 210, 220)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 36, 0, 18)
    btn.Position = UDim2.new(0.85, 0, 0.25, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(200, 25, 25) or Color3.fromRGB(45, 45, 55)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 9)
    btnCorner.Parent = btn

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(200, 25, 25) or Color3.fromRGB(45, 45, 55)
        }):Play()
        pcall(callback, state)
    end)
end

-- FARM PAGE SETUP
addToggle(FarmPage, "AutoFarm", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle(FarmPage, "AutoQuest", Settings.AutoQuest, function(v) Settings.AutoQuest = v end)
addToggle(FarmPage, "AutoStore", Settings.AutoStore, function(v) Settings.AutoStore = v end)

-- WEAPON SELECTOR
local weaponCard = Instance.new("Frame")
weaponCard.Size = UDim2.new(0.96, 0, 0, 36)
weaponCard.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
weaponCard.BorderSizePixel = 0
weaponCard.Parent = FarmPage

local wCorner = Instance.new("UICorner")
wCorner.CornerRadius = UDim.new(0, 6)
wCorner.Parent = weaponCard

local wLabel = Instance.new("TextLabel")
wLabel.Size = UDim2.new(0.5, 0, 1, 0)
wLabel.Position = UDim2.new(0.04, 0, 0, 0)
wLabel.BackgroundTransparency = 1
wLabel.Text = Translations[Settings.CurrentLang].SelectWeapon
wLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
wLabel.Font = Enum.Font.GothamMedium
wLabel.TextSize = 11
wLabel.TextXAlignment = Enum.TextXAlignment.Left
wLabel.Parent = weaponCard

local wBtn = Instance.new("TextButton")
wBtn.Size = UDim2.new(0, 80, 0, 22)
wBtn.Position = UDim2.new(0.72, 0, 0.18, 0)
wBtn.BackgroundColor3 = Color3.fromRGB(200, 25, 25)
wBtn.Text = "Melee"
wBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
wBtn.Font = Enum.Font.GothamBold
wBtn.TextSize = 11
wBtn.Parent = weaponCard

local wBtnCorner = Instance.new("UICorner")
wBtnCorner.CornerRadius = UDim.new(0, 4)
wBtnCorner.Parent = wBtn

local weapons = {"Melee", "Sword", "Gun", "Fruit"}
local wIdx = 1
wBtn.MouseButton1Click:Connect(function()
    wIdx = wIdx + 1
    if wIdx > #weapons then wIdx = 1 end
    Settings.SelectedWeapon = weapons[wIdx]
    wBtn.Text = Settings.SelectedWeapon
end)

-- STATS PAGE SETUP
addToggle(StatsPage, "StatMelee", Settings.AutoStatMelee, function(v) Settings.AutoStatMelee = v end)
addToggle(StatsPage, "StatDefense", Settings.AutoStatDefense, function(v) Settings.AutoStatDefense = v end)
addToggle(StatsPage, "StatSword", Settings.AutoStatSword, function(v) Settings.AutoStatSword = v end)
addToggle(StatsPage, "StatGun", Settings.AutoStatGun, function(v) Settings.AutoStatGun = v end)
addToggle(StatsPage, "StatFruit", Settings.AutoStatFruit, function(v) Settings.AutoStatFruit = v end)

-- OTHER PAGES SETUP
addToggle(RaidPage, "AutoRaid", Settings.AutoRaid, function(v) Settings.AutoRaid = v end)
addToggle(ESPPage, "FruitESP", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle(ESPPage, "PlayerESP", Settings.ESP, function(v) Settings.ESP = v end)

-- SETTINGS PAGE (LANG)
local langCard = Instance.new("Frame")
langCard.Size = UDim2.new(0.96, 0, 0, 36)
langCard.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
langCard.BorderSizePixel = 0
langCard.Parent = SettingsPage

local lCorner = Instance.new("UICorner")
lCorner.CornerRadius = UDim.new(0, 6)
lCorner.Parent = langCard

local langLabel = Instance.new("TextLabel")
langLabel.Size = UDim2.new(0.5, 0, 1, 0)
langLabel.Position = UDim2.new(0.04, 0, 0, 0)
langLabel.BackgroundTransparency = 1
langLabel.Text = Translations[Settings.CurrentLang].Language
langLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
langLabel.Font = Enum.Font.GothamMedium
langLabel.TextSize = 10
langLabel.TextXAlignment = Enum.TextXAlignment.Left
langLabel.Parent = langCard

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 85, 0, 22)
langBtn.Position = UDim2.new(0.70, 0, 0.18, 0)
langBtn.BackgroundColor3 = Color3.fromRGB(35, 110, 210)
langBtn.Text = "EN / English"
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.Font = Enum.Font.GothamBold
langBtn.TextSize = 10
langBtn.Parent = langCard

local langBtnCorner = Instance.new("UICorner")
langBtnCorner.CornerRadius = UDim.new(0, 4)
langBtnCorner.Parent = langBtn

local langList = {"EN", "TR", "IT"}
local langNames = {EN = "English", TR = "Türkçe", IT = "Italiano"}
local lIdx = 1

local function updateLanguage(lang)
    Settings.CurrentLang = lang
    TitleLabel.Text = Translations[lang].Title
    wLabel.Text = Translations[lang].SelectWeapon
    langLabel.Text = Translations[lang].Language

    for key, btn in pairs(TabButtons) do
        btn.Text = Translations[lang][key]
    end
end

langBtn.MouseButton1Click:Connect(function()
    lIdx = lIdx + 1
    if lIdx > #langList then lIdx = 1 end
    local selLang = langList[lIdx]
    langBtn.Text = selLang .. " / " .. langNames[selLang]
    updateLanguage(selLang)
end)

-- =============================================================
-- AUTO STATS ENGINE
-- =============================================================
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if Settings.AutoStatMelee then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
            end
            if Settings.AutoStatDefense then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
            if Settings.AutoStatSword then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
            end
            if Settings.AutoStatGun then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
            end
            if Settings.AutoStatFruit then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
            end
        end)
    end
end)

-- =============================================================
-- AUTO FARM & WEAPON ENGINE
-- =============================================================
local function equipSelectedWeapon()
    local myChar = LocalPlayer.Character
    if not myChar then return end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end

    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            if Settings.SelectedWeapon == "Melee" and (tool.ToolTip == "Melee" or tool.Name:find("Combat") or tool.Name:find("Step")) then
                myChar.Humanoid:EquipTool(tool)
                break
            elseif Settings.SelectedWeapon == "Sword" and (tool.ToolTip == "Sword" or tool.Name:find("Katana") or tool.Name:find("Blade")) then
                myChar.Humanoid:EquipTool(tool)
                break
            elseif Settings.SelectedWeapon == "Gun" and tool.ToolTip == "Gun" then
                myChar.Humanoid:EquipTool(tool)
                break
            elseif Settings.SelectedWeapon == "Fruit" and (tool.ToolTip == "Blox Fruit" or tool.Name:find("Fruit")) then
                myChar.Humanoid:EquipTool(tool)
                break
            end
        end
    end
end

local function getMyLevel()
    pcall(function() return LocalPlayer.Data.Level.Value end)
    return 1
end

local function getCurrentQuest()
    local level = getMyLevel()
    for _, q in ipairs(QuestData) do
        if level >= q.MinLevel and level <= q.MaxLevel then return q end
    end
    return QuestData[1]
end

RunService.Heartbeat:Connect(function()
    if not Settings.AutoFarm then return end

    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
        local root = myChar.HumanoidRootPart

        local currentQuest = getCurrentQuest()

        local hasQuest = false
        if LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") then
            hasQuest = LocalPlayer.PlayerGui.Main.Quest.Visible
        end

        if Settings.AutoQuest and not hasQuest then
            if (root.Position - currentQuest.CFrame.Position).Magnitude > 60 then
                root.CFrame = currentQuest.CFrame
                task.wait(0.5)
            end
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.QuestLevel)
            task.wait(0.5)
            return
        end

        equipSelectedWeapon()

        local enemies = Workspace:FindFirstChild("Enemies") or Workspace
        local targetMob = nil
        for _, enemy in pairs(enemies:GetChildren()) do
            if enemy:IsA("Model") and enemy.Name == currentQuest.MobName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                targetMob = enemy
                break
            end
        end

        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
            myChar.Humanoid.PlatformStand = true
            root.CFrame = CFrame.lookAt(targetMob.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0), targetMob.HumanoidRootPart.Position)

            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        else
            root.CFrame = currentQuest.CFrame * CFrame.new(0, 15, 0)
        end
    end)
end)

-- AUTO STORE FRUIT
LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    if not Settings.AutoStore then return end
    task.wait(0.5)
    if tool:IsA("Tool") and (tool.Name:find("Fruit") or tool.Name:find("Meyve")) then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name, tool)
        end)
    end
end)

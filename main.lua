-- =================================================================================
-- 🔴 MORGAN HUB V7.0 (REDZ HUB STYLE - EN / TR / IT - AUTO RAID & QUEST) 🔴
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
if CoreGui:FindFirstChild("MorganHubV7") then CoreGui.MorganHubV7:Destroy() end

-- LANGUAGE DICTIONARY
local Translations = {
    EN = {
        Title = "🔴 MORGAN HUB - REDZ STYLE",
        MainTab = "Main",
        FarmTab = "Auto Farm",
        RaidTab = "Auto Raid",
        ESPTab = "ESP & Visuals",
        SettingsTab = "Settings",
        AutoFarm = "Auto Farm Level & Quest",
        AutoQuest = "Auto Take Quest",
        SelectWeapon = "Select Weapon",
        AutoStore = "Auto Store Fruit",
        AutoRaid = "Auto Finish Raid (Kill NPCs)",
        FruitESP = "Fruit ESP",
        PlayerESP = "Player ESP",
        Language = "Language / Dil / Lingua"
    },
    TR = {
        Title = "🔴 MORGAN HUB - REDZ BİÇİMİ",
        MainTab = "Ana Sayfa",
        FarmTab = "Otomatik Kasılma",
        RaidTab = "Otomatik Raid",
        ESPTab = "ESP ve Görseller",
        SettingsTab = "Ayarlar",
        AutoFarm = "Otomatik Seviye & Görev",
        AutoQuest = "Otomatik Görev Al",
        SelectWeapon = "Silah Seçimi",
        AutoStore = "Meyveleri Depola",
        AutoRaid = "Raidi Bitir (NPC Kes)",
        FruitESP = "Meyve Gösterici",
        PlayerESP = "Oyuncu Gösterici",
        Language = "Language / Dil / Lingua"
    },
    IT = {
        Title = "🔴 MORGAN HUB - STILE REDZ",
        MainTab = "Principale",
        FarmTab = "Auto Farm",
        RaidTab = "Auto Raid",
        ESPTab = "ESP e Visuali",
        SettingsTab = "Impostazioni",
        AutoFarm = "Auto Farm Livello & Quest",
        AutoQuest = "Prendi Quest Auto",
        SelectWeapon = "Seleziona Arma",
        AutoStore = "Salva Frutti Auto",
        AutoRaid = "Completa Raid (Uccidi NPC)",
        FruitESP = "ESP Frutti",
        PlayerESP = "ESP Giocatori",
        Language = "Language / Dil / Lingua"
    }
}

-- SETTINGS
local Settings = {
    CurrentLang = "EN",
    ESP = false,
    FruitESP = false,
    AutoFarm = false,
    AutoQuest = true,
    AutoRaid = false,
    SelectedWeapon = "Melee",
    AutoStore = true,
    FarmDistance = 8
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

-- REDZ HUB STYLE GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV7"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 45, 0, 45)
ToggleLogo.Position = UDim2.new(0, 15, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
ToggleLogo.BorderSizePixel = 0
ToggleLogo.Text = "🔴"
ToggleLogo.TextSize = 22
ToggleLogo.Active = true
ToggleLogo.Draggable = true
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = ToggleLogo

-- MAIN CONTAINER
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- TOP TITLE BAR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = Translations[Settings.CurrentLang].Title
TitleLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- SIDEBAR TABS (REDZ HUB STYLE)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 4)
SideLayout.Parent = Sidebar

-- CONTENT CONTAINERS
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -135, 1, -40)
Pages.Position = UDim2.new(0, 132, 0, 38)
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
local RaidPage = createPage("Raid")
local ESPPage = createPage("ESP")
local SettingsPage = createPage("Settings")

FarmPage.Visible = true

-- TAB BUTTON CREATOR
local TabButtons = {}
local function createTab(name, langKey, pageTarget)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 32)
    btn.Position = UDim2.new(0, 4, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.BorderSizePixel = 0
    btn.Text = Translations[Settings.CurrentLang][langKey]
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.Parent = Sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(PageFrames) do p.Visible = false end
        for _, b in pairs(TabButtons) do b.BackgroundColor3 = Color3.fromRGB(25, 25, 30) end
        pageTarget.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
    end)

    TabButtons[langKey] = btn
end

createTab("Farm", "FarmTab", FarmPage)
createTab("Raid", "RaidTab", RaidPage)
createTab("ESP", "ESPTab", ESPPage)
createTab("Settings", "SettingsTab", SettingsPage)

-- DYNAMIC UI BUILDERS
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
    label.Name = "Text"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = Translations[Settings.CurrentLang][langKey]
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 36, 0, 18)
    btn.Position = UDim2.new(0.85, 0, 0.25, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(200, 30, 30) or Color3.fromRGB(40, 40, 50)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 9)
    btnCorner.Parent = btn

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(200, 30, 30) or Color3.fromRGB(40, 40, 50)
        pcall(callback, state)
    end)
end

-- POPULATE FARM PAGE
addToggle(FarmPage, "AutoFarm", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle(FarmPage, "AutoQuest", Settings.AutoQuest, function(v) Settings.AutoQuest = v end)
addToggle(FarmPage, "AutoStore", Settings.AutoStore, function(v) Settings.AutoStore = v end)

-- WEAPON SELECTOR
local weaponCard = Instance.new("Frame")
weaponCard.Size = UDim2.new(0.96, 0, 0, 36)
weaponCard.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
weaponCard.BorderSizePixel = 0
weaponCard.Parent = FarmPage

local wLabel = Instance.new("TextLabel")
wLabel.Name = "WLabel"
wLabel.Size = UDim2.new(0.5, 0, 1, 0)
wLabel.Position = UDim2.new(0.04, 0, 0, 0)
wLabel.BackgroundTransparency = 1
wLabel.Text = Translations[Settings.CurrentLang].SelectWeapon
wLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
wLabel.Font = Enum.Font.GothamMedium
wLabel.TextSize = 12
wLabel.TextXAlignment = Enum.TextXAlignment.Left
wLabel.Parent = weaponCard

local wBtn = Instance.new("TextButton")
wBtn.Size = UDim2.new(0, 80, 0, 22)
wBtn.Position = UDim2.new(0.72, 0, 0.18, 0)
wBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
wBtn.Text = "Melee"
wBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
wBtn.Font = Enum.Font.GothamBold
wBtn.TextSize = 11
wBtn.Parent = weaponCard

local wCorner = Instance.new("UICorner")
wCorner.CornerRadius = UDim.new(0, 4)
wCorner.Parent = wBtn

local weapons = {"Melee", "Sword", "Gun", "Fruit"}
local wIdx = 1
wBtn.MouseButton1Click:Connect(function()
    wIdx = wIdx + 1
    if wIdx > #weapons then wIdx = 1 end
    Settings.SelectedWeapon = weapons[wIdx]
    wBtn.Text = Settings.SelectedWeapon
end)

-- POPULATE RAID PAGE
addToggle(RaidPage, "AutoRaid", Settings.AutoRaid, function(v) Settings.AutoRaid = v end)

-- POPULATE ESP PAGE
addToggle(ESPPage, "FruitESP", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle(ESPPage, "PlayerESP", Settings.ESP, function(v) Settings.ESP = v end)

-- POPULATE SETTINGS PAGE (LANGUAGE SWITCHER)
local langCard = Instance.new("Frame")
langCard.Size = UDim2.new(0.96, 0, 0, 36)
langCard.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
langCard.BorderSizePixel = 0
langCard.Parent = SettingsPage

local langLabel = Instance.new("TextLabel")
langLabel.Name = "LLabel"
langLabel.Size = UDim2.new(0.5, 0, 1, 0)
langLabel.Position = UDim2.new(0.04, 0, 0, 0)
langLabel.BackgroundTransparency = 1
langLabel.Text = Translations[Settings.CurrentLang].Language
langLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
langLabel.Font = Enum.Font.GothamMedium
langLabel.TextSize = 11
langLabel.TextXAlignment = Enum.TextXAlignment.Left
langLabel.Parent = langCard

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 80, 0, 22)
langBtn.Position = UDim2.new(0.72, 0, 0.18, 0)
langBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 220)
langBtn.Text = "EN / English"
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.Font = Enum.Font.GothamBold
langBtn.TextSize = 10
langBtn.Parent = langCard

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
    local selectedLang = langList[lIdx]
    langBtn.Text = selectedLang .. " / " .. langNames[selectedLang]
    updateLanguage(selectedLang)
end)

-- =============================================================
-- AUTO FINISH RAID SYSTEM
-- =============================================================
table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.AutoRaid then return end

    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local root = myChar.HumanoidRootPart

        -- Check Raid Map Locations / Enemies
        local raidEnemies = Workspace:FindFirstChild("Raids") or Workspace:FindFirstChild("Enemies") or Workspace
        local targetEnemy = nil

        for _, enemy in pairs(raidEnemies:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                targetEnemy = enemy
                break
            end
        end

        if targetEnemy then
            myChar.Humanoid.PlatformStand = true
            root.CFrame = targetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, Settings.FarmDistance, 0)

            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        end
    end)
end))

-- =============================================================
-- AUTO FARM & QUEST ENGINE
-- =============================================================
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

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.AutoFarm or Settings.AutoRaid then return end

    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local root = myChar.HumanoidRootPart

        local currentQuest = getCurrentQuest()

        -- Auto Quest
        local hasQuest = false
        if LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") then
            hasQuest = LocalPlayer.PlayerGui.Main.Quest.Visible
        end

        if Settings.AutoQuest and not hasQuest then
            if (root.Position - currentQuest.CFrame.Position).Magnitude > 50 then
                root.CFrame = currentQuest.CFrame
                task.wait(0.5)
            end
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.QuestLevel)
            task.wait(0.5)
            return
        end

        -- Find Enemy
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
        end
    end)
end))

-- AUTO STORE FRUIT
local function storeFruit(tool)
    if not Settings.AutoStore or not tool or not tool:IsA("Tool") then return end
    if tool.Name:find("Fruit") or tool.Name:find("Meyve") then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name, tool)
        end)
    end
end

table.insert(Connections, LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    task.wait(0.5)
    storeFruit(tool)
end))

-- NOTIFICATION
game.StarterGui:SetCore("SendNotification", {
    Title = "🔴 MORGAN HUB V7.0",
    Text = "Redz Hub Style & Auto Raid Multi-Lang Loaded!",
    Duration = 4
})

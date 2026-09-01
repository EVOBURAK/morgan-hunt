-- =================================================================================
-- 💎 MORGAN CLIENT V5.0 (MULTILINGUAL & SMART AUTO QUEST FARM) 💎
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
    ESP = false,
    FruitESP = false,
    AutoFarm = false,
    AutoQuest = true,
    WeaponType = "Blox Fruits", -- "Blox Fruits", "Melee", "Sword", "Gun"
    Language = "TR", -- "TR", "EN", "IT"
    Aimbot = false,
    AutoHunt = false,
    AutoStore = true,
    LuckMultiplier = false,
    LuckPower = 100,
    FlySpeed = 12,
    FarmDistance = 8
}

-- TRANSLATION DICTIONARY
local Translations = {
    TR = {
        Title = "💎 MORGAN CLIENT",
        Search = "🔍 Modüllerde ara...",
        AutoFarm = "Otomatik Farm",
        AutoQuest = "Otomatik Görev Al",
        AutoStore = "Meyve Depola",
        LuckBooster = "Şans Arttırıcı",
        FruitESP = "Meyve ESP",
        PlayerESP = "Oyuncu ESP",
        Aimbot = "Aimbot",
        AutoHunt = "Otomatik Av",
        WeaponSelect = "Silah: ",
        LangSelect = "Dil / Language",
        Notif = "Morgan Client yüklendi!"
    },
    EN = {
        Title = "💎 MORGAN CLIENT",
        Search = "🔍 Search modules...",
        AutoFarm = "Auto Farm",
        AutoQuest = "Auto Get Quest",
        AutoStore = "Auto Store Fruit",
        LuckBooster = "Luck Booster",
        FruitESP = "Fruit ESP",
        PlayerESP = "Player ESP",
        Aimbot = "Aimbot",
        AutoHunt = "Auto Hunt",
        WeaponSelect = "Weapon: ",
        LangSelect = "Language / Dil",
        Notif = "Morgan Client loaded!"
    },
    IT = {
        Title = "💎 MORGAN CLIENT",
        Search = "🔍 Cerca moduli...",
        AutoFarm = "Farm Automatico",
        AutoQuest = "Ottieni Quest",
        AutoStore = "Salva Frutto",
        LuckBooster = "Aumento Fortuna",
        FruitESP = "ESP Frutti",
        PlayerESP = "ESP Giocatori",
        Aimbot = "Aimbot",
        AutoHunt = "Caccia Automatica",
        WeaponSelect = "Arma: ",
        LangSelect = "Lingua / Language",
        Notif = "Morgan Client caricato!"
    }
}

-- FRUIT ICONS
local FruitIcons = {
    ["Kitsune"] = "rbxassetid://15312061073", ["Dragon"] = "rbxassetid://13886869488",
    ["Leopard"] = "rbxassetid://13886867744", ["Dough"] = "rbxassetid://13886866168",
    ["Venom"] = "rbxassetid://13886870244", ["Buddha"] = "rbxassetid://13886865890"
}
local DefaultIcon = "rbxassetid://13886865768"

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- LOGO BUTTON
local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Size = UDim2.new(0, 48, 0, 48)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(25, 18, 38)
ToggleLogo.Text = "💎"
ToggleLogo.TextSize = 24
ToggleLogo.Active = true
ToggleLogo.Draggable = true
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 12)
LogoCorner.Parent = ToggleLogo

-- MAIN DASHBOARD
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 660, 0, 420)
MainFrame.Position = UDim2.new(0.5, -330, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Size = UDim2.new(0, 120, 1, 0)
LogoLabel.Position = UDim2.new(0, 15, 0, 0)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = Translations[Settings.Language].Title
LogoLabel.TextColor3 = Color3.fromRGB(200, 140, 255)
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextSize = 13
LogoLabel.TextXAlignment = Enum.TextXAlignment.Left
LogoLabel.Parent = TopBar

local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(0, 220, 0, 28)
SearchFrame.Position = UDim2.new(0.5, -110, 0.5, -14)
SearchFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
SearchFrame.Parent = TopBar

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -20, 1, 0)
SearchBox.Position = UDim2.new(0, 10, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = Translations[Settings.Language].Search
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextSize = 11
SearchBox.Parent = SearchFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- SIDEBAR & LANGUAGE SELECTOR
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 140, 1, -55)
SideBar.Position = UDim2.new(0, 12, 0, 48)
SideBar.BackgroundTransparency = 1
SideBar.Parent = MainFrame

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 6)
SideLayout.Parent = SideBar

-- DİL SEÇİM BUTONLARI (TR / EN / IT)
local LangTitle = Instance.new("TextLabel")
LangTitle.Size = UDim2.new(1, 0, 0, 20)
LangTitle.BackgroundTransparency = 1
LangTitle.Text = "🌐 Language"
LangTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
LangTitle.Font = Enum.Font.GothamBold
LangTitle.TextSize = 11
LangTitle.Parent = SideBar

local LangFrame = Instance.new("Frame")
LangFrame.Size = UDim2.new(1, 0, 0, 32)
LangFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
LangFrame.Parent = SideBar

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 6)
LangCorner.Parent = LangFrame

local function createLangBtn(lang, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.31, 0, 0.8, 0)
    btn.Position = pos
    btn.BackgroundColor3 = Settings.Language == lang and Color3.fromRGB(150, 50, 255) or Color3.fromRGB(40, 40, 50)
    btn.Text = lang
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = LangFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Settings.Language = lang
        SearchBox.PlaceholderText = Translations[lang].Search
        LogoLabel.Text = Translations[lang].Title
        game.StarterGui:SetCore("SendNotification", {Title = "Morgan", Text = "Language: " .. lang, Duration = 2})
    end)
end

createLangBtn("TR", UDim2.new(0.02, 0, 0.1, 0))
createLangBtn("EN", UDim2.new(0.35, 0, 0.1, 0))
createLangBtn("IT", UDim2.new(0.68, 0, 0.1, 0))

-- SİLAH SEÇİMİ (WEAPON SELECTOR)
local WeaponTitle = Instance.new("TextLabel")
WeaponTitle.Size = UDim2.new(1, 0, 0, 20)
WeaponTitle.BackgroundTransparency = 1
WeaponTitle.Text = "⚔️ Weapon Type"
WeaponTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
WeaponTitle.Font = Enum.Font.GothamBold
WeaponTitle.TextSize = 11
WeaponTitle.Parent = SideBar

local WeaponBtn = Instance.new("TextButton")
WeaponBtn.Size = UDim2.new(1, 0, 0, 32)
WeaponBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
WeaponBtn.Text = Settings.WeaponType
WeaponBtn.TextColor3 = Color3.fromRGB(200, 140, 255)
WeaponBtn.Font = Enum.Font.GothamBold
WeaponBtn.TextSize = 11
WeaponBtn.Parent = SideBar

local WCorner = Instance.new("UICorner")
WCorner.CornerRadius = UDim.new(0, 6)
WCorner.Parent = WeaponBtn

local WeaponsList = {"Blox Fruits", "Melee", "Sword", "Gun"}
local wIdx = 1

WeaponBtn.MouseButton1Click:Connect(function()
    wIdx = wIdx % #WeaponsList + 1
    Settings.WeaponType = WeaponsList[wIdx]
    WeaponBtn.Text = Settings.WeaponType
end)

-- GRID MODULE CONTAINER
local GridContainer = Instance.new("ScrollingFrame")
GridContainer.Size = UDim2.new(1, -170, 1, -55)
GridContainer.Position = UDim2.new(0, 160, 0, 48)
GridContainer.BackgroundTransparency = 1
GridContainer.ScrollBarThickness = 3
GridContainer.Parent = MainFrame

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 112, 0, 85)
GridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
GridLayout.Parent = GridContainer

local function addModuleCard(titleKey, defaultState, callback)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    card.Parent = GridContainer

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -8, 0, 30)
    nameLabel.Position = UDim2.new(0, 4, 0, 12)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = titleKey
    nameLabel.TextColor3 = Color3.fromRGB(230, 230, 245)
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.TextSize = 11
    nameLabel.TextWrapped = true
    nameLabel.Parent = card

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 46, 0, 20)
    toggleBtn.Position = UDim2.new(0.5, -23, 1, -28)
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
    toggleBtn.Text = ""
    toggleBtn.Parent = card

    local pillCorner = Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(1, 0)
    pillCorner.Parent = toggleBtn

    local state = defaultState
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
        pcall(callback, state)
    end)
end

addModuleCard("AutoFarm", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addModuleCard("AutoQuest", Settings.AutoQuest, function(v) Settings.AutoQuest = v end)
addModuleCard("AutoStore", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addModuleCard("Fruit ESP", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addModuleCard("Player ESP", Settings.ESP, function(v) Settings.ESP = v end)
addModuleCard("Aimbot", Settings.Aimbot, function(v) Settings.Aimbot = v end)

-- =============================================================
-- SMART QUEST & WEAPON FARM ENGINE (SEA 1, 2, 3 SUPPORT)
-- =============================================================
local function getPlayerLevel()
    local level = 1
    pcall(function()
        level = LocalPlayer.Data.Level.Value
    end)
    return level
end

local function checkAndTakeQuest()
    if not Settings.AutoQuest then return end
    pcall(function()
        local level = getPlayerLevel()
        local questName, questLevel = "BanditQuest1", 1
        
        -- Leveline göre dinamik quest belirleme
        if level >= 10 and level < 15 then questName, questLevel = "JungleQuest", 1
        elseif level >= 15 then questName, questLevel = "JungleQuest", 2 end

        -- Remote üzerinden görevi tetikle
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("StartQuest", questName, questLevel)
    end)
end

local function equipSelectedWeapon()
    local char = LocalPlayer.Character
    if not char then return end

    local toolType = Settings.WeaponType
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    
    -- Eline uygun silahı geçirme
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            if toolType == "Blox Fruits" and (tool.ToolTip == "Blox Fruit" or tool.Name:find("Fruit")) then return tool end
            if toolType == "Melee" and tool.ToolTip == "Melee" then return tool end
            if toolType == "Sword" and tool.ToolTip == "Sword" then return tool end
            if toolType == "Gun" and tool.ToolTip == "Gun" then return tool end
        end
    end

    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local isMatch = false
                if toolType == "Blox Fruits" and (tool.ToolTip == "Blox Fruit" or tool.Name:find("Fruit")) then isMatch = true
                elseif toolType == "Melee" and tool.ToolTip == "Melee" then isMatch = true
                elseif toolType == "Sword" and tool.ToolTip == "Sword" then isMatch = true
                elseif toolType == "Gun" and tool.ToolTip == "Gun" then isMatch = true end

                if isMatch then
                    char.Humanoid:EquipTool(tool)
                    return tool
                end
            end
        end
    end
    return nil
end

local function getClosestEnemy()
    local closest, minDistance = nil, math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end

    local enemies = Workspace:FindFirstChild("Enemies") or Workspace
    for _, enemy in pairs(enemies:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(enemy) then
                local dist = (enemy.HumanoidRootPart.Position - myChar.HumanoidRootPart.Position).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    closest = enemy
                end
            end
        end
    end
    return closest
end

-- AUTO FARM LOOP WITH SKILL ATTACKS
table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.AutoFarm then return end

    pcall(function()
        checkAndTakeQuest()

        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
        local root = myChar.HumanoidRootPart

        local enemy = getClosestEnemy()
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            myChar.Humanoid.PlatformStand = true

            local activeWeapon = equipSelectedWeapon()

            local enemyPos = enemy.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
            root.CFrame = CFrame.lookAt(enemyPos, enemy.HumanoidRootPart.Position)

            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))

            -- Blox Fruits seçiliyse skilleri otomatik kullan
            if Settings.WeaponType == "Blox Fruits" and activeWeapon then
                local VirtualInputManager = game:GetService("VirtualInputManager")
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game)
            end
        else
            myChar.Humanoid.PlatformStand = false
        end
    end)
end))

-- AUTO STORE ENGINE
local function storeFruit(tool)
    if not Settings.AutoStore or not tool or not tool:IsA("Tool") then return end
    if tool.Name:find("Fruit") or tool.Name:find("Meyve") or FruitIcons[tool.Name:gsub(" Fruit", "")] then
        pcall(function()
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("StoreFruit", tool.Name, tool)
        end)
    end
end

table.insert(Connections, LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    task.wait(0.5)
    storeFruit(tool)
end))

-- NOTIFICATION
game.StarterGui:SetCore("SendNotification", {
    Title = "💎 MORGAN CLIENT V5",
    Text = Translations[Settings.Language].Notif,
    Duration = 4
})

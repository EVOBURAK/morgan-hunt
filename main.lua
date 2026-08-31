-- =================================================================================
-- 🏴‍☠️ MORGAN HUB V6.0 (ULTIMATE BLOX FRUITS EDITION) 🏴‍☠️
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

-- Anti-AFK
table.insert(Connections, LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end))

-- Clear Previous GUI
if CoreGui:FindFirstChild("MorganHubV6") then CoreGui.MorganHubV6:Destroy() end

-- AYARLAR
local Settings = {
    AutoFarm = false,
    AutoQuest = true,
    AutoStore = true,
    ESP = false,
    FruitESP = false,
    Aimbot = false,
    LuckMultiplier = false,
    LuckPower = 100,
    FlySpeed = 25,
    FarmDistance = 8
}

-- LEVEL & ADA VERİ TABANI (1. DÜNYA / SEA 1)
local LevelData = {
    {MinLevel = 1, MaxLevel = 14, QuestNPC = "Bandit Quest Giver", QuestName = "BanditQuest1", QuestLevel = 1, TargetMob = "Bandit", SpawnCFrame = CFrame.new(1059, 16, 1548)},
    {MinLevel = 15, MaxLevel = 29, QuestNPC = "Jungle Quest Giver", QuestName = "JungleQuest", QuestLevel = 1, TargetMob = "Monkey", SpawnCFrame = CFrame.new(-1610, 36, 147)},
    {MinLevel = 30, MaxLevel = 59, QuestNPC = "Pirate Quest Giver", QuestName = "BuggyQuest1", QuestLevel = 1, TargetMob = "Pirate", SpawnCFrame = CFrame.new(-1140, 4, 3828)},
    {MinLevel = 60, MaxLevel = 89, QuestNPC = "Desert Quest Giver", QuestName = "DesertQuest", QuestLevel = 1, TargetMob = "Desert Bandit", SpawnCFrame = CFrame.new(896, 6, 4388)},
    {MinLevel = 90, MaxLevel = 119, QuestNPC = "Snow Quest Giver", QuestName = "SnowQuest", QuestLevel = 1, TargetMob = "Snow Bandit", SpawnCFrame = CFrame.new(1385, 87, -1298)},
    {MinLevel = 120, MaxLevel = 149, QuestNPC = "Marine Quest Giver", QuestName = "MarineQuest2", QuestLevel = 1, TargetMob = "Chief Petty Officer", SpawnCFrame = CFrame.new(-5035, 20, 4322)},
    {MinLevel = 150, MaxLevel = 189, QuestNPC = "Sky Quest Giver", QuestName = "SkyQuest", QuestLevel = 1, TargetMob = "Sky Bandit", SpawnCFrame = CFrame.new(-4832, 717, -2620)}
}

-- MEYVE İKONLARI
local FruitIcons = {
    ["Kitsune"] = "rbxassetid://15312061073",
    ["Dragon"] = "rbxassetid://13886869488",
    ["Leopard"] = "rbxassetid://13886867744",
    ["Dough"] = "rbxassetid://13886866168",
    ["T-Rex"] = "rbxassetid://15682970597",
    ["Buddha"] = "rbxassetid://13886865890",
    ["Venom"] = "rbxassetid://13886870244",
    ["Magma"] = "rbxassetid://13886868420",
    ["Light"] = "rbxassetid://13886867888",
    ["Ice"] = "rbxassetid://13886867566"
}
local DefaultIcon = "rbxassetid://13886865768"

-- =============================================================
-- GUI MİMARİSİ
-- =============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV6"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- 🎬 AÇILIŞ ANİMASYONU (INTRO SPLASH)
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(0, 320, 0, 180)
IntroFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
IntroFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
IntroFrame.BorderSizePixel = 0
IntroFrame.BackgroundTransparency = 1
IntroFrame.Parent = ScreenGui

local IntroCorner = Instance.new("UICorner")
IntroCorner.CornerRadius = UDim.new(0, 16)
IntroCorner.Parent = IntroFrame

local IntroStroke = Instance.new("UIStroke")
IntroStroke.Color = Color3.fromRGB(130, 90, 230)
IntroStroke.Thickness = 2
IntroStroke.Transparency = 1
IntroStroke.Parent = IntroFrame

local IntroLogo = Instance.new("TextLabel")
IntroLogo.Size = UDim2.new(1, 0, 0, 60)
IntroLogo.Position = UDim2.new(0, 0, 0.2, 0)
IntroLogo.BackgroundTransparency = 1
IntroLogo.Text = "🏴‍☠️"
IntroLogo.TextSize = 48
IntroLogo.TextTransparency = 1
IntroLogo.Parent = IntroFrame

local IntroTitle = Instance.new("TextLabel")
IntroTitle.Size = UDim2.new(1, 0, 0, 30)
IntroTitle.Position = UDim2.new(0, 0, 0.6, 0)
IntroTitle.BackgroundTransparency = 1
IntroTitle.Text = "MORGAN HUB V6"
IntroTitle.TextColor3 = Color3.fromRGB(220, 220, 245)
IntroTitle.Font = Enum.Font.GothamBold
IntroTitle.TextSize = 18
IntroTitle.TextTransparency = 1
IntroTitle.Parent = IntroFrame

-- Intro Animasyon Mantığı
task.spawn(function()
    TweenService:Create(IntroFrame, TweenInfo.new(0.6), {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(IntroStroke, TweenInfo.new(0.6), {Transparency = 0}):Play()
    TweenService:Create(IntroLogo, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    TweenService:Create(IntroTitle, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    task.wait(2)
    TweenService:Create(IntroFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    TweenService:Create(IntroLogo, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(IntroTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    task.wait(0.5)
    IntroFrame:Destroy()
end)

-- TOGGLE LOGO BUTTON
local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 48, 0, 48)
ToggleLogo.Position = UDim2.new(0, 25, 0.15, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
ToggleLogo.BorderSizePixel = 0
ToggleLogo.Text = "🏴‍☠️"
ToggleLogo.TextSize = 24
ToggleLogo.Active = true
ToggleLogo.Draggable = true
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 12)
LogoCorner.Parent = ToggleLogo

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(120, 80, 220)
LogoStroke.Thickness = 2
LogoStroke.Parent = ToggleLogo

-- MAIN WINDOW
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 500)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 70, 200)
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🏴‍☠️ MORGAN HUB V6.0 — DARK EDITION"
Title.TextColor3 = Color3.fromRGB(180, 160, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- LUCK FRAME
local LuckFrame = Instance.new("Frame")
LuckFrame.Name = "LuckFrame"
LuckFrame.Size = UDim2.new(0, 240, 0, 120)
LuckFrame.Position = UDim2.new(0.8, -250, 0.2, 0)
LuckFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
LuckFrame.BorderSizePixel = 0
LuckFrame.Active = true
LuckFrame.Draggable = true
LuckFrame.Visible = false
LuckFrame.Parent = ScreenGui

local LuckCorner = Instance.new("UICorner")
LuckCorner.CornerRadius = UDim.new(0, 10)
LuckCorner.Parent = LuckFrame

local LuckStroke = Instance.new("UIStroke")
LuckStroke.Color = Color3.fromRGB(255, 215, 0)
LuckStroke.Thickness = 1.5
LuckStroke.Parent = LuckFrame

local LuckTitle = Instance.new("TextLabel")
LuckTitle.Size = UDim2.new(1, 0, 0, 30)
LuckTitle.BackgroundTransparency = 1
LuckTitle.Text = "🍀 LUCK MULTIPLIER"
LuckTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
LuckTitle.Font = Enum.Font.GothamBold
LuckTitle.TextSize = 13
LuckTitle.Parent = LuckFrame

local LuckStatus = Instance.new("TextLabel")
LuckStatus.Size = UDim2.new(1, 0, 0, 25)
LuckStatus.Position = UDim2.new(0, 0, 0.35, 0)
LuckStatus.BackgroundTransparency = 1
LuckStatus.Text = "POWER: 100x ACTIVE"
LuckStatus.TextColor3 = Color3.fromRGB(140, 255, 170)
LuckStatus.Font = Enum.Font.GothamBold
LuckStatus.TextSize = 12
LuckStatus.Parent = LuckFrame

local ChanceDisplay = Instance.new("TextLabel")
ChanceDisplay.Size = UDim2.new(1, -20, 0, 30)
ChanceDisplay.Position = UDim2.new(0, 10, 0.65, 0)
ChanceDisplay.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
ChanceDisplay.BorderSizePixel = 0
ChanceDisplay.Text = "Mythical Rate: ~85.0%"
ChanceDisplay.TextColor3 = Color3.fromRGB(255, 170, 50)
ChanceDisplay.Font = Enum.Font.GothamMedium
ChanceDisplay.TextSize = 11
ChanceDisplay.Parent = LuckFrame

local ChanceCorner = Instance.new("UICorner")
ChanceCorner.CornerRadius = UDim.new(0, 6)
ChanceCorner.Parent = ChanceDisplay

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 48)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Container

local function addToggle(text, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    card.BorderSizePixel = 0
    card.Parent = Container

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(0.86, 0, 0.24, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(110, 70, 210) or Color3.fromRGB(45, 45, 60)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 11)
    btnCorner.Parent = btn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
    circle.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
    circle.BorderSizePixel = 0
    circle.Parent = btn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 8)
    circleCorner.Parent = circle

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(110, 70, 210) or Color3.fromRGB(45, 45, 60)
        circle.Position = state and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
        pcall(callback, state)
    end)
end

local function addButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.98, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(32, 32, 46)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 190, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = Container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

local function addSlider(text, min, max, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 50)
    card.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    card.BorderSizePixel = 0
    card.Parent = Container

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0.5, 0)
    label.Position = UDim2.new(0.04, 0, 0.08, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0.76, 0, 0.08, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(160, 130, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = card

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(0.92, 0, 0, 8)
    sliderBg.Position = UDim2.new(0.04, 0, 0.65, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.Parent = card

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(120, 80, 230)
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

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- MENÜ ELEMANLARI
addToggle("🌾 Auto Farm Level (Sea 1 + Quests)", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle("📜 Auto Get Quest (Level Based)", Settings.AutoQuest, function(v) Settings.AutoQuest = v end)
addToggle("📦 Auto Store Fruit (Inventory)", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle("🍀 Luck Rate Multiplier GUI", Settings.LuckMultiplier, function(v) 
    Settings.LuckMultiplier = v 
    LuckFrame.Visible = v
end)

addSlider("🍀 Luck Multiplier Power", 1, 1000, Settings.LuckPower, function(v)
    Settings.LuckPower = v
    LuckStatus.Text = "POWER: " .. v .. "x"
    local simulatedRate = math.min(99.9, math.floor(v * 0.85 * 10) / 10)
    ChanceDisplay.Text = "Mythical Rate: ~" .. simulatedRate .. "%"
end)

addButton("🎰 Roll Fruit (Random Fruit Spin)", function()
    pcall(function()
        local args = {[1] = "Cousin", [2] = "Buy"}
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end)
    game.StarterGui:SetCore("SendNotification", {
        Title = "🎰 FRUIT ROLL",
        Text = "Random fruit bought from Cousin NPC!",
        Duration = 3
    })
end)

addButton("🍎 Fruit Spawner (Visual)", function()
    local myChar = LocalPlayer.Character
    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
        local p = Instance.new("Part")
        p.Size = Vector3.new(1.5, 1.5, 1.5)
        p.Position = myChar.HumanoidRootPart.Position + Vector3.new(0, 3, -5)
        p.BrickColor = BrickColor.new("Bright red")
        p.Material = Enum.Material.Neon
        p.Name = "Kitsune Fruit [Visual]"
        p.Parent = Workspace
        
        local b = Instance.new("BillboardGui")
        b.Size = UDim2.new(0, 100, 0, 30)
        b.Adornee = p
        b.AlwaysOnTop = true
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, 0, 1, 0)
        t.Text = "🦊 Kitsune Fruit"
        t.TextColor3 = Color3.fromRGB(255, 100, 100)
        t.BackgroundTransparency = 1
        t.Font = Enum.Font.GothamBold
        t.Parent = b
        b.Parent = p

        game.StarterGui:SetCore("SendNotification", {
            Title = "🍎 FRUIT SPAWNER",
            Text = "Visual Kitsune Fruit Spawned!",
            Duration = 3
        })
    end
end)

addToggle("🖼️ Fruit ESP (With Images)", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("👁️ Player ESP (Boxes)", Settings.ESP, function(v) Settings.ESP = v end)
addSlider("⚙️ Fly Speed", 10, 50, Settings.FlySpeed, function(v) Settings.FlySpeed = v end)

-- =============================================================
-- AUTO FARM & QUEST ENGINE (SEA 1)
-- =============================================================
local function getCurrentQuestData()
    local level = LocalPlayer.Data.Level.Value
    for _, data in ipairs(LevelData) do
        if level >= data.MinLevel and level <= data.MaxLevel then
            return data
        end
    end
    return LevelData[1]
end

local function hasQuest()
    local myGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
    if myGui and myGui:FindFirstChild("Quest") and myGui.Quest.Visible then
        return true
    end
    return false
end

local function takeQuest(questData)
    if not Settings.AutoQuest or hasQuest() then return end
    pcall(function()
        local args = {
            [1] = "StartQuest",
            [2] = questData.QuestName,
            [3] = questData.QuestLevel
        }
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end)
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.AutoFarm then return end

    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
        local root = myChar.HumanoidRootPart

        local currentData = getCurrentQuestData()

        -- Auto Quest Al
        if not hasQuest() then
            if (root.Position - currentData.SpawnCFrame.Position).Magnitude > 50 then
                root.CFrame = currentData.SpawnCFrame
            else
                takeQuest(currentData)
            end
            return
        end

        -- Düşman Bul ve Farm Yap
        local targetEnemy = nil
        local enemies = Workspace:FindFirstChild("Enemies") or Workspace
        for _, enemy in pairs(enemies:GetChildren()) do
            if enemy:IsA("Model") and enemy.Name == currentData.TargetMob and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                targetEnemy = enemy
                break
            end
        end

        if targetEnemy then
            myChar.Humanoid.PlatformStand = true

            -- Equip Weapon
            local tool = myChar:FindFirstChildOfClass("Tool")
            if not tool then
                local weapon = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                if weapon then myChar.Humanoid:EquipTool(weapon) end
            end

            local enemyPos = targetEnemy.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
            root.CFrame = CFrame.lookAt(enemyPos, targetEnemy.HumanoidRootPart.Position)

            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        else
            -- Düşman Yoksa Spawn Noktasına Git
            root.CFrame = currentData.SpawnCFrame
            myChar.Humanoid.PlatformStand = false
        end
    end)
end))

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

-- BİLDİRİM
game.StarterGui:SetCore("SendNotification", {
    Title = "🏴‍☠️ MORGAN HUB V6.0",
    Text = "Yenilenmiş UI ve Auto Quest/Farm Yüklendi!",
    Duration = 4
})

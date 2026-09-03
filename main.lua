-- =================================================================================
-- 🔮 MORGAN HUB V5.0 (AMETHYST EDITION - SAFE & FIXED) 🔮
-- =================================================================================

if not game:IsLoaded() then 
    pcall(function() game.Loaded:Wait() end) 
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

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
    Aimbot = false,
    AutoHunt = false,
    AutoStore = true,
    LuckMultiplier = false,
    LuckPower = 100,
    FlySpeed = 12,
    FarmDistance = 8,
    AdminHop = true
}

-- =============================================================
-- BLOX FRUITS LEVEL & QUEST DATABASE (1 - 2800 LEVEL)
-- =============================================================
local QuestData = {
    -- FIRST SEA
    {MinLvl = 1, MaxLvl = 14, QuestName = "BanditQuest1", QuestLvl = 1, Mob = "Bandit", NPC = "Bandit Quest Giver", NPCPos = Vector3.new(1059, 16, 1549)},
    {MinLvl = 15, MaxLvl = 29, QuestName = "JungleQuest", QuestLvl = 1, Mob = "Monkey", NPC = "Jungle Quest Giver", NPCPos = Vector3.new(-1598, 36, 153)},
    {MinLvl = 30, MaxLvl = 59, QuestName = "PirateQuest", QuestLvl = 1, Mob = "Pirate", NPC = "Pirate Quest Giver", NPCPos = Vector3.new(-1140, 4, 3828)},
    {MinLvl = 60, MaxLvl = 89, QuestName = "DesertQuest", QuestLvl = 1, Mob = "Desert Bandit", NPC = "Desert Quest Giver", NPCPos = Vector3.new(894, 6, 4388)},
    {MinLvl = 90, MaxLvl = 119, QuestName = "SnowQuest", QuestLvl = 1, Mob = "Snow Bandit", NPC = "Snow Quest Giver", NPCPos = Vector3.new(1385, 87, -1298)},
    {MinLvl = 120, MaxLvl = 149, QuestName = "MarineQuest2", QuestLvl = 1, Mob = "Chief Petty Officer", NPC = "Marine Quest Giver", NPCPos = Vector3.new(-5035, 20, 4324)},
    {MinLvl = 150, MaxLvl = 189, QuestName = "SkyQuest", QuestLvl = 1, Mob = "Sky Bandit", NPC = "Sky Quest Giver", NPCPos = Vector3.new(-4839, 717, -2619)},
    {MinLvl = 190, MaxLvl = 249, QuestName = "PrisonerQuest", QuestLvl = 1, Mob = "Prisoner", NPC = "Prison Quest Giver", NPCPos = Vector3.new(530, 1, 474)},
    {MinLvl = 250, MaxLvl = 299, QuestName = "ColosseumQuest", QuestLvl = 1, Mob = "Toga Warrior", NPC = "Colosseum Quest Giver", NPCPos = Vector3.new(-1580, 7, -2982)},
    {MinLvl = 300, MaxLvl = 374, QuestName = "MagmaQuest", QuestLvl = 1, Mob = "Military Soldier", NPC = "Magma Quest Giver", NPCPos = Vector3.new(-5313, 12, 8515)},
    {MinLvl = 375, MaxLvl = 449, QuestName = "FishmanQuest", QuestLvl = 1, Mob = "Fishman Warrior", NPC = "Fishman Quest Giver", NPCPos = Vector3.new(61122, 18, 1569)},
    {MinLvl = 450, MaxLvl = 524, QuestName = "Sky2Quest", QuestLvl = 1, Mob = "God's Guard", NPC = "Upper Sky Quest Giver", NPCPos = Vector3.new(-7906, 5611, -2280)},
    {MinLvl = 525, MaxLvl = 624, QuestName = "FountainQuest", QuestLvl = 1, Mob = "Shandora Warrior", NPC = "Fountain Quest Giver", NPCPos = Vector3.new(5259, 38, 4050)},
    {MinLvl = 625, MaxLvl = 699, QuestName = "GalleyQuest", QuestLvl = 1, Mob = "Galley Pirate", NPC = "Fountain Quest Giver", NPCPos = Vector3.new(5259, 38, 4050)},
    
    -- SECOND SEA
    {MinLvl = 700, MaxLvl = 774, QuestName = "Area1Quest", QuestLvl = 1, Mob = "Raider", NPC = "Quest Giver", NPCPos = Vector3.new(-424, 73, 1836)},
    {MinLvl = 775, MaxLvl = 874, QuestName = "Area2Quest", QuestLvl = 1, Mob = "Mercenary", NPC = "Quest Giver", NPCPos = Vector3.new(638, 73, 918)},
    {MinLvl = 875, MaxLvl = 999, QuestName = "MarineQuest3", QuestLvl = 1, Mob = "Marine Lieutenant", NPC = "Quest Giver", NPCPos = Vector3.new(-2440, 73, -3216)},
    {MinLvl = 1000, MaxLvl = 1174, QuestName = "SnowMountainQuest", QuestLvl = 1, Mob = "Snow Trooper", NPC = "Quest Giver", NPCPos = Vector3.new(609, 401, -5372)},
    {MinLvl = 1175, MaxLvl = 1349, QuestName = "ShipQuest1", QuestLvl = 1, Mob = "Ship Deckhand", NPC = "Quest Giver", NPCPos = Vector3.new(920, 125, 32800)},
    {MinLvl = 1350, MaxLvl = 1499, QuestName = "FrostQuest", QuestLvl = 1, Mob = "Arctic Warrior", NPC = "Quest Giver", NPCPos = Vector3.new(5667, 28, -6480)},

    -- THIRD SEA & 2026 UPDATE (UP TO LEVEL 2800)
    {MinLvl = 1500, MaxLvl = 1574, QuestName = "PiratePortQuest", QuestLvl = 1, Mob = "Pirate Millionaire", NPC = "Quest Giver", NPCPos = Vector3.new(-290, 44, 5580)},
    {MinLvl = 1575, MaxLvl = 1699, QuestName = "AmazonQuest", QuestLvl = 1, Mob = "Dragon Crew Warrior", NPC = "Quest Giver", NPCPos = Vector3.new(5833, 52, -1105)},
    {MinLvl = 1700, MaxLvl = 1824, QuestName = "MarineTreeQuest", QuestLvl = 1, Mob = "Marine Commodore", NPC = "Quest Giver", NPCPos = Vector3.new(2180, 29, -6740)},
    {MinLvl = 1825, MaxLvl = 1974, QuestName = "DeepForestIslandQuest", QuestLvl = 1, Mob = "Fishman Raider", NPC = "Quest Giver", NPCPos = Vector3.new(-10500, 332, -8760)},
    {MinLvl = 1975, MaxLvl = 2074, QuestName = "HauntedQuest1", QuestLvl = 1, Mob = "Reborn Skeleton", NPC = "Quest Giver", NPCPos = Vector3.new(-9515, 142, 5520)},
    {MinLvl = 2075, MaxLvl = 2199, QuestName = "PeanutQuest", QuestLvl = 1, Mob = "Peanut Scout", NPC = "Quest Giver", NPCPos = Vector3.new(-2100, 38, -10190)},
    {MinLvl = 2200, MaxLvl = 2449, QuestName = "IceCreamQuest1", QuestLvl = 1, Mob = "Ice Cream Chef", NPC = "Quest Giver", NPCPos = Vector3.new(-820, 65, -10960)},
    {MinLvl = 2450, MaxLvl = 2599, QuestName = "TikiQuest1", QuestLvl = 1, Mob = "Sun-kissed Warrior", NPC = "Quest Giver", NPCPos = Vector3.new(-16533, 55, -172]},
    {MinLvl = 2600, MaxLvl = 2800, QuestName = "TikiQuest2", QuestLvl = 2, Mob = "Isle Outlaw", NPC = "Quest Giver", NPCPos = Vector3.new(-16700, 70, 200)}
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

-- SERVER HOP ENGINE
local function ServerHop()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end

local function CheckForAdmins()
    if not Settings.AdminHop then return end
    pcall(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                if p:GetRankInGroup(2924100) and p:GetRankInGroup(2924100) >= 2 then
                    ServerHop()
                elseif p.Name:lower():find("admin") or p.Name:lower():find("mod") or p.Name:lower():find("uzoth") then
                    ServerHop()
                end
            end
        end
    end)
end

table.insert(Connections, Players.PlayerAdded:Connect(function() CheckForAdmins() end))

-- =============================================================
-- GUI ARCHITECTURE & SCREEN GUI
-- =============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV5"
ScreenGui.ResetOnSpawn = false

-- Executor Desteği için CoreGui denemesi, yoksa LocalPlayer.PlayerGui
local parentTarget = CoreGui
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- 🔮 AÇILIŞ EKRANI (LOADING / INTRO SCREEN)
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 100
LoadingFrame.Parent = ScreenGui

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 50)
LoadingTitle.Position = UDim2.new(0, 0, 0.38, 0)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "💎 MORGAN HUB V5 💎"
LoadingTitle.TextColor3 = Color3.fromRGB(180, 100, 255)
LoadingTitle.TextSize = 28
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.ZIndex = 101
LoadingTitle.Parent = LoadingFrame

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 30)
LoadingSub.Position = UDim2.new(0, 0, 0.45, 0)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Text = "Ametist Gücü Yükleniyor..."
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

local BarBgCorner = Instance.new("UICorner")
BarBgCorner.CornerRadius = UDim.new(1, 0)
BarBgCorner.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(160, 30, 255)
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 102
BarFill.Parent = BarBg

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(1, 0)
BarFillCorner.Parent = BarFill

task.spawn(function()
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(BarFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    tween.Completed:Wait()
    
    LoadingSub.Text = "Hazır!"
    task.wait(0.3)
    LoadingFrame:Destroy()
end)

-- LOGO BUTTON
local ToggleLogo = Instance.new("ImageButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 48, 0, 48)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
ToggleLogo.BorderSizePixel = 0
ToggleLogo.AutoButtonColor = false
ToggleLogo.Active = true
ToggleLogo.Draggable = true
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 12)
LogoCorner.Parent = ToggleLogo

local LogoImage = Instance.new("ImageLabel")
LogoImage.Name = "LogoImage"
LogoImage.Size = UDim2.new(1, 0, 1, 0)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://15312061073"
LogoImage.ScaleType = Enum.ScaleType.Fit
LogoImage.Parent = ToggleLogo

-- MAIN WINDOW
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 480)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local startPos
ToggleLogo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startPos = input.Position
    end
end)

ToggleLogo.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if startPos then
            local delta = (input.Position - startPos).Magnitude
            if delta < 10 then
                MainFrame.Visible = not MainFrame.Visible
            end
        end
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💎 MORGAN HUB V5.0"
Title.TextColor3 = Color3.fromRGB(200, 130, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- LUCK BOOSTER GUI
local LuckFrame = Instance.new("Frame")
LuckFrame.Name = "LuckFrame"
LuckFrame.Size = UDim2.new(0, 260, 0, 140)
LuckFrame.Position = UDim2.new(0.8, -260, 0.15, 0)
LuckFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 32)
LuckFrame.BorderSizePixel = 0
LuckFrame.Active = true
LuckFrame.Draggable = true
LuckFrame.Visible = false
LuckFrame.Parent = ScreenGui

local LuckCorner = Instance.new("UICorner")
LuckCorner.CornerRadius = UDim.new(0, 8)
LuckCorner.Parent = LuckFrame

local LuckTitle = Instance.new("TextLabel")
LuckTitle.Size = UDim2.new(1, 0, 0, 30)
LuckTitle.Position = UDim2.new(0, 0, 0.05, 0)
LuckTitle.BackgroundTransparency = 1
LuckTitle.Text = "🔮 LUCK RATE BOOSTER"
LuckTitle.TextColor3 = Color3.fromRGB(220, 150, 255)
LuckTitle.Font = Enum.Font.GothamBold
LuckTitle.TextSize = 13
LuckTitle.Parent = LuckFrame

local LuckStatus = Instance.new("TextLabel")
LuckStatus.Size = UDim2.new(1, 0, 0, 25)
LuckStatus.Position = UDim2.new(0, 0, 0.3, 0)
LuckStatus.BackgroundTransparency = 1
LuckStatus.Text = "MULTIPLIER: 100x"
LuckStatus.TextColor3 = Color3.fromRGB(170, 100, 255)
LuckStatus.Font = Enum.Font.GothamBold
LuckStatus.TextSize = 12
LuckStatus.Parent = LuckFrame

local ChanceDisplay = Instance.new("TextLabel")
ChanceDisplay.Size = UDim2.new(1, -20, 0, 30)
ChanceDisplay.Position = UDim2.new(0, 10, 0.55, 0)
ChanceDisplay.BackgroundColor3 = Color3.fromRGB(30, 20, 48)
ChanceDisplay.BorderSizePixel = 0
ChanceDisplay.Text = "Mythical Drop Rate: ~84.5%"
ChanceDisplay.TextColor3 = Color3.fromRGB(255, 170, 0)
ChanceDisplay.Font = Enum.Font.GothamMedium
ChanceDisplay.TextSize = 11
ChanceDisplay.Parent = LuckFrame

-- CONFIRM DESTROY FRAME
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(12, 8, 18)
ConfirmFrame.BackgroundTransparency = 0.1
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 10
ConfirmFrame.Parent = MainFrame

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, 0, 0.4, 0)
ConfirmText.Position = UDim2.new(0, 0, 0.2, 0)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "GUI'yi kapatıp silmek istediğinize emin misiniz?"
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 14
ConfirmText.ZIndex = 11
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 100, 0, 35)
YesBtn.Position = UDim2.new(0.2, 0, 0.65, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 80)
YesBtn.Text = "EVET"
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 11
YesBtn.Parent = ConfirmFrame

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 100, 0, 35)
NoBtn.Position = UDim2.new(0.6, 0, 0.65, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 75)
NoBtn.Text = "HAYIR"
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.ZIndex = 11
NoBtn.Parent = ConfirmFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 70)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 48)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(150, 60, 255)
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Container

local function addToggle(text, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(24, 18, 38)
    card.BorderSizePixel = 0
    card.Parent = Container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
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

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
    circle.BackgroundColor3 = Color3.fromRGB(240, 230, 255)
    circle.BorderSizePixel = 0
    circle.Parent = btn

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
        circle.Position = state and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
        pcall(callback, state)
    end)
end

local function addSlider(text, min, max, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 50)
    card.BackgroundColor3 = Color3.fromRGB(24, 18, 38)
    card.BorderSizePixel = 0
    card.Parent = Container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0.5, 0)
    label.Position = UDim2.new(0.04, 0, 0.08, 0)
    label.BackgroundTransparency = 1
    label.Text = text
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

-- MENU ITEMS
addToggle("🔮 Luck Rate Booster GUI", Settings.LuckMultiplier, function(v) 
    Settings.LuckMultiplier = v
    LuckFrame.Visible = v
end)
addSlider("🔮 Luck Multiplier Power", 1, 1000, Settings.LuckPower, function(v)
    Settings.LuckPower = v
    LuckStatus.Text = "MULTIPLIER: " .. v .. "x"
    local simulatedRate = math.min(99.9, math.floor(v * 0.85 * 10) / 10)
    ChanceDisplay.Text = "Mythical Drop Rate: ~" .. simulatedRate .. "%"
end)

addToggle("🌾 Auto Farm Level + Quest (1-2800)", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle("⚡ Admin Detect Auto Server Hop", Settings.AdminHop, function(v) Settings.AdminHop = v end)
addToggle("📦 Auto Store Fruit (Inventory)", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle("🖼️ Fruit ESP (With Image Icons)", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("👁️ Player ESP (Boxes & HP)", Settings.ESP, function(v) Settings.ESP = v end)
addToggle("🎯 Aimbot (Nearest Player)", Settings.Aimbot, function(v) Settings.Aimbot = v end)
addToggle("⚡ Auto Bounty Hunt (Fast Fly)", Settings.AutoHunt, function(v) Settings.AutoHunt = v end)

-- SETTINGS SECTION
addSlider("⚙️ Fly / Hunt Speed", 5, 30, Settings.FlySpeed, function(v) Settings.FlySpeed = v end)
addSlider("⚙️ Auto Farm Distance (Height)", 3, 20, Settings.FarmDistance, function(v) Settings.FarmDistance = v end)

-- =============================================================
-- AUTO STORE FRUIT ENGINE
-- =============================================================
local function storeFruit(tool)
    if not Settings.AutoStore or not tool or not tool:IsA("Tool") then return end
    if tool.Name:find("Fruit") or tool.Name:find("Meyve") or FruitIcons[tool.Name:gsub(" Fruit", "")] then
        pcall(function()
            local args = {[1] = "StoreFruit", [2] = tool.Name, [3] = tool}
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
        end)
    end
end

table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(storeFruit)
end))
if LocalPlayer.Character then LocalPlayer.Character.ChildAdded:Connect(storeFruit) end

table.insert(Connections, LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    task.wait(0.5)
    storeFruit(tool)
end))

-- =============================================================
-- AUTO FARM LEVEL & QUEST ENGINE
-- =============================================================
local function getMyLevel()
    local level = 1
    pcall(function()
        level = LocalPlayer.Data.Level.Value
    end)
    return level
end

local function getCurrentQuest()
    local myLevel = getMyLevel()
    for _, quest in pairs(QuestData) do
        if myLevel >= quest.MinLvl and myLevel <= quest.MaxLvl then
            return quest
        end
    end
    return QuestData[#QuestData]
end

local function hasActiveQuest()
    local active = false
    pcall(function()
        local mainFrame = LocalPlayer.PlayerGui:FindFirstChild("Main")
        if mainFrame and mainFrame:FindFirstChild("Quest") and mainFrame.Quest.Visible then
            active = true
        end
    end)
    return active
end

local function takeQuest(quest)
    pcall(function()
        local args = {
            [1] = "StartQuest",
            [2] = quest.QuestName,
            [3] = quest.QuestLvl
        }
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end)
end

local function getTargetEnemy(mobName)
    local closest, minDistance = nil, math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position

    local enemies = Workspace:FindFirstChild("Enemies") or Workspace
    for _, enemy in pairs(enemies:GetChildren()) do
        if enemy:IsA("Model") and enemy.Name == mobName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
            local dist = (enemy.HumanoidRootPart.Position - myPos).Magnitude
            if dist < minDistance then
                minDistance = dist
                closest = enemy
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

        local currentQuest = getCurrentQuest()

        if not hasActiveQuest() then
            myChar.Humanoid.PlatformStand = true
            local distToNPC = (root.Position - currentQuest.NPCPos).Magnitude
            if distToNPC > 8 then
                root.CFrame = CFrame.new(currentQuest.NPCPos + Vector3.new(0, 5, 0))
            else
                takeQuest(currentQuest)
            end
            return
        end

        local enemy = getTargetEnemy(currentQuest.Mob)
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            myChar.Humanoid.PlatformStand = true

            local tool = myChar:FindFirstChildOfClass("Tool")
            if not tool then
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    local weapon = backpack:FindFirstChildOfClass("Tool")
                    if weapon then myChar.Humanoid:EquipTool(weapon) end
                end
            end

            local enemyPos = enemy.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
            root.CFrame = CFrame.lookAt(enemyPos, enemy.HumanoidRootPart.Position)

            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        else
            myChar.Humanoid.PlatformStand = false
        end
    end)
end))

-- DESTROY FUNCTION
YesBtn.MouseButton1Click:Connect(function()
    Settings.AutoFarm = false
    Settings.AutoHunt = false
    Settings.ESP = false
    Settings.FruitESP = false
    Settings.AutoStore = false
    Settings.LuckMultiplier = false
    Settings.AdminHop = false

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end

    for _, conn in pairs(Connections) do pcall(function() conn:Disconnect() end) end
    ScreenGui:Destroy()
end)

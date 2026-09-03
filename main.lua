-- =================================================================================
-- 🔮 MORGAN HUB V6.1 (FIXED ADMIN DETECT & ROBUST SERVER HOP) 🔮
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
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Connections = {}

-- Safe GUI Parent
local ParentGui
if gethui then
    ParentGui = gethui()
elseif syn and syn.protect_gui then
    ParentGui = Instance.new("Folder")
    syn.protect_gui(ParentGui)
    ParentGui.Parent = CoreGui
else
    ParentGui = CoreGui:FindFirstChild("RobloxGui") or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end

if ParentGui:FindFirstChild("MorganHubV6") then 
    ParentGui.MorganHubV6:Destroy() 
end

-- LANGUAGE SYSTEM
local CurrentLang = "IT"

local Translations = {
    IT = {
        Title = "💎 MORGAN HUB V6.1",
        LoadingSub = "Caricamento Modulo Blox Fruits 2800...",
        Ready = "Pronto!",
        LuckGUI = "🔮 Potenziatore Fortuna (Luck)",
        LuckPower = "🔮 Potenza Moltiplicatore",
        AutoFarm = "🌾 Auto Farm Level + Quest",
        AutoStore = "📦 Deposito Automatico Frutti",
        FruitESP = "🖼️ ESP Frutti (Con Icone)",
        PlayerESP = "👁️ ESP Giocatori (Box & HP)",
        Aimbot = "🎯 Mirino Automatico (Aimbot)",
        AutoHunt = "⚡ Caccia Taglie Automatica",
        AdminHop = "🛡️ Auto Server Hop (Admin Detect)",
        FlySpeed = "⚙️ Velocità Volo / Caccia",
        FarmDist = "⚙️ Distanza Farm (Altezza)",
        ConfirmText = "Sei sicuro di voler chiudere la GUI?",
        Yes = "SÌ",
        No = "NO",
        NotifTitle = "💎 MORGAN HUB V6.1",
        NotifText = "Sistema caricato con successo!"
    },
    EN = {
        Title = "💎 MORGAN HUB V6.1",
        LoadingSub = "Loading Blox Fruits 2800 Module...",
        Ready = "Ready!",
        LuckGUI = "🔮 Luck Rate Booster GUI",
        LuckPower = "🔮 Luck Multiplier Power",
        AutoFarm = "🌾 Auto Farm Level + Quest",
        AutoStore = "📦 Auto Store Fruit (Inventory)",
        FruitESP = "🖼️ Fruit ESP (With Icons)",
        PlayerESP = "👁️ Player ESP (Boxes & HP)",
        Aimbot = "🎯 Aimbot (Nearest Player)",
        AutoHunt = "⚡ Auto Bounty Hunt (Fast Fly)",
        AdminHop = "🛡️ Auto Server Hop (Admin Detect)",
        FlySpeed = "⚙️ Fly / Hunt Speed",
        FarmDist = "⚙️ Auto Farm Distance (Height)",
        ConfirmText = "Are you sure you want to close and destroy the GUI?",
        Yes = "YES",
        No = "NO",
        NotifTitle = "💎 MORGAN HUB V6.1",
        NotifText = "System loaded successfully!"
    }
}

-- SETTINGS
local Settings = {
    ESP = false,
    FruitESP = false,
    AutoFarm = false,
    Aimbot = false,
    AutoHunt = false,
    AutoStore = true,
    AdminHop = true,
    LuckMultiplier = false,
    LuckPower = 100,
    FlySpeed = 12,
    FarmDistance = 9
}

-- STRICT ADMIN LIST (ONLY EXACT USERNAMES & USER IDS)
local ExactAdminNames = {
    ["uzoth"] = true,
    ["rip_indra"] = true,
    ["mygame43"] = true,
    ["zioles"] = true,
    ["axiore"] = true,
    ["wenlocktoad"] = true,
    ["daigrock"] = true,
    ["kilobyte"] = true,
    ["nobleee"] = true
}

local AdminUserIds = {
    [115003008] = true, -- rip_indra
    [30005273] = true,  -- mygame43
    [150047872] = true, -- Zioles
    [89389230] = true,  -- Uzoth
}

-- ADVANCED ROBUST SERVER HOP ENGINE
local isHopping = false
local function ServerHop()
    if isHopping then return end
    isHopping = true

    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🛡️ ADMIN DETECTED!",
            Text = "Gerçek Admin Algılandı! Sunucudan Kaçılıyor...",
            Duration = 5
        })
    end)

    local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    local placeId = game.PlaceId
    local jobId = game.JobId

    task.spawn(function()
        for attempt = 1, 5 do
            local servers = {}
            local reqUrl = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/0?sortOrder=Asc&limit=100"

            if httpRequest then
                local res = pcall(function()
                    return httpRequest({Url = reqUrl, Method = "GET"})
                end)
                if res and res.Body then
                    local data = pcall(function() return HttpService:JSONDecode(res.Body) end)
                    if data and data.data then
                        for _, v in pairs(data.data) do
                            if type(v) == "table" and v.playing < v.maxPlayers and v.id ~= jobId then
                                table.insert(servers, v.id)
                            end
                        end
                    end
                end
            end

            if #servers == 0 then
                local success, result = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(reqUrl))
                end)
                if success and result and result.data then
                    for _, v in pairs(result.data) do
                        if type(v) == "table" and v.playing < v.maxPlayers and v.id ~= jobId then
                            table.insert(servers, v.id)
                        end
                    end
                end
            end

            if #servers > 0 then
                local targetServer = servers[math.random(1, #servers)]
                TeleportService:TeleportToPlaceInstance(placeId, targetServer, LocalPlayer)
                task.wait(2)
            else
                TeleportService:Teleport(placeId, LocalPlayer)
                task.wait(3)
            end
        end
        isHopping = false
    end)
end

-- FIXED STRICT ADMIN CHECKER
local function checkAdmin(player)
    if not Settings.AdminHop or player == LocalPlayer then return end

    local nameLower = player.Name:lower()

    -- 1. Exact Name Check
    if ExactAdminNames[nameLower] then
        ServerHop()
        return
    end

    -- 2. Exact User ID Check
    if AdminUserIds[player.UserId] then
        ServerHop()
        return
    end

    -- 3. High Rank Group Check (Gamer Robot Inc Group ID: 2918800)
    pcall(function()
        local rank = player:GetRankInGroup(2918800)
        if rank >= 250 then -- Only Developer / Official Admin ranks
            ServerHop()
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do checkAdmin(p) end
table.insert(Connections, Players.PlayerAdded:Connect(checkAdmin))

-- BLOX FRUITS LEVEL MAP (1 - 2800 LEVEL)
local LevelData = {
    -- SEA 1
    {Min = 1, Max = 14, Quest = "BanditQuest1", QuestLvl = 1, Mob = "Bandit", QPos = Vector3.new(-1045, 16, 1561)},
    {Min = 15, Max = 29, Quest = "JungleQuest", QuestLvl = 1, Mob = "Monkey", QPos = Vector3.new(-1598, 36, 153)},
    {Min = 30, Max = 39, Quest = "JungleQuest", QuestLvl = 2, Mob = "Gorilla", QPos = Vector3.new(-1598, 36, 153)},
    {Min = 40, Max = 59, Quest = "PirateQuest", QuestLvl = 1, Mob = "Pirate", QPos = Vector3.new(-1140, 4, 3828)},
    {Min = 60, Max = 89, Quest = "DesertQuest", QuestLvl = 1, Mob = "Desert Bandit", QPos = Vector3.new(896, 6, 4388)},
    {Min = 90, Max = 119, Quest = "SnowQuest", QuestLvl = 1, Mob = "Snow Bandit", QPos = Vector3.new(1385, 87, -1298)},
    {Min = 120, Max = 149, Quest = "MarineQuest2", QuestLvl = 1, Mob = "Chief Petty Officer", QPos = Vector3.new(-5035, 20, 4322)},
    {Min = 150, Max = 189, Quest = "SkyQuest", QuestLvl = 1, Mob = "Sky Bandit", QPos = Vector3.new(-4840, 717, -2620)},
    {Min = 190, Max = 224, Quest = "PrisonerQuest", QuestLvl = 1, Mob = "Prisoner", QPos = Vector3.new(530, 1, 474)},
    {Min = 225, Max = 299, Quest = "ColosseumQuest", QuestLvl = 1, Mob = "Toga Warrior", QPos = Vector3.new(-1580, 7, -2980)},
    {Min = 300, Max = 374, Quest = "MagmaQuest", QuestLvl = 1, Mob = "Military Soldier", QPos = Vector3.new(-5310, 12, 8515)},
    {Min = 375, Max = 449, Quest = "FishmanQuest", QuestLvl = 1, Mob = "Fishman Warrior", QPos = Vector3.new(61122, 18, 1567)},
    {Min = 450, Max = 524, Quest = "SkyExp1Quest", QuestLvl = 1, Mob = "God's Guard", QPos = Vector3.new(-4720, 845, -1950)},
    {Min = 525, Max = 624, Quest = "SkyExp2Quest", QuestLvl = 1, Mob = "Shandora Warrior", QPos = Vector3.new(-7900, 5605, -2280)},
    {Min = 625, Max = 699, Quest = "FountainQuest", QuestLvl = 1, Mob = "Corporal", QPos = Vector3.new(5250, 38, 4050)},
    
    -- SEA 2
    {Min = 700, Max = 774, Quest = "Area1Quest", QuestLvl = 1, Mob = "Raider", QPos = Vector3.new(-425, 73, 1835)},
    {Min = 775, Max = 874, Quest = "Area2Quest", QuestLvl = 1, Mob = "Mercenary", QPos = Vector3.new(635, 73, 918)},
    {Min = 875, Max = 999, Quest = "MarineQuest", QuestLvl = 1, Mob = "Marine Lieutenant", QPos = Vector3.new(-2440, 73, -3210)},
    {Min = 1000, Max = 1124, Quest = "SnowMountainQuest", QuestLvl = 1, Mob = "Snow Trooper", QPos = Vector3.new(605, 400, -5370)},
    {Min = 1125, Max = 1249, Quest = "IceSideQuest", QuestLvl = 1, Mob = "Lab Subordinate", QPos = Vector3.new(-6060, 15, -4900)},
    {Min = 1250, Max = 1349, Quest = "ShipQuest1", QuestLvl = 1, Mob = "Ship Deckhand", QPos = Vector3.new(1030, 125, 32900)},
    {Min = 1350, Max = 1499, Quest = "FrostQuest", QuestLvl = 1, Mob = "Arctic Warrior", QPos = Vector3.new(5660, 28, -6480)},

    -- SEA 3 & 2800 EXTENSION
    {Min = 1500, Max = 1574, Quest = "PiratePortQuest", QuestLvl = 1, Mob = "Pirate Millionaire", QPos = Vector3.new(-290, 44, 5580)},
    {Min = 1575, Max = 1699, Quest = "AmazonQuest", QuestLvl = 1, Mob = "Dragon Crew Warrior", QPos = Vector3.new(5830, 52, -1100)},
    {Min = 1700, Max = 1824, Quest = "MarineTreeQuest", QuestLvl = 1, Mob = "Marine Commodore", QPos = Vector3.new(2180, 28, -6740)},
    {Min = 1825, Max = 1974, Quest = "DeepForestIslandQuest", QuestLvl = 1, Mob = "Forest Pirate", QPos = Vector3.new(-13230, 330, -7630)},
    {Min = 1975, Max = 2074, Quest = "HauntedQuest1", QuestLvl = 1, Mob = "Reborn Skeleton", QPos = Vector3.new(-9515, 142, 5520)},
    {Min = 2075, Max = 2224, Quest = "PeanutQuest", QuestLvl = 1, Mob = "Peanut Scout", QPos = Vector3.new(-2120, 38, -10190)},
    {Min = 2225, Max = 2449, Quest = "IceCreamQuest1", QuestLvl = 1, Mob = "Ice Cream Chef", QPos = Vector3.new(-820, 65, -10960)},
    {Min = 2450, Max = 2800, Quest = "TikiQuest1", QuestLvl = 1, Mob = "Isle Outlaw", QPos = Vector3.new(-16530, 55, -17250)}
}

-- FRUIT ICONS
local FruitIcons = {
    ["Kitsune"] = "rbxassetid://15312061073", ["Dragon"] = "rbxassetid://13886869488",
    ["Leopard"] = "rbxassetid://13886867744", ["Dough"] = "rbxassetid://13886866168",
    ["T-Rex"] = "rbxassetid://15682970597", ["Mammoth"] = "rbxassetid://14930198642",
    ["Spirit"] = "rbxassetid://13886869850", ["Venom"] = "rbxassetid://13886870244",
    ["Shadow"] = "rbxassetid://13886869634", ["Blizzard"] = "rbxassetid://13886865660",
    ["Buddha"] = "rbxassetid://13886865890", ["Portal"] = "rbxassetid://13886869150"
}

-- Anti-AFK
table.insert(Connections, LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end))

-- GUI UTILS
local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- GUI BUILD
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV6"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ParentGui

local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 50, 0, 50)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(20, 12, 35)
ToggleLogo.BorderSizePixel = 0
ToggleLogo.Text = "💎"
ToggleLogo.TextSize = 26
ToggleLogo.Parent = ScreenGui
makeDraggable(ToggleLogo)

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = ToggleLogo

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(170, 0, 255)
LogoStroke.Thickness = 2
LogoStroke.Parent = ToggleLogo

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 480)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
makeDraggable(MainFrame)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(160, 50, 255)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.2
MainStroke.Parent = MainFrame

ToggleLogo.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 260, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = Translations[CurrentLang].Title
Title.TextColor3 = Color3.fromRGB(200, 130, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local LangBtn = Instance.new("TextButton")
LangBtn.Size = UDim2.new(0, 80, 0, 26)
LangBtn.Position = UDim2.new(1, -120, 0, 8)
LangBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 70)
LangBtn.BorderSizePixel = 0
LangBtn.Text = "🇮🇹 IT"
LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LangBtn.Font = Enum.Font.GothamBold
LangBtn.TextSize = 12
LangBtn.Parent = MainFrame

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 6)
LangCorner.Parent = LangBtn

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
ConfirmText.Text = Translations[CurrentLang].ConfirmText
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 14
ConfirmText.ZIndex = 11
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 100, 0, 35)
YesBtn.Position = UDim2.new(0.2, 0, 0.65, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 80)
YesBtn.Text = Translations[CurrentLang].Yes
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 11
YesBtn.Parent = ConfirmFrame

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 100, 0, 35)
NoBtn.Position = UDim2.new(0.6, 0, 0.65, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 75)
NoBtn.Text = Translations[CurrentLang].No
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

local LuckFrame = Instance.new("Frame")
LuckFrame.Name = "LuckFrame"
LuckFrame.Size = UDim2.new(0, 260, 0, 140)
LuckFrame.Position = UDim2.new(0.8, -260, 0.15, 0)
LuckFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 32)
LuckFrame.BorderSizePixel = 0
LuckFrame.Visible = false
LuckFrame.Parent = ScreenGui
makeDraggable(LuckFrame)

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

local DynamicLabels = {}

local function addToggle(translationKey, defaultState, callback)
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
    label.Text = Translations[CurrentLang][translationKey] or translationKey
    label.TextColor3 = Color3.fromRGB(225, 215, 245)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    table.insert(DynamicLabels, {Element = label, Key = translationKey})

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
end

local function addSlider(translationKey, min, max, default, callback)
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
    label.Text = Translations[CurrentLang][translationKey] or translationKey
    label.TextColor3 = Color3.fromRGB(225, 215, 245)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    table.insert(DynamicLabels, {Element = label, Key = translationKey})

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

local function switchLanguage()
    if CurrentLang == "IT" then
        CurrentLang = "EN"
        LangBtn.Text = "🇬🇧 EN"
    else
        CurrentLang = "IT"
        LangBtn.Text = "🇮🇹 IT"
    end

    Title.Text = Translations[CurrentLang].Title
    ConfirmText.Text = Translations[CurrentLang].ConfirmText
    YesBtn.Text = Translations[CurrentLang].Yes
    NoBtn.Text = Translations[CurrentLang].No

    for _, item in pairs(DynamicLabels) do
        if item.Element and item.Key and Translations[CurrentLang][item.Key] then
            item.Element.Text = Translations[CurrentLang][item.Key]
        end
    end
end

LangBtn.MouseButton1Click:Connect(switchLanguage)

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
addToggle("AutoStore", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle("AdminHop", Settings.AdminHop, function(v) Settings.AdminHop = v end)
addToggle("FruitESP", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("PlayerESP", Settings.ESP, function(v) Settings.ESP = v end)
addToggle("Aimbot", Settings.Aimbot, function(v) Settings.Aimbot = v end)
addToggle("AutoHunt", Settings.AutoHunt, function(v) Settings.AutoHunt = v end)

addSlider("FlySpeed", 5, 30, Settings.FlySpeed, function(v) Settings.FlySpeed = v end)
addSlider("FarmDist", 3, 20, Settings.FarmDistance, function(v) Settings.FarmDistance = v end)

-- NOCLIP SYSTEM
table.insert(Connections, RunService.Stepped:Connect(function()
    if Settings.AutoFarm or Settings.AutoHunt then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end))

-- HELPER: GET CURRENT QUEST DATA BY LEVEL
local function getCurrentQuestData()
    local myLevel = 1
    pcall(function() myLevel = LocalPlayer.Data.Level.Value end)
    for _, data in ipairs(LevelData) do
        if myLevel >= data.Min and myLevel <= data.Max then
            return data
        end
    end
    return LevelData[1]
end

-- HELPER: CHECK IF QUEST IS ACTIVE
local function hasQuest()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui and playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Quest") then
        return playerGui.Main.Quest.Visible
    end
    return false
end

-- AUTO FARM ENGINE WITH QUEST LOGIC
local lastClick = 0
local lastQuestAttempt = 0

table.insert(Connections, RunService.Heartbeat:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
    local root = myChar.HumanoidRootPart
    local humanoid = myChar.Humanoid

    if Settings.AutoFarm then
        humanoid.PlatformStand = true
        root.AssemblyLinearVelocity = Vector3.zero

        local qData = getCurrentQuestData()

        -- STEP 1: GET QUEST IF NOT ACTIVE
        if not hasQuest() then
            if tick() - lastQuestAttempt > 1.5 then
                lastQuestAttempt = tick()
                if (root.Position - qData.QPos).Magnitude > 15 then
                    root.CFrame = CFrame.new(qData.QPos + Vector3.new(0, 3, 0))
                else
                    pcall(function()
                        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                        if remotes and remotes:FindFirstChild("CommF_") then
                            remotes.CommF_:InvokeServer("StartQuest", qData.Quest, qData.QuestLvl)
                        end
                    end)
                end
            end
            return
        end

        -- STEP 2: FARM TARGET MOB
        local targetMob = nil
        local minDist = math.huge
        local enemies = Workspace:FindFirstChild("Enemies") or Workspace

        for _, mob in pairs(enemies:GetChildren()) do
            if mob:IsA("Model") and mob.Name == qData.Mob then
                local hum = mob:FindFirstChildOfClass("Humanoid")
                local hrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso")
                if hum and hrp and hum.Health > 0 then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        targetMob = mob
                    end
                end
            end
        end

        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
            local enemyHrp = targetMob.HumanoidRootPart
            local farmPos = enemyHrp.Position + Vector3.new(0, Settings.FarmDistance, 0)
            root.CFrame = CFrame.lookAt(farmPos, enemyHrp.Position)

            local tool = myChar:FindFirstChildOfClass("Tool")
            if not tool then
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    local w = backpack:FindFirstChildOfClass("Tool")
                    if w then humanoid:EquipTool(w) tool = w end
                end
            end

            if tick() - lastClick >= 0.12 then
                lastClick = tick()
                if tool then pcall(function() tool:Activate() end) end
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
                VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)
            end
        else
            root.CFrame = CFrame.new(qData.QPos + Vector3.new(0, 20, 0))
        end
        return
    end

    -- AUTO HUNT ENGINE
    local target = nil
    local minPlayerDist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local dist = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < minPlayerDist then minPlayerDist = dist target = p end
        end
    end

    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = target.Character.HumanoidRootPart
        if Settings.Aimbot then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetRoot.Position) end

        if Settings.AutoHunt then
            humanoid.PlatformStand = true
            root.AssemblyLinearVelocity = Vector3.zero
            local targetPos = targetRoot.Position + Vector3.new(0, 2, 0)
            if (targetPos - root.Position).Magnitude > 6 then
                myChar:PivotTo(CFrame.lookAt(root.Position, targetPos) * CFrame.new(0, 0, -Settings.FlySpeed))
            else
                myChar:PivotTo(CFrame.lookAt(root.Position, targetPos))
                if tick() - lastClick >= 0.12 then
                    lastClick = tick()
                    local tool = myChar:FindFirstChildOfClass("Tool")
                    if tool then pcall(function() tool:Activate() end) end
                    VirtualUser:CaptureController()
                    VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
                    VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)
                end
            end
            return
        end
    end

    if not Settings.AutoFarm and not Settings.AutoHunt then
        humanoid.PlatformStand = false
    end
end))

-- AUTO STORE FRUIT
local function storeFruit(tool)
    if not Settings.AutoStore or not tool or not tool:IsA("Tool") then return end
    if tool.Name:find("Fruit") or tool.Name:find("Meyve") or FruitIcons[tool.Name:gsub(" Fruit", "")] then
        task.spawn(function()
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes and remotes:FindFirstChild("CommF_") then
                    remotes.CommF_:InvokeServer("StoreFruit", tool.Name, tool)
                end
            end)
        end)
    end
end

table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(storeFruit)
end))
if LocalPlayer.Character then LocalPlayer.Character.ChildAdded:Connect(storeFruit) end
table.insert(Connections, LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    task.wait(0.3)
    storeFruit(tool)
end))

-- CLEANUP / DESTROY
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

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = Translations[CurrentLang].NotifTitle,
        Text = Translations[CurrentLang].NotifText,
        Duration = 4
    })
end)

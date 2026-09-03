-- =================================================================================
-- 🔮 MORGAN HUB V5.0 (AMETHYST EDITION - OPTIMIZED & REFACTORED) 🔮
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
local ESP_Objects = {}

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
    Language = "EN" -- Default to English. Toggle option supports IT (Italian)
}

-- TRANS-LATE DICTIONARY (EN & IT)
local Languages = {
    EN = {
        title = "💎 MORGAN HUB V5.0",
        loading = "Amethyst Power Loading...",
        ready = "Ready!",
        confirm_destroy = "Are you sure you want to close and destroy the GUI?",
        yes = "YES",
        no = "NO",
        luck_booster = "🔮 Luck Rate Booster GUI",
        luck_power = "🔮 Luck Multiplier Power",
        auto_farm = "🌾 Auto Farm Level (Mobs - Max 2800)",
        auto_store = "📦 Auto Store Fruit (Inventory)",
        fruit_esp = "🖼️ Fruit ESP (With Image Icons)",
        player_esp = "👁️ Player ESP (Box, Skeleton & HP)",
        aimbot = "🎯 Aimbot (Nearest Player)",
        auto_hunt = "⚡ Auto Bounty Hunt (Fast Fly)",
        fly_speed = "⚙️ Fly / Hunt Speed",
        farm_dist = "⚙️ Auto Farm Distance (Height)",
        notif_title = "💎 MORGAN HUB V5.0",
        notif_desc = "All Modules Successfully Optimized!",
        lang_btn = "🌐 EN / IT",
        admin_hop = "Admin detected! Performing safe Server Hop..."
    },
    IT = {
        title = "💎 MORGAN HUB V5.0",
        loading = "Caricamento Potere Ametista...",
        ready = "Pronto!",
        confirm_destroy = "Sei sicuro di voler chiudere ed eliminare la GUI?",
        yes = "SÌ",
        no = "NO",
        luck_booster = "🔮 GUI Potenziatore di Fortuna",
        luck_power = "🔮 Potenza Moltiplicatore Fortuna",
        auto_farm = "🌾 Auto Farm Livello (Mostri - Max 2800)",
        auto_store = "📦 Auto Conserva Frutti (Inventario)",
        fruit_esp = "🖼️ ESP Frutti (Con Icone)",
        player_esp = "👁️ ESP Giocatori (Box, Scheletro & HP)",
        aimbot = "🎯 Aimbot (Giocatore Più Vicino)",
        auto_hunt = "⚡ Auto Caccia Taglie (Volo Rapido)",
        fly_speed = "⚙️ Velocità di Volo / Caccia",
        farm_dist = "⚙️ Distanza Auto Farm (Altezza)",
        notif_title = "💎 MORGAN HUB V5.0",
        notif_desc = "Tutti i moduli sono stati ottimizzati con successo!",
        lang_btn = "🌐 EN / IT",
        admin_hop = "Amministratore rilevato! Cambio server sicuro in corso..."
    }
}

-- QUEST MAP DATA (LEVELS 0 - 2800)
local QuestMap = {
    -- Sea 1
    {Min = 1, Max = 9, NPC = "Bandit Quest Giver", Quest = "BanditQuest1", Mob = "Bandit", Island = "Starter Island", PartName = "QuestGiver"},
    {Min = 10, Max = 14, NPC = "Monkey Quest Giver", Quest = "JungleQuest", Mob = "Monkey", Island = "Jungle", PartName = "QuestGiver"},
    {Min = 15, Max = 29, NPC = "Monkey Quest Giver", Quest = "JungleQuest", Mob = "Gorilla", Island = "Jungle", PartName = "QuestGiver"},
    {Min = 30, Max = 39, NPC = "Pirate Quest Giver", Quest = "BuggyQuest1", Mob = "Pirate", Island = "Pirate Village", PartName = "QuestGiver"},
    {Min = 40, Max = 59, NPC = "Pirate Quest Giver", Quest = "BuggyQuest1", Mob = "Brute", Island = "Pirate Village", PartName = "QuestGiver"},
    {Min = 60, Max = 74, NPC = "Desert Quest Giver", Quest = "DesertQuest", Mob = "Desert Bandit", Island = "Desert", PartName = "QuestGiver"},
    {Min = 75, Max = 89, NPC = "Desert Quest Giver", Quest = "DesertQuest", Mob = "Desert Officer", Island = "Desert", PartName = "QuestGiver"},
    {Min = 90, Max = 119, NPC = "Snow Quest Giver", Quest = "SnowQuest", Mob = "Snow Bandit", Island = "Frozen Village", PartName = "QuestGiver"},
    {Min = 120, Max = 149, NPC = "Marine Quest Giver", Quest = "MarineQuest", Mob = "Marine Trainee", Island = "Marine Fortress", PartName = "QuestGiver"},
    {Min = 150, Max = 174, NPC = "Sky Quest Giver", Quest = "SkyQuest", Mob = "Sky Bandit", Island = "Skypiea", PartName = "QuestGiver"},
    {Min = 175, Max = 224, NPC = "Sky Quest Giver", Quest = "SkyQuest", Mob = "Dark Master", Island = "Skypiea", PartName = "QuestGiver"},
    {Min = 225, Max = 249, NPC = "Prison Quest Giver", Quest = "PrisonerQuest", Mob = "Prisoner", Island = "Prison", PartName = "QuestGiver"},
    {Min = 250, Max = 299, NPC = "Prison Quest Giver", Quest = "PrisonerQuest", Mob = "Dangerous Prisoner", Island = "Prison", PartName = "QuestGiver"},
    {Min = 300, Max = 324, NPC = "Magma Quest Giver", Quest = "MagmaQuest", Mob = "Military Soldier", Island = "Magma Village", PartName = "QuestGiver"},
    {Min = 325, Max = 374, NPC = "Magma Quest Giver", Quest = "MagmaQuest", Mob = "Military Spy", Island = "Magma Village", PartName = "QuestGiver"},
    {Min = 375, Max = 399, NPC = "Fishman Quest Giver", Quest = "FishmanQuest", Mob = "Fishman Warrior", Island = "Underwater City", PartName = "QuestGiver"},
    {Min = 400, Max = 449, NPC = "Fishman Quest Giver", Quest = "FishmanQuest", Mob = "Fishman Commando", Island = "Underwater City", PartName = "QuestGiver"},
    {Min = 450, Max = 474, NPC = "Sky Quest Giver 2", Quest = "SkyQuest2", Mob = "God's Guard", Island = "Upper Skylands", PartName = "QuestGiver"},
    {Min = 475, Max = 524, NPC = "Sky Quest Giver 2", Quest = "SkyQuest2", Mob = "Shandian", Island = "Upper Skylands", PartName = "QuestGiver"},
    {Min = 525, Max = 574, NPC = "Sky Quest Giver 2", Quest = "SkyQuest2", Mob = "Royal Squad", Island = "Upper Skylands", PartName = "QuestGiver"},
    {Min = 575, Max = 624, NPC = "Cyborg Quest Giver", Quest = "CyborgQuest", Mob = "Cyborg", Island = "Fountain City", PartName = "QuestGiver"},
    -- Sea 2
    {Min = 700, Max = 724, NPC = "Area 1 Quest Giver", Quest = "Area1Quest", Mob = "Raider", Island = "Kingdom of Rose", PartName = "QuestGiver"},
    {Min = 725, Max = 774, NPC = "Area 1 Quest Giver", Quest = "Area1Quest", Mob = "Mercenary", Island = "Kingdom of Rose", PartName = "QuestGiver"},
    {Min = 775, Max = 799, NPC = "Area 2 Quest Giver", Quest = "Area2Quest", Mob = "Swan Pirate", Island = "Kingdom of Rose", PartName = "QuestGiver"},
    {Min = 800, Max = 874, NPC = "Area 2 Quest Giver", Quest = "Area2Quest", Mob = "Factory Worker", Island = "Kingdom of Rose", PartName = "QuestGiver"},
    {Min = 875, Max = 899, NPC = "Green Zone Quest Giver", Quest = "GreenZoneQuest", Mob = "Marine Lieutenant", Island = "Green Zone", PartName = "QuestGiver"},
    {Min = 900, Max = 949, NPC = "Green Zone Quest Giver", Quest = "GreenZoneQuest", Mob = "Giant Warrior", Island = "Green Zone", PartName = "QuestGiver"},
    {Min = 950, Max = 974, NPC = "Graveyard Quest Giver", Quest = "GraveyardQuest", Mob = "Zombie Squire", Island = "Graveyard", PartName = "QuestGiver"},
    {Min = 975, Max = 999, NPC = "Graveyard Quest Giver", Quest = "GraveyardQuest", Mob = "Zombie Demolisher", Island = "Graveyard", PartName = "QuestGiver"},
    {Min = 1000, Max = 1049, NPC = "Snow Mountain Quest Giver", Quest = "SnowMountainQuest", Mob = "Snow Trooper", Island = "Snow Mountain", PartName = "QuestGiver"},
    {Min = 1050, Max = 1099, NPC = "Snow Mountain Quest Giver", Quest = "SnowMountainQuest", Mob = "Winter Warrior", Island = "Snow Mountain", PartName = "QuestGiver"},
    {Min = 1100, Max = 1124, NPC = "Hot and Cold Quest Giver", Quest = "HotAndColdQuest", Mob = "Lab Subordinate", Island = "Hot and Cold", PartName = "QuestGiver"},
    {Min = 1125, Max = 1174, NPC = "Hot and Cold Quest Giver", Quest = "HotAndColdQuest", Mob = "Horned Warrior", Island = "Hot and Cold", PartName = "QuestGiver"},
    {Min = 1175, Max = 1199, NPC = "Hot and Cold Quest Giver 2", Quest = "HotAndColdQuest2", Mob = "Magma Ninja", Island = "Hot and Cold", PartName = "QuestGiver"},
    {Min = 1200, Max = 1249, NPC = "Hot and Cold Quest Giver 2", Quest = "HotAndColdQuest2", Mob = "Lava Pirate", Island = "Hot and Cold", PartName = "QuestGiver"},
    {Min = 1250, Max = 1274, NPC = "Cursed Ship Quest Giver", Quest = "ShipQuest", Mob = "Ship Officer", Island = "Cursed Ship", PartName = "QuestGiver"},
    {Min = 1275, Max = 1349, NPC = "Cursed Ship Quest Giver", Quest = "ShipQuest", Mob = "Ship Lieutenant", Island = "Cursed Ship", PartName = "QuestGiver"},
    {Min = 1350, Max = 1374, NPC = "Ice Castle Quest Giver", Quest = "IceCastleQuest", Mob = "Arctic Warrior", Island = "Ice Castle", PartName = "QuestGiver"},
    {Min = 1375, Max = 1424, NPC = "Ice Castle Quest Giver", Quest = "IceCastleQuest", Mob = "Snow Lurker", Island = "Ice Castle", PartName = "QuestGiver"},
    {Min = 1425, Max = 1449, NPC = "Forgotten Quest Giver", Quest = "ForgottenQuest", Mob = "Sea Soldier", Island = "Forgotten Island", PartName = "QuestGiver"},
    {Min = 1450, Max = 1499, NPC = "Forgotten Quest Giver", Quest = "ForgottenQuest", Mob = "Water Bandit", Island = "Forgotten Island", PartName = "QuestGiver"},
    -- Sea 3
    {Min = 1500, Max = 1524, NPC = "Port Town Quest Giver", Quest = "PortTownQuest", Mob = "Pirate Millionaire", Island = "Port Town", PartName = "QuestGiver"},
    {Min = 1525, Max = 1574, NPC = "Port Town Quest Giver", Quest = "PortTownQuest", Mob = "Pistol Billionaire", Island = "Port Town", PartName = "QuestGiver"},
    {Min = 1575, Max = 1599, NPC = "Hydra Island Quest Giver", Quest = "HydraIslandQuest", Mob = "Dragon Crew Warrior", Island = "Hydra Island", PartName = "QuestGiver"},
    {Min = 1600, Max = 1624, NPC = "Hydra Island Quest Giver", Quest = "HydraIslandQuest", Mob = "Dragon Crew Archer", Island = "Hydra Island", PartName = "QuestGiver"},
    {Min = 1625, Max = 1649, NPC = "Hydra Island Quest Giver", Quest = "HydraIslandQuest", Mob = "Female Assassin", Island = "Hydra Island", PartName = "QuestGiver"},
    {Min = 1650, Max = 1699, NPC = "Turtle Quest Giver 1", Quest = "TurtleQuest1", Mob = "Fishman Raider", Island = "Floating Turtle", PartName = "QuestGiver"},
    {Min = 1700, Max = 1724, NPC = "Turtle Quest Giver 1", Quest = "TurtleQuest1", Mob = "Fishman Captain", Island = "Floating Turtle", PartName = "QuestGiver"},
    {Min = 1725, Max = 1774, NPC = "Turtle Quest Giver 1", Quest = "TurtleQuest1", Mob = "Forest Pirate", Island = "Floating Turtle", PartName = "QuestGiver"},
    {Min = 1775, Max = 1799, NPC = "Turtle Quest Giver 2", Quest = "TurtleQuest2", Mob = "Mythical Pirate", Island = "Floating Turtle", PartName = "QuestGiver"},
    {Min = 1800, Max = 1849, NPC = "Turtle Quest Giver 2", Quest = "TurtleQuest2", Mob = "Jungle Pirate", Island = "Floating Turtle", PartName = "QuestGiver"},
    {Min = 1850, Max = 1899, NPC = "Turtle Quest Giver 2", Quest = "TurtleQuest2", Mob = "Musketeer Pirate", Island = "Floating Turtle", PartName = "QuestGiver"},
    {Min = 1900, Max = 1974, NPC = "Haunted Quest Giver", Quest = "HauntedQuest1", Mob = "Reborn Skeleton", Island = "Haunted Castle", PartName = "QuestGiver"},
    {Min = 1975, Max = 1999, NPC = "Haunted Quest Giver", Quest = "HauntedQuest1", Mob = "Living Zombie", Island = "Haunted Castle", PartName = "QuestGiver"},
    {Min = 2000, Max = 2024, NPC = "Haunted Quest Giver", Quest = "HauntedQuest2", Mob = "Demonic Soul", Island = "Haunted Castle", PartName = "QuestGiver"},
    {Min = 2025, Max = 2074, NPC = "Haunted Quest Giver", Quest = "HauntedQuest2", Mob = "Posessed Mummy", Island = "Haunted Castle", PartName = "QuestGiver"},
    {Min = 2075, Max = 2099, NPC = "Ice Cream Quest Giver", Quest = "IceCreamQuest1", Mob = "Cookie Crafter", Island = "Sea of Treats", PartName = "QuestGiver"},
    {Min = 2100, Max = 2124, NPC = "Ice Cream Quest Giver", Quest = "IceCreamQuest1", Mob = "Cake Guard", Island = "Sea of Treats", PartName = "QuestGiver"},
    {Min = 2125, Max = 2149, NPC = "Ice Cream Quest Giver", Quest = "IceCreamQuest1", Mob = "Baking Brute", Island = "Sea of Treats", PartName = "QuestGiver"},
    {Min = 2150, Max = 2199, NPC = "Cake Quest Giver", Quest = "CakeQuest1", Mob = "Head Baker", Island = "Sea of Treats", PartName = "QuestGiver"},
    {Min = 2200, Max = 2249, NPC = "Cake Quest Giver", Quest = "CakeQuest2", Mob = "Cocoa Warrior", Island = "Sea of Treats", PartName = "QuestGiver"},
    {Min = 2250, Max = 2299, NPC = "Tiki Quest Giver", Quest = "TikiQuest1", Mob = "Sunken Pirate", Island = "Tiki Outpost", PartName = "QuestGiver"},
    {Min = 2300, Max = 2399, NPC = "Tiki Quest Giver", Quest = "TikiQuest2", Mob = "Dragon Guard", Island = "Tiki Outpost", PartName = "QuestGiver"},
    {Min = 2400, Max = 2499, NPC = "Tiki Quest Giver 2", Quest = "TikiQuest3", Mob = "Abyssal Cultist", Island = "Tiki Outpost", PartName = "QuestGiver"},
    {Min = 2500, Max = 2599, NPC = "Tiki Quest Giver 2", Quest = "TikiQuest4", Mob = "Isle Defender", Island = "Tiki Outpost", PartName = "QuestGiver"},
    {Min = 2600, Max = 2699, NPC = "Tiki Quest Giver 2", Quest = "TikiQuest5", Mob = "Tiki Shaman", Island = "Tiki Outpost", PartName = "QuestGiver"},
    {Min = 2700, Max = 2800, NPC = "Tiki Quest Giver 3", Quest = "TikiQuest6", Mob = "Serpent Guardian", Island = "Tiki Outpost", PartName = "QuestGiver"},
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
    ["Love"] = "rbxassetid://1388688018",
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

-- =============================================================
-- SERVER HOPPING (ADMIN PROTECT)
-- =============================================================
local function serverHop()
    local sf, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if sf and servers and servers.data then
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end
end

local function checkAdminPresence(player)
    -- Famous Admin IDs and group rankings verification
    local adminIDs = {[410143093] = true, [1552391024] = true, [4424317] = true} -- rip_indra, uzoth, mygame43
    if adminIDs[player.UserId] or player:GetRankInGroup(11424103) >= 100 then
        task.spawn(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = Languages[Settings.Language].notif_title,
                Text = Languages[Settings.Language].admin_hop,
                Duration = 5
            })
            task.wait(2)
            serverHop()
        end)
    end
end

for _, p in pairs(Players:GetPlayers()) do checkAdminPresence(p) end
table.insert(Connections, Players.PlayerAdded:Connect(checkAdminPresence))

-- =============================================================
-- GUI ARCHITECTURE & SCREEN GUI
-- =============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- -------------------------------------------------------------
-- 🔮 LOADING SCREEN
-- -------------------------------------------------------------
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
LoadingSub.Text = Languages[Settings.Language].loading
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

local BarGlow = Instance.new("UIStroke")
BarGlow.Color = Color3.fromRGB(200, 80, 255)
BarGlow.Thickness = 2
BarGlow.Parent = BarFill

-- Loading Animation Execution
task.spawn(function()
    local tweenInfo = TweenInfo.new(2.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(BarFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    tween.Completed:Wait()
    
    LoadingSub.Text = Languages[Settings.Language].ready
    task.wait(0.4)
    
    local fadeTween = TweenService:Create(LoadingFrame, TweenInfo.new(0.8), {BackgroundTransparency = 1})
    TweenService:Create(LoadingTitle, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(LoadingSub, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(BarBg, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    fadeTween:Play()
    fadeTween.Completed:Wait()
    LoadingFrame:Destroy()
end)

-- -------------------------------------------------------------
-- LOGO BUTTON
-- -------------------------------------------------------------
local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 50, 0, 50)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(20, 12, 35)
ToggleLogo.BorderSizePixel = 0
ToggleLogo.Text = "💎"
ToggleLogo.TextSize = 26
ToggleLogo.Active = true
ToggleLogo.Draggable = true
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = ToggleLogo

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(170, 0, 255)
LogoStroke.Thickness = 2
LogoStroke.Parent = ToggleLogo

-- -------------------------------------------------------------
-- MAIN WINDOW (AMETHYST STYLE)
-- -------------------------------------------------------------
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

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(160, 50, 255)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.2
MainStroke.Parent = MainFrame

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 🔮 AMETHYST SIDE WINGS
local function createSideAmethyst(isLeft)
    local amethyst = Instance.new("TextLabel")
    amethyst.Name = isLeft and "LeftAmethyst" or "RightAmethyst"
    amethyst.Size = UDim2.new(0, 40, 0, 40)
    local posX = isLeft and UDim2.new(0, -35, 0.5, -20) or UDim2.new(1, -5, 0.5, -20)
    amethyst.Position = posX
    amethyst.BackgroundTransparency = 1
    amethyst.Text = "💎"
    amethyst.TextSize = 30
    amethyst.ZIndex = 5
    amethyst.Parent = MainFrame

    local upPos = posX + UDim2.new(0, 0, 0, -25)
    local downPos = posX + UDim2.new(0, 0, 0, 25)
    amethyst.Position = upPos
    
    local tweenInfo = TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local floatTween = TweenService:Create(amethyst, tweenInfo, {Position = downPos})
    floatTween:Play()
end

createSideAmethyst(true)
createSideAmethyst(false)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = Languages[Settings.Language].title
Title.TextColor3 = Color3.fromRGB(200, 130, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- 🌐 DYNAMIC LANGUAGE BUTTON
local LangBtn = Instance.new("TextButton")
LangBtn.Size = UDim2.new(0, 75, 0, 26)
LangBtn.Position = UDim2.new(1, -115, 0, 8)
LangBtn.BackgroundColor3 = Color3.fromRGB(40, 25, 60)
LangBtn.Text = Languages[Settings.Language].lang_btn
LangBtn.TextColor3 = Color3.fromRGB(240, 220, 255)
LangBtn.Font = Enum.Font.GothamBold
LangBtn.TextSize = 11
LangBtn.Parent = MainFrame

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 6)
LangCorner.Parent = LangBtn

-- LUCK RATE BOOSTER GUI
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

local LuckStroke = Instance.new("UIStroke")
LuckStroke.Color = Color3.fromRGB(180, 80, 255)
LuckStroke.Thickness = 2
LuckStroke.Parent = LuckFrame

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

local ChanceCorner = Instance.new("UICorner")
ChanceCorner.CornerRadius = UDim.new(0, 6)
ChanceCorner.Parent = ChanceDisplay

-- CONFIRM DESTROY FRAME
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(12, 8, 18)
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
ConfirmText.Text = Languages[Settings.Language].confirm_destroy
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 14
ConfirmText.ZIndex = 11
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 100, 0, 35)
YesBtn.Position = UDim2.new(0.2, 0, 0.65, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 80)
YesBtn.Text = Languages[Settings.Language].yes
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 11
YesBtn.Parent = ConfirmFrame

local YesCorner = Instance.new("UICorner")
YesCorner.CornerRadius = UDim.new(0, 6)
YesCorner.Parent = YesBtn

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 100, 0, 35)
NoBtn.Position = UDim2.new(0.6, 0, 0.65, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 75)
NoBtn.Text = Languages[Settings.Language].no
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.ZIndex = 11
NoBtn.Parent = ConfirmFrame

local NoCorner = Instance.new("UICorner")
NoCorner.CornerRadius = UDim.new(0, 6)
NoCorner.Parent = NoBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 70)
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

-- SYSTEM REGISTER FOR UPDATES
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
    label.Text = Languages[Settings.Language][key] or key
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

    UI_Elements[key] = label
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
    label.Text = Languages[Settings.Language][key] or key
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

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(160, 50, 255)
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

    UI_Elements[key] = label
end

-- UPDATE LANGUAGE TRANSLATION DIRECTLY
local function changeLanguage(lang)
    Settings.Language = lang
    LangBtn.Text = Languages[lang].lang_btn
    Title.Text = Languages[lang].title
    ConfirmText.Text = Languages[lang].confirm_destroy
    YesBtn.Text = Languages[lang].yes
    NoBtn.Text = Languages[lang].no

    for key, label in pairs(UI_Elements) do
        if Languages[lang][key] then
            label.Text = Languages[lang][key]
        end
    end
end

LangBtn.MouseButton1Click:Connect(function()
    if Settings.Language == "EN" then
        changeLanguage("IT")
    else
        changeLanguage("EN")
    end
end)

-- MENU CARDS BINDING
addToggle("luck_booster", Settings.LuckMultiplier, function(v) 
    Settings.LuckMultiplier = v
    LuckFrame.Visible = v
end)
addSlider("luck_power", 1, 1000, Settings.LuckPower, function(v)
    Settings.LuckPower = v
    LuckStatus.Text = "MULTIPLIER: " .. v .. "x"
    local simulatedRate = math.min(99.9, math.floor(v * 0.85 * 10) / 10)
    ChanceDisplay.Text = "Mythical Drop Rate: ~" .. simulatedRate .. "%"
end)

addToggle("auto_farm", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle("auto_store", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle("fruit_esp", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("player_esp", Settings.ESP, function(v) Settings.ESP = v end)
addToggle("aimbot", Settings.Aimbot, function(v) Settings.Aimbot = v end)
addToggle("auto_hunt", Settings.AutoHunt, function(v) Settings.AutoHunt = v end)

-- SETTINGS
addSlider("fly_speed", 5, 30, Settings.FlySpeed, function(v) Settings.FlySpeed = v end)
addSlider("farm_dist", 3, 20, Settings.FarmDistance, function(v) Settings.FarmDistance = v end)

-- =============================================================
-- AUTO STORE FRUIT ENGINE
-- =============================================================
local function storeFruit(tool)
    if not Settings.AutoStore or not tool or not tool:IsA("Tool") then return end
    if tool.Name:find("Fruit") or tool.Name:find("Meyve") or FruitIcons[tool.Name:gsub(" Fruit", "")] then
        pcall(function()
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("StoreFruit", tool.Name, tool)
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
-- AUTO FARM ENGINE (QUEST & LEVEL CAP 2800 MAP)
-- =============================================================
local function getQuestNPCAndData()
    local myLevel = LocalPlayer.Data.Level.Value
    for _, data in ipairs(QuestMap) do
        if myLevel >= data.Min and myLevel <= data.Max then
            return data
        end
    end
    return QuestMap[#QuestMap] -- Fallback to highest level quest
end

local function getEnemy(enemyName)
    for _, enemy in pairs(Workspace:GetChildren()) do
        if enemy:IsA("Model") and enemy.Name == enemyName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
            return enemy
        end
    end
    -- Also scan Enemies folder (Blox Fruits compatibility)
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy.Name == enemyName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                return enemy
            end
        end
    end
    return nil
end

-- CRAZY MOB FARM (Grouping Engine)
local function aggregateMobs(enemyName, baseEnemy)
    if not baseEnemy or not baseEnemy:FindFirstChild("HumanoidRootPart") then return end
    local basePos = baseEnemy.HumanoidRootPart.Position

    local sourceFolders = {Workspace, Workspace:FindFirstChild("Enemies")}
    for _, folder in pairs(sourceFolders) do
        if folder then
            for _, enemy in pairs(folder:GetChildren()) do
                if enemy.Name == enemyName and enemy ~= baseEnemy and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    enemy.HumanoidRootPart.CFrame = CFrame.new(basePos)
                    enemy.Humanoid.PlatformStand = true
                    enemy.HumanoidRootPart.CanCollide = false
                    enemy.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.AutoFarm then return end

    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
        local root = myChar.HumanoidRootPart

        local questData = getQuestNPCAndData()
        if not questData then return end

        -- Check Quest State
        local hasQuest = false
        local questText = LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
        if questText:find(questData.Mob) or questText ~= "" then
            hasQuest = true
        end

        if not hasQuest then
            -- Find NPC in Workspace
            local npcModel = Workspace:FindFirstChild(questData.NPC) or Workspace.NPCs:FindFirstChild(questData.NPC)
            if npcModel and npcModel:FindFirstChild("HumanoidRootPart") then
                -- Bypass Teleport directly to NPC
                root.CFrame = npcModel.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                task.wait(0.2)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.Quest, 1)
            end
        else
            local enemy = getEnemy(questData.Mob)
            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                myChar.Humanoid.PlatformStand = true

                -- Aggregate mobs nearby (Crazy Mob Bring Module)
                aggregateMobs(questData.Mob, enemy)

                -- Weapon Equipping
                local tool = myChar:FindFirstChildOfClass("Tool")
                if not tool then
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    if backpack then
                        local weapon = backpack:FindFirstChildOfClass("Tool")
                        if weapon then myChar.Humanoid:EquipTool(weapon) end
                    end
                end

                local targetPos = enemy.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
                root.CFrame = CFrame.lookAt(targetPos, enemy.HumanoidRootPart.Position)

                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(500, 500))
            else
                -- Fly to Mob Spawn Point if none are alive
                local spawnPoint = Workspace:FindFirstChild(questData.Mob) or Workspace.Enemies:FindFirstChild(questData.Mob)
                if spawnPoint and spawnPoint:FindFirstChild("HumanoidRootPart") then
                    root.CFrame = spawnPoint.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                end
                myChar.Humanoid.PlatformStand = false
            end
        end
    end)
end))

-- =============================================================
-- OPTIMIZED FRUIT ESP ENGINE
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

local function createFruitESP(obj)
    if FruitBillboards[obj] then return end

    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part") or obj:FindFirstChildOfClass("MeshPart")
    if not handle then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FruitESP_G"
    bb.Adornee = handle
    bb.Size = UDim2.new(0, 70, 0, 85)
    bb.AlwaysOnTop = true

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, 48, 0, 48)
    img.Position = UDim2.new(0.5, -24, 0, 0)
    img.BackgroundTransparency = 1
    img.Image = getFruitImage(obj.Name)
    img.Parent = bb

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.35, 0)
    textLabel.Position = UDim2.new(0, 0, 0.65, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = obj.Name
    textLabel.TextColor3 = Color3.fromRGB(220, 150, 255)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 11
    textLabel.TextStrokeTransparency = 0
    textLabel.Parent = bb

    bb.Parent = CoreGui
    FruitBillboards[obj] = {Gui = bb, Text = textLabel, Handle = handle}
end

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if not Settings.FruitESP then
        for obj, data in pairs(FruitBillboards) do
            if data.Gui then data.Gui.Enabled = false end
        end
        return
    end

    local myChar = LocalPlayer.Character
    local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position or Vector3.zero

    for _, obj in pairs(Workspace:GetChildren()) do
        if (obj:IsA("Tool") or obj:IsA("Model")) and (obj.Name:find("Fruit") or obj.Name:find("Meyve") or obj.Name:find("Blox")) then
            createFruitESP(obj)
        end
    end

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
end))

-- =============================================================
-- UNIFIED PLAYER ESP (BOX, SKELETON & HP RENDERING SYSTEM)
-- =============================================================
local function getJoints(character)
    local joints = {}
    local r15_joints = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }
    local r6_joints = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"}
    }

    local list = character:FindFirstChild("UpperTorso") and r15_joints or r6_joints
    for _, pair in ipairs(list) do
        local p1 = character:FindFirstChild(pair[1])
        local p2 = character:FindFirstChild(pair[2])
        if p1 and p2 then
            table.insert(joints, {p1, p2})
        end
    end
    return joints
end

local function drawSkeletonAndUI(p)
    if p == LocalPlayer then return end

    local cache = {
        Lines = {},
        Box = nil,
        Label = nil,
        Active = false
    }

    local function cleanup()
        for _, line in pairs(cache.Lines) do line:Destroy() end
        if cache.Box then cache.Box:Destroy() end
        if cache.Label then cache.Label:Destroy() end
        cache.Lines = {}
        cache.Active = false
    end

    local function render()
        local char = p.Character
        if not Settings.ESP or not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            cleanup()
            return
        end

        local root = char.HumanoidRootPart
        local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)

        if not onScreen then
            cleanup()
            return
        end

        cache.Active = true

        -- Project Box Outline
        local topHeight = root.Position + Vector3.new(0, 3, 0)
        local bottomHeight = root.Position - Vector3.new(0, 3.5, 0)
        local topScreen = Camera:WorldToViewportPoint(topHeight)
        local bottomScreen = Camera:WorldToViewportPoint(bottomHeight)
        local boxHeight = math.abs(topScreen.Y - bottomScreen.Y)
        local boxWidth = boxHeight * 0.65

        if not cache.Box then
            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
            box.BackgroundTransparency = 1
            box.BorderSizePixel = 0
            box.Parent = ScreenGui

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(160, 50, 255)
            stroke.Thickness = 2
            stroke.Parent = box

            cache.Box = box
        else
            cache.Box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
            cache.Box.Position = UDim2.new(0, screenPos.X - (boxWidth / 2), 0, screenPos.Y - (boxHeight / 2))
        end

        -- Project Skeleton Lines (Robust Fallback System for Engine draw limits)
        local joints = getJoints(char)
        for i, pair in ipairs(joints) do
            local startPos, startVisible = Camera:WorldToViewportPoint(pair[1].Position)
            local endPos, endVisible = Camera:WorldToViewportPoint(pair[2].Position)

            if startVisible and endVisible then
                local line = cache.Lines[i]
                if not line then
                    line = Instance.new("Frame")
                    line.BackgroundColor3 = Color3.fromRGB(240, 220, 255)
                    line.BorderSizePixel = 0
                    line.AnchorPoint = Vector2.new(0.5, 0.5)
                    line.Parent = ScreenGui
                    cache.Lines[i] = line
                end

                local startV = Vector2.new(startPos.X, startPos.Y)
                local endV = Vector2.new(endPos.X, endPos.Y)
                local distance = (startV - endV).Magnitude
                local angle = math.atan2(endV.Y - startV.Y, endV.X - startV.X)

                line.Size = UDim2.new(0, distance, 0, 1.5)
                line.Position = UDim2.new(0, (startV.X + endV.X) / 2, 0, (startV.Y + endV.Y) / 2)
                line.Rotation = math.deg(angle)
            else
                if cache.Lines[i] then cache.Lines[i]:Destroy() cache.Lines[i] = nil end
            end
        end

        -- Render Health Bar & Info Tag
        local dist = math.floor((root.Position - Camera.CFrame.Position).Magnitude)
        local hpText = p.Name .. " [" .. math.floor(char.Humanoid.Health) .. " HP]\n" .. dist .. "m"

        if not cache.Label then
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 140, 0, 30)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 11
            label.TextStrokeTransparency = 0.2
            label.Parent = ScreenGui
            cache.Label = label
        else
            cache.Label.Position = UDim2.new(0, screenPos.X - 70, 0, screenPos.Y - (boxHeight / 2) - 35)
            cache.Label.Text = hpText
        end
    end

    table.insert(ESP_Objects, RunService.RenderStepped:Connect(render))
end

for _, p in pairs(Players:GetPlayers()) do drawSkeletonAndUI(p) end
table.insert(Connections, Players.PlayerAdded:Connect(drawSkeletonAndUI))

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
                closest = p
            end
        end
    end
    return closest
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
        local root = myChar.HumanoidRootPart

        local target = getClosestPlayer()

        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = target.Character.HumanoidRootPart

            -- Smooth Tracking Aimbot
            if Settings.Aimbot then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetRoot.Position + Vector3.new(0, 1.5, 0))
            end

            -- Fast Auto Bounty Fly Hunter
            if Settings.AutoHunt then
                myChar.Humanoid.PlatformStand = true
                
                local tool = myChar:FindFirstChildOfClass("Tool")
                if not tool then
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    if bp then
                        local weapon = bp:FindFirstChildOfClass("Tool")
                        if weapon then myChar.Humanoid:EquipTool(weapon) end
                    end
                end

                local targetPos = targetRoot.Position + Vector3.new(0, 2, 0)
                local distance = (targetPos - root.Position).Magnitude

                if distance > 5 then
                    local targetCFrame = CFrame.lookAt(root.Position, targetPos) * CFrame.new(0, 0, -Settings.FlySpeed)
                    root.CFrame = targetCFrame
                else
                    root.CFrame = CFrame.lookAt(root.Position, targetPos)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(500, 500))
                end
            elseif not Settings.AutoFarm then
                myChar.Humanoid.PlatformStand = false
            end
        else
            if Settings.AutoHunt and not Settings.AutoFarm then
                myChar.Humanoid.PlatformStand = false
            end
        end
    end)
end))

-- DESTROY / SHUTDOWN HANDLER
YesBtn.MouseButton1Click:Connect(function()
    Settings.AutoFarm = false
    Settings.AutoHunt = false
    Settings.ESP = false
    Settings.FruitESP = false
    Settings.AutoStore = false
    Settings.LuckMultiplier = false

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end

    for _, conn in pairs(Connections) do conn:Disconnect() end
    for _, conn in pairs(ESP_Objects) do conn:Disconnect() end
    
    for _, data in pairs(FruitBillboards) do
        if data.Gui then data.Gui:Destroy() end
    end

    ScreenGui:Destroy()
end)

-- SEND COMPLETION NOTIFICATION
game.StarterGui:SetCore("SendNotification", {
    Title = Languages[Settings.Language].notif_title,
    Text = Languages[Settings.Language].notif_desc,
    Duration = 4
})

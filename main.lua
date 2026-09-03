-- =================================================================================
-- 🔮 MORGAN HUB V5.0 (AMETHYST EDITION - OPTIMIZED & REFACTORED) 🔮
-- =================================================================================

if not game:IsLoaded() then 
    pcall(function()
        game.Loaded:Wait()
    end) 
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
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.LocalPlayer

-- Wait for critical components to prevent runtime crashes (Safe for Emulators)
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 15)
local Data = LocalPlayer:WaitForChild("Data", 15)
local Level = Data and Data:WaitForChild("Level", 15)

local Connections = {}
local PlayerESPCache = {}

-- Safe GUI Parent Detection (Prevents empty GUI glitches on BlueStacks/Mobile executors)
local function getGuiParent()
    local success, result = pcall(function()
        local test = Instance.new("Folder")
        test.Parent = CoreGui
        test:Destroy()
        return CoreGui
    end)
    if success and result then
        return CoreGui
    end
    return PlayerGui
end

local ParentGui = getGuiParent()

-- Clear Previous GUI instances
if ParentGui:FindFirstChild("MorganHubV5") then ParentGui.MorganHubV5:Destroy() end

-- Anti-AFK
table.insert(Connections, LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end))

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
    Language = "EN"
}

-- BILINGUAL SYSTEM DICTIONARY
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
        player_esp = "👁️ Player ESP (Box, Glow & HP Bar)",
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
        player_esp = "👁️ ESP Giocatori (Box, Bagliore e Barra HP)",
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

-- COMPREHENSIVE QUEST DATA (REAL DATABASE NAMES - LEVELS 1 TO 2800)
local QuestMap = {
    -- Sea 1
    {Min = 1, Max = 9, NPC = "Bandit Quest Giver", Quest = "BanditQuest1", Index = 1, Mob = "Bandit"},
    {Min = 10, Max = 14, NPC = "Adventurer", Quest = "JungleQuest", Index = 1, Mob = "Monkey"},
    {Min = 15, Max = 29, NPC = "Adventurer", Quest = "JungleQuest", Index = 2, Mob = "Gorilla"},
    {Min = 30, Max = 39, NPC = "Pirate Adventurer", Quest = "BuggyQuest1", Index = 1, Mob = "Pirate"},
    {Min = 40, Max = 59, NPC = "Pirate Adventurer", Quest = "BuggyQuest1", Index = 2, Mob = "Brute"},
    {Min = 60, Max = 74, NPC = "Desert Adventurer", Quest = "DesertQuest", Index = 1, Mob = "Desert Bandit"},
    {Min = 75, Max = 89, NPC = "Desert Adventurer", Quest = "DesertQuest", Index = 2, Mob = "Desert Officer"},
    {Min = 90, Max = 99, NPC = "Villager", Quest = "SnowQuest", Index = 1, Mob = "Snow Bandit"},
    {Min = 100, Max = 119, NPC = "Villager", Quest = "SnowQuest", Index = 2, Mob = "Snowman"},
    {Min = 120, Max = 149, NPC = "Marine Officer", Quest = "MarineQuest", Index = 1, Mob = "Trainee"},
    {Min = 150, Max = 174, NPC = "Sky Adventurer", Quest = "SkyQuest", Index = 1, Mob = "Sky Bandit"},
    {Min = 175, Max = 224, NPC = "Sky Adventurer", Quest = "SkyQuest", Index = 2, Mob = "Dark Master"},
    {Min = 225, Max = 249, NPC = "Jail Keeper", Quest = "PrisonerQuest", Index = 1, Mob = "Prisoner"},
    {Min = 250, Max = 299, NPC = "Jail Keeper", Quest = "PrisonerQuest", Index = 2, Mob = "Dangerous Prisoner"},
    {Min = 300, Max = 324, NPC = "Quest Giver", Quest = "MagmaQuest", Index = 1, Mob = "Military Soldier"},
    {Min = 325, Max = 374, NPC = "Quest Giver", Quest = "MagmaQuest", Index = 2, Mob = "Military Spy"},
    {Min = 375, Max = 399, NPC = "Fishman Adventurer", Quest = "FishmanQuest", Index = 1, Mob = "Fishman Warrior"},
    {Min = 400, Max = 449, NPC = "Fishman Adventurer", Quest = "FishmanQuest", Index = 2, Mob = "Fishman Commando"},
    {Min = 450, Max = 474, NPC = "Quest Giver", Quest = "SkyQuest2", Index = 1, Mob = "God's Guard"},
    {Min = 475, Max = 524, NPC = "Quest Giver", Quest = "SkyQuest2", Index = 2, Mob = "Shandian"},
    {Min = 525, Max = 624, NPC = "Quest Giver", Quest = "SkyQuest2", Index = 3, Mob = "Royal Squad"},
    {Min = 625, Max = 649, NPC = "Quest Giver", Quest = "FountainQuest", Index = 1, Mob = "Galley Pirate"},
    {Min = 650, Max = 699, NPC = "Quest Giver", Quest = "FountainQuest", Index = 2, Mob = "Galley Captain"},
    -- Sea 2
    {Min = 700, Max = 724, NPC = "Area 1 Quest Giver", Quest = "Area1Quest", Index = 1, Mob = "Raider"},
    {Min = 725, Max = 774, NPC = "Area 1 Quest Giver", Quest = "Area1Quest", Index = 2, Mob = "Mercenary"},
    {Min = 775, Max = 799, NPC = "Area 2 Quest Giver", Quest = "Area2Quest", Index = 1, Mob = "Swan Pirate"},
    {Min = 800, Max = 874, NPC = "Area 2 Quest Giver", Quest = "Area2Quest", Index = 2, Mob = "Factory Staff"},
    {Min = 875, Max = 899, NPC = "Green Zone Quest Giver", Quest = "MarineQuest3", Index = 1, Mob = "Marine Lieutenant"},
    {Min = 900, Max = 949, NPC = "Green Zone Quest Giver", Quest = "MarineQuest3", Index = 2, Mob = "Marine Captain"},
    {Min = 950, Max = 974, NPC = "Graveyard Quest Giver", Quest = "GraveyardQuest", Index = 1, Mob = "Zombie Squire"},
    {Min = 975, Max = 999, NPC = "Graveyard Quest Giver", Quest = "GraveyardQuest", Index = 2, Mob = "Zombie Demolisher"},
    {Min = 1000, Max = 1049, NPC = "Snow Mountain Quest Giver", Quest = "SnowMountainQuest", Index = 1, Mob = "Snow Trooper"},
    {Min = 1050, Max = 1099, NPC = "Snow Mountain Quest Giver", Quest = "SnowMountainQuest", Index = 2, Mob = "Winter Warrior"},
    {Min = 1100, Max = 1124, NPC = "Quest Giver", Quest = "IceSideQuest", Index = 1, Mob = "Lab Subordinate"},
    {Min = 1125, Max = 1174, NPC = "Quest Giver", Quest = "IceSideQuest", Index = 2, Mob = "Horned Warrior"},
    {Min = 1175, Max = 1199, NPC = "Quest Giver 2", Quest = "FireSideQuest", Index = 1, Mob = "Magma Ninja"},
    {Min = 1200, Max = 1249, NPC = "Quest Giver 2", Quest = "FireSideQuest", Index = 2, Mob = "Lava Pirate"},
    {Min = 1250, Max = 1274, NPC = "Cursed Ship Quest Giver", Quest = "ShipQuest1", Index = 1, Mob = "Ship Deckhand"},
    {Min = 1275, Max = 1299, NPC = "Cursed Ship Quest Giver", Quest = "ShipQuest1", Index = 2, Mob = "Ship Engineer"},
    {Min = 1300, Max = 1324, NPC = "Cursed Ship Quest Giver", Quest = "ShipQuest2", Index = 1, Mob = "Ship Steward"},
    {Min = 1325, Max = 1349, NPC = "Cursed Ship Quest Giver", Quest = "ShipQuest2", Index = 2, Mob = "Ship Officer"},
    {Min = 1350, Max = 1374, NPC = "Ice Castle Quest Giver", Quest = "IceCastleQuest", Index = 1, Mob = "Arctic Warrior"},
    {Min = 1375, Max = 1424, NPC = "Ice Castle Quest Giver", Quest = "IceCastleQuest", Index = 2, Mob = "Snow Lurker"},
    {Min = 1425, Max = 1449, NPC = "Forgotten Quest Giver", Quest = "ForgottenQuest", Index = 1, Mob = "Sea Soldier"},
    {Min = 1450, Max = 1500, NPC = "Forgotten Quest Giver", Quest = "ForgottenQuest", Index = 2, Mob = "Water Fighter"},
    -- Sea 3
    {Min = 1500, Max = 1524, NPC = "Port Town Quest Giver", Quest = "PortTownQuest", Index = 1, Mob = "Pirate Millionaire"},
    {Min = 1525, Max = 1574, NPC = "Port Town Quest Giver", Quest = "PortTownQuest", Index = 2, Mob = "Pistol Billionaire"},
    {Min = 1575, Max = 1599, NPC = "Hydra Island Quest Giver", Quest = "HydraIslandQuest", Index = 1, Mob = "Dragon Crew Warrior"},
    {Min = 1600, Max = 1624, NPC = "Hydra Island Quest Giver", Quest = "HydraIslandQuest", Index = 2, Mob = "Dragon Crew Archer"},
    {Min = 1625, Max = 1699, NPC = "Hydra Island Quest Giver", Quest = "HydraIslandQuest", Index = 3, Mob = "Female Assassin"},
    {Min = 1700, Max = 1724, NPC = "Quest Giver", Quest = "TurtleQuest1", Index = 1, Mob = "Fishman Raider"},
    {Min = 1725, Max = 1774, NPC = "Quest Giver", Quest = "TurtleQuest1", Index = 2, Mob = "Fishman Captain"},
    {Min = 1725, Max = 1774, NPC = "Quest Giver", Quest = "TurtleQuest1", Index = 3, Mob = "Forest Pirate"},
    {Min = 1800, Max = 1849, NPC = "Quest Giver", Quest = "TurtleQuest2", Index = 1, Mob = "Mythical Pirate"},
    {Min = 1850, Max = 1899, NPC = "Quest Giver", Quest = "TurtleQuest2", Index = 2, Mob = "Jungle Pirate"},
    {Min = 1900, Max = 1974, NPC = "Quest Giver", Quest = "TurtleQuest2", Index = 3, Mob = "Musketeer Pirate"},
    {Min = 1975, Max = 1999, NPC = "Haunted Quest Giver", Quest = "HauntedQuest1", Index = 1, Mob = "Reborn Skeleton"},
    {Min = 2000, Max = 2024, NPC = "Haunted Quest Giver", Quest = "HauntedQuest1", Index = 2, Mob = "Living Zombie"},
    {Min = 2025, Max = 2049, NPC = "Haunted Quest Giver", Quest = "HauntedQuest2", Index = 1, Mob = "Demonic Soul"},
    {Min = 2050, Max = 2074, NPC = "Haunted Quest Giver", Quest = "HauntedQuest2", Index = 2, Mob = "Posessed Mummy"},
    {Min = 2075, Max = 2099, NPC = "Quest Giver", Quest = "PeanutQuest", Index = 1, Mob = "Peanut Scout"},
    {Min = 2100, Max = 2124, NPC = "Quest Giver", Quest = "PeanutQuest", Index = 2, Mob = "Peanut President"},
    {Min = 2125, Max = 2149, NPC = "Quest Giver", Quest = "IceCreamQuest", Index = 1, Mob = "Ice Cream Chef"},
    {Min = 2150, Max = 2199, NPC = "Quest Giver", Quest = "IceCreamQuest", Index = 2, Mob = "Ice Cream Commander"},
    {Min = 2200, Max = 2224, NPC = "Quest Giver", Quest = "CakeQuest1", Index = 1, Mob = "Cookie Crafter"},
    {Min = 2225, Max = 2249, NPC = "Quest Giver", Quest = "CakeQuest1", Index = 2, Mob = "Cake Guard"},
    {Min = 2250, Max = 2274, NPC = "Quest Giver", Quest = "CakeQuest2", Index = 1, Mob = "Baking Staff"},
    {Min = 2275, Max = 2299, NPC = "Quest Giver", Quest = "CakeQuest2", Index = 2, Mob = "Head Baker"},
    {Min = 2300, Max = 2324, NPC = "Quest Giver", Quest = "ChocQuest1", Index = 1, Mob = "Cocoa Warrior"},
    {Min = 2325, Max = 2349, NPC = "Quest Giver", Quest = "ChocQuest1", Index = 2, Mob = "Chocolate Bar Battler"},
    {Min = 2350, Max = 2374, NPC = "Quest Giver", Quest = "ChocQuest2", Index = 1, Mob = "Sweet Thief"},
    {Min = 2375, Max = 2399, NPC = "Quest Giver", Quest = "ChocQuest2", Index = 2, Mob = "Candy Rebel"},
    {Min = 2400, Max = 2424, NPC = "Quest Giver", Quest = "CandyQuest1", Index = 1, Mob = "Candy Pirate"},
    {Min = 2425, Max = 2449, NPC = "Quest Giver", Quest = "CandyQuest1", Index = 2, Mob = "Snow Demon"},
    {Min = 2450, Max = 2474, NPC = "Quest Giver", Quest = "TikiQuest1", Index = 1, Mob = "Isle Outlaw"},
    {Min = 2475, Max = 2800, NPC = "Quest Giver", Quest = "TikiQuest1", Index = 2, Mob = "Island Boy"}
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

-- SERVER HOP SYSTEM
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
    local adminIDs = {[410143093] = true, [1552391024] = true, [4424317] = true}
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

-- SCREEN GUI CREATION
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ParentGui

-- LOADING BAR
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

task.spawn(function()
    local tween = TweenService:Create(BarFill, TweenInfo.new(2.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
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

-- LOGO TRIGGER BUTTON
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

-- MAIN INTERFACE FRAME
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

-- 🔮 AMETİST KANAT/YAN ANİMASYONLARI DEFINITION (Must be defined BEFORE calling!)
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

-- Call functions safely after they are defined
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

-- LANGUAGE INTERCHANGE
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

-- LUCK DISPLAY
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

-- CLOSE CONFIRMATION SYSTEM
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

-- SCROLLING CONTAINER (Emulator rendering fixes applied)
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 6
Container.ScrollBarImageColor3 = Color3.fromRGB(150, 60, 255)
Container.ClipsDescendants = true
Container.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y -- Enforces automatic scale rendering
Container.CanvasSize = UDim2.new(0, 0, 0, 1100) -- Fallback viewport size for older emulators
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Container

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

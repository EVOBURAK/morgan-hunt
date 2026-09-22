--[[
    ============================================================================
    MORGAN HUB V3.0 ULTIMATE  |  Blox Fruits  |  English UI  |  No Key
    Built for Delta (Mobile + PC).
    Quest / mob / island data comes from open-source hub tables (levels 1 - 2550).
    Levels above that are resolved dynamically from the game's own quest module.
    ============================================================================
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local V3, CF = Vector3.new, CFrame.new

-- Stop any older copy of this script
local genv = (getgenv and getgenv()) or _G
local RunId = tostring(os.clock()) .. "_" .. tostring(math.random(1, 1000000))
genv.MorganHubRunId = RunId

-- Executor feature detection (all optional)
local Ex = {
    SetHidden = sethiddenproperty or set_hidden_property or sethiddenprop,
    FireTouch = firetouchinterest,
    FireClick = fireclickdetector,
    FireProx = fireproximityprompt,
    GetConnections = getconnections,
    FireSignal = firesignal,
    CustomAsset = getcustomasset or getsynasset,
    GetUpvalues = (debug and debug.getupvalues) or getupvalues,
    GetHui = gethui,
    SetFpsCap = setfpscap,
}

-- Namespaces (keeps the number of top-level locals low)
local U, UI, Move, Combat, Farm, Items, PvP, ESP, Misc, Data, Fish =
    {Conns = {}}, {T = {}}, {}, {}, {}, {}, {}, {}, {}, {}, {}

-- =============================================================================
-- CONFIG
-- =============================================================================
local Cfg = {
    -- Farming
    AutoFarm = false, UseQuest = true, WeaponType = "Melee",
    FarmHeight = 12, TweenSpeed = 200,
    BringMobs = true, BringRadius = 380, Hitbox = true, HitboxSize = 45,
    FastAttack = true, AttackMode = "Auto-Detect", AttackRange = 70, ClickMethod = "VirtualUser",
    AutoBuso = true, AutoKen = false,
    TargetLevel = 3000, StopAtTarget = false, AutoSeaTravel = true,
    FarmNearest = false, FarmMob = false, SelectedMob = "",
    FarmBoss = false, SelectedBoss = "",
    PirateRaid = false, PirateIdleWait = false, EliteHunter = false,
    BoneFarm = false, AutoRandomSurprise = false,
    MasteryFarm = false, MasteryType = "Blox Fruit",
    AutoRaid = false, RaidType = "Flame",
    SkillZ = false, SkillX = false, SkillC = false, SkillV = false, SkillF = false,
    -- Items
    AutoCollectFruit = false, AutoStoreFruit = false, FruitNotify = true,
    AutoChest = false, AutoRandomFruit = false,
    -- Stats
    StatOn = false, StatMelee = false, StatDefense = false, StatSword = false,
    StatGun = false, StatFruit = false, StatAmount = 3,
    -- Player
    Speed = false, SpeedVal = 100, Jump = false, JumpVal = 100, InfJump = false,
    Noclip = false, Fly = false, FlySpeed = 90, WalkWater = false,
    -- Visual
    ESPPlayer = false, ESPFruit = false, ESPChest = false, ESPMob = false,
    Stretch = false, StretchAmt = 0.65, Rain = true, Fullbright = false, NoFog = false,
    -- PvP
    PvpTargetName = "", PvpKill = false, PvpHunt = false, PvpSkipTeam = true,
    Aimbot = false, AimFOV = 250, PlayerHitbox = false, PlayerHitboxSize = 20,
    -- Safety / system
    AdminHop = true, AdminRank = 2, AutoReconnect = true, LowHPEscape = false, EscapeHP = 30,
    UIScale = 1, SaveConfig = true,
    -- Fishing / visuals
    FishFarm = false, FishSell = true, FishBait = true, FishRestock = 5,
    FpsBoost = false, Theme = "Rain",
    -- Uses a Roblox asset by default; the URL option below can still override it.
    LogoAsset = "rbxassetid://92647074735439", LogoURL = "",
    -- Discord webhook / bug reports / fruit hop
    WebhookURL = "https://discord.com/api/webhooks/1551443716810477678/MQhHmmfbw3DCkgBtJjlLaUPAsLHLt6LY4kuetBALnwci8irzjrbH1WatCccR4QNUuHFz",
    WhIncludeName = true, WhAlerts = false, WhStaff = false, WhStuck = false, WhLevel = false, WhErrors = false,
    FruitHop = false, HopWait = 45,
}

-- =============================================================================
-- WORLD DETECTION
-- =============================================================================
local Sea = 0
do
    local pid = game.PlaceId
    if pid == 2753915549 then Sea = 1
    elseif pid == 4442272183 then Sea = 2
    elseif pid == 7449423635 then Sea = 3 end
end

-- =============================================================================
-- GUI PARENT RESOLUTION  (gethui -> CoreGui -> PlayerGui)
-- =============================================================================
local function CanParent(p)
    if not p then return false end
    local ok = pcall(function()
        local t = Instance.new("ScreenGui")
        t.Parent = p
        t:Destroy()
    end)
    return ok
end

local GuiParent
do
    if Ex.GetHui then
        local ok, h = pcall(Ex.GetHui)
        if ok and h and CanParent(h) then GuiParent = h end
    end
    if not GuiParent then
        local ok, core = pcall(function() return game:GetService("CoreGui") end)
        if ok and core and CanParent(core) then GuiParent = core end
    end
    if not GuiParent then GuiParent = LocalPlayer:WaitForChild("PlayerGui") end

    -- remove older copies
    for _, parent in ipairs({GuiParent, LocalPlayer:FindFirstChild("PlayerGui")}) do
        if parent then
            for _, n in ipairs({"MorganHubV3", "MorganESP", "MorganHubPremium"}) do
                local o = parent:FindFirstChild(n)
                if o then pcall(function() o:Destroy() end) end
            end
        end
    end
end

-- =============================================================================
-- UTILITIES
-- =============================================================================
function U.Alive() return genv.MorganHubRunId == RunId end

local logSeen = {}
U.ErrLog = {}
function U.Log(msg)
    msg = tostring(msg)
    if not logSeen[msg] then
        logSeen[msg] = true
        warn("[MorganHub] " .. msg)
        table.insert(U.ErrLog, msg)
        if #U.ErrLog > 10 then table.remove(U.ErrLog, 1) end
        if Misc.ReportError then Misc.ReportError(msg) end
    end
end

function U.Spawn(fn, ...)
    local args = table.pack(...)
    task.spawn(function()
        local ok, err = pcall(fn, table.unpack(args, 1, args.n))
        if not ok then U.Log(err) end
    end)
end

function U.Loop(interval, fn)
    task.spawn(function()
        while U.Alive() do
            local ok, err = pcall(fn)
            if not ok then U.Log(err) end
            task.wait(interval)
        end
    end)
end

function U.Conn(signal, fn)
    local c = signal:Connect(function(...)
        if not U.Alive() then return end
        local ok, err = pcall(fn, ...)
        if not ok then U.Log(err) end
    end)
    table.insert(U.Conns, c)
    return c
end

function U.Notify(title, msg, dur)
    if UI.Notify then UI.Notify(title, msg, dur) end
end

function U.Root()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

function U.Hum()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

function U.Level()
    local d = LocalPlayer:FindFirstChild("Data")
    local l = d and d:FindFirstChild("Level")
    return l and l.Value or 1
end

function U.Points()
    local d = LocalPlayer:FindFirstChild("Data")
    local p = d and d:FindFirstChild("Points")
    return p and p.Value or 0
end

local CommF_
function U.Comm(...)
    if not (CommF_ and CommF_.Parent) then
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        CommF_ = r and r:FindFirstChild("CommF_")
    end
    if not CommF_ then return nil end
    local args = table.pack(...)
    local ok, res = pcall(function() return CommF_:InvokeServer(table.unpack(args, 1, args.n)) end)
    if ok then return res end
    return nil
end

-- fire-and-forget remote call: never blocks the farming loop
function U.CommAsync(...)
    local args = table.pack(...)
    task.spawn(function() U.Comm(table.unpack(args, 1, args.n)) end)
end

-- "Bandit [Lv. 5]" -> "Bandit"
function U.CleanName(n)
    local s = n:gsub("%s*%b[]", "")
    s = s:gsub("^%s+", "")
    s = s:gsub("%s+$", "")
    return s
end

-- returns the HumanoidRootPart if the mob is alive
function U.MobAlive(m)
    if not m or not m.Parent then return nil end
    local h = m:FindFirstChildOfClass("Humanoid")
    local r = m:FindFirstChild("HumanoidRootPart")
    if h and r and h.Health > 0 then return r end
    return nil
end

-- fall back to a level-based guess when the place id is unknown
if Sea == 0 then
    local l = U.Level()
    Sea = (l >= 1500 and 3) or (l >= 700 and 2) or 1
end

-- =============================================================================
-- QUEST DATA
-- row = {minLevel, mobName, questName, questIndex, questPos, mobPos, island, entrance}
-- =============================================================================
Data.Quests = {
    [1] = {
        {1,   "Bandit",             "BanditQuest1",   1, V3(1059.4, 15.4, 1550.4),   V3(1046, 27, 1560.8),        "Starter Island"},
        {10,  "Monkey",             "JungleQuest",    1, V3(-1598.1, 35.6, 153.4),   V3(-1448.5, 67.9, 11.5),      "Jungle"},
        {15,  "Gorilla",            "JungleQuest",    2, V3(-1598.1, 35.6, 153.4),   V3(-1129.9, 40.5, -525.4),    "Jungle"},
        {30,  "Pirate",             "BuggyQuest1",    1, V3(-1141.1, 4.1, 3831.5),   V3(-1103.5, 13.8, 3896.1),    "Pirate Village"},
        {40,  "Brute",              "BuggyQuest1",    2, V3(-1141.1, 4.1, 3831.5),   V3(-1140.1, 14.8, 4322.9),    "Pirate Village"},
        {60,  "Desert Bandit",      "DesertQuest",    1, V3(894.5, 5.1, 4392.4),     V3(924.8, 6.4, 4481.6),       "Desert"},
        {75,  "Desert Officer",     "DesertQuest",    2, V3(894.5, 5.1, 4392.4),     V3(1608.3, 8.6, 4371),        "Desert"},
        {90,  "Snow Bandit",        "SnowQuest",      1, V3(1389.7, 88.2, -1298.9),  V3(1354.3, 87.3, -1393.9),    "Frozen Village"},
        {100, "Snowman",            "SnowQuest",      2, V3(1389.7, 88.2, -1298.9),  V3(1201.6, 144.6, -1550.1),   "Frozen Village"},
        {120, "Chief Petty Officer","MarineQuest2",   1, V3(-5039.6, 27.4, 4324.7),  V3(-4881.2, 22.7, 4273.8),    "Marine Fortress"},
        {150, "Sky Bandit",         "SkyQuest",       1, V3(-4839.5, 716.4, -2619.4),V3(-4953.2, 295.7, -2899.2),  "Lower Skylands"},
        {175, "Dark Master",        "SkyQuest",       2, V3(-4839.5, 716.4, -2619.4),V3(-5259.8, 391.4, -2229),    "Lower Skylands"},
        {190, "Prisoner",           "PrisonerQuest",  1, V3(5308.9, 1.7, 475.1),     V3(5099, -0.3, 474.2),        "Prison"},
        {210, "Dangerous Prisoner", "PrisonerQuest",  2, V3(5308.9, 1.7, 475.1),     V3(5654.6, 15.6, 866.3),      "Prison"},
        {250, "Toga Warrior",       "ColosseumQuest", 1, V3(-1580, 6.4, -2986.5),    V3(-1820.2, 51.7, -2740.7),   "Colosseum"},
        {275, "Gladiator",          "ColosseumQuest", 2, V3(-1580, 6.4, -2986.5),    V3(-1292.8, 56.4, -3339),     "Colosseum"},
        {300, "Military Soldier",   "MagmaQuest",     1, V3(-5313.4, 10.9, 8515.3),  V3(-5411.2, 11.1, 8454.3),    "Magma Village"},
        {325, "Military Spy",       "MagmaQuest",     2, V3(-5313.4, 10.9, 8515.3),  V3(-5802.9, 86.3, 8828.9),    "Magma Village"},
        {375, "Fishman Warrior",    "FishmanQuest",   1, V3(61122.7, 18.5, 1569.4),  V3(60878.3, 18.5, 1543.8),    "Underwater City", V3(61163.9, 11.7, 1819.8)},
        {400, "Fishman Commando",   "FishmanQuest",   2, V3(61122.7, 18.5, 1569.4),  V3(61922.6, 18.5, 1493.9),    "Underwater City", V3(61163.9, 11.7, 1819.8)},
        {450, "God's Guard",        "SkyExp1Quest",   1, V3(-4721.9, 843.9, -1950),  V3(-4710, 845.3, -1927.3),    "Middle Skylands", V3(-4607.8, 872.5, -1667.6)},
        {475, "Shanda",             "SkyExp1Quest",   2, V3(-7859.1, 5544.2, -381.5),V3(-7678.5, 5566.4, -497.2),  "Upper Skylands",  V3(-7894.6, 5547.1, -380.3)},
        {525, "Royal Squad",        "SkyExp2Quest",   1, V3(-7906.8, 5634.7, -1412), V3(-7624.3, 5658.1, -1467.4), "Upper Skylands"},
        {550, "Royal Soldier",      "SkyExp2Quest",   2, V3(-7906.8, 5634.7, -1412), V3(-7836.8, 5645.7, -1790.6), "Upper Skylands"},
        {625, "Galley Pirate",      "FountainQuest",  1, V3(5259.8, 37.4, 4050),     V3(5551, 78.9, 3930.4),       "Fountain City"},
        {650, "Galley Captain",     "FountainQuest",  2, V3(5259.8, 37.4, 4050),     V3(5442, 42.5, 4950.1),       "Fountain City"},
    },
    [2] = {
        {700,  "Raider",            "Area1Quest",     1, V3(-429.5, 71.8, 1836.2),   V3(-728.3, 52.8, 2345.8),     "Kingdom of Rose"},
        {725,  "Mercenary",         "Area1Quest",     2, V3(-429.5, 71.8, 1836.2),   V3(-1004.3, 80.2, 1424.6),    "Kingdom of Rose"},
        {775,  "Swan Pirate",       "Area2Quest",     1, V3(638.4, 71.8, 918.3),     V3(1068.7, 137.6, 1322.1),    "Kingdom of Rose (Area 2)"},
        {800,  "Factory Staff",     "Area2Quest",     2, V3(632.7, 73.1, 918.7),     V3(73.1, 81.9, -27.5),        "Kingdom of Rose (Area 2)"},
        {875,  "Marine Lieutenant", "MarineQuest3",   1, V3(-2440.8, 71.7, -3216.1), V3(-2821.4, 75.9, -3070.1),   "Green Zone"},
        {900,  "Marine Captain",    "MarineQuest3",   2, V3(-2440.8, 71.7, -3216.1), V3(-1861.2, 80.2, -3254.7),   "Green Zone"},
        {950,  "Zombie",            "ZombieQuest",    1, V3(-5497.1, 47.6, -795.2),  V3(-5657.8, 79, -928.7),      "Graveyard"},
        {975,  "Vampire",           "ZombieQuest",    2, V3(-5497.1, 47.6, -795.2),  V3(-6037.7, 32.2, -1340.7),   "Graveyard"},
        {1000, "Snow Trooper",      "SnowMountainQuest", 1, V3(609.9, 400.1, -5372.3), V3(549.1, 427.4, -5563.7),  "Snow Mountain"},
        {1050, "Winter Warrior",    "SnowMountainQuest", 2, V3(609.9, 400.1, -5372.3), V3(1142.7, 475.6, -5199.4), "Snow Mountain"},
        {1100, "Lab Subordinate",   "IceSideQuest",   1, V3(-6064.1, 15.2, -4903),   V3(-5707.5, 16, -4513.4),     "Hot and Cold (Ice Side)"},
        {1125, "Horned Warrior",    "IceSideQuest",   2, V3(-6064.1, 15.2, -4903),   V3(-6341.4, 16, -5723.2),     "Hot and Cold (Ice Side)"},
        {1175, "Magma Ninja",       "FireSideQuest",  1, V3(-5428, 15.1, -5299.4),   V3(-5449.7, 76.7, -5808.2),   "Hot and Cold (Fire Side)"},
        {1200, "Lava Pirate",       "FireSideQuest",  2, V3(-5428, 15.1, -5299.4),   V3(-5213.3, 49.7, -4701.5),   "Hot and Cold (Fire Side)"},
        {1250, "Ship Deckhand",     "ShipQuest1",     1, V3(1037.8, 125.1, 32911.6), V3(1212, 150.8, 33059.2),     "Cursed Ship", V3(923.2, 127, 32852.8)},
        {1275, "Ship Engineer",     "ShipQuest1",     2, V3(1037.8, 125.1, 32911.6), V3(919.5, 43.5, 32780),       "Cursed Ship", V3(923.2, 127, 32852.8)},
        {1300, "Ship Steward",      "ShipQuest2",     1, V3(968.8, 125.1, 33244.1),  V3(919.4, 129.6, 33436),      "Cursed Ship", V3(923.2, 127, 32852.8)},
        {1325, "Ship Officer",      "ShipQuest2",     2, V3(968.8, 125.1, 33244.1),  V3(1036, 181.4, 33315.7),     "Cursed Ship", V3(923.2, 127, 32852.8)},
        {1350, "Arctic Warrior",    "FrostQuest",     1, V3(5667.7, 26.8, -6486.1),  V3(5966.2, 63, -6179.4),      "Ice Castle", V3(-6508.6, 5000, -132.8)},
        {1375, "Snow Lurker",       "FrostQuest",     2, V3(5667.7, 26.8, -6486.1),  V3(5407.1, 69.2, -6880.9),    "Ice Castle"},
        {1425, "Sea Soldier",       "ForgottenQuest", 1, V3(-3054.4, 235.5, -10142.8), V3(-3028.2, 64.7, -9775.4), "Forgotten Island"},
        {1450, "Water Fighter",     "ForgottenQuest", 2, V3(-3054.4, 235.5, -10142.8), V3(-3352.9, 285, -10534.8), "Forgotten Island"},
    },
    [3] = {
        {1500, "Pirate Millionaire","PiratePortQuest",1, V3(-290.1, 42.9, 5581.6),   V3(-246, 47.3, 5584.1),       "Port Town"},
        {1525, "Pistol Billionaire","PiratePortQuest",2, V3(-290.1, 42.9, 5581.6),   V3(-187.3, 86.2, 6013.5),     "Port Town"},
        {1575, "Dragon Crew Warrior","AmazonQuest",   1, V3(5832.8, 51.7, -1101.5),  V3(6141.1, 51.4, -1340.7),    "Hydra Island"},
        {1600, "Dragon Crew Archer","AmazonQuest",    2, V3(5833.1, 51.6, -1103.1),  V3(6616.4, 441.8, 446),       "Hydra Island"},
        {1625, "Female Islander",   "AmazonQuest2",   1, V3(5446.9, 601.6, 749.5),   V3(4685.3, 735.8, 815.3),     "Hydra Island"},
        {1650, "Giant Islander",    "AmazonQuest2",   2, V3(5446.9, 601.6, 749.5),   V3(4729.1, 590.4, -37),       "Hydra Island"},
        {1700, "Marine Commodore",  "MarineTreeIsland",1, V3(2180.5, 27.8, -6741.5), V3(2286, 73.1, -7159.8),      "Great Tree"},
        {1725, "Marine Rear Admiral","MarineTreeIsland",2, V3(2180, 28.7, -6740.1),  V3(3656.8, 160.5, -7001.6),   "Great Tree"},
        {1775, "Fishman Raider",    "DeepForestIsland3",1, V3(-10581.7, 330.9, -8761.2), V3(-10407.5, 331.8, -8368.5), "Floating Turtle (Fishmen)"},
        {1800, "Fishman Captain",   "DeepForestIsland3",2, V3(-10581.7, 330.9, -8761.2), V3(-10994.7, 352.4, -9002.1), "Floating Turtle (Fishmen)"},
        {1825, "Forest Pirate",     "DeepForestIsland",1, V3(-13234, 331.5, -7625.4), V3(-13274.5, 332.4, -7769.6), "Floating Turtle (Forest)"},
        {1850, "Mythological Pirate","DeepForestIsland",2, V3(-13234, 331.5, -7625.4), V3(-13680.6, 501.1, -6991.2), "Floating Turtle (Forest)"},
        {1900, "Jungle Pirate",     "DeepForestIsland2",1, V3(-12680.4, 390, -9902), V3(-12256.2, 331.7, -10485.8), "Floating Turtle (Jungle)"},
        {1925, "Musketeer Pirate",  "DeepForestIsland2",2, V3(-12680.4, 390, -9902), V3(-13457.9, 391.5, -9859.2),  "Floating Turtle (Jungle)"},
        {1975, "Reborn Skeleton",   "HauntedQuest1",  1, V3(-9479.2, 141.2, 5566.1), V3(-8763.7, 165.7, 6159.9),   "Haunted Castle"},
        {2000, "Living Zombie",     "HauntedQuest1",  2, V3(-9479.2, 141.2, 5566.1), V3(-10144.1, 138.6, 5838.1),  "Haunted Castle"},
        {2025, "Demonic Soul",      "HauntedQuest2",  1, V3(-9517, 172, 6078.5),     V3(-9505.9, 172.1, 6159),     "Haunted Castle"},
        {2050, "Posessed Mummy",    "HauntedQuest2",  2, V3(-9517, 172, 6078.5),     V3(-9582, 6.3, 6205.5),       "Haunted Castle"},
        {2075, "Peanut Scout",      "NutsIslandQuest",1, V3(-2104.4, 38.1, -10194.2),V3(-2143.2, 47.7, -10030),    "Peanut Land"},
        {2100, "Peanut President",  "NutsIslandQuest",2, V3(-2104.4, 38.1, -10194.2),V3(-1859.4, 38.1, -10422.4),  "Peanut Land"},
        {2125, "Ice Cream Chef",    "IceCreamIslandQuest",1, V3(-820.6, 65.8, -10965.8), V3(-872.2, 65.8, -10920), "Ice Cream Land"},
        {2150, "Ice Cream Commander","IceCreamIslandQuest",2, V3(-820.6, 65.8, -10965.8), V3(-558.1, 112, -11290.8), "Ice Cream Land"},
        {2200, "Cookie Crafter",    "CakeQuest1",     1, V3(-2021.3, 37.8, -12028.7),V3(-2374.1, 37.8, -12125.3),  "Cake Land"},
        {2225, "Cake Guard",        "CakeQuest1",     2, V3(-2021.3, 37.8, -12028.7),V3(-1598.3, 43.8, -12244.6),  "Cake Land"},
        {2250, "Baking Staff",      "CakeQuest2",     1, V3(-1927.9, 37.8, -12842.5),V3(-1887.8, 77.6, -12998.4),  "Cake Land"},
        {2275, "Head Baker",        "CakeQuest2",     2, V3(-1927.9, 37.8, -12842.5),V3(-2216.2, 82.9, -12869.3),  "Cake Land"},
        {2300, "Cocoa Warrior",     "ChocQuest1",     1, V3(233.2, 29.9, -12201.2),  V3(-21.6, 80.6, -12352.4),    "Chocolate Land"},
        {2325, "Chocolate Bar Battler","ChocQuest1",  2, V3(233.2, 29.9, -12201.2),  V3(582.6, 77.2, -12463.2),    "Chocolate Land"},
        {2350, "Sweet Thief",       "ChocQuest2",     1, V3(150.5, 30.7, -12774.5),  V3(165.2, 76.1, -12600.8),    "Chocolate Land"},
        {2375, "Candy Rebel",       "ChocQuest2",     2, V3(150.5, 30.7, -12774.5),  V3(134.9, 77.2, -12876.5),    "Chocolate Land"},
        {2400, "Candy Pirate",      "CandyQuest1",    1, V3(-1150, 20.4, -14446.3),  V3(-1310.5, 26, -14562.4),    "Candy Land"},
        {2425, "Snow Demon",        "CandyQuest1",    2, V3(-1150, 20.4, -14446.3),  V3(-880.2, 71.2, -14538.6),   "Candy Land"},
        {2450, "Isle Outlaw",       "TikiQuest1",     1, V3(-16547.7, 61.1, -173.4), V3(-16442.8, 116.1, -264.5),  "Tiki Outpost"},
        {2475, "Island Boy",        "TikiQuest1",     2, V3(-16547.7, 61.1, -173.4), V3(-16901.3, 84.1, -192.9),   "Tiki Outpost"},
        {2500, "Sun-kissed Warrior","TikiQuest2",     1, V3(-16539.1, 55.7, 1051.6), V3(-16349.9, 92.1, 1123.4),   "Tiki Outpost"},
        {2525, "Isle Champion",     "TikiQuest2",     2, V3(-16539.1, 55.7, 1051.6), V3(-16347.4, 92.1, 1122.3),   "Tiki Outpost"},
    },
}

-- Submerged Island (2600-2800) quest routing.
-- Quest NPC positions and quest IDs are resolved from the live quest module so
-- this does not depend on stale hard-coded coordinates.
Data.SubmergedQuests = {
    {2600, "Reef Bandit", "Submerged Quest Giver 1"},
    {2625, "Coral Pirate", "Submerged Quest Giver 1"},
    {2650, "Sea Chanter", "Submerged Quest Giver 2"},
    {2675, "Ocean Prophet", "Submerged Quest Giver 2"},
    {2675, "High Disciple", "Submerged Quest Giver 3"},
    {2700, "Grand Devotee", "Submerged Quest Giver 3"},
}

Data.CastlePos = V3(-5496.2, 313.8, -2841.5) -- Castle on the Sea (Sea 3), pirate raid spot

-- Fisherman docks (approximate, used to fly there before the NPC has streamed in)
Data.FisherPos = {
    [1] = V3(1354, 88, -1394),   -- Frozen Village docks
    [2] = V3(-350, 72, 1900),    -- Kingdom of Rose, Docks 2
    [3] = V3(-246, 47, 5584),    -- Port Town docks
}

Data.Bosses = {
    [1] = {"Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral", "Saber Expert", "Warden",
           "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Ice Admiral"},
    [2] = {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Cursed Captain", "Darkbeard", "Order",
           "Awakened Ice Admiral", "Tide Keeper"},
    [3] = {"Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen",
           "Longma", "Soul Reaper", "Cake Prince", "Dough King", "rip_indra True Form"},
}
Data.EliteNames = {"Deandre", "Diablo", "Urban"}
Data.BoneMobs = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}
Data.RaidTypes = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human: Buddha",
                  "Sand", "Bird: Phoenix", "Dough"}

-- Derived lists for the current sea
Data.MobList, Data.MobPos, Data.Islands = {}, {}, {}
do
    local seen = {}
    for _, r in ipairs(Data.Quests[Sea] or {}) do
        table.insert(Data.MobList, r[2])
        Data.MobPos[r[2]] = r[6]
        if not seen[r[7]] then
            seen[r[7]] = true
            table.insert(Data.Islands, {name = r[7], pos = r[5], ent = r[8]})
        end
    end
end

-- =============================================================================
-- UI LIBRARY  (glass window, sliding pill sidebar, fading pages, ripple, particle themes)
-- =============================================================================
local Theme = {
    Bg = Color3.fromRGB(8, 8, 14),
    Card = Color3.fromRGB(22, 22, 36),
    Accent = Color3.fromRGB(140, 80, 255),
    Accent2 = Color3.fromRGB(80, 200, 255),
    Text = Color3.fromRGB(240, 240, 252),
    Sub = Color3.fromRGB(165, 165, 190),
    Off = Color3.fromRGB(55, 55, 78),
    Line = Color3.fromRGB(60, 60, 90),
}

local function New(class, props, parent)
    local o = Instance.new(class)
    if props then
        for k, v in pairs(props) do o[k] = v end
    end
    if parent then o.Parent = parent end
    return o
end

local function Corner(o, r)
    return New("UICorner", {CornerRadius = UDim.new(0, r or 8)}, o)
end

local function Stroke(o, color, thickness, transparency)
    return New("UIStroke", {
        Color = color, Thickness = thickness or 1, Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, o)
end

local function Pad(o, l, t, r, b)
    return New("UIPadding", {
        PaddingLeft = UDim.new(0, l), PaddingTop = UDim.new(0, t),
        PaddingRight = UDim.new(0, r), PaddingBottom = UDim.new(0, b),
    }, o)
end

-- one-line tween (Quint out by default = smooth deceleration)
local function tw(obj, t, props, style, dir)
    local tween = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function IsPointer(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

local function IsMove(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
end

local function MakeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
    U.Conn(handle.InputBegan, function(input)
        if IsPointer(input) then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            local c
            c = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if c then c:Disconnect() end
                end
            end)
        end
    end)
    U.Conn(UserInputService.InputChanged, function(input)
        if dragging and IsMove(input) then
            local d = input.Position - dragStart
            local s = (UI.Scale and UI.Scale.Scale) or 1
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X / s,
                                        startPos.Y.Scale, startPos.Y.Offset + d.Y / s)
        end
    end)
end

-- expanding circle at the click point
local function Ripple(btn, x, y)
    local s = (UI.Scale and UI.Scale.Scale) or 1
    local ap, asz = btn.AbsolutePosition, btn.AbsoluteSize
    local d = math.max(asz.X, asz.Y) / s * 1.7
    local rp = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset((x - ap.X) / s, (y - ap.Y) / s),
        Size = UDim2.fromOffset(0, 0), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.85,
        BorderSizePixel = 0, ZIndex = btn.ZIndex + 2,
    }, btn)
    Corner(rp, 999)
    tw(rp, 0.6, {Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
    task.delay(0.65, function() pcall(function() rp:Destroy() end) end)
end

-- toast notification: fades + pops in, fades out
function UI.Notify(title, msg, dur)
    if not UI.ToastHolder then return end
    dur = dur or 4
    local t = New("CanvasGroup", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Bg,
        BackgroundTransparency = 0.1, BorderSizePixel = 0, GroupTransparency = 1,
    }, UI.ToastHolder)
    Corner(t, 10)
    Stroke(t, Theme.Line, 1, 0.4)
    Pad(t, 12, 8, 12, 8)
    local sc = New("UIScale", {Scale = 0.88}, t)
    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)}, t)
    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = tostring(title),
        TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1,
    }, t)
    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        Text = tostring(msg), TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12,
        TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2,
    }, t)
    tw(t, 0.35, {GroupTransparency = 0})
    tw(sc, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
    task.delay(dur, function()
        tw(t, 0.3, {GroupTransparency = 1})
        tw(sc, 0.3, {Scale = 0.88})
        task.delay(0.35, function() pcall(function() t:Destroy() end) end)
    end)
end

UI.Pulses = {}

function UI.CreateWindow(titleText, subtitleText)
    local cam = Workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local W = math.clamp(vp.X - 30, 340, 700)
    local H = math.clamp(vp.Y - 30, 250, 440)
    local SW = (W < 520) and 100 or 132

    local Gui = New("ScreenGui", {
        Name = "MorganHubV3", ResetOnSpawn = false, DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    Gui.Parent = GuiParent
    UI.Gui = Gui

    UI.ToastHolder = New("Frame", {
        Size = UDim2.new(0, 240, 1, -20), AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -10, 1, -10), BackgroundTransparency = 1,
    }, Gui)
    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 6),
    }, UI.ToastHolder)

    -- glass window
    local Main = New("Frame", {
        Name = "Main", Size = UDim2.new(0, W, 0, H), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Theme.Bg,
        BackgroundTransparency = 0.1, BorderSizePixel = 0, ClipsDescendants = true,
        Active = true,
    }, Gui)
    Corner(Main, 14)
    UI.Scale = New("UIScale", {Scale = Cfg.UIScale}, Main)
    local mainStroke = Stroke(Main, Theme.Line, 1.5, 0.3)
    local strokeGrad = New("UIGradient", {
        Color = ColorSequence.new(Theme.Accent, Theme.Accent2), Rotation = 45,
    }, mainStroke)

    New("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Image = "rbxassetid://92647074735439", ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Crop, ZIndex = 1,
    }, Main)
    local tint = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(6, 6, 16),
        BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 1,
    }, Main)
    New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(1, 0.6),
        }), Rotation = 90,
    }, tint)

    -- PARTICLE LAYER: rain / snow / cherry blossom
    local Rain = New("Frame", {
        Name = "Particles", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        ClipsDescendants = true, ZIndex = 1,
    }, Main)
    local Themes = {
        Rain = {a = Color3.fromRGB(140, 80, 255), b = Color3.fromRGB(80, 200, 255), tint = Color3.fromRGB(6, 6, 16)},
        Snow = {a = Color3.fromRGB(190, 225, 255), b = Color3.fromRGB(120, 180, 255), tint = Color3.fromRGB(8, 18, 36)},
        Sakura = {a = Color3.fromRGB(255, 140, 190), b = Color3.fromRGB(255, 205, 228), tint = Color3.fromRGB(34, 8, 24)},
    }
    local parts = {}
    local curTheme = "Rain"

    function UI.SetTheme(name)
        if not Themes[name] then name = "Rain" end
        curTheme = name
        Cfg.Theme = name
        for _, p in ipairs(parts) do pcall(function() p.f:Destroy() end) end
        parts = {}
        local count = (W < 520) and 14 or 26
        for i = 1, count do
            local f, p
            if name == "Rain" then
                f = New("Frame", {
                    Size = UDim2.new(0, math.random(1, 2), 0, math.random(12, 26)),
                    BackgroundColor3 = Themes[name].b,
                    BackgroundTransparency = 0.68 + math.random() * 0.2, BorderSizePixel = 0,
                    Rotation = 12, ZIndex = 1,
                }, Rain)
                p = {f = f, x = math.random(0, W), y = math.random(-H, H), s = math.random(420, 820), k = "rain"}
            elseif name == "Snow" then
                local sz = math.random(3, 6)
                f = New("Frame", {
                    Size = UDim2.new(0, sz, 0, sz), BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 0.35 + math.random() * 0.4, BorderSizePixel = 0, ZIndex = 1,
                }, Rain)
                Corner(f, 3)
                p = {f = f, x = math.random(0, W), y = math.random(-H, H), s = math.random(28, 75),
                     sw = 8 + math.random() * 14, ph = math.random() * 6.28, k = "snow"}
            else
                f = New("Frame", {
                    Size = UDim2.new(0, math.random(7, 11), 0, math.random(5, 7)),
                    BackgroundColor3 = Color3.fromRGB(255, math.random(150, 190), math.random(190, 220)),
                    BackgroundTransparency = 0.4 + math.random() * 0.35, BorderSizePixel = 0, ZIndex = 1,
                }, Rain)
                Corner(f, 4)
                p = {f = f, x = math.random(0, W), y = math.random(-H, H), s = math.random(35, 85),
                     sw = 14 + math.random() * 22, ph = math.random() * 6.28, rot = math.random(0, 360),
                     rs = math.random(-70, 70), k = "sakura"}
            end
            parts[#parts + 1] = p
        end
        local th = Themes[name]
        strokeGrad.Color = ColorSequence.new(th.a, th.b)
        tw(tint, 0.6, {BackgroundColor3 = th.tint})
    end

    U.Conn(RunService.RenderStepped, function(dt)
        if not Main.Visible then return end
        local now = os.clock()
        -- breathing glow on the hero switches that are ON
        for _, pl in ipairs(UI.Pulses) do
            if pl.on() then pl.stroke.Transparency = 0.02 + (math.sin(now * 3) + 1) * 0.1 end
        end
        Rain.Visible = Cfg.Rain
        if not Rain.Visible then return end
        for _, d in ipairs(parts) do
            if d.k == "rain" then
                d.y = d.y + d.s * dt
                d.x = d.x - d.s * 0.2 * dt
                if d.y > H + 20 or d.x < -20 then d.y = -30 d.x = math.random(0, W + 60) end
            else
                d.y = d.y + d.s * dt
                d.x = d.x + math.sin(now * 1.3 + d.ph) * d.sw * dt
                if d.k == "sakura" then
                    d.rot = d.rot + d.rs * dt
                    d.f.Rotation = d.rot
                end
                if d.y > H + 14 then d.y = -14 d.x = math.random(0, W) end
            end
            d.f.Position = UDim2.fromOffset(d.x, d.y)
        end
    end)

    -- TOP BAR
    local Top = New("Frame", {
        Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = Color3.fromRGB(4, 4, 10),
        BackgroundTransparency = 0.45, BorderSizePixel = 0, ZIndex = 2,
    }, Main)
    New("Frame", {
        Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Theme.Line,
        BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 3,
    }, Top)
    -- faded logo sitting behind the "Morgan Hub" title
    local TitleLbl = New("TextLabel", {
        Size = UDim2.new(1, -150, 0, 22), Position = UDim2.new(0, 16, 0, 5), BackgroundTransparency = 1,
        Text = titleText, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3,
    }, Top)
    New("TextLabel", {
        Size = UDim2.new(1, -150, 0, 14), Position = UDim2.new(0, 16, 0, 26), BackgroundTransparency = 1,
        Text = subtitleText or "", TextColor3 = Theme.Sub, Font = Enum.Font.Gotham, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3,
    }, Top)

    -- logo badge + robust fallback. The same logo is also used by the open button.
    local titleW = 90
    pcall(function()
        local TextSvc = game:GetService("TextService")
        titleW = TextSvc:GetTextSize(titleText, 16, Enum.Font.GothamBold, Vector2.new(1000, 20)).X
    end)

    local LogoWrap = New("Frame", {
        Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0, 16 + titleW + 8, 0, 4),
        BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.08, BorderSizePixel = 0, ZIndex = 3,
    }, Top)
    Corner(LogoWrap, 8)
    Stroke(LogoWrap, Theme.Line, 1, 0.35)

    local Logo = New("ImageLabel", {
        Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2),
        BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, ZIndex = 4,
        Image = Cfg.LogoAsset or ("rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150"),
    }, LogoWrap)
    Corner(Logo, 6)

    local Emblem = New("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "M",
        TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBlack, TextSize = 14,
        Visible = true, ZIndex = 5,
    }, LogoWrap)
    Corner(Emblem, 8)

    Logo:GetPropertyChangedSignal("IsLoaded"):Connect(function()
        if Logo.IsLoaded then Emblem.Visible = false end
    end)
    if Logo.IsLoaded then Emblem.Visible = false end
    UI.Logo = Logo

    function UI.SetLogoAsset(asset)
        asset = tostring(asset or "")
        if asset == "" then return false end
        Logo.Image = asset
        Emblem.Visible = true
        if Logo.IsLoaded then Emblem.Visible = false end
        Cfg.LogoAsset = asset
        return true
    end

    function UI.SetLogoURL(url)
        if not url or url == "" then return false end
        if not (writefile and Ex.CustomAsset) then
            U.Notify("Logo", "Logo URL needs writefile + getcustomasset support.", 4)
            return false
        end
        local ok = pcall(function()
            local body = game:HttpGet(url)
            writefile("MorganLogo.png", body)
            Logo.Image = Ex.CustomAsset("MorganLogo.png")
            Logo.Visible = true
            Emblem.Visible = false
        end)
        if not ok then U.Notify("Logo", "Could not load that image URL.", 4) end
        return ok
    end

    local MinBtn = New("TextButton", {
        Size = UDim2.new(0, 42, 1, 0), Position = UDim2.new(1, -84, 0, 0),
        BackgroundTransparency = 1, Text = "−", TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 26, ZIndex = 3, AutoButtonColor = false,
    }, Top)
    local CloseBtn = New("TextButton", {
        Size = UDim2.new(0, 42, 1, 0), Position = UDim2.new(1, -42, 0, 0),
        BackgroundTransparency = 1, Text = "×", TextColor3 = Color3.fromRGB(255, 90, 90),
        Font = Enum.Font.GothamBold, TextSize = 22, ZIndex = 3, AutoButtonColor = false,
    }, Top)
    MinBtn.MouseEnter:Connect(function() tw(MinBtn, 0.15, {TextColor3 = Theme.Accent2, TextSize = 30}) end)
    MinBtn.MouseLeave:Connect(function() tw(MinBtn, 0.2, {TextColor3 = Theme.Text, TextSize = 26}) end)
    CloseBtn.MouseEnter:Connect(function() tw(CloseBtn, 0.15, {TextColor3 = Color3.fromRGB(255, 140, 140), TextSize = 25}) end)
    CloseBtn.MouseLeave:Connect(function() tw(CloseBtn, 0.2, {TextColor3 = Color3.fromRGB(255, 90, 90), TextSize = 22}) end)
    Top.Active = true
    MakeDraggable(Top, Main)

    -- floating open button: image logo + M fallback, matching the top logo.
    local Float = New("TextButton", {
        Size = UDim2.new(0, 50, 0, 50), AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.35, 0), BackgroundColor3 = Theme.Bg,
        BackgroundTransparency = 0.08, Text = "", Visible = false, AutoButtonColor = false,
    }, Gui)
    Corner(Float, 25)
    Stroke(Float, Theme.Line, 1.5, 0.25)

    local FloatLogo = New("ImageLabel", {
        Size = UDim2.new(1, -6, 1, -6), Position = UDim2.new(0, 3, 0, 3),
        BackgroundTransparency = 1, Image = Logo.Image, ScaleType = Enum.ScaleType.Crop, ZIndex = 2,
    }, Float)
    Corner(FloatLogo, 22)

    local FloatEmblem = New("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "M",
        TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBlack, TextSize = 22, ZIndex = 3,
    }, Float)
    Corner(FloatEmblem, 25)

    Logo:GetPropertyChangedSignal("Image"):Connect(function()
        FloatLogo.Image = Logo.Image
        FloatEmblem.Visible = not Logo.IsLoaded
    end)
    FloatEmblem.Visible = not Logo.IsLoaded

    local floatScale = New("UIScale", {Scale = 1}, Float)
    Float.MouseEnter:Connect(function() tw(floatScale, 0.2, {Scale = 1.12}, Enum.EasingStyle.Back) end)
    Float.MouseLeave:Connect(function() tw(floatScale, 0.2, {Scale = 1}) end)

    function UI.Show()
        Main.Visible = true
        Float.Visible = false
        UI.Scale.Scale = Cfg.UIScale * 0.86
        Main.BackgroundTransparency = 0.8
        tw(UI.Scale, 0.45, {Scale = Cfg.UIScale}, Enum.EasingStyle.Back)
        tw(Main, 0.4, {BackgroundTransparency = 0.1})
    end
    function UI.Hide()
        tw(UI.Scale, 0.22, {Scale = Cfg.UIScale * 0.86}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        tw(Main, 0.22, {BackgroundTransparency = 0.8})
        task.delay(0.24, function()
            Main.Visible = false
            Float.Visible = true
            UI.Scale.Scale = Cfg.UIScale
            Main.BackgroundTransparency = 0.1
            floatScale.Scale = 0.6
            tw(floatScale, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
        end)
    end
    MinBtn.MouseButton1Click:Connect(function() UI.Hide() end)
    Float.MouseButton1Click:Connect(function() UI.Show() end)
    CloseBtn.MouseButton1Click:Connect(function() U.Shutdown() end)

    -- SIDEBAR: background, clipped layer with the sliding selection pill, scrolling tab list
    local SideBg = New("Frame", {
        Size = UDim2.new(0, SW, 1, -44), Position = UDim2.new(0, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(4, 4, 10), BackgroundTransparency = 0.6, BorderSizePixel = 0, ZIndex = 2,
    }, Main)
    local SideClip = New("Frame", {
        Size = UDim2.new(0, SW, 1, -44), Position = UDim2.new(0, 0, 0, 44), BackgroundTransparency = 1,
        ClipsDescendants = true, ZIndex = 2,
    }, Main)
    local Pill = New("Frame", {
        Size = UDim2.new(1, -12, 0, 34), Position = UDim2.new(0, 6, 0, 0), BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.8, BorderSizePixel = 0, Visible = false, ZIndex = 2,
    }, SideClip)
    Corner(Pill, 8)
    local PillBar = New("Frame", {
        Size = UDim2.new(0, 3, 1, -14), Position = UDim2.new(0, 0, 0, 7), BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0, ZIndex = 3,
    }, Pill)
    Corner(PillBar, 2)

    local Side = New("ScrollingFrame", {
        Size = UDim2.new(0, SW, 1, -44), Position = UDim2.new(0, 0, 0, 44),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Line,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3,
    }, Main)
    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, Side)
    Pad(Side, 6, 6, 6, 6)

    -- profile card
    local Card = New("Frame", {
        Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.5,
        BorderSizePixel = 0, LayoutOrder = 0, ZIndex = 4,
    }, Side)
    Corner(Card, 10)
    local Av = New("ImageLabel", {
        Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0, 7, 0.5, -16),
        BackgroundColor3 = Theme.Bg, BorderSizePixel = 0, ZIndex = 5,
    }, Card)
    Corner(Av, 16)
    New("TextLabel", {
        Size = UDim2.new(1, -48, 0, 16), Position = UDim2.new(0, 45, 0, 7), BackgroundTransparency = 1,
        Text = LocalPlayer.DisplayName, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
    }, Card)
    UI.ProfileSub = New("TextLabel", {
        Size = UDim2.new(1, -48, 0, 14), Position = UDim2.new(0, 45, 0, 24), BackgroundTransparency = 1,
        Text = "Level ...", TextColor3 = Theme.Sub, Font = Enum.Font.Gotham, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
    }, Card)
    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and img then Av.Image = img end
    end)

    local Content = New("Frame", {
        Size = UDim2.new(1, -SW, 1, -44), Position = UDim2.new(0, SW, 0, 44),
        BackgroundTransparency = 1, ZIndex = 2,
    }, Main)

    local Window = {Tabs = {}, Gui = Gui, Main = Main}

    -- pill position for tab index (profile card 54 + paddings, every tab is 38 + 4 spacing)
    local function pillY(idx)
        return 6 + 46 + 4 + (idx - 1) * 38 - Side.CanvasPosition.Y
    end
    function UI.RefreshPill()
        if Window.Selected then Pill.Position = UDim2.new(0, 6, 0, pillY(Window.Selected.idx)) end
    end
    U.Conn(Side:GetPropertyChangedSignal("CanvasPosition"), function() UI.RefreshPill() end)

    function Window:CreateTab(name, icon)
        local idx = #Window.Tabs + 1
        local Btn = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1,
            Text = " " .. (icon or "") .. " " .. name, TextColor3 = Theme.Sub, Font = Enum.Font.GothamMedium,
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
            AutoButtonColor = false, LayoutOrder = idx, ZIndex = 4,
        }, Side)
        Pad(Btn, 6, 0, 0, 0)

        local Group = New("CanvasGroup", {
            Size = UDim2.new(1, -8, 1, -8), Position = UDim2.new(0, 4, 0, 4), BackgroundTransparency = 1,
            GroupTransparency = 1, Visible = false, ZIndex = 3,
        }, Content)
        local Page = New("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Line,
            ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3,
        }, Group)
        New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)}, Page)
        Pad(Page, 6, 6, 10, 10)

        local TabData = {Btn = Btn, Group = Group, Page = Page, idx = idx}
        table.insert(Window.Tabs, TabData)

        local function Select()
            if Window.Selected == TabData then return end
            local first = Window.Selected == nil
            for _, t in ipairs(Window.Tabs) do
                if t ~= TabData then
                    t.Group.Visible = false
                    tw(t.Btn, 0.25, {TextColor3 = Theme.Sub})
                end
            end
            Window.Selected = TabData
            tw(Btn, 0.25, {TextColor3 = Theme.Text})
            Group.Position = UDim2.new(0, 30, 0, 4)
            Group.GroupTransparency = 1
            Group.Visible = true
            tw(Group, 0.4, {Position = UDim2.new(0, 4, 0, 4), GroupTransparency = 0})
            Pill.Visible = true
            if first then
                Pill.Position = UDim2.new(0, 6, 0, pillY(idx))
            else
                tw(Pill, 0.38, {Position = UDim2.new(0, 6, 0, pillY(idx))}, Enum.EasingStyle.Quint)
            end
        end
        Btn.MouseButton1Click:Connect(Select)
        Btn.MouseEnter:Connect(function()
            if Window.Selected ~= TabData then tw(Btn, 0.15, {TextColor3 = Theme.Text}) end
        end)
        Btn.MouseLeave:Connect(function()
            if Window.Selected ~= TabData then tw(Btn, 0.2, {TextColor3 = Theme.Sub}) end
        end)
        if idx == 1 then Select() end

        local Tab = {Page = Page}
        local order = 0
        local function nextOrder() order = order + 1 return order end

        function Tab:Section(text)
            New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Text = string.upper(text),
                TextColor3 = Theme.Sub, Font = Enum.Font.GothamBold, TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom,
                LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
        end

        -- two big hero switches (used on the Home tab)
        function Tab:BigToggle(title, subtitle, default, callback, key, colA, colB)
            local state = default and true or false
            local card = New("Frame", {
                Size = UDim2.new(1, 0, 0, 74), BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = state and 0.4 or 0.78, BorderSizePixel = 0, ClipsDescendants = true,
                LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(card, 12)
            New("UIGradient", {Color = ColorSequence.new(colA, colB), Rotation = 20}, card)
            local st = Stroke(card, colB, 1.5, state and 0.4 or 0.75)
            New("TextLabel", {
                Size = UDim2.new(1, -100, 0, 24), Position = UDim2.new(0, 14, 0, 10), BackgroundTransparency = 1,
                Text = title, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 15,
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
            }, card)
            local sub = New("TextLabel", {
                Size = UDim2.new(1, -100, 0, 30), Position = UDim2.new(0, 14, 0, 36), BackgroundTransparency = 1,
                Text = subtitle, TextColor3 = Color3.fromRGB(225, 225, 245), Font = Enum.Font.Gotham, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true, ZIndex = 4,
            }, card)
            local pill = New("TextLabel", {
                Size = UDim2.new(0, 64, 0, 30), Position = UDim2.new(1, -78, 0.5, -15),
                BackgroundColor3 = Color3.fromRGB(10, 10, 20), BackgroundTransparency = 0.25,
                Text = state and "ON" or "OFF", TextColor3 = state and Color3.fromRGB(110, 255, 160) or Theme.Sub,
                Font = Enum.Font.GothamBlack, TextSize = 13, ZIndex = 4,
            }, card)
            Corner(pill, 15)
            local hit = New("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 6}, card)
            local obj = {}
            function obj.Set(v, silent)
                state = v and true or false
                pill.Text = state and "ON" or "OFF"
                tw(pill, 0.25, {TextColor3 = state and Color3.fromRGB(110, 255, 160) or Theme.Sub})
                tw(card, 0.3, {BackgroundTransparency = state and 0.4 or 0.78})
                tw(st, 0.3, {Transparency = state and 0.4 or 0.75})
                if not silent then
                    local ok, err = pcall(callback, state)
                    if not ok then U.Log(err) end
                end
            end
            function obj.Get() return state end
            function obj.SetStatus(t) sub.Text = tostring(t) end
            hit.MouseEnter:Connect(function() tw(card, 0.2, {BackgroundTransparency = state and 0.3 or 0.65}) end)
            hit.MouseLeave:Connect(function() tw(card, 0.25, {BackgroundTransparency = state and 0.4 or 0.78}) end)
            hit.MouseButton1Down:Connect(function(x, y) Ripple(hit, x, y) end)
            hit.MouseButton1Click:Connect(function() obj.Set(not state) end)
            if key then UI.T[key] = obj end
            return obj
        end

        -- row of small stat cards, returns {Set = function(index, text)}
        function Tab:StatRow(captions)
            local n = #captions
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, row)
            local values = {}
            for i, cap in ipairs(captions) do
                local c = New("Frame", {
                    Size = UDim2.new(1 / n, -6 * (n - 1) / n, 1, 0), BackgroundColor3 = Theme.Card,
                    BackgroundTransparency = 0.5, BorderSizePixel = 0, LayoutOrder = i, ZIndex = 3,
                }, row)
                Corner(c, 10)
                values[i] = New("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 28), Position = UDim2.new(0, 0, 0, 6), BackgroundTransparency = 1,
                    Text = "-", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 18, ZIndex = 4,
                }, c)
                New("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 32), BackgroundTransparency = 1,
                    Text = cap, TextColor3 = Theme.Sub, Font = Enum.Font.Gotham, TextSize = 9, ZIndex = 4,
                }, c)
            end
            return {Set = function(i, text) if values[i] then values[i].Text = tostring(text) end end}
        end

        function Tab:Label(text)
            local l = New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Text = text,
                TextColor3 = Theme.Sub, Font = Enum.Font.Gotham, TextSize = 11, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Pad(l, 4, 2, 4, 2)
            return {Set = function(t) l.Text = tostring(t) end}
        end

        function Tab:Button(text, callback)
            local b = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.6,
                Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12,
                AutoButtonColor = false, BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(b, 8)
            local pressScale = New("UIScale", {Scale = 1}, b)
            b.MouseButton1Down:Connect(function(x, y)
                tw(pressScale, 0.1, {Scale = 0.96})
                Ripple(b, x, y)
            end)
            b.MouseButton1Up:Connect(function() tw(pressScale, 0.25, {Scale = 1}, Enum.EasingStyle.Back) end)
            b.MouseEnter:Connect(function() tw(b, 0.2, {BackgroundTransparency = 0.4}) end)
            b.MouseLeave:Connect(function()
                tw(pressScale, 0.2, {Scale = 1})
                tw(b, 0.25, {BackgroundTransparency = 0.6})
            end)
            b.MouseButton1Click:Connect(function() U.Spawn(callback) end)
        end

        function Tab:Toggle(text, default, callback, key)
            local state = default and true or false
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.5,
                BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(row, 8)
            New("TextLabel", {
                Size = UDim2.new(1, -66, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1,
                Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
            }, row)
            local track = New("Frame", {
                Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -52, 0.5, -11),
                BackgroundColor3 = state and Theme.Accent or Theme.Off, BorderSizePixel = 0, ZIndex = 4,
            }, row)
            Corner(track, 11)
            local knob = New("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = state and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2),
                BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 5,
            }, track)
            Corner(knob, 9)
            local hit = New("TextButton", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 6,
            }, row)

            local obj = {}
            function obj.Set(v, silent)
                state = v and true or false
                tw(knob, 0.3, {Position = state and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)}, Enum.EasingStyle.Back)
                tw(track, 0.25, {BackgroundColor3 = state and Theme.Accent or Theme.Off})
                if not silent then
                    local ok, err = pcall(callback, state)
                    if not ok then U.Log(err) end
                end
            end
            function obj.Get() return state end
            hit.MouseEnter:Connect(function() tw(row, 0.2, {BackgroundTransparency = 0.35}) end)
            hit.MouseLeave:Connect(function() tw(row, 0.25, {BackgroundTransparency = 0.5}) end)
            hit.MouseButton1Click:Connect(function() obj.Set(not state) end)
            if key then UI.T[key] = obj end
            return obj
        end

        function Tab:Input(text, placeholder, default, callback)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.5,
                BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(row, 8)
            local st = Stroke(row, Theme.Line, 1, 1)
            New("TextLabel", {
                Size = UDim2.new(0.34, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1,
                Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
            }, row)
            local box = New("TextBox", {
                Size = UDim2.new(0.66, -20, 0, 26), Position = UDim2.new(0.34, 8, 0.5, -13),
                BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.3, Text = default or "",
                PlaceholderText = placeholder or "", TextColor3 = Theme.Text, PlaceholderColor3 = Theme.Sub,
                Font = Enum.Font.Gotham, TextSize = 11, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
            }, row)
            Corner(box, 6)
            Pad(box, 8, 0, 8, 0)
            box.Focused:Connect(function() tw(st, 0.2, {Color = Theme.Accent2, Transparency = 0.1}) end)
            box.FocusLost:Connect(function()
                tw(st, 0.25, {Color = Theme.Line, Transparency = 1})
                local ok, err = pcall(callback, box.Text)
                if not ok then U.Log(err) end
            end)
            return {Get = function() return box.Text end, Set = function(t) box.Text = t end}
        end

        -- multi-line box for longer text (bug reports)
        function Tab:TextArea(text, placeholder, height, callback)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, height or 90), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.5,
                BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(row, 8)
            local st = Stroke(row, Theme.Line, 1, 1)
            New("TextLabel", {
                Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 12, 0, 4), BackgroundTransparency = 1,
                Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4,
            }, row)
            local box = New("TextBox", {
                Size = UDim2.new(1, -20, 1, -34), Position = UDim2.new(0, 10, 0, 26),
                BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.3, Text = "", PlaceholderText = placeholder or "",
                TextColor3 = Theme.Text, PlaceholderColor3 = Theme.Sub, Font = Enum.Font.Gotham, TextSize = 12,
                ClearTextOnFocus = false, MultiLine = true, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 4,
            }, row)
            Corner(box, 6)
            Pad(box, 8, 6, 8, 6)
            box.Focused:Connect(function() tw(st, 0.2, {Color = Theme.Accent2, Transparency = 0.1}) end)
            box.FocusLost:Connect(function()
                tw(st, 0.25, {Color = Theme.Line, Transparency = 1})
                local ok, err = pcall(callback, box.Text)
                if not ok then U.Log(err) end
            end)
            return {Get = function() return box.Text end, Set = function(t) box.Text = t end}
        end

        function Tab:Dropdown(text, options, default, callback)
            local holder = New("Frame", {
                Size = UDim2.new(1, 0, 0, 38), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.5, BorderSizePixel = 0,
                ClipsDescendants = true, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(holder, 8)
            local st = Stroke(holder, Theme.Line, 1, 1)
            New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, holder)
            local head = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1, Text = "", LayoutOrder = 1, ZIndex = 4,
            }, holder)
            New("TextLabel", {
                Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1,
                Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
            }, head)
            local val = New("TextLabel", {
                Size = UDim2.new(0.5, -34, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1,
                Text = tostring(default or "-"), TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBold,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 5,
            }, head)
            local arrow = New("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -26, 0, 0), BackgroundTransparency = 1,
                Text = "v", TextColor3 = Theme.Sub, Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 5,
            }, head)
            local list = New("ScrollingFrame", {
                Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
                ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, LayoutOrder = 2, ZIndex = 4,
            }, holder)
            New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)}, list)
            Pad(list, 6, 2, 6, 4)

            local obj = {Value = default}
            local open, targetH = false, 0
            local function setOpen(v)
                open = v
                if v then
                    list.Size = UDim2.new(1, 0, 0, 0)
                    list.Visible = true
                    tw(list, 0.32, {Size = UDim2.new(1, 0, 0, targetH)})
                    tw(arrow, 0.3, {Rotation = 180})
                    tw(st, 0.2, {Color = Theme.Accent, Transparency = 0.3})
                else
                    tw(list, 0.22, {Size = UDim2.new(1, 0, 0, 0)})
                    tw(arrow, 0.25, {Rotation = 0})
                    tw(st, 0.25, {Color = Theme.Line, Transparency = 1})
                    task.delay(0.24, function() if not open then list.Visible = false end end)
                end
            end
            local function build(opts)
                for _, c in ipairs(list:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for i, o in ipairs(opts) do
                    local ob = New("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.35,
                        Text = tostring(o), TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12,
                        AutoButtonColor = false, LayoutOrder = i, ZIndex = 5,
                    }, list)
                    Corner(ob, 6)
                    ob.MouseEnter:Connect(function() tw(ob, 0.15, {BackgroundTransparency = 0.1, BackgroundColor3 = Theme.Accent}) end)
                    ob.MouseLeave:Connect(function() tw(ob, 0.2, {BackgroundTransparency = 0.35, BackgroundColor3 = Theme.Bg}) end)
                    ob.MouseButton1Click:Connect(function()
                        obj.Value = o
                        val.Text = tostring(o)
                        setOpen(false)
                        local ok, err = pcall(callback, o)
                        if not ok then U.Log(err) end
                    end)
                end
                targetH = math.min(#opts * 30 + 6, 156)
                if open then list.Size = UDim2.new(1, 0, 0, targetH) end
            end
            function obj.SetOptions(opts) build(opts) end
            head.MouseEnter:Connect(function() tw(holder, 0.2, {BackgroundTransparency = 0.35}) end)
            head.MouseLeave:Connect(function() tw(holder, 0.25, {BackgroundTransparency = 0.5}) end)
            head.MouseButton1Click:Connect(function() setOpen(not open) end)
            build(options)
            return obj
        end

        function Tab:Slider(text, min, max, default, callback, step)
            step = step or 1
            local value = default
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.5,
                BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(row, 8)
            local st = Stroke(row, Theme.Line, 1, 1)
            New("TextLabel", {
                Size = UDim2.new(0.68, 0, 0, 22), Position = UDim2.new(0, 12, 0, 4), BackgroundTransparency = 1,
                Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
            }, row)
            local vlbl = New("TextLabel", {
                Size = UDim2.new(0.32, -12, 0, 22), Position = UDim2.new(0.68, 0, 0, 4), BackgroundTransparency = 1,
                Text = tostring(default), TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBold, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4,
            }, row)
            local track = New("Frame", {
                Size = UDim2.new(1, -24, 0, 4), Position = UDim2.new(0, 12, 0, 35),
                BackgroundColor3 = Theme.Off, BorderSizePixel = 0, ZIndex = 4,
            }, row)
            Corner(track, 2)
            local fill = New("Frame", {
                Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0),
                BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 5,
            }, track)
            Corner(fill, 2)
            New("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.Accent2)}, fill)
            local knob = New("Frame", {
                Size = UDim2.new(0, 12, 0, 12), AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0, ZIndex = 6,
            }, fill)
            Corner(knob, 9)
            local hit = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 24), BackgroundTransparency = 1,
                Text = "", ZIndex = 7,
            }, row)

            local dragging = false
            local function setFromX(x)
                local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                local raw = min + (max - min) * rel
                value = math.floor(raw / step + 0.5) * step
                value = math.clamp(value, min, max)
                value = math.floor(value * 1000 + 0.5) / 1000
                tw(fill, 0.08, {Size = UDim2.new((value - min) / (max - min), 0, 1, 0)}, Enum.EasingStyle.Quad)
                vlbl.Text = tostring(value)
                local ok, err = pcall(callback, value)
                if not ok then U.Log(err) end
            end
            hit.MouseEnter:Connect(function() tw(st, 0.2, {Color = Theme.Accent, Transparency = 0.35}) end)
            hit.MouseLeave:Connect(function()
                if not dragging then tw(st, 0.25, {Color = Theme.Line, Transparency = 1}) end
            end)
            hit.InputBegan:Connect(function(input)
                if IsPointer(input) then
                    dragging = true
                    tw(knob, 0.2, {Size = UDim2.new(0, 17, 0, 17)}, Enum.EasingStyle.Back)
                    setFromX(input.Position.X)
                end
            end)
            U.Conn(UserInputService.InputChanged, function(input)
                if dragging and IsMove(input) then setFromX(input.Position.X) end
            end)
            U.Conn(UserInputService.InputEnded, function(input)
                if IsPointer(input) and dragging then
                    dragging = false
                    tw(knob, 0.25, {Size = UDim2.new(0, 12, 0, 12)})
                    tw(st, 0.25, {Color = Theme.Line, Transparency = 1})
                end
            end)
        end

        return Tab
    end

    UI.Window = Window
    UI.SetTheme(Cfg.Theme or "Rain")
    UI.Show()
    return Window
end

-- =============================================================================
-- MOVEMENT  (tween, noclip, float, fly, speed, jump)
-- =============================================================================
Move.Goal, Move.Speed, Move.Left, Move.Teleporting, Move.TpToken = nil, 200, 0, false, 0

function Move.Cancel()
    Move.Goal = nil
end

-- Returns true when already at (or snapped onto) the target. Otherwise the target becomes the goal and the
-- Heartbeat stepper below flies there at Tween Speed studs per second (no TweenService, nothing to get stuck).
function Move.To(cf, speed)
    local root = U.Root()
    if not root then return false end
    local hum = U.Hum()
    if hum and hum.Sit then hum.Sit = false end
    local dist = (root.Position - cf.Position).Magnitude
    if dist < 35 then
        Move.Goal = nil
        Move.Left = 0
        root.CFrame = cf
        return true
    end
    Move.Goal = cf
    Move.Speed = speed or Cfg.TweenSpeed
    Move.Left = dist
    return false
end

function Move.Step(dt)
    local goal = Move.Goal
    if not goal then return end
    local root = U.Root()
    if not root then
        Move.Goal = nil
        return
    end
    local delta = goal.Position - root.Position
    local dist = delta.Magnitude
    if dist < 35 then
        root.CFrame = goal
        Move.Goal = nil
        Move.Left = 0
        return
    end
    local step = math.min(Move.Speed * dt, dist)
    root.CFrame = root.CFrame + delta.Unit * step
    Move.Left = dist - step
end

U.Conn(RunService.Heartbeat, function(dt) Move.Step(math.min(dt, 0.1)) end)

function Move.AutoActive()
    return Cfg.AutoFarm or Cfg.FarmNearest or Cfg.FarmMob or Cfg.FarmBoss or Cfg.PirateRaid
        or Cfg.EliteHunter or Cfg.AutoChest or Cfg.AutoCollectFruit or Cfg.PvpKill or Cfg.PvpHunt
        or Cfg.BoneFarm or Cfg.MasteryFarm or Cfg.AutoRaid or Move.Teleporting
end

-- Blocking teleport (used by buttons, run inside task.spawn)
function Move.Go(pos, ent)
    Move.TpToken = Move.TpToken + 1
    local token = Move.TpToken
    Move.Teleporting = true
    local root = U.Root()
    if root and ent and (root.Position - pos).Magnitude > 8000 then
        U.Comm("requestEntrance", ent)
        task.wait(1.2)
    end
    local start = os.clock()
    while U.Alive() and Move.TpToken == token do
        root = U.Root()
        if not root then break end
        if Move.To(CF(pos)) then break end
        if os.clock() - start > 150 then break end
        task.wait(0.1)
    end
    if Move.TpToken == token then
        Move.Teleporting = false
        Move.Cancel()
    end
end

function Move.StopTeleport()
    Move.TpToken = Move.TpToken + 1
    Move.Teleporting = false
    Move.Cancel()
end

-- noclip + hover while automation is running
U.Conn(RunService.Stepped, function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local auto = Move.AutoActive()
    if auto or Cfg.Noclip then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end
    local f = root:FindFirstChild("MorganFloat")
    if auto and not Cfg.Fly then
        if not f then
            f = Instance.new("BodyVelocity")
            f.Name = "MorganFloat"
            f.MaxForce = V3(1e9, 1e9, 1e9)
            f.Velocity = V3(0, 0, 0)
            f.Parent = root
        end
        root.AssemblyLinearVelocity = V3(0, 0, 0)
    elseif f then
        f:Destroy()
    end
end)

-- manual fly (uses the joystick / WASD + camera pitch)
U.Conn(RunService.Heartbeat, function()
    local root, hum = U.Root(), U.Hum()
    if not root or not hum then return end
    local bv = root:FindFirstChild("MorganFly")
    if not Cfg.Fly then
        if bv then bv:Destroy() end
        return
    end
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "MorganFly"
        bv.MaxForce = V3(1e9, 1e9, 1e9)
        bv.Velocity = V3(0, 0, 0)
        bv.Parent = root
    end
    local cam = Workspace.CurrentCamera
    local mv = hum.MoveDirection
    if mv.Magnitude > 0 then
        local look = cam.CFrame.LookVector
        local flat = V3(look.X, 0, look.Z)
        local sign = 1
        if flat.Magnitude > 0 then sign = (mv:Dot(flat.Unit) >= -0.2) and 1 or -1 end
        bv.Velocity = V3(mv.X * Cfg.FlySpeed, look.Y * Cfg.FlySpeed * sign, mv.Z * Cfg.FlySpeed)
    else
        bv.Velocity = V3(0, 0, 0)
    end
end)

-- walk speed / jump power
U.Conn(RunService.Heartbeat, function()
    local hum = U.Hum()
    if not hum then return end
    if Cfg.Speed then hum.WalkSpeed = Cfg.SpeedVal end
    if Cfg.Jump then
        hum.UseJumpPower = true
        hum.JumpPower = Cfg.JumpVal
    end
end)

U.Conn(UserInputService.JumpRequest, function()
    if Cfg.InfJump then
        local hum = U.Hum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- =============================================================================
-- COMBAT  (fast attack + auto skills)
-- =============================================================================
Combat.Want, Combat.Last, Combat.LastClick, Combat.Extra = 0, 0, 0, nil

function Combat.Request() Combat.Want = os.clock() end

task.spawn(function()
    local mods = ReplicatedStorage:WaitForChild("Modules", 20)
    local net = mods and mods:WaitForChild("Net", 20)
    if net then
        Combat.RegAttack = net:FindFirstChild("RE/RegisterAttack")
        Combat.RegHit = net:FindFirstChild("RE/RegisterHit")
    end
end)

task.spawn(function()
    pcall(function()
        local ps = LocalPlayer:WaitForChild("PlayerScripts")
        local cfm = ps:WaitForChild("CombatFramework", 15)
        if cfm and Ex.GetUpvalues then
            local ups = Ex.GetUpvalues(require(cfm))
            for _, v in pairs(ups) do
                if type(v) == "table" and v.activeController ~= nil then
                    Combat.Framework = v
                    break
                end
            end
            if not Combat.Framework then Combat.Framework = ups[2] end
        end
    end)
end)

-- some game versions need extra arguments on the hit remote (flag lives in Modules.Flags)
task.spawn(function()
    pcall(function()
        local mods = ReplicatedStorage:WaitForChild("Modules", 20)
        local fl = mods and mods:FindFirstChild("Flags")
        if fl then
            Combat.RemoteThread = require(fl).COMBAT_REMOTE_THREAD
            if Combat.RemoteThread == false then Combat.ProfileIdx = 2 end
        end
    end)
end)

function Combat.Targets(range)
    local root = U.Root()
    if not root then return nil, nil end
    local list, main = {}, nil
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, m in ipairs(enemies:GetChildren()) do
            local r = U.MobAlive(m)
            if r and (r.Position - root.Position).Magnitude <= range then
                local part = m:FindFirstChild("Head") or r
                list[#list + 1] = {m, part}
                main = main or part
            end
        end
    end
    local ex = Combat.Extra
    if ex and ex.Parent then
        local r = ex:FindFirstChild("HumanoidRootPart")
        local h = ex:FindFirstChildOfClass("Humanoid")
        if r and h and h.Health > 0 and (r.Position - root.Position).Magnitude <= range then
            local part = ex:FindFirstChild("Head") or r
            list[#list + 1] = {ex, part}
            main = main or part
        end
    end
    return list, main
end

function Combat.HitId()
    return tostring(LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15)
end

-- Batched hit packet (modern Blox Fruits combat remotes). variant 4 = with id + extra table, 2 = plain.
function Combat.Net(variant)
    if not (Combat.RegAttack and Combat.RegHit) then return end
    local list, main = Combat.Targets(Cfg.AttackRange)
    if not main or #list == 0 then return end
    Combat.RegAttack:FireServer(0)
    if variant == 2 then
        Combat.RegHit:FireServer(main, list)
    else
        Combat.RegHit:FireServer(main, list, {}, Combat.HitId())
    end
end

-- Classic CombatFramework controller speed-up. Best-effort.
function Combat.FrameworkAttack()
    local fw = Combat.Framework
    if not fw then return end
    local ac = fw.activeController
    if ac and ac.equipped then
        ac.timeToNextAttack = 0
        ac.hitboxMagnitude = Cfg.AttackRange
        ac.attacking = false
        if ac.attack then ac:attack() end
    end
end

-- Clicks land on the far right edge of the screen so they never hit this hub's own window.
function Combat.Click(method, activate)
    local cam = Workspace.CurrentCamera
    method = method or Cfg.ClickMethod
    if method ~= "VirtualInputManager" then
        VirtualUser:CaptureController()
        VirtualUser:Button1Down(Vector2.new(1280, 672), cam.CFrame)
        VirtualUser:Button1Up(Vector2.new(1280, 672), cam.CFrame)
    end
    if method == "VirtualInputManager" or method == "Both" then
        local vp = cam.ViewportSize
        local x, y = vp.X - 3, vp.Y * 0.6
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end
    if activate then
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end
end

-- Attack methods. Auto-Detect walks through them until the target's health really drops.
Combat.Profiles = {
    {name = "Net (4 args) + Click", net = 4, fw = true, click = "VirtualUser"},
    {name = "Net (2 args) + Click", net = 2, fw = true, click = "VirtualUser"},
    {name = "Click (VirtualUser)", click = "VirtualUser"},
    {name = "Click (mouse events + Tool:Activate)", click = "VirtualInputManager", activate = true},
    {name = "Framework + Click", fw = true, click = "VirtualUser"},
}
Combat.ProfileIdx = 1

function Combat.Profile()
    local m = Cfg.AttackMode
    if m == "Auto-Detect" then return Combat.Profiles[Combat.ProfileIdx] end
    if m == "Ultra (Net+Combat)" then return Combat.Profiles[1] end
    if m == "Combat Framework" then return Combat.Profiles[5] end
    return Combat.Profiles[3] -- "Click Only"
end

-- watches the mob we are hitting; if its health does not move for 5s while we are next to it, try the next method
function Combat.Observe(target)
    if Cfg.AttackMode ~= "Auto-Detect" then return end
    local h = target:FindFirstChildOfClass("Humanoid")
    local root = U.Root()
    local tr = target:FindFirstChild("HumanoidRootPart")
    if not h or not root or not tr then return end
    if (root.Position - tr.Position).Magnitude > 45 then
        Combat.Obs = nil
        return
    end
    local now = os.clock()
    local o = Combat.Obs
    if not o or o.mob ~= target then
        Combat.Obs = {mob = target, hp = h.Health, t = now}
        return
    end
    if h.Health < o.hp then
        o.hp, o.t = h.Health, now
        Combat.Works = Combat.ProfileIdx
        return
    end
    o.hp = h.Health
    if now - o.t > 5 then
        o.t = now
        Combat.ProfileIdx = Combat.ProfileIdx % #Combat.Profiles + 1
        UI.Notify("Fast Attack", "No damage yet, trying: " .. Combat.Profiles[Combat.ProfileIdx].name, 4)
    end
end

U.Conn(RunService.Heartbeat, function()
    local now = os.clock()
    if now - Combat.Want > 0.35 then return end
    local prof = Combat.Profile()
    local wt = Farm.Weapon()
    if Cfg.FastAttack and (wt == "Melee" or wt == "Sword") and now - Combat.Last >= 0.03 then
        Combat.Last = now
        if prof.net then pcall(Combat.Net, prof.net) end
        if prof.fw then pcall(Combat.FrameworkAttack) end
    end
    if now - Combat.LastClick >= 0.2 then
        Combat.LastClick = now
        pcall(Combat.Click, prof.click, prof.activate)
    end
end)

-- auto skills (key presses)
function Combat.PressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

U.Loop(0.6, function()
    if os.clock() - Combat.Want > 1 then return end
    local m = Cfg.MasteryFarm
    if Cfg.SkillZ or m then Combat.PressKey(Enum.KeyCode.Z) end
    if Cfg.SkillX or m then Combat.PressKey(Enum.KeyCode.X) end
    if Cfg.SkillC or m then Combat.PressKey(Enum.KeyCode.C) end
    if Cfg.SkillV or m then Combat.PressKey(Enum.KeyCode.V) end
    if Cfg.SkillF then Combat.PressKey(Enum.KeyCode.F) end
end)

-- =============================================================================
-- FARM
-- =============================================================================
Farm.StatusText = "Idle"
Farm.Target = nil
Farm.LastEquip, Farm.LastBuso, Farm.LastKen, Farm.LastAbandon = 0, 0, 0, 0
Farm.QuestWait, Farm.LastSim, Farm.LastEntrance, Farm.LastTravel = 0, 0, 0, 0
Farm.LastElite, Farm.LastSubmerged = 0, 0

function Farm.Status(t) Farm.StatusText = t end

-- ---------- weapon / haki ----------
function Farm.GetTool(tp)
    local char = LocalPlayer.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t.ToolTip == tp then return t, true end
        end
    end
    for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if t:IsA("Tool") and t.ToolTip == tp then return t, false end
    end
    return nil, false
end

-- with plain clicks the hitbox is short, so hover closer; the fast-attack modes reach further
function Farm.Height()
    if Cfg.FastAttack and Cfg.AttackMode ~= "Click Only" then return Cfg.FarmHeight end
    return math.min(Cfg.FarmHeight, 7)
end

function Farm.Weapon()
    if Cfg.MasteryFarm then return Cfg.MasteryType end
    return Cfg.WeaponType
end

-- Re-equips the selected weapon type. Runs every tick, so it also fixes respawns.
function Farm.EquipSelected()
    if os.clock() - Farm.LastEquip < 0.25 then return end
    Farm.LastEquip = os.clock()
    local hum = U.Hum()
    if not hum or hum.Health <= 0 then return end
    local tool, equipped = Farm.GetTool(Farm.Weapon())
    if tool and not equipped then hum:EquipTool(tool) end
end

function Farm.Prep()
    Farm.EquipSelected()
    local char = LocalPlayer.Character
    if Cfg.AutoBuso and char and not char:FindFirstChild("HasBuso") and os.clock() - Farm.LastBuso > 4 then
        Farm.LastBuso = os.clock()
        U.Spawn(function() U.Comm("Buso") end)
    end
    if Cfg.AutoKen and os.clock() - Farm.LastKen > 3 then
        Farm.LastKen = os.clock()
        pcall(function() ReplicatedStorage.Remotes.CommE:FireServer("Ken", true) end)
    end
end

-- ---------- mob helpers ----------
function Farm.FindMobs(name)
    local list = {}
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return list end
    local ln = name:lower()
    for _, m in ipairs(enemies:GetChildren()) do
        if U.MobAlive(m) and U.CleanName(m.Name):lower() == ln then list[#list + 1] = m end
    end
    if #list == 0 then -- fallback: partial name match
        for _, m in ipairs(enemies:GetChildren()) do
            if U.MobAlive(m) and U.CleanName(m.Name):lower():find(ln, 1, true) then list[#list + 1] = m end
        end
    end
    return list
end

function Farm.Nearest(list, pos)
    local best, bd
    for _, m in ipairs(list) do
        local d = (m.HumanoidRootPart.Position - pos).Magnitude
        if not bd or d < bd then best, bd = m, d end
    end
    return best
end

function Farm.TemplatePos(name)
    local ln = name:lower()
    for _, o in ipairs(ReplicatedStorage:GetChildren()) do
        if o:IsA("Model") and U.CleanName(o.Name):lower():find(ln, 1, true) then
            local r = o:FindFirstChild("HumanoidRootPart")
            if r then return r.Position end
        end
    end
    return nil
end

function Farm.Sim()
    if os.clock() - Farm.LastSim < 1 then return end
    Farm.LastSim = os.clock()
    if Ex.SetHidden then pcall(Ex.SetHidden, LocalPlayer, "SimulationRadius", math.huge) end
    pcall(function() LocalPlayer.MaximumSimulationRadius = math.huge end)
end

-- Magnet: pulls mobs onto the target and enlarges their hitbox
function Farm.Bring(target, name)
    if not Cfg.BringMobs then return end
    local enemies = Workspace:FindFirstChild("Enemies")
    local tr = target and target:FindFirstChild("HumanoidRootPart")
    if not enemies or not tr then return end
    Farm.Sim()
    local ln = name and name:lower()
    for _, m in ipairs(enemies:GetChildren()) do
        local r = U.MobAlive(m)
        if r and (not ln or U.CleanName(m.Name):lower() == ln) then
            if m == target or (r.Position - tr.Position).Magnitude <= Cfg.BringRadius then
                if m ~= target then r.CFrame = tr.CFrame end
                r.CanCollide = false
                if Cfg.Hitbox then r.Size = V3(Cfg.HitboxSize, Cfg.HitboxSize, Cfg.HitboxSize) end
                local h = m:FindFirstChildOfClass("Humanoid")
                if h then
                    h.WalkSpeed = 0
                    h.JumpPower = 0
                end
                local head = m:FindFirstChild("Head")
                if head then head.CanCollide = false end
            end
        end
    end
end

-- ---------- quest data lookup ----------
function Farm.FindMobSpawn(name)
    local ln = name:lower()
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, m in ipairs(enemies:GetChildren()) do
            local r = U.MobAlive(m)
            if r and U.CleanName(m.Name):lower() == ln then return r.Position end
        end
    end
    for _, o in ipairs(ReplicatedStorage:GetChildren()) do
        if o:IsA("Model") and U.CleanName(o.Name):lower() == ln then
            local r = o:FindFirstChild("HumanoidRootPart")
            if r then return r.Position end
        end
    end
    local wo = Workspace:FindFirstChild("_WorldOrigin")
    local spawns = wo and wo:FindFirstChild("EnemySpawns")
    if spawns then
        for _, s in ipairs(spawns:GetChildren()) do
            if s:IsA("BasePart") and U.CleanName(s.Name):lower() == ln then return s.Position end
        end
    end
    return nil
end

function Farm.FindNPC(pattern, near)
    local npcs = Workspace:FindFirstChild("NPCs")
    if not npcs then return nil end
    local best, bd
    for _, n in ipairs(npcs:GetChildren()) do
        if n.Name:lower():find(pattern, 1, true) then
            local p = n:FindFirstChild("HumanoidRootPart") or n.PrimaryPart or n:FindFirstChildWhichIsA("BasePart", true)
            if p then
                local d = near and (p.Position - near).Magnitude or 0
                if not bd or d < bd then best, bd = p.Position, d end
            end
        end
    end
    if near and bd and bd > 4000 then return nil end
    return best
end

-- Resolve a quest row from the live quest module. For Submerged Island we
-- use the known level/mob route first, instead of choosing an arbitrary
-- highest-LevelReq quest from pairs(), which can select the wrong quest.
function Farm.Dynamic(level)
    local c = Farm.DynCache
    if c and c.level == level then return c.row end
    local row
    pcall(function()
        local qm = ReplicatedStorage:FindFirstChild("Quests")
        if not qm then return end
        local Quests = require(qm)

        local wanted
        for i = #Data.SubmergedQuests, 1, -1 do
            local r = Data.SubmergedQuests[i]
            if level >= r[1] then
                wanted = r
                break
            end
        end

        local function matchesMob(info, mobName)
            if type(info) ~= "table" or type(info.Task) ~= "table" then return false end
            for mob, count in pairs(info.Task) do
                if type(mob) == "string" and type(count) == "number"
                    and count > 0 and mob:lower() == mobName:lower() then
                    return true
                end
            end
            return false
        end

        if wanted then
            for qName, qTable in pairs(Quests) do
                if type(qTable) == "table" then
                    for idx, info in pairs(qTable) do
                        if type(info) == "table" and type(info.LevelReq) == "number"
                            and info.LevelReq == wanted[1] and matchesMob(info, wanted[2]) then
                            local mpos = Farm.FindMobSpawn(wanted[2])
                            local qpos = mpos and Farm.FindNPC("quest", mpos)
                            qpos = qpos or Farm.FindNPC(wanted[3])
                            if mpos and qpos then
                                row = {wanted[1], wanted[2], qName, idx, qpos, mpos, "Dynamic: Submerged Island"}
                                return
                            end
                        end
                    end
                end
            end
        end

        -- Generic fallback for future quest additions.
        local bestReq, bestQ, bestIdx, bestMob = -1, nil, nil, nil
        for qName, qTable in pairs(Quests) do
            if type(qTable) == "table" then
                for idx, info in pairs(qTable) do
                    if type(info) == "table" and type(info.LevelReq) == "number" and type(info.Task) == "table"
                        and info.LevelReq <= level and info.LevelReq > bestReq then
                        local mob, cnt
                        for k, v in pairs(info.Task) do mob, cnt = k, v break end
                        if type(mob) == "string" and type(cnt) == "number" and cnt > 0 then
                            bestReq, bestQ, bestIdx, bestMob = info.LevelReq, qName, idx, mob
                        end
                    end
                end
            end
        end
        if bestQ then
            local mpos = Farm.FindMobSpawn(bestMob)
            local qpos = mpos and Farm.FindNPC("quest", mpos)
            if mpos and qpos then
                row = {bestReq, bestMob, bestQ, bestIdx, qpos, mpos, "Dynamic: " .. bestQ}
            end
        end
    end)
    Farm.DynCache = {level = level, row = row}
    return row
end

function Farm.GetRow(level)
    local rows = Data.Quests[Sea]
    if not rows then return nil, "UNKNOWN_SEA" end
    if Sea == 1 and level >= 700 then return nil, "NEED_SEA2" end
    if Sea == 2 and level >= 1500 then return nil, "NEED_SEA3" end
    local best
    for _, r in ipairs(rows) do
        if level >= r[1] then best = r else break end
    end
    if Sea == 3 and level >= 2600 and os.clock() >= Farm.DynBlockedUntil then
        local dyn = Farm.Dynamic(level)
        if dyn then return dyn end
    end
    if best then return best end
    return nil, "NO_ROW"
end

Farm.QuestFails, Farm.OwnKills, Farm.OwnActive, Farm.Kills = 0, 0, false, 0
Farm.OwnStart, Farm.GuiTrusted, Farm.QuestResp = 0, false, "-"
Farm.LastProgress, Farm.WDPos = os.clock(), nil
Farm.DynBlockedUntil, Farm.SubmergedTries = 0, 0
Farm.NeedCache = {}

-- Reads the on-screen quest tracker. Returns (active, title). active == nil means "GUI not found".
-- Matches ANY visible label with a "(0/8)"-style counter, so this works regardless of the exact wording
-- Blox Fruits uses ("Defeat 8 Bandits", "Kill 5 Gorillas", translated text, etc).
function Farm.QuestInfo()
    local now = os.clock()
    local c = Farm.QI
    if c and now - c.t < 0.4 then return c.active, c.title end
    local active, title = nil, ""
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local main = pg:FindFirstChild("Main") or pg
        for _, d in ipairs(main:GetDescendants()) do
            if d:IsA("TextLabel") then
                local tx = d.Text
                if type(tx) == "string" and tx:find("%(%s*%d+%s*/%s*%d+%s*%)") and Misc.IsShown(d) then
                    active, title = true, tx
                    break
                end
            end
        end
        if not active then
            for _, d in ipairs(main:GetDescendants()) do
                if d:IsA("TextLabel") then
                    local tx = d.Text
                    if type(tx) == "string" and tx:lower():find("^%s*defeat%s+%d") and Misc.IsShown(d) then
                        active, title = true, tx
                        break
                    end
                end
            end
        end
        -- classic Main.Quest frame, used only to know whether the tracker exists at all
        local q = main:FindFirstChild("Quest")
        if q then
            Farm.QuestCached = q
            if active == nil then active = q.Visible and true or false end
        end
    end
    if active then Farm.GuiTrusted = true end
    Farm.QI = {t = now, active = active, title = title}
    return active, title
end

function Farm.QuestTitle()
    local _, t = Farm.QuestInfo()
    return t
end

function Farm.QuestGui()
    Farm.QuestInfo()
    return Farm.QuestCached
end

-- how many kills the quest wants (used only when the quest GUI cannot be read)
function Farm.QuestNeed(row)
    local key = row[3] .. "#" .. tostring(row[4])
    if Farm.NeedCache[key] then return Farm.NeedCache[key] end
    local need = 6
    pcall(function()
        local info = require(ReplicatedStorage.Quests)[row[3]][row[4]]
        for _, v in pairs(info.Task) do
            if type(v) == "number" then need = v end
            break
        end
    end)
    Farm.NeedCache[key] = need
    return need
end

-- If the title carries no "(n/n)" progress counter it isn't the kind of text we can check, so let it pass.
function Farm.TitleMatches(title, row)
    if type(title) ~= "string" or not title:find("%(%s*%d+%s*/%s*%d+%s*%)") then return true end
    local t, m = title:lower(), row[2]:lower()
    if t:find(m, 1, true) then return true end
    if m:find("kissed", 1, true) and t:find("kissed", 1, true) then return true end
    if #m > 4 and t:find(m:sub(1, #m - 1), 1, true) then return true end
    return false
end

-- if nothing improves for 30s the farm resets itself (quest, target, tween)
function Farm.Watchdog(root)
    local now = os.clock()
    if not Farm.WDPos or (root.Position - Farm.WDPos).Magnitude > 12 then
        Farm.WDPos = root.Position
        Farm.LastProgress = now
        return
    end
    if now - Farm.LastProgress > 30 then
        Farm.LastProgress = now
        Farm.QuestWait, Farm.Target, Farm.OwnActive, Farm.OwnKills = 0, nil, false, 0
        Move.Cancel()
        U.CommAsync("AbandonQuest")
        U.Notify("Auto Farm", "Farm looked stuck, resetting the quest.", 4)
        Misc.Alert("WhStuck", "Farm stuck", "The watchdog reset the quest.", 0xFFB040)
    end
end

function Farm.Entrance(row, pos)
    local ent = row[8]
    local root = U.Root()
    if ent and root and (root.Position - pos).Magnitude > 8000 and os.clock() - Farm.LastEntrance > 4 then
        Farm.LastEntrance = os.clock()
        U.Comm("requestEntrance", ent)
        task.wait(1)
    end
end

function Farm.TravelSea(reason)
    if not Cfg.AutoSeaTravel or os.clock() - Farm.LastTravel < 30 then return end
    Farm.LastTravel = os.clock()
    if reason == "NEED_SEA2" then
        U.Notify("Sea Travel", "Level 700+ reached, trying to travel to Sea 2 (unlock the quest manually if this fails).", 6)
        U.Spawn(function() U.Comm("TravelDressrosa") end)
    elseif reason == "NEED_SEA3" then
        U.Notify("Sea Travel", "Level 1500+ reached, trying to travel to Sea 3 (unlock the quest manually if this fails).", 6)
        U.Spawn(function() U.Comm("TravelZou") end)
    end
end

-- Best-effort: talk to the Submarine Worker and try every known way to enter Submerged Island.
-- returns true when an attempt was actually made (there is a 15s cooldown between attempts)
function Farm.EnterSubmerged()
    if os.clock() - Farm.LastSubmerged < 15 then return false end
    Farm.LastSubmerged = os.clock()
    local pos = Farm.FindNPC("submarine worker") or Farm.FindNPC("submarine")
    if not pos then
        U.Notify("Submerged Island", "Submarine Worker not loaded. Go to Tiki Outpost (Sub Port 01) first.", 6)
        return true
    end
    U.Notify("Submerged Island", "Flying to the Submarine Worker and trying to enter.", 5)
    Move.Go(pos + V3(0, 3, 4))
    Misc.Interact("submarine")
    task.wait(1.2)
    Misc.ClickText({"submerged", "travel", "yes", "confirm"})
    task.wait(0.6)
    Misc.ClickText({"yes", "confirm"})
    U.Comm("SubmarineWorkerSpeak", "TravelToSubmergedIsland")
    return true
end

-- ---------- fighting ----------
function Farm.Fight(name, mobPos, row)
    local root = U.Root()
    if not root then return end
    local target = Farm.Target
    if target and not U.MobAlive(target) then
        -- the mob we were hitting just died
        Farm.OwnKills = Farm.OwnKills + 1
        Farm.Kills = Farm.Kills + 1
        Farm.LastProgress = os.clock()
        target, Farm.Target = nil, nil
    end
    if not (target and target.Parent and U.CleanName(target.Name):lower():find(name:lower(), 1, true)) then
        target = Farm.Nearest(Farm.FindMobs(name), root.Position)
        Farm.Target = target
    end
    if target then
        Move.To(target.HumanoidRootPart.CFrame * CF(0, Farm.Height(), 0) * CFrame.Angles(math.rad(-90), 0, 0))
        Farm.Bring(target, U.CleanName(target.Name))
        Combat.Request()
        Combat.Observe(target)
        return
    end
    -- nothing spawned near us: fly to the mob area
    local pos = mobPos or Farm.TemplatePos(name)
    if pos then
        if row then Farm.Entrance(row, pos) end
        Move.To(CF(pos + V3(0, Farm.Height(), 0)))
        Farm.Status(string.format("Flying to %s spawn, %d studs left", name, math.floor(Move.Left)))
    end
end

function Farm.Level()
    local root, hum = U.Root(), U.Hum()
    if not root or not hum or hum.Health <= 0 then
        Move.Cancel()
        Farm.Target = nil
        return
    end
    local lvl = U.Level()
    if Cfg.StopAtTarget and lvl >= Cfg.TargetLevel then
        Farm.Status("Target level " .. Cfg.TargetLevel .. " reached, farm stopped")
        if UI.T.AutoFarm then UI.T.AutoFarm.Set(false) else Cfg.AutoFarm = false end
        U.Notify("Auto Farm", "Target level reached. Auto Farm turned off.", 6)
        return
    end

    local row, reason = Farm.GetRow(lvl)
    if not row then
        if reason == "NEED_SEA2" or reason == "NEED_SEA3" then
            Farm.Status("Need a new sea for level " .. lvl)
            Farm.TravelSea(reason)
        else
            Farm.Status("No quest data (" .. tostring(reason) .. "), farming nearest mobs")
            Farm.NearestStep()
        end
        return
    end

    -- far-away dynamic quests (Submerged Island): try to travel, then fall back so we never sit idle
    if type(row[7]) == "string" and row[7]:sub(1, 7) == "Dynamic" then
        if (root.Position - row[6]).Magnitude > 6000 then
            if Farm.SubmergedTries >= 3 then
                Farm.SubmergedTries = 0
                Farm.DynBlockedUntil = os.clock() + 240
                Farm.DynCache = nil
                U.Notify("Submerged Island", "Could not reach it. Farming the best reachable quest for 4 minutes.", 6)
                return
            end
            Farm.Status("Traveling to Submerged Island (try " .. (Farm.SubmergedTries + 1) .. "/3)")
            if Farm.EnterSubmerged() then Farm.SubmergedTries = Farm.SubmergedTries + 1 end
            return
        end
        Farm.SubmergedTries = 0
    end

    Farm.Status(string.format("Lv %d | %s | %s | kills %d | %s", lvl, row[7], row[2], Farm.Kills, Combat.Profile().name))
    Farm.Prep()
    Farm.Watchdog(root)

    if Cfg.UseQuest then
        local guiActive, title = Farm.QuestInfo()
        local now = os.clock()
        local active
        if guiActive then
            active = true
            Farm.QuestFails = 0
        elseif Farm.OwnActive and now - Farm.OwnStart < 8 then
            active = true -- just accepted, the tracker can lag behind the server
        elseif Farm.OwnActive and not Farm.GuiTrusted and Farm.OwnKills < Farm.QuestNeed(row) then
            active = true -- the tracker never showed a quest here: trust our own kill counter instead of freezing
        else
            active = false
        end
        if guiActive and not Farm.TitleMatches(title, row) then
            if now - Farm.LastAbandon > 8 then
                Farm.LastAbandon = now
                Farm.OwnActive = false
                U.CommAsync("AbandonQuest")
            end
            return
        end
        if not active then
            if now < Farm.QuestWait then return end
            local stand = row[5]
            if Farm.QuestFails >= 2 then stand = Farm.FindNPC("quest", row[5]) or row[5] end
            Farm.Entrance(row, stand)
            Move.To(CF(stand))
            local r2 = U.Root()
            if r2 and (r2.Position - stand).Magnitude < 14 then
                U.Spawn(function()
                    local r = U.Comm("StartQuest", row[3], row[4]) -- never block the loop on the server
                    Farm.QuestResp = tostring(r)
                end)
                Farm.QuestWait = now + 2
                Farm.OwnActive, Farm.OwnKills, Farm.OwnStart = true, 0, now
                Farm.QuestFails = Farm.QuestFails + 1
                Farm.LastProgress = now
            else
                Farm.Status(string.format("Flying to quest NPC, %d studs left", math.floor(Move.Left)))
            end
            return
        end
    end

    Farm.Fight(row[2], row[6], row)
end

function Farm.NearestStep()
    local root = U.Root()
    local enemies = Workspace:FindFirstChild("Enemies")
    if not root or not enemies then return false end
    local best, bd
    for _, m in ipairs(enemies:GetChildren()) do
        local r = U.MobAlive(m)
        if r then
            local d = (r.Position - root.Position).Magnitude
            if d < 2500 and (not bd or d < bd) then best, bd = m, d end
        end
    end
    if not best then
        Farm.Status("Nearest: no mobs around")
        return false
    end
    Farm.Prep()
    Move.To(best.HumanoidRootPart.CFrame * CF(0, Farm.Height(), 0) * CFrame.Angles(math.rad(-90), 0, 0))
    Farm.Bring(best, U.CleanName(best.Name))
    Combat.Request()
    Farm.Status("Nearest: " .. best.Name)
    return true
end

function Farm.SelectedMobStep()
    local name = Cfg.SelectedMob
    if name == "" then return false end
    Farm.Prep()
    Farm.Status("Farming: " .. name)
    Farm.Fight(name, Data.MobPos[name], nil)
    return true
end

function Farm.FightBoss(name)
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return false end
    local ln = name:lower()
    local target
    for _, m in ipairs(enemies:GetChildren()) do
        if U.MobAlive(m) and U.CleanName(m.Name):lower():find(ln, 1, true) then
            target = m
            break
        end
    end
    if target then
        Farm.Prep()
        Move.To(target.HumanoidRootPart.CFrame * CF(0, math.max(Farm.Height(), 22), 0) * CFrame.Angles(math.rad(-90), 0, 0))
        Combat.Request()
        Farm.Status("Boss: " .. target.Name)
        return true
    end
    local pos = Farm.TemplatePos(name)
    if pos then
        Farm.Status("Boss: heading to spawn of " .. name)
        Move.To(CF(pos + V3(0, 30, 0)))
        return true
    end
    return false
end

function Farm.BossStep()
    if Cfg.SelectedBoss == "" then return false end
    local ok = Farm.FightBoss(Cfg.SelectedBoss)
    if not ok then Farm.Status("Boss not spawned: " .. Cfg.SelectedBoss) end
    return ok
end

function Farm.EliteStep()
    for _, name in ipairs(Data.EliteNames) do
        if Farm.FightBoss(name) then return true end
    end
    if os.clock() - Farm.LastElite > 12 then
        Farm.LastElite = os.clock()
        U.Spawn(function() U.Comm("EliteHunter") end)
    end
    Farm.Status("Elite Hunter: waiting for an elite")
    return false
end

function Farm.PirateRaidStep()
    if Sea ~= 3 then
        Farm.Status("Pirate Raid works in Sea 3 only")
        return false
    end
    local root = U.Root()
    local enemies = Workspace:FindFirstChild("Enemies")
    if not root or not enemies then return false end
    local best, bd
    for _, m in ipairs(enemies:GetChildren()) do
        local r = U.MobAlive(m)
        if r and (r.Position - Data.CastlePos).Magnitude < 1800 then
            local d = (r.Position - root.Position).Magnitude
            if not bd or d < bd then best, bd = m, d end
        end
    end
    if best then
        Farm.Prep()
        Move.To(best.HumanoidRootPart.CFrame * CF(0, Farm.Height(), 0) * CFrame.Angles(math.rad(-90), 0, 0))
        Farm.Bring(best, nil)
        Combat.Request()
        Farm.Status("Pirate Raid: fighting " .. best.Name)
        return true
    end
    -- no raid pirates right now: let the lower-priority farm keep going
    if Cfg.PirateIdleWait then
        Farm.Status("Pirate Raid: waiting at Castle on the Sea")
        if (root.Position - Data.CastlePos).Magnitude > 600 then
            Move.To(CF(Data.CastlePos + V3(0, 60, 0)))
        end
        return true
    end
    return false
end

-- ---------- bone farm (Haunted Castle) ----------
function Farm.BoneStep()
    if Sea ~= 3 then
        Farm.Status("Bone farm works in Sea 3 only")
        return false
    end
    local root = U.Root()
    local enemies = Workspace:FindFirstChild("Enemies")
    if not root or not enemies then return false end
    local want = {}
    for _, n in ipairs(Data.BoneMobs) do want[n:lower()] = true end
    local best, bd
    for _, m in ipairs(enemies:GetChildren()) do
        local r = U.MobAlive(m)
        if r and want[U.CleanName(m.Name):lower()] then
            local d = (r.Position - root.Position).Magnitude
            if not bd or d < bd then best, bd = m, d end
        end
    end
    Farm.Prep()
    if best then
        Move.To(best.HumanoidRootPart.CFrame * CF(0, Farm.Height(), 0) * CFrame.Angles(math.rad(-90), 0, 0))
        Farm.Bring(best, U.CleanName(best.Name))
        Combat.Request()
        Farm.Status("Bones: " .. best.Name)
        return true
    end
    local pos = Data.MobPos["Living Zombie"] or Data.MobPos["Reborn Skeleton"]
    if pos then
        Farm.Status("Bones: heading to Haunted Castle")
        Move.To(CF(pos + V3(0, Farm.Height(), 0)))
    end
    return true
end

-- ---------- mastery farm (uses its own weapon type + forced skills) ----------
function Farm.MasteryStep()
    local row = Farm.GetRow(U.Level())
    if not row then return Farm.NearestStep() end
    Farm.Prep()
    Farm.Status("Mastery (" .. Cfg.MasteryType .. "): " .. row[2])
    Farm.Fight(row[2], row[6], row)
    return true
end

-- ---------- fruit raid (dungeon) ----------
Farm.LastChip, Farm.LastRaidStart = 0, 0

function Farm.RaidIslands()
    local wo = Workspace:FindFirstChild("_WorldOrigin")
    local locs = wo and wo:FindFirstChild("Locations")
    if not locs then return nil end
    for i = 5, 1, -1 do
        local l = locs:FindFirstChild("Island " .. i)
        if l then return l, i end
    end
    return nil
end

function Farm.RaidButton()
    local map = Workspace:FindFirstChild("Map")
    if not map then return nil, nil end
    for _, holder in ipairs({map:FindFirstChild("CircleIsland"), map:FindFirstChild("Boat Castle")}) do
        local rs = holder and holder:FindFirstChild("RaidSummon2")
        local b = rs and rs:FindFirstChild("Button")
        local main = b and b:FindFirstChild("Main")
        local cd = main and main:FindFirstChildOfClass("ClickDetector")
        if cd then return cd, main end
    end
    return nil, nil
end

function Farm.RaidStep()
    local root = U.Root()
    if not root then return false end
    local isl, idx = Farm.RaidIslands()
    if isl then
        Farm.Prep()
        local enemies = Workspace:FindFirstChild("Enemies")
        local best, bd
        if enemies then
            for _, m in ipairs(enemies:GetChildren()) do
                local r = U.MobAlive(m)
                if r then
                    local d = (r.Position - root.Position).Magnitude
                    if d < 3000 and (not bd or d < bd) then best, bd = m, d end
                end
            end
        end
        if best then
            Move.To(best.HumanoidRootPart.CFrame * CF(0, Farm.Height(), 0) * CFrame.Angles(math.rad(-90), 0, 0))
            Farm.Bring(best, U.CleanName(best.Name))
            Combat.Request()
            Farm.Status("Raid: fighting on island " .. tostring(idx))
        else
            local p = isl:IsA("BasePart") and isl.Position or (isl.PrimaryPart and isl.PrimaryPart.Position)
            if p then Move.To(CF(p + V3(0, 40, 0))) end
            Farm.Status("Raid: moving to island " .. tostring(idx))
        end
        return true
    end
    if Sea == 1 then
        Farm.Status("Raids need Sea 2 or Sea 3")
        return false
    end
    local hasChip = false
    for _, c in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
        if c and c:FindFirstChild("Special Microchip") then hasChip = true end
    end
    if not hasChip then
        if os.clock() - Farm.LastChip > 8 then
            Farm.LastChip = os.clock()
            U.Spawn(function() U.Comm("RaidsNpc", "Select", Cfg.RaidType) end)
        end
        Farm.Status("Raid: buying " .. Cfg.RaidType .. " chip")
        return true
    end
    local cd, main = Farm.RaidButton()
    if not cd then
        Farm.Status("Raid button not found in this sea")
        return false
    end
    Move.To(main.CFrame * CF(0, 3, 6))
    if (root.Position - main.Position).Magnitude < 25 and os.clock() - Farm.LastRaidStart > 6 then
        Farm.LastRaidStart = os.clock()
        if Ex.FireClick then pcall(Ex.FireClick, cd) end
    end
    Farm.Status("Raid: starting")
    return true
end

-- =============================================================================
-- ITEMS (fruit collect / store / chests / stats)
-- =============================================================================
Items.Bad = setmetatable({}, {__mode = "k"})
Items.Near = setmetatable({}, {__mode = "k"})

function Items.FruitTools(container)
    local out = {}
    if not container then return out end
    for _, t in ipairs(container:GetChildren()) do
        if t:IsA("Tool") and t.Name:find("Fruit") then out[#out + 1] = t end
    end
    return out
end

function Items.DeriveName(toolName)
    local base = toolName:gsub(" Fruit$", "")
    if base == "Falcon" then return "Bird-Bird: Falcon" end
    if base == "Phoenix" then return "Bird-Bird: Phoenix" end
    return base .. "-" .. base
end

function Items.StoreAll()
    local n = 0
    for _, c in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
        for _, t in ipairs(Items.FruitTools(c)) do
            local orig = t:GetAttribute("OriginalName") or Items.DeriveName(t.Name)
            U.Comm("StoreFruit", orig, t)
            n = n + 1
            task.wait(0.15)
        end
    end
    return n
end

function Items.CollectStep()
    local root = U.Root()
    if not root then return false end
    local best, bd
    for _, o in ipairs(Workspace:GetChildren()) do
        if o:IsA("Tool") and o.Name:find("Fruit") then
            local h = o:FindFirstChild("Handle")
            if h then
                local d = (h.Position - root.Position).Magnitude
                if not bd or d < bd then best, bd = h, d end
            end
        end
    end
    if not best then return false end
    Farm.Status("Collecting: " .. best.Parent.Name)
    if bd < 12 then
        if Ex.FireTouch then
            pcall(Ex.FireTouch, root, best, 0)
            pcall(Ex.FireTouch, root, best, 1)
        end
        root.CFrame = best.CFrame
    else
        Move.To(best.CFrame * CF(0, 2, 0))
    end
    return true
end

function Items.ChestStep()
    local root = U.Root()
    if not root then return false end
    local best, bd
    for _, o in ipairs(Workspace:GetChildren()) do
        if o:IsA("BasePart") and o.Name:find("Chest") and not Items.Bad[o] then
            local d = (o.Position - root.Position).Magnitude
            if not bd or d < bd then best, bd = o, d end
        end
    end
    if not best then return false end
    Farm.Status("Chest: " .. best.Name)
    if bd < 8 then
        Items.Near[best] = Items.Near[best] or os.clock()
        if os.clock() - Items.Near[best] > 1.5 then Items.Bad[best] = true end
        if Ex.FireTouch then
            pcall(Ex.FireTouch, root, best, 0)
            pcall(Ex.FireTouch, root, best, 1)
        end
        root.CFrame = best.CFrame
    else
        Move.To(best.CFrame)
    end
    return true
end

U.Loop(2, function()
    if Cfg.AutoStoreFruit then Items.StoreAll() end
end)

U.Loop(4, function()
    if Cfg.AutoRandomFruit then U.Comm("Cousin", "Buy") end
end)

U.Loop(3, function()
    if Cfg.AutoRandomSurprise and Sea == 3 then U.Comm("Bones", "Buy", 1, 1) end
end)

U.Loop(1.5, function()
    if not Cfg.StatOn then return end
    local pts = U.Points()
    if pts <= 0 then return end
    local amt = math.min(Cfg.StatAmount, pts)
    local map = {
        {"Melee", "StatMelee"}, {"Defense", "StatDefense"}, {"Sword", "StatSword"},
        {"Gun", "StatGun"}, {"Demon Fruit", "StatFruit"},
    }
    for _, e in ipairs(map) do
        if Cfg[e[2]] then U.Comm("AddPoint", e[1], amt) end
    end
end)

U.Conn(Workspace.ChildAdded, function(o)
    if o:IsA("Tool") and o.Name:find("Fruit") then
        if Cfg.FruitNotify then UI.Notify("Fruit Spawned", o.Name, 6) end
        Misc.Alert("WhAlerts", "Fruit spawned", o.Name, 0x50DC8C, {{"Server", game.JobId, false}})
    end
end)

-- =============================================================================
-- MASTER LOOP  (one task at a time, priority ordered)
-- =============================================================================
Farm.Escaping, Farm.EscapeY = false, nil

U.Loop(0.05, function()
    Combat.Extra = nil
    local root, hum = U.Root(), U.Hum()
    if not root or not hum or hum.Health <= 0 then
        Move.Cancel()
        Farm.Target = nil
        Farm.Escaping = false
        return
    end
    if Move.Teleporting then return end
    if not Move.AutoActive() and not Cfg.FishFarm then
        if Move.Goal then Move.Cancel() end
        Farm.Target = nil
        return
    end

    -- low HP escape: fly high up until health recovers (fixed fast speed, the only exception to Tween Speed)
    if Cfg.LowHPEscape then
        local frac = hum.Health / math.max(hum.MaxHealth, 1)
        if frac < Cfg.EscapeHP / 100 and not Farm.Escaping then
            Farm.Escaping = true
            Farm.EscapeY = root.Position.Y + 1500
        end
        if Farm.Escaping then
            if frac >= 0.85 then
                Farm.Escaping = false
            else
                Farm.Status(string.format("Escaping, HP %d%%", math.floor(frac * 100)))
                Move.To(CF(root.Position.X, Farm.EscapeY, root.Position.Z), 250)
                return
            end
        end
    end

    if Cfg.FishFarm and Fish.Step() then return end
    if Cfg.AutoCollectFruit and Items.CollectStep() then return end
    if Cfg.AutoChest and Items.ChestStep() then return end
    if (Cfg.PvpKill or Cfg.PvpHunt) and PvP.KillStep() then return end
    if Cfg.PirateRaid and Farm.PirateRaidStep() then return end
    if Cfg.AutoRaid and Farm.RaidStep() then return end
    if Cfg.EliteHunter and Farm.EliteStep() then return end
    if Cfg.FarmBoss and Farm.BossStep() then return end
    if Cfg.BoneFarm and Farm.BoneStep() then return end
    if Cfg.FarmMob and Farm.SelectedMobStep() then return end
    if Cfg.MasteryFarm and Farm.MasteryStep() then return end
    if Cfg.AutoFarm then
        Farm.Level()
        return
    end
    if Cfg.FarmNearest then Farm.NearestStep() end
    if Cfg.PirateRaid and not Cfg.AutoFarm then Farm.Status("Pirate Raid: watching for the event") end
end)

-- =============================================================================
-- PVP
-- =============================================================================
PvP.Orig = setmetatable({}, {__mode = "k"})

function PvP.PlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then names[#names + 1] = p.Name end
    end
    table.sort(names)
    return names
end

function PvP.Valid(p)
    if not p or p == LocalPlayer then return nil, nil end
    local c = p.Character
    if not c then return nil, nil end
    local h = c:FindFirstChildOfClass("Humanoid")
    local r = c:FindFirstChild("HumanoidRootPart")
    if h and r and h.Health > 0 then return c, r end
    return nil, nil
end

function PvP.SameTeam(p)
    return Cfg.PvpSkipTeam and p.Team ~= nil and p.Team == LocalPlayer.Team
end

function PvP.NearestPlayer()
    local root = U.Root()
    if not root then return nil end
    local best, bd
    for _, p in ipairs(Players:GetPlayers()) do
        local c, r = PvP.Valid(p)
        if c and not PvP.SameTeam(p) and not c:FindFirstChildOfClass("ForceField") then
            local d = (r.Position - root.Position).Magnitude
            if not bd or d < bd then best, bd = p, d end
        end
    end
    return best
end

function PvP.KillStep()
    local p
    if Cfg.PvpKill and Cfg.PvpTargetName ~= "" then p = Players:FindFirstChild(Cfg.PvpTargetName) end
    if (not p or not PvP.Valid(p)) and Cfg.PvpHunt then p = PvP.NearestPlayer() end
    local c, r = PvP.Valid(p)
    if not c then return false end
    Farm.Prep()
    Move.To(r.CFrame * CF(0, 4, 7))
    Combat.Extra = c
    Combat.Request()
    Farm.Status("PvP: " .. p.Name)
    return true
end

-- camera aimbot
U.Conn(RunService.RenderStepped, function()
    if not Cfg.Aimbot then return end
    local cam = Workspace.CurrentCamera
    local center = cam.ViewportSize / 2
    local best, bd
    for _, p in ipairs(Players:GetPlayers()) do
        local c, r = PvP.Valid(p)
        if c and not PvP.SameTeam(p) then
            local head = c:FindFirstChild("Head") or r
            local sp, on = cam:WorldToViewportPoint(head.Position)
            if on then
                local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                if d < Cfg.AimFOV and (not bd or d < bd) then best, bd = head, d end
            end
        end
    end
    if best then cam.CFrame = CF(cam.CFrame.Position, best.Position) end
end)

-- player hitbox expander
U.Loop(0.5, function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                if Cfg.PlayerHitbox then
                    if not PvP.Orig[r] then PvP.Orig[r] = r.Size end
                    local s = Cfg.PlayerHitboxSize
                    r.Size = V3(s, s, s)
                    r.Transparency = 0.85
                    r.CanCollide = false
                elseif PvP.Orig[r] then
                    r.Size = PvP.Orig[r]
                    r.Transparency = 1
                    PvP.Orig[r] = nil
                end
            end
        end
    end
end)

-- =============================================================================
-- ESP
-- =============================================================================
ESP.Store = {Player = {}, Fruit = {}, Chest = {}, Mob = {}}
ESP.Holder = New("ScreenGui", {Name = "MorganESP", ResetOnSpawn = false})
ESP.Holder.Parent = GuiParent

function ESP.Destroy(rec)
    pcall(function()
        rec.gui:Destroy()
        if rec.hl then rec.hl:Destroy() end
    end)
end

function ESP.Clear(kind)
    for _, rec in pairs(ESP.Store[kind]) do ESP.Destroy(rec) end
    ESP.Store[kind] = {}
end

function ESP.Make(e)
    local gui = New("BillboardGui", {
        Name = "MESP", AlwaysOnTop = true, Size = UDim2.new(0, 150, 0, 30),
        StudsOffset = V3(0, 3, 0), Adornee = e.adornee,
    }, ESP.Holder)
    local lbl = New("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = e.text, TextColor3 = e.color,
        TextStrokeTransparency = 0.3, Font = Enum.Font.GothamBold, TextSize = 12,
    }, gui)
    local hl
    if e.highlight then
        hl = New("Highlight", {
            FillColor = e.color, OutlineColor = e.color, FillTransparency = 0.7,
            DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
        })
        hl.Parent = e.obj
    end
    return {gui = gui, label = lbl, hl = hl}
end

function ESP.Refresh(kind, entries)
    local store = ESP.Store[kind]
    local seen = {}
    for _, e in ipairs(entries) do
        seen[e.obj] = true
        local rec = store[e.obj]
        if not rec or not rec.gui.Parent then
            rec = ESP.Make(e)
            store[e.obj] = rec
        end
        rec.label.Text = e.text
    end
    for obj, rec in pairs(store) do
        if not seen[obj] or not obj.Parent then
            ESP.Destroy(rec)
            store[obj] = nil
        end
    end
end

U.Loop(0.4, function()
    local root = U.Root()
    local function dist(part)
        return root and math.floor((part.Position - root.Position).Magnitude / 3) or 0
    end

    if Cfg.ESPPlayer then
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            local c, r = PvP.Valid(p)
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                list[#list + 1] = {
                    obj = c, adornee = c:FindFirstChild("Head") or r, highlight = true,
                    color = PvP.SameTeam(p) and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(255, 80, 80),
                    text = string.format("%s\n%dm | %d%%", p.DisplayName, dist(r), math.floor(h.Health / math.max(h.MaxHealth, 1) * 100)),
                }
            end
        end
        ESP.Refresh("Player", list)
    else
        ESP.Clear("Player")
    end

    if Cfg.ESPFruit then
        local list = {}
        for _, o in ipairs(Workspace:GetChildren()) do
            if o:IsA("Tool") and o.Name:find("Fruit") and o:FindFirstChild("Handle") then
                list[#list + 1] = {
                    obj = o, adornee = o.Handle, highlight = true, color = Color3.fromRGB(90, 255, 140),
                    text = o.Name .. "\n" .. dist(o.Handle) .. "m",
                }
            end
        end
        ESP.Refresh("Fruit", list)
    else
        ESP.Clear("Fruit")
    end

    if Cfg.ESPChest then
        local list = {}
        for _, o in ipairs(Workspace:GetChildren()) do
            if o:IsA("BasePart") and o.Name:find("Chest") then
                list[#list + 1] = {
                    obj = o, adornee = o, highlight = false, color = Color3.fromRGB(255, 220, 90),
                    text = o.Name .. "\n" .. dist(o) .. "m",
                }
            end
        end
        ESP.Refresh("Chest", list)
    else
        ESP.Clear("Chest")
    end

    if Cfg.ESPMob then
        local list = {}
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies and root then
            for _, m in ipairs(enemies:GetChildren()) do
                local r = U.MobAlive(m)
                if r and (r.Position - root.Position).Magnitude < 900 and #list < 40 then
                    list[#list + 1] = {
                        obj = m, adornee = r, highlight = false, color = Color3.fromRGB(255, 150, 80),
                        text = U.CleanName(m.Name) .. "\n" .. dist(r) .. "m",
                    }
                end
            end
        end
        ESP.Refresh("Mob", list)
    else
        ESP.Clear("Mob")
    end
end)

-- =============================================================================
-- MISC / VISUAL / FUN
-- =============================================================================
-- stretched resolution
U.Conn(RunService.RenderStepped, function()
    if Cfg.Stretch then
        local cam = Workspace.CurrentCamera
        cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, Cfg.StretchAmt, 0, 0, 0, 1)
    end
end)

-- anti-AFK
U.Conn(LocalPlayer.Idled, function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)

Misc.LightOrig = {
    Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient,
}

function Misc.SetFullbright(on)
    if on then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(190, 190, 190)
    else
        Lighting.Brightness = Misc.LightOrig.Brightness
        Lighting.ClockTime = Misc.LightOrig.ClockTime
        Lighting.GlobalShadows = Misc.LightOrig.GlobalShadows
        Lighting.Ambient = Misc.LightOrig.Ambient
    end
end

function Misc.SetNoFog(on)
    Lighting.FogEnd = on and 9e9 or Misc.LightOrig.FogEnd
    for _, o in ipairs(Lighting:GetChildren()) do
        if o:IsA("Atmosphere") then o.Density = on and 0 or 0.3 end
    end
end

-- applies the cheap look to one instance (never touches terrain, our fake fruits or our own GUI)
function Misc.FpsApply(o)
    if o:IsA("Terrain") then return end
    if o:IsA("BasePart") then
        o.Material = Enum.Material.SmoothPlastic
        o.Reflectance = 0
        o.CastShadow = false
    elseif o:IsA("Decal") or o:IsA("Texture") then
        o.Transparency = 1
    elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") or o:IsA("Fire")
        or o:IsA("Smoke") or o:IsA("Sparkles") then
        o.Enabled = false
    elseif o:IsA("PostEffect") then
        o.Enabled = false
    end
end

function Misc.SetFpsBoost(on)
    Cfg.FpsBoost = on and true or false
    if not on then
        if Misc.FpsConn then
            pcall(function() Misc.FpsConn:Disconnect() end)
            Misc.FpsConn = nil
        end
        UI.Notify("FPS Boost", "Turned off for new objects. Rejoin to restore old textures.", 4)
        return
    end
    U.Spawn(function()
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        if Ex.SetFpsCap then pcall(Ex.SetFpsCap, 240) end
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, e in ipairs(Lighting:GetChildren()) do
                if e:IsA("PostEffect") then e.Enabled = false end
                if e:IsA("Atmosphere") then e.Density = 0 end
            end
        end)
        pcall(function()
            local t = Workspace:FindFirstChildOfClass("Terrain")
            if t then
                t.WaterWaveSize = 0
                t.WaterWaveSpeed = 0
                t.WaterReflectance = 0
                t.WaterTransparency = 1
                t.Decoration = false
            end
        end)
        local n = 0
        for _, o in ipairs(Workspace:GetDescendants()) do
            if not Cfg.FpsBoost then return end
            pcall(Misc.FpsApply, o)
            n = n + 1
            if n % 300 == 0 then task.wait() end
        end
        if not Misc.FpsConn then
            Misc.FpsConn = Workspace.DescendantAdded:Connect(function(o)
                if Cfg.FpsBoost and U.Alive() then task.defer(function() pcall(Misc.FpsApply, o) end) end
            end)
            table.insert(U.Conns, Misc.FpsConn)
        end
        UI.Notify("FPS Boost", "Textures, shadows and effects reduced.", 4)
    end)
end

function Misc.WaterWalk(on)
    local map = Workspace:FindFirstChild("Map")
    local plane = map and map:FindFirstChild("WaterBase-Plane")
    if plane then plane.Size = V3(1000, on and 112 or 80, 1000) end
end

function Misc.Rejoin()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

Misc.HopFile = "MorganHopped.json"

function Misc.LoadVisited()
    local v = {}
    if isfile and readfile then
        local ok, t = pcall(function()
            if isfile(Misc.HopFile) then return HttpService:JSONDecode(readfile(Misc.HopFile)) end
        end)
        if ok and type(t) == "table" then v = t end
    end
    return v
end

function Misc.Hop()
    local visited = Misc.LoadVisited()
    local seen = {}
    for _, id in ipairs(visited) do seen[id] = true end
    seen[game.JobId] = true
    local ok, res = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if ok and res and res.data then
        for _, sv in ipairs(res.data) do
            if not seen[sv.id] and sv.playing and sv.maxPlayers and sv.playing < sv.maxPlayers - 1 then
                table.insert(visited, game.JobId)
                while #visited > 40 do table.remove(visited, 1) end
                if writefile then pcall(writefile, Misc.HopFile, HttpService:JSONEncode(visited)) end
                TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id, LocalPlayer)
                return
            end
        end
    end
    UI.Notify("Server Hop", "Server list unavailable, joining a random server.", 4)
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end

-- ---------------------------------------------------------------------------
-- GUI MACRO HELPERS (find NPC, interact, click a dialogue button by its text)
-- ---------------------------------------------------------------------------
function Misc.FindNPCModel(pattern)
    local npcs = Workspace:FindFirstChild("NPCs")
    if npcs then
        for _, n in ipairs(npcs:GetChildren()) do
            if n.Name:lower():find(pattern, 1, true) then return n end
        end
    end
    return nil
end

function Misc.Interact(pattern)
    local n = Misc.FindNPCModel(pattern)
    if not n then return false end
    for _, d in ipairs(n:GetDescendants()) do
        if d:IsA("ProximityPrompt") and Ex.FireProx then pcall(Ex.FireProx, d) end
        if d:IsA("ClickDetector") and Ex.FireClick then pcall(Ex.FireClick, d) end
    end
    pcall(Combat.PressKey, Enum.KeyCode.E)
    return true
end

function Misc.IsShown(obj)
    local o = obj
    while o and o ~= game do
        if o:IsA("GuiObject") and not o.Visible then return false end
        if o:IsA("ScreenGui") then return o.Enabled end
        o = o.Parent
    end
    return true
end

function Misc.PressGui(btn)
    local fired = false
    if Ex.GetConnections then
        for _, sig in ipairs({btn.MouseButton1Click, btn.Activated, btn.MouseButton1Down}) do
            local ok, conns = pcall(Ex.GetConnections, sig)
            if ok and type(conns) == "table" then
                for _, c in ipairs(conns) do
                    pcall(function() c:Fire() end)
                    fired = true
                end
            end
        end
    end
    if not fired then
        local pos, size = btn.AbsolutePosition, btn.AbsoluteSize
        local inset = game:GetService("GuiService"):GetGuiInset()
        local x, y = pos.X + size.X / 2, pos.Y + size.Y / 2 + inset.Y
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        fired = true
    end
    return fired
end

-- clicks the first visible game button whose text contains one of the patterns
function Misc.ClickText(patterns)
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return false end
    for _, d in ipairs(pg:GetDescendants()) do
        if d:IsA("GuiButton") and d.AbsoluteSize.X > 0 and Misc.IsShown(d) then
            local txt = d:IsA("TextButton") and d.Text or ""
            if txt == "" then
                for _, c in ipairs(d:GetDescendants()) do
                    if c:IsA("TextLabel") and c.Text ~= "" then txt = c.Text break end
                end
            end
            local lt = txt:lower()
            for _, pat in ipairs(patterns) do
                if lt:find(pat, 1, true) then
                    Misc.PressGui(d)
                    return true, txt
                end
            end
        end
    end
    return false
end

-- ---------------------------------------------------------------------------
-- AUTO FISH (click macro) + restock (sell fish / buy bait through the Fisherman's dialogue)
-- ---------------------------------------------------------------------------
Fish.LastRestock, Fish.Phase, Fish.PhaseT, Fish.Holding, Fish.LastClick = 0, "cast", 0, false, 0
Fish.Cycle = {cast = {len = 1.1, next = "wait"}, wait = {len = 3.5, next = "reel"}, reel = {len = 9, next = "cast"}}

function Fish.FindRod()
    for _, c in ipairs({LocalPlayer.Character, LocalPlayer.Backpack}) do
        if c then
            for _, t in ipairs(c:GetChildren()) do
                if t:IsA("Tool") and t.Name:lower():find("rod", 1, true) then
                    return t, c == LocalPlayer.Character
                end
            end
        end
    end
    return nil, false
end

function Fish.Mouse(down)
    local cam = Workspace.CurrentCamera
    VirtualUser:CaptureController()
    if down then
        VirtualUser:Button1Down(Vector2.new(1280, 672), cam.CFrame)
    else
        VirtualUser:Button1Up(Vector2.new(1280, 672), cam.CFrame)
    end
    Fish.Holding = down
end

-- Waits for the Fisherman model to stream in. Flies to the known dock first if it hasn't loaded yet.
function Fish.LocateFisherman(timeout)
    local npc = Misc.FindNPCModel("fisherman")
    if npc then return npc end
    local dock = Data.FisherPos[Sea]
    if dock then
        Farm.Status("Fishing: heading to the docks to find the Fisherman")
        Move.Go(dock + V3(0, 3, 0))
    end
    local start = os.clock()
    while os.clock() - start < (timeout or 20) do
        npc = Misc.FindNPCModel("fisherman")
        if npc then return npc end
        task.wait(0.5)
    end
    return nil
end

function Fish.Restock()
    Fish.LastRestock = os.clock()
    local npc = Fish.LocateFisherman(20)
    local part = npc and (npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart", true))
    if not part then
        U.Notify("Fishing", "Fisherman NPC not found in this sea, even near the docks.", 5)
        return false
    end
    Farm.Status("Fishing: restocking (sell fish / buy bait)")
    if Fish.Holding then Fish.Mouse(false) end
    Move.Go(part.Position + V3(0, 3, 5))
    Misc.Interact("fisherman")
    task.wait(1.5)
    if Cfg.FishSell then
        if Misc.ClickText({"sell all", "sell fish", "sell"}) then task.wait(1) end
    end
    if Cfg.FishBait then
        Misc.ClickText({"shop"})
        task.wait(1)
        Misc.ClickText({"basic bait"})
        task.wait(0.6)
        Misc.ClickText({"craft", "purchase", "buy"})
        task.wait(1)
    end
    Misc.ClickText({"close", "exit", "leave", "bye"})
    return true
end

-- one tick of the fishing macro; returns true while it is in control
function Fish.Step()
    local hum = U.Hum()
    if not hum or hum.Health <= 0 then return false end
    if (Cfg.FishSell or Cfg.FishBait) and Cfg.FishRestock > 0
        and os.clock() - Fish.LastRestock > Cfg.FishRestock * 60 then
        Fish.Restock()
        return true
    end
    local rod, equipped = Fish.FindRod()
    if not rod then
        Farm.Status("Fishing: no rod yet, talk to the Fisherman first")
        return false
    end
    if not equipped then
        hum:EquipTool(rod)
        return true
    end
    local now = os.clock()
    local ph = Fish.Cycle[Fish.Phase]
    if now - Fish.PhaseT >= ph.len then
        if Fish.Phase == "cast" and Fish.Holding then Fish.Mouse(false) end
        Fish.Phase, Fish.PhaseT = ph.next, now
        ph = Fish.Cycle[Fish.Phase]
        if Fish.Phase == "cast" then Fish.Mouse(true) end
    end
    if Fish.Phase == "reel" and now - Fish.LastClick > 0.14 then
        Fish.LastClick = now
        Fish.Mouse(true)
        Fish.Mouse(false)
    end
    Farm.Status("Fishing: " .. Fish.Phase)
    return true
end

-- ---------------------------------------------------------------------------
-- SELF TEST + DEBUG
-- ---------------------------------------------------------------------------
function Misc.SelfTest()
    local L = {}
    local function add(name, ok, extra)
        L[#L + 1] = (ok and "OK    " or "FAIL  ") .. name .. (extra and (" - " .. extra) or "")
    end
    local rem = ReplicatedStorage:FindFirstChild("Remotes")
    add("Remote CommF_", rem ~= nil and rem:FindFirstChild("CommF_") ~= nil)
    add("Net attack remotes", Combat.RegAttack ~= nil and Combat.RegHit ~= nil)
    add("CombatFramework controller", Combat.Framework ~= nil)
    Farm.QI = nil
    local active = Farm.QuestInfo()
    add("Quest GUI readable", Farm.QuestCached ~= nil, Farm.QuestCached and "active=" .. tostring(active) or "counting kills instead")
    add("Quests module", ReplicatedStorage:FindFirstChild("Quests") ~= nil)
    add("NPCs folder", Workspace:FindFirstChild("NPCs") ~= nil)
    add("Enemies folder", Workspace:FindFirstChild("Enemies") ~= nil)
    local tool = Farm.GetTool(Farm.Weapon())
    add("Weapon '" .. Farm.Weapon() .. "' found", tool ~= nil)
    add("Fisherman NPC loaded right now", Misc.FindNPCModel("fisherman") ~= nil,
        "not streamed in yet, this is normal far from the docks; Auto Fish flies there and waits")
    add("Submarine Worker NPC", Misc.FindNPCModel("submarine") ~= nil)
    add("writefile (config/logo)", writefile ~= nil)
    add("getconnections (GUI macro)", Ex.GetConnections ~= nil)
    add("firetouchinterest", Ex.FireTouch ~= nil)
    add("fireproximityprompt", Ex.FireProx ~= nil)
    add("fireclickdetector", Ex.FireClick ~= nil)
    add("sethiddenproperty (magnet)", Ex.SetHidden ~= nil)
    add("getcustomasset (custom logo)", Ex.CustomAsset ~= nil)
    return table.concat(L, "\n")
end

-- prints everything needed to verify quest data (open the executor console)
function Misc.Debug()
    local lines = {}
    local function add(s) lines[#lines + 1] = s end
    local lvl = U.Level()
    add("Sea=" .. Sea .. " Level=" .. lvl .. " PlaceId=" .. game.PlaceId)
    local row, reason = Farm.GetRow(lvl)
    add("Row: " .. (row and (row[2] .. " | " .. row[3] .. " #" .. tostring(row[4]) .. " | " .. row[7]) or ("none (" .. tostring(reason) .. ")")))
    local active, title = Farm.QuestInfo()
    add("Quest GUI: found=" .. tostring(Farm.QuestCached ~= nil) .. " active=" .. tostring(active) .. " title=" .. title)
    add("Farm kills=" .. Farm.Kills .. " ownKills=" .. Farm.OwnKills .. " dynBlocked=" .. tostring(os.clock() < Farm.DynBlockedUntil))
    add("Quest: guiTrusted=" .. tostring(Farm.GuiTrusted) .. " ownActive=" .. tostring(Farm.OwnActive) .. " lastStartQuestReply=" .. tostring(Farm.QuestResp))
    add("Attack method: " .. Combat.Profile().name .. " (worked before: " .. tostring(Combat.Works) .. ")")
    add("Move: goal=" .. tostring(Move.Goal ~= nil) .. " studsLeft=" .. tostring(math.floor(Move.Left)))
    for _, l in ipairs(string.split(Misc.SelfTest(), "\n")) do add("TEST " .. l) end
    pcall(function()
        local Quests = require(ReplicatedStorage.Quests)
        for qName, qTable in pairs(Quests) do
            for idx, info in pairs(qTable) do
                if type(info) == "table" and type(info.LevelReq) == "number" and info.LevelReq >= 2500 then
                    local mob, cnt
                    for k, v in pairs(info.Task or {}) do mob, cnt = k, v break end
                    add(string.format("QUEST %s #%s req=%d mob=%s x%s", tostring(qName), tostring(idx), info.LevelReq, tostring(mob), tostring(cnt)))
                end
            end
        end
    end)
    local npcs = Workspace:FindFirstChild("NPCs")
    if npcs then
        for _, n in ipairs(npcs:GetChildren()) do
            local ln = n.Name:lower()
            if ln:find("submerged") or ln:find("submarine") or ln:find("fisher") or ln:find("angler") then
                local p = n:FindFirstChildWhichIsA("BasePart", true)
                add("NPC " .. n.Name .. " @ " .. (p and tostring(p.Position) or "?"))
            end
        end
    end
    pcall(function()
        local net = ReplicatedStorage.Modules.Net
        for _, r in ipairs(net:GetChildren()) do
            local ln = r.Name:lower()
            if ln:find("fish") or ln:find("bait") or ln:find("rod") or ln:find("submar") then add("NET " .. r.Name) end
        end
    end)
    pcall(function()
        local pg = LocalPlayer.PlayerGui
        local n = 0
        for _, d in ipairs(pg:GetDescendants()) do
            if d:IsA("TextButton") and d.Text ~= "" and Misc.IsShown(d) and n < 25 then
                n = n + 1
                add("BUTTON '" .. d.Text .. "' (" .. d:GetFullName() .. ")")
            end
        end
    end)
    for _, s in ipairs(lines) do print("[MorganHub Debug] " .. s) end
    UI.Notify("Debug", "Printed " .. #lines .. " lines to the executor console.", 5)
end

-- =============================================================================
-- DISCORD WEBHOOK  (bug reports + optional alerts)
-- Nothing is sent unless you press "Send Bug Report" / "Send Test Message" or switch an alert on.
-- =============================================================================
Misc.Version = "V3.3"
Misc.WhLast = {}
Misc.BugText, Misc.BugCat, Misc.LastBug = "", "Auto Farm", -100

local function trunc(s, n)
    s = tostring(s or "")
    if #s > n then return s:sub(1, n - 3) .. "..." end
    return s
end

function Misc.HttpRequest(opts)
    local req = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
    if not req then return false, "this executor has no HTTP request function" end
    local ok, res = pcall(req, opts)
    if not ok then return false, tostring(res) end
    local code = type(res) == "table" and (res.StatusCode or res.Status) or nil
    if type(code) == "number" and code >= 200 and code < 300 then return true end
    return false, "HTTP " .. tostring(code)
end

function Misc.Executor()
    local name = "unknown"
    if identifyexecutor then
        local ok, n, v = pcall(identifyexecutor)
        if ok and n then name = tostring(n) .. (v and (" " .. tostring(v)) or "") end
    end
    return name
end

function Misc.BaseFields()
    return {
        {"Player", Cfg.WhIncludeName and LocalPlayer.Name or "(hidden)", true},
        {"Level / Sea", tostring(U.Level()) .. " / " .. tostring(Sea), true},
        {"Executor", Misc.Executor(), true},
        {"Status", Farm.StatusText, false},
    }
end

function Misc.SendWebhook(title, desc, fields, color)
    local url = Cfg.WebhookURL
    if type(url) ~= "string" or not url:find("discord.com/api/webhooks/", 1, true) then
        return false, "webhook URL is not set"
    end
    local embed = {
        title = trunc(title, 250), description = trunc(desc, 1900), color = color or 0x8C50FF, fields = {},
        footer = {text = "Morgan Hub " .. Misc.Version}, timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
    for _, f in ipairs(fields or {}) do
        local v = tostring(f[2] or "")
        table.insert(embed.fields, {name = trunc(f[1], 250), value = v == "" and "-" or trunc(v, 1000), inline = f[3] and true or false})
    end
    local body = HttpService:JSONEncode({username = "Morgan Hub", embeds = {embed}})
    return Misc.HttpRequest({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
end

-- optional event alerts (each has its own switch, all off by default, 20s throttle per kind)
function Misc.Alert(flag, title, desc, color, extra)
    if not Cfg[flag] then return end
    local now = os.clock()
    if Misc.WhLast[flag] and now - Misc.WhLast[flag] < 20 then return end
    Misc.WhLast[flag] = now
    local fields = Misc.BaseFields()
    for _, e in ipairs(extra or {}) do table.insert(fields, e) end
    U.Spawn(function() Misc.SendWebhook(title, desc, fields, color) end)
end

function Misc.ReportError(msg)
    if not Cfg.WhErrors then return end
    local now = os.clock()
    if Misc.WhLast.err and now - Misc.WhLast.err < 60 then return end
    Misc.WhLast.err = now
    U.Spawn(function() Misc.SendWebhook("Script error", "```" .. trunc(msg, 1500) .. "```", Misc.BaseFields(), 0xFF5050) end)
end

function Misc.SendBug()
    if os.clock() - Misc.LastBug < 30 then
        UI.Notify("Bugs & Issues", "Please wait 30 seconds between reports.", 4)
        return
    end
    if #Misc.BugText < 5 then
        UI.Notify("Bugs & Issues", "Describe the problem first (a few words at least).", 4)
        return
    end
    Misc.LastBug = os.clock()
    local errs = (#U.ErrLog > 0) and table.concat(U.ErrLog, "\n") or "none"
    local fields = Misc.BaseFields()
    table.insert(fields, {"Category", Misc.BugCat, true})
    table.insert(fields, {"Version", Misc.Version, true})
    table.insert(fields, {"Recent errors", "```" .. trunc(errs, 900) .. "```", false})
    table.insert(fields, {"Self-test", "```" .. trunc(Misc.SelfTest(), 900) .. "```", false})
    local ok, err = Misc.SendWebhook("Bug report: " .. Misc.BugCat, Misc.BugText, fields, 0xFF9040)
    if ok then
        UI.Notify("Bugs & Issues", "Report sent. Thank you!", 4)
    else
        Misc.LastBug = -100
        UI.Notify("Bugs & Issues", "Could not send: " .. tostring(err), 6)
    end
end

function Misc.SendTest()
    local ok, err = Misc.SendWebhook("Test message", "The webhook works.", Misc.BaseFields(), 0x50DC8C)
    UI.Notify("Webhook", ok and "Test message sent." or ("Failed: " .. tostring(err)), 5)
end

Misc.LastLvlSent = nil
U.Loop(30, function()
    local lvl = U.Level()
    if not Misc.LastLvlSent or lvl < Misc.LastLvlSent then Misc.LastLvlSent = lvl return end
    if lvl - Misc.LastLvlSent >= 50 then
        Misc.LastLvlSent = lvl
        Misc.Alert("WhLevel", "Level milestone", "Reached level " .. lvl, 0x50DC8C)
    end
end)

-- fruit hop: hop to a fresh server when no fruit is lying around for a while
Misc.FruitSeenAt, Misc.LastFruitHop = os.clock(), -100
U.Loop(2, function()
    if not Cfg.FruitHop then
        Misc.FruitSeenAt = os.clock()
        return
    end
    for _, o in ipairs(Workspace:GetChildren()) do
        if o:IsA("Tool") and o.Name:find("Fruit") then
            Misc.FruitSeenAt = os.clock()
            return
        end
    end
    if os.clock() - Misc.FruitSeenAt > Cfg.HopWait and os.clock() - Misc.LastFruitHop > 20 then
        Misc.LastFruitHop = os.clock()
        UI.Notify("Fruit Hop", "No fruit here, hopping to a new server.", 4)
        Misc.Hop()
    end
end)

-- =============================================================================
-- SAFETY  (admin detector, auto reconnect, anti-AFK boost)
-- =============================================================================
Misc.RankCache = {}
Misc.LastAdminHop = 0

function Misc.StaffRank(p)
    if p == LocalPlayer then return 0 end
    if game.CreatorType ~= Enum.CreatorType.Group then return 0 end
    local cached = Misc.RankCache[p.UserId]
    if cached ~= nil then return cached end
    local ok, rank = pcall(function() return p:GetRankInGroup(game.CreatorId) end)
    rank = (ok and type(rank) == "number") and rank or 0
    Misc.RankCache[p.UserId] = rank
    return rank
end

function Misc.CheckStaff()
    if not Cfg.AdminHop or os.clock() - Misc.LastAdminHop < 30 then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and Misc.StaffRank(p) >= Cfg.AdminRank then
            Misc.LastAdminHop = os.clock()
            UI.Notify("Staff Detected", p.Name .. " is in this server. Hopping to another server...", 6)
            Misc.Alert("WhStaff", "Staff detected", "Leaving the server (" .. p.Name .. ")", 0xFF5050)
            task.wait(1)
            Misc.Hop()
            return
        end
    end
end

U.Conn(Players.PlayerAdded, function() U.Spawn(Misc.CheckStaff) end)
U.Loop(10, Misc.CheckStaff)

do
    local GuiService = game:GetService("GuiService")
    U.Conn(GuiService.ErrorMessageChanged, function(msg)
        if Cfg.AutoReconnect and msg and msg ~= "" then
            task.wait(4)
            pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
        end
    end)
end

-- extra idle protection on top of the normal anti-AFK
U.Loop(240, function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
end)

-- =============================================================================
-- CONFIG SAVE / LOAD
-- =============================================================================
Misc.CfgFile = "MorganHubV3.json"
Misc.NoPersist = {PvpKill = true, PvpHunt = true, Fly = true, Aimbot = true, Noclip = true, PvpTargetName = true}

function Misc.Snapshot()
    local t = {}
    for k, v in pairs(Cfg) do
        local tv = type(v)
        if (tv == "boolean" or tv == "number" or tv == "string") and not Misc.NoPersist[k] then t[k] = v end
    end
    return t
end

function Misc.SaveConfig()
    if not (writefile and Cfg.SaveConfig) then return end
    local ok, json = pcall(function() return HttpService:JSONEncode(Misc.Snapshot()) end)
    if ok and json ~= Misc.LastSaved then
        Misc.LastSaved = json
        pcall(writefile, Misc.CfgFile, json)
    end
end

function Misc.LoadConfig()
    if not (isfile and readfile) then return false end
    local exists = false
    pcall(function() exists = isfile(Misc.CfgFile) end)
    if not exists then return false end
    local ok, t = pcall(function() return HttpService:JSONDecode(readfile(Misc.CfgFile)) end)
    if not ok or type(t) ~= "table" then return false end
    for k, v in pairs(t) do
        if Cfg[k] ~= nil and type(Cfg[k]) == type(v) and not Misc.NoPersist[k] then Cfg[k] = v end
    end
    return true
end

function Misc.ResetConfig()
    Cfg.SaveConfig = false
    if delfile and isfile and isfile(Misc.CfgFile) then pcall(delfile, Misc.CfgFile) end
    UI.Notify("Config", "Saved config deleted. Re-execute the script to use defaults.", 5)
end

U.Loop(4, Misc.SaveConfig)

-- =============================================================================
-- SHUTDOWN
-- =============================================================================
function U.Shutdown()
    pcall(Misc.SaveConfig)
    genv.MorganHubRunId = nil
    for k, v in pairs(Cfg) do
        if type(v) == "boolean" and k ~= "PvpSkipTeam" then Cfg[k] = false end
    end
    for _, c in ipairs(U.Conns) do pcall(function() c:Disconnect() end) end
    Move.Cancel()
    pcall(function()
        local root = U.Root()
        if root then
            for _, n in ipairs({"MorganFloat", "MorganFly"}) do
                local o = root:FindFirstChild(n)
                if o then o:Destroy() end
            end
        end
    end)
    for kind in pairs(ESP.Store) do ESP.Clear(kind) end
    pcall(function() ESP.Holder:Destroy() end)
    Misc.SetFullbright(false)
    Misc.SetNoFog(false)
    Misc.WaterWalk(false)
    pcall(function() UI.Gui:Destroy() end)
end

-- =============================================================================
-- LOAD SAVED CONFIG, THEN BUILD THE GUI
-- =============================================================================
local loadedCfg = Misc.LoadConfig()

if not table.find(Data.MobList, Cfg.SelectedMob) then Cfg.SelectedMob = Data.MobList[1] or "" end
do
    local bosses = Data.Bosses[Sea] or {}
    if not table.find(bosses, Cfg.SelectedBoss) then Cfg.SelectedBoss = bosses[1] or "" end
end

local Win = UI.CreateWindow("Morgan Hub V3", "Ultimate Edition  |  Blox Fruits  |  Sea " .. Sea)

local TabHome    = Win:CreateTab("Home", "🏠")
local TabFarm    = Win:CreateTab("Auto Farm", "⚔️")
local TabMore    = Win:CreateTab("More Farm", "🎯")
local TabFruit   = Win:CreateTab("Fruits", "🍎")
local TabFish    = Win:CreateTab("Fishing", "🎣")
local TabStats   = Win:CreateTab("Stats", "📊")
local TabTp      = Win:CreateTab("Teleport", "🏝️")
local TabPvp     = Win:CreateTab("PVP", "🥊")
local TabShop    = Win:CreateTab("Shop", "🛒")
local TabPlayer  = Win:CreateTab("Player", "🏃")
local TabVisual  = Win:CreateTab("Visual", "👁️")
local TabSafe    = Win:CreateTab("Safety", "🛡️")
local TabBugs    = Win:CreateTab("Bugs & Issues", "🐞")
local TabSet     = Win:CreateTab("Settings", "⚙️")

-- ---------------------------------------------------------------------------
-- HOME  (two hero switches + live status)
-- ---------------------------------------------------------------------------
TabHome:Section("Main Switches")
TabHome:BigToggle("AUTO FARM", "Quests, island and mob by your level.",
    Cfg.AutoFarm, function(v)
        Cfg.AutoFarm = v
        if not v then Move.Cancel() Farm.Target = nil end
    end, "AutoFarm", Color3.fromRGB(120, 70, 255), Color3.fromRGB(70, 190, 255))

TabHome:BigToggle("PIRATE RAID", "Joins the raid when it starts, then farming resumes.",
    Cfg.PirateRaid, function(v)
        Cfg.PirateRaid = v
        if not v then Move.Cancel() end
    end, "PirateRaid", Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 170, 60))

TabHome:Section("Live")
local Stat = TabHome:StatRow({"LEVEL", "SEA", "FPS"})
local LblStatus = TabHome:Label("Status: Idle")

TabHome:Section("Quick Actions")
TabHome:Button("Stop Everything", function()
    for _, k in ipairs({"AutoFarm", "PirateRaid", "AutoChest", "AutoCollectFruit", "FarmNearest", "FarmMob",
                        "FarmBoss", "EliteHunter", "PvpKill", "PvpHunt", "BoneFarm", "MasteryFarm", "AutoRaid", "FishFarm"}) do
        if UI.T[k] then UI.T[k].Set(false) else Cfg[k] = false end
    end
    Move.StopTeleport()
    U.Notify("Morgan Hub", "All automation stopped.", 3)
end)
TabHome:Label("Tip: '-' hides the window, the round M button brings it back.")

local fpsSmooth = 60
U.Conn(RunService.RenderStepped, function(dt)
    if dt > 0 then fpsSmooth = fpsSmooth * 0.95 + (1 / dt) * 0.05 end
end)

U.Loop(0.5, function()
    local lvl = U.Level()
    Stat.Set(1, lvl)
    Stat.Set(2, Sea)
    Stat.Set(3, math.floor(fpsSmooth))
    if UI.ProfileSub then UI.ProfileSub.Text = "Level " .. lvl end
    local row = Farm.GetRow(lvl)
    LblStatus.Set("Status: " .. Farm.StatusText .. "\nTarget: " .. (row and (row[2] .. " @ " .. row[7]) or "-")
        .. "\nWeapon: " .. Farm.Weapon())
    if UI.T.AutoFarm then
        UI.T.AutoFarm.SetStatus(Cfg.AutoFarm and ("Running: " .. Farm.StatusText)
            or "Quests, island and mob by your level.")
    end
    if UI.T.PirateRaid then
        UI.T.PirateRaid.SetStatus((Cfg.PirateRaid and Farm.StatusText:sub(1, 11) == "Pirate Raid")
            and Farm.StatusText or (Cfg.PirateRaid and "Armed. Waiting for a raid."
            or "Joins the raid when it starts, then farming resumes."))
    end
end)

-- ---------------------------------------------------------------------------
-- AUTO FARM
-- ---------------------------------------------------------------------------
TabFarm:Section("Level Farm")
TabFarm:Toggle("Take Quests", Cfg.UseQuest, function(v) Cfg.UseQuest = v end)
TabFarm:Dropdown("Weapon Type", {"Melee", "Sword", "Gun", "Blox Fruit"}, Cfg.WeaponType, function(v) Cfg.WeaponType = v end)
TabFarm:Toggle("Auto Buso Haki", Cfg.AutoBuso, function(v) Cfg.AutoBuso = v end)
TabFarm:Toggle("Auto Observation (Ken)", Cfg.AutoKen, function(v) Cfg.AutoKen = v end)
TabFarm:Toggle("Auto Travel To Next Sea", Cfg.AutoSeaTravel, function(v) Cfg.AutoSeaTravel = v end)
TabFarm:Toggle("Stop Auto Farm At Target Level", Cfg.StopAtTarget, function(v) Cfg.StopAtTarget = v end)
TabFarm:Slider("Target Level", 100, 3000, Cfg.TargetLevel, function(v) Cfg.TargetLevel = v end, 25)

TabFarm:Section("Movement")
TabFarm:Slider("Travel / Tween Speed (all movement)", 20, 350, Cfg.TweenSpeed, function(v) Cfg.TweenSpeed = v end, 5)
TabFarm:Slider("Farm Height", 5, 40, Cfg.FarmHeight, function(v) Cfg.FarmHeight = v end, 1)

TabFarm:Section("Combat")
TabFarm:Toggle("Fast Attack", Cfg.FastAttack, function(v) Cfg.FastAttack = v end)
TabFarm:Dropdown("Attack Mode", {"Auto-Detect", "Ultra (Net+Combat)", "Combat Framework", "Click Only"}, Cfg.AttackMode,
    function(v) Cfg.AttackMode = v end)
TabFarm:Dropdown("Click Method", {"Both", "VirtualUser", "VirtualInputManager"}, Cfg.ClickMethod,
    function(v) Cfg.ClickMethod = v end)
TabFarm:Slider("Attack Range", 30, 120, Cfg.AttackRange, function(v) Cfg.AttackRange = v end, 5)
TabFarm:Toggle("Magnet (Bring Mobs)", Cfg.BringMobs, function(v) Cfg.BringMobs = v end)
TabFarm:Slider("Magnet Radius", 100, 600, Cfg.BringRadius, function(v) Cfg.BringRadius = v end, 20)
TabFarm:Toggle("Hitbox Expander (Mobs)", Cfg.Hitbox, function(v) Cfg.Hitbox = v end)
TabFarm:Slider("Hitbox Size", 10, 80, Cfg.HitboxSize, function(v) Cfg.HitboxSize = v end, 5)

TabFarm:Section("Auto Skills (only while fighting)")
TabFarm:Toggle("Skill Z", Cfg.SkillZ, function(v) Cfg.SkillZ = v end)
TabFarm:Toggle("Skill X", Cfg.SkillX, function(v) Cfg.SkillX = v end)
TabFarm:Toggle("Skill C", Cfg.SkillC, function(v) Cfg.SkillC = v end)
TabFarm:Toggle("Skill V", Cfg.SkillV, function(v) Cfg.SkillV = v end)
TabFarm:Toggle("Skill F", Cfg.SkillF, function(v) Cfg.SkillF = v end)

-- ---------------------------------------------------------------------------
-- MORE FARM
-- ---------------------------------------------------------------------------
TabMore:Section("Pirate Raid")
TabMore:Toggle("Wait At Castle When Idle", Cfg.PirateIdleWait, function(v) Cfg.PirateIdleWait = v end)
TabMore:Label("Turn on PIRATE RAID on the Home tab. It only interrupts your farm while a raid is active.")

TabMore:Section("Bone Farm (Sea 3)")
TabMore:Toggle("Auto Farm Bones (Haunted Castle)", Cfg.BoneFarm, function(v)
    Cfg.BoneFarm = v
    if not v then Move.Cancel() end
end, "BoneFarm")
TabMore:Toggle("Auto Random Surprise (costs 50 bones)", Cfg.AutoRandomSurprise, function(v) Cfg.AutoRandomSurprise = v end)

TabMore:Section("Mastery Farm")
TabMore:Dropdown("Mastery Weapon", {"Blox Fruit", "Sword", "Gun", "Melee"}, Cfg.MasteryType, function(v) Cfg.MasteryType = v end)
TabMore:Toggle("Auto Mastery Farm (forces skills Z X C V)", Cfg.MasteryFarm, function(v)
    Cfg.MasteryFarm = v
    if not v then Move.Cancel() end
end, "MasteryFarm")

TabMore:Section("Fruit Raid (Dungeon)")
TabMore:Dropdown("Raid Type", Data.RaidTypes, Cfg.RaidType, function(v) Cfg.RaidType = v end)
TabMore:Toggle("Auto Raid (buys chip, starts, clears islands)", Cfg.AutoRaid, function(v)
    Cfg.AutoRaid = v
    if not v then Move.Cancel() end
end, "AutoRaid")

TabMore:Section("Mob Farming")
TabMore:Toggle("Farm Nearest Mob (Mob Aura)", Cfg.FarmNearest, function(v)
    Cfg.FarmNearest = v
    if not v then Move.Cancel() end
end, "FarmNearest")
TabMore:Dropdown("Select Mob", Data.MobList, Cfg.SelectedMob, function(v) Cfg.SelectedMob = v end)
TabMore:Toggle("Farm Selected Mob", Cfg.FarmMob, function(v)
    Cfg.FarmMob = v
    if not v then Move.Cancel() end
end, "FarmMob")

TabMore:Section("Bosses")
TabMore:Dropdown("Select Boss", Data.Bosses[Sea] or {}, Cfg.SelectedBoss, function(v) Cfg.SelectedBoss = v end)
TabMore:Toggle("Farm Selected Boss", Cfg.FarmBoss, function(v)
    Cfg.FarmBoss = v
    if not v then Move.Cancel() end
end, "FarmBoss")
TabMore:Toggle("Auto Elite Hunter", Cfg.EliteHunter, function(v)
    Cfg.EliteHunter = v
    if not v then Move.Cancel() end
end, "EliteHunter")
TabMore:Toggle("Auto Collect Chests", Cfg.AutoChest, function(v)
    Cfg.AutoChest = v
    if not v then Move.Cancel() end
end, "AutoChest")
TabMore:Label("Saber, Rengoku and CDK quest chains are not automated. Use Boss Farm for sword drops.")

-- ---------------------------------------------------------------------------
-- FRUITS
-- ---------------------------------------------------------------------------
TabFruit:Section("Collect / Store")
TabFruit:Toggle("Auto Collect Fruit", Cfg.AutoCollectFruit, function(v)
    Cfg.AutoCollectFruit = v
    if not v then Move.Cancel() end
end, "AutoCollectFruit")
TabFruit:Toggle("Auto Store Fruit", Cfg.AutoStoreFruit, function(v) Cfg.AutoStoreFruit = v end)
TabFruit:Button("Store All Fruits Now", function()
    local n = Items.StoreAll()
    UI.Notify("Fruits", "Tried to store " .. n .. " fruit(s).", 3)
end)
TabFruit:Toggle("Fruit Spawn Notifier", Cfg.FruitNotify, function(v) Cfg.FruitNotify = v end)
TabFruit:Toggle("Fruit ESP", Cfg.ESPFruit, function(v) Cfg.ESPFruit = v end)
TabFruit:Toggle("Hop Servers Until A Fruit Spawns", Cfg.FruitHop, function(v) Cfg.FruitHop = v end)
TabFruit:Slider("Hop After (seconds without fruit)", 15, 180, Cfg.HopWait, function(v) Cfg.HopWait = v end, 5)
TabFruit:Label("Fruit Hop restarts the script after each hop, so keep it in Delta's autoexecute folder.")

TabFruit:Section("Random Fruit (costs Beli)")
TabFruit:Button("Buy Random Fruit Now", function() U.Comm("Cousin", "Buy") end)
TabFruit:Toggle("Auto Buy Random Fruit", Cfg.AutoRandomFruit, function(v) Cfg.AutoRandomFruit = v end)
TabFruit:Label("Fruit rarity is decided by the server, so luck cannot be changed from the client.")

-- ---------------------------------------------------------------------------
-- FISHING
-- ---------------------------------------------------------------------------
TabFish:Section("Auto Fish")
TabFish:Toggle("Auto Fish (cast + reel macro)", Cfg.FishFarm, function(v)
    Cfg.FishFarm = v
    if not v and Fish.Holding then Fish.Mouse(false) end
end, "FishFarm")
TabFish:Toggle("Auto Sell Fish (at the Fisherman)", Cfg.FishSell, function(v) Cfg.FishSell = v end)
TabFish:Toggle("Auto Buy Bait (Basic Bait)", Cfg.FishBait, function(v) Cfg.FishBait = v end)
TabFish:Slider("Restock Every (minutes, 0 = never)", 0, 30, Cfg.FishRestock, function(v) Cfg.FishRestock = v end, 1)
TabFish:Section("Actions")
TabFish:Button("Go To Fisherman + Sell Fish + Buy Bait Now", function() Fish.Restock() end)
TabFish:Button("Stop Fishing Click", function() if Fish.Holding then Fish.Mouse(false) end end)
TabFish:Label("Get the rod from the Fisherman first, then stand on a dock facing the water and switch Auto Fish on.")

-- ---------------------------------------------------------------------------
-- STATS
-- ---------------------------------------------------------------------------
TabStats:Section("Auto Stats")
TabStats:Toggle("Enable Auto Stats", Cfg.StatOn, function(v) Cfg.StatOn = v end)
TabStats:Toggle("Melee", Cfg.StatMelee, function(v) Cfg.StatMelee = v end)
TabStats:Toggle("Defense", Cfg.StatDefense, function(v) Cfg.StatDefense = v end)
TabStats:Toggle("Sword", Cfg.StatSword, function(v) Cfg.StatSword = v end)
TabStats:Toggle("Gun", Cfg.StatGun, function(v) Cfg.StatGun = v end)
TabStats:Toggle("Blox Fruit", Cfg.StatFruit, function(v) Cfg.StatFruit = v end)
TabStats:Slider("Points Per Tick", 1, 99, Cfg.StatAmount, function(v) Cfg.StatAmount = v end, 1)

-- ---------------------------------------------------------------------------
-- TELEPORT
-- ---------------------------------------------------------------------------
TabTp:Section("Sea Travel")
TabTp:Button("Travel To Sea 1", function() U.Comm("TravelMain") end)
TabTp:Button("Travel To Sea 2", function() U.Comm("TravelDressrosa") end)
TabTp:Button("Travel To Sea 3", function() U.Comm("TravelZou") end)
TabTp:Button("Stop Teleport", function() Move.StopTeleport() end)

TabTp:Section("Islands (Sea " .. Sea .. ")")
for _, isl in ipairs(Data.Islands) do
    TabTp:Button(isl.name, function() Move.Go(isl.pos + V3(0, 3, 0), isl.ent) end)
end
if Sea == 3 then
    TabTp:Button("Castle on the Sea", function() Move.Go(Data.CastlePos + V3(0, 10, 0)) end)
    TabTp:Section("Submerged Island")
    TabTp:Button("Go To Submarine Worker + Try Enter", function() Farm.EnterSubmerged() end)
end

-- ---------------------------------------------------------------------------
-- PVP
-- ---------------------------------------------------------------------------
TabPvp:Section("Target")
local ddPlayers = TabPvp:Dropdown("Select Player", PvP.PlayerNames(), "-", function(v) Cfg.PvpTargetName = v end)
TabPvp:Button("Refresh Player List", function() ddPlayers.SetOptions(PvP.PlayerNames()) end)
U.Conn(Players.PlayerAdded, function() ddPlayers.SetOptions(PvP.PlayerNames()) end)
U.Conn(Players.PlayerRemoving, function() task.delay(0.2, function() ddPlayers.SetOptions(PvP.PlayerNames()) end) end)
TabPvp:Button("Teleport To Player", function()
    local p = Players:FindFirstChild(Cfg.PvpTargetName)
    local _, r = PvP.Valid(p)
    if r then Move.Go(r.Position + V3(0, 4, 0)) end
end)
TabPvp:Toggle("Spectate Player", false, function(v)
    local cam = Workspace.CurrentCamera
    if v then
        local p = Players:FindFirstChild(Cfg.PvpTargetName)
        local c = p and p.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then cam.CameraSubject = h end
    else
        local h = U.Hum()
        if h then cam.CameraSubject = h end
    end
end)

TabPvp:Section("Fighting")
TabPvp:Toggle("Auto Kill Selected Player", false, function(v)
    Cfg.PvpKill = v
    if not v then Move.Cancel() end
end, "PvpKill")
TabPvp:Toggle("Auto Hunt Nearest Player", false, function(v)
    Cfg.PvpHunt = v
    if not v then Move.Cancel() end
end, "PvpHunt")
TabPvp:Toggle("Skip Teammates / Forcefield", Cfg.PvpSkipTeam, function(v) Cfg.PvpSkipTeam = v end)
TabPvp:Toggle("Camera Aimbot", false, function(v) Cfg.Aimbot = v end)
TabPvp:Slider("Aimbot FOV", 60, 600, Cfg.AimFOV, function(v) Cfg.AimFOV = v end, 10)
TabPvp:Toggle("Player Hitbox Expander", Cfg.PlayerHitbox, function(v) Cfg.PlayerHitbox = v end)
TabPvp:Slider("Player Hitbox Size", 5, 50, Cfg.PlayerHitboxSize, function(v) Cfg.PlayerHitboxSize = v end, 1)
TabPvp:Toggle("Player ESP", Cfg.ESPPlayer, function(v) Cfg.ESPPlayer = v end)

-- ---------------------------------------------------------------------------
-- SHOP
-- ---------------------------------------------------------------------------
local function ShopBtn(tab, label, ...)
    local args = table.pack(...)
    tab:Button(label, function()
        U.Comm(table.unpack(args, 1, args.n))
        UI.Notify("Shop", "Request sent: " .. label, 2)
    end)
end

TabShop:Section("Abilities")
ShopBtn(TabShop, "Buy Geppo", "BuyHaki", "Geppo")
ShopBtn(TabShop, "Buy Buso Haki", "BuyHaki", "Buso")
ShopBtn(TabShop, "Buy Soru", "BuyHaki", "Soru")

TabShop:Section("Fighting Styles")
for _, s in ipairs({
    {"Black Leg", "BuyBlackLeg"}, {"Electro", "BuyElectro"}, {"Fishman Karate", "BuyFishmanKarate"},
    {"Dragon Claw", "BuyDragonClaw"}, {"Superhuman", "BuySuperhuman"}, {"Death Step", "BuyDeathStep"},
    {"Sharkman Karate", "BuySharkmanKarate"}, {"Electric Claw", "BuyElectricClaw"},
    {"Dragon Talon", "BuyDragonTalon"}, {"Godhuman", "BuyGodhuman"}, {"Sanguine Art", "BuySanguineArt"},
}) do
    ShopBtn(TabShop, "Buy " .. s[1], s[2])
end

TabShop:Section("Swords")
for _, n in ipairs({"Cutlass", "Katana", "Iron Mace", "Duel Katana", "Triple Katana", "Pipe",
                    "Dual-Headed Blade", "Bisento", "Soul Cane"}) do
    ShopBtn(TabShop, "Buy " .. n, "BuyItem", n)
end

TabShop:Section("Guns")
for _, n in ipairs({"Slingshot", "Musket", "Flintlock", "Refined Flintlock", "Cannon"}) do
    ShopBtn(TabShop, "Buy " .. n, "BuyItem", n)
end

TabShop:Section("Accessories")
for _, n in ipairs({"Black Cape", "Swordsman Hat", "Tomoe Ring"}) do
    ShopBtn(TabShop, "Buy " .. n, "BuyItem", n)
end
TabShop:Section("Misc")
ShopBtn(TabShop, "Set Spawn Point (Home)", "SetSpawnPoint")

-- ---------------------------------------------------------------------------
-- PLAYER
-- ---------------------------------------------------------------------------
TabPlayer:Section("Movement")
TabPlayer:Toggle("WalkSpeed", Cfg.Speed, function(v)
    Cfg.Speed = v
    if not v then local h = U.Hum() if h then h.WalkSpeed = 16 end end
end)
TabPlayer:Slider("WalkSpeed Value", 16, 300, Cfg.SpeedVal, function(v) Cfg.SpeedVal = v end, 2)
TabPlayer:Toggle("JumpPower", Cfg.Jump, function(v)
    Cfg.Jump = v
    if not v then local h = U.Hum() if h then h.UseJumpPower = true h.JumpPower = 50 end end
end)
TabPlayer:Slider("JumpPower Value", 50, 400, Cfg.JumpVal, function(v) Cfg.JumpVal = v end, 5)
TabPlayer:Toggle("Infinite Jump", Cfg.InfJump, function(v) Cfg.InfJump = v end)
TabPlayer:Toggle("Noclip", false, function(v) Cfg.Noclip = v end)
TabPlayer:Toggle("Fly", false, function(v) Cfg.Fly = v end)
TabPlayer:Slider("Fly Speed", 30, 300, Cfg.FlySpeed, function(v) Cfg.FlySpeed = v end, 5)
TabPlayer:Toggle("Walk On Water", Cfg.WalkWater, function(v) Cfg.WalkWater = v Misc.WaterWalk(v) end)
TabPlayer:Section("Character")
TabPlayer:Button("Reset Character", function() local h = U.Hum() if h then h.Health = 0 end end)

-- ---------------------------------------------------------------------------
-- VISUAL
-- ---------------------------------------------------------------------------
TabVisual:Section("Screen")
TabVisual:Toggle("Stretched Screen", Cfg.Stretch, function(v) Cfg.Stretch = v end)
TabVisual:Slider("Stretch Amount", 0.3, 1, Cfg.StretchAmt, function(v) Cfg.StretchAmt = v end, 0.05)
TabVisual:Toggle("Fullbright", Cfg.Fullbright, function(v) Cfg.Fullbright = v Misc.SetFullbright(v) end)
TabVisual:Toggle("No Fog", Cfg.NoFog, function(v) Cfg.NoFog = v Misc.SetNoFog(v) end)
TabVisual:Toggle("FPS Boost (textures, shadows, effects)", Cfg.FpsBoost, function(v) Misc.SetFpsBoost(v) end)
TabVisual:Section("ESP")
TabVisual:Toggle("Mob ESP", Cfg.ESPMob, function(v) Cfg.ESPMob = v end)
TabVisual:Toggle("Chest ESP", Cfg.ESPChest, function(v) Cfg.ESPChest = v end)
TabVisual:Label("Player ESP is in the PVP tab, Fruit ESP is in the Fruits tab.")

-- ---------------------------------------------------------------------------
-- SAFETY
-- ---------------------------------------------------------------------------
TabSafe:Section("Staff / Admin")
TabSafe:Toggle("Leave Server When Staff Joins", Cfg.AdminHop, function(v) Cfg.AdminHop = v end)
TabSafe:Slider("Min Staff Rank (game group)", 2, 255, Cfg.AdminRank, function(v) Cfg.AdminRank = v end, 1)
TabSafe:Label("Anyone in this server with a rank above the minimum in the game's group counts as staff.")
TabSafe:Button("Hop To Another Server Now", function() Misc.Hop() end)

TabSafe:Section("Connection")
TabSafe:Toggle("Auto Reconnect After Disconnect", Cfg.AutoReconnect, function(v) Cfg.AutoReconnect = v end)
TabSafe:Label("Anti-AFK is always on. Use Delta's autoexecute folder to resume after a rejoin.")

TabSafe:Section("Survival")
TabSafe:Toggle("Escape To The Sky At Low HP", Cfg.LowHPEscape, function(v) Cfg.LowHPEscape = v end)
TabSafe:Slider("Escape Below HP %", 10, 60, Cfg.EscapeHP, function(v) Cfg.EscapeHP = v end, 5)

-- ---------------------------------------------------------------------------
-- BUGS & ISSUES  (Discord webhook)
-- ---------------------------------------------------------------------------
TabBugs:Section("Report A Bug")
TabBugs:Dropdown("Category", {"Auto Farm", "Quests", "Fast Attack", "Fishing", "Teleport", "PVP", "Fruits", "GUI", "Crash / Error", "Other"},
    Misc.BugCat, function(v) Misc.BugCat = v end)
TabBugs:TextArea("What went wrong?", "Example: Auto Farm stops at the Bandit quest NPC and never attacks.", 96,
    function(t) Misc.BugText = t end)
TabBugs:Button("Send Bug Report To Discord", function() Misc.SendBug() end)
TabBugs:Label("Sends your text, category, level, sea, executor, status, recent errors and self-test. Nothing is sent automatically.")
TabBugs:Toggle("Include My Roblox Username", Cfg.WhIncludeName, function(v) Cfg.WhIncludeName = v end)

TabBugs:Section("Discord Alerts (all off by default)")
TabBugs:Toggle("Alert: Fruit Spawned", Cfg.WhAlerts, function(v) Cfg.WhAlerts = v end)
TabBugs:Toggle("Alert: Staff Detected", Cfg.WhStaff, function(v) Cfg.WhStaff = v end)
TabBugs:Toggle("Alert: Farm Got Stuck", Cfg.WhStuck, function(v) Cfg.WhStuck = v end)
TabBugs:Toggle("Alert: Level Milestone (every 50 levels)", Cfg.WhLevel, function(v) Cfg.WhLevel = v end)
TabBugs:Toggle("Send Script Errors Automatically", Cfg.WhErrors, function(v) Cfg.WhErrors = v end)

TabBugs:Section("Webhook")
TabBugs:Input("Webhook URL", "https://discord.com/api/webhooks/...", Cfg.WebhookURL, function(t) Cfg.WebhookURL = t end)
TabBugs:Button("Send Test Message", function() Misc.SendTest() end)

-- ---------------------------------------------------------------------------
-- SETTINGS
-- ---------------------------------------------------------------------------
TabSet:Section("Interface")
TabSet:Slider("GUI Scale", 0.6, 1.2, Cfg.UIScale, function(v)
    Cfg.UIScale = v
    if UI.Scale then UI.Scale.Scale = v end
end, 0.05)
TabSet:Dropdown("GUI Theme", {"Rain", "Snow", "Sakura"}, Cfg.Theme, function(v) UI.SetTheme(v) end)
TabSet:Toggle("Particle Effect (rain / snow / petals)", Cfg.Rain, function(v) Cfg.Rain = v end)
TabSet:Input("Logo Image URL", "https://.../logo.png", Cfg.LogoURL, function(t) Cfg.LogoURL = t end)
TabSet:Input("Logo Roblox Asset", "rbxassetid://123456789", Cfg.LogoAsset, function(t) UI.SetLogoAsset(t) end)
TabSet:Button("Apply Logo From URL", function() UI.SetLogoURL(Cfg.LogoURL) end)

TabSet:Section("Config")
TabSet:Toggle("Auto Save Settings", Cfg.SaveConfig, function(v) Cfg.SaveConfig = v end)
TabSet:Button("Delete Saved Config", function() Misc.ResetConfig() end)

TabSet:Section("Server")
TabSet:Button("Rejoin Server", function() Misc.Rejoin() end)
TabSet:Button("Server Hop", function() Misc.Hop() end)
TabSet:Button("Copy Job ID", function()
    if setclipboard then
        setclipboard(game.JobId)
        UI.Notify("Settings", "Job ID copied.", 3)
    else
        UI.Notify("Settings", "Your executor has no clipboard support.", 3)
    end
end)

TabSet:Section("Troubleshooting")
local lblTest = TabSet:Label("Self-test not run yet.")
TabSet:Button("Run Self-Test (checks every module)", function()
    local report = Misc.SelfTest()
    lblTest.Set(report)
    print("[MorganHub SelfTest]\n" .. report)
end)
TabSet:Button("Print Debug Info (executor console)", function() Misc.Debug() end)
TabSet:Label("Quests or attacks misbehaving? Run the self-test and send it through Bugs & Issues.")
TabSet:Section("Script")
TabSet:Button("Unload Morgan Hub", function() U.Shutdown() end)

-- apply side effects of restored settings
if Cfg.FpsBoost then Misc.SetFpsBoost(true) end
if Cfg.LogoAsset and Cfg.LogoAsset ~= "" then
    U.Spawn(function() UI.SetLogoAsset(Cfg.LogoAsset) end)
end
if Cfg.LogoURL ~= "" then
    U.Spawn(function() UI.SetLogoURL(Cfg.LogoURL) end)
end
if Cfg.Fullbright then Misc.SetFullbright(true) end
if Cfg.NoFog then Misc.SetNoFog(true) end
if Cfg.WalkWater then Misc.WaterWalk(true) end

UI.Notify("Morgan Hub V3", "Loaded. Sea " .. Sea .. " | Level " .. U.Level()
    .. (loadedCfg and " | settings restored" or ""), 5)
print("[MorganHub] " .. Misc.Version .. " loaded. Sea " .. Sea)

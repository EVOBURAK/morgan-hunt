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
    FarmHeight = 12, TweenSpeed = 40,
    BringMobs = true, BringRadius = 380, Hitbox = true, HitboxSize = 45,
    FastAttack = true, AttackMode = "Ultra (Net+Combat)", AttackRange = 70, ClickMethod = "VirtualUser",
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
    FpsBoost = false, Theme = "Rain", LogoURL = "",
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
function U.Log(msg)
    msg = tostring(msg)
    if not logSeen[msg] then
        logSeen[msg] = true
        warn("[MorganHub] " .. msg)
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

Data.CastlePos = V3(-5496.2, 313.8, -2841.5) -- Castle on the Sea (Sea 3), pirate raid spot

Data.Bosses = {
    [1] = {"Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral", "Saber Expert", "Warden",
           "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Ice Admiral"},
    [2] = {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Cursed Captain", "Darkbeard", "Order",
           "Awakened Ice Admiral", "Tide Keeper"},
    [3] = {"Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen",
           "Longma", "Soul Reaper", "Cake Prince", "Dough King", "rip_indra True Form"},
}
Data.EliteNames = {"Deandre", "Diablo", "Urban"}
Data.FruitList = {"Rocket", "Spin", "Blade", "Spring", "Bomb", "Smoke", "Spike", "Flame", "Ice", "Sand", "Dark",
    "Falcon", "Diamond", "Light", "Rubber", "Barrier", "Ghost", "Magma", "Quake", "Buddha", "Love", "Spider",
    "Sound", "Phoenix", "Portal", "Rumble", "Pain", "Blizzard", "Gravity", "Mammoth", "T-Rex", "Dough",
    "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard", "Kitsune", "Yeti", "Gas"}
Data.FruitColors = {
    Leopard = Color3.fromRGB(255, 200, 60), Dough = Color3.fromRGB(255, 240, 210), Dragon = Color3.fromRGB(255, 90, 60),
    Venom = Color3.fromRGB(150, 60, 230), Buddha = Color3.fromRGB(255, 220, 60), Kitsune = Color3.fromRGB(120, 200, 255),
    Yeti = Color3.fromRGB(190, 230, 255), Gas = Color3.fromRGB(190, 190, 120), Control = Color3.fromRGB(200, 120, 255),
    Spirit = Color3.fromRGB(120, 255, 200), Shadow = Color3.fromRGB(90, 60, 130), Portal = Color3.fromRGB(255, 140, 220),
}
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
-- UI LIBRARY  (glass window, rain background, scrolling pages)
-- =============================================================================
local Theme = {
    Bg = Color3.fromRGB(8, 8, 14),
    Card = Color3.fromRGB(22, 22, 36),
    Accent = Color3.fromRGB(140, 80, 255),
    Accent2 = Color3.fromRGB(80, 200, 255),
    Text = Color3.fromRGB(240, 240, 252),
    Sub = Color3.fromRGB(165, 165, 190),
    Off = Color3.fromRGB(55, 55, 78),
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
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                        startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

function UI.Notify(title, msg, dur)
    if not UI.ToastHolder then return end
    dur = dur or 4
    local t = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.12, BorderSizePixel = 0,
    }, UI.ToastHolder)
    Corner(t, 8)
    Stroke(t, Theme.Accent, 1, 0.25)
    Pad(t, 10, 6, 10, 6)
    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, t)
    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = tostring(title),
        TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBold, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1,
    }, t)
    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        Text = tostring(msg), TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12,
        TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2,
    }, t)
    task.delay(dur, function() pcall(function() t:Destroy() end) end)
end

function UI.CreateWindow(titleText, subtitleText)
    local cam = Workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local W = math.clamp(vp.X - 30, 340, 700)
    local H = math.clamp(vp.Y - 30, 250, 440)
    local SW = (W < 520) and 112 or 152

    local Gui = New("ScreenGui", {
        Name = "MorganHubV3", ResetOnSpawn = false, DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    Gui.Parent = GuiParent
    UI.Gui = Gui

    -- toast holder
    UI.ToastHolder = New("Frame", {
        Size = UDim2.new(0, 230, 1, -20), AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -10, 1, -10), BackgroundTransparency = 1,
    }, Gui)
    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 6),
    }, UI.ToastHolder)

    -- main glass frame
    local Main = New("Frame", {
        Name = "Main", Size = UDim2.new(0, W, 0, H), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Theme.Bg,
        BackgroundTransparency = 0.22, BorderSizePixel = 0, ClipsDescendants = true,
    }, Gui)
    Corner(Main, 14)
    UI.Scale = New("UIScale", {Scale = Cfg.UIScale}, Main)
    local mainStroke = Stroke(Main, Theme.Accent, 2, 0.1)
    local strokeGrad = New("UIGradient", {
        Color = ColorSequence.new(Theme.Accent, Theme.Accent2), Rotation = 45,
    }, mainStroke)

    -- background artwork (visible through the glass)
    New("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Image = "rbxassetid://92647074735439", ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Crop, ZIndex = 1,
    }, Main)
    -- soft dark tint so text stays readable
    local tint = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(6, 6, 16),
        BackgroundTransparency = 0.45, BorderSizePixel = 0, ZIndex = 1,
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
    local Flash = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(200, 220, 255),
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1,
    }, Main)
    local Themes = {
        Rain = {a = Color3.fromRGB(140, 80, 255), b = Color3.fromRGB(80, 200, 255), tint = Color3.fromRGB(6, 6, 16)},
        Snow = {a = Color3.fromRGB(190, 225, 255), b = Color3.fromRGB(120, 180, 255), tint = Color3.fromRGB(8, 18, 36)},
        Sakura = {a = Color3.fromRGB(255, 140, 190), b = Color3.fromRGB(255, 205, 228), tint = Color3.fromRGB(34, 8, 24)},
    }
    local parts = {}
    local curTheme = "Rain"
    local nextFlash = os.clock() + math.random(6, 14)

    function UI.SetTheme(name)
        if not Themes[name] then name = "Rain" end
        curTheme = name
        Cfg.Theme = name
        for _, p in ipairs(parts) do pcall(function() p.f:Destroy() end) end
        parts = {}
        local count = (W < 520) and 30 or 56
        for i = 1, count do
            local f, p
            if name == "Rain" then
                f = New("Frame", {
                    Size = UDim2.new(0, 1, 0, math.random(10, 24)), BackgroundColor3 = Color3.fromRGB(175, 205, 255),
                    BackgroundTransparency = 0.5 + math.random() * 0.3, BorderSizePixel = 0, Rotation = 12, ZIndex = 1,
                }, Rain)
                p = {f = f, x = math.random(0, W), y = math.random(-H, H), s = math.random(420, 820), k = "rain"}
            elseif name == "Snow" then
                local sz = math.random(3, 6)
                f = New("Frame", {
                    Size = UDim2.new(0, sz, 0, sz), BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 0.1 + math.random() * 0.4, BorderSizePixel = 0, ZIndex = 1,
                }, Rain)
                Corner(f, 3)
                p = {f = f, x = math.random(0, W), y = math.random(-H, H), s = math.random(28, 75),
                     sw = 8 + math.random() * 14, ph = math.random() * 6.28, k = "snow"}
            else
                f = New("Frame", {
                    Size = UDim2.new(0, math.random(7, 11), 0, math.random(5, 7)),
                    BackgroundColor3 = Color3.fromRGB(255, math.random(150, 190), math.random(190, 220)),
                    BackgroundTransparency = 0.15 + math.random() * 0.35, BorderSizePixel = 0, ZIndex = 1,
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
        tint.BackgroundColor3 = th.tint
    end

    U.Conn(RunService.RenderStepped, function(dt)
        if not Main.Visible then return end
        strokeGrad.Rotation = (os.clock() * 40) % 360
        Rain.Visible = Cfg.Rain
        if not Rain.Visible then return end
        local now = os.clock()
        if curTheme == "Rain" and now >= nextFlash then
            nextFlash = now + math.random(8, 18)
            Flash.BackgroundTransparency = 0.82
            TweenService:Create(Flash, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
        end
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
        Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = Color3.fromRGB(4, 4, 10),
        BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2,
    }, Main)
    New("ImageLabel", {
        Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(0, 10, 0, 6), BackgroundTransparency = 1,
        Image = "rbxassetid://119861971194635", ZIndex = 3,
    }, Top)
    New("TextLabel", {
        Size = UDim2.new(1, -230, 0, 24), Position = UDim2.new(0, 52, 0, 4), BackgroundTransparency = 1,
        Text = titleText, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3,
    }, Top)
    New("TextLabel", {
        Size = UDim2.new(1, -230, 0, 14), Position = UDim2.new(0, 52, 0, 27), BackgroundTransparency = 1,
        Text = subtitleText or "", TextColor3 = Theme.Accent2, Font = Enum.Font.Gotham, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3,
    }, Top)

    -- logo in the gap of the top bar (game icon from Roblox, custom URL optional)
    local Logo = New("ImageLabel", {
        Size = UDim2.new(0, 36, 0, 36), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -94, 0.5, 0),
        BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.2, ScaleType = Enum.ScaleType.Crop, ZIndex = 3,
        Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150",
    }, Top)
    Corner(Logo, 10)
    Stroke(Logo, Theme.Accent2, 1.5, 0.15)
    local Emblem = New("TextLabel", {
        Size = UDim2.new(0, 36, 0, 36), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -94, 0.5, 0),
        BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.1, Text = "M", TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBlack, TextSize = 22, Visible = false, ZIndex = 3,
    }, Top)
    Corner(Emblem, 10)
    New("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.Accent2), Rotation = 45}, Emblem)
    task.delay(4, function()
        if Logo.Parent and not Logo.IsLoaded then
            Logo.Visible = false
            Emblem.Visible = true
        end
    end)
    UI.Logo = Logo

    function UI.SetLogoURL(url)
        if not url or url == "" then return false end
        if not (writefile and Ex.CustomAsset) then
            U.Notify("Logo", "Your executor has no writefile/getcustomasset.", 4)
            return false
        end
        local ok, err = pcall(function()
            writefile("MorganLogo.png", game:HttpGet(url))
            Logo.Image = Ex.CustomAsset("MorganLogo.png")
            Logo.Visible = true
            Emblem.Visible = false
        end)
        if not ok then U.Notify("Logo", "Could not load that image URL.", 4) end
        return ok
    end

    local MinBtn = New("TextButton", {
        Size = UDim2.new(0, 42, 1, 0), Position = UDim2.new(1, -84, 0, 0), BackgroundTransparency = 1,
        Text = "-", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 26, ZIndex = 3,
    }, Top)
    local CloseBtn = New("TextButton", {
        Size = UDim2.new(0, 42, 1, 0), Position = UDim2.new(1, -42, 0, 0), BackgroundTransparency = 1,
        Text = "X", TextColor3 = Color3.fromRGB(255, 90, 90), Font = Enum.Font.GothamBold, TextSize = 20, ZIndex = 3,
    }, Top)
    MakeDraggable(Top, Main)

    -- floating open button
    local Float = New("TextButton", {
        Size = UDim2.new(0, 46, 0, 46), AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.35, 0), BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.15,
        Text = "M", TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBlack, TextSize = 22,
        Visible = false, AutoButtonColor = false,
    }, Gui)
    Corner(Float, 23)
    Stroke(Float, Theme.Accent, 2, 0.1)

    function UI.Show()
        Main.Visible = true
        Float.Visible = false
        UI.Scale.Scale = Cfg.UIScale * 0.82
        TweenService:Create(UI.Scale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = Cfg.UIScale}):Play()
    end
    function UI.Hide()
        local t = TweenService:Create(UI.Scale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Scale = Cfg.UIScale * 0.82})
        t:Play()
        t.Completed:Connect(function()
            Main.Visible = false
            Float.Visible = true
            UI.Scale.Scale = Cfg.UIScale
        end)
    end
    MinBtn.MouseButton1Click:Connect(function() UI.Hide() end)
    Float.MouseButton1Click:Connect(function() UI.Show() end)
    CloseBtn.MouseButton1Click:Connect(function() U.Shutdown() end)

    -- SIDEBAR
    local Side = New("ScrollingFrame", {
        Size = UDim2.new(0, SW, 1, -46), Position = UDim2.new(0, 0, 0, 46),
        BackgroundColor3 = Color3.fromRGB(4, 4, 10), BackgroundTransparency = 0.5, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2,
    }, Main)
    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, Side)
    Pad(Side, 6, 6, 6, 6)

    -- profile card
    local Card = New("Frame", {
        Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.3,
        BorderSizePixel = 0, LayoutOrder = 0, ZIndex = 3,
    }, Side)
    Corner(Card, 10)
    Stroke(Card, Theme.Accent, 1, 0.5)
    local Av = New("ImageLabel", {
        Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(0, 7, 0.5, -19),
        BackgroundColor3 = Theme.Bg, BorderSizePixel = 0, ZIndex = 4,
    }, Card)
    Corner(Av, 19)
    New("TextLabel", {
        Size = UDim2.new(1, -54, 0, 18), Position = UDim2.new(0, 50, 0, 9), BackgroundTransparency = 1,
        Text = LocalPlayer.DisplayName, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
    }, Card)
    UI.ProfileSub = New("TextLabel", {
        Size = UDim2.new(1, -54, 0, 14), Position = UDim2.new(0, 50, 0, 28), BackgroundTransparency = 1,
        Text = "Level ...", TextColor3 = Theme.Accent2, Font = Enum.Font.Gotham, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4,
    }, Card)
    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and img then Av.Image = img end
    end)

    local Content = New("Frame", {
        Size = UDim2.new(1, -SW, 1, -46), Position = UDim2.new(0, SW, 0, 46),
        BackgroundTransparency = 1, ZIndex = 2,
    }, Main)

    local Window = {Tabs = {}, Gui = Gui, Main = Main}

    function Window:CreateTab(name, icon)
        local Btn = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 1,
            Text = " " .. (icon or "") .. " " .. name, TextColor3 = Theme.Sub, Font = Enum.Font.GothamSemibold,
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
            AutoButtonColor = false, LayoutOrder = #Window.Tabs + 1, ZIndex = 3,
        }, Side)
        Corner(Btn, 8)
        local Ind = New("Frame", {
            Size = UDim2.new(0, 3, 1, -14), Position = UDim2.new(0, 0, 0, 7),
            BackgroundColor3 = Theme.Accent2, BorderSizePixel = 0, Visible = false, ZIndex = 4,
        }, Btn)
        Corner(Ind, 2)

        local Page = New("ScrollingFrame", {
            Size = UDim2.new(1, -8, 1, -8), Position = UDim2.new(0, 4, 0, 4), BackgroundTransparency = 1,
            BorderSizePixel = 0, ScrollBarThickness = 5, ScrollBarImageColor3 = Theme.Accent,
            ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 3,
        }, Content)
        New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)}, Page)
        Pad(Page, 4, 4, 10, 10)

        local TabData = {Btn = Btn, Page = Page, Ind = Ind}
        table.insert(Window.Tabs, TabData)

        local function Select()
            for _, t in ipairs(Window.Tabs) do
                t.Page.Visible = false
                t.Ind.Visible = false
                t.Btn.TextColor3 = Theme.Sub
                TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end
            Page.Position = UDim2.new(0, 34, 0, 4)
            Page.Visible = true
            TweenService:Create(Page, TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0, 4, 0, 4)}):Play()
            Ind.Visible = true
            Btn.TextColor3 = Theme.Text
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.75}):Play()
        end
        Btn.MouseButton1Click:Connect(Select)
        if #Window.Tabs == 1 then Select() end

        local Tab = {Page = Page}
        local order = 0
        local function nextOrder() order = order + 1 return order end

        function Tab:Section(text)
            local sec = New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Text = "    " .. string.upper(text),
                TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBold, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            local bar = New("Frame", {
                Size = UDim2.new(0, 3, 0, 12), Position = UDim2.new(0, 4, 0.5, -6),
                BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 4,
            }, sec)
            Corner(bar, 2)
        end

        -- two big hero switches (used on the Home tab)
        function Tab:BigToggle(title, subtitle, default, callback, key, colA, colB)
            local state = default and true or false
            local card = New("Frame", {
                Size = UDim2.new(1, 0, 0, 74), BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = state and 0.2 or 0.6, BorderSizePixel = 0,
                LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(card, 12)
            New("UIGradient", {Color = ColorSequence.new(colA, colB), Rotation = 20}, card)
            local st = Stroke(card, colB, 2, state and 0.05 or 0.5)
            New("TextLabel", {
                Size = UDim2.new(1, -100, 0, 24), Position = UDim2.new(0, 14, 0, 10), BackgroundTransparency = 1,
                Text = title, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBlack, TextSize = 16,
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
                TweenService:Create(pill, TweenInfo.new(0.15), {
                    TextColor3 = state and Color3.fromRGB(110, 255, 160) or Theme.Sub}):Play()
                TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = state and 0.2 or 0.6}):Play()
                TweenService:Create(st, TweenInfo.new(0.2), {Transparency = state and 0.05 or 0.5}):Play()
                if not silent then
                    local ok, err = pcall(callback, state)
                    if not ok then U.Log(err) end
                end
            end
            function obj.Get() return state end
            function obj.SetStatus(t) sub.Text = tostring(t) end
            hit.MouseButton1Click:Connect(function() obj.Set(not state) end)
            if key then UI.T[key] = obj end
            return obj
        end

        -- row of small stat cards, returns {Set = function(index, text)}
        function Tab:StatRow(captions)
            local n = #captions
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, row)
            local values = {}
            for i, cap in ipairs(captions) do
                local c = New("Frame", {
                    Size = UDim2.new(1 / n, -6 * (n - 1) / n, 1, 0), BackgroundColor3 = Theme.Card,
                    BackgroundTransparency = 0.35, BorderSizePixel = 0, LayoutOrder = i, ZIndex = 3,
                }, row)
                Corner(c, 10)
                Stroke(c, Color3.fromRGB(70, 70, 110), 1, 0.5)
                values[i] = New("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 6), BackgroundTransparency = 1,
                    Text = "-", TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBlack, TextSize = 19, ZIndex = 4,
                }, c)
                New("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 34), BackgroundTransparency = 1,
                    Text = cap, TextColor3 = Theme.Sub, Font = Enum.Font.GothamMedium, TextSize = 10, ZIndex = 4,
                }, c)
            end
            return {Set = function(i, text) if values[i] then values[i].Text = tostring(text) end end}
        end

        function Tab:Label(text)
            local l = New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.5, Text = text,
                TextColor3 = Theme.Sub, Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(l, 8)
            Pad(l, 10, 6, 10, 6)
            return {Set = function(t) l.Text = tostring(t) end}
        end

        function Tab:Button(text, callback)
            local b = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.4,
                Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
                AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(b, 8)
            New("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.Accent2), Rotation = 0}, b)
            local pressScale = New("UIScale", {Scale = 1}, b)
            local function squish(v) TweenService:Create(pressScale, TweenInfo.new(0.09), {Scale = v}):Play() end
            b.MouseButton1Down:Connect(function() squish(0.95) end)
            b.MouseButton1Up:Connect(function() squish(1) end)
            b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play() end)
            b.MouseLeave:Connect(function()
                squish(1)
                TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play()
            end)
            b.MouseButton1Click:Connect(function() U.Spawn(callback) end)
        end

        function Tab:Toggle(text, default, callback, key)
            local state = default and true or false
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.4,
                BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(row, 8)
            Stroke(row, Color3.fromRGB(60, 60, 90), 1, 0.55)
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
                TweenService:Create(knob, TweenInfo.new(0.15), {
                    Position = state and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
                TweenService:Create(track, TweenInfo.new(0.15), {
                    BackgroundColor3 = state and Theme.Accent or Theme.Off}):Play()
                if not silent then
                    local ok, err = pcall(callback, state)
                    if not ok then U.Log(err) end
                end
            end
            function obj.Get() return state end
            hit.MouseButton1Click:Connect(function() obj.Set(not state) end)
            if key then UI.T[key] = obj end
            return obj
        end

        function Tab:Input(text, placeholder, default, callback)
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.4,
                BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(row, 8)
            Stroke(row, Color3.fromRGB(60, 60, 90), 1, 0.55)
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
                ZIndex = 4,
            }, row)
            Corner(box, 6)
            Pad(box, 8, 0, 8, 0)
            box.FocusLost:Connect(function()
                local ok, err = pcall(callback, box.Text)
                if not ok then U.Log(err) end
            end)
            return {Get = function() return box.Text end, Set = function(t) box.Text = t end}
        end

        function Tab:Dropdown(text, options, default, callback)
            local holder = New("Frame", {
                Size = UDim2.new(1, 0, 0, 40), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.4, BorderSizePixel = 0,
                ClipsDescendants = true, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(holder, 8)
            Stroke(holder, Color3.fromRGB(60, 60, 90), 1, 0.55)
            New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, holder)
            local head = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = "", LayoutOrder = 1, ZIndex = 4,
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
                    ob.MouseButton1Click:Connect(function()
                        obj.Value = o
                        val.Text = tostring(o)
                        list.Visible = false
                        arrow.Text = "v"
                        local ok, err = pcall(callback, o)
                        if not ok then U.Log(err) end
                    end)
                end
                list.Size = UDim2.new(1, 0, 0, math.min(#opts * 30 + 6, 156))
            end
            function obj.SetOptions(opts) build(opts) end
            head.MouseButton1Click:Connect(function()
                list.Visible = not list.Visible
                arrow.Text = list.Visible and "^" or "v"
            end)
            build(options)
            return obj
        end

        function Tab:Slider(text, min, max, default, callback, step)
            step = step or 1
            local value = default
            local row = New("Frame", {
                Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.4,
                BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3,
            }, Page)
            Corner(row, 8)
            Stroke(row, Color3.fromRGB(60, 60, 90), 1, 0.55)
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
                Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 38),
                BackgroundColor3 = Theme.Off, BorderSizePixel = 0, ZIndex = 4,
            }, row)
            Corner(track, 3)
            local fill = New("Frame", {
                Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0),
                BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 5,
            }, track)
            Corner(fill, 3)
            local knob = New("Frame", {
                Size = UDim2.new(0, 14, 0, 14), AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0, ZIndex = 6,
            }, fill)
            Corner(knob, 7)
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
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                vlbl.Text = tostring(value)
                local ok, err = pcall(callback, value)
                if not ok then U.Log(err) end
            end
            hit.InputBegan:Connect(function(input)
                if IsPointer(input) then
                    dragging = true
                    setFromX(input.Position.X)
                end
            end)
            U.Conn(UserInputService.InputChanged, function(input)
                if dragging and IsMove(input) then setFromX(input.Position.X) end
            end)
            U.Conn(UserInputService.InputEnded, function(input)
                if IsPointer(input) then dragging = false end
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
Move.Tween, Move.Target, Move.Teleporting, Move.TpToken = nil, nil, false, 0

function Move.Cancel()
    if Move.Tween then
        pcall(function() Move.Tween:Cancel() end)
        Move.Tween = nil
    end
    Move.Target = nil
end

-- Returns true when the character is already at (or snapped to) the target.
function Move.To(cf, speed)
    local root = U.Root()
    if not root then return false end
    local hum = U.Hum()
    if hum and hum.Sit then hum.Sit = false end
    local dist = (root.Position - cf.Position).Magnitude
    if dist < 35 then
        Move.Cancel()
        root.CFrame = cf
        return true
    end
    if Move.Target and Move.Tween and (Move.Target.Position - cf.Position).Magnitude < 4
        and Move.Tween.PlaybackState == Enum.PlaybackState.Playing then
        return false
    end
    Move.Cancel()
    Move.Target = cf
    Move.Tween = TweenService:Create(root, TweenInfo.new(dist / (speed or Cfg.TweenSpeed), Enum.EasingStyle.Linear), {CFrame = cf})
    Move.Tween:Play()
    return false
end

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
        if fl then Combat.RemoteThread = require(fl).COMBAT_REMOTE_THREAD end
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

-- Batched hit packet (modern Blox Fruits combat remotes). Best-effort.
function Combat.Net()
    if not (Combat.RegAttack and Combat.RegHit) then return end
    local list, main = Combat.Targets(Cfg.AttackRange)
    if not main or #list == 0 then return end
    Combat.RegAttack:FireServer(0)
    if Combat.RemoteThread == false then
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
function Combat.Click()
    local cam = Workspace.CurrentCamera
    local m = Cfg.ClickMethod
    if m ~= "VirtualInputManager" then
        VirtualUser:CaptureController()
        VirtualUser:Button1Down(Vector2.new(1280, 672), cam.CFrame)
        VirtualUser:Button1Up(Vector2.new(1280, 672), cam.CFrame)
    end
    if m ~= "VirtualUser" then
        local vp = cam.ViewportSize
        local x, y = vp.X - 3, vp.Y * 0.6
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end
end

U.Conn(RunService.Heartbeat, function()
    local now = os.clock()
    if now - Combat.Want > 0.35 then return end
    local wt = Farm.Weapon()
    if Cfg.FastAttack and (wt == "Melee" or wt == "Sword") and now - Combat.Last >= 0.03 then
        Combat.Last = now
        if Cfg.AttackMode == "Ultra (Net+Combat)" then
            pcall(Combat.Net)
            pcall(Combat.FrameworkAttack)
        elseif Cfg.AttackMode == "Combat Framework" then
            pcall(Combat.FrameworkAttack)
        end
    end
    if now - Combat.LastClick >= 0.2 then
        Combat.LastClick = now
        pcall(Combat.Click)
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

-- Levels above the hard-coded table (Submerged Island etc.) are resolved from the game's quest module.
function Farm.Dynamic(level)
    local c = Farm.DynCache
    if c and c.level == level then return c.row end
    local row
    pcall(function()
        local qm = ReplicatedStorage:FindFirstChild("Quests")
        if not qm then return end
        local Quests = require(qm)
        local bestReq, bestQ, bestIdx, bestMob = -1, nil, nil, nil
        for qName, qTable in pairs(Quests) do
            if type(qTable) == "table" then
                for idx, info in pairs(qTable) do
                    if type(info) == "table" and type(info.LevelReq) == "number" and type(info.Task) == "table"
                        and info.LevelReq <= level and info.LevelReq > bestReq then
                        local mob, cnt
                        for k, v in pairs(info.Task) do mob, cnt = k, v break end
                        if type(mob) == "string" and type(cnt) == "number" and cnt > 1 then
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
    if Sea == 3 and level >= 2550 and os.clock() >= Farm.DynBlockedUntil then
        local dyn = Farm.Dynamic(level)
        if dyn then return dyn end
    end
    if best then return best end
    return nil, "NO_ROW"
end

Farm.QuestFails, Farm.OwnKills, Farm.OwnActive, Farm.Kills = 0, 0, false, 0
Farm.LastProgress, Farm.WDPos = os.clock(), nil
Farm.DynBlockedUntil, Farm.SubmergedTries = 0, 0
Farm.NeedCache = {}

-- Reads the on-screen quest tracker. Returns (active, title). active == nil means "GUI not found".
function Farm.QuestInfo()
    local now = os.clock()
    local c = Farm.QI
    if c and now - c.t < 0.25 then return c.active, c.title end
    local active, title = nil, ""
    local q = Farm.QuestCached
    if not (q and q.Parent) then
        q = nil
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local main = pg and pg:FindFirstChild("Main")
        if main then
            q = main:FindFirstChild("Quest")
            if not q then
                for _, d in ipairs(main:GetChildren()) do
                    if d.Name:lower():find("quest", 1, true) and d:IsA("GuiObject") then q = d break end
                end
            end
        end
        Farm.QuestCached = q
    end
    if q then
        active = q.Visible and true or false
        if active then
            for _, d in ipairs(q:GetDescendants()) do
                if d:IsA("TextLabel") and type(d.Text) == "string" and d.Text:lower():find("defeat", 1, true) then
                    title = d.Text
                    break
                end
            end
        end
    end
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

function Farm.TitleMatches(title, row)
    if type(title) ~= "string" or not title:lower():find("defeat", 1, true) then return true end
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
        return
    end
    -- nothing spawned near us: fly to the mob area
    local pos = mobPos or Farm.TemplatePos(name)
    if pos then
        if row then Farm.Entrance(row, pos) end
        Move.To(CF(pos + V3(0, Farm.Height(), 0)))
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
    if row[7]:sub(1, 7) == "Dynamic" then
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

    Farm.Status(string.format("Lv %d | %s | %s | kills %d", lvl, row[7], row[2], Farm.Kills))
    Farm.Prep()
    Farm.Watchdog(root)

    if Cfg.UseQuest then
        local active, title = Farm.QuestInfo()
        if active == nil then
            -- quest tracker not found: count our own kills instead of freezing at the NPC
            active = Farm.OwnActive and Farm.OwnKills < Farm.QuestNeed(row)
        end
        if active and not Farm.TitleMatches(title, row) then
            if os.clock() - Farm.LastAbandon > 8 then
                Farm.LastAbandon = os.clock()
                Farm.OwnActive = false
                U.CommAsync("AbandonQuest")
            end
            return
        end
        if not active then
            if os.clock() < Farm.QuestWait then return end
            local stand = row[5]
            if Farm.QuestFails >= 2 then stand = Farm.FindNPC("quest", row[5]) or row[5] end
            Farm.Entrance(row, stand)
            Move.To(CF(stand))
            local r2 = U.Root()
            if r2 and (r2.Position - stand).Magnitude < 14 then
                U.CommAsync("StartQuest", row[3], row[4]) -- never block the loop on the server
                Farm.QuestWait = os.clock() + 2
                Farm.OwnActive, Farm.OwnKills = true, 0
                Farm.QuestFails = Farm.QuestFails + 1
                Farm.LastProgress = os.clock()
            end
            return
        end
        Farm.QuestFails = 0
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
    if Cfg.FruitNotify and o:IsA("Tool") and o.Name:find("Fruit") then
        UI.Notify("Fruit Spawned", o.Name, 6)
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
        if Move.Tween then Move.Cancel() end
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
    if o:GetAttribute("MorganFake") then return end
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

function Misc.Hop()
    local ok, res = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if ok and res and res.data then
        for _, s in ipairs(res.data) do
            if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers - 1 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                return
            end
        end
    end
    UI.Notify("Server Hop", "Server list unavailable, joining a random server.", 4)
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end

-- ---------------------------------------------------------------------------
-- FAKE FRUITS: clones the real fruit mesh as a plain anchored part. It is not a Tool and has no prompts,
-- so it cannot be picked up, stored or dropped, and nobody else sees it.
-- ---------------------------------------------------------------------------
Misc.FruitCache, Misc.Fakes = {}, {}

function Misc.FruitHandleFrom(inst)
    if inst:IsA("Tool") then return inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart", true) end
    if inst:IsA("Model") then return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart", true) end
    if inst:IsA("BasePart") then return inst end
    return nil
end

function Misc.FindFruitTemplate(base)
    local cached = Misc.FruitCache[base]
    if cached ~= nil then return cached or nil end
    local lb = base:lower()
    local names = {[lb .. " fruit"] = 3, [lb .. "-" .. lb] = 2, [lb] = 1}
    local best, bestScore = nil, 0
    local function consider(inst)
        local sc = names[inst.Name:lower()]
        if sc and sc > bestScore and (inst:IsA("Tool") or inst:IsA("Model") or inst:IsA("BasePart")) then
            local h = Misc.FruitHandleFrom(inst)
            if h and h:IsA("BasePart") then best, bestScore = h, sc end
        end
    end
    local n = 0
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        consider(d)
        n = n + 1
        if n % 600 == 0 then task.wait() end
    end
    for _, c in ipairs({Workspace, LocalPlayer.Backpack, LocalPlayer.Character}) do
        if c then
            for _, d in ipairs(c:GetChildren()) do consider(d) end
        end
    end
    -- last resort: other containers a fruit model could hide in
    if not best then
        for _, name in ipairs({"StarterPack", "Lighting"}) do
            local ok, svc = pcall(function() return game:GetService(name) end)
            if ok and svc then
                for _, d in ipairs(svc:GetDescendants()) do consider(d) end
            end
        end
    end
    Misc.FruitCache[base] = best or false
    return best
end

function Misc.SpawnFakeFruit(base)
    local root = U.Root()
    if not root then return end
    local tpl = Misc.FindFruitTemplate(base)
    local pos = root.Position + root.CFrame.LookVector * 6
    local hit = Workspace:Raycast(pos + V3(0, 40, 0), V3(0, -120, 0))
    if hit and typeof(hit.Position) == "Vector3" then pos = hit.Position + V3(0, 1.8, 0) end

    local part
    if tpl then
        local okc, cl = pcall(function() return tpl:Clone() end) -- Archivable=false assets return nil
        part = okc and cl or nil
    end
    if part then
        for _, d in ipairs(part:GetDescendants()) do
            if d:IsA("BaseScript") or d:IsA("ProximityPrompt") or d:IsA("ClickDetector")
                or d:IsA("TouchTransmitter") or d:IsA("Sound") or d:IsA("Weld") or d:IsA("WeldConstraint") then
                d:Destroy()
            end
        end
    else
        part = Instance.new("Part")
        part.Shape = Enum.PartType.Ball
        part.Material = Enum.Material.Neon
        part.Size = V3(1.6, 1.6, 1.6)
        part.Color = Data.FruitColors[base] or Color3.fromRGB(255, 120, 120)
        UI.Notify("Fake Fruit", "Real " .. base .. " model not found, using a glowing orb.", 4)
    end
    part.Name = base .. " Fruit"
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    part:SetAttribute("MorganFake", true)
    part.CFrame = CF(pos)

    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 150, 0, 34)
    bb.StudsOffset = V3(0, 2.6, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = part
    bb.Parent = part
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = base .. " Fruit"
    l.TextColor3 = Data.FruitColors[base] or Color3.fromRGB(255, 255, 255)
    l.TextStrokeTransparency = 0
    l.TextSize = 14
    l.Font = Enum.Font.GothamBold
    l.Parent = bb

    part.Parent = Workspace
    table.insert(Misc.Fakes, {part = part, pos = pos, ph = math.random() * 6.28})
end

function Misc.ClearFakeFruits()
    for _, f in ipairs(Misc.Fakes) do pcall(function() f.part:Destroy() end) end
    Misc.Fakes = {}
    for _, o in ipairs(Workspace:GetChildren()) do
        if o:GetAttribute("MorganFake") then o:Destroy() end
    end
end

-- gentle hover + spin so the fruit looks alive
U.Conn(RunService.Heartbeat, function()
    if #Misc.Fakes == 0 then return end
    local t = os.clock()
    for i = #Misc.Fakes, 1, -1 do
        local f = Misc.Fakes[i]
        if not f.part.Parent then
            table.remove(Misc.Fakes, i)
        else
            f.part.CFrame = CF(f.pos + V3(0, math.sin(t * 2 + f.ph) * 0.35, 0)) * CFrame.Angles(0, t * 1.1 + f.ph, 0)
        end
    end
end)

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

function Fish.Restock()
    Fish.LastRestock = os.clock()
    local npc = Misc.FindNPCModel("fisherman")
    local part = npc and (npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart", true))
    if not part then
        U.Notify("Fishing", "Fisherman NPC not found in this sea.", 5)
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
    add("Fisherman NPC", Misc.FindNPCModel("fisherman") ~= nil)
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
    Misc.ClearFakeFruits()
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
local TabFun     = Win:CreateTab("Fun", "🎭")
local TabSafe    = Win:CreateTab("Safety", "🛡️")
local TabSet     = Win:CreateTab("Settings", "⚙️")

-- ---------------------------------------------------------------------------
-- HOME  (two hero switches + live status)
-- ---------------------------------------------------------------------------
TabHome:Section("Main Switches")
TabHome:BigToggle("AUTO FARM", "Quests, island and mob by your level. Re-equips your weapon after death.",
    Cfg.AutoFarm, function(v)
        Cfg.AutoFarm = v
        if not v then Move.Cancel() Farm.Target = nil end
    end, "AutoFarm", Color3.fromRGB(120, 70, 255), Color3.fromRGB(70, 190, 255))

TabHome:BigToggle("PIRATE RAID", "Watches the Castle on the Sea. Goes when the raid starts, then Auto Farm continues.",
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
TabHome:Label("Use '-' to hide the window and the round M button to bring it back. Every page scrolls.")

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
            or "Quests, island and mob by your level. Re-equips your weapon after death.")
    end
    if UI.T.PirateRaid then
        UI.T.PirateRaid.SetStatus((Cfg.PirateRaid and Farm.StatusText:sub(1, 11) == "Pirate Raid")
            and Farm.StatusText or (Cfg.PirateRaid and "Armed. Waiting for the raid, Auto Farm keeps running."
            or "Watches the Castle on the Sea. Goes when the raid starts, then Auto Farm continues."))
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
TabFarm:Dropdown("Attack Mode", {"Ultra (Net+Combat)", "Combat Framework", "Click Only"}, Cfg.AttackMode,
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
TabMore:Label("The big PIRATE RAID switch on Home does the work. Leave 'Wait At Castle' off to keep farming between raids.")

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
TabMore:Label("Sword quest chains (Saber, Rengoku, CDK...) change often and are not automated. "
    .. "Use Boss Farm for sword drops and the Shop tab for dealer swords.")

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

TabFruit:Section("Random Fruit (costs Beli)")
TabFruit:Button("Buy Random Fruit Now", function() U.Comm("Cousin", "Buy") end)
TabFruit:Toggle("Auto Buy Random Fruit", Cfg.AutoRandomFruit, function(v) Cfg.AutoRandomFruit = v end)
TabFruit:Label("Fruit rarity is rolled on the server, so a client script cannot raise luck. "
    .. "Auto Buy + Auto Store just repeats the normal roll for you.")

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
TabFish:Label("Get the rod first: talk to the Fisherman (Frozen Village docks in Sea 1, Kingdom of Rose Docks 2 "
    .. "in Sea 2, Port Town docks in Sea 3). Stand on a dock facing the water, then turn Auto Fish on. "
    .. "Selling and buying press the dialogue buttons by their text, so if it misses, run the Self-Test and "
    .. "send me the console output.")

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
-- FUN
-- ---------------------------------------------------------------------------
TabFun:Section("Fake Fruits (real model, only you see it)")
local fakeSel = "Leopard"
TabFun:Dropdown("Fruit", Data.FruitList, fakeSel, function(v) fakeSel = v end)
TabFun:Button("Spawn Selected Fake Fruit", function() Misc.SpawnFakeFruit(fakeSel) end)
TabFun:Button("Spawn 5 Random Fake Fruits", function()
    for _ = 1, 5 do
        Misc.SpawnFakeFruit(Data.FruitList[math.random(1, #Data.FruitList)])
        task.wait(0.15)
    end
end)
TabFun:Label("Fake fruits are plain anchored copies of the real fruit mesh. They are not tools, so they cannot be "
    .. "picked up, eaten, stored or dropped, and other players cannot see them.")
TabFun:Button("Clear Fake Fruits", function() Misc.ClearFakeFruits() end)

-- ---------------------------------------------------------------------------
-- SAFETY
-- ---------------------------------------------------------------------------
TabSafe:Section("Staff / Admin")
TabSafe:Toggle("Leave Server When Staff Joins", Cfg.AdminHop, function(v) Cfg.AdminHop = v end)
TabSafe:Slider("Min Staff Rank (game group)", 2, 255, Cfg.AdminRank, function(v) Cfg.AdminRank = v end, 1)
TabSafe:Label("Checks every player's rank in the game's group. Members are rank 1, so anything above that "
    .. "counts as staff by default. Raise the rank if you get too many false alarms.")
TabSafe:Button("Hop To Another Server Now", function() Misc.Hop() end)

TabSafe:Section("Connection")
TabSafe:Toggle("Auto Reconnect After Disconnect", Cfg.AutoReconnect, function(v) Cfg.AutoReconnect = v end)
TabSafe:Label("Anti-AFK is always on (also every 4 minutes) so you are not idle-kicked. "
    .. "Put the script in Delta's autoexecute folder and your switches restore themselves after a rejoin.")

TabSafe:Section("Survival")
TabSafe:Toggle("Escape To The Sky At Low HP", Cfg.LowHPEscape, function(v) Cfg.LowHPEscape = v end)
TabSafe:Slider("Escape Below HP %", 10, 60, Cfg.EscapeHP, function(v) Cfg.EscapeHP = v end, 5)

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
TabSet:Label("If quests or attacks misbehave, press the debug button and send me the console output.")
TabSet:Section("Script")
TabSet:Button("Unload Morgan Hub", function() U.Shutdown() end)

-- apply side effects of restored settings
if Cfg.FpsBoost then Misc.SetFpsBoost(true) end
if Cfg.LogoURL ~= "" then U.Spawn(function() UI.SetLogoURL(Cfg.LogoURL) end) end
if Cfg.Fullbright then Misc.SetFullbright(true) end
if Cfg.NoFog then Misc.SetNoFog(true) end
if Cfg.WalkWater then Misc.WaterWalk(true) end

UI.Notify("Morgan Hub V3", "Loaded. Sea " .. Sea .. " | Level " .. U.Level()
    .. (loadedCfg and " | settings restored" or ""), 5)
print("[MorganHub] V3.2 loaded. Sea " .. Sea)

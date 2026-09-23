--[[
============================================================
 MORGAN HUB V4 "GLASS" | Blox Fruits | Mobile + PC | No Key
============================================================
 ✔ Auto Farm  : Lv 1 → 2550+ quest tabanlı (Lv 150 dahil)
 ✔ FAST ATTACK: Redz tarzı ayar paneli — 4 metod + Super
 ✔ BRING MOB  : DÜZELTİLDİ → yaklaş → halk şeklinde çek → VUR
 ✔ Temalar    : Rain (şimşek+sıçrama) • Blood Rain • Sunny
                • Snow • Sakura + 🎲 Rastgele Tema
 ✔ Şeffaf cam GUI (opaklık ayarlı) • ESP • Auto Fruit/Chest
 ✔ Auto Stats • Auto Skills (Z X C V) • Config kaydet
============================================================
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local VirtualUser       = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local HttpService       = game:GetService("HttpService")
local Lighting          = game:GetService("Lighting")
local StarterGui        = game:GetService("StarterGui")
local TeleportService   = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local V3, CF = Vector3.new, CFrame.new

-- eski sürümü devre dışı bırak
local genv = (getgenv and getgenv()) or _G
local RunId = tostring(os.clock()) .. "_" .. tostring(math.random(1, 1000000))
genv.MorganHubRunId = RunId

local Ex = {
    FireTouch = firetouchinterest,
    GetConnections = getconnections,
    FireSignal = firesignal,
    GetHui = gethui,
}
local VirtualInputManager
do
    local ok, v = pcall(function() return game:GetService("VirtualInputManager") end)
    if ok then VirtualInputManager = v end
end

local U, UI, Combat, Farm, ESP, Misc, Data = {Conns = {}}, {Pulses = {}}, {}, {}, {}, {}, {}

-- ============================== UTIL ==============================
function U.Alive() return genv.MorganHubRunId == RunId end

local logSeen = {}
function U.Log(msg)
    msg = tostring(msg)
    if not logSeen[msg] then logSeen[msg] = true warn("[MorganHub V4] " .. msg) end
end

function U.Spawn(fn, ...)
    local a = table.pack(...)
    task.spawn(function()
        local ok, err = pcall(fn, table.unpack(a, 1, a.n))
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
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = tostring(title), Text = tostring(msg), Duration = dur or 4})
    end)
end

function U.Root() local c = LocalPlayer.Character return c and c:FindFirstChild("HumanoidRootPart") end
function U.Hum()  local c = LocalPlayer.Character return c and c:FindFirstChildOfClass("Humanoid") end
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
    local a = table.pack(...)
    local ok, res = pcall(function() return CommF_:InvokeServer(table.unpack(a, 1, a.n)) end)
    if ok then return res end
    return nil
end

function U.CommAsync(...)
    local a = table.pack(...)
    task.spawn(function() U.Comm(table.unpack(a, 1, a.n)) end)
end

function U.CleanName(n)
    local s = n:gsub("%s*%b[]", "")
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- ============================== DÜNYA ==============================
local Sea = 0
do
    local pid = game.PlaceId
    if pid == 2753915549 then Sea = 1
    elseif pid == 4442272183 then Sea = 2
    elseif pid == 7449423635 then Sea = 3 end
end
if Sea == 0 then
    local l = U.Level()
    Sea = (l >= 1500 and 3) or (l >= 700 and 2) or 1
end

-- ============================== CONFIG ==============================
local Cfg = {
    AutoFarm = false, UseQuest = true, Method = "Hybrid (Önerilen)",
    FarmHeight = 12, TweenSpeed = 200, BringRadius = 150, AnchorMobs = false,
    FarmMob = false, SelectedMob = "", Hitbox = true, HitboxSize = 45,
    StopAtTarget = false, TargetLevel = 3000,
    AutoBuso = true, StatOn = false, StatType = "Melee", StatAmount = 3,
    FastAttack = false, AttackSpeed = 0.15, ClickMethod = "VirtualInputManager (Redz)",
    SuperAttack = false, AttackAlways = false,
    AutoEquip = true, WeaponType = "Melee (Combat)", AutoSkills = false,
    AutoCollectFruit = false, FruitNotify = true, AutoChest = false,
    Theme = "Rain", Rain = true, GlassT = 0.25,
    Fullbright = false, NoFog = false, FpsBoost = false, AutoRandomTheme = false,
    ESPPlayer = false, ESPMob = false, ESPFruit = false, ESPChest = false,
    Speed = false, SpeedVal = 100, Jump = false, JumpVal = 100,
    InfJump = false, WalkWater = false, Noclip = false,
    UIScale = 1, WebhookURL = "", WhFruit = false,
}

-- kayıtlı config varsa UI kurulmadan ÖNCE yükle
pcall(function()
    if not (isfile and readfile) then error("") end
    if not isfile("MorganHubV4.json") then error("") end
    local data = HttpService:JSONDecode(readfile("MorganHubV4.json"))
    for k, v in pairs(data) do
        if Cfg[k] ~= nil and type(v) == type(Cfg[k]) then Cfg[k] = v end
    end
end)

-- ============================== DATA ==============================
Data.Quests = {
    [1] = {
        {1,   "Bandit",             "BanditQuest1",   1, V3(1059.4, 15.4, 1550.4),   V3(1046, 27, 1560.8)},
        {10,  "Monkey",             "JungleQuest",    1, V3(-1598.1, 35.6, 153.4),   V3(-1448.5, 67.9, 11.5)},
        {15,  "Gorilla",            "JungleQuest",    2, V3(-1598.1, 35.6, 153.4),   V3(-1129.9, 40.5, -525.4)},
        {30,  "Pirate",             "BuggyQuest1",    1, V3(-1141.1, 4.1, 3831.5),   V3(-1103.5, 13.8, 3896.1)},
        {40,  "Brute",              "BuggyQuest1",    2, V3(-1141.1, 4.1, 3831.5),   V3(-1140.1, 14.8, 4322.9)},
        {60,  "Desert Bandit",      "DesertQuest",    1, V3(894.5, 5.1, 4392.4),     V3(924.8, 6.4, 4481.6)},
        {75,  "Desert Officer",     "DesertQuest",    2, V3(894.5, 5.1, 4392.4),     V3(1608.3, 8.6, 4371)},
        {90,  "Snow Bandit",        "SnowQuest",      1, V3(1389.7, 88.2, -1298.9),  V3(1354.3, 87.3, -1393.9)},
        {100, "Snowman",            "SnowQuest",      2, V3(1389.7, 88.2, -1298.9),  V3(1201.6, 144.6, -1550.1)},
        {120, "Chief Petty Officer","MarineQuest2",   1, V3(-5039.6, 27.4, 4324.7),  V3(-4881.2, 22.7, 4273.8)},
        {150, "Sky Bandit",         "SkyQuest",       1, V3(-4839.5, 716.4, -2619.4),V3(-4953.2, 295.7, -2899.2)},
        {175, "Dark Master",        "SkyQuest",       2, V3(-4839.5, 716.4, -2619.4),V3(-5259.8, 391.4, -2229)},
        {190, "Prisoner",           "PrisonerQuest",  1, V3(5308.9, 1.7, 475.1),     V3(5099, -0.3, 474.2)},
        {210, "Dangerous Prisoner", "PrisonerQuest",  2, V3(5308.9, 1.7, 475.1),     V3(5654.6, 15.6, 866.3)},
        {250, "Toga Warrior",       "ColosseumQuest", 1, V3(-1580, 6.4, -2986.5),    V3(-1820.2, 51.7, -2740.7)},
        {275, "Gladiator",          "ColosseumQuest", 2, V3(-1580, 6.4, -2986.5),    V3(-1292.8, 56.4, -3339)},
        {300, "Military Soldier",   "MagmaQuest",     1, V3(-5313.4, 10.9, 8515.3),  V3(-5411.2, 11.1, 8454.3)},
        {325, "Military Spy",       "MagmaQuest",     2, V3(-5313.4, 10.9, 8515.3),  V3(-5802.9, 86.3, 8828.9)},
        {375, "Fishman Warrior",    "FishmanQuest",   1, V3(61122.7, 18.5, 1569.4),  V3(60878.3, 18.5, 1543.8)},
        {400, "Fishman Commando",   "FishmanQuest",   2, V3(61122.7, 18.5, 1569.4),  V3(61922.6, 18.5, 1493.9)},
        {450, "God's Guard",        "SkyExp1Quest",   1, V3(-4721.9, 843.9, -1950),  V3(-4710, 845.3, -1927.3)},
        {475, "Shanda",             "SkyExp1Quest",   2, V3(-7859.1, 5544.2, -381.5),V3(-7678.5, 5566.4, -497.2)},
        {525, "Royal Squad",        "SkyExp2Quest",   1, V3(-7906.8, 5634.7, -1412), V3(-7624.3, 5658.1, -1467.4)},
        {550, "Royal Soldier",      "SkyExp2Quest",   2, V3(-7906.8, 5634.7, -1412), V3(-7836.8, 5645.7, -1790.6)},
        {625, "Galley Pirate",      "FountainQuest",  1, V3(5259.8, 37.4, 4050),     V3(5551, 78.9, 3930.4)},
        {650, "Galley Captain",     "FountainQuest",  2, V3(5259.8, 37.4, 4050),     V3(5442, 42.5, 4950.1)},
    },
    [2] = {
        {700,  "Raider",            "Area1Quest",     1, V3(-429.5, 71.8, 1836.2),   V3(-728.3, 52.8, 2345.8)},
        {725,  "Mercenary",         "Area1Quest",     2, V3(-429.5, 71.8, 1836.2),   V3(-1004.3, 80.2, 1424.6)},
        {775,  "Swan Pirate",       "Area2Quest",     1, V3(638.4, 71.8, 918.3),     V3(1068.7, 137.6, 1322.1)},
        {800,  "Factory Staff",     "Area2Quest",     2, V3(632.7, 73.1, 918.7),     V3(73.1, 81.9, -27.5)},
        {875,  "Marine Lieutenant", "MarineQuest3",   1, V3(-2440.8, 71.7, -3216.1), V3(-2821.4, 75.9, -3070.1)},
        {900,  "Marine Captain",    "MarineQuest3",   2, V3(-2440.8, 71.7, -3216.1), V3(-1861.2, 80.2, -3254.7)},
        {950,  "Zombie",            "ZombieQuest",    1, V3(-5497.1, 47.6, -795.2),  V3(-5657.8, 79, -928.7)},
        {975,  "Vampire",           "ZombieQuest",    2, V3(-5497.1, 47.6, -795.2),  V3(-6037.7, 32.2, -1340.7)},
        {1000, "Snow Trooper",      "SnowMountainQuest", 1, V3(609.9, 400.1, -5372.3), V3(549.1, 427.4, -5563.7)},
        {1050, "Winter Warrior",    "SnowMountainQuest", 2, V3(609.9, 400.1, -5372.3), V3(1142.7, 475.6, -5199.4)},
        {1100, "Lab Subordinate",   "IceSideQuest",   1, V3(-6064.1, 15.2, -4903),   V3(-5707.5, 16, -4513.4)},
        {1125, "Horned Warrior",    "IceSideQuest",   2, V3(-6064.1, 15.2, -4903),   V3(-6341.4, 16, -5723.2)},
        {1175, "Magma Ninja",       "FireSideQuest",  1, V3(-5428, 15.1, -5299.4),   V3(-5449.7, 76.7, -5808.2)},
        {1200, "Lava Pirate",       "FireSideQuest",  2, V3(-5428, 15.1, -5299.4),   V3(-5213.3, 49.7, -4701.5)},
        {1250, "Ship Deckhand",     "ShipQuest1",     1, V3(1037.8, 125.1, 32911.6), V3(1212, 150.8, 33059.2)},
        {1275, "Ship Engineer",     "ShipQuest1",     2, V3(1037.8, 125.1, 32911.6), V3(919.5, 43.5, 32780)},
        {1300, "Ship Steward",      "ShipQuest2",     1, V3(968.8, 125.1, 33244.1),  V3(919.4, 129.6, 33436)},
        {1325, "Ship Officer",      "ShipQuest2",     2, V3(968.8, 125.1, 33244.1),  V3(1036, 181.4, 33315.7)},
        {1350, "Arctic Warrior",    "FrostQuest",     1, V3(5667.7, 26.8, -6486.1),  V3(5966.2, 63, -6179.4)},
        {1375, "Snow Lurker",       "FrostQuest",     2, V3(5667.7, 26.8, -6486.1),  V3(5407.1, 69.2, -6880.9)},
        {1425, "Sea Soldier",       "ForgottenQuest", 1, V3(-3054.4, 235.5, -10142.8), V3(-3028.2, 64.7, -9775.4)},
        {1450, "Water Fighter",     "ForgottenQuest", 2, V3(-3054.4, 235.5, -10142.8), V3(-3352.9, 285, -10534.8)},
    },
    [3] = {
        {1500, "Pirate Millionaire","PiratePortQuest",1, V3(-290.1, 42.9, 5581.6),   V3(-246, 47.3, 5584.1)},
        {1525, "Pistol Billionaire","PiratePortQuest",2, V3(-290.1, 42.9, 5581.6),   V3(-187.3, 86.2, 6013.5)},
        {1575, "Dragon Crew Warrior","AmazonQuest",   1, V3(5832.8, 51.7, -1101.5),  V3(6141.1, 51.4, -1340.7)},
        {1600, "Dragon Crew Archer","AmazonQuest",    2, V3(5833.1, 51.6, -1103.1),  V3(6616.4, 441.8, 446)},
        {1625, "Female Islander",   "AmazonQuest2",   1, V3(5446.9, 601.6, 749.5),   V3(4685.3, 735.8, 815.3)},
        {1650, "Giant Islander",    "AmazonQuest2",   2, V3(5446.9, 601.6, 749.5),   V3(4729.1, 590.4, -37)},
        {1700, "Marine Commodore",  "MarineTreeIsland",1, V3(2180.5, 27.8, -6741.5), V3(2286, 73.1, -7159.8)},
        {1725, "Marine Rear Admiral","MarineTreeIsland",2, V3(2180, 28.7, -6740.1),  V3(3656.8, 160.5, -7001.6)},
        {1775, "Fishman Raider",    "DeepForestIsland3",1, V3(-10581.7, 330.9, -8761.2), V3(-10407.5, 331.8, -8368.5)},
        {1800, "Fishman Captain",   "DeepForestIsland3",2, V3(-10581.7, 330.9, -8761.2), V3(-10994.7, 352.4, -9002.1)},
        {1825, "Forest Pirate",     "DeepForestIsland",1, V3(-13234, 331.5, -7625.4), V3(-13274.5, 332.4, -7769.6)},
        {1850, "Mythological Pirate","DeepForestIsland",2, V3(-13234, 331.5, -7625.4), V3(-13680.6, 501.1, -6991.2)},
        {1900, "Jungle Pirate",     "DeepForestIsland2",1, V3(-12680.4, 390, -9902), V3(-12256.2, 331.7, -10485.8)},
        {1925, "Musketeer Pirate",  "DeepForestIsland2",2, V3(-12680.4, 390, -9902), V3(-13457.9, 391.5, -9859.2)},
        {1975, "Reborn Skeleton",   "HauntedQuest1",  1, V3(-9479.2, 141.2, 5566.1), V3(-8763.7, 165.7, 6159.9)},
        {2000, "Living Zombie",     "HauntedQuest1",  2, V3(-9479.2, 141.2, 5566.1), V3(-10144.1, 138.6, 5838.1)},
        {2025, "Demonic Soul",      "HauntedQuest2",  1, V3(-9517, 172, 6078.5),     V3(-9505.9, 172.1, 6159)},
        {2050, "Posessed Mummy",    "HauntedQuest2",  2, V3(-9517, 172, 6078.5),     V3(-9582, 6.3, 6205.5)},
        {2075, "Peanut Scout",      "NutsIslandQuest",1, V3(-2104.4, 38.1, -10194.2),V3(-2143.2, 47.7, -10030)},
        {2100, "Peanut President",  "NutsIslandQuest",2, V3(-2104.4, 38.1, -10194.2),V3(-1859.4, 38.1, -10422.4)},
        {2125, "Ice Cream Chef",    "IceCreamIslandQuest",1, V3(-820.6, 65.8, -10965.8), V3(-872.2, 65.8, -10920)},
        {2150, "Ice Cream Commander","IceCreamIslandQuest",2, V3(-820.6, 65.8, -10965.8), V3(-558.1, 112, -11290.8)},
        {2200, "Cookie Crafter",    "CakeQuest1",     1, V3(-2021.3, 37.8, -12028.7),V3(-2374.1, 37.8, -12125.3)},
        {2225, "Cake Guard",        "CakeQuest1",     2, V3(-2021.3, 37.8, -12028.7),V3(-1598.3, 43.8, -12244.6)},
        {2250, "Baking Staff",      "CakeQuest2",     1, V3(-1927.9, 37.8, -12842.5),V3(-1887.8, 77.6, -12998.4)},
        {2275, "Head Baker",        "CakeQuest2",     2, V3(-1927.9, 37.8, -12842.5),V3(-2216.2, 82.9, -12869.3)},
        {2300, "Cocoa Warrior",     "ChocQuest1",     1, V3(233.2, 29.9, -12201.2),  V3(-21.6, 80.6, -12352.4)},
        {2325, "Chocolate Bar Battler","ChocQuest1",  2, V3(233.2, 29.9, -12201.2),  V3(582.6, 77.2, -12463.2)},
        {2350, "Sweet Thief",       "ChocQuest2",     1, V3(150.5, 30.7, -12774.5),  V3(165.2, 76.1, -12600.8)},
        {2375, "Candy Rebel",       "ChocQuest2",     2, V3(150.5, 30.7, -12774.5),  V3(134.9, 77.2, -12876.5)},
        {2400, "Candy Pirate",      "CandyQuest1",    1, V3(-1150, 20.4, -14446.3),  V3(-1310.5, 26, -14562.4)},
        {2425, "Snow Demon",        "CandyQuest1",    2, V3(-1150, 20.4, -14446.3),  V3(-880.2, 71.2, -14538.6)},
        {2450, "Isle Outlaw",       "TikiQuest1",     1, V3(-16547.7, 61.1, -173.4), V3(-16442.8, 116.1, -264.5)},
        {2475, "Island Boy",        "TikiQuest1",     2, V3(-16547.7, 61.1, -173.4), V3(-16901.3, 84.1, -192.9)},
        {2500, "Sun-kissed Warrior","TikiQuest2",     1, V3(-16539.1, 55.7, 1051.6), V3(-16349.9, 92.1, 1123.4)},
        {2525, "Isle Champion",     "TikiQuest2",     2, V3(-16539.1, 55.7, 1051.6), V3(-16347.4, 92.1, 1122.3)},
    },
}

Data.Swords = {"Cursed Dual Katana","Dark Blade","Rengoku","Buddy Sword","Saddi","Shisui","Yama",
    "Shark Saw","Saber","Bisento","Pole","Dual Katana","Katana","Cutlass","Iron Mace","Wardens Sword"}

Data.Fruits = {
    Rocket=1,Spin=1,Chop=1,Spring=1,Bomb=1,Smoke=1,Spike=1,
    Flame=2,Ice=2,Sand=2,Dark=2,Falcon=2,Diamond=2,Light=2,Rubber=2,Barrier=2,
    Magma=3,Quake=3,Buddha=3,Love=3,Spider=3,Sound=3,Phoenix=3,Portal=3,
    Rumble=4,Pain=4,Blizzard=4,Gravity=4,Dough=4,Shadow=4,Venom=4,Control=4,Spirit=4,Dragon=4,
    Leopard=5,Kitsune=5,
}

Data.MobList, Data.MobPos = {}, {}
for _, r in ipairs(Data.Quests[Sea] or {}) do
    if not table.find(Data.MobList, r[2]) then table.insert(Data.MobList, r[2]) end
    Data.MobPos[r[2]] = r[6]
end

-- ============================== GUI EBEVEYNİ ==============================
local function CanParent(p)
    if not p then return false end
    return pcall(function()
        local t = Instance.new("ScreenGui") t.Parent = p t:Destroy()
    end)
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
    for _, parent in ipairs({GuiParent, LocalPlayer:FindFirstChild("PlayerGui")}) do
        if parent then
            for _, n in ipairs({"MorganHubV3", "MorganHubV4"}) do
                local o = parent:FindFirstChild(n)
                if o then pcall(function() o:Destroy() end) end
            end
        end
    end
end

-- ============================== UI YARDIMCILARI ==============================
local Theme = {
    Bg = Color3.fromRGB(8, 8, 14), Card = Color3.fromRGB(22, 22, 36),
    Accent = Color3.fromRGB(140, 80, 255), Accent2 = Color3.fromRGB(80, 200, 255),
    Text = Color3.fromRGB(240, 240, 252), Sub = Color3.fromRGB(165, 165, 190),
    Off = Color3.fromRGB(55, 55, 78), Line = Color3.fromRGB(60, 60, 90),
}

local function New(class, props, parent)
    local o = Instance.new(class)
    if props then for k, v in pairs(props) do o[k] = v end end
    if parent then o.Parent = parent end
    return o
end
local function Corner(o, r) return New("UICorner", {CornerRadius = UDim.new(0, r or 8)}, o) end
local function Stroke(o, color, thickness, transparency)
    return New("UIStroke", {Color = color, Thickness = thickness or 1,
        Transparency = transparency or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, o)
end
local function Pad(o, l, t, r, b)
    return New("UIPadding", {PaddingLeft = UDim.new(0, l), PaddingTop = UDim.new(0, t),
        PaddingRight = UDim.new(0, r), PaddingBottom = UDim.new(0, b)}, o)
end
local function tw(obj, t, props, style, dir)
    local tween = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end
local function IsPointer(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end
local function IsMove(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end
local function MakeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
    U.Conn(handle.InputBegan, function(input)
        if IsPointer(input) then
            dragging, dragStart, startPos = true, input.Position, target.Position
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
local function Ripple(btn, x, y)
    local s = (UI.Scale and UI.Scale.Scale) or 1
    local ap, asz = btn.AbsolutePosition, btn.AbsoluteSize
    local d = math.max(asz.X, asz.Y) / s * 1.7
    local rp = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset((x - ap.X) / s, (y - ap.Y) / s),
        Size = UDim2.fromOffset(0, 0), BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.85, BorderSizePixel = 0, ZIndex = btn.ZIndex + 2}, btn)
    Corner(rp, 999)
    tw(rp, 0.6, {Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
    task.delay(0.65, function() pcall(function() rp:Destroy() end) end)
end

-- ============================== PENCERE ==============================
function UI.Notify(title, msg, dur)
    if not UI.ToastHolder then return end
    dur = dur or 4
    local t = New("CanvasGroup", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.1, BorderSizePixel = 0,
        GroupTransparency = 1}, UI.ToastHolder)
    Corner(t, 10)
    Stroke(t, Theme.Line, 1, 0.4)
    Pad(t, 12, 8, 12, 8)
    local sc = New("UIScale", {Scale = 0.88}, t)
    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)}, t)
    New("TextLabel", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = tostring(title),
        TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1}, t)
    New("TextLabel", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Text = tostring(msg), TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2}, t)
    tw(t, 0.35, {GroupTransparency = 0})
    tw(sc, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
    task.delay(dur, function()
        tw(t, 0.3, {GroupTransparency = 1})
        tw(sc, 0.3, {Scale = 0.88})
        task.delay(0.35, function() pcall(function() t:Destroy() end) end)
    end)
end

function UI.CreateWindow(titleText, subtitleText)
    local cam = Workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local W = math.clamp(vp.X - 30, 340, 700)
    local H = math.clamp(vp.Y - 30, 260, 460)
    local SW = (W < 520) and 94 or 128

    local Gui = New("ScreenGui", {Name = "MorganHubV4", ResetOnSpawn = false,
        DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    Gui.Parent = GuiParent
    UI.Gui = Gui

    UI.ToastHolder = New("Frame", {Size = UDim2.new(0, 240, 1, -20), AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -10, 1, -10), BackgroundTransparency = 1}, Gui)
    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 6)}, UI.ToastHolder)

    -- cam (glass) pencere
    local Main = New("Frame", {Name = "Main", Size = UDim2.new(0, W, 0, H),
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = Theme.Bg, BackgroundTransparency = Cfg.GlassT,
        BorderSizePixel = 0, ClipsDescendants = true}, Gui)
    Corner(Main, 14)
    UI.Scale = New("UIScale", {Scale = Cfg.UIScale}, Main)
    local mainStroke = Stroke(Main, Theme.Line, 1.5, 0.3)
    local strokeGrad = New("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.Accent2), Rotation = 45}, mainStroke)
    local tint = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(6, 6, 16),
        BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 1}, Main)
    New("UIGradient", {Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(1, 0.6)}), Rotation = 90}, tint)

    function UI.SetGlass(pct) -- 15..90 (%)
        Cfg.GlassT = pct / 100
        tw(Main, 0.3, {BackgroundTransparency = Cfg.GlassT})
    end

    -- şimşek parlaması
    local Flash = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2}, Main)

    -- ============ PARÇACIK KATMANI (tema motoru) ============
    local Layer = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        ClipsDescendants = true, ZIndex = 1}, Main)

    local defs = {
        ["Rain"]       = {kind = "rain", blood = false, tint = Color3.fromRGB(6, 6, 16),
                          a = Color3.fromRGB(140, 80, 255), b = Color3.fromRGB(80, 200, 255), flash = Color3.fromRGB(210, 225, 255)},
        ["Blood Rain"] = {kind = "rain", blood = true, tint = Color3.fromRGB(16, 3, 6),
                          a = Color3.fromRGB(255, 45, 60), b = Color3.fromRGB(140, 15, 30), flash = Color3.fromRGB(255, 70, 70)},
        ["Sunny"]      = {kind = "sunny", tint = Color3.fromRGB(26, 20, 8),
                          a = Color3.fromRGB(255, 190, 80), b = Color3.fromRGB(255, 235, 160)},
        ["Snow"]       = {kind = "snow", tint = Color3.fromRGB(8, 18, 36),
                          a = Color3.fromRGB(190, 225, 255), b = Color3.fromRGB(120, 180, 255)},
        ["Sakura"]     = {kind = "sakura", tint = Color3.fromRGB(30, 10, 20),
                          a = Color3.fromRGB(255, 140, 190), b = Color3.fromRGB(255, 205, 228)},
    }
    UI.ThemeNames = {"Rain", "Blood Rain", "Sunny", "Snow", "Sakura"}

    local parts, splashes, curDef, nextFlash = {}, {}, defs.Rain, 0

    local function Splash(x)
        if #splashes > 12 then return end
        local col = curDef.blood and Color3.fromRGB(170, 25, 40) or Color3.fromRGB(170, 200, 240)
        local s = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, H - 4),
            Size = UDim2.new(0, 3, 0, 2), BackgroundColor3 = col, BackgroundTransparency = 0.55,
            BorderSizePixel = 0, ZIndex = 1}, Layer)
        Corner(s, 999)
        splashes[#splashes + 1] = s
        tw(s, 0.35, {Size = UDim2.new(0, 16, 0, 4), BackgroundTransparency = 1})
        task.delay(0.4, function()
            for i, v in ipairs(splashes) do if v == s then table.remove(splashes, i) break end end
            pcall(function() s:Destroy() end)
        end)
    end

    local function DoFlash(color)
        task.spawn(function()
            pcall(function()
                Flash.BackgroundColor3 = color
                Flash.BackgroundTransparency = 1
                tw(Flash, 0.06, {BackgroundTransparency = 0.82}).Completed:Wait()
                tw(Flash, 0.08, {BackgroundTransparency = 1}).Completed:Wait()
                tw(Flash, 0.05, {BackgroundTransparency = 0.88}).Completed:Wait()
                tw(Flash, 0.12, {BackgroundTransparency = 1})
            end)
        end)
    end

    function UI.SetTheme(name)
        if not defs[name] then name = "Rain" end
        curDef = defs[name]
        Cfg.Theme = name
        for _, p in ipairs(parts) do pcall(function() p.f:Destroy() end) end
        for _, s in ipairs(splashes) do pcall(function() s:Destroy() end) end
        parts, splashes = {}, {}
        local count = (W < 520) and 16 or 30
        if curDef.kind == "rain" then
            for i = 1, count do
                local depth = (i % 3 == 0) and 2 or 1
                local len = math.random(9, 22) * (depth == 2 and 1.5 or 1)
                local col = curDef.blood and Color3.fromRGB(200, 35, 50) or Color3.fromRGB(175, 205, 255)
                local f = New("Frame", {Size = UDim2.new(0, depth == 2 and 2 or 1, 0, len),
                    BackgroundColor3 = col,
                    BackgroundTransparency = (depth == 2 and 0.45 or 0.68) + math.random() * 0.15,
                    BorderSizePixel = 0, Rotation = curDef.blood and 4 or (10 + depth * 3), ZIndex = 1}, Layer)
                local v0 = (depth == 2 and 850 or 500) + math.random(0, 260)
                parts[#parts + 1] = {f = f, x = math.random(-40, W + 40), y = math.random(-H, H), v = v0, v0 = v0, len = len}
            end
        elseif curDef.kind == "snow" then
            for i = 1, count do
                local sz = math.random(3, 6)
                local f = New("Frame", {Size = UDim2.new(0, sz, 0, sz), BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 0.35 + math.random() * 0.4, BorderSizePixel = 0, ZIndex = 1}, Layer)
                Corner(f, 3)
                parts[#parts + 1] = {f = f, x = math.random(0, W), y = math.random(-H, H),
                    v = math.random(28, 75), sw = 8 + math.random() * 14, ph = math.random() * 6.28, k = "sway"}
            end
        elseif curDef.kind == "sakura" then
            for i = 1, count do
                local f = New("Frame", {Size = UDim2.new(0, math.random(7, 11), 0, math.random(5, 7)),
                    BackgroundColor3 = Color3.fromRGB(255, math.random(150, 190), math.random(190, 220)),
                    BackgroundTransparency = 0.4 + math.random() * 0.35, BorderSizePixel = 0, ZIndex = 1}, Layer)
                Corner(f, 4)
                parts[#parts + 1] = {f = f, x = math.random(0, W), y = math.random(-H, H),
                    v = math.random(35, 85), sw = 14 + math.random() * 22, ph = math.random() * 6.28,
                    rot = math.random(0, 360), rs = math.random(-70, 70), k = "sakura"}
            end
        elseif curDef.kind == "sunny" then
            -- güneş parlaması (sağ üst)
            for idx, s in ipairs({190, 130, 78}) do
                local tr = ({0.93, 0.88, 0.8})[idx]
                local g = New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(1, -60, 0, 40), Size = UDim2.new(0, s, 0, s),
                    BackgroundColor3 = Color3.fromRGB(255, 210, 110), BackgroundTransparency = tr,
                    BorderSizePixel = 0, ZIndex = 1}, Layer)
                Corner(g, 999)
                parts[#parts + 1] = {f = g, k = "glow"}
            end
            -- tanrı ışınları
            for i = 1, 3 do
                local ray = New("Frame", {Size = UDim2.new(0, 60 + i * 30, 0, H * 1.6),
                    Position = UDim2.new(0.5 + i * 0.14, 0, 0, -H * 0.35),
                    BackgroundColor3 = Color3.fromRGB(255, 235, 180), BackgroundTransparency = 0.93,
                    BorderSizePixel = 0, Rotation = 18, ZIndex = 1}, Layer)
                parts[#parts + 1] = {f = ray, k = "ray", base = 0.93, spd = 0.5 + math.random() * 0.5, ph = math.random() * 6}
            end
            -- havada süzülen altın tozlar
            for i = 1, 16 do
                local sz = math.random(2, 4)
                local f = New("Frame", {Size = UDim2.new(0, sz, 0, sz),
                    BackgroundColor3 = Color3.fromRGB(255, 225, 160),
                    BackgroundTransparency = 0.5 + math.random() * 0.3, BorderSizePixel = 0, ZIndex = 1}, Layer)
                Corner(f, 2)
                parts[#parts + 1] = {f = f, k = "mote", x = math.random(0, W), y = math.random(0, H),
                    v = math.random(6, 18), ph = math.random() * 6}
            end
        end
        strokeGrad.Color = ColorSequence.new(curDef.a, curDef.b)
        tw(tint, 0.6, {BackgroundColor3 = curDef.tint})
    end

    U.Conn(RunService.RenderStepped, function(dt)
        if not Main.Visible then return end
        local now = os.clock()
        for _, pl in ipairs(UI.Pulses) do
            if pl.on() then pl.stroke.Transparency = 0.02 + (math.sin(now * 3) + 1) * 0.1 end
        end
        Layer.Visible = Cfg.Rain
        if not Layer.Visible then return end
        if curDef.kind == "rain" then
            if now > nextFlash then
                nextFlash = now + 6 + math.random(0, 8)
                DoFlash(curDef.flash)
            end
            for _, d in ipairs(parts) do
                d.y = d.y + d.v * dt
                d.x = d.x - d.v * 0.16 * dt -- rüzgar
                if d.y > H then
                    Splash(d.x)
                    d.y = -d.len - math.random(0, 60)
                    d.x = math.random(-40, W + 40)
                    d.v = d.v0 + math.random(-60, 60)
                end
                d.f.Position = UDim2.fromOffset(d.x, d.y)
            end
        elseif curDef.kind == "snow" or curDef.kind == "sakura" then
            for _, d in ipairs(parts) do
                d.y = d.y + d.v * dt
                d.x = d.x + math.sin(now * 1.3 + d.ph) * d.sw * dt
                if d.k == "sakura" then
                    d.rot = d.rot + d.rs * dt
                    d.f.Rotation = d.rot
                end
                if d.y > H + 14 then d.y = -14 d.x = math.random(0, W) end
                d.f.Position = UDim2.fromOffset(d.x, d.y)
            end
        elseif curDef.kind == "sunny" then
            for _, p in ipairs(parts) do
                if p.k == "ray" then
                    p.f.BackgroundTransparency = p.base + (math.sin(now * p.spd + p.ph) + 1) * 0.03
                elseif p.k == "mote" then
                    p.y = p.y - p.v * dt
                    p.x = p.x + math.sin(now * 0.8 + p.ph) * 6 * dt
                    if p.y < -8 then p.y = H + 8 p.x = math.random(0, W) end
                    p.f.Position = UDim2.fromOffset(p.x, p.y)
                end
            end
        end
    end)

    -- ÜST BAR
    local Top = New("Frame", {Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = Color3.fromRGB(4, 4, 10),
        BackgroundTransparency = 0.45, BorderSizePixel = 0, ZIndex = 2}, Main)
    New("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.Line, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 3}, Top)
    New("TextLabel", {Size = UDim2.new(1, -150, 0, 22), Position = UDim2.new(0, 16, 0, 5),
        BackgroundTransparency = 1, Text = titleText, TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3}, Top)
    New("TextLabel", {Size = UDim2.new(1, -150, 0, 14), Position = UDim2.new(0, 16, 0, 26),
        BackgroundTransparency = 1, Text = subtitleText or "", TextColor3 = Theme.Sub,
        Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3}, Top)
    local Emblem = New("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 120, 0, 6),
        BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.15, Text = "M",
        TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBlack, TextSize = 12, ZIndex = 3}, Top)
    Corner(Emblem, 6)

    local MinBtn = New("TextButton", {Size = UDim2.new(0, 42, 1, 0), Position = UDim2.new(1, -84, 0, 0),
        BackgroundTransparency = 1, Text = "-", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold,
        TextSize = 26, ZIndex = 3}, Top)
    local CloseBtn = New("TextButton", {Size = UDim2.new(0, 42, 1, 0), Position = UDim2.new(1, -42, 0, 0),
        BackgroundTransparency = 1, Text = "X", TextColor3 = Color3.fromRGB(255, 90, 90),
        Font = Enum.Font.GothamBold, TextSize = 20, ZIndex = 3}, Top)
    MakeDraggable(Top, Main)

    -- yüzen açma butonu
    local Float = New("TextButton", {Size = UDim2.new(0, 46, 0, 46), AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.35, 0), BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.15,
        Text = "M", TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBlack, TextSize = 22,
        Visible = false, AutoButtonColor = false}, Gui)
    Corner(Float, 23)
    Stroke(Float, Theme.Line, 1.5, 0.3)
    local floatScale = New("UIScale", {Scale = 1}, Float)
    Float.MouseEnter:Connect(function() tw(floatScale, 0.2, {Scale = 1.12}, Enum.EasingStyle.Back) end)
    Float.MouseLeave:Connect(function() tw(floatScale, 0.2, {Scale = 1}) end)

    function UI.Show()
        Main.Visible = true
        Float.Visible = false
        UI.Scale.Scale = Cfg.UIScale * 0.86
        tw(UI.Scale, 0.45, {Scale = Cfg.UIScale}, Enum.EasingStyle.Back)
    end
    function UI.Hide()
        tw(UI.Scale, 0.22, {Scale = Cfg.UIScale * 0.86}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.24, function()
            Main.Visible = false
            Float.Visible = true
            UI.Scale.Scale = Cfg.UIScale
            floatScale.Scale = 0.6
            tw(floatScale, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
        end)
    end
    MinBtn.MouseButton1Click:Connect(UI.Hide)
    Float.MouseButton1Click:Connect(UI.Show)
    CloseBtn.MouseButton1Click:Connect(function() U.Shutdown() end)

    -- YAN MENÜ
    New("Frame", {Size = UDim2.new(0, SW, 1, -44), Position = UDim2.new(0, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(4, 4, 10), BackgroundTransparency = 0.6,
        BorderSizePixel = 0, ZIndex = 2}, Main)
    local SideClip = New("Frame", {Size = UDim2.new(0, SW, 1, -44), Position = UDim2.new(0, 0, 0, 44),
        BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2}, Main)
    local Pill = New("Frame", {Size = UDim2.new(1, -12, 0, 34), Position = UDim2.new(0, 6, 0, 0),
        BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.8, BorderSizePixel = 0,
        Visible = false, ZIndex = 2}, SideClip)
    Corner(Pill, 8)
    New("Frame", {Size = UDim2.new(0, 3, 1, -14), Position = UDim2.new(0, 0, 0, 7),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 3}, Pill)
    Corner(Pill:FindFirstChildOfClass("Frame") or Pill, 2)

    local Side = New("ScrollingFrame", {Size = UDim2.new(0, SW, 1, -44), Position = UDim2.new(0, 0, 0, 44),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Line, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3}, Main)
    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, Side)
    Pad(Side, 6, 6, 6, 6)

    -- profil kartı
    local Card = New("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 0.5, BorderSizePixel = 0, LayoutOrder = 0, ZIndex = 4}, Side)
    Corner(Card, 10)
    local Av = New("ImageLabel", {Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0, 7, 0.5, -16),
        BackgroundColor3 = Theme.Bg, BorderSizePixel = 0, ZIndex = 5}, Card)
    Corner(Av, 16)
    New("TextLabel", {Size = UDim2.new(1, -48, 0, 16), Position = UDim2.new(0, 45, 0, 7),
        BackgroundTransparency = 1, Text = LocalPlayer.DisplayName, TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5}, Card)
    UI.ProfileSub = New("TextLabel", {Size = UDim2.new(1, -48, 0, 14), Position = UDim2.new(0, 45, 0, 24),
        BackgroundTransparency = 1, Text = "Lv ...", TextColor3 = Theme.Sub, Font = Enum.Font.Gotham,
        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5}, Card)
    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and img then Av.Image = img end
    end)

    local Content = New("Frame", {Size = UDim2.new(1, -SW, 1, -44), Position = UDim2.new(0, SW, 0, 44),
        BackgroundTransparency = 1, ZIndex = 2}, Main)

    local Window = {Tabs = {}, Gui = Gui, Main = Main}

    local function pillY(idx)
        return 6 + 46 + 4 + (idx - 1) * 38 - Side.CanvasPosition.Y
    end
    U.Conn(Side:GetPropertyChangedSignal("CanvasPosition"), function()
        if Window.Selected then Pill.Position = UDim2.new(0, 6, 0, pillY(Window.Selected.idx)) end
    end)

    function Window:CreateTab(name, icon)
        local idx = #Window.Tabs + 1
        local Btn = New("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1,
            Text = " " .. (icon or "") .. " " .. name, TextColor3 = Theme.Sub,
            Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, AutoButtonColor = false,
            LayoutOrder = idx, ZIndex = 4}, Side)
        Pad(Btn, 6, 0, 0, 0)

        local Group = New("CanvasGroup", {Size = UDim2.new(1, -8, 1, -8), Position = UDim2.new(0, 4, 0, 4),
            BackgroundTransparency = 1, GroupTransparency = 1, Visible = false, ZIndex = 3}, Content)
        local Page = New("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Line,
            ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3}, Group)
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
                tw(Pill, 0.38, {Position = UDim2.new(0, 6, 0, pillY(idx))})
            end
        end
        Btn.MouseButton1Click:Connect(Select)
        if idx == 1 then task.defer(Select) end

        local Tab = {Page = Page}
        local order = 0
        local function nextOrder() order = order + 1 return order end

        function Tab:Section(text)
            New("TextLabel", {Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1,
                Text = string.upper(text), TextColor3 = Theme.Sub, Font = Enum.Font.GothamBold,
                TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Bottom, LayoutOrder = nextOrder(), ZIndex = 3}, Page)
        end

        function Tab:Note(text)
            New("TextLabel", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Text = "💡 " .. text, TextColor3 = Theme.Sub,
                Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrder(), ZIndex = 3}, Page)
        end

        function Tab:Toggle(text, default, callback)
            local state = default and true or false
            local btn = New("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Theme.Card,
                BackgroundTransparency = 0.35, BorderSizePixel = 0, Text = "", AutoButtonColor = false,
                LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            Corner(btn, 8)
            New("TextLabel", {Size = UDim2.new(1, -64, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4}, btn)
            local track = New("Frame", {Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -46, 0.5, -9),
                BackgroundColor3 = Theme.Off, BorderSizePixel = 0, ZIndex = 4}, btn)
            Corner(track, 9)
            local dot = New("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = Theme.Sub, BorderSizePixel = 0, ZIndex = 5}, track)
            Corner(dot, 7)
            local obj
            obj = {
                Set = function(v, silent)
                    state = v and true or false
                    if state then
                        tw(track, 0.2, {BackgroundColor3 = Theme.Accent})
                        tw(dot, 0.2, {Position = UDim2.new(1, -16, 0.5, -7), BackgroundColor3 = Color3.new(1, 1, 1)})
                    else
                        tw(track, 0.2, {BackgroundColor3 = Theme.Off})
                        tw(dot, 0.2, {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Theme.Sub})
                    end
                    if not silent then
                        local ok, e = pcall(callback, state)
                        if not ok then U.Log(e) end
                    end
                end,
                Get = function() return state end,
            }
            btn.MouseButton1Down:Connect(function(x, y) Ripple(btn, x, y) end)
            btn.MouseButton1Click:Connect(function() obj.Set(not state) end)
            obj.Set(state, true)
            return obj
        end

        function Tab:Slider(text, min, max, default, decimals, callback)
            local val = math.clamp(default or min, min, max)
            local holder = New("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1,
                LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            New("TextLabel", {Size = UDim2.new(1, -70, 0, 16), Position = UDim2.new(0, 12, 0, 4),
                BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4}, holder)
            local vlbl = New("TextLabel", {Size = UDim2.new(0, 60, 0, 16), Position = UDim2.new(1, -72, 0, 4),
                BackgroundTransparency = 1, Text = "", TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBold,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4}, holder)
            local bar = New("Frame", {Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 34),
                BackgroundColor3 = Theme.Off, BorderSizePixel = 0, ZIndex = 4}, holder)
            Corner(bar, 3)
            local fill = New("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0, ZIndex = 5}, bar)
            Corner(fill, 3)
            local hit = New("TextButton", {Size = UDim2.new(1, 0, 0, 26), Position = UDim2.new(0, 0, 0, 20),
                BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 6}, holder)

            local function fmt(v)
                if decimals and decimals > 0 then return string.format("%." .. decimals .. "f", v) end
                return tostring(math.floor(v))
            end
            local function set(v, silent)
                val = math.clamp(v, min, max)
                vlbl.Text = fmt(val)
                fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                if not silent then
                    local ok, e = pcall(callback, val)
                    if not ok then U.Log(e) end
                end
            end
            local dragging = false
            hit.InputBegan:Connect(function(i)
                if IsPointer(i) then
                    dragging = true
                    set(min + (max - min) * math.clamp((i.Position.X - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1))
                end
            end)
            U.Conn(UserInputService.InputEnded, function(i) if IsPointer(i) then dragging = false end end)
            U.Conn(UserInputService.InputChanged, function(i)
                if dragging and IsMove(i) then
                    set(min + (max - min) * math.clamp((i.Position.X - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1))
                end
            end)
            set(val, true)
            return {Set = function(v, s) set(v, s) end, Get = function() return val end}
        end

        function Tab:Dropdown(text, options, default, callback)
            local value = default or options[1]
            local holder = New("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1,
                LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            local btn = New("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Theme.Card,
                BackgroundTransparency = 0.35, BorderSizePixel = 0, Text = "", AutoButtonColor = false,
                ZIndex = 4}, holder)
            Corner(btn, 8)
            New("TextLabel", {Size = UDim2.new(1, -130, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Sub, Font = Enum.Font.Gotham,
                TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5}, btn)
            local val = New("TextLabel", {Size = UDim2.new(0, 92, 1, 0), Position = UDim2.new(1, -110, 0, 0),
                BackgroundTransparency = 1, Text = tostring(value), TextColor3 = Theme.Accent2,
                Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5}, btn)
            New("TextLabel", {Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -22, 0, 0),
                BackgroundTransparency = 1, Text = "▾", TextColor3 = Theme.Sub, Font = Enum.Font.Gotham,
                TextSize = 12, ZIndex = 5}, btn)

            local open = false
            local listH = math.min(#options, 6) * 30 + 8
            local list = New("ScrollingFrame", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 36),
                BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.15, BorderSizePixel = 0,
                ScrollBarThickness = 2, CanvasSize = UDim2.new(0, 0, 0, #options * 30 + 4),
                ClipsDescendants = true, ZIndex = 6}, holder)
            Corner(list, 8)
            New("UIListLayout", {Padding = UDim.new(0, 2)}, list)
            for _, opt in ipairs(options) do
                local ob = New("TextButton", {Size = UDim2.new(1, -8, 0, 28), BackgroundTransparency = 1,
                    Text = "  " .. tostring(opt), TextColor3 = Theme.Text, Font = Enum.Font.Gotham,
                    TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false,
                    ZIndex = 7}, list)
                ob.MouseButton1Click:Connect(function()
                    value = opt
                    val.Text = tostring(opt)
                    open = false
                    holder.ZIndex = 3
                    tw(list, 0.2, {Size = UDim2.new(1, 0, 0, 0)})
                    local ok, e = pcall(callback, opt)
                    if not ok then U.Log(e) end
                end)
            end
            btn.MouseButton1Click:Connect(function()
                open = not open
                holder.ZIndex = open and 10 or 3
                tw(list, 0.22, {Size = UDim2.new(1, 0, 0, open and listH or 0)})
            end)
            return {Get = function() return value end}
        end

        function Tab:Button(text, callback)
            local b = New("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Theme.Card,
                BackgroundTransparency = 0.35, BorderSizePixel = 0, Text = text, TextColor3 = Theme.Text,
                Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false,
                LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            Corner(b, 8)
            b.MouseButton1Down:Connect(function(x, y) Ripple(b, x, y) end)
            b.MouseButton1Click:Connect(function()
                local ok, e = pcall(callback)
                if not ok then U.Log(e) end
            end)
            return b
        end

        function Tab:TextBox(text, placeholder, default, callback)
            local holder = New("Frame", {Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1,
                LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            New("TextLabel", {Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 12, 0, 2),
                BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Sub, Font = Enum.Font.GothamBold,
                TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4}, holder)
            local tb = New("TextBox", {Size = UDim2.new(1, -24, 0, 30), Position = UDim2.new(0, 12, 0, 18),
                BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.3, Text = default or "",
                PlaceholderText = placeholder or "", TextColor3 = Theme.Text, Font = Enum.Font.Gotham,
                TextSize = 11, ClearTextOnFocus = false, BorderSizePixel = 0, ZIndex = 4}, holder)
            Corner(tb, 8)
            tb.FocusLost:Connect(function()
                local ok, e = pcall(callback, tb.Text)
                if not ok then U.Log(e) end
            end)
            return tb
        end

        function Tab:BigToggle(title, subtitle, default, callback, colA, colB)
            local state = default and true or false
            local card = New("Frame", {Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = state and 0.42 or 0.8, BorderSizePixel = 0,
                ClipsDescendants = true, LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            Corner(card, 12)
            New("UIGradient", {Color = ColorSequence.new(colA or Theme.Accent, colB or Theme.Accent2), Rotation = 20}, card)
            local stK = Stroke(card, colB or Theme.Accent2, 1.5, state and 0.4 or 0.75)
            New("TextLabel", {Size = UDim2.new(1, -100, 0, 22), Position = UDim2.new(0, 14, 0, 9),
                BackgroundTransparency = 1, Text = title, TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4}, card)
            local sub = New("TextLabel", {Size = UDim2.new(1, -100, 0, 34), Position = UDim2.new(0, 14, 0, 33),
                BackgroundTransparency = 1, Text = subtitle or "", TextColor3 = Color3.fromRGB(228, 228, 245),
                Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, ZIndex = 4}, card)
            local pill = New("TextLabel", {Size = UDim2.new(0, 62, 0, 28), Position = UDim2.new(1, -76, 0.5, -14),
                BackgroundColor3 = Color3.fromRGB(10, 10, 20), BackgroundTransparency = 0.25,
                Text = state and "ON" or "OFF",
                TextColor3 = state and Color3.fromRGB(110, 255, 160) or Theme.Sub,
                Font = Enum.Font.GothamBlack, TextSize = 13, ZIndex = 4}, card)
            Corner(pill, 14)
            local hit = New("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = "", ZIndex = 6}, card)
            local obj
            obj = {
                Set = function(v, silent)
                    state = v and true or false
                    pill.Text = state and "ON" or "OFF"
                    pill.TextColor3 = state and Color3.fromRGB(110, 255, 160) or Theme.Sub
                    tw(card, 0.3, {BackgroundTransparency = state and 0.42 or 0.8})
                    tw(stK, 0.3, {Transparency = state and 0.4 or 0.75})
                    if not silent then
                        local ok, e = pcall(callback, state)
                        if not ok then U.Log(e) end
                    end
                end,
                Get = function() return state end,
                SetStatus = function(t) sub.Text = tostring(t) end,
            }
            table.insert(UI.Pulses, {on = function() return state end, stroke = stK})
            hit.MouseButton1Down:Connect(function(x, y) Ripple(hit, x, y) end)
            hit.MouseButton1Click:Connect(function() obj.Set(not state) end)
            return obj
        end

        function Tab:StatRow(labels)
            local row = New("Frame", {Size = UDim2.new(1, 0, 0, 54), BackgroundTransparency = 1,
                LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            New("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6)}, row)
            local cells = {}
            for i, cap in ipairs(labels) do
                local c = New("Frame", {Size = UDim2.new(1 / #labels, -6, 1, 0), BackgroundColor3 = Theme.Card,
                    BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 4}, row)
                Corner(c, 8)
                New("TextLabel", {Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 8),
                    BackgroundTransparency = 1, Text = cap, TextColor3 = Theme.Sub,
                    Font = Enum.Font.GothamBold, TextSize = 8, ZIndex = 5}, c)
                cells[i] = New("TextLabel", {Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 0, 24),
                    BackgroundTransparency = 1, Text = "-", TextColor3 = Theme.Text,
                    Font = Enum.Font.GothamBold, TextSize = 13, ZIndex = 5}, c)
            end
            return {Set = function(i, t) if cells[i] then cells[i].Text = tostring(t) end end}
        end

        return Tab
    end
    return Window
end

-- ============================== COMBAT (FAST ATTACK) ==============================
Combat.LastTool = nil

function Combat.GetTool()
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool then Combat.LastTool = tool end
    return tool or Combat.LastTool
end

function Combat.EnsureEquipped()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not (char and hum) then return end
    if char:FindFirstChildOfClass("Tool") then return end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then return end
    local want
    if Cfg.WeaponType == "Melee (Combat)" then
        want = bp:FindFirstChild("Combat")
    else
        for _, n in ipairs(Data.Swords) do
            local t = bp:FindFirstChild(n)
            if t then want = t break end
        end
        if not want then want = bp:FindFirstChild("Combat") end
    end
    if want then pcall(function() hum:EquipTool(want) end) end
end

function Combat.AutoBuso()
    local char = LocalPlayer.Character
    if char and not char:FindFirstChild("HasBusoHaki") then
        U.CommAsync("Buso")
    end
end

function Combat.Click()
    local m = Cfg.ClickMethod
    local useVIM = m == "VirtualInputManager (Redz)" or Cfg.SuperAttack
    local useVU  = m == "VirtualUser" or Cfg.SuperAttack
    local useTA  = m == "Tool Activate" or Cfg.SuperAttack
    local useFS  = m == "FireSignal Bypass" or Cfg.SuperAttack
    if useVIM and VirtualInputManager then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
    end
    if useVU then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new())
            VirtualUser:Button1Up(Vector2.new())
        end)
    end
    local tool = Combat.GetTool()
    if useTA and tool then
        pcall(function() tool:Activate() end)
    end
    if useFS and tool then
        pcall(function()
            if Ex.FireSignal then
                Ex.FireSignal(tool.Activated)
            elseif Ex.GetConnections then
                for _, c in ipairs(Ex.GetConnections(tool.Activated)) do
                    c:Fire()
                end
            end
        end)
    end
end

-- ============================== FARM ==============================
local function ScanMobs()
    local out = {}
    local live = Workspace:FindFirstChild("Live")
    local parents = live and {live, Workspace} or {Workspace}
    for _, parent in ipairs(parents) do
        for _, obj in ipairs(parent:GetChildren()) do
            local h = obj:FindFirstChildOfClass("Humanoid")
            local r = obj:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                out[#out + 1] = {inst = obj, hum = h, hrp = r, name = U.CleanName(obj.Name)}
            end
        end
    end
    return out
end

Farm.Status, Farm.QuestKey, Farm.QuestChar, Farm.Target = "-", nil, nil, nil
Farm.OrigSize, Farm.AnchoredList = {}, {}

function Farm.Row()
    local lvl = U.Level()
    local list = Data.Quests[Sea] or {}
    local best
    for _, r in ipairs(list) do
        if lvl >= r[1] then best = r end
    end
    return best or list[1]
end

function Farm.MoveTo(cf)
    local root = U.Root()
    if not root then return end
    local dist = (root.Position - cf.Position).Magnitude
    if dist < 3 then return end
    if Farm.Tw then Farm.Tw:Cancel() end
    Farm.Tw = TweenService:Create(root,
        TweenInfo.new(math.clamp(dist / Cfg.TweenSpeed, 0.15, 8), Enum.EasingStyle.Linear), {CFrame = cf})
    Farm.Tw:Play()
end

function Farm.ApplyHitbox(mobs)
    for hrp in pairs(Farm.OrigSize) do
        if not hrp.Parent then Farm.OrigSize[hrp] = nil end
    end
    local s = V3(Cfg.HitboxSize, Cfg.HitboxSize, Cfg.HitboxSize)
    for _, m in ipairs(mobs) do
        if m.hrp.Size ~= s then
            Farm.OrigSize[m.hrp] = m.hrp.Size
            m.hrp.Size = s
        end
    end
end

function Farm.ClearHitbox()
    for hrp, sz in pairs(Farm.OrigSize) do
        pcall(function() if hrp.Parent then hrp.Size = sz end end)
    end
    Farm.OrigSize = {}
end

function Farm.ClearAnchors()
    for hrp in pairs(Farm.AnchoredList) do
        pcall(function() if hrp.Parent then hrp.Anchored = false end end)
    end
    Farm.AnchoredList = {}
end

-- BRING MOB DÜZELTMESİ:
-- Moblar önce spawn yakınına gelinir (network ownership geçsin),
-- sonra önümüzde HALK şeklinde dizilir, hızları sıfırlanır → VURULABİLİR
function Farm.Bring(mobs, root)
    local base = root.CFrame * CF(0, -3, -9)
    for i, m in ipairs(mobs) do
        if (m.hrp.Position - root.Position).Magnitude <= Cfg.BringRadius then
            local ang = (i / #mobs) * math.pi * 2
            pcall(function()
                m.hrp.CFrame = base * CF(math.cos(ang) * 5, 1.2, math.sin(ang) * 5)
                m.hrp.AssemblyLinearVelocity = V3()
                m.hrp.AssemblyAngularVelocity = V3()
                if Cfg.AnchorMobs then
                    m.hrp.Anchored = true
                    Farm.AnchoredList[m.hrp] = true
                end
            end)
        end
    end
end

function Farm.Step()
    if not Cfg.AutoFarm then Farm.Status = "-" return end
    local root = U.Root()
    if not root then Farm.Status = "Respawn bekleniyor..." return end
    if Cfg.StopAtTarget and U.Level() >= Cfg.TargetLevel then Farm.Status = "Hedef seviye tamam ✅" return end
    local row = Farm.Row()
    if not row then Farm.Status = "Quest verisi yok" return end

    if Cfg.UseQuest then
        local key = row[3] .. tostring(row[4])
        if Farm.QuestKey ~= key or Farm.QuestChar ~= LocalPlayer.Character then
            Farm.QuestKey, Farm.QuestChar = key, LocalPlayer.Character
            Farm.Status = "Quest alınıyor: " .. row[2]
            U.Spawn(function()
                U.Comm("AbandonQuest")
                task.wait(0.25)
                U.Comm("StartQuest", row[3], row[4])
            end)
        end
    end
    if Cfg.AutoBuso then Combat.AutoBuso() end
    if Cfg.AutoEquip then Combat.EnsureEquipped() end

    local mobName = (Cfg.FarmMob and Cfg.SelectedMob ~= "" and Cfg.SelectedMob) or row[2]
    local mobs = {}
    for _, m in ipairs(ScanMobs()) do
        if m.name == mobName then mobs[#mobs + 1] = m end
    end

    if Cfg.Hitbox then Farm.ApplyHitbox(mobs) end

    if #mobs == 0 then
        Farm.Status = mobName .. " yok → spawn'a gidiliyor"
        Farm.Target = nil
        local sp = (Cfg.FarmMob and Data.MobPos[mobName]) or row[6]
        Farm.MoveTo(CF(sp) * CF(0, Cfg.FarmHeight, 0))
        return
    end

    table.sort(mobs, function(a, b)
        return (a.hrp.Position - root.Position).Magnitude < (b.hrp.Position - root.Position).Magnitude
    end)
    local target = mobs[1]
    Farm.Target = target
    Farm.Status = "Avlanıyor: " .. mobName .. " (" .. #mobs .. " adet)"

    if Cfg.Method == "Tween (Güvenli)" then
        if (root.Position - target.hrp.Position).Magnitude > 35 then
            Farm.MoveTo(target.hrp.CFrame * CF(0, Cfg.FarmHeight, 0))
        end
    elseif Cfg.Method == "Bring (Hızlı)" then
        local sp = row[6]
        local flat = V3(sp.X, root.Position.Y, sp.Z)
        if (root.Position - flat).Magnitude > math.min(Cfg.BringRadius, 140) then
            Farm.Status = "Spawn'a yaklaşılıyor (ownership)..."
            Farm.MoveTo(CF(sp) * CF(0, Cfg.FarmHeight, 0))
        else
            Farm.Bring(mobs, root)
        end
    else -- Hybrid
        if (root.Position - target.hrp.Position).Magnitude > 60 then
            Farm.MoveTo(target.hrp.CFrame * CF(0, Cfg.FarmHeight, 0))
        else
            Farm.Bring(mobs, root)
        end
    end
end

U.Loop(0.25, Farm.Step)

U.Conn(LocalPlayer.CharacterAdded, function()
    Farm.QuestChar = nil
end)

-- saldırı döngüsü (Fast Attack)
task.spawn(function()
    while U.Alive() do
        if Cfg.FastAttack and (Cfg.AutoFarm or Cfg.AttackAlways) then
            if Cfg.AutoEquip then Combat.EnsureEquipped() end
            if Cfg.AttackAlways and Cfg.AutoBuso then Combat.AutoBuso() end
            Combat.Click()
        end
        task.wait(math.max(Cfg.AttackSpeed, 0.05))
    end
end)

-- auto skills
U.Loop(1.5, function()
    if not (Cfg.AutoSkills and Cfg.FastAttack and (Cfg.AutoFarm or Cfg.AttackAlways)) then return end
    for _, k in ipairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}) do
        if VirtualInputManager then
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, k, false, game)
                VirtualInputManager:SendKeyEvent(false, k, false, game)
            end)
        end
        task.wait(0.12)
    end
end)

-- auto stat
U.Loop(2, function()
    if not Cfg.StatOn then return end
    local pts = U.Points()
    if pts > 0 then
        U.CommAsync("addPoint", Cfg.StatType, math.min(pts, Cfg.StatAmount))
    end
end)

-- ============================== ESP ==============================
ESP.Tagged = {}
local function SetTag(hrp, text, color)
    if not (hrp and hrp.Parent) then return end
    local t = ESP.Tagged[hrp]
    if not t then
        local b = Instance.new("BillboardGui")
        b.Name = "MH_Tag"
        b.Size = UDim2.new(0, 160, 0, 18)
        b.StudsOffset = Vector3.new(0, 4, 0)
        b.AlwaysOnTop = true
        b.MaxDistance = 2500
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.GothamBold
        l.TextSize = 12
        l.TextStrokeTransparency = 0.5
        l.Parent = b
        b.Parent = hrp
        t = {gui = b, label = l}
        ESP.Tagged[hrp] = t
    end
    t.label.Text = text
    t.label.TextColor3 = color
end

U.Loop(1, function()
    local root = U.Root()
    local seen = {}
    if Cfg.ESPPlayer then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    seen[hrp] = true
                    local d = root and math.floor((hrp.Position - root.Position).Magnitude) or 0
                    SetTag(hrp, plr.DisplayName .. " [" .. d .. "m]", Color3.fromRGB(255, 90, 90))
                end
            end
        end
    end
    if Cfg.ESPMob then
        for _, m in ipairs(ScanMobs()) do
            if root and (m.hrp.Position - root.Position).Magnitude < 900 then
                seen[m.hrp] = true
                SetTag(m.hrp, m.name .. " [" .. math.floor((m.hrp.Position - root.Position).Magnitude) .. "m]",
                    Color3.fromRGB(170, 130, 255))
            end
        end
    end
    if Cfg.ESPFruit then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if Data.Fruits[obj.Name] then
                local p = (obj:IsA("Tool") and obj:FindFirstChild("Handle")) or obj:FindFirstChildWhichIsA("BasePart", true)
                if p then
                    seen[p] = true
                    SetTag(p, "🍎 " .. obj.Name, Color3.fromRGB(255, 170, 60))
                end
            end
        end
    end
    if Cfg.ESPChest then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name:match("^Chest") then
                local p = (obj:IsA("BasePart") and obj) or obj:FindFirstChildWhichIsA("BasePart", true)
                if p then
                    seen[p] = true
                    SetTag(p, "💰 Chest", Color3.fromRGB(255, 220, 90))
                end
            end
        end
    end
    for hrp, t in pairs(ESP.Tagged) do
        if not seen[hrp] or not hrp.Parent then
            pcall(function() t.gui:Destroy() end)
            ESP.Tagged[hrp] = nil
        end
    end
end)

-- ============================== MİSC ==============================
function Misc.Webhook(content)
    if Cfg.WebhookURL == "" then return end
    local req = (syn and syn.request) or (http and http.request) or request or http_request
    if not req then return end
    pcall(function()
        req({Url = Cfg.WebhookURL, Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({content = content})})
    end)
end

function Misc.Save()
    if not writefile then U.Notify("Config", "Executor'da writefile yok 😕") return end
    pcall(function() writefile("MorganHubV4.json", HttpService:JSONEncode(Cfg)) end)
    U.Notify("Config", "Kaydedildi 💾")
end

-- meyve + sandık toplama
local seenFruit = setmetatable({}, {__mode = "k"})
U.Loop(2, function()
    if not (Cfg.AutoCollectFruit or Cfg.AutoChest) then return end
    local root = U.Root()
    if not root then return end
    for _, obj in ipairs(Workspace:GetChildren()) do
        local isFruit = Data.Fruits[obj.Name] ~= nil
        local isChest = Cfg.AutoChest and obj.Name:match("^Chest") ~= nil
        if isFruit or isChest then
            local p = (obj:IsA("BasePart") and obj)
                or (obj:IsA("Tool") and obj:FindFirstChild("Handle"))
                or obj:FindFirstChildWhichIsA("BasePart", true)
            if p then
                if isFruit and Cfg.FruitNotify and not seenFruit[obj] then
                    seenFruit[obj] = true
                    U.Notify("🍎 Fruit Spawn", obj.Name .. " spawn oldu!")
                    if Cfg.WhFruit then Misc.Webhook("🍎 **" .. obj.Name .. "** spawn oldu!") end
                end
                root.CFrame = p.CFrame + V3(0, 2, 0)
                task.wait(0.15)
                if Ex.FireTouch then
                    pcall(function()
                        Ex.FireTouch(root, p)
                        Ex.FireTouch(p, root)
                    end)
                end
                break
            end
        end
    end
end)

-- hız / zıplama
U.Loop(0.3, function()
    local h = U.Hum()
    if not h then return end
    if Cfg.Speed then h.WalkSpeed = Cfg.SpeedVal else h.WalkSpeed = 16 end
    if Cfg.Jump then
        h.UseJumpPower = true
        h.JumpPower = Cfg.JumpVal
    else
        h.UseJumpPower = true
        h.JumpPower = 50
    end
end)

-- sonsuz zıplama
U.Conn(UserInputService.JumpRequest, function()
    if Cfg.InfJump then
        local h = U.Hum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- noclip
U.Conn(RunService.Stepped, function()
    if Cfg.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
            end
        end
    end
end)

-- su üstünde yürü
Misc.WaterPart = nil
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
U.Loop(0.1, function()
    if not Cfg.WalkWater then
        if Misc.WaterPart then pcall(function() Misc.WaterPart:Destroy() end) Misc.WaterPart = nil end
        return
    end
    local root = U.Root()
    if not root then return end
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Misc.WaterPart}
    local hit = Workspace:Raycast(root.Position, V3(0, -12, 0), rayParams)
    if hit and hit.Material == Enum.Material.Water then
        if not Misc.WaterPart then
            Misc.WaterPart = New("Part", {Name = "MH_Water", Size = V3(8, 1, 8), Transparency = 1,
                CanCollide = true, Anchored = true}, Workspace)
        end
        Misc.WaterPart.Position = root.Position - V3(0, 3.4, 0)
    end
end)

-- ışık ayarları
local OrigLight = {Bright = Lighting.Brightness, Time = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd, Shadows = Lighting.GlobalShadows}
local fpsDone = false
U.Loop(1, function()
    if Cfg.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    elseif Cfg.NoFog then
        Lighting.FogEnd = 100000
        Lighting.Brightness = OrigLight.Bright
        Lighting.ClockTime = OrigLight.Time
    else
        Lighting.Brightness = OrigLight.Bright
        Lighting.ClockTime = OrigLight.Time
        Lighting.FogEnd = OrigLight.FogEnd
    end
    if Cfg.FpsBoost then
        Lighting.GlobalShadows = false
        if not fpsDone then
            fpsDone = true
            pcall(function()
                for _, d in ipairs(Workspace:GetDescendants()) do
                    if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam")
                        or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then
                        d.Enabled = false
                    end
                end
            end)
        end
    else
        fpsDone = false
        Lighting.GlobalShadows = OrigLight.Shadows
    end
end)

-- deniz geçiş hatırlatması
local seaWarned = false
U.Loop(5, function()
    if not seaWarned then
        local l = U.Level()
        if (Sea == 1 and l >= 700) or (Sea == 2 and l >= 1500) then
            seaWarned = true
            U.Notify("Dikkat", "Levelin yeterli — gemiyle bir sonraki denize geçebilirsin!")
        end
    end
end)

-- kapanış temizliği
function U.Shutdown()
    pcall(function() genv.MorganHubRunId = nil end)
    Farm.ClearHitbox()
    Farm.ClearAnchors()
    pcall(function()
        Lighting.Brightness = OrigLight.Bright
        Lighting.ClockTime = OrigLight.Time
        Lighting.FogEnd = OrigLight.FogEnd
        Lighting.GlobalShadows = OrigLight.Shadows
    end)
    for _, c in ipairs(U.Conns) do pcall(function() c:Disconnect() end) end
    if UI.Gui then pcall(function() UI.Gui:Destroy() end) end
end

-- ============================== SEKMELER ==============================
local Win = UI.CreateWindow("MORGAN HUB", "Blox Fruits • V4 GLASS ⚡")

local Home   = Win:CreateTab("Home", "🏠")
local FarmT  = Win:CreateTab("Farm", "🌾")
local Atk    = Win:CreateTab("Attack", "⚔️")
local Vis    = Win:CreateTab("Visual", "🎨")
local PlayT  = Win:CreateTab("Player", "🏃")
local SetT   = Win:CreateTab("Settings", "⚙️")

-- HOME
Home:Section("Ana Kontroller")
local bigFarm = Home:BigToggle("AUTO FARM", "Quest alır → mobları avlar → ölsen bile devam", Cfg.AutoFarm,
    function(v)
        Cfg.AutoFarm = v
        U.Notify("Auto Farm", v and "Açıldı 🔥" or "Kapatıldı")
    end, Color3.fromRGB(120, 60, 240), Color3.fromRGB(60, 180, 255))
local bigAtk = Home:BigToggle("FAST ATTACK", "Redz tarzı hızlı saldırı — ayarlar Attack sekmesinde", Cfg.FastAttack,
    function(v) Cfg.FastAttack = v end, Color3.fromRGB(255, 80, 100), Color3.fromRGB(255, 170, 60))

Home:Section("Durum")
local stats = Home:StatRow({"LEVEL", "SEA", "MOB", "DURUM"})
U.Loop(1, function()
    stats.Set(1, U.Level())
    stats.Set(2, Sea)
    stats.Set(3, (Farm.Target and Farm.Target.name) or "-")
    stats.Set(4, Farm.Status)
    bigFarm.SetStatus("Lv " .. U.Level() .. " • " .. Farm.Status)
    if UI.ProfileSub then UI.ProfileSub.Text = "Lv " .. U.Level() .. " • Sea " .. Sea end
end)

-- FARM
FarmT:Section("Auto Farm")
FarmT:Toggle("Quest Kullan", Cfg.UseQuest, function(v) Cfg.UseQuest = v end)
FarmT:Dropdown("Farm Yöntemi", {"Hybrid (Önerilen)", "Tween (Güvenli)", "Bring (Hızlı)"}, Cfg.Method,
    function(v) Cfg.Method = v end)
FarmT:Slider("Uçuş Yüksekliği", 5, 40, Cfg.FarmHeight, 0, function(v) Cfg.FarmHeight = v end)
FarmT:Slider("Tween Hızı", 50, 400, Cfg.TweenSpeed, 0, function(v) Cfg.TweenSpeed = v end)
FarmT:Slider("Bring Menzili", 50, 250, Cfg.BringRadius, 0, function(v) Cfg.BringRadius = v end)
FarmT:Toggle("Çekilen Mobları Sabitle", Cfg.AnchorMobs, function(v)
    Cfg.AnchorMobs = v
    if not v then Farm.ClearAnchors() end
end)
FarmT:Note("Bring menzilini 150'nin altında tut kanka. Uzaktan çekilen mob server gözünde eski yerinde kalır → hasar YOK. Script önce spawn'a yaklaşır (ownership alır), sonra çeker.")

FarmT:Section("Manuel Mob")
FarmT:Toggle("Seçili Mob'u Avla", Cfg.FarmMob, function(v) Cfg.FarmMob = v end)
FarmT:Dropdown("Mob Seç", Data.MobList, Cfg.SelectedMob ~= "" and Cfg.SelectedMob or Data.MobList[1],
    function(v) Cfg.SelectedMob = v end)

FarmT:Section("Hitbox")
FarmT:Toggle("Mob Hitbox Büyüt", Cfg.Hitbox, function(v)
    Cfg.Hitbox = v
    if not v then Farm.ClearHitbox() end
end)
FarmT:Slider("Hitbox Boyutu", 20, 60, Cfg.HitboxSize, 0, function(v) Cfg.HitboxSize = v end)

FarmT:Section("Meyve & Sandık")
FarmT:Toggle("Auto Meyve Topla", Cfg.AutoCollectFruit, function(v) Cfg.AutoCollectFruit = v end)
FarmT:Toggle("Meyve Bildirimi", Cfg.FruitNotify, function(v) Cfg.FruitNotify = v end)
FarmT:Toggle("Auto Sandık", Cfg.AutoChest, function(v) Cfg.AutoChest = v end)

FarmT:Section("Diğer")
FarmT:Toggle("Auto Buso Haki", Cfg.AutoBuso, function(v) Cfg.AutoBuso = v end)
FarmT:Toggle("Auto Stat Dağıt", Cfg.StatOn, function(v) Cfg.StatOn = v end)
FarmT:Dropdown("Stat Tipi", {"Melee", "Defense", "Sword", "Gun", "Devil Fruit"}, Cfg.StatType,
    function(v) Cfg.StatType = v end)
FarmT:Slider("Stat Miktarı", 1, 10, Cfg.StatAmount, 0, function(v) Cfg.StatAmount = v end)
FarmT:Toggle("Hedef Levelda Dur", Cfg.StopAtTarget, function(v) Cfg.StopAtTarget = v end)
FarmT:Slider("Hedef Level", 100, 3000, Cfg.TargetLevel, 0, function(v) Cfg.TargetLevel = v end)

-- ATTACK
Atk:Section("Fast Attack — Redz Tarzı")
Atk:Slider("Saldırı Hızı (sn)", 0.05, 1, Cfg.AttackSpeed, 2, function(v) Cfg.AttackSpeed = v end)
Atk:Dropdown("Tıklama Metodu", {"VirtualInputManager (Redz)", "VirtualUser", "Tool Activate", "FireSignal Bypass"},
    Cfg.ClickMethod, function(v) Cfg.ClickMethod = v end)
Atk:Toggle("Super Attack (Hepsi Birlikte)", Cfg.SuperAttack, function(v) Cfg.SuperAttack = v end)
Atk:Toggle("Farm Kapalıyken de Saldır", Cfg.AttackAlways, function(v) Cfg.AttackAlways = v end)
Atk:Note("Saldırmıyorsa: 1) Auto Kuşan'ı aç 2) Metodu FireSignal Bypass'a çevir 3) Hızı 0.3 yap. Bir metod her executor'da farklı çalışır, hepsi denendi.")

Atk:Section("Silah")
Atk:Toggle("Auto Kuşan", Cfg.AutoEquip, function(v) Cfg.AutoEquip = v end)
Atk:Dropdown("Silah Tipi", {"Melee (Combat)", "En İyi Kılıç"}, Cfg.WeaponType, function(v) Cfg.WeaponType = v end)

Atk:Section("Skiller")
Atk:Toggle("Auto Skills (Z X C V)", Cfg.AutoSkills, function(v) Cfg.AutoSkills = v end)

-- VISUAL
Vis:Section("Tema")
Vis:Dropdown("Tema", UI.ThemeNames, Cfg.Theme, function(v) UI.SetTheme(v) end)
Vis:Toggle("Parçacıklar (Yağmur vb.)", Cfg.Rain, function(v) Cfg.Rain = v end)
Vis:Button("🎲 Rastgele Tema", function()
    local n = UI.ThemeNames[math.random(#UI.ThemeNames)]
    UI.SetTheme(n)
    U.Notify("Tema", "Rastgele: " .. n)
end)
Vis:Toggle("45 sn'de Bir Rastgele Tema", Cfg.AutoRandomTheme, function(v) Cfg.AutoRandomTheme = v end)
U.Loop(45, function()
    if Cfg.AutoRandomTheme then
        UI.SetTheme(UI.ThemeNames[math.random(#UI.ThemeNames)])
    end
end)

Vis:Section("Şeffaflık & Görüntü")
Vis:Slider("Cam Şeffaflığı (%)", 15, 90, math.floor((Cfg.GlassT or 0.25) * 100), 0,
    function(v) UI.SetGlass(v) end)
Vis:Toggle("Fullbright", Cfg.Fullbright, function(v) Cfg.Fullbright = v end)
Vis:Toggle("Sis Kaldır", Cfg.NoFog, function(v) Cfg.NoFog = v end)
Vis:Toggle("FPS Boost", Cfg.FpsBoost, function(v) Cfg.FpsBoost = v end)

Vis:Section("ESP")
Vis:Toggle("Oyuncu ESP", Cfg.ESPPlayer, function(v) Cfg.ESPPlayer = v end)
Vis:Toggle("Mob ESP", Cfg.ESPMob, function(v) Cfg.ESPMob = v end)
Vis:Toggle("Meyve ESP", Cfg.ESPFruit, function(v) Cfg.ESPFruit = v end)
Vis:Toggle("Sandık ESP", Cfg.ESPChest, function(v) Cfg.ESPChest = v end)

Vis:Section("Eğlence 🍀")
Vis:Button("🍀 Şansına Bak", function()
    local n = math.random(1, 100)
    U.Notify("Şansın", n >= 90 and "🔥 " .. n .. "/100 — Kitsune kokusu alıyorum!" or n .. "/100")
end)

-- PLAYER
PlayT:Section("Hareket")
PlayT:Toggle("Hız", Cfg.Speed, function(v) Cfg.Speed = v end)
PlayT:Slider("Hız Değeri", 20, 300, Cfg.SpeedVal, 0, function(v) Cfg.SpeedVal = v end)
PlayT:Toggle("Zıplama", Cfg.Jump, function(v) Cfg.Jump = v end)
PlayT:Slider("Zıplama Değeri", 50, 300, Cfg.JumpVal, 0, function(v) Cfg.JumpVal = v end)
PlayT:Toggle("Sonsuz Zıplama", Cfg.InfJump, function(v) Cfg.InfJump = v end)
PlayT:Toggle("Su Üstünde Yürü", Cfg.WalkWater, function(v) Cfg.WalkWater = v end)
PlayT:Toggle("Noclip", Cfg.Noclip, function(v) Cfg.Noclip = v end)

-- SETTINGS
SetT:Section("Arayüz")
SetT:Slider("UI Boyutu (%)", 70, 130, math.floor(Cfg.UIScale * 100), 0, function(v)
    Cfg.UIScale = v / 100
    if UI.Scale then UI.Scale.Scale = Cfg.UIScale end
end)
SetT:Section("Webhook")
SetT:TextBox("Discord Webhook", "https://discord.com/api/webhooks/...", Cfg.WebhookURL,
    function(t) Cfg.WebhookURL = t end)
SetT:Toggle("Meyve Bulununca Webhook'a At", Cfg.WhFruit, function(v) Cfg.WhFruit = v end)
SetT:Section("Config")
SetT:Button("💾 Kaydet", Misc.Save)
SetT:Button("🗑 Config Sil", function()
    pcall(function() if isfile then delfile("MorganHubV4.json") end end)
    U.Notify("Config", "Silindi, scripti tekrar çalıştırınca sıfırdan başlar")
end)
SetT:Button("🔄 Sunucuya Yeniden Katıl", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)
SetT:Note("Kapat (X) basarsan config otomatik kaydedilir ve her şey temizlenir.")

-- başlangıç
UI.SetTheme(Cfg.Theme)
UI.SetGlass(math.floor((Cfg.GlassT or 0.25) * 100))
U.Notify("Morgan Hub V4", "Yüklendi ⚡ Tema: " .. Cfg.Theme)

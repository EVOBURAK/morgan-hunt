-- =================================================================================
-- 🔮 MORGAN HUB V10.0 (20x MEGA FUN & TWEEN FRUITS & UPDATE 30 EDITION) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Orion Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "💎 Morgan Hub V10.0 | Blox Fruits Ultimate",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MorganHubV10"
})

-- Blox Fruits Uzak İletişimler
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local CommF_ = Remotes and Remotes:WaitForChild("CommF_", 10)
local Net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
local RegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = Net and Net:FindFirstChild("RE/RegisterHit")

-- Ayarlar
local Settings = {
    AutoFarm = false,
    FarmDistance = 9,
    FastAttack = true,
    BringMobs = true,
    AutoBuso = true,
    WaitAtSpawn = true,
    -- Meyve Avcısı
    TweenFruits = false,
    FruitTweenSpeed = 240,
    -- Update 30 Magnet
    MagnetTokenFarm = false,
    -- Raids
    AutoRaid = false,
    SelectedRaid = "Flame",
    AutoNextIsland = true,
    AutoPirateRaid = false,
    -- 20x FUN & TROLL AYARLARI
    RainbowCharacter = false,
    GhostMode = false,
    FullBright = false,
    MoonGravity = false,
    AirSwim = false,
    RagdollSelf = false,
    CameraFOV = 70,
    NoCameraShake = false,
    SuperJump = false,
    SoruSpam = false,
    GiantHitbox = false,
    PotatoFPS = false,
    HeadSpasm = false,
    ManualNoclip = false,
    OrbitPlayer = false,
    OrbitSpeed = 15,
    RainbowHaki = false,
    InfiniteDash = false,
    Moonwalk = false,
    TrailEffects = false,
    -- Klasikler
    InfiniteJump = false,
    WaterWalk = false,
    SpinBot = false,
    SpinSpeed = 25,
    ClickTP = false,
    WalkSpeedBoost = 16,
    -- Misc
    AutoStore = true,
    AutoStats = false,
    StatTarget = "Melee",
    AutoChest = false,
    PlayerESP = false,
    FruitESP = false,
    WebhookURL = ""
}

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end)

-- =============================================================
-- 📜 QUEST VE SPAWN VERİLERİ
-- =============================================================
local QuestGivers = {
    ["BanditQuest1"] = "Bandit Quest Giver", ["JungleQuest"] = "Adventurer",
    ["BuggyQuest1"] = "Pirate Adventurer", ["DesertQuest"] = "Desert Adventurer",
    ["SnowQuest"] = "Villager", ["MarineQuest2"] = "Marine", ["SkyQuest"] = "Sky Adventurer",
    ["PrisonerQuest"] = "Jail Keeper", ["ImpelQuest"] = "Head Jailer", ["ColosseumQuest"] = "Colosseum Quest Giver",
    ["MagmaQuest"] = "The Mayor", ["FishmanQuest"] = "King Neptune", ["SkyExp1Quest"] = "Mole",
    ["SkyExp2Quest"] = "Sky Quest Giver 2", ["FountainQuest"] = "Freezeburg Quest Giver",
    ["Area1Quest"] = "Area 1 Quest Giver", ["Area2Quest"] = "Area 2 Quest Giver",
    ["MarineQuest3"] = "Marine Quest Giver", ["ZombieQuest"] = "Graveyard Quest Giver",
    ["SnowMountainQuest"] = "Snow Quest Giver", ["IceSideQuest"] = "Ice Quest Giver",
    ["FireSideQuest"] = "Fire Quest Giver", ["ShipQuest1"] = "Rear Crew Quest Giver",
    ["ShipQuest2"] = "Front Crew Quest Giver", ["FrostQuest"] = "Frost Quest Giver",
    ["ForgottenQuest"] = "Forgotten Quest Giver", ["PiratePortQuest"] = "Pirate Port Quest Giver",
    ["VenomCrewQuest"] = "Hydra Town Quest Giver", ["MarineTreeIsland"] = "Marine Tree Quest Giver",
    ["DeepForestIsland"] = "Deep Forest Quest Giver", ["DeepForestIsland2"] = "Deep Forest Area 2 Quest Giver",
    ["DeepForestIsland3"] = "Turtle Adventure Quest Giver", ["HauntedQuest1"] = "Haunted Castle Quest Giver 1",
    ["HauntedQuest2"] = "Haunted Castle Quest Giver 2", ["NutsIslandQuest"] = "Peanut Quest Giver",
    ["IceCreamIslandQuest"] = "Ice Cream Quest Giver", ["CakeQuest1"] = "Cake Quest Giver 1",
    ["CakeQuest2"] = "Cake Quest Giver 2", ["ChocQuest1"] = "Chocolate Quest Giver 1",
    ["ChocQuest2"] = "Chocolate Quest Giver 2", ["CandyQuest1"] = "Candy Cane Quest Giver",
    ["TikiQuest1"] = "Tiki Quest Giver 1", ["TikiQuest2"] = "Tiki Quest Giver 2", ["TikiQuest3"] = "Tiki Quest Giver 3"
}

local QuestData = {
    {LevelReq = 0, QuestName = "BanditQuest1", QuestIndex = 1, MobName = "Bandit"},
    {LevelReq = 10, QuestName = "JungleQuest", QuestIndex = 1, MobName = "Monkey"},
    {LevelReq = 15, QuestName = "JungleQuest", QuestIndex = 2, MobName = "Gorilla"},
    {LevelReq = 20, QuestName = "JungleQuest", QuestIndex = 3, MobName = "The Gorilla King"},
    {LevelReq = 30, QuestName = "BuggyQuest1", QuestIndex = 1, MobName = "Pirate"},
    {LevelReq = 40, QuestName = "BuggyQuest1", QuestIndex = 2, MobName = "Brute"},
    {LevelReq = 55, QuestName = "BuggyQuest1", QuestIndex = 3, MobName = "Bobby"},
    {LevelReq = 60, QuestName = "DesertQuest", QuestIndex = 1, MobName = "Desert Bandit"},
    {LevelReq = 75, QuestName = "DesertQuest", QuestIndex = 2, MobName = "Desert Officer"},
    {LevelReq = 90, QuestName = "SnowQuest", QuestIndex = 1, MobName = "Snow Bandit"},
    {LevelReq = 100, QuestName = "SnowQuest", QuestIndex = 2, MobName = "Snowman"},
    {LevelReq = 105, QuestName = "SnowQuest", QuestIndex = 3, MobName = "Yeti"},
    {LevelReq = 120, QuestName = "MarineQuest2", QuestIndex = 1, MobName = "Chief Petty Officer"},
    {LevelReq = 130, QuestName = "MarineQuest2", QuestIndex = 2, MobName = "Vice Admiral"},
    {LevelReq = 150, QuestName = "SkyQuest", QuestIndex = 1, MobName = "Sky Bandit"},
    {LevelReq = 175, QuestName = "SkyQuest", QuestIndex = 2, MobName = "Dark Master"},
    {LevelReq = 190, QuestName = "PrisonerQuest", QuestIndex = 1, MobName = "Prisoner"},
    {LevelReq = 210, QuestName = "PrisonerQuest", QuestIndex = 2, MobName = "Dangerous Prisoner"},
    {LevelReq = 220, QuestName = "ImpelQuest", QuestIndex = 1, MobName = "Warden"},
    {LevelReq = 230, QuestName = "ImpelQuest", QuestIndex = 2, MobName = "Chief Warden"},
    {LevelReq = 240, QuestName = "ImpelQuest", QuestIndex = 3, MobName = "Swan"},
    {LevelReq = 250, QuestName = "ColosseumQuest", QuestIndex = 1, MobName = "Toga Warrior"},
    {LevelReq = 275, QuestName = "ColosseumQuest", QuestIndex = 2, MobName = "Gladiator"},
    {LevelReq = 300, QuestName = "MagmaQuest", QuestIndex = 1, MobName = "Military Soldier"},
    {LevelReq = 325, QuestName = "MagmaQuest", QuestIndex = 2, MobName = "Military Spy"},
    {LevelReq = 350, QuestName = "MagmaQuest", QuestIndex = 3, MobName = "Magma Admiral"},
    {LevelReq = 375, QuestName = "FishmanQuest", QuestIndex = 1, MobName = "Fishman Warrior"},
    {LevelReq = 400, QuestName = "FishmanQuest", QuestIndex = 2, MobName = "Fishman Commando"},
    {LevelReq = 425, QuestName = "FishmanQuest", QuestIndex = 3, MobName = "Fishman Lord"},
    {LevelReq = 450, QuestName = "SkyExp1Quest", QuestIndex = 1, MobName = "God's Guard"},
    {LevelReq = 475, QuestName = "SkyExp1Quest", QuestIndex = 2, MobName = "Shanda"},
    {LevelReq = 500, QuestName = "SkyExp1Quest", QuestIndex = 3, MobName = "Wysper"},
    {LevelReq = 525, QuestName = "SkyExp2Quest", QuestIndex = 1, MobName = "Royal Squad"},
    {LevelReq = 550, QuestName = "SkyExp2Quest", QuestIndex = 2, MobName = "Royal Soldier"},
    {LevelReq = 575, QuestName = "SkyExp2Quest", QuestIndex = 3, MobName = "Thunder God"},
    {LevelReq = 625, QuestName = "FountainQuest", QuestIndex = 1, MobName = "Galley Pirate"},
    {LevelReq = 650, QuestName = "FountainQuest", QuestIndex = 2, MobName = "Galley Captain"},
    {LevelReq = 675, QuestName = "FountainQuest", QuestIndex = 3, MobName = "Cyborg"},
    {LevelReq = 700, QuestName = "Area1Quest", QuestIndex = 1, MobName = "Raider"},
    {LevelReq = 725, QuestName = "Area1Quest", QuestIndex = 2, MobName = "Mercenary"},
    {LevelReq = 750, QuestName = "Area1Quest", QuestIndex = 3, MobName = "Diamond"},
    {LevelReq = 775, QuestName = "Area2Quest", QuestIndex = 1, MobName = "Swan Pirate"},
    {LevelReq = 800, QuestName = "Area2Quest", QuestIndex = 2, MobName = "Factory Staff"},
    {LevelReq = 850, QuestName = "Area2Quest", QuestIndex = 3, MobName = "Jeremy"},
    {LevelReq = 875, QuestName = "MarineQuest3", QuestIndex = 1, MobName = "Marine Lieutenant"},
    {LevelReq = 900, QuestName = "MarineQuest3", QuestIndex = 2, MobName = "Marine Captain"},
    {LevelReq = 925, QuestName = "MarineQuest3", QuestIndex = 3, MobName = "Fajita"},
    {LevelReq = 950, QuestName = "ZombieQuest", QuestIndex = 1, MobName = "Zombie"},
    {LevelReq = 975, QuestName = "ZombieQuest", QuestIndex = 2, MobName = "Vampire"},
    {LevelReq = 1000, QuestName = "SnowMountainQuest", QuestIndex = 1, MobName = "Snow Trooper"},
    {LevelReq = 1050, QuestName = "SnowMountainQuest", QuestIndex = 2, MobName = "Winter Warrior"},
    {LevelReq = 1100, QuestName = "IceSideQuest", QuestIndex = 1, MobName = "Lab Subordinate"},
    {LevelReq = 1125, QuestName = "IceSideQuest", QuestIndex = 2, MobName = "Horned Warrior"},
    {LevelReq = 1150, QuestName = "IceSideQuest", QuestIndex = 3, MobName = "Smoke Admiral"},
    {LevelReq = 1175, QuestName = "FireSideQuest", QuestIndex = 1, MobName = "Magma Ninja"},
    {LevelReq = 1200, QuestName = "FireSideQuest", QuestIndex = 2, MobName = "Lava Pirate"},
    {LevelReq = 1250, QuestName = "ShipQuest1", QuestIndex = 1, MobName = "Ship Deckhand"},
    {LevelReq = 1275, QuestName = "ShipQuest1", QuestIndex = 2, MobName = "Ship Engineer"},
    {LevelReq = 1300, QuestName = "ShipQuest2", QuestIndex = 1, MobName = "Ship Steward"},
    {LevelReq = 1325, QuestName = "ShipQuest2", QuestIndex = 2, MobName = "Ship Officer"},
    {LevelReq = 1350, QuestName = "FrostQuest", QuestIndex = 1, MobName = "Arctic Warrior"},
    {LevelReq = 1375, QuestName = "FrostQuest", QuestIndex = 2, MobName = "Snow Lurker"},
    {LevelReq = 1400, QuestName = "FrostQuest", QuestIndex = 3, MobName = "Awakened Ice Admiral"},
    {LevelReq = 1425, QuestName = "ForgottenQuest", QuestIndex = 1, MobName = "Sea Soldier"},
    {LevelReq = 1450, QuestName = "ForgottenQuest", QuestIndex = 2, MobName = "Water Fighter"},
    {LevelReq = 1475, QuestName = "ForgottenQuest", QuestIndex = 3, MobName = "Tide Keeper"},
    {LevelReq = 1500, QuestName = "PiratePortQuest", QuestIndex = 1, MobName = "Pirate Millionaire"},
    {LevelReq = 1525, QuestName = "PiratePortQuest", QuestIndex = 2, MobName = "Pistol Billionaire"},
    {LevelReq = 1550, QuestName = "PiratePortQuest", QuestIndex = 3, MobName = "Stone"},
    {LevelReq = 1575, QuestName = "DragonCrewQuest", QuestIndex = 1, MobName = "Dragon Crew Warrior"},
    {LevelReq = 1600, QuestName = "DragonCrewQuest", QuestIndex = 2, MobName = "Dragon Crew Archer"},
    {LevelReq = 1625, QuestName = "VenomCrewQuest", QuestIndex = 1, MobName = "Hydra Enforcer"},
    {LevelReq = 1650, QuestName = "VenomCrewQuest", QuestIndex = 2, MobName = "Venomous Assailant"},
    {LevelReq = 1675, QuestName = "VenomCrewQuest", QuestIndex = 3, MobName = "Hydra Leader"},
    {LevelReq = 1700, QuestName = "MarineTreeIsland", QuestIndex = 1, MobName = "Marine Commodore"},
    {LevelReq = 1725, QuestName = "MarineTreeIsland", QuestIndex = 2, MobName = "Marine Rear Admiral"},
    {LevelReq = 1750, QuestName = "MarineTreeIsland", QuestIndex = 3, MobName = "Kilo Admiral"},
    {LevelReq = 1775, QuestName = "DeepForestIsland3", QuestIndex = 1, MobName = "Fishman Raider"},
    {LevelReq = 1800, QuestName = "DeepForestIsland3", QuestIndex = 2, MobName = "Fishman Captain"},
    {LevelReq = 1825, QuestName = "DeepForestIsland", QuestIndex = 1, MobName = "Forest Pirate"},
    {LevelReq = 1850, QuestName = "DeepForestIsland", QuestIndex = 2, MobName = "Mythological Pirate"},
    {LevelReq = 1875, QuestName = "DeepForestIsland", QuestIndex = 3, MobName = "Captain Elephant"},
    {LevelReq = 1900, QuestName = "DeepForestIsland2", QuestIndex = 1, MobName = "Jungle Pirate"},
    {LevelReq = 1925, QuestName = "DeepForestIsland2", QuestIndex = 2, MobName = "Musketeer Pirate"},
    {LevelReq = 1950, QuestName = "DeepForestIsland2", QuestIndex = 3, MobName = "Beautiful Pirate"},
    {LevelReq = 1975, QuestName = "HauntedQuest1", QuestIndex = 1, MobName = "Reborn Skeleton"},
    {LevelReq = 2000, QuestName = "HauntedQuest1", QuestIndex = 2, MobName = "Living Zombie"},
    {LevelReq = 2025, QuestName = "HauntedQuest2", QuestIndex = 1, MobName = "Demonic Soul"},
    {LevelReq = 2050, QuestName = "HauntedQuest2", QuestIndex = 2, MobName = "Posessed Mummy"},
    {LevelReq = 2075, QuestName = "NutsIslandQuest", QuestIndex = 1, MobName = "Peanut Scout"},
    {LevelReq = 2100, QuestName = "NutsIslandQuest", QuestIndex = 2, MobName = "Peanut President"},
    {LevelReq = 2125, QuestName = "IceCreamIslandQuest", QuestIndex = 1, MobName = "Ice Cream Chef"},
    {LevelReq = 2150, QuestName = "IceCreamIslandQuest", QuestIndex = 2, MobName = "Ice Cream Commander"},
    {LevelReq = 2175, QuestName = "IceCreamIslandQuest", QuestIndex = 3, MobName = "Cake Queen"},
    {LevelReq = 2200, QuestName = "CakeQuest1", QuestIndex = 1, MobName = "Cookie Crafter"},
    {LevelReq = 2225, QuestName = "CakeQuest1", QuestIndex = 2, MobName = "Cake Guard"},
    {LevelReq = 2250, QuestName = "CakeQuest2", QuestIndex = 1, MobName = "Baking Staff"},
    {LevelReq = 2275, QuestName = "CakeQuest2", QuestIndex = 2, MobName = "Head Baker"},
    {LevelReq = 2300, QuestName = "ChocQuest1", QuestIndex = 1, MobName = "Cocoa Warrior"},
    {LevelReq = 2325, QuestName = "ChocQuest1", QuestIndex = 2, MobName = "Chocolate Bar Battler"},
    {LevelReq = 2350, QuestName = "ChocQuest2", QuestIndex = 1, MobName = "Sweet Thief"},
    {LevelReq = 2375, QuestName = "ChocQuest2", QuestIndex = 2, MobName = "Candy Rebel"},
    {LevelReq = 2400, QuestName = "CandyQuest1", QuestIndex = 1, MobName = "Candy Pirate"},
    {LevelReq = 2425, QuestName = "CandyQuest1", QuestIndex = 2, MobName = "Snow Demon"},
    {LevelReq = 2450, QuestName = "TikiQuest1", QuestIndex = 1, MobName = "Isle Outlaw"},
    {LevelReq = 2475, QuestName = "TikiQuest1", QuestIndex = 2, MobName = "Island Boy"},
    {LevelReq = 2500, QuestName = "TikiQuest2", QuestIndex = 1, MobName = "Sun-kissed Warrior"},
    {LevelReq = 2525, QuestName = "TikiQuest2", QuestIndex = 2, MobName = "Isle Champion"},
    {LevelReq = 2550, QuestName = "TikiQuest3", QuestIndex = 1, MobName = "Serpent Hunter"},
    {LevelReq = 2575, QuestName = "TikiQuest3", QuestIndex = 2, MobName = "Skull Slayer"}
}

local function CleanMobName(name)
    return name:gsub(" %b[]", ""):gsub(" %pLv%. %d+%p", ""):gsub(" %pBoss%p", ""):gsub("^%s*(.-)%s*$", "%1")
end

local function GetCurrentLevel()
    local data = LocalPlayer:FindFirstChild("Data")
    local level = data and data:FindFirstChild("Level")
    return level and level.Value or 1
end

local function GetBestQuest()
    local myLvl = GetCurrentLevel()
    local best = QuestData[1]
    for _, q in ipairs(QuestData) do
        if myLvl >= q.LevelReq then
            best = q
        else
            break
        end
    end
    return best
end

local function HasQuest()
    local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
    local questFrame = mainGui and mainGui:FindFirstChild("Quest")
    return questFrame and questFrame.Visible == true
end

-- =============================================================
-- 🚀 PÜRÜZSÜZ DUVARLARDAN GEÇEN TWEEN HAREKET SİSTEMİ
-- =============================================================
local BodyVelocity = nil

local function EnableNoclip()
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

local function TweenToPosition(targetPos, speed)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end

    speed = speed or 240
    EnableNoclip()
    hum.PlatformStand = true

    if not BodyVelocity or BodyVelocity.Parent ~= root then
        if BodyVelocity then BodyVelocity:Destroy() end
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyVelocity.Velocity = Vector3.zero
        BodyVelocity.Parent = root
    end

    local distance = (targetPos - root.Position).Magnitude
    if distance < 10 then
        root.CFrame = CFrame.new(targetPos)
        BodyVelocity.Velocity = Vector3.zero
        return
    end

    local dir = (targetPos - root.Position).Unit
    BodyVelocity.Velocity = dir * speed
    root.CFrame = CFrame.lookAt(root.Position, root.Position + dir)
end

local function StopMovement()
    if BodyVelocity then
        BodyVelocity.Velocity = Vector3.zero
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
end

-- =============================================================
-- 🍓 MEYVE AVCISI (TWEEN FRUITS & AUTO STORE)
-- =============================================================
local function GetSpawnedFruit()
    for _, item in ipairs(Workspace:GetChildren()) do
        if (item:IsA("Tool") or item:IsA("Model")) and (item.Name:find("Fruit") or item.Name:find("Meyve")) then
            local handle = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
            if handle then
                return item, handle
            end
        end
    end
    return nil, nil
end

local function StoreFruit(tool)
    if not tool or not tool:IsA("Tool") then return end
    pcall(function()
        if CommF_ then
            CommF_:InvokeServer("StoreFruit", tool.Name, tool)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.2)
        if Settings.TweenFruits then
            pcall(function()
                local fruit, handle = GetSpawnedFruit()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")

                if fruit and handle and root then
                    TweenToPosition(handle.Position, Settings.FruitTweenSpeed)
                    if (handle.Position - root.Position).Magnitude < 12 then
                        firetouchinterest(root, handle, 0)
                        firetouchinterest(root, handle, 1)
                        task.wait(0.4)
                        if Settings.AutoStore then
                            StoreFruit(fruit)
                        end
                    end
                else
                    if not Settings.AutoFarm and not Settings.AutoRaid and not Settings.MagnetTokenFarm then
                        StopMovement()
                    end
                end
            end)
        end
    end
end)

-- =============================================================
-- ⚡ FAST ATTACK & COMBAT PROTOKOLÜ
-- =============================================================
local function PerformFastAttack(targetPart)
    if not Settings.FastAttack or not targetPart then return end
    local char = LocalPlayer.Character
    if not char then return end

    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end

    if RegisterAttack and RegisterHit then
        pcall(function()
            RegisterAttack:FireServer(0)
            RegisterHit:FireServer(targetPart, {{targetPart.Parent, targetPart}})
        end)
    end

    pcall(function()
        tool:Activate()
    end)
end

local function CheckBuso()
    if not Settings.AutoBuso then return end
    local char = LocalPlayer.Character
    if char and not char:FindFirstChild("HasBuso") and CommF_ then
        pcall(function()
            CommF_:InvokeServer("Buso")
        end)
    end
end

local function EquipBestWeapon()
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") and (t.ToolTip == "Melee" or t.ToolTip == "Sword" or t.ToolTip == "Blox Fruit") then
                    char.Humanoid:EquipTool(t)
                    break
                end
            end
        end
    end
end

local function BringMobsTo(targetCFrame, mobName)
    if not Settings.BringMobs then return end
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            if CleanMobName(enemy.Name) == mobName and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                local dist = (enemy.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
                if dist <= 300 then
                    enemy.HumanoidRootPart.CFrame = targetCFrame
                    enemy.HumanoidRootPart.CanCollide = false
                    enemy.Humanoid.WalkSpeed = 0
                end
            end
        end
    end
end

-- =============================================================
-- 🌾 AUTO FARM ENGINE
-- =============================================================
local function GetQuestNPCModel(giverName)
    local npcsFolder = Workspace:FindFirstChild("NPCs")
    if npcsFolder and npcsFolder:FindFirstChild(giverName) then
        return npcsFolder:FindFirstChild(giverName)
    end
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name == giverName then
            return obj
        end
    end
    return nil
end

local function FindQuestMob(mobName)
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            if CleanMobName(enemy.Name) == mobName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                return enemy
            end
        end
    end
    return nil
end

local function GetMobSpawnCFrame(mobName)
    local spawns = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("EnemySpawns")
    if spawns and spawns:FindFirstChild(mobName) then
        return spawns[mobName].CFrame
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait()
        if Settings.AutoFarm and not Settings.AutoRaid and not Settings.MagnetTokenFarm and not Settings.TweenFruits then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
                    return
                end

                local quest = GetBestQuest()
                local giverName = QuestGivers[quest.QuestName] or ""

                if not HasQuest() then
                    local npcModel = GetQuestNPCModel(giverName)
                    local npcRoot = npcModel and (npcModel:FindFirstChild("HumanoidRootPart") or npcModel:FindFirstChildWhichIsA("BasePart"))
                    if npcRoot then
                        local dist = (npcRoot.Position - char.HumanoidRootPart.Position).Magnitude
                        if dist > 20 then
                            TweenToPosition(npcRoot.Position + Vector3.new(0, 5, 0), 320)
                        else
                            StopMovement()
                            CommF_:InvokeServer("StartQuest", quest.QuestName, quest.QuestIndex)
                            task.wait(0.5)
                        end
                    else
                        CommF_:InvokeServer("StartQuest", quest.QuestName, quest.QuestIndex)
                        task.wait(0.5)
                    end
                else
                    local mob = FindQuestMob(quest.MobName)
                    if mob and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        local mobPos = mob.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
                        TweenToPosition(mobPos, 340)
                        CheckBuso()
                        EquipBestWeapon()
                        BringMobsTo(mob.HumanoidRootPart.CFrame, quest.MobName)
                        PerformFastAttack(mob.HumanoidRootPart)
                    else
                        if Settings.WaitAtSpawn then
                            local spawnCF = GetMobSpawnCFrame(quest.MobName)
                            if spawnCF then
                                TweenToPosition(spawnCF.Position + Vector3.new(0, 20, 0), 320)
                            end
                        end
                    end
                end
            end)
        elseif not Settings.AutoRaid and not Settings.MagnetTokenFarm and not Settings.TweenFruits then
            StopMovement()
        end
    end
end)

-- =============================================================
-- 🎉 20x MEGA FUN & TROLL MOTORU
-- =============================================================

-- 1. Rainbow Karakter (RGB Avatar)
task.spawn(function()
    while true do
        task.wait(0.08)
        if Settings.RainbowCharacter then
            local char = LocalPlayer.Character
            if char then
                local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = color
                    end
                end
            end
        end
    end
end)

-- 2. Hayalet / Görünmezlik (Ghost Mode)
local function SetGhostMode(enabled)
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = enabled and 0.75 or 0
            end
        end
    end
end

-- 3. FullBright (Gece Görüşü)
local DefaultBrightness = Lighting.Brightness
local DefaultClock = Lighting.ClockTime
local DefaultShadows = Lighting.GlobalShadows

task.spawn(function()
    while true do
        task.wait(1)
        if Settings.FullBright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 1e5
            Lighting.GlobalShadows = false
        end
    end
end)

-- 4. Ay Yerçekimi (Moon Gravity)
task.spawn(function()
    while true do
        task.wait(0.5)
        if Settings.MoonGravity then
            Workspace.Gravity = 45
        else
            Workspace.Gravity = 196.2
        end
    end
end)

-- 5. Havada Yüzme (Air Swimming)
RunService.Stepped:Connect(function()
    if Settings.AirSwim then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
        end
    end
end)

-- 6. Ölü Taklidi (Ragdoll / Play Dead)
RunService.Heartbeat:Connect(function()
    if Settings.RagdollSelf then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = true
        end
    end
end)

-- 7. Kamera FOV
RunService.RenderStepped:Connect(function()
    if Settings.CameraFOV ~= 70 then
        Camera.FieldOfView = Settings.CameraFOV
    end
end)

-- 8. Ekran Sallantısı Kapatıcı (No Camera Shake)
task.spawn(function()
    while true do
        task.wait(1)
        if Settings.NoCameraShake then
            pcall(function()
                local shaker = require(ReplicatedStorage.Util.CameraShaker)
                if shaker then shaker:Stop() end
            end)
        end
    end
end)

-- 9. Süper Zıplama (Super High Jump)
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = Settings.SuperJump and 220 or 50
    end
end)

-- 10. Soru / Flash Step Spam
task.spawn(function()
    while true do
        task.wait(0.1)
        if Settings.SoruSpam and CommF_ then
            pcall(function()
                CommF_:InvokeServer("Soru")
            end)
        end
    end
end)

-- 11. Dev Mob Hitbox (Giant Hitbox)
task.spawn(function()
    while true do
        task.wait(1)
        if Settings.GiantHitbox then
            local enemies = Workspace:FindFirstChild("Enemies")
            if enemies then
                for _, enemy in ipairs(enemies:GetChildren()) do
                    local root = enemy:FindFirstChild("HumanoidRootPart")
                    if root and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        root.Size = Vector3.new(25, 25, 25)
                        root.Transparency = 0.6
                        root.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- 12. Patates Grafik (Ultra FPS Boost)
local function ActivatePotatoPC()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
    Lighting.GlobalShadows = false
    OrionLib:MakeNotification({
        Name = "FPS Boost",
        Content = "Patates grafik modu devrede!",
        Time = 3
    })
end

-- 13. Klon Heykeli Bırakma (Decoy)
local function SpawnCloneDecoy()
    local char = LocalPlayer.Character
    if char then
        char.Archivable = true
        local clone = char:Clone()
        clone.Name = "MorganDecoy"
        clone.Parent = Workspace
        for _, part in ipairs(clone:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = true
                part.Color = Color3.fromRGB(160, 60, 255)
            end
        end
        char.Archivable = false
        OrionLib:MakeNotification({
            Name = "Klon Bırakıldı",
            Content = "Taş gibi klon heykeliniz bırakıldı!",
            Time = 3
        })
    end
end

-- 14. Kafa Spazmı (Head Shake / Glitch)
RunService.RenderStepped:Connect(function()
    if Settings.HeadSpasm then
        local char = LocalPlayer.Character
        local head = char and char:FindFirstChild("Head")
        local neck = head and head:FindFirstChild("Neck")
        if neck then
            neck.C0 = neck.C0 * CFrame.Angles(math.random(-180, 180), math.random(-180, 180), math.random(-180, 180))
        end
    end
end)

-- 15. Manuel No-Clip
RunService.Stepped:Connect(function()
    if Settings.ManualNoclip then
        EnableNoclip()
    end
end)

-- 16. Oyuncu Yörüngesi (Orbit Player)
local function GetClosestPlayerOrbit()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
            if d < dist then
                dist = d
                closest = p
            end
        end
    end
    return closest
end

local orbitAngle = 0
RunService.Heartbeat:Connect(function()
    if Settings.OrbitPlayer then
        local target = GetClosestPlayerOrbit()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and myRoot then
            orbitAngle += Settings.OrbitSpeed * 0.05
            local targetPos = target.Character.HumanoidRootPart.Position
            local x = targetPos.X + math.cos(orbitAngle) * 15
            local z = targetPos.Z + math.sin(orbitAngle) * 15
            myRoot.CFrame = CFrame.lookAt(Vector3.new(x, targetPos.Y + 4, z), targetPos)
        end
    end
end)

-- 17. Gökkuşağı Haki Işıltısı (Rainbow Haki Aura)
local HakiHighlight = nil
task.spawn(function()
    while true do
        task.wait(0.08)
        if Settings.RainbowHaki then
            local char = LocalPlayer.Character
            if char then
                if not HakiHighlight or HakiHighlight.Parent ~= char then
                    if HakiHighlight then HakiHighlight:Destroy() end
                    HakiHighlight = Instance.new("Highlight")
                    HakiHighlight.FillTransparency = 0.5
                    HakiHighlight.OutlineTransparency = 0
                    HakiHighlight.Parent = char
                end
                local color = Color3.fromHSV(tick() % 4 / 4, 1, 1)
                HakiHighlight.FillColor = color
                HakiHighlight.OutlineColor = color
            end
        else
            if HakiHighlight then
                HakiHighlight:Destroy()
                HakiHighlight = nil
            end
        end
    end
end)

-- 18. Sınırsız Dash (Zero Dash CD)
task.spawn(function()
    while true do
        task.wait(0.15)
        if Settings.InfiniteDash then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:SetAttribute("DashCD", 0)
                end
            end)
        end
    end
end)

-- 19. Moonwalk (Ters Yürüme)
RunService.RenderStepped:Connect(function()
    if Settings.Moonwalk then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = CFrame.lookAt(root.Position, root.Position - hum.MoveDirection)
        end
    end
end)

-- 20. Adım İzi Işıltısı (Trail / Footstep FX)
local stepPart = nil
RunService.RenderStepped:Connect(function()
    if Settings.TrailEffects then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local p = Instance.new("Part")
            p.Size = Vector3.new(1.2, 0.2, 1.2)
            p.Position = root.Position - Vector3.new(0, 2.8, 0)
            p.Anchored = true
            p.CanCollide = false
            p.Material = Enum.Material.Neon
            p.Color = Color3.fromHSV(tick() % 3 / 3, 1, 1)
            p.Parent = Workspace
            task.delay(0.8, function()
                p:Destroy()
            end)
        end
    end
end)

-- Klasik Fun: Sonsuz Zıplama & Su Üstü & SpinBot & TP
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local WaterPlatform = Instance.new("Part")
WaterPlatform.Name = "JesusPlatform"
WaterPlatform.Size = Vector3.new(100, 1, 100)
WaterPlatform.Transparency = 1
WaterPlatform.Anchored = true
WaterPlatform.CanCollide = true
WaterPlatform.Parent = Workspace

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if Settings.WaterWalk and root then
        WaterPlatform.Position = Vector3.new(root.Position.X, 0.5, root.Position.Z)
        WaterPlatform.CanCollide = true
    else
        WaterPlatform.Position = Vector3.new(0, -500, 0)
        WaterPlatform.CanCollide = false
    end
end)

RunService.RenderStepped:Connect(function()
    if Settings.SpinBot then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
        end
    end
end)

Mouse.Button1Down:Connect(function()
    if Settings.ClickTP and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if Mouse.Target then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and Settings.WalkSpeedBoost > 16 then
        hum.WalkSpeed = Settings.WalkSpeedBoost
    end
end)

-- =============================================================
-- 🖥️ ORION ARAYÜZ SEKMELERİ
-- =============================================================

-- TAB 1: Auto Farm
local FarmTab = Window:MakeTab({
    Name = "🌾 Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

FarmTab:AddToggle({
    Name = "Auto Farm Level (Otomatik Seviye)",
    Default = false,
    Callback = function(v) Settings.AutoFarm = v end
})

FarmTab:AddToggle({
    Name = "Spawn Bekleme Noktasına Git",
    Default = true,
    Callback = function(v) Settings.WaitAtSpawn = v end
})

FarmTab:AddToggle({
    Name = "Mob Magnet (Yaratıkları Yanına Çek)",
    Default = true,
    Callback = function(v) Settings.BringMobs = v end
})

FarmTab:AddToggle({
    Name = "Ultra Fast Attack",
    Default = true,
    Callback = function(v) Settings.FastAttack = v end
})

FarmTab:AddToggle({
    Name = "Otomatik Buso Haki",
    Default = true,
    Callback = function(v) Settings.AutoBuso = v end
})

FarmTab:AddSlider({
    Name = "Mob Üstü Güvenli Mesafe",
    Min = 5,
    Max = 15,
    Default = 9,
    Increment = 1,
    ValueName = "Studs",
    Callback = function(v) Settings.FarmDistance = v end
})

-- TAB 2: Meyve Avcısı
local FruitTab = Window:MakeTab({
    Name = "🍓 Meyve Avcısı & Tween",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

FruitTab:AddToggle({
    Name = "Auto Tween Fruits (Meyvelere Duvarlardan Uç)",
    Default = false,
    Callback = function(v)
        Settings.TweenFruits = v
        if v then Settings.AutoFarm = false end
    end
})

FruitTab:AddSlider({
    Name = "Meyveye Uçuş Hızı (Orta Hız)",
    Min = 150,
    Max = 350,
    Default = 240,
    Increment = 10,
    ValueName = "Speed",
    Callback = function(v) Settings.FruitTweenSpeed = v end
})

FruitTab:AddToggle({
    Name = "Bulunan Meyveyi Otomatik Sakla",
    Default = true,
    Callback = function(v) Settings.AutoStore = v end
})

-- TAB 3: 20x MEGA FUN & TROLL SEKMESİ
local FunTab = Window:MakeTab({
    Name = "🎉 20x Fun & Troll",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

FunTab:AddSection({ Name = "🕺 Karakter Görseli & Havalı Modlar" })

FunTab:AddToggle({
    Name = "1. Rainbow Karakter (RGB Avatar)",
    Default = false,
    Callback = function(v) Settings.RainbowCharacter = v end
})

FunTab:AddToggle({
    Name = "2. Hayalet Görünmezlik (Ghost Mode)",
    Default = false,
    Callback = function(v)
        Settings.GhostMode = v
        SetGhostMode(v)
    end
})

FunTab:AddToggle({
    Name = "3. Gökkuşağı Haki Işıltısı (Rainbow Haki Glow)",
    Default = false,
    Callback = function(v) Settings.RainbowHaki = v end
})

FunTab:AddToggle({
    Name = "4. Adım İzi Neon Baloncukları (Footstep FX)",
    Default = false,
    Callback = function(v) Settings.TrailEffects = v end
})

FunTab:AddButton({
    Name = "5. Taş Klon Bırak (Decoy Statue)",
    Callback = function() SpawnCloneDecoy() end
})

FunTab:AddSection({ Name = "🌍 Dünya & Ekran Hileleri" })

FunTab:AddToggle({
    Name = "6. FullBright (Gece Görüşü / Sıfır Sis)",
    Default = false,
    Callback = function(v)
        Settings.FullBright = v
        if not v then
            Lighting.Brightness = DefaultBrightness
            Lighting.ClockTime = DefaultClock
            Lighting.GlobalShadows = DefaultShadows
        end
    end
})

FunTab:AddSlider({
    Name = "7. Kamera Görüş Açısı (FOV Changer)",
    Min = 70,
    Max = 120,
    Default = 70,
    Increment = 2,
    ValueName = "FOV",
    Callback = function(v) Settings.CameraFOV = v end
})

FunTab:AddToggle({
    Name = "8. Ekran Sallantısını Kapat (No Shake)",
    Default = false,
    Callback = function(v) Settings.NoCameraShake = v end
})

FunTab:AddButton({
    Name = "9. Patates Grafik (Ultra FPS Boost)",
    Callback = function() ActivatePotatoPC() end
})

FunTab:AddSection({ Name = "🤸 Fizik & Eğlenceli Hareketler" })

FunTab:AddToggle({
    Name = "10. Ay Yerçekimi (Moon Gravity)",
    Default = false,
    Callback = function(v) Settings.MoonGravity = v end
})

FunTab:AddToggle({
    Name = "11. Havada Yüzme Modu (Air Swim)",
    Default = false,
    Callback = function(v) Settings.AirSwim = v end
})

FunTab:AddToggle({
    Name = "12. Ölü Taklidi (Fake Ragdoll)",
    Default = false,
    Callback = function(v)
        Settings.RagdollSelf = v
        if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
    end
})

FunTab:AddToggle({
    Name = "13. Süper Yüksek Zıplama (Super Jump)",
    Default = false,
    Callback = function(v) Settings.SuperJump = v end
})

FunTab:AddToggle({
    Name = "14. Sonsuz Geppo / Zıplama (Infinite Jump)",
    Default = false,
    Callback = function(v) Settings.InfiniteJump = v end
})

FunTab:AddToggle({
    Name = "15. Su Üstünde Yürüme (Jesus Mode)",
    Default = false,
    Callback = function(v) Settings.WaterWalk = v end
})

FunTab:AddToggle({
    Name = "16. Moonwalk (Ters Yürüme)",
    Default = false,
    Callback = function(v) Settings.Moonwalk = v end
})

FunTab:AddSection({ Name = "🎯 Savaş & Trol Hileleri" })

FunTab:AddToggle({
    Name = "17. Dev Mob Hitbox (Kilometrelerce Vur)",
    Default = false,
    Callback = function(v) Settings.GiantHitbox = v end
})

FunTab:AddToggle({
    Name = "18. Soru / Flash Step Spam",
    Default = false,
    Callback = function(v) Settings.SoruSpam = v end
})

FunTab:AddToggle({
    Name = "19. Sınırsız Dash (Zero Cooldown)",
    Default = false,
    Callback = function(v) Settings.InfiniteDash = v end
})

FunTab:AddToggle({
    Name = "20. Oyuncunun Etrafında Dön (Orbit Player)",
    Default = false,
    Callback = function(v) Settings.OrbitPlayer = v end
})

FunTab:AddSlider({
    Name = "Orbit Dönüş Hızı",
    Min = 5,
    Max = 50,
    Default = 15,
    Increment = 5,
    ValueName = "Speed",
    Callback = function(v) Settings.OrbitSpeed = v end
})

FunTab:AddToggle({
    Name = "SpinBot (Beyblade Modu)",
    Default = false,
    Callback = function(v) Settings.SpinBot = v end
})

FunTab:AddToggle({
    Name = "Kafa Spazmı Glitch (Head Spasm)",
    Default = false,
    Callback = function(v) Settings.HeadSpasm = v end
})

FunTab:AddToggle({
    Name = "Duvarlardan Geçme (Manuel No-Clip)",
    Default = false,
    Callback = function(v) Settings.ManualNoclip = v end
})

FunTab:AddToggle({
    Name = "Ctrl + Sol Tık Işınlanma (Click TP)",
    Default = false,
    Callback = function(v) Settings.ClickTP = v end
})

-- TAB 4: Update 30 - Magnet Event
local MagnetTab = Window:MakeTab({
    Name = "⚡ Update 30 Magnet",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MagnetTab:AddToggle({
    Name = "Auto Magnet Token Farm ([Magnetized] Yaratıklar)",
    Default = false,
    Callback = function(v) Settings.MagnetTokenFarm = v end
})

-- TAB 5: Auto Raid
local RaidTab = Window:MakeTab({
    Name = "⚔️ Auto Raid",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

RaidTab:AddDropdown({
    Name = "Yapılacak Raid Çipi",
    Default = "Flame",
    Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand"},
    Callback = function(v) Settings.SelectedRaid = v end
})

RaidTab:AddToggle({
    Name = "Auto Raid (Çip Al + Başlat + Bitir)",
    Default = false,
    Callback = function(v) Settings.AutoRaid = v end
})

-- TAB 6: Discord Webhook
local WebhookTab = Window:MakeTab({
    Name = "📡 Discord Webhook",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

WebhookTab:AddTextbox({
    Name = "Discord Webhook URL",
    Default = "",
    TextDisappear = false,
    Callback = function(v) Settings.WebhookURL = v end
})

WebhookTab:AddButton({
    Name = "Durum Raporu Gönder (Test)",
    Callback = function()
        if Settings.WebhookURL == "" then return end
        local data = LocalPlayer:FindFirstChild("Data")
        local level = data and data:FindFirstChild("Level") and data.Level.Value or 1
        local beli = data and data:FindFirstChild("Beli") and data.Beli.Value or 0
        local frags = data and data:FindFirstChild("Fragments") and data.Fragments.Value or 0

        local payload = {
            ["username"] = "Morgan Hub Rapor",
            ["embeds"] = {{
                ["title"] = "💎 Morgan Hub - Durum Raporu",
                ["color"] = 9371903,
                ["fields"] = {
                    {["name"] = "Oyuncu", ["value"] = LocalPlayer.DisplayName, ["inline"] = true},
                    {["name"] = "Seviye", ["value"] = tostring(level), ["inline"] = true},
                    {["name"] = "Beli", ["value"] = tostring(beli), ["inline"] = true},
                    {["name"] = "Fragman", ["value"] = tostring(frags), ["inline"] = true}
                }
            }}
        }
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then
            req({
                Url = Settings.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end
    end
})

OrionLib:Init()

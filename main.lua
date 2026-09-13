-- =================================================================================
-- 🔮 MORGAN HUB V8.0 (UPDATE 30 MAGNET TOKEN & FULL AUTO RAID EDITION) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Orion Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "💎 Morgan Hub V8.0 | Blox Fruits Update 30",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MorganHubV8"
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
    -- Update 30 Magnet Event
    MagnetTokenFarm = false,
    -- Raids
    AutoRaid = false,
    SelectedRaid = "Flame",
    AutoNextIsland = true,
    -- Pirate Raid
    AutoPirateRaid = false,
    -- Misc
    AutoStore = true,
    AutoStats = false,
    StatTarget = "Melee",
    AutoChest = false,
    PlayerESP = false,
    FruitESP = false,
    WebhookURL = "",
    WebhookAutoSend = false
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
-- 🚀 PÜRÜZSÜZ HAREKET & NOCLIP SİSTEMİ
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

    speed = speed or 320
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
    if distance < 12 then
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

-- =============================================================
-- 🧲 MOB MAGNET (YARATIKLARI YANINA ÇEKME)
-- =============================================================
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
-- 📍 SPAWN BEKLEME YERİNİ BULMA (SPAWN NOKTASINDA BEKLEME)
-- =============================================================
local function GetMobSpawnCFrame(mobName)
    local spawns = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("EnemySpawns")
    if spawns and spawns:FindFirstChild(mobName) then
        return spawns[mobName].CFrame
    end
    -- Yedek olarak Location veya harita içi arama
    local locs = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("Locations")
    if locs and locs:FindFirstChild(mobName) then
        return locs[mobName].CFrame
    end
    return nil
end

-- =============================================================
-- 🌾 ANA AUTO FARM DÖNGÜSÜ
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

task.spawn(function()
    while true do
        task.wait()
        if Settings.AutoFarm and not Settings.AutoRaid and not Settings.MagnetTokenFarm and not Settings.AutoPirateRaid then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
                    return
                end

                local quest = GetBestQuest()
                local giverName = QuestGivers[quest.QuestName] or ""

                -- Görev al
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
                    -- Görev varsa yaratığı bul
                    local mob = FindQuestMob(quest.MobName)
                    if mob and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        local mobPos = mob.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
                        TweenToPosition(mobPos, 340)
                        CheckBuso()
                        EquipBestWeapon()
                        BringMobsTo(mob.HumanoidRootPart.CFrame, quest.MobName)
                        PerformFastAttack(mob.HumanoidRootPart)
                    else
                        -- Yaratık yoksa doğma noktasına uç ve bekle!
                        if Settings.WaitAtSpawn then
                            local spawnCF = GetMobSpawnCFrame(quest.MobName)
                            if spawnCF then
                                TweenToPosition(spawnCF.Position + Vector3.new(0, 20, 0), 320)
                            end
                        end
                    end
                end
            end)
        elseif not Settings.AutoRaid and not Settings.MagnetTokenFarm and not Settings.AutoPirateRaid then
            StopMovement()
        end
    end
end)

-- =============================================================
-- ⚡ UPDATE 30: MAGNET TOKEN FARM ENGINE
-- =============================================================
-- Update 30'da saat başı XX:00'da gelen 10 dk'lık Magnet Night etkinliğinde
-- [Magnetized] düşmanları bulur, yanlarına uçar, magnet token toplar.
local function FindMagnetizedEnemy()
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            local isMag = enemy.Name:find("Magnetized") or enemy.Name:find("Overcharged") or enemy:GetAttribute("Magnetized") or enemy:GetAttribute("IsMagnetized")
            if isMag and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                return enemy
            end
        end
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait()
        if Settings.MagnetTokenFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local magMob = FindMagnetizedEnemy()
                if magMob and magMob:FindFirstChild("HumanoidRootPart") then
                    local targetPos = magMob.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
                    TweenToPosition(targetPos, 350)
                    CheckBuso()
                    EquipBestWeapon()
                    PerformFastAttack(magMob.HumanoidRootPart)
                else
                    -- Magnetized düşman kalmadıysa adaları tarayacak şekilde merkezde bekle
                    local center = Vector3.new(-12463, 375, -7552)
                    TweenToPosition(center + Vector3.new(0, 60, 0), 300)
                end
            end)
        end
    end
end)

-- =============================================================
-- ⚔️ AUTO RAID ENGINE (DUNGEON / CHIP / NEXT ISLAND)
-- =============================================================
local RaidIslandNames = {"Island 1", "Island 2", "Island 3", "Island 4", "Island 5"}

local function GetCurrentRaidIsland()
    local locs = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("Locations")
    if not locs then return nil end
    for i = 5, 1, -1 do
        local isl = locs:FindFirstChild("Island " .. i)
        if isl and (isl.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 3500 then
            return isl
        end
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait()
        if Settings.AutoRaid then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                -- Raid içinde miyiz kontrol et
                local raidIsland = GetCurrentRaidIsland()
                if raidIsland then
                    -- Raid adasındaki yaratıkları bul ve kes
                    local enemies = Workspace:FindFirstChild("Enemies")
                    local foundEnemy = false
                    if enemies then
                        for _, enemy in ipairs(enemies:GetChildren()) do
                            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                                foundEnemy = true
                                local farmPos = enemy.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
                                TweenToPosition(farmPos, 340)
                                CheckBuso()
                                EquipBestWeapon()
                                PerformFastAttack(enemy.HumanoidRootPart)
                                break
                            end
                        end
                    end
                    -- Adadaki yaratıklar bittiyse sonraki adaya uç
                    if not foundEnemy and Settings.AutoNextIsland then
                        TweenToPosition(raidIsland.Position + Vector3.new(0, 70, 0), 320)
                    end
                else
                    -- Raidde değilsek çip alıp raidi başlat
                    if CommF_ then
                        CommF_:InvokeServer("RaidsNpc", "Select", Settings.SelectedRaid)
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
end)

-- =============================================================
-- 🏴‍☠️ PIRATE RAID AUTO (CASTLE ON THE SEA)
-- =============================================================
local CastlePosition = Vector3.new(-5556, 314, -2988)

task.spawn(function()
    while true do
        task.wait()
        if Settings.AutoPirateRaid then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local enemies = Workspace:FindFirstChild("Enemies")
                local pirateMob = nil

                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                            local dist = (enemy.HumanoidRootPart.Position - CastlePosition).Magnitude
                            if dist <= 750 then
                                pirateMob = enemy
                                break
                            end
                        end
                    end
                end

                if pirateMob then
                    local farmPos = pirateMob.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
                    TweenToPosition(farmPos, 350)
                    CheckBuso()
                    EquipBestWeapon()
                    PerformFastAttack(pirateMob.HumanoidRootPart)
                else
                    -- Kale etrafında hazır bekle
                    local distToCastle = (char.HumanoidRootPart.Position - CastlePosition).Magnitude
                    if distToCastle > 100 then
                        TweenToPosition(CastlePosition + Vector3.new(0, 50, 0), 320)
                    end
                end
            end)
        end
    end
end)

-- =============================================================
-- 🏝️ ADAYA IŞINLANMA LİSTESİ (ISLAND TELEPORT)
-- =============================================================
local IslandLocations = {
    -- Sea 1
    ["Starter Pirate Island"] = Vector3.new(1060, 16, 1428),
    ["Starter Marine Island"] = Vector3.new(-2570, 7, 2045),
    ["Jungle"] = Vector3.new(-1612, 37, 149),
    ["Pirate Village"] = Vector3.new(-1181, 4, 3847),
    ["Desert"] = Vector3.new(894, 7, 4390),
    ["Frozen Village"] = Vector3.new(1198, 27, -1211),
    ["Marine Fortress"] = Vector3.new(-5035, 29, 4326),
    ["Skylands"] = Vector3.new(-4839, 717, -2619),
    ["Prison"] = Vector3.new(4875, 5, 734),
    ["Colosseum"] = Vector3.new(-1427, 7, -2792),
    ["Magma Village"] = Vector3.new(-5242, 8, 8466),
    ["Underwater City"] = Vector3.new(61163, 18, 1569),
    ["Fountain City"] = Vector3.new(5127, 4, 4038),
    -- Sea 2
    ["Kingdom of Rose"] = Vector3.new(-427, 73, 1835),
    ["Green Zone"] = Vector3.new(-2441, 73, -3219),
    ["Graveyard"] = Vector3.new(-5389, 8, -474),
    ["Snow Mountain"] = Vector3.new(609, 401, -5372),
    ["Cold & Hot"] = Vector3.new(-6061, 16, -4904),
    ["Cursed Ship"] = Vector3.new(923, 126, 32852),
    ["Ice Castle"] = Vector3.new(5668, 28, -6484),
    ["Forgotten Island"] = Vector3.new(-3056, 240, -10145),
    -- Sea 3
    ["Port Town"] = Vector3.new(-290, 7, 5343),
    ["Hydra Island"] = Vector3.new(5228, 1004, 340),
    ["Great Tree"] = Vector3.new(2485, 74, -6788),
    ["Floating Turtle"] = Vector3.new(-13233, 332, -7626),
    ["Castle on the Sea"] = Vector3.new(-5085, 316, -3156),
    ["Haunted Castle"] = Vector3.new(-9515, 142, 5535),
    ["Sea of Treats"] = Vector3.new(-2087, 38, -10194),
    ["Tiki Outpost"] = Vector3.new(-16234, 9, 442)
}

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
    Name = "Auto Farm Level (Otomatik Seviye Kasma)",
    Default = false,
    Callback = function(v)
        Settings.AutoFarm = v
    end
})

FarmTab:AddToggle({
    Name = "Spawn Bekleme Noktasına Git (Yaratık Yoksa)",
    Default = true,
    Callback = function(v)
        Settings.WaitAtSpawn = v
    end
})

FarmTab:AddToggle({
    Name = "Mob Magnet (Yaratıkları Üst Üste Topla)",
    Default = true,
    Callback = function(v)
        Settings.BringMobs = v
    end
})

FarmTab:AddToggle({
    Name = "Ultra Fast Attack (Hızlı Vuruş)",
    Default = true,
    Callback = function(v)
        Settings.FastAttack = v
    end
})

FarmTab:AddToggle({
    Name = "Otomatik Buso Haki",
    Default = true,
    Callback = function(v)
        Settings.AutoBuso = v
    end
})

FarmTab:AddSlider({
    Name = "Mob Üstü Güvenli Mesafe",
    Min = 5,
    Max = 15,
    Default = 9,
    Increment = 1,
    ValueName = "Studs",
    Callback = function(v)
        Settings.FarmDistance = v
    end
})

-- TAB 2: Update 30 - Magnet Event
local MagnetTab = Window:MakeTab({
    Name = "⚡ Update 30 Magnet",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MagnetTab:AddSection({
    Name = "Magnet Event & Token Kasma"
})

MagnetTab:AddToggle({
    Name = "Auto Magnet Token Farm ([Magnetized] Yaratıklar)",
    Default = false,
    Callback = function(v)
        Settings.MagnetTokenFarm = v
        if v then
            Settings.AutoFarm = false
            Settings.AutoRaid = false
        end
    end
})

MagnetTab:AddButton({
    Name = "Middletown Zioles'e Git (Magnet Gacha Aç)",
    Callback = function()
        TweenToPosition(Vector3.new(-655, 15, 1582), 350)
    end
})

-- TAB 3: Auto Raid & Pirate Raid
local RaidTab = Window:MakeTab({
    Name = "⚔️ Raid & Pirate Raid",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

RaidTab:AddSection({
    Name = "Dungeon / Raid Sistemi"
})

RaidTab:AddDropdown({
    Name = "Yapılacak Raid Çipi",
    Default = "Flame",
    Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand"},
    Callback = function(v)
        Settings.SelectedRaid = v
    end
})

RaidTab:AddToggle({
    Name = "Auto Raid (Çip Al + Başlat + Adaları Temizle)",
    Default = false,
    Callback = function(v)
        Settings.AutoRaid = v
        if v then
            Settings.AutoFarm = false
            Settings.MagnetTokenFarm = false
        end
    end
})

RaidTab:AddToggle({
    Name = "Otomatik Sonraki Adaya Uç (Auto Next Island)",
    Default = true,
    Callback = function(v)
        Settings.AutoNextIsland = v
    end
})

RaidTab:AddSection({
    Name = "Castle Pirate Raid (3. Deniz)"
})

RaidTab:AddToggle({
    Name = "Auto Pirate Raid (Kale Korsan Baskını)",
    Default = false,
    Callback = function(v)
        Settings.AutoPirateRaid = v
        if v then
            Settings.AutoFarm = false
            Settings.AutoRaid = false
        end
    end
})

-- TAB 4: Ada Işınlanma & Portallar
local TravelTab = Window:MakeTab({
    Name = "🏝️ Adalar & Portallar",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local IslandNames = {}
for name, _ in pairs(IslandLocations) do
    table.insert(IslandNames, name)
end
table.sort(IslandNames)

local SelectedIsland = IslandNames[1]

TravelTab:AddDropdown({
    Name = "Işınlanılacak Adayı Seç",
    Default = SelectedIsland,
    Options = IslandNames,
    Callback = function(v)
        SelectedIsland = v
    end
})

TravelTab:AddButton({
    Name = "Seçilen Adaya Uç (Tween Noclip)",
    Callback = function()
        local pos = IslandLocations[SelectedIsland]
        if pos then
            TweenToPosition(pos + Vector3.new(0, 30, 0), 350)
        end
    end
})

TravelTab:AddSection({
    Name = "Deniz Geçişleri"
})

TravelTab:AddButton({
    Name = "First Sea (Sea 1)",
    Callback = function()
        CommF_:InvokeServer("TravelMain")
    end
})

TravelTab:AddButton({
    Name = "Second Sea (Sea 2)",
    Callback = function()
        CommF_:InvokeServer("TravelDressrosa")
    end
})

TravelTab:AddButton({
    Name = "Third Sea (Sea 3)",
    Callback = function()
        CommF_:InvokeServer("TravelZou")
    end
})

-- TAB 5: Otomasyon & Kodlar
local MiscTab = Window:MakeTab({
    Name = "⚙️ Otomasyon",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MiscTab:AddToggle({
    Name = "Meyveyi Sakla (Auto Store Fruit)",
    Default = true,
    Callback = function(v)
        Settings.AutoStore = v
    end
})

MiscTab:AddToggle({
    Name = "Otomatik Stat Ver",
    Default = false,
    Callback = function(v)
        Settings.AutoStats = v
    end
})

MiscTab:AddDropdown({
    Name = "Hedef Stat",
    Default = "Melee",
    Options = {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"},
    Callback = function(v)
        Settings.StatTarget = v
    end
})

MiscTab:AddToggle({
    Name = "Otomatik Sandık Topla (Para Kasma)",
    Default = false,
    Callback = function(v)
        Settings.AutoChest = v
    end
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
    Callback = function(v)
        Settings.WebhookURL = v
    end
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
                ["title"] = "💎 Morgan Hub - Durum Bilgisi",
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

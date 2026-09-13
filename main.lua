-- =================================================================================
-- 🔮 MORGAN HUB V17.0 (ULTIMATE EXPANDED EDITION - SKILLS, DOUGH KING & WAYPOINTS) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Eski GUI'yi temizle
local CoreGuiContainer = (gethui and gethui()) or game:GetService("CoreGui")
if CoreGuiContainer:FindFirstChild("MorganHubV17UI") then
    CoreGuiContainer.MorganHubV17UI:Destroy()
end

-- Blox Fruits Remotes
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local CommF_ = Remotes and Remotes:WaitForChild("CommF_", 10)
local CommE = Remotes and Remotes:WaitForChild("CommE", 10)
local Net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
local RegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = Net and Net:FindFirstChild("RE/RegisterHit")

-- =============================================================
-- ⚙️ CONFIGURATION REPOSITORY
-- =============================================================
local Config = {
    -- Auto Farm
    AutoFarm = false,
    AutoFarmNearest = false,
    FarmDistance = 9,
    FarmSpeed = 260,
    FastAttack = true,
    BringMobs = true,
    AutoBuso = true,
    AutoKen = false,
    WaitAtSpawn = true,
    -- Skills Spammer
    AutoSkillZ = false,
    AutoSkillX = false,
    AutoSkillC = false,
    AutoSkillV = false,
    -- Mastery & Bosses
    AutoMastery = false,
    MasteryWeapon = "Sword",
    AutoEliteHunter = false,
    AutoBoneFarm = false,
    AutoRollBones = false,
    AutoCakePrince = false, -- 500 Mob Farm for Dough King
    -- Chest Collector
    ChestCollector = false,
    ChestSpeed = 20,
    -- Sea Events
    AutoSeaEvent = false,
    SeaEventSpeed = 280,
    DangerZone = "Danger 5",
    KillSeaBeasts = true,
    KillTerrorShark = true,
    -- Fruits
    TweenFruits = false,
    FruitSpeed = 240,
    AutoStore = true,
    -- Raids
    AutoRaid = false,
    SelectedRaid = "Flame",
    AutoNextIsland = true,
    AutoPirateRaid = false,
    -- ESP
    PlayerESP = false,
    FruitESP = false,
    BerryESP = false,
    ChestESP = false,
    EliteESP = false,
    -- Player Mods
    InfiniteJump = false,
    WaterWalk = false,
    ManualNoclip = false,
    SpinBot = false,
    SpinSpeed = 25,
    FullBright = false
}

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end)

-- =============================================================
-- 📍 QUEST VE KOORDİNAT VERİTABANI
-- =============================================================
local RealQuests = {
    {Level = 1, Quest = "BanditQuest1", Index = 1, Mob = "Bandit", Pos = Vector3.new(1060, 16, 1548), NpcPos = Vector3.new(1060, 16, 1548)},
    {Level = 10, Quest = "JungleQuest", Index = 1, Mob = "Monkey", Pos = Vector3.new(-1610, 37, 148), NpcPos = Vector3.new(-1601, 36, 153)},
    {Level = 15, Quest = "JungleQuest", Index = 2, Mob = "Gorilla", Pos = Vector3.new(-1237, 6, -486), NpcPos = Vector3.new(-1601, 36, 153)},
    {Level = 30, Quest = "BuggyQuest1", Index = 1, Mob = "Pirate", Pos = Vector3.new(-1215, 4, 3905), NpcPos = Vector3.new(-1140, 4, 3828)},
    {Level = 40, Quest = "BuggyQuest1", Index = 2, Mob = "Brute", Pos = Vector3.new(-1327, 14, 4180), NpcPos = Vector3.new(-1140, 4, 3828)},
    {Level = 60, Quest = "DesertQuest", Index = 1, Mob = "Desert Bandit", Pos = Vector3.new(932, 6, 4485), NpcPos = Vector3.new(896, 6, 4390)},
    {Level = 75, Quest = "DesertQuest", Index = 2, Mob = "Desert Officer", Pos = Vector3.new(1572, 9, 4373), NpcPos = Vector3.new(896, 6, 4390)},
    {Level = 90, Quest = "SnowQuest", Index = 1, Mob = "Snow Bandit", Pos = Vector3.new(1288, 105, -1320), NpcPos = Vector3.new(1385, 87, -1298)},
    {Level = 100, Quest = "SnowQuest", Index = 2, Mob = "Snowman", Pos = Vector3.new(1288, 105, -1320), NpcPos = Vector3.new(1385, 87, -1298)},
    {Level = 120, Quest = "MarineQuest2", Index = 1, Mob = "Chief Petty Officer", Pos = Vector3.new(-4855, 21, 4295), NpcPos = Vector3.new(-5035, 29, 4326)},
    {Level = 150, Quest = "SkyQuest", Index = 1, Mob = "Sky Bandit", Pos = Vector3.new(-4840, 718, -2620), NpcPos = Vector3.new(-4840, 718, -2620)},
    {Level = 175, Quest = "SkyQuest", Index = 2, Mob = "Dark Master", Pos = Vector3.new(-4840, 718, -2620), NpcPos = Vector3.new(-4840, 718, -2620)},
    {Level = 190, Quest = "PrisonerQuest", Index = 1, Mob = "Prisoner", Pos = Vector3.new(5308, 2, 475), NpcPos = Vector3.new(5191, 4, 692)},
    {Level = 250, Quest = "ColosseumQuest", Index = 1, Mob = "Toga Warrior", Pos = Vector3.new(-1575, 7, -2985), NpcPos = Vector3.new(-1575, 7, -2985)},
    {Level = 300, Quest = "MagmaQuest", Index = 1, Mob = "Military Soldier", Pos = Vector3.new(-5315, 12, 8515), NpcPos = Vector3.new(-5315, 12, 8515)},
    {Level = 375, Quest = "FishmanQuest", Index = 1, Mob = "Fishman Warrior", Pos = Vector3.new(61122, 18, 1567), NpcPos = Vector3.new(61122, 18, 1567)},
    {Level = 450, Quest = "SkyExp1Quest", Index = 1, Mob = "God's Guard", Pos = Vector3.new(-7861, 5545, -381), NpcPos = Vector3.new(-7861, 5545, -381)},
    {Level = 700, Quest = "Area1Quest", Index = 1, Mob = "Raider", Pos = Vector3.new(-427, 73, 1835), NpcPos = Vector3.new(-427, 73, 1835)},
    {Level = 800, Quest = "Area2Quest", Index = 1, Mob = "Factory Staff", Pos = Vector3.new(635, 73, 919), NpcPos = Vector3.new(635, 73, 919)},
    {Level = 1000, Quest = "SnowMountainQuest", Index = 1, Mob = "Snow Trooper", Pos = Vector3.new(609, 401, -5372), NpcPos = Vector3.new(609, 401, -5372)},
    {Level = 1250, Quest = "ShipQuest1", Index = 1, Mob = "Ship Deckhand", Pos = Vector3.new(923, 126, 32852), NpcPos = Vector3.new(923, 126, 32852)},
    {Level = 1500, Quest = "PiratePortQuest", Index = 1, Mob = "Pirate Millionaire", Pos = Vector3.new(-449, 109, 5950), NpcPos = Vector3.new(-449, 109, 5950)},
    {Level = 1775, Quest = "DeepForestIsland3", Index = 1, Mob = "Fishman Raider", Pos = Vector3.new(-13233, 332, -7626), NpcPos = Vector3.new(-13233, 332, -7626)},
    {Level = 2000, Quest = "HauntedQuest1", Index = 2, Mob = "Living Zombie", Pos = Vector3.new(-9515, 142, 5535), NpcPos = Vector3.new(-9515, 142, 5535)},
    {Level = 2200, Quest = "CakeQuest1", Index = 1, Mob = "Cookie Crafter", Pos = Vector3.new(-2087, 38, -10194), NpcPos = Vector3.new(-2087, 38, -10194)},
    {Level = 2450, Quest = "TikiQuest1", Index = 1, Mob = "Isle Outlaw", Pos = Vector3.new(-16234, 9, 442), NpcPos = Vector3.new(-16234, 9, 442)}
}

local function GetPlayerLevel()
    local data = LocalPlayer:FindFirstChild("Data")
    local lvl = data and data:FindFirstChild("Level")
    return lvl and lvl.Value or 1
end

local function GetCurrentQuest()
    local playerLvl = GetPlayerLevel()
    local chosen = RealQuests[1]
    for _, q in ipairs(RealQuests) do
        if playerLvl >= q.Level then chosen = q end
    end
    return chosen
end

local function HasActiveQuest()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local quest = main and main:FindFirstChild("Quest")
    return quest and quest.Visible == true
end

local function CleanMobName(name)
    return name:gsub(" %b[]", ""):gsub(" %pLv%. %d+%p", ""):gsub(" %pBoss%p", ""):gsub("^%s*(.-)%s*$", "%1")
end

-- =============================================================
-- 🚀 FİZİK SABİTLEYİCİ UÇUŞ & NOCLIP
-- =============================================================
local function ApplyNoclip()
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

RunService.Stepped:Connect(function()
    if Config.AutoFarm or Config.ChestCollector or Config.TweenFruits or Config.AutoSeaEvent or Config.AutoEliteHunter or Config.AutoBoneFarm or Config.AutoCakePrince or Config.ManualNoclip then
        ApplyNoclip()
    end
end)

local function StableGlideTo(targetPos, speed)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return false end

    speed = speed or 250
    hum.PlatformStand = true

    local bv = root:FindFirstChild("MorganGlideBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "MorganGlideBV"
        bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        bv.Velocity = Vector3.zero
        bv.Parent = root
    end

    local currentPos = root.Position
    local dist = (targetPos - currentPos).Magnitude

    if dist < 6 then
        root.CFrame = CFrame.new(targetPos)
        bv.Velocity = Vector3.zero
        return true
    end

    local dir = (targetPos - currentPos).Unit
    bv.Velocity = dir * speed
    root.CFrame = CFrame.lookAt(currentPos, currentPos + dir)
    return false
end

local function StopGlide()
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and root:FindFirstChild("MorganGlideBV") then
            root.MorganGlideBV:Destroy()
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- =============================================================
-- ⚡ COMBAT, SKILLS & FAST ATTACK
-- =============================================================
local function EquipWeaponByToolTip(toolTipName)
    local char = LocalPlayer.Character
    if not char then return end
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool and currentTool.ToolTip == toolTipName then return end

    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and (t.ToolTip == toolTipName or toolTipName == "Any") then
                char.Humanoid:EquipTool(t)
                break
            end
        end
    end
end

local lastSkillTime = 0
local function TriggerSkill(key)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.04)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end)
end

local function ExecuteFastAttack(targetPart)
    if not Config.FastAttack or not targetPart then return end
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")

    pcall(function()
        if RegisterAttack and RegisterHit then
            RegisterAttack:FireServer(0)
            RegisterHit:FireServer(targetPart, {{targetPart.Parent, targetPart}})
        end
        if tool then tool:Activate() end
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(500, 500))

        -- Kombo Yetenek Basma
        if tick() - lastSkillTime > 0.8 then
            lastSkillTime = tick()
            if Config.AutoSkillZ then TriggerSkill("Z") end
            if Config.AutoSkillX then TriggerSkill("X") end
            if Config.AutoSkillC then TriggerSkill("C") end
            if Config.AutoSkillV then TriggerSkill("V") end
        end
    end)
end

local function EnsureBuso()
    if not Config.AutoBuso then return end
    local char = LocalPlayer.Character
    if char and not char:FindFirstChild("HasBuso") and CommF_ then
        pcall(function() CommF_:InvokeServer("Buso") end)
    end
end

local function EnsureKen()
    if not Config.AutoKen then return end
    local char = LocalPlayer.Character
    if char and not char:FindFirstChild("VisionActive") and CommE then
        pcall(function() CommE:FireServer("Ken", true) end)
    end
end

-- =============================================================
-- 🌾 AUTO FARM ENGINE
-- =============================================================
task.spawn(function()
    while true do
        task.wait()
        if Config.AutoFarm and not Config.ChestCollector and not Config.TweenFruits and not Config.AutoSeaEvent and not Config.AutoEliteHunter and not Config.AutoBoneFarm and not Config.AutoCakePrince then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not root or not hum or hum.Health <= 0 then return end

                local questData = GetCurrentQuest()

                if not HasActiveQuest() then
                    local distToNPC = (questData.NpcPos - root.Position).Magnitude
                    if distToNPC > 20 then
                        StableGlideTo(questData.NpcPos + Vector3.new(0, 5, 0), Config.FarmSpeed)
                    else
                        StopGlide()
                        if CommF_ then
                            CommF_:InvokeServer("StartQuest", questData.Quest, questData.Index)
                            task.wait(0.4)
                        end
                    end
                else
                    local targetMob = nil
                    local enemies = Workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, enemy in ipairs(enemies:GetChildren()) do
                            if CleanMobName(enemy.Name) == questData.Mob and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                                targetMob = enemy
                                break
                            end
                        end
                    end

                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        local mobPos = targetMob.HumanoidRootPart.Position + Vector3.new(0, Config.FarmDistance, 0)
                        StableGlideTo(mobPos, Config.FarmSpeed)

                        if Config.AutoMastery then
                            local hpPercent = targetMob.Humanoid.Health / targetMob.Humanoid.MaxHealth
                            EquipWeaponByToolTip(hpPercent <= 0.25 and Config.MasteryWeapon or "Melee")
                        else
                            EquipWeaponByToolTip("Melee")
                        end

                        EnsureBuso()
                        EnsureKen()
                        ExecuteFastAttack(targetMob.HumanoidRootPart)

                        if Config.BringMobs and enemies then
                            for _, other in ipairs(enemies:GetChildren()) do
                                if other ~= targetMob and CleanMobName(other.Name) == questData.Mob and other:FindFirstChild("HumanoidRootPart") and other.Humanoid.Health > 0 then
                                    if (other.HumanoidRootPart.Position - targetMob.HumanoidRootPart.Position).Magnitude < 280 then
                                        other.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame
                                        other.HumanoidRootPart.CanCollide = false
                                        other.Humanoid.WalkSpeed = 0
                                    end
                                end
                            end
                        end
                    else
                        if Config.WaitAtSpawn then
                            StableGlideTo(questData.Pos + Vector3.new(0, 20, 0), Config.FarmSpeed)
                        end
                    end
                end
            end)
        elseif not Config.ChestCollector and not Config.TweenFruits and not Config.AutoSeaEvent and not Config.AutoEliteHunter and not Config.AutoBoneFarm and not Config.AutoCakePrince then
            StopGlide()
        end
    end
end)

-- =============================================================
-- 🎂 AUTO CAKE PRINCE & DOUGH KING (500 MOBS AUTO SPAWN)
-- =============================================================
local CakeIslandCenter = Vector3.new(-2087, 38, -10194)

task.spawn(function()
    while true do
        task.wait()
        if Config.AutoCakePrince then
            pcall(function()
                local enemies = Workspace:FindFirstChild("Enemies")
                local cakeBoss = nil
                local normalMob = nil

                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        local n = enemy.Name
                        if (n:find("Cake Prince") or n:find("Dough King")) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                            cakeBoss = enemy
                            break
                        elseif (n:find("Baker") or n:find("Baking") or n:find("Cake Guard") or n:find("Cookie")) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                            normalMob = enemy
                        end
                    end
                end

                local target = cakeBoss or normalMob
                if target and target:FindFirstChild("HumanoidRootPart") then
                    local targetPos = target.HumanoidRootPart.Position + Vector3.new(0, Config.FarmDistance, 0)
                    StableGlideTo(targetPos, Config.FarmSpeed)
                    EnsureBuso()
                    EquipWeaponByToolTip("Melee")
                    ExecuteFastAttack(target.HumanoidRootPart)
                else
                    StableGlideTo(CakeIslandCenter + Vector3.new(0, 40, 0), Config.FarmSpeed)
                end
            end)
        end
    end
end)

-- =============================================================
-- ☠️ AUTO ELITE HUNTER & BONES
-- =============================================================
local EliteBossNames = {"Urban", "Deandre", "Diablo"}

local function GetSpawnedElite()
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            for _, eliteName in ipairs(EliteBossNames) do
                if enemy.Name:find(eliteName) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                    return enemy
                end
            end
        end
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait()
        if Config.AutoEliteHunter then
            pcall(function()
                local eliteMob = GetSpawnedElite()
                if eliteMob and eliteMob:FindFirstChild("HumanoidRootPart") then
                    local targetPos = eliteMob.HumanoidRootPart.Position + Vector3.new(0, Config.FarmDistance, 0)
                    StableGlideTo(targetPos, Config.FarmSpeed)
                    EnsureBuso()
                    EquipWeaponByToolTip("Melee")
                    ExecuteFastAttack(eliteMob.HumanoidRootPart)
                else
                    if CommF_ then
                        CommF_:InvokeServer("EliteHunter")
                        task.wait(1.5)
                    end
                end
            end)
        end
    end
end)

-- =============================================================
-- 💰 CHEST COLLECTOR (20 SPEED / NOCLIP)
-- =============================================================
task.spawn(function()
    while true do
        task.wait(0.1)
        if Config.ChestCollector and not Config.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then return end

                local chestFolder = Workspace:FindFirstChild("ChestModels") or Workspace
                local chests = {}

                for _, obj in ipairs(chestFolder:GetChildren()) do
                    if obj.Name:find("Chest") and obj:IsA("BasePart") then
                        table.insert(chests, obj)
                    elseif obj.Name:find("Chest") and obj:FindFirstChildWhichIsA("BasePart") then
                        table.insert(chests, obj:FindFirstChildWhichIsA("BasePart"))
                    end
                end

                if #chests > 0 then
                    local closestChest, minDist = nil, math.huge
                    for _, c in ipairs(chests) do
                        local dist = (c.Position - root.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closestChest = c
                        end
                    end

                    if closestChest then
                        local arrived = StableGlideTo(closestChest.Position, Config.ChestSpeed)
                        if arrived then
                            firetouchinterest(root, closestChest, 0)
                            firetouchinterest(root, closestChest, 1)
                            task.wait(0.3)
                        end
                    end
                else
                    StopGlide()
                end
            end)
        end
    end
end)

-- =============================================================
-- 🌊 AUTO SEA EVENT & FRUIT TWEEN
-- =============================================================
local DangerZones = {
    ["Danger 1"] = Vector3.new(-16500, 35, 2500),
    ["Danger 2"] = Vector3.new(-16500, 35, 5500),
    ["Danger 3"] = Vector3.new(-16500, 35, 8500),
    ["Danger 4"] = Vector3.new(-16500, 35, 11500),
    ["Danger 5"] = Vector3.new(-16500, 35, 14500),
    ["Danger 6"] = Vector3.new(-16500, 35, 18500)
}

local function LocateSeaBeastOrShark()
    local seaBeasts = Workspace:FindFirstChild("SeaBeasts")
    if seaBeasts then
        for _, sb in ipairs(seaBeasts:GetChildren()) do
            if sb:FindFirstChild("HumanoidRootPart") and sb:FindFirstChild("Humanoid") and sb.Humanoid.Health > 0 then
                return sb
            end
        end
    end
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            local name = enemy.Name
            if (name:find("Terror") or name:find("Shark") or name:find("Piranha") or name:find("Ship")) and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                return enemy
            end
        end
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait()
        if Config.AutoSeaEvent then
            pcall(function()
                local monster = LocateSeaBeastOrShark()
                if monster and monster:FindFirstChild("HumanoidRootPart") then
                    local targetPos = monster.HumanoidRootPart.Position + Vector3.new(0, 35, 0)
                    StableGlideTo(targetPos, Config.SeaEventSpeed)
                    EnsureBuso()
                    EquipWeaponByToolTip("Melee")
                    ExecuteFastAttack(monster.HumanoidRootPart)
                else
                    local zone = DangerZones[Config.DangerZone] or DangerZones["Danger 5"]
                    StableGlideTo(zone, Config.SeaEventSpeed)
                end
            end)
        end
    end
end)

-- Fruit Tween
local function FindWorldFruit()
    for _, item in ipairs(Workspace:GetChildren()) do
        if (item:IsA("Tool") or item:IsA("Model")) and (item.Name:find("Fruit") or item.Name:find("Meyve")) then
            local handle = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
            if handle then return item, handle end
        end
    end
    return nil, nil
end

task.spawn(function()
    while true do
        task.wait(0.3)
        if Config.TweenFruits then
            pcall(function()
                local fruitItem, fruitHandle = FindWorldFruit()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")

                if fruitItem and fruitHandle and root then
                    StableGlideTo(fruitHandle.Position, Config.FruitSpeed)
                    if (fruitHandle.Position - root.Position).Magnitude < 12 then
                        firetouchinterest(root, fruitHandle, 0)
                        firetouchinterest(root, fruitHandle, 1)
                        task.wait(0.5)
                        if Config.AutoStore and CommF_ then
                            CommF_:InvokeServer("StoreFruit", fruitItem.Name, fruitItem)
                        end
                    end
                else
                    if not Config.AutoFarm and not Config.ChestCollector then
                        StopGlide()
                    end
                end
            end)
        end
    end
end)

-- =============================================================
-- 👁️ 0-LAG PERSISTENT ESP
-- =============================================================
local ESPFolder = Instance.new("Folder", Workspace)
ESPFolder.Name = "MorganESP_V17"

local function AddESPBillboard(part, text, color)
    local b = Instance.new("BillboardGui")
    b.Size = UDim2.new(0, 110, 0, 30)
    b.AlwaysOnTop = true
    b.Adornee = part
    b.StudsOffset = Vector3.new(0, 3, 0)
    b.Parent = ESPFolder

    local l = Instance.new("TextLabel", b)
    l.Size = UDim2.fromScale(1, 1)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color
    l.TextStrokeTransparency = 0
    l.TextSize = 11
    l.Font = Enum.Font.GothamBold
end

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            ESPFolder:ClearAllChildren()
            local char = LocalPlayer.Character
            local myPos = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position or Vector3.zero

            if Config.PlayerESP then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                        local d = math.floor((p.Character.HumanoidRootPart.Position - myPos).Magnitude)
                        AddESPBillboard(p.Character.HumanoidRootPart, p.DisplayName .. " [" .. d .. "m]\nHP: " .. math.floor(p.Character.Humanoid.Health), Color3.fromRGB(180, 100, 255))
                    end
                end
            end

            if Config.FruitESP then
                for _, item in ipairs(Workspace:GetChildren()) do
                    if (item:IsA("Tool") or item:IsA("Model")) and (item.Name:find("Fruit") or item.Name:find("Meyve")) then
                        local h = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
                        if h then
                            local d = math.floor((h.Position - myPos).Magnitude)
                            AddESPBillboard(h, "🍇 " .. item.Name .. " [" .. d .. "m]", Color3.fromRGB(255, 170, 0))
                        end
                    end
                end
            end

            if Config.BerryESP then
                for _, bush in ipairs(CollectionService:GetTagged("BerryBush")) do
                    local p = bush:IsA("BasePart") and bush or bush:FindFirstChildWhichIsA("BasePart")
                    if p then
                        local d = math.floor((p.Position - myPos).Magnitude)
                        AddESPBillboard(p, "🍒 Berry Bush [" .. d .. "m]", Color3.fromRGB(255, 60, 100))
                    end
                end
            end

            if Config.ChestESP then
                local chests = Workspace:FindFirstChild("ChestModels") or Workspace
                for _, c in ipairs(chests:GetChildren()) do
                    if c.Name:find("Chest") and c:IsA("BasePart") then
                        local d = math.floor((c.Position - myPos).Magnitude)
                        AddESPBillboard(c, "💰 Chest [" .. d .. "m]", Color3.fromRGB(255, 220, 50))
                    end
                end
            end

            if Config.EliteESP then
                local elite = GetSpawnedElite()
                if elite and elite:FindFirstChild("HumanoidRootPart") then
                    local d = math.floor((elite.HumanoidRootPart.Position - myPos).Magnitude)
                    AddESPBillboard(elite.HumanoidRootPart, "👑 " .. elite.Name .. " [" .. d .. "m]", Color3.fromRGB(255, 40, 40))
                end
            end
        end)
    end
end)

-- =============================================================
-- 🎨 PURPLE DASHBOARD UI TASARIMI
-- =============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV17UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGuiContainer

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(780, 460)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 14, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(45, 40, 68)
MainStroke.Thickness = 1.2

-- Top Right Controls
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(0, 110, 0, 35)
TopBar.Position = UDim2.new(1, -115, 0, 8)
TopBar.BackgroundTransparency = 1

local function CreateTopBtn(symbol, xPos, callback)
    local btn = Instance.new("TextButton", TopBar)
    btn.Size = UDim2.fromOffset(26, 26)
    btn.Position = UDim2.fromOffset(xPos, 4)
    btn.BackgroundTransparency = 1
    btn.Text = symbol
    btn.TextColor3 = Color3.fromRGB(160, 150, 185)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.MouseButton1Click:Connect(callback)
    return btn
end

CreateTopBtn("—", 10, function() MainFrame.Visible = not MainFrame.Visible end)
CreateTopBtn("⛶", 45, function() end)
CreateTopBtn("✕", 78, function() ScreenGui:Destroy() end)

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 175, 1, -70)
Sidebar.Position = UDim2.fromOffset(15, 58)
Sidebar.BackgroundTransparency = 1

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 4)

-- Content Area
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -225, 1, -60)
ContentArea.Position = UDim2.fromOffset(205, 46)
ContentArea.BackgroundColor3 = Color3.fromRGB(19, 17, 28)
ContentArea.BorderSizePixel = 0

local ContentCorner = Instance.new("UICorner", ContentArea)
ContentCorner.CornerRadius = UDim.new(0, 12)

local ContentStroke = Instance.new("UIStroke", ContentArea)
ContentStroke.Color = Color3.fromRGB(38, 32, 56)
ContentStroke.Thickness = 1

local TabPages = {}
local function RegisterPage(name)
    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.fromOffset(10, 10)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(150, 85, 255)
    page.Visible = false

    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    TabPages[name] = page
    return page
end

local MainPage = RegisterPage("Main")
local FarmPage = RegisterPage("Farm")
local CombatPage = RegisterPage("Combat")
local CakePage = RegisterPage("DoughKing")
local SeaPage = RegisterPage("SeaEvents")
local FruitPage = RegisterPage("Fruits")
local WaypointPage = RegisterPage("Waypoints")
local ShopPage = RegisterPage("Shop")
local PlayerPage = RegisterPage("Player")
local ESPPage = RegisterPage("Visuals")

-- Tab Switcher
local firstTab = true
local function AddNavTab(name, icon, targetPage)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(25, 22, 38)
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. icon .. "  " .. name
    btn.TextColor3 = Color3.fromRGB(160, 150, 185)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.fromOffset(4, 16)
    indicator.Position = UDim2.new(0, 2, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(160, 100, 255)
    indicator.Visible = false
    local indCorner = Instance.new("UICorner", indicator)
    indCorner.CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(TabPages) do p.Visible = false end
        for _, b in ipairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundTransparency = 1
                b.TextColor3 = Color3.fromRGB(160, 150, 185)
                if b:FindFirstChild("Frame") then b.Frame.Visible = false end
            end
        end

        targetPage.Visible = true
        btn.BackgroundTransparency = 0
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Visible = true
    end)

    if firstTab then
        firstTab = false
        btn.BackgroundTransparency = 0
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Visible = true
        targetPage.Visible = true
    end
end

AddNavTab("Dashboard", "🏠", MainPage)
AddNavTab("Auto Farm", "🌾", FarmPage)
AddNavTab("Auto Skills", "⚡", CombatPage)
AddNavTab("Dough King", "🎂", CakePage)
AddNavTab("Sea Events", "🌊", SeaPage)
AddNavTab("Fruits & Chest", "🍓", FruitPage)
AddNavTab("Waypoints", "📍", WaypointPage)
AddNavTab("Abilities & Shop", "🛒", ShopPage)
AddNavTab("Player & Fun", "👤", PlayerPage)
AddNavTab("ESP Visuals", "👁️", ESPPage)

-- Card Generator
local function CreateToggleCard(parent, title, desc, defaultState, callback)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, -6, 0, 52)
    card.BackgroundColor3 = Color3.fromRGB(25, 22, 38)

    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 8)

    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = Color3.fromRGB(45, 40, 68)
    cardStroke.Thickness = 1

    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.Size = UDim2.new(0.7, 0, 0, 18)
    titleLbl.Position = UDim2.fromOffset(14, 7)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(240, 235, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local descLbl = Instance.new("TextLabel", card)
    descLbl.Size = UDim2.new(0.7, 0, 0, 16)
    descLbl.Position = UDim2.fromOffset(14, 27)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = desc
    descLbl.TextColor3 = Color3.fromRGB(150, 140, 175)
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 11
    descLbl.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", card)
    toggleBtn.Size = UDim2.fromOffset(44, 22)
    toggleBtn.Position = UDim2.new(1, -58, 0.5, -11)
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(150, 80, 255) or Color3.fromRGB(45, 40, 65)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""

    local togCorner = Instance.new("UICorner", toggleBtn)
    togCorner.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", toggleBtn)
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)

    local state = defaultState
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(150, 80, 255) or Color3.fromRGB(45, 40, 65)
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        }):Play()
        pcall(callback, state)
    end)
end

local function CreateActionBtn(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -6, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(35, 28, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(245, 240, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- =============================================================
-- 🏠 TAB 1: DASHBOARD
-- =============================================================
local CardsRow = Instance.new("Frame", MainPage)
CardsRow.Size = UDim2.new(1, 0, 0, 110)
CardsRow.BackgroundTransparency = 1

local Banner = Instance.new("Frame", CardsRow)
Banner.Size = UDim2.new(0.62, 0, 1, 0)
Banner.BackgroundColor3 = Color3.fromRGB(30, 22, 50)
local bCorner = Instance.new("UICorner", Banner)
bCorner.CornerRadius = UDim.new(0, 10)

local bGrad = Instance.new("UIGradient", Banner)
bGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 35, 160)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 16, 38))
}
bGrad.Rotation = 45

local bTitle = Instance.new("TextLabel", Banner)
bTitle.Size = UDim2.new(1, -20, 0, 22)
bTitle.Position = UDim2.fromOffset(15, 20)
bTitle.BackgroundTransparency = 1
bTitle.Text = "Morgan Hub V17 Pro"
bTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
bTitle.Font = Enum.Font.GothamBold
bTitle.TextSize = 16
bTitle.TextXAlignment = Enum.TextXAlignment.Left

local MoonStatusLbl = Instance.new("TextLabel", Banner)
MoonStatusLbl.Size = UDim2.new(1, -20, 0, 20)
MoonStatusLbl.Position = UDim2.fromOffset(15, 46)
MoonStatusLbl.BackgroundTransparency = 1
MoonStatusLbl.Text = "🌕 Moon Status: Checking..."
MoonStatusLbl.TextColor3 = Color3.fromRGB(220, 200, 255)
MoonStatusLbl.Font = Enum.Font.GothamMedium
MoonStatusLbl.TextSize = 12
MoonStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Full Moon Tracker
task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            local sky = Lighting:FindFirstChildWhichIsA("Sky")
            if sky and sky.MoonTextureId:find("9709149431") then
                MoonStatusLbl.Text = "🌕 FULL MOON IS ACTIVE!"
                MoonStatusLbl.TextColor3 = Color3.fromRGB(255, 220, 50)
            else
                MoonStatusLbl.Text = "🌑 Regular Moon Phase"
                MoonStatusLbl.TextColor3 = Color3.fromRGB(180, 170, 210)
            end
        end)
    end
end)

local UserCard = Instance.new("Frame", CardsRow)
UserCard.Size = UDim2.new(0.35, 0, 1, 0)
UserCard.Position = UDim2.new(0.65, 0, 0, 0)
UserCard.BackgroundColor3 = Color3.fromRGB(25, 22, 38)
local uCorner = Instance.new("UICorner", UserCard)
uCorner.CornerRadius = UDim.new(0, 10)

local UserAvatar = Instance.new("ImageLabel", UserCard)
UserAvatar.Size = UDim2.fromOffset(55, 55)
UserAvatar.Position = UDim2.new(0, 12, 0.5, -27)
UserAvatar.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
UserAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
local aCorner = Instance.new("UICorner", UserAvatar)
aCorner.CornerRadius = UDim.new(1, 0)

local DisplayNameLabel = Instance.new("TextLabel", UserCard)
DisplayNameLabel.Size = UDim2.new(1, -75, 0, 18)
DisplayNameLabel.Position = UDim2.fromOffset(75, 24)
DisplayNameLabel.BackgroundTransparency = 1
DisplayNameLabel.Text = LocalPlayer.DisplayName
DisplayNameLabel.TextColor3 = Color3.fromRGB(240, 235, 255)
DisplayNameLabel.Font = Enum.Font.GothamBold
DisplayNameLabel.TextSize = 13
DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local LevelLabel = Instance.new("TextLabel", UserCard)
LevelLabel.Size = UDim2.new(1, -75, 0, 16)
LevelLabel.Position = UDim2.fromOffset(75, 46)
LevelLabel.BackgroundTransparency = 1
LevelLabel.Text = "Lv. " .. GetPlayerLevel()
LevelLabel.TextColor3 = Color3.fromRGB(160, 110, 255)
LevelLabel.Font = Enum.Font.GothamMedium
LevelLabel.TextSize = 11
LevelLabel.TextXAlignment = Enum.TextXAlignment.Left

CreateToggleCard(MainPage, "Auto Farm Level", "Start quest farming with stabilized CFrame flight", Config.AutoFarm, function(v) Config.AutoFarm = v end)
CreateToggleCard(MainPage, "Chest Collector", "Fly through walls and collect all server chests", Config.ChestCollector, function(v) Config.ChestCollector = v end)
CreateToggleCard(MainPage, "Auto Elite Hunter", "Tracks and defeats Sea 3 Elite Bosses", Config.AutoEliteHunter, function(v) Config.AutoEliteHunter = v end)

-- =============================================================
-- 🌾 TAB 2: AUTO FARM
-- =============================================================
CreateToggleCard(FarmPage, "Auto Farm Level", "Coordinates-based quest farming engine", Config.AutoFarm, function(v) Config.AutoFarm = v end)
CreateToggleCard(FarmPage, "Auto Farm Nearest", "Attacks closest enemies without quests", Config.AutoFarmNearest, function(v) Config.AutoFarmNearest = v end)
CreateToggleCard(FarmPage, "Auto Mastery Farm", "Finishes mobs with sword/fruit at low HP", Config.AutoMastery, function(v) Config.AutoMastery = v end)
CreateToggleCard(FarmPage, "Mob Magnet", "Pulls all quest mobs together", Config.BringMobs, function(v) Config.BringMobs = v end)
CreateToggleCard(FarmPage, "Ultra Fast Attack", "High-speed network remote attack", Config.FastAttack, function(v) Config.FastAttack = v end)
CreateToggleCard(FarmPage, "Auto Buso Haki", "Hardens armament haki automatically", Config.AutoBuso, function(v) Config.AutoBuso = v end)

-- =============================================================
-- ⚡ TAB 3: AUTO SKILLS SPAMMER (NEW)
-- =============================================================
CreateToggleCard(CombatPage, "Auto Use Skill [Z]", "Casts Z skill during attacks", Config.AutoSkillZ, function(v) Config.AutoSkillZ = v end)
CreateToggleCard(CombatPage, "Auto Use Skill [X]", "Casts X skill during attacks", Config.AutoSkillX, function(v) Config.AutoSkillX = v end)
CreateToggleCard(CombatPage, "Auto Use Skill [C]", "Casts C skill during attacks", Config.AutoSkillC, function(v) Config.AutoSkillC = v end)
CreateToggleCard(CombatPage, "Auto Use Skill [V]", "Casts V skill during attacks", Config.AutoSkillV, function(v) Config.AutoSkillV = v end)

-- =============================================================
-- 🎂 TAB 4: DOUGH KING & BONES (NEW)
-- =============================================================
CreateToggleCard(CakePage, "Auto 500 Mobs (Dough King / Cake Prince)", "Farms 500 mobs at Sea of Treats to spawn boss", Config.AutoCakePrince, function(v)
    Config.AutoCakePrince = v
    if v then Config.AutoFarm = false end
end)
CreateToggleCard(CakePage, "Auto Bone Farm (Haunted Castle)", "Kills skeletons & zombies for bones", Config.AutoBoneFarm, function(v)
    Config.AutoBoneFarm = v
    if v then Config.AutoFarm = false end
end)
CreateToggleCard(CakePage, "Auto Roll Bones (Death King)", "Spends 50 Bones every 5s for random surprises", Config.AutoRollBones, function(v) Config.AutoRollBones = v end)

-- =============================================================
-- 📍 TAB 5: WAYPOINTS & TELEPORTS (NEW)
-- =============================================================
local Waypoints = {
    ["Cafe (Sea 2)"] = Vector3.new(-380, 73, 298),
    ["Mansion (Sea 3)"] = Vector3.new(-12463, 375, -7552),
    ["Castle on Sea (Sea 3)"] = Vector3.new(-5085, 316, -3156),
    ["Hydra Island (Sea 3)"] = Vector3.new(5228, 1004, 340),
    ["Floating Turtle (Sea 3)"] = Vector3.new(-13233, 332, -7626),
    ["Haunted Castle (Sea 3)"] = Vector3.new(-9515, 142, 5535),
    ["Port Town (Sea 3)"] = Vector3.new(-290, 7, 5343)
}

for name, pos in pairs(Waypoints) do
    CreateActionBtn(WaypointPage, "Teleport to " .. name, function()
        StableGlideTo(pos + Vector3.new(0, 15, 0), 320)
    end)
end

-- =============================================================
-- 🌊 TAB 6: SEA EVENTS
-- =============================================================
CreateToggleCard(SeaPage, "Auto Sea Event Patrol", "Flies through deep ocean to summon events", Config.AutoSeaEvent, function(v)
    Config.AutoSeaEvent = v
    if v then Config.AutoFarm = false end
end)
CreateToggleCard(SeaPage, "Hunt Sea Beasts", "Attacks and destroys Sea Beasts", Config.KillSeaBeasts, function(v) Config.KillSeaBeasts = v end)
CreateToggleCard(SeaPage, "Hunt Terror Sharks & Piranhas", "Targets oceanic predators", Config.KillTerrorShark, function(v) Config.KillTerrorShark = v end)

-- =============================================================
-- 🍓 TAB 7: FRUITS & CHESTS
-- =============================================================
CreateToggleCard(FruitPage, "Chest Collector (20 Speed / Noclip)", "Glides through all walls to collect map chests", Config.ChestCollector, function(v) Config.ChestCollector = v end)
CreateToggleCard(FruitPage, "Tween to Spawned Fruits", "Flies directly to uncollected fruits", Config.TweenFruits, function(v) Config.TweenFruits = v end)
CreateToggleCard(FruitPage, "Auto Store Fruits", "Stores retrieved fruits in fruit bag", Config.AutoStore, function(v) Config.AutoStore = v end)

-- =============================================================
-- 🛒 TAB 8: REMOTE SHOP & ABILITIES
-- =============================================================
CreateActionBtn(ShopPage, "Buy Geppo (Skyjump - $10,000)", function() CommF_:InvokeServer("BuyHaki", "Geppo") end)
CreateActionBtn(ShopPage, "Buy Buso (Buso Haki - $25,000)", function() CommF_:InvokeServer("BuyHaki", "Buso") end)
CreateActionBtn(ShopPage, "Buy Soru (Flash Step - $100,000)", function() CommF_:InvokeServer("BuyHaki", "Soru") end)
CreateActionBtn(ShopPage, "Buy Ken Haki (Observation - $750,000)", function() CommF_:InvokeServer("KenTalk", "Buy") end)
CreateActionBtn(ShopPage, "Reset Stats (Refund - 2,500 Frags)", function() CommF_:InvokeServer("BlackbeardReward", "Refund", "2") end)
CreateActionBtn(ShopPage, "Race Reroll (3,000 Frags)", function() CommF_:InvokeServer("BlackbeardReward", "Reroll", "2") end)

-- =============================================================
-- 👤 TAB 9: PLAYER & FUN
-- =============================================================
CreateToggleCard(PlayerPage, "Infinite Jump", "Jump continuously in the air", Config.InfiniteJump, function(v) Config.InfiniteJump = v end)
CreateToggleCard(PlayerPage, "Jesus Mode (Walk on Water)", "Walk on ocean without taking damage", Config.WaterWalk, function(v) Config.WaterWalk = v end)
CreateToggleCard(PlayerPage, "Manual Noclip", "Pass through any wall or obstacle", Config.ManualNoclip, function(v) Config.ManualNoclip = v end)

-- =============================================================
-- 👁️ TAB 10: 0-LAG PERSISTENT ESP
-- =============================================================
CreateToggleCard(ESPPage, "Player ESP", "Shows player name, distance and HP", Config.PlayerESP, function(v) Config.PlayerESP = v end)
CreateToggleCard(ESPPage, "Fruit ESP", "Displays spawned fruit locations", Config.FruitESP, function(v) Config.FruitESP = v end)
CreateToggleCard(ESPPage, "Berry Bush ESP (Sea 3)", "Locates berry bushes across islands", Config.BerryESP, function(v) Config.BerryESP = v end)
CreateToggleCard(ESPPage, "Chest ESP", "Marks chests on the map", Config.ChestESP, function(v) Config.ChestESP = v end)

-- Runtime Hooks
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local WaterPlatform = Instance.new("Part", Workspace)
WaterPlatform.Name = "JesusPlatform_V17"
WaterPlatform.Size = Vector3.new(100, 1, 100)
WaterPlatform.Transparency = 1
WaterPlatform.Anchored = true
WaterPlatform.CanCollide = false

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if Config.WaterWalk and root then
        WaterPlatform.Position = Vector3.new(root.Position.X, 0.5, root.Position.Z)
        WaterPlatform.CanCollide = true
    else
        WaterPlatform.CanCollide = false
    end
end)

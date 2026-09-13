-- =================================================================================
-- 🔮 MORGAN HUB V28.0 (OPEN-SOURCE ENGINE MERGE - FRUIT HOP, STATS & DYNAMIC KEY) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Varsa eski arayüzleri temizle
local CoreGuiContainer = (gethui and gethui()) or game:GetService("CoreGui")
if CoreGuiContainer:FindFirstChild("MorganHubMasterUI") then
    CoreGuiContainer.MorganHubMasterUI:Destroy()
end
if CoreGuiContainer:FindFirstChild("MorganKeyDialogUI") then
    CoreGuiContainer.MorganKeyDialogUI:Destroy()
end

-- =============================================================
-- 🔑 24-HOUR DYNAMIC KEY VERIFIER
-- =============================================================
local KEY_SALT = "MORGAN_V28_DYNAMIC_DAILY_SALT"
local GATEWAY_URL = "https://yourwebsite.com"
local KEY_SAVE_FILE = "MorganHub_DailyKey.json"

local function GetTodayDynamicKey()
    local d = os.date("!*t")
    local dateStr = string.format("%04d-%02d-%02d-%s", d.year, d.month, d.day, KEY_SALT)

    local hash = 5381
    for i = 1, #dateStr do
        local c = string.byte(dateStr, i)
        hash = ((hash * 33) + c) % 4294967296
    end

    local b1 = string.format("%04X", (hash % 65536))
    local b2 = string.format("%04X", math.floor(hash / 65536) % 65536)
    local b3 = string.format("%04X", ((hash * 7 + 13) % 65536))

    return "MGN-" .. b1 .. "-" .. b2 .. "-" .. b3
end

local function CheckSavedKeyStatus()
    if isfile and readfile and isfile(KEY_SAVE_FILE) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(KEY_SAVE_FILE))
        end)
        if success and type(data) == "table" then
            local currentUTC = os.date("!*t")
            if data.Day == currentUTC.yday and data.Year == currentUTC.year and data.Key == GetTodayDynamicKey() then
                return true
            end
        end
    end
    return false
end

-- =============================================================
-- 🚀 CORE MORGAN HUB ENGINE
-- =============================================================
local function StartMorganHub()
    if CoreGuiContainer:FindFirstChild("MorganKeyDialogUI") then
        CoreGuiContainer.MorganKeyDialogUI:Destroy()
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔮 Morgan Hub",
        Text = "Verified! Welcome, " .. LocalPlayer.DisplayName,
        Duration = 4
    })

    -- Remotes
    local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
    local CommF_ = Remotes and Remotes:WaitForChild("CommF_", 10)
    local CommE = Remotes and Remotes:WaitForChild("CommE", 10)
    local Net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
    local RegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
    local RegisterHit = Net and Net:FindFirstChild("RE/RegisterHit")

    -- CombatFramework Bypass (Zero Cooldown Fast Attack)
    local CombatFrameworkR = nil
    pcall(function()
        local cf = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework", 5))
        if getupvalues then
            CombatFrameworkR = getupvalues(cf)[2]
        end
    end)

    local function OpenSourceFastAttack(targetPart)
        if not targetPart then return end
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end

        if CombatFrameworkR and CombatFrameworkR.activeController then
            pcall(function()
                local ac = CombatFrameworkR.activeController
                if ac.equipped then
                    ac.timeToNextAttack = 0
                    ac.attacking = false
                    ac.hitboxMagnitude = 65
                    if ac.attack then ac:attack() end
                end
            end)
        end

        pcall(function()
            if RegisterAttack and RegisterHit then
                RegisterAttack:FireServer(0)
                RegisterHit:FireServer(targetPart, {{targetPart.Parent, targetPart}})
            end
            tool:Activate()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        end)
    end

    -- Ayarlar
    local Config = {
        AutoFarm = false,
        FarmWeapon = "Melee",
        FarmDistance = 9,
        FarmSpeed = 260,
        FastAttack = true,
        BringMobs = true,
        AutoBuso = true,
        AutoKen = false,
        WaitAtSpawn = true,
        -- Açık Kaynak Yeni Modüller
        AutoFruitHop = false, -- Meyve yoksa sunucu değiştirir
        AutoStats = false,    -- Otomatik stat puanı dağıtıcı
        StatMode = "MeleeDefense", -- "MeleeDefense" / "MaxMelee" / "MaxSword"
        AutoMasteryFinisher = false,
        MasteryWeapon = "Sword",
        -- Magnet & Chest
        MagnetTokenFarm = false,
        MagnetSpeed = 320,
        ChestCollector = false,
        ChestSpeed = 100,
        TweenFruits = false,
        FruitSpeed = 240,
        AutoStore = true,
        -- Sea Progression
        AutoNextSea = false,
        AutoGoLastIsland = false,
        -- ESP
        PlayerESP = false,
        FruitESP = false,
        BerryESP = false,
        ChestESP = false,
        -- Safety
        StaffDetector = true,
        InfiniteJump = false,
        WaterWalk = false,
        ManualNoclip = false
    }

    -- Anti-AFK
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end)

    -- Staff Guard & Safe Server Hop
    local StaffNames = {["rip_indra"] = true, ["mygame43"] = true, ["Uzoth"] = true, ["Axiore"] = true}
    local StaffIDs = {[3095250] = true, [17884881] = true, [6079649301] = true}

    local function SafeServerHop()
        local servers = {}
        pcall(function()
            local raw = game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            local dec = HttpService:JSONDecode(raw)
            for _, s in ipairs(dec.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    table.insert(servers, s.id)
                end
            end
        end)
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end

    Players.PlayerAdded:Connect(function(p)
        if Config.StaffDetector and (StaffNames[p.Name] or StaffIDs[p.UserId] or p:GetRankInGroup(4372130) >= 100) then
            SafeServerHop()
        end
    end)

    -- Deniz Tespiti
    local function GetCurrentSea()
        if game.PlaceId == 2753915549 then return 1
        elseif game.PlaceId == 4442272183 then return 2
        elseif game.PlaceId == 7449423635 then return 3
        else
            local data = LocalPlayer:FindFirstChild("Data")
            local lvl = data and data:FindFirstChild("Level") and data.Level.Value or 1
            if lvl >= 1500 then return 3
            elseif lvl >= 700 then return 2
            else return 1 end
        end
    end

    local LastIslands = {
        [1] = {Name = "Fountain City", Pos = Vector3.new(5127, 4, 4038)},
        [2] = {Name = "Forgotten Island", Pos = Vector3.new(-3056, 240, -10145)},
        [3] = {Name = "Tiki Outpost", Pos = Vector3.new(-16234, 9, 442)}
    }

    local SeaMagnetRoutes = {
        [1] = {Vector3.new(-655, 15, 1582), Vector3.new(-1140, 4, 3828), Vector3.new(896, 6, 4390), Vector3.new(1385, 87, -1298), Vector3.new(5127, 4, 4038)},
        [2] = {Vector3.new(-427, 73, 1835), Vector3.new(-2441, 73, -3219), Vector3.new(-5389, 8, -474), Vector3.new(609, 401, -5372), Vector3.new(-3056, 240, -10145)},
        [3] = {Vector3.new(-290, 7, 5343), Vector3.new(5228, 1004, 340), Vector3.new(-5085, 316, -3156), Vector3.new(-13233, 332, -7626), Vector3.new(-16234, 9, 442)}
    }

    -- Quests
    local Quests = {
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
        {Level = 625, Quest = "FountainQuest", Index = 1, Mob = "Galley Pirate", Pos = Vector3.new(5127, 4, 4038), NpcPos = Vector3.new(5127, 4, 4038)},
        -- Sea 2
        {Level = 700, Quest = "Area1Quest", Index = 1, Mob = "Raider", Pos = Vector3.new(-427, 73, 1835), NpcPos = Vector3.new(-427, 73, 1835)},
        {Level = 800, Quest = "Area2Quest", Index = 1, Mob = "Factory Staff", Pos = Vector3.new(635, 73, 919), NpcPos = Vector3.new(635, 73, 919)},
        {Level = 1000, Quest = "SnowMountainQuest", Index = 1, Mob = "Snow Trooper", Pos = Vector3.new(609, 401, -5372), NpcPos = Vector3.new(609, 401, -5372)},
        {Level = 1250, Quest = "ShipQuest1", Index = 1, Mob = "Ship Deckhand", Pos = Vector3.new(923, 126, 32852), NpcPos = Vector3.new(923, 126, 32852)},
        {Level = 1425, Quest = "ForgottenQuest", Index = 1, Mob = "Sea Soldier", Pos = Vector3.new(-3056, 240, -10145), NpcPos = Vector3.new(-3056, 240, -10145)},
        -- Sea 3
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
        local pLvl = GetPlayerLevel()
        local chosen = Quests[1]
        for _, q in ipairs(Quests) do
            if pLvl >= q.Level then chosen = q end
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

    -- Physics Glide Engine & Noclip
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
        if Config.AutoFarm or Config.ChestCollector or Config.TweenFruits or Config.AutoGoLastIsland or Config.MagnetTokenFarm or Config.ManualNoclip then
            ApplyNoclip()
        end
    end)

    local function StableGlideTo(targetPos, speed)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return false end

        speed = speed or 260
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

        if dist < 5 then
            root.CFrame = CFrame.new(targetPos) * CFrame.Angles(math.rad(-90), 0, 0)
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

    local function EquipSelectedWeapon(customToolTip)
        local char = LocalPlayer.Character
        if not char then return end
        local chosen = customToolTip or Config.FarmWeapon

        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and currentTool.ToolTip == chosen then return end

        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") and tool.ToolTip == chosen then
                    char.Humanoid:EquipTool(tool)
                    return
                end
            end
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.ToolTip == "Blox Fruit") then
                    char.Humanoid:EquipTool(tool)
                    break
                end
            end
        end
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

    -- =========================================================
    -- 🥋 AÇIK KAYNAK OTOMATİK STAT DAĞITICI MOTORU
    -- =========================================================
    task.spawn(function()
        while true do
            task.wait(1.5)
            if Config.AutoStats and CommF_ then
                pcall(function()
                    local points = LocalPlayer.Data.Points.Value
                    if points > 0 then
                        if Config.StatMode == "MeleeDefense" then
                            local half = math.floor(points / 2)
                            CommF_:InvokeServer("AddPoint", "Melee", half)
                            CommF_:InvokeServer("AddPoint", "Defense", points - half)
                        elseif Config.StatMode == "MaxMelee" then
                            CommF_:InvokeServer("AddPoint", "Melee", points)
                        elseif Config.StatMode == "MaxSword" then
                            CommF_:InvokeServer("AddPoint", "Sword", points)
                        end
                    end
                end)
            end
        end
    end)

    -- =========================================================
    -- 🍇 AÇIK KAYNAK MEYVE BULUCU & SUNUCU DEĞİŞTİRİCİ
    -- =========================================================
    local function CheckAnyWorldFruit()
        for _, item in ipairs(Workspace:GetChildren()) do
            if (item:IsA("Tool") or item:IsA("Model")) and item.Name:find("Fruit") then
                local h = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
                if h then return item, h end
            end
        end
        return nil, nil
    end

    task.spawn(function()
        while true do
            task.wait(4)
            if Config.AutoFruitHop then
                pcall(function()
                    local fruit, handle = CheckAnyWorldFruit()
                    if not fruit then
                        warn("🍇 Sunucuda meyve kalmadı! Meyveli sunucu aranıyor...")
                        SafeServerHop()
                    else
                        -- Meyve varsa önce topla
                        local char = LocalPlayer.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if root and handle then
                            StableGlideTo(handle.Position, Config.FruitSpeed)
                            if (handle.Position - root.Position).Magnitude < 12 then
                                firetouchinterest(root, handle, 0)
                                firetouchinterest(root, handle, 1)
                                task.wait(0.5)
                                if CommF_ then CommF_:InvokeServer("StoreFruit", fruit.Name, fruit) end
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- Update 30 Magnet Mob Sweeper
    local function FindMagnetMob()
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, e in ipairs(enemies:GetChildren()) do
                if e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 and e:FindFirstChild("HumanoidRootPart") then
                    local n = e.Name
                    local isMag = n:find("Magnetized") or n:find("Overcharged") or e:GetAttribute("Magnetized") or e:FindFirstChild("MagnetTag") or e:FindFirstChild("Scrap")
                    if isMag then return e end
                end
            end
        end
        return nil
    end

    local sweepIdx = 1
    task.spawn(function()
        while true do
            task.wait()
            if Config.MagnetTokenFarm and not Config.AutoFarm then
                pcall(function()
                    local sea = GetCurrentSea()
                    local route = SeaMagnetRoutes[sea] or SeaMagnetRoutes[1]
                    local magMob = FindMagnetMob()

                    if magMob and magMob:FindFirstChild("HumanoidRootPart") then
                        local targetPos = magMob.HumanoidRootPart.Position + Vector3.new(0, Config.FarmDistance, 0)
                        StableGlideTo(targetPos, Config.MagnetSpeed)
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(LocalPlayer.Character.HumanoidRootPart.Position, magMob.HumanoidRootPart.Position)
                        EquipSelectedWeapon()
                        EnsureBuso()
                        OpenSourceFastAttack(magMob.HumanoidRootPart)
                    else
                        local targetIsland = route[sweepIdx]
                        if targetIsland then
                            local arrived = StableGlideTo(targetIsland + Vector3.new(0, 35, 0), Config.MagnetSpeed)
                            if arrived or (targetIsland - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 100 then
                                task.wait(1.5)
                                if not FindMagnetMob() then
                                    sweepIdx = (sweepIdx % #route) + 1
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- Auto Farm Worker
    task.spawn(function()
        while true do
            task.wait()
            if Config.AutoFarm and not Config.ChestCollector and not Config.TweenFruits and not Config.MagnetTokenFarm and not Config.AutoGoLastIsland then
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
                            local mobRoot = targetMob.HumanoidRootPart
                            local mobPos = mobRoot.Position + Vector3.new(0, Config.FarmDistance, 0)
                            StableGlideTo(mobPos, Config.FarmSpeed)

                            root.CFrame = CFrame.lookAt(root.Position, mobRoot.Position)

                            -- Akıllı Düşük Can Silah Değiştirici
                            if Config.AutoMasteryFinisher then
                                local hpPercent = targetMob.Humanoid.Health / targetMob.Humanoid.MaxHealth
                                if hpPercent <= 0.25 then
                                    EquipSelectedWeapon(Config.MasteryWeapon)
                                else
                                    EquipSelectedWeapon("Melee")
                                end
                            else
                                EquipSelectedWeapon()
                            end

                            EnsureBuso()
                            EnsureKen()
                            OpenSourceFastAttack(mobRoot)

                            if Config.BringMobs and enemies then
                                for _, other in ipairs(enemies:GetChildren()) do
                                    if other ~= targetMob and CleanMobName(other.Name) == questData.Mob and other:FindFirstChild("HumanoidRootPart") and other.Humanoid.Health > 0 then
                                        if (other.HumanoidRootPart.Position - mobRoot.Position).Magnitude < 280 then
                                            other.HumanoidRootPart.CFrame = mobRoot.CFrame
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
            elseif not Config.ChestCollector and not Config.TweenFruits and not Config.MagnetTokenFarm and not Config.AutoGoLastIsland then
                StopGlide()
            end
        end
    end)

    -- Chest Collector Worker
    task.spawn(function()
        while true do
            task.wait(0.05)
            if Config.ChestCollector and not Config.AutoFarm and not Config.MagnetTokenFarm then
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
                                task.wait(0.2)
                            end
                        end
                    else
                        StopGlide()
                    end
                end)
            end
        end
    end)

    -- Mobile ESP Worker
    local ESPFolder = Instance.new("Folder", Workspace)
    ESPFolder.Name = "MorganESP_V28"

    local function AddSimpleTag(part, text, color)
        local b = Instance.new("BillboardGui")
        b.Size = UDim2.new(0, 100, 0, 24)
        b.AlwaysOnTop = true
        b.Adornee = part
        b.StudsOffset = Vector3.new(0, 2.5, 0)
        b.Parent = ESPFolder

        local l = Instance.new("TextLabel", b)
        l.Size = UDim2.fromScale(1, 1)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = color
        l.TextStrokeTransparency = 0
        l.TextSize = 10
        l.Font = Enum.Font.GothamBold
    end

    task.spawn(function()
        while true do
            task.wait(0.8)
            pcall(function()
                ESPFolder:ClearAllChildren()
                local char = LocalPlayer.Character
                local myPos = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position or Vector3.zero

                if Config.PlayerESP then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            local d = math.floor((p.Character.HumanoidRootPart.Position - myPos).Magnitude)
                            AddSimpleTag(p.Character.HumanoidRootPart, p.DisplayName .. " [" .. d .. "m]", Color3.fromRGB(180, 100, 255))
                        end
                    end
                end

                if Config.FruitESP then
                    for _, item in ipairs(Workspace:GetChildren()) do
                        if (item:IsA("Tool") or item:IsA("Model")) and item.Name:find("Fruit") then
                            local h = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
                            if h then
                                local d = math.floor((h.Position - myPos).Magnitude)
                                AddSimpleTag(h, "🍇 " .. item.Name .. " [" .. d .. "m]", Color3.fromRGB(255, 170, 0))
                            end
                        end
                    end
                end

                if Config.BerryESP then
                    for _, bush in ipairs(CollectionService:GetTagged("BerryBush")) do
                        local p = bush:IsA("BasePart") and bush or bush:FindFirstChildWhichIsA("BasePart")
                        if p then
                            local d = math.floor((p.Position - myPos).Magnitude)
                            if d <= 1500 then AddSimpleTag(p, "🍒 Berry [" .. d .. "m]", Color3.fromRGB(255, 75, 120)) end
                        end
                    end
                end

                if Config.ChestESP then
                    local chests = Workspace:FindFirstChild("ChestModels") or Workspace
                    for _, c in ipairs(chests:GetChildren()) do
                        if c.Name:find("Chest") and c:IsA("BasePart") then
                            local d = math.floor((c.Position - myPos).Magnitude)
                            if d <= 1200 then AddSimpleTag(c, "💰 Chest [" .. d .. "m]", Color3.fromRGB(255, 220, 50)) end
                        end
                    end
                end
            end)
        end
    end)

    -- =========================================================
    -- 🎨 MORGAN HUB ANA DASHBOARD ARAYÜZÜ
    -- =========================================================
    local ScreenGui = Instance.new("ScreenGui", CoreGuiContainer)
    ScreenGui.Name = "MorganHubMasterUI"
    ScreenGui.ResetOnSpawn = false

    local ToggleLogo = Instance.new("TextButton", ScreenGui)
    ToggleLogo.Name = "MorganFloatingLogo"
    ToggleLogo.Size = UDim2.fromOffset(46, 46)
    ToggleLogo.Position = UDim2.new(0, 20, 0.25, 0)
    ToggleLogo.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
    ToggleLogo.Text = "🔮"
    ToggleLogo.TextSize = 22
    ToggleLogo.Active = true
    ToggleLogo.Draggable = true
    Instance.new("UICorner", ToggleLogo).CornerRadius = UDim.new(1, 0)
    local LogoStroke = Instance.new("UIStroke", ToggleLogo)
    LogoStroke.Color = Color3.fromRGB(160, 100, 255)
    LogoStroke.Thickness = 1.8

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.fromOffset(780, 460)
    MainFrame.Position = UDim2.new(0.5, -390, 0.5, -230)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 14, 22)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(45, 40, 68)

    ToggleLogo.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

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
    CreateTopBtn("✕", 60, function() ScreenGui:Destroy() end)

    local Sidebar = Instance.new("ScrollingFrame", MainFrame)
    Sidebar.Size = UDim2.new(0, 180, 1, -70)
    Sidebar.Position = UDim2.fromOffset(15, 58)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 2
    Sidebar.ScrollBarImageColor3 = Color3.fromRGB(160, 100, 255)
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.BorderSizePixel = 0

    local SideLayout = Instance.new("UIListLayout", Sidebar)
    SideLayout.Padding = UDim.new(0, 4)

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -225, 1, -60)
    ContentArea.Position = UDim2.fromOffset(205, 46)
    ContentArea.BackgroundColor3 = Color3.fromRGB(19, 17, 28)
    ContentArea.BorderSizePixel = 0
    Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 12)
    local ContentStroke = Instance.new("UIStroke", ContentArea)
    ContentStroke.Color = Color3.fromRGB(38, 32, 56)

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
        TabPages[name] = page
        return page
    end

    local MainPage = RegisterPage("Main")
    local FarmPage = RegisterPage("Farm")
    local OpenSourcePage = RegisterPage("OpenSourceModules")
    local MagnetPage = RegisterPage("MagnetEvent")
    local SeaProgPage = RegisterPage("SeaProgression")
    local FruitPage = RegisterPage("Fruits")
    local ESPPage = RegisterPage("Visuals")

    local firstTab = true
    local function AddNavTab(name, icon, targetPage)
        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(1, -6, 0, 36)
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
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

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
    AddNavTab("OpenSource Ops", "⚡", OpenSourcePage) -- YENİ MODÜLLER
    AddNavTab("Magnet Event (U30)", "🧲", MagnetPage)
    AddNavTab("Sea Progression", "⛵", SeaProgPage)
    AddNavTab("Fruits & Chest", "🍓", FruitPage)
    AddNavTab("Visuals / ESP", "👁️", ESPPage)

    local function CreateToggleCard(parent, title, desc, defaultState, callback)
        local card = Instance.new("Frame", parent)
        card.Size = UDim2.new(1, -6, 0, 52)
        card.BackgroundColor3 = Color3.fromRGB(25, 22, 38)
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", card)
        s.Color = Color3.fromRGB(45, 40, 68)

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
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame", toggleBtn)
        knob.Size = UDim2.fromOffset(16, 16)
        knob.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

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

    -- Dashboard
    local CardsRow = Instance.new("Frame", MainPage)
    CardsRow.Size = UDim2.new(1, 0, 0, 110)
    CardsRow.BackgroundTransparency = 1

    local Banner = Instance.new("Frame", CardsRow)
    Banner.Size = UDim2.new(0.62, 0, 1, 0)
    Banner.BackgroundColor3 = Color3.fromRGB(30, 22, 50)
    Instance.new("UICorner", Banner).CornerRadius = UDim.new(0, 10)

    local bTitle = Instance.new("TextLabel", Banner)
    bTitle.Size = UDim2.new(1, -20, 0, 22)
    bTitle.Position = UDim2.fromOffset(15, 20)
    bTitle.BackgroundTransparency = 1
    bTitle.Text = "Morgan Hub V28 Master"
    bTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    bTitle.Font = Enum.Font.GothamBold
    bTitle.TextSize = 16
    bTitle.TextXAlignment = Enum.TextXAlignment.Left

    local AdminStatus = Instance.new("TextLabel", Banner)
    AdminStatus.Size = UDim2.new(1, -20, 0, 20)
    AdminStatus.Position = UDim2.fromOffset(15, 46)
    AdminStatus.BackgroundTransparency = 1
    AdminStatus.Text = "🛡️ Staff Guard: ACTIVE (Auto-Hop)"
    AdminStatus.TextColor3 = Color3.fromRGB(140, 255, 140)
    AdminStatus.Font = Enum.Font.GothamBold
    AdminStatus.TextSize = 12
    AdminStatus.TextXAlignment = Enum.TextXAlignment.Left

    local UserCard = Instance.new("Frame", CardsRow)
    UserCard.Size = UDim2.new(0.35, 0, 1, 0)
    UserCard.Position = UDim2.new(0.65, 0, 0, 0)
    UserCard.BackgroundColor3 = Color3.fromRGB(25, 22, 38)
    Instance.new("UICorner", UserCard).CornerRadius = UDim.new(0, 10)

    local UserAvatar = Instance.new("ImageLabel", UserCard)
    UserAvatar.Size = UDim2.fromOffset(55, 55)
    UserAvatar.Position = UDim2.new(0, 12, 0.5, -27)
    UserAvatar.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
    UserAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    Instance.new("UICorner", UserAvatar).CornerRadius = UDim.new(1, 0)

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

    CreateToggleCard(MainPage, "Auto Farm Level", "Quest farming with head-hover positioning", Config.AutoFarm, function(v) Config.AutoFarm = v end)
    CreateToggleCard(MainPage, "Auto Fruit Hop", "Auto hops server if no fruits exist in world", Config.AutoFruitHop, function(v) Config.AutoFruitHop = v end)
    CreateToggleCard(MainPage, "Chest Collector (100 Speed)", "Glides through terrain to harvest chests", Config.ChestCollector, function(v) Config.ChestCollector = v end)

    -- Farm Page
    CreateToggleCard(FarmPage, "Auto Farm Level", "Takes quest and attacks from directly above", Config.AutoFarm, function(v) Config.AutoFarm = v end)
    CreateToggleCard(FarmPage, "Ultra Fast Attack", "CombatFramework bypass with zero cooldown", Config.FastAttack, function(v) Config.FastAttack = v end)
    CreateToggleCard(FarmPage, "Mob Magnet", "Clusters all active mobs directly underneath", Config.BringMobs, function(v) Config.BringMobs = v end)
    CreateToggleCard(FarmPage, "Auto Buso Haki", "Hardens armament haki automatically in battle", Config.AutoBuso, function(v) Config.AutoBuso = v end)
    CreateToggleCard(FarmPage, "Auto Ken Haki", "Keeps Observation/Dodge active continuously", Config.AutoKen, function(v) Config.AutoKen = v end)

    -- OpenSource Ops Page (YENİ SİSTEMLER)
    CreateToggleCard(OpenSourcePage, "Auto Fruit Server Hop", "Sunucuda meyve kalmayınca yeni sunucuya atlar", Config.AutoFruitHop, function(v) Config.AutoFruitHop = v end)
    CreateToggleCard(OpenSourcePage, "Auto Allocate Stats", "Puanları otomatik olarak dağıtır", Config.AutoStats, function(v) Config.AutoStats = v end)
    CreateActionBtn(OpenSourcePage, "Mode: 1:1 Melee & Defense", function() Config.StatMode = "MeleeDefense" end)
    CreateActionBtn(OpenSourcePage, "Mode: Max Melee Only", function() Config.StatMode = "MaxMelee" end)
    CreateActionBtn(OpenSourcePage, "Mode: Max Sword Only", function() Config.StatMode = "MaxSword" end)
    CreateToggleCard(OpenSourcePage, "Low HP Mastery Finisher", "Mobun canı %25 olunca kılıç/meyveye geçer", Config.AutoMasteryFinisher, function(v) Config.AutoMasteryFinisher = v end)

    -- Magnet Event Page
    CreateToggleCard(MagnetPage, "Auto Farm Magnet Tokens", "Sweeps islands for [Magnetized] enemies", Config.MagnetTokenFarm, function(v)
        Config.MagnetTokenFarm = v
        if v then Config.AutoFarm = false end
    end)

    -- Sea Progression Page
    CreateToggleCard(SeaProgPage, "Auto Next Sea Progression", "Teleports to next sea at Lv. 700 & Lv. 1500", Config.AutoNextSea, function(v) Config.AutoNextSea = v end)
    CreateToggleCard(SeaProgPage, "Fly to Sea's Final Island", "Fountain (Sea 1), Forgotten (Sea 2), Tiki (Sea 3)", Config.AutoGoLastIsland, function(v)
        Config.AutoGoLastIsland = v
        if v then Config.AutoFarm = false end
    end)
    CreateActionBtn(SeaProgPage, "Direct Fly to Fountain City (Sea 1)", function() StableGlideTo(LastIslands[1].Pos + Vector3.new(0, 35, 0), Config.FarmSpeed) end)
    CreateActionBtn(SeaProgPage, "Direct Fly to Forgotten Island (Sea 2)", function() StableGlideTo(LastIslands[2].Pos + Vector3.new(0, 35, 0), Config.FarmSpeed) end)
    CreateActionBtn(SeaProgPage, "Direct Fly to Tiki Outpost (Sea 3)", function() StableGlideTo(LastIslands[3].Pos + Vector3.new(0, 35, 0), Config.FarmSpeed) end)

    -- Fruits & Chests Page
    CreateToggleCard(FruitPage, "Auto Chest Collector (100 Speed)", "Glides through terrain to claim all server chests", Config.ChestCollector, function(v) Config.ChestCollector = v end)
    CreateToggleCard(FruitPage, "Tween to Spawned Fruits", "Flies directly to uncollected world fruits", Config.TweenFruits, function(v) Config.TweenFruits = v end)
    CreateToggleCard(FruitPage, "Auto Store Fruits", "Secures collected fruits into your fruit bag", Config.AutoStore, function(v) Config.AutoStore = v end)

    -- Visuals Page
    CreateToggleCard(ESPPage, "Player ESP", "Shows player display names and health", Config.PlayerESP, function(v) Config.PlayerESP = v end)
    CreateToggleCard(ESPPage, "Fruit ESP", "Locates spawned devil fruits on map", Config.FruitESP, function(v) Config.FruitESP = v end)
    CreateToggleCard(ESPPage, "Mobile Berry ESP", "Low-lag nearby Berry bushes (Sea 3)", Config.BerryESP, function(v) Config.BerryESP = v end)
    CreateToggleCard(ESPPage, "Chest ESP", "Marks chests across the islands", Config.ChestESP, function(v) Config.ChestESP = v end)
end

-- =============================================================
-- 🔒 KEY GİRİŞİ VEYA DOĞRUDAN BAŞLATICI
-- =============================================================
if CheckSavedKeyStatus() then
    StartMorganHub()
    return
end

-- Key Penceresi
local ScreenGui = Instance.new("ScreenGui", CoreGuiContainer)
ScreenGui.Name = "MorganKeyDialogUI"
ScreenGui.ResetOnSpawn = false

local Dialog = Instance.new("Frame", ScreenGui)
Dialog.Size = UDim2.fromOffset(450, 270)
Dialog.Position = UDim2.new(0.5, -225, 0.5, -135)
Dialog.BackgroundColor3 = Color3.fromRGB(16, 13, 25)
Dialog.BorderSizePixel = 0
Dialog.Active = true
Dialog.Draggable = true
Instance.new("UICorner", Dialog).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", Dialog)
MainStroke.Color = Color3.fromRGB(65, 45, 105)
MainStroke.Thickness = 1.4

local Title = Instance.new("TextLabel", Dialog)
Title.Size = UDim2.new(1, -60, 0, 30)
Title.Position = UDim2.fromOffset(20, 16)
Title.BackgroundTransparency = 1
Title.Text = "🔮 MORGAN HUB | 24H KEY GATEWAY"
Title.TextColor3 = Color3.fromRGB(245, 240, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Dialog)
CloseBtn.Size = UDim2.fromOffset(26, 26)
CloseBtn.Position = UDim2.new(1, -38, 0, 16)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(160, 150, 185)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local ProfileRow = Instance.new("Frame", Dialog)
ProfileRow.Size = UDim2.new(1, -40, 0, 50)
ProfileRow.Position = UDim2.fromOffset(20, 50)
ProfileRow.BackgroundColor3 = Color3.fromRGB(24, 19, 36)
Instance.new("UICorner", ProfileRow).CornerRadius = UDim.new(0, 10)

local Avatar = Instance.new("ImageLabel", ProfileRow)
Avatar.Size = UDim2.fromOffset(38, 38)
Avatar.Position = UDim2.new(0, 8, 0.5, -19)
Avatar.BackgroundColor3 = Color3.fromRGB(38, 30, 56)
Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

local UserGreeting = Instance.new("TextLabel", ProfileRow)
UserGreeting.Size = UDim2.new(1, -60, 0, 20)
UserGreeting.Position = UDim2.fromOffset(54, 8)
UserGreeting.BackgroundTransparency = 1
UserGreeting.Text = "Welcome, " .. LocalPlayer.DisplayName
UserGreeting.TextColor3 = Color3.fromRGB(240, 235, 255)
UserGreeting.Font = Enum.Font.GothamBold
UserGreeting.TextSize = 12
UserGreeting.TextXAlignment = Enum.TextXAlignment.Left

local SubGreeting = Instance.new("TextLabel", ProfileRow)
SubGreeting.Size = UDim2.new(1, -60, 0, 16)
SubGreeting.Position = UDim2.fromOffset(54, 26)
SubGreeting.BackgroundTransparency = 1
SubGreeting.Text = "Keys expire daily at 00:00 UTC."
SubGreeting.TextColor3 = Color3.fromRGB(150, 140, 175)
SubGreeting.Font = Enum.Font.Gotham
SubGreeting.TextSize = 11
SubGreeting.TextXAlignment = Enum.TextXAlignment.Left

local InputBox = Instance.new("TextBox", Dialog)
InputBox.Size = UDim2.new(1, -40, 0, 42)
InputBox.Position = UDim2.fromOffset(20, 112)
InputBox.BackgroundColor3 = Color3.fromRGB(22, 17, 33)
InputBox.PlaceholderText = "Paste today's key (e.g. MGN-XXXX-XXXX-XXXX)..."
InputBox.Text = ""
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.Font = Enum.Font.GothamMedium
InputBox.TextSize = 12
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 8)
local InpStroke = Instance.new("UIStroke", InputBox)
InpStroke.Color = Color3.fromRGB(55, 40, 85)

local GetKeyBtn = Instance.new("TextButton", Dialog)
GetKeyBtn.Size = UDim2.new(0.48, -5, 0, 40)
GetKeyBtn.Position = UDim2.fromOffset(20, 166)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(35, 26, 55)
GetKeyBtn.Text = "🌐 Get Key (Checkpoint)"
GetKeyBtn.TextColor3 = Color3.fromRGB(210, 190, 255)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 12
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(GATEWAY_URL)
        GetKeyBtn.Text = "✓ Link Copied!"
        task.wait(2)
        GetKeyBtn.Text = "🌐 Get Key (Checkpoint)"
    end
end)

local SubmitBtn = Instance.new("TextButton", Dialog)
SubmitBtn.Size = UDim2.new(0.48, -5, 0, 40)
SubmitBtn.Position = UDim2.new(1, -20 - (Dialog.AbsoluteSize.X * 0.48 - 5), 0, 166)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
SubmitBtn.Text = "✓ Check Key"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 12
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

SubmitBtn.MouseButton1Click:Connect(function()
    local entered = InputBox.Text:gsub("%s+", "")
    local todayKey = GetTodayDynamicKey()

    if entered == todayKey then
        SubmitBtn.Text = "✓ Access Granted!"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 100)

        if writefile then
            local curDate = os.date("!*t")
            local saveTable = {
                Key = todayKey,
                Day = curDate.yday,
                Year = curDate.year
            }
            writefile(KEY_SAVE_FILE, HttpService:JSONEncode(saveTable))
        end

        task.wait(0.5)
        StartMorganHub()
    else
        SubmitBtn.Text = "✕ Expired or Invalid!"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(200, 45, 60)
        task.wait(1.5)
        SubmitBtn.Text = "✓ Check Key"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
    end
end)

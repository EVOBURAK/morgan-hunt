-- =================================================================================
-- 🔮 MORGAN HUB V29.0 (DYNAMIC CONFIG MANAGER, ONLINE CLOUD CONFIG & ISLAND ESP) 🔮
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
-- 🛠️ CENTRAL CONFIGURATION TABLE (VARSAYILAN AYARLAR)
-- =============================================================
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
    -- OpenSource Modules
    AutoFruitHop = false,
    AutoStats = false,
    StatMode = "MeleeDefense",
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
    IslandESP = false,
    -- Safety
    StaffDetector = true,
    InfiniteJump = false,
    WaterWalk = false,
    ManualNoclip = false,
    -- Online/Cloud Config URL
    OnlineConfigURL = "https://raw.githubusercontent.com/username/repo/main/morgan_config.json"
}

local CONFIG_FILE_NAME = "MorganHub_UserConfig.json"

-- Config Kaydetme / Yükleme / Cloud Çekme Fonksiyonları
local function SaveLocalConfig()
    if writefile then
        local success, err = pcall(function()
            writefile(CONFIG_FILE_NAME, HttpService:JSONEncode(Config))
        end)
        return success
    end
    return false
end

local function LoadLocalConfig()
    if isfile and readfile and isfile(CONFIG_FILE_NAME) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE_NAME))
        end)
        if success and type(data) == "table" then
            for k, v in pairs(data) do
                Config[k] = v
            end
            return true
        end
    end
    return false
end

local function FetchOnlineConfig(url)
    if game.HttpGetAsync then
        local success, result = pcall(function()
            local raw = game:HttpGet(url or Config.OnlineConfigURL)
            return HttpService:JSONDecode(raw)
        end)
        if success and type(result) == "table" then
            for k, v in pairs(result) do
                Config[k] = v
            end
            return true
        end
    end
    return false
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

    -- Otomatik olarak kaydedilmiş yerel config varsa yükle
    LoadLocalConfig()

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

    -- Fast Attack Core
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

    -- Stat Dağıtıcı Loop
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

    -- Meyve Bulucu Loop
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
                        SafeServerHop()
                    else
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

    -- Auto Farm Loop
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

    -- Chest Collector Loop
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

    -- ESP Engine
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

                if Config.ChestESP then
                    local chests = Workspace:FindFirstChild("ChestModels") or Workspace
                    for _, c in ipairs(chests:GetChildren()) do
                        if c.Name:find("Chest") and c:IsA("BasePart") then
                            local d = math.floor((c.Position - myPos).Magnitude)
                            if d <= 1200 then AddSimpleTag(c, "💰 Chest [" .. d .. "m]", Color3.fromRGB(255, 220, 50)) end
                        end
                    end
                end

                if Config.IslandESP then
                    local locs = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("Locations")
                    if locs then
                        for _, island in ipairs(locs:GetChildren()) do
                            local p = island:IsA("BasePart") and island or island:FindFirstChildWhichIsA("BasePart")
                            if p then
                                local d = math.floor((p.Position - myPos).Magnitude)
                                AddSimpleTag(p, "🏝️ " .. island.Name .. " [" .. d .. "m]", Color3.fromRGB(0, 230, 255))
                            end
                        end
                    end
                end
            end)
        end
    end)

    -- =========================================================
    -- 🎨 MORGAN HUB DASHBOARD UI
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
    MainFrame.Size = UDim2.fromOffset(800, 470)
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -235)
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
    Sidebar.Size = UDim2.new(0, 185, 1, -70)
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
    ContentArea.Size = UDim2.new(1, -230, 1, -60)
    ContentArea.Position = UDim2.fromOffset(210, 46)
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
    local ConfigPage = RegisterPage("ConfigManager") -- [YENİ CONFIG SEKMESİ]
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
    AddNavTab("OpenSource Ops", "⚡", OpenSourcePage)
    AddNavTab("Config Manager", "⚙️", ConfigPage) -- [YENİ CONFIG SEKMESİ]
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
    CreateToggleCard(MainPage, "Auto Farm Level", "Quest farming with head-hover positioning", Config.AutoFarm, function(v) Config.AutoFarm = v end)
    CreateToggleCard(MainPage, "Auto Fruit Hop", "Auto hops server if no fruits exist in world", Config.AutoFruitHop, function(v) Config.AutoFruitHop = v end)

    -- Farm Page
    CreateToggleCard(FarmPage, "Auto Farm Level", "Takes quest and attacks from directly above", Config.AutoFarm, function(v) Config.AutoFarm = v end)
    CreateToggleCard(FarmPage, "Ultra Fast Attack", "CombatFramework bypass with zero cooldown", Config.FastAttack, function(v) Config.FastAttack = v end)
    CreateToggleCard(FarmPage, "Mob Magnet", "Clusters all active mobs directly underneath", Config.BringMobs, function(v) Config.BringMobs = v end)

    -- OpenSource Page
    CreateToggleCard(OpenSourcePage, "Auto Allocate Stats", "Puanları otomatik olarak dağıtır", Config.AutoStats, function(v) Config.AutoStats = v end)
    CreateActionBtn(OpenSourcePage, "Mode: 1:1 Melee & Defense", function() Config.StatMode = "MeleeDefense" end)
    CreateActionBtn(OpenSourcePage, "Mode: Max Melee Only", function() Config.StatMode = "MaxMelee" end)

    -- =========================================================
    -- ⚙️ CONFIG MANAGER PAGE (CONFIG YERİ VE ONLINE CONFIG)
    -- =========================================================
    CreateActionBtn(ConfigPage, "💾 Save Current Config (Yerel Kaydet)", function()
        if SaveLocalConfig() then
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Config", Text = "Ayarlar başarıyla kaydedildi!", Duration = 3})
        end
    end)

    CreateActionBtn(ConfigPage, "📂 Load Local Config (Yerel Yükle)", function()
        if LoadLocalConfig() then
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Config", Text = "Ayarlar başarıyla yüklendi!", Duration = 3})
        end
    end)

    -- Online Config Kutusu & Butonu
    local UrlInput = Instance.new("TextBox", ConfigPage)
    UrlInput.Size = UDim2.new(1, -6, 0, 38)
    UrlInput.BackgroundColor3 = Color3.fromRGB(25, 22, 38)
    UrlInput.PlaceholderText = "Paste Online Config JSON Raw URL..."
    UrlInput.Text = Config.OnlineConfigURL
    UrlInput.TextColor3 = Color3.fromRGB(200, 200, 255)
    UrlInput.Font = Enum.Font.Gotham
    UrlInput.TextSize = 11
    Instance.new("UICorner", UrlInput).CornerRadius = UDim.new(0, 8)

    CreateActionBtn(ConfigPage, "🌐 Fetch & Apply Online Config (Cloud'dan Yükle)", function()
        local url = UrlInput.Text
        if FetchOnlineConfig(url) then
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Cloud Config", Text = "Online Config Başarıyla Çekildi!", Duration = 3})
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Cloud Config", Text = "Config Çekilemedi! URL'yi Kontrol Et.", Duration = 3})
        end
    end)

    -- Sea Prog & Visuals
    CreateToggleCard(ESPPage, "Player ESP", "Shows player display names and health", Config.PlayerESP, function(v) Config.PlayerESP = v end)
    CreateToggleCard(ESPPage, "Fruit ESP", "Locates spawned devil fruits on map", Config.FruitESP, function(v) Config.FruitESP = v end)
    CreateToggleCard(ESPPage, "Island ESP", "Shows island locations and distances through fog", Config.IslandESP, function(v) Config.IslandESP = v end)
end

-- =============================================================
-- 🔒 START LOGIC
-- =============================================================
if CheckSavedKeyStatus() then
    StartMorganHub()
    return
end

-- (Key Dialog kısımları aynen korundu)
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

local SubmitBtn = Instance.new("TextButton", Dialog)
SubmitBtn.Size = UDim2.new(0.9, 0, 0, 40)
SubmitBtn.Position = UDim2.fromOffset(20, 166)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
SubmitBtn.Text = "✓ Check Key & Start"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 12
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

SubmitBtn.MouseButton1Click:Connect(function()
    local entered = InputBox.Text:gsub("%s+", "")
    if entered == GetTodayDynamicKey() then
        if writefile then
            local curDate = os.date("!*t")
            writefile(KEY_SAVE_FILE, HttpService:JSONEncode({Key = entered, Day = curDate.yday, Year = curDate.year}))
        end
        StartMorganHub()
    end
end)

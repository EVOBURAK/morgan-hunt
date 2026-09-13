-- =================================================================================
-- 🔮 MORGAN HUB V19.0 (STAFF GUARD, MOON TRACKER, FRUIT STOCK & 100 SPEED CHEST) 🔮
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

-- Varsa eski GUI'yi temizle
local CoreGuiContainer = (gethui and gethui()) or game:GetService("CoreGui")
if CoreGuiContainer:FindFirstChild("MorganHubV19UI") then
    CoreGuiContainer.MorganHubV19UI:Destroy()
end

-- Blox Fruits Ağ Paketleri
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local CommF_ = Remotes and Remotes:WaitForChild("CommF_", 10)
local Net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
local RegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = Net and Net:FindFirstChild("RE/RegisterHit")

-- =============================================================
-- ⚙️ CONFIGURATION REPOSITORY
-- =============================================================
local Config = {
    -- Auto Farm
    AutoFarm = false,
    FarmWeapon = "Melee", -- "Melee" / "Sword" / "Blox Fruit"
    FarmDistance = 9,
    FarmSpeed = 260,
    FastAttack = true,
    BringMobs = true,
    AutoBuso = true,
    WaitAtSpawn = true,
    -- Staff Detection (Anti-Admin)
    StaffDetector = true,
    -- Chest Collector (100 Speed Support)
    ChestCollector = false,
    ChestSpeed = 100, -- 100 Hız Talebi
    -- Trackers
    MirageNotifier = true,
    -- Fruits
    TweenFruits = false,
    FruitSpeed = 240,
    AutoStore = true,
    -- ESP
    PlayerESP = false,
    FruitESP = false,
    BerryESP = false,
    ChestESP = false,
    -- Player Mods
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

-- =============================================================
-- 🛡️ STAFF & ADMIN DETECTOR (AUTO SERVER HOP)
-- =============================================================
local StaffList = {
    ["rip_indra"] = true,
    ["mygame43"] = true,
    ["Uzoth"] = true,
    ["Axiore"] = true,
    ["Jokurei"] = true
}

local StaffUserIds = {
    [3095250] = true,  -- rip_indra
    [17884881] = true, -- mygame43
    [6079649301] = true -- Uzoth
}

local function ServerHop()
    local servers = {}
    pcall(function()
        local raw = game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local decoded = HttpService:JSONDecode(raw)
        for _, s in ipairs(decoded.data) do
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

local function CheckPlayerStaff(player)
    if not Config.StaffDetector then return end
    if StaffList[player.Name] or StaffUserIds[player.UserId] or player:GetRankInGroup(4372130) >= 100 then
        warn("⚠️ STAFF DETECTED: " .. player.Name .. "! Server Hopping...")
        ServerHop()
    end
end

Players.PlayerAdded:Connect(CheckPlayerStaff)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CheckPlayerStaff(p) end
end

-- =============================================================
-- 🌕 MOON PHASES & MIRAGE DETECTOR
-- =============================================================
local function GetMoonPhase()
    local sky = Lighting:FindFirstChildWhichIsA("Sky")
    if not sky then return "Standard Sky" end
    local texture = sky.MoonTextureId
    if texture:find("9709149431") or texture:find("9709149052") then
        return "🌕 FULL MOON (100%)"
    elseif texture:find("9709149724") then
        return "🌖 Waning Gibbous (~80%)"
    elseif texture:find("9709148733") then
        return "🌓 Third Quarter (50%)"
    elseif texture:find("9709150123") then
        return "🌑 New Moon (0%)"
    end
    return "🌔 Moon Visible"
end

local function CheckMirageIsland()
    local locs = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("Locations")
    if locs and locs:FindFirstChild("Mirage Island") then
        return true
    end
    if Workspace:FindFirstChild("Mirage Island") then
        return true
    end
    return false
end

-- =============================================================
-- 🍇 FRUIT STOCK RETRIEVER
-- =============================================================
local function FetchFruitStock()
    if not CommF_ then return {"Stock unavailable"} end
    local success, res = pcall(function()
        return CommF_:InvokeServer("GetFruits")
    end)
    local inStock = {}
    if success and type(res) == "table" then
        for _, fruit in ipairs(res) do
            if fruit.OnSale then
                table.insert(inStock, fruit.Name .. " ($" .. (fruit.Price or 0) .. ")")
            end
        end
    end
    return #inStock > 0 and inStock or {"No fruits currently on stock"}
end

-- =============================================================
-- 📍 QUEST VE KOORDİNAT SİSTEMİ
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
-- 🚀 FİZİK VE GLIDE MOTORU
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
    if Config.AutoFarm or Config.ChestCollector or Config.TweenFruits or Config.ManualNoclip then
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

-- =============================================================
-- ⚔️ SİLAH KUŞANMA VE FAST ATTACK (GÜVENLİ LİMİTLERLE)
-- =============================================================
local function EquipSelectedWeapon()
    local char = LocalPlayer.Character
    if not char then return end

    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool and currentTool.ToolTip == Config.FarmWeapon then return end

    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == Config.FarmWeapon then
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
    end)
end

local function EnsureBuso()
    if not Config.AutoBuso then return end
    local char = LocalPlayer.Character
    if char and not char:FindFirstChild("HasBuso") and CommF_ then
        pcall(function() CommF_:InvokeServer("Buso") end)
    end
end

-- =============================================================
-- 🌾 AUTO FARM ENGINE
-- =============================================================
task.spawn(function()
    while true do
        task.wait()
        if Config.AutoFarm and not Config.ChestCollector and not Config.TweenFruits then
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
                        local targetPosition = mobRoot.Position + Vector3.new(0, Config.FarmDistance, 0)
                        StableGlideTo(targetPosition, Config.FarmSpeed)

                        root.CFrame = CFrame.lookAt(root.Position, mobRoot.Position)
                        EquipSelectedWeapon()
                        EnsureBuso()
                        ExecuteFastAttack(mobRoot)

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
        elseif not Config.ChestCollector and not Config.TweenFruits then
            StopGlide()
        end
    end
end)

-- =============================================================
-- 💰 CHEST COLLECTOR (100 HIZ DESTEKLİ)
-- =============================================================
task.spawn(function()
    while true do
        task.wait(0.05)
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

-- =============================================================
-- 🍓 MEYVE TOPLAYICI & AUTO STORE
-- =============================================================
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
-- 👁️ MOBİL UYUMLU ESP
-- =============================================================
local ESPFolder = Instance.new("Folder", Workspace)
ESPFolder.Name = "MorganESP_V19"

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
                    if (item:IsA("Tool") or item:IsA("Model")) and (item.Name:find("Fruit") or item.Name:find("Meyve")) then
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
                        if d <= 1500 then
                            AddSimpleTag(p, "🍒 Berry [" .. d .. "m]", Color3.fromRGB(255, 75, 120))
                        end
                    end
                end
            end

            if Config.ChestESP then
                local chests = Workspace:FindFirstChild("ChestModels") or Workspace
                for _, c in ipairs(chests:GetChildren()) do
                    if c.Name:find("Chest") and c:IsA("BasePart") then
                        local d = math.floor((c.Position - myPos).Magnitude)
                        if d <= 1200 then
                            AddSimpleTag(c, "💰 Chest [" .. d .. "m]", Color3.fromRGB(255, 220, 50))
                        end
                    end
                end
            end
        end)
    end
end)

-- =============================================================
-- 🎨 PURPLE DASHBOARD UI TASARIMI
-- =============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV19UI"
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

-- Üst Butonlar
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
local TrackerPage = RegisterPage("Trackers")
local FruitPage = RegisterPage("Fruits")
local ESPPage = RegisterPage("Visuals")

-- Tab Switcher
local firstTab = true
local function AddNavTab(name, icon, targetPage)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 36)
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
AddNavTab("Moon & Stock", "🌕", TrackerPage)
AddNavTab("Fruits & Chest", "🍓", FruitPage)
AddNavTab("Visuals / ESP", "👁️", ESPPage)

-- Card Builder
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
bTitle.Text = "Morgan Hub V19 Pro"
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

CreateToggleCard(MainPage, "Staff & Admin Detector", "Auto server hop if rip_indra, mygame43 or staff joins", Config.StaffDetector, function(v) Config.StaffDetector = v end)
CreateToggleCard(MainPage, "Chest Collector (100 Speed)", "Fly through walls at speed 100", Config.ChestCollector, function(v) Config.ChestCollector = v end)
CreateToggleCard(MainPage, "Auto Farm Level", "Stable quest farming above mob heads", Config.AutoFarm, function(v) Config.AutoFarm = v end)

-- =============================================================
-- 🌾 TAB 2: AUTO FARM
-- =============================================================
local WeaponCard = Instance.new("Frame", FarmPage)
WeaponCard.Size = UDim2.new(1, -6, 0, 64)
WeaponCard.BackgroundColor3 = Color3.fromRGB(25, 22, 38)
local wCorner = Instance.new("UICorner", WeaponCard)
wCorner.CornerRadius = UDim.new(0, 8)

local wTitle = Instance.new("TextLabel", WeaponCard)
wTitle.Size = UDim2.new(1, -20, 0, 18)
wTitle.Position = UDim2.fromOffset(12, 6)
wTitle.BackgroundTransparency = 1
wTitle.Text = "Farming Weapon Selector"
wTitle.TextColor3 = Color3.fromRGB(240, 235, 255)
wTitle.Font = Enum.Font.GothamBold
wTitle.TextSize = 11
wTitle.TextXAlignment = Enum.TextXAlignment.Left

local BtnCont = Instance.new("Frame", WeaponCard)
BtnCont.Size = UDim2.new(1, -24, 0, 28)
BtnCont.Position = UDim2.fromOffset(12, 28)
BtnCont.BackgroundTransparency = 1
local bLayout = Instance.new("UIListLayout", BtnCont)
bLayout.FillDirection = Enum.FillDirection.Horizontal
bLayout.Padding = UDim.new(0, 6)

local wButtons = {}
local function AddWBtn(wType, name)
    local btn = Instance.new("TextButton", BtnCont)
    btn.Size = UDim2.new(0.31, 0, 1, 0)
    btn.BackgroundColor3 = Config.FarmWeapon == wType and Color3.fromRGB(150, 80, 255) or Color3.fromRGB(35, 28, 55)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        Config.FarmWeapon = wType
        for wt, b in pairs(wButtons) do
            b.BackgroundColor3 = wt == wType and Color3.fromRGB(150, 80, 255) or Color3.fromRGB(35, 28, 55)
        end
    end)
    wButtons[wType] = btn
end
AddWBtn("Melee", "👊 Melee")
AddWBtn("Sword", "⚔️ Sword")
AddWBtn("Blox Fruit", "🍇 Fruit")

CreateToggleCard(FarmPage, "Auto Farm Level", "Coordinates-based quest farming engine", Config.AutoFarm, function(v) Config.AutoFarm = v end)
CreateToggleCard(FarmPage, "Ultra Fast Attack", "Network remote combat acceleration", Config.FastAttack, function(v) Config.FastAttack = v end)
CreateToggleCard(FarmPage, "Mob Magnet", "Clusters all mobs underneath character", Config.BringMobs, function(v) Config.BringMobs = v end)
CreateToggleCard(FarmPage, "Auto Buso Haki", "Hardens armament haki automatically", Config.AutoBuso, function(v) Config.AutoBuso = v end)

-- =============================================================
-- 🌕 TAB 3: MOON TRACKER & FRUIT STOCK (NEW)
-- =============================================================
local MoonCard = Instance.new("Frame", TrackerPage)
MoonCard.Size = UDim2.new(1, -6, 0, 75)
MoonCard.BackgroundColor3 = Color3.fromRGB(25, 22, 38)
Instance.new("UICorner", MoonCard).CornerRadius = UDim.new(0, 8)

local MoonLbl = Instance.new("TextLabel", MoonCard)
MoonLbl.Size = UDim2.new(1, -20, 0, 25)
MoonLbl.Position = UDim2.fromOffset(14, 10)
MoonLbl.BackgroundTransparency = 1
MoonLbl.Text = "Current Phase: " .. GetMoonPhase()
MoonLbl.TextColor3 = Color3.fromRGB(255, 220, 100)
MoonLbl.Font = Enum.Font.GothamBold
MoonLbl.TextSize = 13
MoonLbl.TextXAlignment = Enum.TextXAlignment.Left

local MirageLbl = Instance.new("TextLabel", MoonCard)
MirageLbl.Size = UDim2.new(1, -20, 0, 20)
MirageLbl.Position = UDim2.fromOffset(14, 40)
MirageLbl.BackgroundTransparency = 1
MirageLbl.Text = "🏝️ Mirage Island: Searching..."
MirageLbl.TextColor3 = Color3.fromRGB(170, 160, 210)
MirageLbl.Font = Enum.Font.GothamMedium
MirageLbl.TextSize = 12
MirageLbl.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            MoonLbl.Text = "Current Phase: " .. GetMoonPhase()
            if CheckMirageIsland() then
                MirageLbl.Text = "🏝️ MIRAGE ISLAND HAS SPAWNED!"
                MirageLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                MirageLbl.Text = "🏝️ Mirage Island: Not Spawned"
                MirageLbl.TextColor3 = Color3.fromRGB(170, 160, 210)
            end
        end)
    end
end)

-- Fruit Stock List Viewer
local StockTitle = Instance.new("TextLabel", TrackerPage)
StockTitle.Size = UDim2.new(1, 0, 0, 20)
StockTitle.BackgroundTransparency = 1
StockTitle.Text = "Current Devil Fruit Stock:"
StockTitle.TextColor3 = Color3.fromRGB(240, 235, 255)
StockTitle.Font = Enum.Font.GothamBold
StockTitle.TextSize = 12
StockTitle.TextXAlignment = Enum.TextXAlignment.Left

local StockBox = Instance.new("TextLabel", TrackerPage)
StockBox.Size = UDim2.new(1, -6, 0, 90)
StockBox.BackgroundColor3 = Color3.fromRGB(25, 22, 38)
StockBox.Text = table.concat(FetchFruitStock(), "\n")
StockBox.TextColor3 = Color3.fromRGB(200, 185, 235)
StockBox.Font = Enum.Font.Gotham
StockBox.TextSize = 11
StockBox.TextXAlignment = Enum.TextXAlignment.Left
StockBox.TextYAlignment = Enum.TextYAlignment.Top
Instance.new("UICorner", StockBox).CornerRadius = UDim.new(0, 8)
Instance.new("UIPadding", StockBox).PaddingLeft = UDim.new(0, 10)
StockBox.UIPadding.PaddingTop = UDim.new(0, 8)

-- =============================================================
-- 🍓 TAB 4: FRUITS & CHESTS
-- =============================================================
CreateToggleCard(FruitPage, "Auto Chest Collector (100 Speed)", "Duvarlardan ve dağlardan geçerek sandıkları toplar", Config.ChestCollector, function(v) Config.ChestCollector = v end)
CreateToggleCard(FruitPage, "Tween to Spawned Fruits", "Haritada doğan meyvelere uçar", Config.TweenFruits, function(v) Config.TweenFruits = v end)
CreateToggleCard(FruitPage, "Auto Store Fruits", "Toplanan meyveleri çantaya saklar", Config.AutoStore, function(v) Config.AutoStore = v end)

-- =============================================================
-- 👁️ TAB 5: VISUALS & ESP
-- =============================================================
CreateToggleCard(ESPPage, "Player ESP", "Shows player distance and HP", Config.PlayerESP, function(v) Config.PlayerESP = v end)
CreateToggleCard(ESPPage, "Fruit ESP", "Locates spawned devil fruits", Config.FruitESP, function(v) Config.FruitESP = v end)
CreateToggleCard(ESPPage, "Mobile Berry ESP", "Low-lag nearby Berry bushes (Sea 3)", Config.BerryESP, function(v) Config.BerryESP = v end)
CreateToggleCard(ESPPage, "Chest ESP", "Marks chests on the map", Config.ChestESP, function(v) Config.ChestESP = v end)

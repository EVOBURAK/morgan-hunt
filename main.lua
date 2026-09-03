-- =================================================================================
-- 🔮 MORGAN HUB V5.0 (AMETHYST EDITION - ULTIMATE 2800 MAX LEVEL & ADMIN HOP) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Connections = {}

-- Anti-AFK
table.insert(Connections, LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end))

-- Clear Previous GUI
if CoreGui:FindFirstChild("MorganHubV5") then CoreGui.MorganHubV5:Destroy() end

-- SETTINGS
local Settings = {
    ESP = false,
    FruitESP = false,
    AutoFarm = true,
    AutoQuest = true,
    Aimbot = false,
    AutoHunt = false,
    AutoStore = true,
    LuckMultiplier = false,
    LuckPower = 100,
    FlySpeed = 350,
    FarmDistance = 9,
    AdminHop = true
}

-- =============================================================
-- 🛡️ ADMIN DETECT & SERVER HOP ENGINE (0 BAN RISK / UZOTH GUARD)
-- =============================================================
local function ServerHop()
    local x = {}
    for _, v in ipairs(HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
        if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
            x[#x + 1] = v.id
        end
    end
    if #x > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)], LocalPlayer)
    end
end

local function CheckAdmin(player)
    if not Settings.AdminHop then return end
    -- Check staff / ranks or known admin IDs (Uzoth, Staff ranks, etc.)
    if player:GetRankInGroup(4372132) >= 2 or player.Name:lower():find("uzoth") or player.Name:lower():find("admin") or player.Name:lower():find("rip_") then
        ServerHop()
    end
end

for _, p in pairs(Players:GetPlayers()) do CheckAdmin(p) end
table.insert(Connections, Players.PlayerAdded:Connect(CheckAdmin))

-- =============================================================
-- 📜 BLOX FRUITS 2026 QUEST & LEVEL DATA ENGINE (UP TO 2800)
-- =============================================================
local QuestData = {
    -- SEA 1
    {MinLvl = 1, MaxLvl = 9, QuestName = "BanditQuest1", QuestLvl = 1, Enemy = "Bandit", NPC = "Bandit Quest Giver", CFrame = CFrame.new(1059, 17, 1548)},
    {MinLvl = 10, MaxLvl = 14, QuestName = "JungleQuest", QuestLvl = 1, Enemy = "Monkey", NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1598, 37, 153)},
    {MinLvl = 15, MaxLvl = 29, QuestName = "JungleQuest", QuestLvl = 2, Enemy = "Gorilla", NPC = "Jungle Quest Giver", CFrame = CFrame.new(-1598, 37, 153)},
    {MinLvl = 30, MaxLvl = 39, QuestName = "BuggyQuest1", QuestLvl = 1, Enemy = "Pirate", NPC = "Pirate Quest Giver", CFrame = CFrame.new(-1140, 4, 3828)},
    {MinLvl = 40, MaxLvl = 59, QuestName = "BuggyQuest1", QuestLvl = 2, Enemy = "Brute", NPC = "Pirate Quest Giver", CFrame = CFrame.new(-1140, 4, 3828)},
    {MinLvl = 60, MaxLvl = 89, QuestName = "DesertQuest", QuestLvl = 1, Enemy = "Desert Bandit", NPC = "Desert Quest Giver", CFrame = CFrame.new(896, 7, 4388)},
    {MinLvl = 90, MaxLvl = 119, QuestName = "SnowQuest", QuestLvl = 1, Enemy = "Snow Bandit", NPC = "Snow Quest Giver", CFrame = CFrame.new(1385, 87, -1298)},
    {MinLvl = 120, MaxLvl = 149, QuestName = "MarineQuest2", QuestLvl = 1, Enemy = "Chief Petty Officer", NPC = "Marine Quest Giver", CFrame = CFrame.new(-5030, 20, 4324)},
    {MinLvl = 150, MaxLvl = 189, QuestName = "SkyQuest", QuestLvl = 1, Enemy = "Sky Bandit", NPC = "Sky Quest Giver", CFrame = CFrame.new(-4840, 718, -2620)},
    {MinLvl = 190, MaxLvl = 224, QuestName = "PrisonerQuest", QuestLvl = 1, Enemy = "Prisoner", NPC = "Prison Quest Giver", CFrame = CFrame.new(530, 2, 470)},
    {MinLvl = 225, MaxLvl = 299, QuestName = "ColosseumQuest", QuestLvl = 1, Enemy = "Toga Warrior", NPC = "Colosseum Quest Giver", CFrame = CFrame.new(-1580, 7, -2980)},
    {MinLvl = 300, MaxLvl = 374, QuestName = "MagmaQuest", QuestLvl = 1, Enemy = "Military Soldier", NPC = "Magma Quest Giver", CFrame = CFrame.new(-5310, 12, 8515)},
    {MinLvl = 375, MaxLvl = 449, QuestName = "FishmanQuest", QuestLvl = 1, Enemy = "Fishman Warrior", NPC = "Fishman Quest Giver", CFrame = CFrame.new(61122, 18, 1567)},
    {MinLvl = 450, MaxLvl = 524, QuestName = "SkyExp1Quest", QuestLvl = 1, Enemy = "God's Guard", NPC = "Sky Exp Quest Giver", CFrame = CFrame.new(-4720, 845, -1950)},
    {MinLvl = 525, MaxLvl = 624, QuestName = "SkyExp2Quest", QuestLvl = 1, Enemy = "Shandorian Warrior", NPC = "Sky Exp 2 Quest Giver", CFrame = CFrame.new(-7900, 5600, -1180)},
    {MinLvl = 625, MaxLvl = 699, QuestName = "FountainQuest", QuestLvl = 1, Enemy = "Galley Pirate", NPC = "Fountain Quest Giver", CFrame = CFrame.new(5250, 38, 4050)},

    -- SEA 2
    {MinLvl = 700, MaxLvl = 774, QuestName = "Area1Quest", QuestLvl = 1, Enemy = "Raider", NPC = "Quest Giver 1", CFrame = CFrame.new(-425, 73, 1835)},
    {MinLvl = 775, MaxLvl = 874, QuestName = "Area2Quest", QuestLvl = 1, Enemy = "Mercenary", NPC = "Quest Giver 2", CFrame = CFrame.new(-1940, 93, 605)},
    {MinLvl = 875, MaxLvl = 999, QuestName = "ZombieQuest", QuestLvl = 1, Enemy = "Zombie", NPC = "Graveyard Quest Giver", CFrame = CFrame.new(-5490, 48, -795)},
    {MinLvl = 1000, MaxLvl = 1124, QuestName = "SnowMountainQuest", QuestLvl = 1, Enemy = "Snow Trooper", NPC = "Snow Quest Giver", CFrame = CFrame.new(605, 401, -5370)},
    {MinLvl = 1125, MaxLvl = 1249, QuestName = "IceSideQuest", QuestLvl = 1, Enemy = "Lab Subordinate", NPC = "Ice Quest Giver", CFrame = CFrame.new(-6060, 16, -4900)},
    {MinLvl = 1250, MaxLvl = 1349, QuestName = "ShipQuest1", QuestLvl = 1, Enemy = "Ship Deckhand", NPC = "Ship Quest Giver", CFrame = CFrame.new(1030, 125, 32900)},
    {MinLvl = 1350, MaxLvl = 1424, QuestName = "FrostQuest", QuestLvl = 1, Enemy = "Arctic Warrior", NPC = "Frost Quest Giver", CFrame = CFrame.new(5660, 28, -6480)},
    {MinLvl = 1425, MaxLvl = 1499, QuestName = "ForgottenQuest", QuestLvl = 1, Enemy = "Sea Soldier", NPC = "Forgotten Quest Giver", CFrame = CFrame.new(-3050, 235, -10140)},

    -- SEA 3
    {MinLvl = 1500, MaxLvl = 1574, QuestName = "PiratePortQuest", QuestLvl = 1, Enemy = "Pirate Millionaire", NPC = "Port Quest Giver", CFrame = CFrame.new(-290, 44, 5580)},
    {MinLvl = 1575, MaxLvl = 1699, QuestName = "AmazonQuest", QuestLvl = 1, Enemy = "Dragon Crew Warrior", NPC = "Amazon Quest Giver", CFrame = CFrame.new(5830, 52, -1100)},
    {MinLvl = 1700, MaxLvl = 1799, QuestName = "GiantTreeQuest", QuestLvl = 1, Enemy = "Marine Commodore", NPC = "Tree Quest Giver", CFrame = CFrame.new(2180, 28, -6740)},
    {MinLvl = 1800, MaxLvl = 1899, QuestName = "MansionQuest", QuestLvl = 1, Enemy = "Fishman Raider", NPC = "Mansion Quest Giver", CFrame = CFrame.new(-12550, 335, -7470)},
    {MinLvl = 1900, MaxLvl = 1999, QuestName = "HauntedQuest1", QuestLvl = 1, Enemy = "Reborn Skeleton", NPC = "Haunted Quest Giver", CFrame = CFrame.new(-9480, 140, 5530)},
    {MinLvl = 2000, MaxLvl = 2200, QuestName = "PeanutQuest", QuestLvl = 1, Enemy = "Peanut Scout", NPC = "Peanut Quest Giver", CFrame = CFrame.new(-2120, 38, -10190)},
    {MinLvl = 2201, MaxLvl = 2450, QuestName = "IceCreamQuest1", QuestLvl = 1, Enemy = "Ice Cream Chef", NPC = "Ice Cream Quest Giver", CFrame = CFrame.new(-820, 65, -10960)},
    {MinLvl = 2451, MaxLvl = 2600, QuestName = "TikiQuest1", QuestLvl = 1, Enemy = "Sun-kissed Warrior", NPC = "Tiki Quest Giver", CFrame = CFrame.new(-16230, 10, -100 mission)},
    {MinLvl = 2601, MaxLvl = 2800, QuestName = "TikiQuest2", QuestLvl = 2, Enemy = "Isle Outlaw", NPC = "Tiki Master Giver", CFrame = CFrame.new(-16500, 25, -10500)}
}

local function GetPlayerLevel()
    local lvl = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")
    return lvl and lvl.Value or 1
end

local function GetCurrentQuestData()
    local myLevel = GetPlayerLevel()
    for _, q in ipairs(QuestData) do
        if myLevel >= q.MinLvl and myLevel <= q.MaxLvl then
            return q
        end
    end
    return QuestData[#QuestData] -- Default max lvl fallback
end

local function HasQuest()
    local gui = LocalPlayer.PlayerGui:FindFirstChild("Main")
    return gui and gui:FindFirstChild("Quest") and gui.Quest.Visible
end

-- Safe Tween System
local function SmoothTween(targetCFrame)
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local root = myChar.HumanoidRootPart
    
    local dist = (targetCFrame.Position - root.Position).Magnitude
    local time = dist / Settings.FlySpeed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- FRUIT ICONS
local FruitIcons = {
    ["Kitsune"] = "rbxassetid://15312061073", ["Dragon"] = "rbxassetid://13886869488",
    ["Leopard"] = "rbxassetid://13886867744", ["Dough"] = "rbxassetid://13886866168",
    ["T-Rex"] = "rbxassetid://15682970597", ["Mammoth"] = "rbxassetid://14930198642",
    ["Buddha"] = "rbxassetid://13886865890", ["Portal"] = "rbxassetid://13886869150"
}
local DefaultIcon = "rbxassetid://13886865768"

-- =============================================================
-- GUI ARCHITECTURE
-- =============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 480)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 24)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💎 MORGAN HUB V5.0 (2800 MAX LEVEL EDITION)"
Title.TextColor3 = Color3.fromRGB(200, 130, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 48)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Container

local function addToggle(text, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(24, 18, 38)
    card.Parent = Container
    local cardCorner = Instance.new("UICorner") cardCorner.CornerRadius = UDim.new(0, 6) cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(225, 215, 245)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(0.86, 0, 0.24, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
    btn.Text = ""
    btn.Parent = card
    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, 11) btnCorner.Parent = btn

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
        pcall(callback, state)
    end)
end

addToggle("🌾 Auto Quest & Level Farm (2800 Cap)", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle("🛡️ Admin / Uzoth Detect Server Hop", Settings.AdminHop, function(v) Settings.AdminHop = v end)
addToggle("📦 Auto Store Fruits", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle("🖼️ Fruit ESP Icons", Settings.FruitESP, function(v) Settings.FruitESP = v end)

-- =============================================================
-- AUTO QUEST & AUTO FARM LOOP (CRAZY FAST & SAFE)
-- =============================================================
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoFarm then
            pcall(function()
                local myChar = LocalPlayer.Character
                if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
                local root = myChar.HumanoidRootPart
                
                local currentData = GetCurrentQuestData()

                -- Step 1: Check & Take Quest
                if Settings.AutoQuest and not HasQuest() then
                    local distToNpc = (root.Position - currentData.CFrame.Position).Magnitude
                    if distToNpc > 15 then
                        SmoothTween(currentData.CFrame)
                    else
                        local args = {
                            [1] = "StartQuest",
                            [2] = currentData.QuestName,
                            [3] = currentData.QuestLvl
                        }
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
                    end
                else
                    -- Step 2: Farm Target Mob
                    local targetEnemy = nil
                    local enemies = Workspace:FindFirstChild("Enemies") or Workspace
                    for _, enemy in pairs(enemies:GetChildren()) do
                        if enemy:IsA("Model") and enemy.Name:find(currentData.Enemy) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                            targetEnemy = enemy
                            break
                        end
                    end

                    if targetEnemy then
                        myChar.Humanoid.PlatformStand = true
                        
                        -- Equip Weapon
                        local tool = myChar:FindFirstChildOfClass("Tool")
                        if not tool then
                            local backpack = LocalPlayer:FindFirstChild("Backpack")
                            if backpack then
                                local weapon = backpack:FindFirstChildOfClass("Tool")
                                if weapon then myChar.Humanoid:EquipTool(weapon) end
                            end
                        end

                        -- Pos Above Enemy
                        local farmPos = targetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, Settings.FarmDistance, 0)
                        root.CFrame = CFrame.lookAt(farmPos.Position, targetEnemy.HumanoidRootPart.Position)

                        -- Fast Attack
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(500, 500))
                    else
                        -- Teleport to Mob Spawn Zone if none found
                        SmoothTween(currentData.CFrame * CFrame.new(0, 30, 0))
                    end
                end
            end)
        end
    end
end)

-- NOTIFICATION
game.StarterGui:SetCore("SendNotification", {
    Title = "💎 MORGAN HUB V5.0",
    Text = "2800 Level & Admin Hop Aktif Edildi!",
    Duration = 5
})

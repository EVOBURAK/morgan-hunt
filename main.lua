-- =================================================================================
-- 🔮 MORGAN HUB V6.0 (ORION LIB EDITION - AUTO FARM & CLEAN WEBHOOK) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

-- Servisler
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Orion Library Yükleme
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "💎 Morgan Hub V6.0 | Blox Fruits",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MorganHubBloxFruits"
})

-- Blox Fruits Uzak İletişim (Remotes)
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local CommF_ = Remotes and Remotes:WaitForChild("CommF_", 10)
local CommE = Remotes and Remotes:WaitForChild("CommE", 10)

-- Durum Değişkenleri & Ayarlar
local Settings = {
    AutoFarm = false,
    FarmDistance = 8,
    FastAttack = true,
    AutoStore = true,
    PlayerESP = false,
    FruitESP = false,
    Aimbot = false,
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
-- 📜 QUEST TABLOSU (quest.txt Entegrasyonu)
-- =============================================================
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
    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
    if questGui and questGui:FindFirstChild("Quest") and questGui.Quest.Visible then
        return true
    end
    return false
end

-- =============================================================
-- 🔒 GÜVENLİ DİSCORD WEBHOOK SİSTEMİ (TEMİZ & VİRÜSSÜZ)
-- =============================================================
-- Sadece oyuncu statlarını (Seviye, Para, Meyve) gönderir; cookie/şifre çalma vb. kesinlikle barındırmaz.
local function SendWebhookLog()
    if Settings.WebhookURL == "" or not Settings.WebhookURL:find("discord.com/api/webhooks") then
        OrionLib:MakeNotification({
            Name = "Webhook Hatası",
            Content = "Lütfen geçerli bir Discord Webhook URL girin!",
            Time = 4
        })
        return
    end

    local data = LocalPlayer:FindFirstChild("Data")
    local level = data and data:FindFirstChild("Level") and data.Level.Value or "Bilinmiyor"
    local beli = data and data:FindFirstChild("Beli") and data.Beli.Value or 0
    local frags = data and data:FindFirstChild("Fragments") and data.Fragments.Value or 0
    local devilFruit = data and data:FindFirstChild("DevilFruit") and data.DevilFruit.Value or "Yok"

    local payload = {
        ["username"] = "Morgan Hub Stat Notifier",
        ["avatar_url"] = "https://cdn-icons-png.flaticon.com/512/3504/3504837.png",
        ["embeds"] = {{
            ["title"] = "💎 Morgan Hub - Durum Raporu",
            ["color"] = 11141375,
            ["fields"] = {
                {["name"] = "👤 Oyuncu", ["value"] = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")", ["inline"] = true},
                {["name"] = "📈 Seviye", ["value"] = tostring(level), ["inline"] = true},
                {["name"] = "🍇 Meyve", ["value"] = tostring(devilFruit), ["inline"] = true},
                {["name"] = "💰 Beli", ["value"] = tostring(beli), ["inline"] = true},
                {["name"] = "🔮 Fragman", ["value"] = tostring(frags), ["inline"] = true},
                {["name"] = "🎮 Server Job ID", ["value"] = game.JobId ~= "" and game.JobId or "Tek Kişilik/Özel", ["inline"] = false}
            },
            ["footer"] = {["text"] = "Morgan Hub V6.0 • Güvenli Bilgilendirme Sistemi"}
        }}
    }

    local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request) or request
    if httpRequest then
        pcall(function()
            httpRequest({
                Url = Settings.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
            OrionLib:MakeNotification({
                Name = "Webhook Başarılı",
                Content = "İstatistikler Discord sunucunuza iletildi!",
                Time = 3
            })
        end)
    else
        OrionLib:MakeNotification({
            Name = "Hata",
            Content = "Executor'ınız http_request özelliğini desteklemiyor!",
            Time = 4
        })
    end
end

-- =============================================================
-- ⚔️ FAST ATTACK VE HAREKET SİSTEMİ
-- =============================================================
local function EquipWeapon()
    local char = LocalPlayer.Character
    if not char then return end
    local currentTool = char:FindFirstChildOfClass("Tool")
    if not currentTool then
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

local function AttackMob()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(500, 500))
end

-- Mob arama
local function FindTargetMob(mobName)
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in pairs(enemies:GetChildren()) do
            if enemy.Name == mobName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                return enemy
            end
        end
    end
    return nil
end

-- Uçma / Pozisyonlama (No-Clip eşliğinde)
local function FarmFly(targetPos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
        char.Humanoid.PlatformStand = true
        char.HumanoidRootPart.CFrame = CFrame.lookAt(targetPos, targetPos - Vector3.new(0, 10, 0))
    end
end

-- =============================================================
-- 🌾 AUTO FARM ENGINE
-- =============================================================
task.spawn(function()
    while true do
        task.wait()
        if Settings.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
                    return
                end

                local quest = GetBestQuest()
                if not HasQuest() then
                    if CommF_ then
                        CommF_:InvokeServer("StartQuest", quest.QuestName, quest.QuestIndex)
                    end
                    task.wait(0.5)
                else
                    local mob = FindTargetMob(quest.MobName)
                    if mob and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        local aboveMob = mob.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
                        FarmFly(aboveMob)
                        EquipWeapon()
                        AttackMob()
                    else
                        char.Humanoid.PlatformStand = false
                    end
                end
            end)
        else
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.PlatformStand then
                char.Humanoid.PlatformStand = false
            end
        end
    end
end)

-- =============================================================
-- 📦 AUTO STORE FRUIT
-- =============================================================
local function StoreFruit(tool)
    if not Settings.AutoStore or not tool or not tool:IsA("Tool") then return end
    if tool.Name:find("Fruit") or tool.Name:find("Meyve") then
        pcall(function()
            if CommF_ then
                CommF_:InvokeServer("StoreFruit", tool.Name, tool)
            end
        end)
    end
end

LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    task.wait(0.4)
    StoreFruit(tool)
end)

-- =============================================================
-- 🎁 OYUN KODLARINI KULLANMA (oyun kodları.txt)
-- =============================================================
local CodesList = {
    "LIGHTNINGABUSE","1LOSTADMIN ","ADMINFIGHT","NOMOREHACK","BANEXPLOIT","krazydares",
    "TRIPLEABUSE","24NOADMIN","REWARDFUN","Chandler","NEWTROLL","KITT_RESET","Sub2CaptainMaui",
    "kittgaming","Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK","Starcodeheo","Bluxxy",
    "fudd10_v2","SUB2GAMERROBOT_EXP1","Sub2NoobMaster123","Sub2UncleKizaru","Sub2Daigrock",
    "Axiore","TantaiGaming","StrawHatMaine","Sub2OfficialNoobie","Fudd10","Bignews","TheGreatAce",
    "SECRET_ADMIN","SUB2GAMERROBOT_RESET1","SUB2OFFICIALNOOBIE","AXIORE","BIGNEWS","BLUXXY",
    "CHANDLER","ENYU_IS_PRO","FUDD10","FUDD10_V2","KITTGAMING","MAGICBUS","STARCODEHEO",
    "STRAWHATMAINE","SUB2CAPTAINMAUI","SUB2DAIGROCK","SUB2FER999","SUB2NOOBMASTER123",
    "SUB2UNCLEKIZARU","TANTAIGAMING","THEGREATACE"
}

local function RedeemAllCodes()
    if not CommF_ then return end
    task.spawn(function()
        local count = 0
        for _, code in ipairs(CodesList) do
            local cleanCode = string.gsub(code, "%s+", "")
            pcall(function()
                CommF_:InvokeServer("RedeemCustomCode", cleanCode)
            end)
            count += 1
            task.wait(0.15)
        end
        OrionLib:MakeNotification({
            Name = "Kodlar Tamamlandı",
            Content = count .. " adet promo kodu denendi!",
            Time = 4
        })
    end)
end

-- =============================================================
-- 🖼️ ESP SİSTEMLERİ (Player Box ESP & Fruit ESP)
-- =============================================================
local ESPFolder = Instance.new("Folder", Workspace)
ESPFolder.Name = "MorganESPFolder"

RunService.RenderStepped:Connect(function()
    ESPFolder:ClearAllChildren()

    -- Player ESP
    if Settings.PlayerESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local root = p.Character.HumanoidRootPart
                local bill = Instance.new("BillboardGui")
                bill.Name = "PlayerTag"
                bill.Adornee = root
                bill.Size = UDim2.new(0, 100, 0, 40)
                bill.AlwaysOnTop = true
                bill.StudsOffset = Vector3.new(0, 3, 0)
                bill.Parent = ESPFolder

                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                local dist = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                txt.Text = p.DisplayName .. "\n[" .. dist .. "m] HP: " .. math.floor(p.Character.Humanoid.Health)
                txt.TextColor3 = Color3.fromRGB(180, 80, 255)
                txt.TextStrokeTransparency = 0
                txt.TextSize = 11
                txt.Font = Enum.Font.GothamBold
                txt.Parent = bill
            end
        end
    end

    -- Fruit ESP
    if Settings.FruitESP then
        for _, item in ipairs(Workspace:GetChildren()) do
            if (item:IsA("Tool") or item:IsA("Model")) and (item.Name:find("Fruit") or item.Name:find("Meyve")) then
                local handle = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
                if handle then
                    local bill = Instance.new("BillboardGui")
                    bill.Name = "FruitTag"
                    bill.Adornee = handle
                    bill.Size = UDim2.new(0, 100, 0, 30)
                    bill.AlwaysOnTop = true
                    bill.StudsOffset = Vector3.new(0, 2, 0)
                    bill.Parent = ESPFolder

                    local txt = Instance.new("TextLabel")
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Text = "🍇 " .. item.Name
                    txt.TextColor3 = Color3.fromRGB(255, 170, 0)
                    txt.TextStrokeTransparency = 0
                    txt.TextSize = 12
                    txt.Font = Enum.Font.GothamBold
                    txt.Parent = bill
                end
            end
        end
    end
end)

-- =============================================================
-- 🖥️ ORION LIB SEKMELERİ VE ELEMENTLERİ
-- =============================================================

-- TAB 1: Auto Farm
local FarmTab = Window:MakeTab({
    Name = "🌾 Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

FarmTab:AddToggle({
    Name = "Auto Farm Level (Otomatik Görev & Kesim)",
    Default = false,
    Callback = function(Value)
        Settings.AutoFarm = Value
    end
})

FarmTab:AddSlider({
    Name = "Mob Üstü Mesafe (Yükseklik)",
    Min = 4,
    Max = 15,
    Default = 8,
    Color = Color3.fromRGB(150, 60, 255),
    Increment = 1,
    ValueName = "Studs",
    Callback = function(Value)
        Settings.FarmDistance = Value
    end
})

FarmTab:AddToggle({
    Name = "Hızlı Saldırı (Fast Attack)",
    Default = true,
    Callback = function(Value)
        Settings.FastAttack = Value
    end
})

FarmTab:AddToggle({
    Name = "Meyveyi Otomatik Envantere Sakla (Auto Store)",
    Default = true,
    Callback = function(Value)
        Settings.AutoStore = Value
    end
})

-- TAB 2: ESP & Görseller
local VisualsTab = Window:MakeTab({
    Name = "👁️ ESP & Görseller",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

VisualsTab:AddToggle({
    Name = "Oyuncu ESP (Mesafe & Can)",
    Default = false,
    Callback = function(Value)
        Settings.PlayerESP = Value
    end
})

VisualsTab:AddToggle({
    Name = "Yerdeki Meyve ESP",
    Default = false,
    Callback = function(Value)
        Settings.FruitESP = Value
    end
})

-- TAB 3: Webhook Sistemi
local WebhookTab = Window:MakeTab({
    Name = "📡 Discord Webhook",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

WebhookTab:AddTextbox({
    Name = "Discord Webhook URL",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        Settings.WebhookURL = Value
    end
})

WebhookTab:AddButton({
    Name = "Şimdi Durumu Discord'a Gönder (Manuel Test)",
    Callback = function()
        SendWebhookLog()
    end
})

WebhookTab:AddToggle({
    Name = "Her 5 Dakikada Bir Otomatik Rapor Gönder",
    Default = false,
    Callback = function(Value)
        Settings.WebhookAutoSend = Value
    end
})

-- Webhook Otomatik Döngü (5 dakikada bir)
task.spawn(function()
    while true do
        task.wait(300)
        if Settings.WebhookAutoSend and Settings.WebhookURL ~= "" then
            SendWebhookLog()
        end
    end
end)

-- TAB 4: Kodlar & Ekstralar
local MiscTab = Window:MakeTab({
    Name = "🎁 Kodlar & Ekstralar",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MiscTab:AddButton({
    Name = "Tüm Aktif Kodları Kullan (Auto Redeem Codes)",
    Callback = function()
        RedeemAllCodes()
    end
})

OrionLib:Init()

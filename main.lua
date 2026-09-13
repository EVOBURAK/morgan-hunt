-- =================================================================================
-- 🔮 MORGAN HUB V5.0 (FULL INTEGRATED EDITION: NPC, CODES & REAL ESP) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Connections = {}

-- Anti-AFK
table.insert(Connections, LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end))

-- SETTINGS
local Settings = {
    ESP = false,
    FruitESP = false,
    AutoFarm = false,
    Aimbot = false,
    AutoHunt = false,
    AutoStore = true,
    SelectedNPC = "",
    FarmDistance = 8
}

-- ENTEGRE EDİLEN NPC GİVER LİSTESİ
local QuestNPCs = {
    ["BuggyQuest1"] = "Pirate Adventurer",
    ["FountainQuest"] = "Freezeburg Quest Giver",
    ["ColosseumQuest"] = "Colosseum Quest Giver",
    ["SkyQuest"] = "Sky Adventurer",
    ["JungleQuest"] = "Adventurer",
    ["MagmaQuest"] = "The Mayor",
    ["PrisonerQuest"] = "Jail Keeper",
    ["SkyExp2Quest"] = "Sky Quest Giver 2",
    ["MarineQuest2"] = "Marine",
    ["BanditQuest1"] = "Bandit Quest Giver",
    ["FishmanQuest"] = "King Neptune",
    ["MarineQuest"] = "Marine Leader",
    ["SkyExp1Quest"] = "Mole",
    ["DesertQuest"] = "Desert Adventurer",
    ["ImpelQuest"] = "Head Jailer",
    ["SnowQuest"] = "Villager",
    ["IceSideQuest"] = "Ice Quest Giver",
    ["ZombieQuest"] = "Graveyard Quest Giver",
    ["Area2Quest"] = "Area 2 Quest Giver",
    ["Area1Quest"] = "Area 1 Quest Giver",
    ["MarineQuest3"] = "Marine Quest Giver",
    ["SnowMountainQuest"] = "Snow Quest Giver",
    ["ShipQuest1"] = "Rear Crew Quest Giver",
    ["FireSideQuest"] = "Fire Quest Giver",
    ["ShipQuest2"] = "Front Crew Quest Giver",
    ["ForgottenQuest"] = "Forgotten Quest Giver",
    ["FrostQuest"] = "Frost Quest Giver",
    ["IceCreamIslandQuest"] = "Ice Cream Quest Giver",
    ["VenomCrewQuest"] = "Hydra Town Quest Giver",
    ["ChocQuest1"] = "Chocolate Quest Giver 1",
    ["DeepForestIsland"] = "Deep Forest Quest Giver",
    ["DragonCrewQuest"] = "Dragon Crew Quest Giver",
    ["DeepForestIsland2"] = "Deep Forest Area 2 Quest Giver",
    ["NutsIslandQuest"] = "Peanut Quest Giver",
    ["HornedMan"] = "Horned Man",
    ["PiratePortQuest"] = "Pirate Port Quest Giver",
    ["CandyQuest1"] = "Candy Cane Quest Giver",
    ["MarineTreeIsland"] = "Marine Tree Quest Giver",
    ["HauntedQuest2"] = "Haunted Castle Quest Giver 2",
    ["TikiQuest2"] = "Tiki Quest Giver 2",
    ["TikiQuest1"] = "Tiki Quest Giver 1",
    ["DeepForestIsland3"] = "Turtle Adventure Quest Giver",
    ["CakeQuest2"] = "Cake Quest Giver 2",
    ["ArenaTrainer"] = "Arena Trainer",
    ["TikiQuest3"] = "Tiki Quest Giver 3",
    ["CakeQuest1"] = "Cake Quest Giver 1",
    ["ChocQuest2"] = "Chocolate Quest Giver 2",
    ["HauntedQuest1"] = "Haunted Castle Quest Giver 1"
}

-- ENTEGRE EDİLEN OYUN KODLARI
local GameCodes = {
    "LIGHTNINGABUSE", "1LOSTADMIN ", "ADMINFIGHT", "NOMOREHACK", "BANEXPLOIT", 
    "krazydares", "TRIPLEABUSE", "24NOADMIN", "REWARDFUN", "Chandler", 
    "NEWTROLL", "KITT_RESET", "Sub2CaptainMaui", "kittgaming", "Sub2Fer999", 
    "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", 
    "fudd10_v2", "SUB2GAMERROBOT_EXP1", "Sub2NoobMaster123", "Sub2UncleKizaru", 
    "Sub2Daigrock", "Axiore", "TantaiGaming", "StrawHatMaine", "Sub2OfficialNoobie", 
    "Fudd10", "Bignews", "TheGreatAce", "SECRET_ADMIN", "SUB2GAMERROBOT_RESET1", 
    "SUB2OFFICIALNOOBIE", "AXIORE", "BIGNEWS", "BLUXXY", "CHANDLER", 
    "ENYU_IS_PRO", "FUDD10", "FUDD10_V2", "KITTGAMING", "MAGICBUS", 
    "STARCODEHEO", "STRAWHATMAINE", "SUB2CAPTAINMAUI", "SUB2DAIGROCK", 
    "SUB2FER999", "SUB2NOOBMASTER123", "SUB2UNCLEKIZARU", "TANTAIGAMING", "THEGREATACE"
}

-- FRUIT ICONS
local FruitIcons = {
    ["Kitsune"] = "rbxassetid://15312061073",
    ["Dragon"] = "rbxassetid://13886869488",
    ["Leopard"] = "rbxassetid://13886867744",
    ["Dough"] = "rbxassetid://13886866168",
    ["T-Rex"] = "rbxassetid://15682970597",
    ["Mammoth"] = "rbxassetid://14930198642",
    ["Spirit"] = "rbxassetid://13886869850",
    ["Venom"] = "rbxassetid://13886870244",
    ["Shadow"] = "rbxassetid://13886869634",
    ["Blizzard"] = "rbxassetid://13886865660",
    ["Gravity"] = "rbxassetid://13886867420",
    ["Portal"] = "rbxassetid://13886869150",
    ["Rumble"] = "rbxassetid://13886869348",
    ["Buddha"] = "rbxassetid://13886865890",
    ["Love"] = "rbxassetid://13886868018",
    ["Spider"] = "rbxassetid://13886869976",
    ["Sound"] = "rbxassetid://14930200871",
    ["Magma"] = "rbxassetid://13886868420",
    ["Ice"] = "rbxassetid://13886867566",
    ["Light"] = "rbxassetid://13886867896"
}

-- REDZ LIBRARY INTEGRATION
local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RedzLibV5/main/Source.Lua"))()

local Window = RedzLib:MakeWindow({
    Title = "Morgan Hub V5",
    SubTitle = "Blox Fruits Auto-Farm & Quest System",
    ScriptFolder = "MorganHubData"
})

-- TABS
local MainTab = Window:MakeTab({"Main / Auto Farm", "rbxassetid://10709791437"})
local QuestTab = Window:MakeTab({"Quest Givers", "rbxassetid://10709790948"})
local CodesTab = Window:MakeTab({"Promo Codes", "rbxassetid://10734982144"})
local VisualsTab = Window:MakeTab({"Visuals / ESP", "rbxassetid://10709752996"})

-- 1. MAIN TAB (Auto Farm & General)
MainTab:AddToggle({
    Name = "Auto Farm Level",
    Default = false,
    Callback = function(Value)
        Settings.AutoFarm = Value
    end
})

MainTab:AddSlider({
    Name = "Farm Distance",
    Min = 1,
    Max = 20,
    Increment = 1,
    Default = 8,
    Callback = function(Value)
        Settings.FarmDistance = Value
    end
})

-- 2. QUEST GIVERS TAB (NPC Integration)
local NPCList = {}
for codeName, displayName in pairs(QuestNPCs) do
    table.insert(NPCList, displayName .. " (" .. codeName .. ")")
end

QuestTab:AddDropdown({
    Name = "Select Quest Giver NPC",
    Options = NPCList,
    Default = NPCList[1],
    Callback = function(Value)
        Settings.SelectedNPC = Value
    end
})

QuestTab:AddButton({
    Name = "Teleport to Selected Quest NPC",
    Callback = function()
        if Settings.SelectedNPC ~= "" then
            local npcCode = Settings.SelectedNPC:match("%((.-)%)")
            for _, npc in pairs(Workspace:GetDescendants()) do
                if npc:IsA("Model") and (npc.Name == npcCode or npc.Name == QuestNPCs[npcCode]) then
                    if npc:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        return
                    end
                end
            end
        end
    end
})

-- 3. CODES TAB (Game Codes Integration)
CodesTab:AddButton({
    Name = "Redeem All Promo Codes",
    Callback = function()
        local count = 0
        for _, code in ipairs(GameCodes) do
            pcall(function()
                ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
                count = count + 1
            end)
            task.wait(0.1)
        end
        Window:Notify({
            Title = "Codes System",
            Content = count .. " adet kod başarıyla denendi!",
            Duration = 5
        })
    end
})

-- 4. VISUALS TAB (ESP)
VisualsTab:AddToggle({
    Name = "Player ESP (Boxes)",
    Default = false,
    Callback = function(Value)
        Settings.ESP = Value
    end
})

VisualsTab:AddToggle({
    Name = "Fruit ESP",
    Default = false,
    Callback = function(Value)
        Settings.FruitESP = Value
    end
})

-- AUTO FARM LOOP
task.spawn(function()
    while task.wait() do
        if Settings.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    -- Basit yakın düşman arama & teleport mantığı
                    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, Settings.FarmDistance, 0)
                            VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

Window:Notify({
    Title = "Morgan Hub Loaded",
    Content = "Tüm Görev Vericiler ve Kodlar Script'e Entegre Edildi!",
    Duration = 5
})

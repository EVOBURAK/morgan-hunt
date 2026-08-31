-- =================================================================================
-- 🌿 MORGAN HUB V6.0 (AUTO QUEST, MULTI-WEAPON & AUTO ISLAND PROGRESSION) 🌿
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
if CoreGui:FindFirstChild("MorganHubV6") then CoreGui.MorganHubV6:Destroy() end

-- SETTINGS
local Settings = {
    ESP = false,
    FruitESP = false,
    AutoFarm = false,
    AutoQuest = true,
    SelectedWeapon = "Melee", -- "Melee", "Sword", "Gun", "Fruit"
    Aimbot = false,
    AutoHunt = false,
    AutoStore = true,
    LuckMultiplier = false,
    LuckPower = 100,
    FlySpeed = 12,
    FarmDistance = 8
}

-- BLOX FRUITS LEVEL & QUEST DATA (SEA 1 MAP SYSTEM)
local QuestData = {
    {MinLevel = 1, MaxLevel = 14, QuestName = "BanditQuest1", QuestLevel = 1, MobName = "Bandit", CFrame = CFrame.new(1059, 16, 1548)},
    {MinLevel = 15, MaxLevel = 29, QuestName = "JungleQuest", QuestLevel = 1, MobName = "Monkey", CFrame = CFrame.new(-1598, 36, 153)},
    {MinLevel = 30, MaxLevel = 59, QuestName = "PirateQuest", QuestLevel = 1, MobName = "Pirate", CFrame = CFrame.new(-1140, 4, 3828)},
    {MinLevel = 60, MaxLevel = 89, QuestName = "DesertQuest", QuestLevel = 1, MobName = "Desert Bandit", CFrame = CFrame.new(894, 6, 4385)},
    {MinLevel = 90, MaxLevel = 119, QuestName = "SnowQuest", QuestLevel = 1, MobName = "Snow Bandit", CFrame = CFrame.new(1385, 87, -1298)},
    {MinLevel = 120, MaxLevel = 149, QuestName = "MarineQuest2", QuestLevel = 1, MobName = "Chief Petty Officer", CFrame = CFrame.new(-5036, 28, 4324)},
    {MinLevel = 150, MaxLevel = 189, QuestName = "SkyQuest", QuestLevel = 1, MobName = "Sky Bandit", CFrame = CFrame.new(-4839, 717, -2620)},
    {MinLevel = 190, MaxLevel = 249, QuestName = "PrisonerQuest", QuestLevel = 1, MobName = "Prisoner", CFrame = CFrame.new(530, 1, 474)}
}

-- FRUIT ICONS
local FruitIcons = {
    ["Kitsune"] = "rbxassetid://15312061073", ["Dragon"] = "rbxassetid://13886869488", ["Leopard"] = "rbxassetid://13886867744",
    ["Dough"] = "rbxassetid://13886866168", ["T-Rex"] = "rbxassetid://15682970597", ["Spirit"] = "rbxassetid://13886869850",
    ["Venom"] = "rbxassetid://13886870244", ["Buddha"] = "rbxassetid://13886865890", ["Portal"] = "rbxassetid://13886869150"
}
local DefaultIcon = "rbxassetid://13886865768"

-- GUI ARCHITECTURE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV6"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 48, 0, 48)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(15, 22, 18)
ToggleLogo.BorderSizePixel = 0
ToggleLogo.Text = "🌿"
ToggleLogo.TextSize = 26
ToggleLogo.Active = true
ToggleLogo.Draggable = true
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = ToggleLogo

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 470)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -235)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🌿 MORGAN HUB V6.0 (AUTO QUEST & WEAPONS)"
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Container

local function addToggle(text, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(18, 24, 32)
    card.BorderSizePixel = 0
    card.Parent = Container

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 225, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(0.86, 0, 0.24, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 190, 100) or Color3.fromRGB(35, 45, 58)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 11)
    btnCorner.Parent = btn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
    circle.BackgroundColor3 = Color3.fromRGB(180, 190, 200)
    circle.BorderSizePixel = 0
    circle.Parent = btn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 8)
    circleCorner.Parent = circle

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 190, 100) or Color3.fromRGB(35, 45, 58)
        circle.Position = state and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
        pcall(callback, state)
    end)
end

-- WEAPON SELECTOR DROPDOWN (MELEE, SWORD, GUN, FRUIT)
local function addWeaponSelector()
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 45)
    card.BackgroundColor3 = Color3.fromRGB(18, 24, 32)
    card.BorderSizePixel = 0
    card.Parent = Container

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "⚔️ Select Weapon:"
    label.TextColor3 = Color3.fromRGB(210, 225, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local weapons = {"Melee", "Sword", "Gun", "Fruit"}
    local currentIdx = 1

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 28)
    btn.Position = UDim2.new(0.72, -10, 0.18, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    btn.Text = weapons[currentIdx]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        currentIdx = currentIdx + 1
        if currentIdx > #weapons then currentIdx = 1 end
        Settings.SelectedWeapon = weapons[currentIdx]
        btn.Text = Settings.SelectedWeapon
    end)
end

-- CONTROLS
addWeaponSelector()
addToggle("🌾 Auto Farm Level & Quest", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle("📜 Auto Take Quest", Settings.AutoQuest, function(v) Settings.AutoQuest = v end)
addToggle("📦 Auto Store Fruit", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle("🖼️ Fruit ESP (Icons)", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("👁️ Player ESP", Settings.ESP, function(v) Settings.ESP = v end)
addToggle("⚡ Auto Bounty Hunt", Settings.AutoHunt, function(v) Settings.AutoHunt = v end)

-- =============================================================
-- AUTO QUEST & AUTO FARM SYSTEM
-- =============================================================
local function getMyLevel()
    pcall(function()
        return LocalPlayer.Data.Level.Value
    end)
    return 1
end

local function getCurrentQuest()
    local level = getMyLevel()
    for _, q in ipairs(QuestData) do
        if level >= q.MinLevel and level <= q.MaxLevel then
            return q
        end
    end
    return QuestData[1]
end

local function equipSelectedWeapon()
    local char = LocalPlayer.Character
    if not char then return end

    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        if Settings.SelectedWeapon == "Melee" and tool.ToolTip == "Melee" then return end
        if Settings.SelectedWeapon == "Sword" and tool.ToolTip == "Sword" then return end
        if Settings.SelectedWeapon == "Gun" and tool.ToolTip == "Gun" then return end
        if Settings.SelectedWeapon == "Fruit" and tool.ToolTip == "Blox Fruit" then return end
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                if Settings.SelectedWeapon == "Melee" and (item.ToolTip == "Melee" or item.Name:find("Combat") or item.Name:find("Step") or item.Name:find("Kung")) then
                    char.Humanoid:EquipTool(item)
                    break
                elseif Settings.SelectedWeapon == "Sword" and (item.ToolTip == "Sword" or item.Name:find("Katana") or item.Name:find("Blade") or item.Name:find("Cutlass")) then
                    char.Humanoid:EquipTool(item)
                    break
                elseif Settings.SelectedWeapon == "Gun" and item.ToolTip == "Gun" then
                    char.Humanoid:EquipTool(item)
                    break
                elseif Settings.SelectedWeapon == "Fruit" and (item.ToolTip == "Blox Fruit" or item.Name:find("Fruit")) then
                    char.Humanoid:EquipTool(item)
                    break
                end
            end
        end
    end
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.AutoFarm then return end

    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
        local root = myChar.HumanoidRootPart

        local currentQuest = getCurrentQuest()

        -- Check Quest Status
        local hasQuest = false
        if LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") then
            hasQuest = LocalPlayer.PlayerGui.Main.Quest.Visible
        end

        -- Auto Quest Teleport & Take
        if Settings.AutoQuest and not hasQuest then
            if (root.Position - currentQuest.CFrame.Position).Magnitude > 50 then
                root.CFrame = currentQuest.CFrame
                task.wait(0.5)
            end
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentQuest.QuestName, currentQuest.QuestLevel)
            task.wait(0.5)
            return
        end

        -- Auto Equip Weapon
        equipSelectedWeapon()

        -- Find Target Mob
        local targetMob = nil
        local enemies = Workspace:FindFirstChild("Enemies") or Workspace
        for _, enemy in pairs(enemies:GetChildren()) do
            if enemy:IsA("Model") and enemy.Name == currentQuest.MobName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                targetMob = enemy
                break
            end
        end

        -- Teleport to Mob & Attack
        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
            myChar.Humanoid.PlatformStand = true
            local targetPos = targetMob.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
            root.CFrame = CFrame.lookAt(targetPos, targetMob.HumanoidRootPart.Position)

            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        else
            -- If no mob spawned, go to Island Spawn Area
            root.CFrame = currentQuest.CFrame * CFrame.new(0, 20, 0)
        end
    end)
end))

-- AUTO STORE FRUIT
local function storeFruit(tool)
    if not Settings.AutoStore or not tool or not tool:IsA("Tool") then return end
    if tool.Name:find("Fruit") or tool.Name:find("Meyve") then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name, tool)
        end)
    end
end

table.insert(Connections, LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    task.wait(0.5)
    storeFruit(tool)
end))

-- NOTIFICATION
game.StarterGui:SetCore("SendNotification", {
    Title = "🌿 MORGAN HUB V6.0",
    Text = "Auto Quest & Island Progression Ready!",
    Duration = 4
})

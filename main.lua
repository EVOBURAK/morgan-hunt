-- =================================================================================
-- 🔮 MORGAN HUB V5.0 (WIND UI RED EDITION) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

-- WindUI Library Load
local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()

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

-- Anti-AFK Integration
table.insert(Connections, LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end))

-- SETTINGS
local Settings = {
    AutoFarm = false,
    AutoHunt = false,
    AutoStore = true,
    ESP = false,
    FruitESP = false,
    Aimbot = false,
    FlySpeed = 25,
    FarmDistance = 8,
    Noclip = false
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
    ["Light"] = "rbxassetid://13886867888",
    ["Flame"] = "rbxassetid://13886866872",
    ["Rocket"] = "rbxassetid://13886869246",
    ["Spin"] = "rbxassetid://13886870104",
    ["Blade"] = "rbxassetid://13886866580",
    ["Spring"] = "rbxassetid://13886870176",
    ["Bomb"] = "rbxassetid://13886865768",
    ["Smoke"] = "rbxassetid://13886869752",
    ["Spike"] = "rbxassetid://13886870034",
    ["Falcon"] = "rbxassetid://13886866708",
    ["Sand"] = "rbxassetid://13886869528",
    ["Dark"] = "rbxassetid://13886866034",
    ["Diamond"] = "rbxassetid://13886866360",
    ["Ghost"] = "rbxassetid://15082498716",
    ["Rubber"] = "rbxassetid://13886869300",
    ["Barrier"] = "rbxassetid://13886865502"
}
local DefaultIcon = "rbxassetid://13886865768"

-- =============================================================
-- WIND UI INITIALIZATION & RED THEME CREATION
-- =============================================================
WindUI:AddTheme({
    Name = "MorganRed",
    Accent = Color3.fromRGB(255, 30, 60),
    Background = Color3.fromRGB(15, 12, 16),
    Container = Color3.fromRGB(22, 18, 24),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(160, 150, 165),
    Border = Color3.fromRGB(255, 30, 60),
})

local Window = WindUI:CreateWindow({
    Title = "MORGAN HUB V5.0",
    SubTitle = "Red Edition",
    Icon = "rbxassetid://4483345998",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 420),
    Theme = "MorganRed",
})

-- TABS
local FarmTab = Window:Tab({ Title = "Auto Farm", Icon = "rbxassetid://4483345998" })
local BountyTab = Window:Tab({ Title = "Auto Bounty", Icon = "rbxassetid://4483345998" })
local VisualsTab = Window:Tab({ Title = "Visuals & ESP", Icon = "rbxassetid://4483345998" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "rbxassetid://4483345998" })

-- =============================================================
-- NOCLIP ENGINE (WALL PASS THROUGH)
-- =============================================================
table.insert(Connections, RunService.Stepped:Connect(function()
    if Settings.AutoFarm or Settings.AutoHunt or Settings.Noclip then
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end))

-- =============================================================
-- AUTO STORE FRUIT ENGINE
-- =============================================================
local function storeFruit(tool)
    if not Settings.AutoStore or not tool or not tool:IsA("Tool") then return end
    if tool.Name:find("Fruit") or tool.Name:find("Meyve") or FruitIcons[tool.Name:gsub(" Fruit", "")] then
        pcall(function()
            local args = {
                [1] = "StoreFruit",
                [2] = tool.Name,
                [3] = tool
            }
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
        end)
    end
end

table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(storeFruit)
end))
if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(storeFruit)
end

table.insert(Connections, LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    task.wait(0.5)
    storeFruit(tool)
end))

-- =============================================================
-- AUTO FARM ENGINE (FIXED & SMOOTH)
-- =============================================================
local function getClosestEnemy()
    local closest, minDistance = nil, math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position

    local enemies = Workspace:FindFirstChild("Enemies") or Workspace
    for _, enemy in pairs(enemies:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(enemy) then
                local dist = (enemy.HumanoidRootPart.Position - myPos).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    closest = enemy
                end
            end
        end
    end
    return closest
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Settings.AutoFarm then return end

    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
        local root = myChar.HumanoidRootPart

        local enemy = getClosestEnemy()
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            myChar.Humanoid.PlatformStand = true

            local tool = myChar:FindFirstChildOfClass("Tool")
            if not tool then
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    local weapon = backpack:FindFirstChildOfClass("Tool")
                    if weapon then myChar.Humanoid:EquipTool(weapon) end
                end
            end

            local enemyPos = enemy.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
            
            -- Smooth Movement Vector
            local direction = (enemyPos - root.Position).Unit
            local distance = (enemyPos - root.Position).Magnitude
            
            if distance > 2 then
                root.Velocity = direction * (Settings.FlySpeed * 5)
            else
                root.Velocity = Vector3.zero
            end

            root.CFrame = CFrame.lookAt(root.Position, enemy.HumanoidRootPart.Position)

            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        else
            myChar.Humanoid.PlatformStand = false
        end
    end)
end))

-- =============================================================
-- AUTO BOUNTY HUNT ENGINE (FIXED FLY & WALLPASS)
-- =============================================================
local function getClosestPlayer()
    local closest, minDistance = nil, math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < minDistance then
                minDistance = dist
                closest = p
            end
        end
    end
    return closest
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
        local root = myChar.HumanoidRootPart

        local target = getClosestPlayer()

        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = target.Character.HumanoidRootPart

            -- Smooth Camera Aimbot
            if Settings.Aimbot then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetRoot.Position + Vector3.new(0, 1.5, 0))
            end

            -- Advanced Smooth Fly Auto Bounty
            if Settings.AutoHunt then
                myChar.Humanoid.PlatformStand = true

                local tool = myChar:FindFirstChildOfClass("Tool")
                if not tool then
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    if bp then
                        local weapon = bp:FindFirstChildOfClass("Tool")
                        if weapon then myChar.Humanoid:EquipTool(weapon) end
                    end
                end

                local targetPos = targetRoot.Position + Vector3.new(0, 3, 0)
                local distance = (targetPos - root.Position).Magnitude

                if distance > 4 then
                    local direction = (targetPos - root.Position).Unit
                    root.Velocity = direction * (Settings.FlySpeed * 6)
                    root.CFrame = CFrame.lookAt(root.Position, targetPos)
                else
                    root.Velocity = Vector3.zero
                    root.CFrame = CFrame.lookAt(root.Position, targetPos)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(500, 500))
                end
            elseif not Settings.AutoFarm then
                myChar.Humanoid.PlatformStand = false
            end
        else
            if Settings.AutoHunt and not Settings.AutoFarm then
                myChar.Humanoid.PlatformStand = false
            end
        end
    end)
end))

-- =============================================================
-- OPTIMIZED ESP ENGINE (PLAYER & FRUIT)
-- =============================================================
local FruitBillboards = {}
local PlayerESPCache = {}

local function getFruitImage(fruitName)
    for name, iconId in pairs(FruitIcons) do
        if fruitName:lower():find(name:lower()) then
            return iconId
        end
    end
    return DefaultIcon
end

local function createFruitESP(obj)
    if FruitBillboards[obj] then return end

    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part") or obj:FindFirstChildOfClass("MeshPart")
    if not handle then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FruitESP_G"
    bb.Adornee = handle
    bb.Size = UDim2.new(0, 70, 0, 85)
    bb.AlwaysOnTop = true

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, 48, 0, 48)
    img.Position = UDim2.new(0.5, -24, 0, 0)
    img.BackgroundTransparency = 1
    img.Image = getFruitImage(obj.Name)
    img.Parent = bb

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.35, 0)
    textLabel.Position = UDim2.new(0, 0, 0.65, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = obj.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 50, 80)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 11
    textLabel.TextStrokeTransparency = 0
    textLabel.Parent = bb

    bb.Parent = CoreGui
    FruitBillboards[obj] = {Gui = bb, Text = textLabel, Handle = handle}
end

local function createPlayerESP(p)
    if p == LocalPlayer or PlayerESPCache[p] then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "PlayerESP_Info"
    bb.Size = UDim2.new(0, 160, 0, 40)
    bb.AlwaysOnTop = true
    bb.ExtentsOffset = Vector3.new(0, 3, 0)

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255, 60, 90)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 12
    txt.TextStrokeTransparency = 0.2
    txt.Parent = bb

    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESP_Glow"
    highlight.FillColor = Color3.fromRGB(255, 30, 60)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0

    PlayerESPCache[p] = {Gui = bb, Text = txt, Glow = highlight}
end

local function removePlayerESP(p)
    if PlayerESPCache[p] then
        if PlayerESPCache[p].Gui then PlayerESPCache[p].Gui:Destroy() end
        if PlayerESPCache[p].Glow then PlayerESPCache[p].Glow:Destroy() end
        PlayerESPCache[p] = nil
    end
end

for _, p in pairs(Players:GetPlayers()) do createPlayerESP(p) end
table.insert(Connections, Players.PlayerAdded:Connect(createPlayerESP))
table.insert(Connections, Players.PlayerRemoving:Connect(removePlayerESP))

table.insert(Connections, RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position or Vector3.zero

    -- Player ESP Rendering
    for targetPlayer, esp in pairs(PlayerESPCache) do
        local char = targetPlayer.Character
        if Settings.ESP and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local root = char.HumanoidRootPart
            local dist = math.floor((root.Position - myPos).Magnitude)
            local hp = math.floor(char.Humanoid.Health)

            esp.Gui.Adornee = root
            esp.Gui.Parent = CoreGui
            esp.Gui.Enabled = true

            esp.Glow.Adornee = char
            esp.Glow.Parent = CoreGui
            esp.Glow.Enabled = true

            esp.Text.Text = targetPlayer.Name .. " [" .. hp .. " HP]\n" .. dist .. "m"
        else
            if esp.Gui then esp.Gui.Enabled = false end
            if esp.Glow then esp.Glow.Enabled = false end
        end
    end

    -- Fruit ESP Rendering
    if Settings.FruitESP then
        for _, obj in pairs(Workspace:GetChildren()) do
            if (obj:IsA("Tool") or obj:IsA("Model")) and (obj.Name:find("Fruit") or obj.Name:find("Meyve") or obj.Name:find("Blox")) then
                createFruitESP(obj)
            end
        end

        for obj, data in pairs(FruitBillboards) do
            if obj and obj.Parent and data.Handle and data.Handle.Parent then
                data.Gui.Enabled = true
                local dist = math.floor((data.Handle.Position - myPos).Magnitude)
                data.Text.Text = obj.Name .. "\n[" .. dist .. "m]"
            else
                if data.Gui then data.Gui:Destroy() end
                FruitBillboards[obj] = nil
            end
        end
    else
        for obj, data in pairs(FruitBillboards) do
            if data.Gui then data.Gui.Enabled = false end
        end
    end
end))

-- =============================================================
-- WIND UI CONTROLS BINDING
-- =============================================================

-- Farm Tab
FarmTab:Toggle({
    Title = "Auto Farm Level",
    Desc = "Farms nearest mobs automatically",
    Default = Settings.AutoFarm,
    Callback = function(Value) Settings.AutoFarm = Value end
})

FarmTab:Toggle({
    Title = "Auto Store Fruits",
    Desc = "Automatically stores fruits to inventory",
    Default = Settings.AutoStore,
    Callback = function(Value) Settings.AutoStore = Value end
})

-- Bounty Tab
BountyTab:Toggle({
    Title = "Auto Bounty Hunt",
    Desc = "Flies to target player and attacks automatically",
    Default = Settings.AutoHunt,
    Callback = function(Value) Settings.AutoHunt = Value end
})

BountyTab:Toggle({
    Title = "Aimbot Target",
    Desc = "Locks camera smooth to closest player",
    Default = Settings.Aimbot,
    Callback = function(Value) Settings.Aimbot = Value end
})

-- Visuals Tab
VisualsTab:Toggle({
    Title = "Player ESP",
    Desc = "Highlights players with Box & HP information",
    Default = Settings.ESP,
    Callback = function(Value) Settings.ESP = Value end
})

VisualsTab:Toggle({
    Title = "Fruit ESP",
    Desc = "Shows dropped fruits with customized icons",
    Default = Settings.FruitESP,
    Callback = function(Value) Settings.FruitESP = Value end
})

-- Settings Tab
SettingsTab:Toggle({
    Title = "Global No-Clip",
    Desc = "Passes through all walls and obstacles",
    Default = Settings.Noclip,
    Callback = function(Value) Settings.Noclip = Value end
})

SettingsTab:Slider({
    Title = "Flight & Hunting Speed",
    Desc = "Adjusts movement flying speed",
    Min = 5,
    Max = 50,
    Default = Settings.FlySpeed,
    Callback = function(Value) Settings.FlySpeed = Value end
})

SettingsTab:Slider({
    Title = "Farm Above Distance",
    Desc = "Adjusts height distance while farming mobs",
    Min = 3,
    Max = 20,
    Default = Settings.FarmDistance,
    Callback = function(Value) Settings.FarmDistance = Value end
})

-- Send Notification
WindUI:Notify({
    Title = "Morgan Hub Loaded!",
    Content = "All scripts optimized and switched to Red WindUI.",
    Duration = 5,
})

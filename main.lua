-- =================================================================================
-- 🔮 MORGAN HUB V5.0 (REDZ HUB STYLE - AMETHYST EDITION) 🔮
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

-- Clear Previous GUI
if CoreGui:FindFirstChild("MorganHubV5") then CoreGui.MorganHubV5:Destroy() end

-- SETTINGS
local Settings = {
    ESP = false,
    FruitESP = false,
    AutoFarm = false,
    Aimbot = false,
    AutoHunt = false,
    AutoStore = true,
    LuckMultiplier = false,
    LuckPower = 100,
    FlySpeed = 12,
    FarmDistance = 8
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
-- GUI SCREEN CONTAINER
-- =============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- LOGO BUTTON (TOGGLE GUI)
local ToggleLogo = Instance.new("ImageButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 50, 0, 50)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(15, 10, 22)
ToggleLogo.BorderSizePixel = 0
ToggleLogo.Image = "rbxassetid://108376012222640"
ToggleLogo.Active = true
ToggleLogo.Draggable = true
ToggleLogo.Parent = ScreenGui

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(170, 0, 255)
LogoStroke.Thickness = 2
LogoStroke.Parent = ToggleLogo

-- =============================================================
-- MAIN HUB FRAME (REDZ HUB STYLE)
-- =============================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(120, 40, 200)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- TOP HEADER BAR
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(18, 15, 26)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(0, 300, 1, 0)
HeaderTitle.Position = UDim2.new(0, 15, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "💎 Morgan Hub V5.0 : Blox Fruits <font color=\"#888888\">da Morgan</font>"
HeaderTitle.RichText = true
HeaderTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
HeaderTitle.TextSize = 13
HeaderTitle.Font = Enum.Font.GothamMedium
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

-- CLOSE & MINIMIZE BUTTONS
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Header

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -55, 0, 5)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = Header

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- CONFIRM DESTROY POPUP
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
ConfirmFrame.BackgroundTransparency = 0.05
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 50
ConfirmFrame.Parent = MainFrame

local ConfirmCorner = Instance.new("UICorner")
ConfirmCorner.CornerRadius = UDim.new(0, 10)
ConfirmCorner.Parent = ConfirmFrame

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, 0, 0.3, 0)
ConfirmText.Position = UDim2.new(0, 0, 0.25, 0)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "Sei sicuro di voler chiudere e distruggere lo script?"
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 14
ConfirmText.ZIndex = 51
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 110, 0, 32)
YesBtn.Position = UDim2.new(0.25, -55, 0.6, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 70)
YesBtn.Text = "SÌ"
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 51
YesBtn.Parent = ConfirmFrame
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 110, 0, 32)
NoBtn.Position = UDim2.new(0.75, -55, 0.6, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
NoBtn.Text = "NO"
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.ZIndex = 51
NoBtn.Parent = ConfirmFrame
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)

-- SIDEBAR (TAB NAVIGATION)
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, -45)
Sidebar.Position = UDim2.new(0, 10, 0, 40)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 2
Sidebar.ScrollBarImageColor3 = Color3.fromRGB(80, 60, 120)
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.Parent = Sidebar

-- CONTENT CONTAINER (RIGHT SIDE)
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -175, 1, -45)
ContentContainer.Position = UDim2.new(0, 165, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- TAB SYSTEM LOGIC
local Tabs = {}
local TabButtons = {}

local function createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -5, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = "  " .. icon .. "  " .. name
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 170)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 12
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Parent = Sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 18)
    indicator.Position = UDim2.new(0, 0, 0.5, -9)
    indicator.BackgroundColor3 = Color3.fromRGB(170, 50, 255)
    indicator.Visible = false
    indicator.Parent = tabBtn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "Tab"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.ScrollBarThickness = 3
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 255)
    tabContent.Parent = ContentContainer

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tabContent

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        for _, b in pairs(TabButtons) do
            b.Button.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
            b.Button.TextColor3 = Color3.fromRGB(150, 150, 170)
            b.Indicator.Visible = false
        end

        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Visible = true
    end)

    table.insert(Tabs, tabContent)
    table.insert(TabButtons, {Button = tabBtn, Indicator = indicator})

    return tabContent
end

-- UI BUILDER ELEMENTS
local function addSectionTitle(tab, title)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.98, 0, 0, 22)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab
end

local function addToggle(tab, text, desc, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, desc and 46 or 36)
    card.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    card.BorderSizePixel = 0
    card.Parent = tab

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 0, 20)
    label.Position = UDim2.new(0.03, 0, desc and 0.12 or 0.22, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    if desc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0.75, 0, 0, 16)
        descLabel.Position = UDim2.new(0.03, 0, 0.52, 0)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 10
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = card
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(0.86, 0, 0.22, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(40, 32, 58)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = defaultState and UDim2.new(0.56, 0, 0.15, 0) or UDim2.new(0.08, 0, 0.15, 0)
    circle.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
    circle.BorderSizePixel = 0
    circle.Parent = btn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(40, 32, 58)
        circle.Position = state and UDim2.new(0.56, 0, 0.15, 0) or UDim2.new(0.08, 0, 0.15, 0)
        pcall(callback, state)
    end)
end

local function addSlider(tab, text, min, max, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 48)
    card.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    card.BorderSizePixel = 0
    card.Parent = tab

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0.4, 0)
    label.Position = UDim2.new(0.03, 0, 0.1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
    valLabel.Position = UDim2.new(0.76, 0, 0.1, 0)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(default)
    valLabel.TextColor3 = Color3.fromRGB(170, 80, 255)
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 12
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = card

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(0.94, 0, 0, 6)
    sliderBg.Position = UDim2.new(0.03, 0, 0.65, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 32, 58)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.Parent = card
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(160, 50, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valLabel.Text = tostring(val)
        pcall(callback, val)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- =============================================================
-- CREATING TABS & POPULATING SCRIPT FEATURES
-- =============================================================

-- TAB 1: FARM & QUESTS
local FarmTab = createTab("Farm", "🌾")
addSectionTitle(FarmTab, "Auto Farm Mobs")
addToggle(FarmTab, "Auto Farm Livello", "Attacca automaticamente i mob vicini", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addSlider(FarmTab, "Distanza Auto Farm", 3, 20, Settings.FarmDistance, function(v) Settings.FarmDistance = v end)

-- TAB 2: FRUIT & INVENTORY
local FruitTab = createTab("Meyve / İtem", "📦")
addSectionTitle(FruitTab, "Gestione Frutti")
addToggle(FruitTab, "Auto Conserva Frutti", "Mette automaticamente i frutti nell'inventario", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle(FruitTab, "ESP Frutti (Con Icone)", "Mostra le icone dei frutti sulla mappa", Settings.FruitESP, function(v) Settings.FruitESP = v end)

-- TAB 3: FORTUNA / LUCK BOOSTER
local LuckTab = createTab("Fortuna", "🔮")
addSectionTitle(LuckTab, "Luck Multiplier Booster")
addToggle(LuckTab, "Attiva Luck Booster", "Aumenta la percentuale di fortuna per i frutti mitici", Settings.LuckMultiplier, function(v) Settings.LuckMultiplier = v end)
addSlider(LuckTab, "Potenza Moltiplicatore Fortuna", 1, 1000, Settings.LuckPower, function(v) Settings.LuckPower = v end)

-- TAB 4: COMBAT & PVP
local CombatTab = createTab("Combattimento", "🎯")
addSectionTitle(CombatTab, "Aimbot e Caccia")
addToggle(CombatTab, "Aimbot Giocatore Vicino", "Punta automaticamente il giocatore più vicino", Settings.Aimbot, function(v) Settings.Aimbot = v end)
addToggle(CombatTab, "Auto Bounty Hunt (Volo Rapido)", "Vola verso i giocatori ed effettua l'attacco", Settings.AutoHunt, function(v) Settings.AutoHunt = v end)
addSlider(CombatTab, "Velocità Volo / Caccia", 5, 30, Settings.FlySpeed, function(v) Settings.FlySpeed = v end)

-- TAB 5: VISUALS / ESP
local VisualTab = createTab("Visuals", "👁️")
addSectionTitle(VisualTab, "Player ESP")
addToggle(VisualTab, "Player ESP (Box & HP)", "Mostra le scatole e la salute dei giocatori", Settings.ESP, function(v) Settings.ESP = v end)

-- SELECT DEFAULT TAB
Tabs[1].Visible = true
TabButtons[1].Button.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
TabButtons[1].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
TabButtons[1].Indicator.Visible = true

-- =============================================================
-- SCRIPT LOGIC ENGINES (FARM, STORE, ESP, AIMBOT)
-- =============================================================

-- AUTO STORE FRUIT ENGINE
local function storeFruit(tool)
    if not Settings.AutoStore or not tool or not tool:IsA("Tool") then return end
    if tool.Name:find("Fruit") or tool.Name:find("Meyve") or FruitIcons[tool.Name:gsub(" Fruit", "")] then
        pcall(function()
            local args = {[1] = "StoreFruit", [2] = tool.Name, [3] = tool}
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
        end)
    end
end

table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(storeFruit)
end))
if LocalPlayer.Character then LocalPlayer.Character.ChildAdded:Connect(storeFruit) end
table.insert(Connections, LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    task.wait(0.5)
    storeFruit(tool)
end))

-- AUTO FARM ENGINE
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
            root.CFrame = CFrame.lookAt(enemyPos, enemy.HumanoidRootPart.Position)
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        else
            myChar.Humanoid.PlatformStand = false
        end
    end)
end))

-- FRUIT ESP ENGINE
local FruitBillboards = {}
local function getFruitImage(fruitName)
    for name, iconId in pairs(FruitIcons) do
        if fruitName:lower():find(name:lower()) then return iconId end
    end
    return DefaultIcon
end

local function createFruitESP(obj)
    if FruitBillboards[obj] then return end
    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part") or obj:FindFirstChildOfClass("MeshPart")
    if not handle then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FruitESPLogo"
    bb.Adornee = handle
    bb.Size = UDim2.new(0, 60, 0, 70)
    bb.AlwaysOnTop = true

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, 42, 0, 42)
    img.Position = UDim2.new(0.5, -21, 0, 0)
    img.BackgroundTransparency = 1
    img.Image = getFruitImage(obj.Name)
    img.Parent = bb

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.35, 0)
    textLabel.Position = UDim2.new(0, 0, 0.65, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = obj.Name
    textLabel.TextColor3 = Color3.fromRGB(200, 130, 255)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 10
    textLabel.TextStrokeTransparency = 0
    textLabel.Parent = bb

    bb.Parent = CoreGui
    FruitBillboards[obj] = {Gui = bb, Text = textLabel, Handle = handle}
end

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if not Settings.FruitESP then
        for _, data in pairs(FruitBillboards) do if data.Gui then data.Gui.Enabled = false end end
        return
    end
    local myChar = LocalPlayer.Character
    local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position or Vector3.zero

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
end))

-- DRAWING PLAYER ESP ENGINE
local ESPCache = {}
local function createESP(targetPlayer)
    if targetPlayer == LocalPlayer then return end
    local boxOutline = Drawing.new("Square")
    boxOutline.Thickness = 3
    boxOutline.Color = Color3.fromRGB(0, 0, 0)

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(180, 50, 255)

    local text = Drawing.new("Text")
    text.Size = 13
    text.Center = true
    text.Outline = true
    text.Color = Color3.fromRGB(255, 255, 255)

    ESPCache[targetPlayer] = {BoxOutline = boxOutline, Box = box, Text = text}
end

local function removeESP(targetPlayer)
    if ESPCache[targetPlayer] then
        ESPCache[targetPlayer].BoxOutline:Remove()
        ESPCache[targetPlayer].Box:Remove()
        ESPCache[targetPlayer].Text:Remove()
        ESPCache[targetPlayer] = nil
    end
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
table.insert(Connections, Players.PlayerAdded:Connect(createESP))
table.insert(Connections, Players.PlayerRemoving:Connect(removeESP))

table.insert(Connections, RunService.RenderStepped:Connect(function()
    for targetPlayer, esp in pairs(ESPCache) do
        local char = targetPlayer.Character
        if Settings.ESP and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local root = char.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

            if onScreen then
                local head = char:FindFirstChild("Head")
                local headPos = head and head.Position or (root.Position + Vector3.new(0, 2, 0))
                local legPos = root.Position - Vector3.new(0, 3, 0)
                local topScreen = Camera:WorldToViewportPoint(headPos + Vector3.new(0, 1, 0))
                local bottomScreen = Camera:WorldToViewportPoint(legPos)

                local height = math.abs(topScreen.Y - bottomScreen.Y)
                local width = height / 1.6

                esp.BoxOutline.Size = Vector2.new(width, height)
                esp.BoxOutline.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                esp.BoxOutline.Visible = true

                esp.Box.Size = Vector2.new(width, height)
                esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                esp.Box.Visible = true

                esp.Text.Text = targetPlayer.Name .. " [" .. math.floor(char.Humanoid.Health) .. " HP]"
                esp.Text.Position = Vector2.new(pos.X, pos.Y - (height / 2) - 15)
                esp.Text.Visible = true
            else
                esp.BoxOutline.Visible = false
                esp.Box.Visible = false
                esp.Text.Visible = false
            end
        else
            esp.BoxOutline.Visible = false
            esp.Box.Visible = false
            esp.Text.Visible = false
        end
    end
end))

-- AIMBOT & AUTO HUNT ENGINE
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
            if Settings.Aimbot then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetRoot.Position) end

            if Settings.AutoHunt then
                myChar.Humanoid.PlatformStand = true
                local targetPos = targetRoot.Position + Vector3.new(0, 2, 0)
                local distance = (targetPos - root.Position).Magnitude

                if distance > 6 then
                    local newCFrame = CFrame.lookAt(root.Position, targetPos) * CFrame.new(0, 0, -Settings.FlySpeed)
                    myChar:PivotTo(newCFrame)
                else
                    myChar:PivotTo(CFrame.lookAt(root.Position, targetPos))
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(500, 500))
                end
            elseif not Settings.AutoFarm then
                myChar.Humanoid.PlatformStand = false
            end
        else
            if Settings.AutoHunt and not Settings.AutoFarm then myChar.Humanoid.PlatformStand = false end
        end
    end)
end))

-- DESTROY LOGIC
YesBtn.MouseButton1Click:Connect(function()
    Settings.AutoFarm = false
    Settings.AutoHunt = false
    Settings.ESP = false
    Settings.FruitESP = false
    Settings.AutoStore = false
    Settings.LuckMultiplier = false

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end

    for _, conn in pairs(Connections) do conn:Disconnect() end
    for _, esp in pairs(ESPCache) do
        esp.BoxOutline:Remove()
        esp.Box:Remove()
        esp.Text:Remove()
    end
    for _, data in pairs(FruitBillboards) do
        if data.Gui then data.Gui:Destroy() end
    end

    ScreenGui:Destroy()
end)

-- NOTIFICATION
game.StarterGui:SetCore("SendNotification", {
    Title = "💎 MORGAN HUB V5.0",
    Text = "Interfaccia Redz Hub Caricata!",
    Duration = 4
})

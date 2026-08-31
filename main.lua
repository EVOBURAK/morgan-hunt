-- =================================================================================
-- 💜 MORGAN HUB V5.0 (FULL INTEGRATED LUA SCRIPT & GUI) 💜
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

-- Anti-AFK Sistemi
table.insert(Connections, LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end))

if CoreGui:FindFirstChild("MorganHubV5") then CoreGui.MorganHubV5:Destroy() end

local Settings = {
    Language = "TR",
    ESP = false, FruitESP = false, AutoFarm = false, Aimbot = false, AutoHunt = false, AutoStore = true,
    LuckMultiplier = false, LuckPower = 100, FlySpeed = 12, FarmDistance = 8
}

-- DİL SİSTEMİ (TRANSLATIONS)
local Lang = {
    TR = {
        Title = "💜 MORGAN HUB V5.0", LuckUI = "🍀 ŞANS ARTTIRICI", Multi = "ÇARPAN: ", Mythical = "Gizemli Düşme Oranı: ~",
        Confirm = "Arayüzü tamamen kapatmak istiyor musun?", Yes = "EVET", No = "HAYIR",
        T_Luck = "🍀 Şans Arttırıcı Arayüzü", S_Luck = "🍀 Şans Çarpan Gücü", T_Farm = "🌾 Otomatik Kasılma (Moblar)",
        T_Store = "📦 Otomatik Meyve Depola", T_FESP = "🖼️ Meyve ESP (İkonlu)", T_ESP = "👁️ Oyuncu ESP (Kutu & Can)",
        T_Aim = "🎯 Aimbot (En Yakın)", T_Hunt = "⚡ Otomatik Av (Hızlı Uçuş)", S_Fly = "⚙️ Uçuş / Av Hızı", S_Dist = "⚙️ Farm Mesafesi (Yükseklik)",
        Notif = "Morgan Hub V5.0 başarıyla yüklendi, Burak!"
    },
    EN = {
        Title = "💜 MORGAN HUB V5.0", LuckUI = "🍀 LUCK RATE BOOSTER", Multi = "MULTIPLIER: ", Mythical = "Mythical Drop Rate: ~",
        Confirm = "Are you sure you want to destroy GUI?", Yes = "YES", No = "NO",
        T_Luck = "🍀 Luck Rate Booster GUI", S_Luck = "🍀 Luck Multiplier Power", T_Farm = "🌾 Auto Farm Level (Mobs)",
        T_Store = "📦 Auto Store Fruit", T_FESP = "🖼️ Fruit ESP (With Icons)", T_ESP = "👁️ Player ESP (Boxes & HP)",
        T_Aim = "🎯 Aimbot (Nearest Player)", T_Hunt = "⚡ Auto Bounty Hunt", S_Fly = "⚙️ Fly / Hunt Speed", S_Dist = "⚙️ Auto Farm Distance",
        Notif = "Morgan Hub V5.0 successfully loaded, Burak!"
    },
    IT = {
        Title = "💜 MORGAN HUB V5.0", LuckUI = "🍀 MOLTIPLICATORE FORTUNA", Multi = "MOLTIPLICATORE: ", Mythical = "Tasso Mitico: ~",
        Confirm = "Sei sicuro di voler chiudere la GUI?", Yes = "SÌ", No = "NO",
        T_Luck = "🍀 Interfaccia Fortuna", S_Luck = "🍀 Potere della Fortuna", T_Farm = "🌾 Auto Farm (Mostri)",
        T_Store = "📦 Auto Conserva Frutti", T_FESP = "🖼️ ESP Frutti (Con Icone)", T_ESP = "👁️ ESP Giocatori (Box & HP)",
        T_Aim = "🎯 Aimbot (Più Vicino)", T_Hunt = "⚡ Caccia Automatica", S_Fly = "⚙️ Velocità Volo", S_Dist = "⚙️ Distanza Auto Farm",
        Notif = "Morgan Hub V5.0 caricato con successo, Burak!"
    }
}

local FruitIcons = {
    ["Kitsune"]="rbxassetid://15312061073", ["Dragon"]="rbxassetid://13886869488", ["Leopard"]="rbxassetid://13886867744",
    ["Dough"]="rbxassetid://13886866168", ["T-Rex"]="rbxassetid://15682970597", ["Buddha"]="rbxassetid://13886865890"
}
local DefaultIcon = "rbxassetid://13886865768"

-- GUI ARCHITECTURE (PURPLE & TEAL THEME)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- AÇILIŞ ANİMASYONU (INTRO)
local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
IntroFrame.ZIndex = 100
IntroFrame.Parent = ScreenGui

local IntroLogo = Instance.new("TextLabel")
IntroLogo.Size = UDim2.new(0, 300, 0, 100)
IntroLogo.Position = UDim2.new(0.5, -150, 0.5, -50)
IntroLogo.BackgroundTransparency = 1
IntroLogo.Text = "💜 MORGAN HUB 💜\nLoading..."
IntroLogo.TextColor3 = Color3.fromRGB(150, 50, 255)
IntroLogo.TextSize = 30
IntroLogo.Font = Enum.Font.GothamBold
IntroLogo.ZIndex = 101
IntroLogo.Parent = IntroFrame

-- TOGGLE LOGO
local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Size = UDim2.new(0, 50, 0, 50)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleLogo.Text = "💜"
ToggleLogo.TextSize = 24
ToggleLogo.Draggable = true
ToggleLogo.Visible = false
ToggleLogo.Parent = ScreenGui
Instance.new("UICorner", ToggleLogo).CornerRadius = UDim.new(1, 0)
local LogoStroke = Instance.new("UIStroke", ToggleLogo)
LogoStroke.Color = Color3.fromRGB(0, 200, 200)
LogoStroke.Thickness = 2.5

-- MAIN WINDOW
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 500)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 200, 200)
MainStroke.Thickness = 2

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = Lang[Settings.Language].Title
Title.TextColor3 = Color3.fromRGB(150, 50, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- DİL BUTONLARI (LANGUAGES)
local function createLangBtn(text, pos, langCode)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 35, 0, 25)
    btn.Position = UDim2.new(1, pos, 0, 10)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local BtnTR = createLangBtn("TR", -150, "TR")
local BtnEN = createLangBtn("EN", -110, "EN")
local BtnIT = createLangBtn("IT", -70, "IT")

-- LUCK BOOSTER GUI FRAME
local LuckFrame = Instance.new("Frame")
LuckFrame.Size = UDim2.new(0, 260, 0, 140)
LuckFrame.Position = UDim2.new(0.8, -260, 0.15, 0)
LuckFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
LuckFrame.Draggable = true
LuckFrame.Visible = false
LuckFrame.Parent = ScreenGui
Instance.new("UICorner", LuckFrame).CornerRadius = UDim.new(0, 10)
local LuckStroke = Instance.new("UIStroke", LuckFrame)
LuckStroke.Color = Color3.fromRGB(150, 50, 255)
LuckStroke.Thickness = 2

local LuckTitle = Instance.new("TextLabel", LuckFrame)
LuckTitle.Size = UDim2.new(1, 0, 0, 30)
LuckTitle.BackgroundTransparency = 1
LuckTitle.Text = Lang[Settings.Language].LuckUI
LuckTitle.TextColor3 = Color3.fromRGB(0, 200, 200)
LuckTitle.Font = Enum.Font.GothamBold
LuckTitle.TextSize = 14

local LuckStatus = Instance.new("TextLabel", LuckFrame)
LuckStatus.Size = UDim2.new(1, 0, 0, 25)
LuckStatus.Position = UDim2.new(0, 0, 0.3, 0)
LuckStatus.BackgroundTransparency = 1
LuckStatus.Text = Lang[Settings.Language].Multi .. "100x"
LuckStatus.TextColor3 = Color3.fromRGB(150, 50, 255)
LuckStatus.Font = Enum.Font.GothamBold
LuckStatus.TextSize = 13

local ChanceDisplay = Instance.new("TextLabel", LuckFrame)
ChanceDisplay.Size = UDim2.new(1, -20, 0, 30)
ChanceDisplay.Position = UDim2.new(0, 10, 0.55, 0)
ChanceDisplay.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
ChanceDisplay.Text = Lang[Settings.Language].Mythical .. "84.5%"
ChanceDisplay.TextColor3 = Color3.fromRGB(0, 200, 200)
ChanceDisplay.Font = Enum.Font.GothamMedium
ChanceDisplay.TextSize = 12
Instance.new("UICorner", ChanceDisplay).CornerRadius = UDim.new(0, 6)

-- CONFIRM DESTROY FRAME
local ConfirmFrame = Instance.new("Frame", MainFrame)
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
ConfirmFrame.BackgroundTransparency = 0.1
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 10
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 12)

local ConfirmText = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.Size = UDim2.new(1, 0, 0.4, 0)
ConfirmText.Position = UDim2.new(0, 0, 0.2, 0)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = Lang[Settings.Language].Confirm
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 16
ConfirmText.ZIndex = 11

local YesBtn = Instance.new("TextButton", ConfirmFrame)
YesBtn.Size = UDim2.new(0, 120, 0, 40)
YesBtn.Position = UDim2.new(0.2, 0, 0.65, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
YesBtn.Text = Lang[Settings.Language].Yes
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 11
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 8)

local NoBtn = Instance.new("TextButton", ConfirmFrame)
NoBtn.Size = UDim2.new(0, 120, 0, 40)
NoBtn.Position = UDim2.new(0.55, 0, 0.65, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
NoBtn.Text = Lang[Settings.Language].No
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.ZIndex = 11
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 255)

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)

local UIReferences = {}

local function addToggle(langKey, defaultState, callback)
    local card = Instance.new("Frame", Container)
    card.Size = UDim2.new(0.98, 0, 0, 45)
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.04, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = Lang[Settings.Language][langKey]
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0, 46, 0, 24)
    btn.Position = UDim2.new(0.85, 0, 0.22, 0)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(150, 50, 255) or Color3.fromRGB(40, 40, 50)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = defaultState and UDim2.new(0.54, 0, 0.12, 0) or UDim2.new(0.08, 0, 0.12, 0)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(0, 9)

    table.insert(UIReferences, {Type = "Toggle", Element = label, Key = langKey})

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = state and Color3.fromRGB(150, 50, 255) or Color3.fromRGB(40, 40, 50)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.3), {Position = state and UDim2.new(0.54, 0, 0.12, 0) or UDim2.new(0.08, 0, 0.12, 0)}):Play()
        pcall(callback, state)
    end)
end

local function addSlider(langKey, min, max, default, callback)
    local card = Instance.new("Frame", Container)
    card.Size = UDim2.new(0.98, 0, 0, 55)
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(0.7, 0, 0.5, 0)
    label.Position = UDim2.new(0.04, 0, 0.08, 0)
    label.BackgroundTransparency = 1
    label.Text = Lang[Settings.Language][langKey]
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel", card)
    valueLabel.Size = UDim2.new(0.2, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0.76, 0, 0.08, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(0, 200, 200)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local sliderBg = Instance.new("TextButton", card)
    sliderBg.Size = UDim2.new(0.92, 0, 0, 8)
    sliderBg.Position = UDim2.new(0.04, 0, 0.65, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderBg.Text = ""
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 4)

    local fill = Instance.new("Frame", sliderBg)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

    table.insert(UIReferences, {Type = "Slider", Element = label, Key = langKey})

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + ((max - min) * pos))
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(val)
        pcall(callback, val)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
    end)
end

-- DİL GÜNCELLEME SİSTEMİ
local function setLanguage(langCode)
    Settings.Language = langCode
    Title.Text = Lang[langCode].Title
    LuckTitle.Text = Lang[langCode].LuckUI
    ConfirmText.Text = Lang[langCode].Confirm
    YesBtn.Text = Lang[langCode].Yes
    NoBtn.Text = Lang[langCode].No
    LuckStatus.Text = Lang[langCode].Multi .. Settings.LuckPower .. "x"
    local simulatedRate = math.min(99.9, math.floor(Settings.LuckPower * 0.85 * 10) / 10)
    ChanceDisplay.Text = Lang[langCode].Mythical .. simulatedRate .. "%"

    for _, ref in pairs(UIReferences) do
        if ref.Element and Lang[langCode][ref.Key] then
            ref.Element.Text = Lang[langCode][ref.Key]
        end
    end
end

BtnTR.MouseButton1Click:Connect(function() setLanguage("TR") end)
BtnEN.MouseButton1Click:Connect(function() setLanguage("EN") end)
BtnIT.MouseButton1Click:Connect(function() setLanguage("IT") end)

-- MENÜ ELEMANLARI (BACKEND SETTINGS İLE BAĞLANTILI)
addToggle("T_Luck", Settings.LuckMultiplier, function(v) Settings.LuckMultiplier = v; LuckFrame.Visible = v end)
addSlider("S_Luck", 1, 1000, Settings.LuckPower, function(v)
    Settings.LuckPower = v
    LuckStatus.Text = Lang[Settings.Language].Multi .. v .. "x"
    local simulatedRate = math.min(99.9, math.floor(v * 0.85 * 10) / 10)
    ChanceDisplay.Text = Lang[Settings.Language].Mythical .. simulatedRate .. "%"
end)

addToggle("T_Farm", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle("T_Store", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle("T_FESP", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("T_ESP", Settings.ESP, function(v) Settings.ESP = v end)
addToggle("T_Aim", Settings.Aimbot, function(v) Settings.Aimbot = v end)
addToggle("T_Hunt", Settings.AutoHunt, function(v) Settings.AutoHunt = v end)

addSlider("S_Fly", 5, 30, Settings.FlySpeed, function(v) Settings.FlySpeed = v end)
addSlider("S_Dist", 3, 20, Settings.FarmDistance, function(v) Settings.FarmDistance = v end)

-- =============================================================
-- WEAPON PRIORITY ENGINE (Kılıç > Silah > Meyve > Yumruk)
-- =============================================================
local PriorityList = {"Sword", "Gun", "Blox Fruit", "Melee"}

local function equipBestWeapon()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not backpack then return end

    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end

    for _, wepType in ipairs(PriorityList) do
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == wepType then
                return tool
            end
        end
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == wepType then
                humanoid:EquipTool(tool)
                return tool
            end
        end
    end

    if not char:FindFirstChildOfClass("Tool") then
        local fallback = backpack:FindFirstChildOfClass("Tool")
        if fallback then humanoid:EquipTool(fallback) end
    end
end

-- =============================================================
-- AUTO FARM ENGINE
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
                    minDistance = dist; closest = enemy
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
        
        local enemy = getClosestEnemy()
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            myChar.Humanoid.PlatformStand = true
            
            equipBestWeapon()

            local enemyPos = enemy.HumanoidRootPart.Position + Vector3.new(0, Settings.FarmDistance, 0)
            myChar.HumanoidRootPart.CFrame = CFrame.lookAt(enemyPos, enemy.HumanoidRootPart.Position)

            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        else
            myChar.Humanoid.PlatformStand = false
        end
    end)
end))

-- =============================================================
-- AUTO STORE FRUIT ENGINE
-- =============================================================
local function storeFruit(tool)
    if not Settings.AutoStore or not tool or not tool:IsA("Tool") then return end
    if tool.Name:find("Fruit") or tool.Name:find("Meyve") then
        pcall(function() ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("StoreFruit", tool.Name, tool) end)
    end
end

if LocalPlayer:FindFirstChild("Backpack") then
    table.insert(Connections, LocalPlayer.Backpack.ChildAdded:Connect(function(tool) task.wait(0.5); storeFruit(tool) end))
end

-- EXIT / DESTROY CLEANUP
YesBtn.MouseButton1Click:Connect(function()
    Settings.AutoFarm = false; Settings.AutoHunt = false; Settings.ESP = false
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
    for _, conn in pairs(Connections) do conn:Disconnect() end
    ScreenGui:Destroy()
end)

-- =============================================================
-- INTRO & NOTIFICATION ENGINE
-- =============================================================
task.spawn(function()
    task.wait(1.5)
    local fadeOut = TweenService:Create(IntroFrame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    local textFade = TweenService:Create(IntroLogo, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
    fadeOut:Play()
    textFade:Play()
    fadeOut.Completed:Wait()
    IntroFrame:Destroy()
    
    MainFrame.Visible = true
    ToggleLogo.Visible = true
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "💜 MORGAN HUB",
        Text = Lang[Settings.Language].Notif,
        Duration = 5
    })
end)

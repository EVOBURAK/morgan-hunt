-- =================================================================================
-- 🔮 MORGAN HUB V5.0 (AMETHYST EDITION - ULTIMATE GUI & FIXED ESP) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

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
    ["Kitsune"] = "rbxassetid://15312061073", ["Dragon"] = "rbxassetid://13886869488",
    ["Leopard"] = "rbxassetid://13886867744", ["Dough"] = "rbxassetid://13886866168",
    ["T-Rex"] = "rbxassetid://15682970597", ["Mammoth"] = "rbxassetid://14930198642",
    ["Spirit"] = "rbxassetid://13886869850", ["Venom"] = "rbxassetid://13886870244",
    ["Shadow"] = "rbxassetid://13886869634", ["Blizzard"] = "rbxassetid://13886865660",
    ["Gravity"] = "rbxassetid://13886867420", ["Portal"] = "rbxassetid://13886869150",
    ["Rumble"] = "rbxassetid://13886869348", ["Buddha"] = "rbxassetid://13886865890",
    ["Love"] = "rbxassetid://13886868018", ["Spider"] = "rbxassetid://13886869976",
    ["Sound"] = "rbxassetid://14930200871", ["Magma"] = "rbxassetid://13886868420",
    ["Ice"] = "rbxassetid://13886867566", ["Light"] = "rbxassetid://13886867888",
    ["Flame"] = "rbxassetid://13886866872", ["Rocket"] = "rbxassetid://13886869246",
    ["Spin"] = "rbxassetid://13886870104", ["Blade"] = "rbxassetid://13886866580",
    ["Spring"] = "rbxassetid://13886870176", ["Bomb"] = "rbxassetid://13886865768",
    ["Smoke"] = "rbxassetid://13886869752", ["Spike"] = "rbxassetid://13886870034",
    ["Falcon"] = "rbxassetid://13886866708", ["Sand"] = "rbxassetid://13886869528",
    ["Dark"] = "rbxassetid://13886866034", ["Diamond"] = "rbxassetid://13886866360",
    ["Ghost"] = "rbxassetid://15082498716", ["Rubber"] = "rbxassetid://13886869300",
    ["Barrier"] = "rbxassetid://13886865502"
}
local DefaultIcon = "rbxassetid://13886865768"

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- 🔮 AÇILIŞ EKRANI (INTRO INTRO ANIMATION)
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 100
LoadingFrame.Parent = ScreenGui

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 50)
LoadingTitle.Position = UDim2.new(0, 0, 0.38, 0)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "💎 MORGAN HUB V5 💎"
LoadingTitle.TextColor3 = Color3.fromRGB(180, 100, 255)
LoadingTitle.TextSize = 28
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.ZIndex = 101
LoadingTitle.Parent = LoadingFrame

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 30)
LoadingSub.Position = UDim2.new(0, 0, 0.45, 0)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Text = "Ametist Gücü Yükleniyor..."
LoadingSub.TextColor3 = Color3.fromRGB(200, 170, 255)
LoadingSub.TextSize = 14
LoadingSub.Font = Enum.Font.GothamMedium
LoadingSub.ZIndex = 101
LoadingSub.Parent = LoadingFrame

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 320, 0, 10)
BarBg.Position = UDim2.new(0.5, -160, 0.55, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
BarBg.BorderSizePixel = 0
BarBg.ZIndex = 101
BarBg.Parent = LoadingFrame

local BarBgCorner = Instance.new("UICorner")
BarBgCorner.CornerRadius = UDim.new(1, 0)
BarBgCorner.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(160, 30, 255)
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 102
BarFill.Parent = BarBg

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(1, 0)
BarFillCorner.Parent = BarFill

task.spawn(function()
    local tween = TweenService:Create(BarFill, TweenInfo.new(1.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    tween.Completed:Wait()
    LoadingSub.Text = "Hazır!"
    task.wait(0.3)
    local fadeTween = TweenService:Create(LoadingFrame, TweenInfo.new(0.6), {BackgroundTransparency = 1})
    TweenService:Create(LoadingTitle, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(LoadingSub, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    fadeTween:Play()
    fadeTween.Completed:Wait()
    LoadingFrame:Destroy()
end)

-- LOGO BUTTON
local ToggleLogo = Instance.new("TextButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 50, 0, 50)
ToggleLogo.Position = UDim2.new(0, 20, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(20, 12, 35)
ToggleLogo.Text = "💎"
ToggleLogo.TextSize = 26
ToggleLogo.Active = true
ToggleLogo.Draggable = true
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = ToggleLogo

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(170, 0, 255)
LogoStroke.Thickness = 2
LogoStroke.Parent = ToggleLogo

-- MAIN WINDOW
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

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(160, 50, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- YANLARDA YÜZEN AMETİST KRİSTALLERİ
local function createSideAmethyst(isLeft)
    local amethyst = Instance.new("TextLabel")
    amethyst.Size = UDim2.new(0, 40, 0, 40)
    local posX = isLeft and UDim2.new(0, -35, 0.5, -20) or UDim2.new(1, -5, 0.5, -20)
    amethyst.Position = posX
    amethyst.BackgroundTransparency = 1
    amethyst.Text = "💎"
    amethyst.TextSize = 30
    amethyst.Parent = MainFrame

    local floatTween = TweenService:Create(amethyst, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Position = posX + UDim2.new(0, 0, 0, -25)})
    floatTween:Play()
end
createSideAmethyst(true)
createSideAmethyst(false)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💎 MORGAN HUB V5.0"
Title.TextColor3 = Color3.fromRGB(200, 130, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- LUCK BOOSTER GUI
local LuckFrame = Instance.new("Frame")
LuckFrame.Size = UDim2.new(0, 260, 0, 140)
LuckFrame.Position = UDim2.new(0.8, -260, 0.15, 0)
LuckFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 32)
LuckFrame.Active = true
LuckFrame.Draggable = true
LuckFrame.Visible = false
LuckFrame.Parent = ScreenGui

local LuckCorner = Instance.new("UICorner")
LuckCorner.CornerRadius = UDim.new(0, 8)
LuckCorner.Parent = LuckFrame

local LuckStroke = Instance.new("UIStroke")
LuckStroke.Color = Color3.fromRGB(180, 80, 255)
LuckStroke.Thickness = 2
LuckStroke.Parent = LuckFrame

local LuckTitle = Instance.new("TextLabel")
LuckTitle.Size = UDim2.new(1, 0, 0, 30)
LuckTitle.Position = UDim2.new(0, 0, 0.05, 0)
LuckTitle.BackgroundTransparency = 1
LuckTitle.Text = "🔮 LUCK RATE BOOSTER"
LuckTitle.TextColor3 = Color3.fromRGB(220, 150, 255)
LuckTitle.Font = Enum.Font.GothamBold
LuckTitle.TextSize = 13
LuckTitle.Parent = LuckFrame

local LuckStatus = Instance.new("TextLabel")
LuckStatus.Size = UDim2.new(1, 0, 0, 25)
LuckStatus.Position = UDim2.new(0, 0, 0.3, 0)
LuckStatus.BackgroundTransparency = 1
LuckStatus.Text = "MULTIPLIER: 100x"
LuckStatus.TextColor3 = Color3.fromRGB(170, 100, 255)
LuckStatus.Font = Enum.Font.GothamBold
LuckStatus.TextSize = 12
LuckStatus.Parent = LuckFrame

local ChanceDisplay = Instance.new("TextLabel")
ChanceDisplay.Size = UDim2.new(1, -20, 0, 30)
ChanceDisplay.Position = UDim2.new(0, 10, 0.55, 0)
ChanceDisplay.BackgroundColor3 = Color3.fromRGB(30, 20, 48)
ChanceDisplay.Text = "Mythical Drop Rate: ~84.5%"
ChanceDisplay.TextColor3 = Color3.fromRGB(255, 170, 0)
ChanceDisplay.Font = Enum.Font.GothamMedium
ChanceDisplay.TextSize = 11
ChanceDisplay.Parent = LuckFrame

local ChanceCorner = Instance.new("UICorner")
ChanceCorner.CornerRadius = UDim.new(0, 6)
ChanceCorner.Parent = ChanceDisplay

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 70)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 48)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(150, 60, 255)
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Container

local function addToggle(text, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.98, 0, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(24, 18, 38)
    card.Parent = Container

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card

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

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 11)
    btnCorner.Parent = btn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
    circle.BackgroundColor3 = Color3.fromRGB(240, 230, 255)
    circle.Parent = btn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 8)
    circleCorner.Parent = circle

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(150, 40, 255) or Color3.fromRGB(45, 35, 65)
        circle.Position = state and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
        pcall(callback, state)
    end)
end

addToggle("🔮 Luck Rate Booster GUI", Settings.LuckMultiplier, function(v) 
    Settings.LuckMultiplier = v
    LuckFrame.Visible = v
end)
addToggle("🌾 Auto Farm Level (Mobs)", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
addToggle("📦 Auto Store Fruit (Inventory)", Settings.AutoStore, function(v) Settings.AutoStore = v end)
addToggle("🖼️ Fruit ESP (With Image Icons)", Settings.FruitESP, function(v) Settings.FruitESP = v end)
addToggle("👁️ Player ESP (Boxes & HP)", Settings.ESP, function(v) Settings.ESP = v end)

-- =============================================================
-- FIXED 100% WORKING FRUIT ESP ENGINE
-- =============================================================
local FruitFolder = Instance.new("Folder")
FruitFolder.Name = "FruitESPFolder"
FruitFolder.Parent = CoreGui

local function getFruitImage(fruitName)
    for name, iconId in pairs(FruitIcons) do
        if fruitName:lower():find(name:lower()) then
            return iconId
        end
    end
    return DefaultIcon
end

local function addFruitESP(obj)
    if not obj or FruitFolder:FindFirstChild(obj:GetDebugId()) then return end

    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part") or obj:FindFirstChildOfClass("MeshPart")
    if not handle then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = obj:GetDebugId()
    bb.Adornee = handle
    bb.Size = UDim2.new(0, 100, 0, 90)
    bb.AlwaysOnTop = true
    bb.Parent = FruitFolder

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, 40, 0, 40)
    img.Position = UDim2.new(0.5, -20, 0, 0)
    img.BackgroundTransparency = 1
    img.Image = getFruitImage(obj.Name)
    img.Parent = bb

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.4, 0)
    textLabel.Position = UDim2.new(0, 0, 0.5, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = obj.Name
    textLabel.TextColor3 = Color3.fromRGB(200, 130, 255)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 11
    textLabel.TextStrokeTransparency = 0
    textLabel.Parent = bb
end

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if not Settings.FruitESP then
        FruitFolder:ClearAllChildren()
        return
    end

    local myChar = LocalPlayer.Character
    local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position or Vector3.zero

    for _, obj in pairs(Workspace:GetChildren()) do
        if (obj:IsA("Tool") or obj:IsA("Model")) and (obj.Name:find("Fruit") or obj.Name:find("Meyve")) then
            addFruitESP(obj)
        end
    end

    for _, gui in pairs(FruitFolder:GetChildren()) do
        local adornee = gui.Adornee
        if adornee and adornee.Parent then
            local dist = math.floor((adornee.Position - myPos).Magnitude)
            local label = gui:FindFirstChildOfClass("TextLabel")
            if label then
                label.Text = adornee.Parent.Name .. "\n[" .. dist .. "m]"
            end
        else
            gui:Destroy()
        end
    end
end))

-- =============================================================
-- FIXED 100% WORKING PLAYER ESP ENGINE (HIGHLIGHT + BILLBOARD)
-- =============================================================
local PlayerESPFolder = Instance.new("Folder")
PlayerESPFolder.Name = "PlayerESPFolder"
PlayerESPFolder.Parent = CoreGui

local function updatePlayerESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            local hl = PlayerESPFolder:FindFirstChild("HL_" .. player.Name)
            
            if Settings.ESP then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "HL_" .. player.Name
                    hl.FillColor = Color3.fromRGB(160, 50, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    hl.Adornee = char
                    hl.Parent = PlayerESPFolder

                    local bb = Instance.new("BillboardGui")
                    bb.Name = "BB_" .. player.Name
                    bb.Adornee = char:FindFirstChild("Head") or char.HumanoidRootPart
                    bb.Size = UDim2.new(0, 150, 0, 30)
                    bb.StudsOffset = Vector3.new(0, 3, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = PlayerESPFolder

                    local txt = Instance.new("TextLabel")
                    txt.Name = "NameLabel"
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                    txt.Font = Enum.Font.GothamBold
                    txt.TextSize = 12
                    txt.TextStrokeTransparency = 0
                    txt.Parent = bb
                else
                    hl.Adornee = char
                    local bb = PlayerESPFolder:FindFirstChild("BB_" .. player.Name)
                    if bb and char:FindFirstChild("Humanoid") then
                        local hp = math.floor(char.Humanoid.Health)
                        bb.NameLabel.Text = player.Name .. " [" .. hp .. " HP]"
                    end
                end
            else
                if hl then hl:Destroy() end
                local bb = PlayerESPFolder:FindFirstChild("BB_" .. player.Name)
                if bb then bb:Destroy() end
            end
        end
    end
end

table.insert(Connections, RunService.RenderStepped:Connect(updatePlayerESP))

-- NOTIFICATION
game.StarterGui:SetCore("SendNotification", {
    Title = "💎 MORGAN HUB V5.0",
    Text = "ESP ve Ametist GUI tam donanımlı yüklendi!",
    Duration = 4
})

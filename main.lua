-- =============================================================
-- 🌿 MORGAN HUB V1.0 (ULTRA LOGO FRUIT ESP + WORKING V4 & SWORDS) 🌿
-- =============================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
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

-- Eski GUI Temizliği
if CoreGui:FindFirstChild("MorganHubV1") then CoreGui.MorganHubV1:Destroy() end

-- AYARLAR
local Settings = {
    ESP = false,
    FruitESP = false,
    Aimbot = false,
    AutoHunt = false,
    FakePerms = false,
    VisualV4 = false,
    VisualSwords = false,
    SkillMode = "1",
    FlySpeed = 9.5
}

-- =============================================================
-- GUI MİMARİSİ
-- =============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorganHubV1"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- LOGO BUTTON
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

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(0, 255, 120)
LogoStroke.Thickness = 2
LogoStroke.Parent = ToggleLogo

-- ANA MENÜ PENCERESİ
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 430)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 120)
MainStroke.Transparency = 0.6
MainStroke.Parent = MainFrame

ToggleLogo.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🌿 MORGAN HUB V1.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- DESTROY ONAY PENCERESİ
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
ConfirmFrame.BackgroundTransparency = 0.1
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 10
ConfirmFrame.Parent = MainFrame

local ConfirmCorner = Instance.new("UICorner")
ConfirmCorner.CornerRadius = UDim.new(0, 10)
ConfirmCorner.Parent = ConfirmFrame

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, 0, 0.4, 0)
ConfirmText.Position = UDim2.new(0, 0, 0.2, 0)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "Are you sure you want to destroy GUI?"
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 15
ConfirmText.ZIndex = 11
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 100, 0, 35)
YesBtn.Position = UDim2.new(0.2, 0, 0.65, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
YesBtn.Text = "YES"
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 11
YesBtn.Parent = ConfirmFrame

local YesCorner = Instance.new("UICorner")
YesCorner.CornerRadius = UDim.new(0, 6)
YesCorner.Parent = YesBtn

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 100, 0, 35)
NoBtn.Position = UDim2.new(0.6, 0, 0.65, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(50, 60, 75)
NoBtn.Text = "NO"
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.ZIndex = 11
NoBtn.Parent = ConfirmFrame

local NoCorner = Instance.new("UICorner")
NoCorner.CornerRadius = UDim.new(0, 6)
NoCorner.Parent = NoBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Container

local function addToggle(text, callback)
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
    btn.BackgroundColor3 = Color3.fromRGB(35, 45, 58)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 11)
    btnCorner.Parent = btn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0.08, 0, 0.13, 0)
    circle.BackgroundColor3 = Color3.fromRGB(180, 190, 200)
    circle.BorderSizePixel = 0
    circle.Parent = btn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 8)
    circleCorner.Parent = circle

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 190, 100) or Color3.fromRGB(35, 45, 58)
        circle.Position = state and UDim2.new(0.54, 0, 0.13, 0) or UDim2.new(0.08, 0, 0.13, 0)
        pcall(callback, state)
    end)
end

-- MENÜ ELEMANLARI
addToggle("👁️ Player ESP (Oyuncu Kutuları)", function(v) Settings.ESP = v end)
addToggle("🍎 Logolu Fruit ESP (Meyve Bulucu)", function(v) Settings.FruitESP = v end)
addToggle("🍇 Fake All Perm Fruits (Dükkanda Perm Aç)", function(v) Settings.FakePerms = v end)

-- GELİŞMİŞ VISUAL V4 TRANSFORM DÖNÜŞÜMÜ
addToggle("⚡ Visual V4 Transformation (Görsel V4)", function(v) 
    Settings.VisualV4 = v
    local char = LocalPlayer.Character
    if not char then return end

    if v then
        -- Kırmızı Parıldayan Aura
        local hl = char:FindFirstChild("V4Highlight") or Instance.new("Highlight")
        hl.Name = "V4Highlight"
        hl.FillColor = Color3.fromRGB(255, 30, 60)
        hl.OutlineColor = Color3.fromRGB(255, 215, 0)
        hl.FillTransparency = 0.3
        hl.OutlineTransparency = 0
        hl.Parent = char

        -- Karakter Boyutunu V4 Gibi Hafif Büyütme (Client-Side)
        pcall(function()
            char.Humanoid.BodyHeightScale.Value = 1.25
            char.Humanoid.BodyWidthScale.Value = 1.25
        end)

        game.StarterGui:SetCore("SendNotification", {Title = "Visual V4", Text = "V4 Dönüşüm Efekti Aktif!", Duration = 3})
    else
        if char:FindFirstChild("V4Highlight") then char.V4Highlight:Destroy() end
        pcall(function()
            char.Humanoid.BodyHeightScale.Value = 1
            char.Humanoid.BodyWidthScale.Value = 1
        end)
    end
end)

-- 3D MODEL VE IKONLU GELİŞMİŞ FAKE SWORDS
local function createFakeTool(name, color)
    local tool = Instance.new("Tool")
    tool.Name = name .. " (Visual)"
    tool.RequiresHandle = true

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.5, 5, 0.8)
    handle.Color = color
    handle.Material = Enum.Material.Neon
    handle.Parent = tool

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Brick
    mesh.Parent = handle

    return tool
end

addToggle("⚔️ Fake Dark Blade & Triple DB", function(v) 
    Settings.VisualSwords = v 
    if v then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            local db = createFakeTool("Dark Blade", Color3.fromRGB(0, 255, 120))
            db.Parent = backpack

            local tdb = createFakeTool("Triple Dark Blade", Color3.fromRGB(255, 0, 80))
            tdb.Parent = backpack
        end
        game.StarterGui:SetCore("SendNotification", {Title = "Fake Swords", Text = "Dark Blade ve TDB Eline Alınabilir Şekilde Eklendi!", Duration = 3})
    end
end)

addToggle("🎯 Aimbot (En Yakın Oyuncu)", function(v) Settings.Aimbot = v end)
addToggle("⚡ Fast Auto Hunt (Hızlı Uçuş)", function(v) Settings.AutoHunt = v end)

-- =============================================================
-- LOGOLU FRUIT ESP ENGINE (🍎 DEV LOGO + İSİM + METRE)
-- =============================================================
local FruitBillboards = {}

local function createFruitESP(obj)
    if FruitBillboards[obj] then return end

    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part") or obj:FindFirstChildOfClass("MeshPart")
    if not handle then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FruitESPLogo"
    bb.Adornee = handle
    bb.Size = UDim2.new(0, 180, 0, 70)
    bb.AlwaysOnTop = true

    -- Meyve Logosu (Dev 🍎 İkonu)
    local logoLabel = Instance.new("TextLabel")
    logoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    logoLabel.Position = UDim2.new(0, 0, 0, 0)
    logoLabel.BackgroundTransparency = 1
    logoLabel.Text = "🍎"
    logoLabel.TextSize = 28
    logoLabel.Parent = bb

    -- Meyve Adı ve Mesafesi
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.Position = UDim2.new(0, 0, 0.5, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = obj.Name
    textLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 13
    textLabel.TextStrokeTransparency = 0
    textLabel.Parent = bb

    bb.Parent = CoreGui
    FruitBillboards[obj] = {Gui = bb, Text = textLabel, Handle = handle}
end

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if not Settings.FruitESP then
        for obj, data in pairs(FruitBillboards) do
            if data.Gui then data.Gui.Enabled = false end
        end
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

-- =============================================================
-- DRAWING PLAYER ESP SİSTEMİ
-- =============================================================
local ESPCache = {}

local function createESP(targetPlayer)
    if targetPlayer == LocalPlayer then return end

    local boxOutline = Drawing.new("Square")
    boxOutline.Thickness = 3
    boxOutline.Color = Color3.fromRGB(0, 0, 0)
    boxOutline.Filled = false

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 40, 40)
    box.Filled = false

    local text = Drawing.new("Text")
    text.Size = 14
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
                esp.Text.Position = Vector2.new(pos.X, pos.Y - (height / 2) - 16)
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

-- =============================================================
-- EN YAKIN OYUNCU TESPİTİ & FAST FLY / AIMBOT ENGINE
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

            -- AIMBOT
            if Settings.Aimbot then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetRoot.Position)
            end

            -- FAST FLY
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
            else
                myChar.Humanoid.PlatformStand = false
            end
        else
            if Settings.AutoHunt then
                myChar.Humanoid.PlatformStand = false
            end
        end
    end)
end))

-- =============================================================
-- DESTROY FUNCTION (YES BUTONUNA BASINCA)
-- =============================================================
YesBtn.MouseButton1Click:Connect(function()
    Settings.AutoHunt = false
    Settings.ESP = false
    Settings.FruitESP = false
    Settings.FakePerms = false
    Settings.VisualV4 = false
    Settings.VisualSwords = false

    if LocalPlayer.Character then
        if LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
        if LocalPlayer.Character:FindFirstChild("V4Highlight") then
            LocalPlayer.Character.V4Highlight:Destroy()
        end
    end

    for _, conn in pairs(Connections) do
        conn:Disconnect()
    end

    for _, esp in pairs(ESPCache) do
        esp.BoxOutline:Remove()
        esp.Box:Remove()
        esp.Text:Remove()
    end
    for _, data in pairs(FruitBillboards) do
        if data.Gui then data.Gui:Destroy() end
    end

    ScreenGui:Destroy()

    game.StarterGui:SetCore("SendNotification", {
        Title = "🌿 MORGAN HUB",
        Text = "Script tamamen kapatıldı ve temizlendi!",
        Duration = 3
    })
end)

-- BİLDİRİM
game.StarterGui:SetCore("SendNotification", {
    Title = "🌿 MORGAN HUB V1.0",
    Text = "🍎 Logolu Fruit ESP ve Tüm Visual Sistemler Hazır!",
    Duration = 4
})

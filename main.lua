-- =================================================================================
-- 🔮 MORGAN HUB V2.6 PREMIUM (FIXED - DELTA UYUMLU, MOBİL DOSTU, NO KEY) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- =============================================================
-- 🧩 GUI PARENT SEÇİMİ (gethui -> CoreGui -> PlayerGui)
-- =============================================================
local function GetGuiParent()
    local ok, res = pcall(function() return gethui and gethui() end)
    if ok and res then return res end

    local ok2, core = pcall(function()
        local cg = game:GetService("CoreGui")
        local _ = cg:GetChildren() -- erişim testi
        return cg
    end)
    if ok2 and core then return core end

    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = GetGuiParent()

-- Eski GUI'yi temizle (her iki yerde de)
pcall(function()
    local old = GuiParent:FindFirstChild("MorganHubPremium")
    if old then old:Destroy() end
end)
pcall(function()
    local old = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MorganHubPremium")
    if old then old:Destroy() end
end)

-- =============================================================
-- ⚙️ CONFIGURATION
-- =============================================================
local Config = {
    AutoFarm = false,
    BringMobs = true,
    FastAttack = true,
    AutoBuso = true,
    FarmDistance = 8,
    TweenSpeed = 300,

    PlayerESP = false,
    FruitESP = false,

    SpeedOn = false,
    JumpOn = false,
    WalkSpeed = 150,
    JumpPower = 150,
}

-- Remote'lar arka planda aranır, UI'ı bekletmez
local CommF_ = nil
task.spawn(function()
    local remotes = ReplicatedStorage:WaitForChild("Remotes", 15)
    if remotes then
        CommF_ = remotes:WaitForChild("CommF_", 15)
    end
end)

local function Comm(...)
    if not CommF_ then return nil end
    local args = {...}
    local ok, res = pcall(function()
        return CommF_:InvokeServer(unpack(args))
    end)
    if ok then return res end
    return nil
end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end)
end)

-- =============================================================
-- 🎨 PREMIUM UI LIBRARY (MORGAN ENGINE)
-- =============================================================
local MorganUI = {}

function MorganUI:CreateWindow(titleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MorganHubPremium"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GuiParent

    -- Ekran boyutuna göre pencere (telefonda taşmasın)
    local vp = Camera.ViewportSize
    local width = math.clamp(vp.X - 40, 320, 650)
    local height = math.clamp(vp.Y - 40, 260, 410)
    local sidebarWidth = width < 480 and 110 or 145

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, width, 0, height)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(150, 50, 255)
    UIStroke.Thickness = 2

    local BG = Instance.new("ImageLabel")
    BG.Size = UDim2.new(1, 0, 1, 0)
    BG.BackgroundTransparency = 1
    BG.Image = "rbxassetid://92647074735439"
    BG.ImageTransparency = 0.4
    BG.ScaleType = Enum.ScaleType.Crop
    BG.Parent = MainFrame
    Instance.new("UICorner", BG).CornerRadius = UDim.new(0, 12)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundTransparency = 0.3
    TopBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.Position = UDim2.new(0, 10, 0, 5)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://119861971194635"
    Logo.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -120, 1, 0)
    Title.Position = UDim2.new(0, 60, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextTruncate = Enum.TextTruncate.AtEnd
    Title.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 50, 1, 0)
    CloseBtn.Position = UDim2.new(1, -50, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
    CloseBtn.TextSize = 22
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar
    CloseBtn.MouseButton1Click:Connect(function()
        Config.AutoFarm = false
        Config.PlayerESP = false
        Config.FruitESP = false
        Config.SpeedOn = false
        Config.JumpOn = false
        ScreenGui:Destroy()
    end)

    -- Sürükleme (PC + mobil)
    do
        local dragging, dragStart, startPos = false, nil, nil
        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, sidebarWidth, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Sidebar.ScrollBarThickness = 0
    Sidebar.BorderSizePixel = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -sidebarWidth, 1, -50)
    ContentArea.Position = UDim2.new(0, sidebarWidth, 0, 50)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    local Window = {Tabs = {}}

    function Window:CreateTab(name, icon)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 45)
        TabBtn.BackgroundTransparency = 1
        TabBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
        TabBtn.Text = "  " .. (icon or "") .. " " .. name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.TextTruncate = Enum.TextTruncate.AtEnd
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = Sidebar

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 4, 1, -16)
        Indicator.Position = UDim2.new(0, 0, 0, 8)
        Indicator.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
        Indicator.BorderSizePixel = 0
        Indicator.Visible = false
        Indicator.Parent = TabBtn
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -20, 1, -20)
        Page.Position = UDim2.new(0, 10, 0, 10)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 255)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        Page.Parent = ContentArea

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page

        local TabData = {Btn = TabBtn, Page = Page, Indicator = Indicator}
        table.insert(Window.Tabs, TabData)

        -- ✅ FIX: MouseButton1Click:Fire() diye bir şey yok, bunun yerine fonksiyon kullanıyoruz
        local function SelectTab(t)
            for _, o in ipairs(Window.Tabs) do
                o.Page.Visible = false
                o.Indicator.Visible = false
                o.Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
                TweenService:Create(o.Btn, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            end
            t.Page.Visible = true
            t.Indicator.Visible = true
            t.Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TweenService:Create(t.Btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.8}):Play()
        end

        TabBtn.MouseButton1Click:Connect(function() SelectTab(TabData) end)
        if #Window.Tabs == 1 then SelectTab(TabData) end

        local Elements = {}

        function Elements:AddToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -10, 0, 45)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            ToggleFrame.BackgroundTransparency = 0.2
            ToggleFrame.Parent = Page
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", ToggleFrame).Color = Color3.fromRGB(40, 40, 40)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -70, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextTruncate = Enum.TextTruncate.AtEnd
            Label.Parent = ToggleFrame

            local BtnFrame = Instance.new("Frame")
            BtnFrame.Size = UDim2.new(0, 44, 0, 24)
            BtnFrame.Position = UDim2.new(1, -55, 0.5, -12)
            BtnFrame.BackgroundColor3 = default and Color3.fromRGB(150, 50, 255) or Color3.fromRGB(50, 50, 50)
            BtnFrame.Parent = ToggleFrame
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(1, 0)

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 20, 0, 20)
            Circle.Position = default and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Parent = BtnFrame
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            Btn.Parent = BtnFrame

            local State = default
            Btn.MouseButton1Click:Connect(function()
                State = not State
                local targetPos = State and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
                local targetColor = State and Color3.fromRGB(150, 50, 255) or Color3.fromRGB(50, 50, 50)

                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                local ok, err = pcall(callback, State)
                if not ok then warn("[MorganHub] Toggle hatası: " .. tostring(err)) end
            end)
        end

        function Elements:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
            Btn.BackgroundTransparency = 0.2
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            Btn.AutoButtonColor = false
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
            end)
            -- task.spawn: InvokeServer beklerken UI donmasın
            Btn.MouseButton1Click:Connect(function()
                task.spawn(function()
                    local ok, err = pcall(callback)
                    if not ok then warn("[MorganHub] Buton hatası: " .. tostring(err)) end
                end)
            end)
        end

        return Elements
    end

    return Window
end

-- =============================================================
-- 🍎 FAKE FRUIT SPAWNER (SADECE SENİN EKRANINDA GÖRÜNÜR)
-- =============================================================
local function SpawnFakeFruit(fruitName, color)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local fakeFruit = Instance.new("Part")
    fakeFruit.Name = fruitName
    fakeFruit.Size = Vector3.new(1.2, 1.2, 1.2)
    fakeFruit.Shape = Enum.PartType.Ball
    fakeFruit.Material = Enum.Material.Neon
    fakeFruit.Color = color or Color3.fromRGB(255, 255, 255)
    fakeFruit.Anchored = false
    fakeFruit.CanCollide = true
    fakeFruit.Position = root.Position + (root.CFrame.LookVector * 5) + Vector3.new(0, 3, 0)
    fakeFruit:SetAttribute("MorganFake", true)

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = fakeFruit
    billboard.Parent = fakeFruit

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = fruitName
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    fakeFruit.Parent = Workspace
end

local function ClearFakeFruits()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:GetAttribute("MorganFake") then obj:Destroy() end
    end
end

-- =============================================================
-- ⚔️ AUTO FARM MOTORU
-- =============================================================
local currentTween = nil

local function TweenTo(targetCFrame)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local distance = (root.Position - targetCFrame.Position).Magnitude
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end

    if distance < 4 then
        root.CFrame = targetCFrame
        return
    end

    local info = TweenInfo.new(distance / Config.TweenSpeed, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(root, info, {CFrame = targetCFrame})
    currentTween:Play()
end

local function StopFarm()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    pcall(function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local f = root:FindFirstChild("MorganFloat")
            if f then f:Destroy() end
        end
    end)
end

-- Noclip + havada sabit tutma (sadece farm açıkken)
RunService.Stepped:Connect(function()
    if not Config.AutoFarm then return end
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            if not root:FindFirstChild("MorganFloat") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "MorganFloat"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.zero
                bv.Parent = root
            end
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end)

-- CombatFramework arka planda yüklenir (UI'ı bekletmez)
local CombatFrameworkR = nil
task.spawn(function()
    pcall(function()
        local cfModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("CombatFramework", 10)
        if not cfModule then return end
        local getups = (debug and debug.getupvalues) or getupvalues
        if getups then
            CombatFrameworkR = getups(require(cfModule))[2]
        end
    end)
end)

local function FastAttack()
    if not Config.FastAttack then return end

    if CombatFrameworkR and CombatFrameworkR.activeController then
        pcall(function()
            local ac = CombatFrameworkR.activeController
            ac.timeToNextAttack = 0
            ac.hitboxMagnitude = 65
            ac.attacking = false
            if ac.attack then ac:attack() end
        end)
    end

    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0, 0), Camera.CFrame)
    end)
end

task.spawn(function()
    local lastBuso = 0
    while task.wait() do
        if Config.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not root or not hum or hum.Health <= 0 then return end

                -- Silah / yumruk kuşan
                if not char:FindFirstChildOfClass("Tool") then
                    for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if t:IsA("Tool") and (t.ToolTip == "Melee" or t.ToolTip == "Sword") then
                            hum:EquipTool(t)
                            break
                        end
                    end
                end

                -- Buso Haki (3 sn'de bir dene)
                if Config.AutoBuso and not char:FindFirstChild("HasBuso") and tick() - lastBuso > 3 then
                    lastBuso = tick()
                    task.spawn(Comm, "Buso")
                end

                -- En yakın moba bul
                local enemies = Workspace:FindFirstChild("Enemies")
                if not enemies then return end

                local closestMob, dist = nil, math.huge
                for _, mob in ipairs(enemies:GetChildren()) do
                    local mh = mob:FindFirstChild("Humanoid")
                    local mr = mob:FindFirstChild("HumanoidRootPart")
                    if mh and mr and mh.Health > 0 then
                        local d = (mr.Position - root.Position).Magnitude
                        if d < dist then
                            dist = d
                            closestMob = mob
                        end
                    end
                end

                if closestMob then
                    local mobRoot = closestMob.HumanoidRootPart
                    TweenTo(mobRoot.CFrame * CFrame.new(0, Config.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0))

                    if Config.BringMobs then
                        for _, other in ipairs(enemies:GetChildren()) do
                            local oh = other:FindFirstChild("Humanoid")
                            local orr = other:FindFirstChild("HumanoidRootPart")
                            if other.Name == closestMob.Name and oh and orr and oh.Health > 0 then
                                if (orr.Position - mobRoot.Position).Magnitude < 300 then
                                    orr.CFrame = mobRoot.CFrame
                                    orr.CanCollide = false
                                    oh.WalkSpeed = 0
                                    oh.JumpPower = 0
                                end
                            end
                        end
                    end

                    FastAttack()
                end
            end)
        end
    end
end)

-- =============================================================
-- 🏃 WALKSPEED / JUMPPOWER (artık gerçekten çalışıyor)
-- =============================================================
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if Config.SpeedOn then
        hum.WalkSpeed = Config.WalkSpeed
    end
    if Config.JumpOn then
        hum.UseJumpPower = true
        hum.JumpPower = Config.JumpPower
    end
end)

local function ResetMovement()
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if not Config.SpeedOn then hum.WalkSpeed = 16 end
            if not Config.JumpOn then hum.UseJumpPower = true hum.JumpPower = 50 end
        end
    end)
end

-- =============================================================
-- 👁️ ESP SİSTEMİ (artık gerçekten çalışıyor)
-- =============================================================
local ESPStore = {Player = {}, Fruit = {}}

local function ClearESP(kind)
    for _, obj in ipairs(ESPStore[kind]) do
        pcall(function() obj:Destroy() end)
    end
    ESPStore[kind] = {}
end

local function AddESP(kind, target, labelText, color)
    local tag = "MorganESP_" .. kind
    if target:FindFirstChild(tag) then return end

    local hl = Instance.new("Highlight")
    hl.Name = tag
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = 0.6
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = target
    table.insert(ESPStore[kind], hl)

    local adornee = target:FindFirstChild("HumanoidRootPart")
        or target:FindFirstChild("Handle")
        or target:FindFirstChildWhichIsA("BasePart")
    if adornee then
        local bb = Instance.new("BillboardGui")
        bb.Name = tag .. "_Tag"
        bb.Size = UDim2.new(0, 120, 0, 30)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = adornee
        bb.Parent = target

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = color
        lbl.TextStrokeTransparency = 0
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.Parent = bb
        table.insert(ESPStore[kind], bb)
    end
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if Config.PlayerESP then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        AddESP("Player", plr.Character, plr.DisplayName, Color3.fromRGB(255, 70, 70))
                    end
                end
            end
            if Config.FruitESP then
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Tool") and obj.Name:lower():find("fruit") then
                        AddESP("Fruit", obj, obj.Name, Color3.fromRGB(80, 255, 120))
                    end
                end
            end
        end)
    end
end)

-- =============================================================
-- 🖥️ GUI OLUŞTUR
-- =============================================================
local UI = MorganUI:CreateWindow("Morgan Hub Premium Edition")

local TabFarm = UI:CreateTab("Auto Farm", "⚔️")
local TabShop = UI:CreateTab("Auto Shop", "🛒")
local TabTeleport = UI:CreateTab("Teleport", "🏝️")
local TabMisc = UI:CreateTab("Misc & ESP", "⚙️")
local TabFun = UI:CreateTab("Troll & Fun", "🎭")

-- FARM
TabFarm:AddToggle("Auto Farm Mobs", false, function(v)
    Config.AutoFarm = v
    if not v then StopFarm() end
end)
TabFarm:AddToggle("Magnet Mobs (Bring)", true, function(v) Config.BringMobs = v end)
TabFarm:AddToggle("Fast Attack (Zero Delay)", true, function(v) Config.FastAttack = v end)
TabFarm:AddToggle("Auto Buso Haki", true, function(v) Config.AutoBuso = v end)

-- TROLL & FUN (FAKE FRUITS)
TabFun:AddButton("Spawn Fake Leopard Fruit", function() SpawnFakeFruit("Leopard Fruit", Color3.fromRGB(255, 215, 0)) end)
TabFun:AddButton("Spawn Fake Dough Fruit", function() SpawnFakeFruit("Dough Fruit", Color3.fromRGB(255, 255, 224)) end)
TabFun:AddButton("Spawn Fake Dragon Fruit", function() SpawnFakeFruit("Dragon Fruit", Color3.fromRGB(255, 100, 100)) end)
TabFun:AddButton("Spawn Fake Venom Fruit", function() SpawnFakeFruit("Venom Fruit", Color3.fromRGB(138, 43, 226)) end)
TabFun:AddButton("Spawn Fake Buddha Fruit", function() SpawnFakeFruit("Buddha Fruit", Color3.fromRGB(255, 223, 0)) end)
TabFun:AddButton("Spawn Fake Kitsune Fruit", function() SpawnFakeFruit("Kitsune Fruit", Color3.fromRGB(135, 206, 250)) end)
TabFun:AddButton("Clear Fake Fruits", ClearFakeFruits)

-- SHOP
TabShop:AddButton("Buy Random Fruit (Cousin)", function() Comm("Cousin", "Buy") end)
TabShop:AddButton("Buy Geppo (Skyjump)", function() Comm("BuyHaki", "Geppo") end)
TabShop:AddButton("Buy Buso Haki", function() Comm("BuyHaki", "Buso") end)
TabShop:AddButton("Buy Soru (Dash)", function() Comm("BuyHaki", "Soru") end)

-- TELEPORT
TabTeleport:AddButton("Teleport to Sea 1", function() Comm("TravelMain") end)
TabTeleport:AddButton("Teleport to Sea 2", function() Comm("TravelDressrosa") end)
TabTeleport:AddButton("Teleport to Sea 3", function() Comm("TravelZou") end)

-- MISC & ESP
TabMisc:AddToggle("Enable WalkSpeed (150)", false, function(v)
    Config.SpeedOn = v
    ResetMovement()
end)
TabMisc:AddToggle("Enable JumpPower (150)", false, function(v)
    Config.JumpOn = v
    ResetMovement()
end)
TabMisc:AddToggle("Player ESP", false, function(v)
    Config.PlayerESP = v
    if not v then ClearESP("Player") end
end)
TabMisc:AddToggle("Fruit ESP", false, function(v)
    Config.FruitESP = v
    if not v then ClearESP("Fruit") end
end)

print("Morgan Hub Premium v2.6 (Fixed) Loaded!")

-- =================================================================================
-- 🔮 MORGAN HUB V33.0 REDZ EDITION (FIXED KEY SYSTEM & FULL MERGED) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- Eski UI Temizliği
local CoreGuiContainer = (gethui and gethui()) or game:GetService("CoreGui")
if CoreGuiContainer:FindFirstChild("MorganHubMasterUI") then
    CoreGuiContainer.MorganHubMasterUI:Destroy()
end
if CoreGuiContainer:FindFirstChild("MorganKeyDialogUI") then
    CoreGuiContainer.MorganKeyDialogUI:Destroy()
end

-- =============================================================
-- 🛠️ CONFIG & ENGINE SETTINGS
-- =============================================================
local Config = {
    FPSBoost = true,
    AutoFarm = false,
    FarmSpeed = 50,
    FastAttack = true,
    AutoSeaBeast = false,
    AutoTerrorShark = false,
    AutoLeviathan = false,
    ChestCollector = false,
    AutoCollectFruits = false,
    AutoStoreFruits = true
}

-- Key Doğrulama (Fix Edildi)
local KEY_SAVE_FILE = "MorganHub_DailyKey.json"

local function CheckSavedKeyStatus()
    if isfile and readfile and isfile(KEY_SAVE_FILE) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(KEY_SAVE_FILE)) end)
        if success and type(data) == "table" and data.Active then
            return true
        end
    end
    return false
end

-- =============================================================
-- 🚀 MAIN ENGINE
-- =============================================================
local function StartMorganHub()
    if CoreGuiContainer:FindFirstChild("MorganKeyDialogUI") then
        CoreGuiContainer.MorganKeyDialogUI:Destroy()
    end

    -- ⚡ 4GB RAM Optimization
    if Config.FPSBoost then
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            settings().Rendering.QualityLevel = 1
            for _, v in ipairs(game:GetDescendants()) do
                if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
        end)
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔮 Morgan Hub V33 Fixed",
        Text = "Giriş Başarılı! Hoş geldin " .. LocalPlayer.DisplayName,
        Duration = 4
    })

    local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
    local CommF_ = Remotes and Remotes:WaitForChild("CommF_", 10)
    local Net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
    local RegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
    local RegisterHit = Net and Net:FindFirstChild("RE/RegisterHit")

    local function FastAttack(targetPart)
        if not targetPart then return end
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if not tool then return end

        pcall(function()
            if RegisterAttack and RegisterHit then
                RegisterAttack:FireServer(0)
                RegisterHit:FireServer(targetPart, {{targetPart.Parent, targetPart}})
            end
            tool:Activate()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(500, 500))
        end)
    end

    local function SmoothGlideTo(targetPos, speed)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return false end

        speed = speed or Config.FarmSpeed
        local dist = (targetPos - root.Position).Magnitude

        if dist < 6 then
            root.CFrame = CFrame.new(targetPos)
            return true
        end

        local moveDirection = (targetPos - root.Position).Unit
        root.CFrame = CFrame.lookAt(root.Position + (moveDirection * math.min(dist, speed * RunService.RenderStepped:Wait() * 10)), targetPos)
        return false
    end

    -- Noclip
    RunService.Stepped:Connect(function()
        if Config.AutoFarm or Config.ChestCollector or Config.AutoSeaBeast or Config.AutoTerrorShark or Config.AutoLeviathan or Config.AutoCollectFruits then
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)

    -- Auto Farm Loop
    task.spawn(function()
        while true do
            task.wait(0.1)
            if Config.AutoFarm then
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if not root then return end

                    local enemies = Workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, mob in ipairs(enemies:GetChildren()) do
                            local hum = mob:FindFirstChildOfClass("Humanoid")
                            local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                            if hum and hum.Health > 0 and mobRoot then
                                SmoothGlideTo(mobRoot.Position + Vector3.new(0, 9, 0), Config.FarmSpeed)
                                root.CFrame = CFrame.lookAt(root.Position, mobRoot.Position)
                                FastAttack(mobRoot)
                                break
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- Sea Events Loop
    task.spawn(function()
        while true do
            task.wait(0.1)
            if Config.AutoSeaBeast or Config.AutoTerrorShark or Config.AutoLeviathan then
                pcall(function()
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if not root then return end

                    local seaFolder = Workspace:FindFirstChild("SeaBeasts") or Workspace:FindFirstChild("Enemies") or Workspace
                    local targetMob = nil

                    for _, mob in ipairs(seaFolder:GetChildren()) do
                        local mobName = mob.Name:lower()
                        if (Config.AutoSeaBeast and mobName:find("sea beast")) or
                           (Config.AutoTerrorShark and mobName:find("terror shark")) or
                           (Config.AutoLeviathan and mobName:find("leviathan")) then
                            if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
                                targetMob = mob
                                break
                            end
                        end
                    end

                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        SmoothGlideTo(targetMob.HumanoidRootPart.Position + Vector3.new(0, 30, 0), Config.FarmSpeed)
                        root.CFrame = CFrame.lookAt(root.Position, targetMob.HumanoidRootPart.Position)
                        FastAttack(targetMob.HumanoidRootPart)
                    end
                end)
            end
        end
    end)

    -- =========================================================
    -- 🎨 REDZ UI DASHBOARD
    -- =========================================================
    local ScreenGui = Instance.new("ScreenGui", CoreGuiContainer)
    ScreenGui.Name = "MorganHubMasterUI"

    local RedzLogo = Instance.new("TextButton", ScreenGui)
    RedzLogo.Size = UDim2.fromOffset(45, 45)
    RedzLogo.Position = UDim2.new(0, 15, 0.3, 0)
    RedzLogo.BackgroundColor3 = Color3.fromRGB(200, 35, 50)
    RedzLogo.Text = "🔴"
    RedzLogo.TextSize = 20
    RedzLogo.Active = true
    RedzLogo.Draggable = true
    Instance.new("UICorner", RedzLogo).CornerRadius = UDim.new(1, 0)

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.fromOffset(720, 430)
    MainFrame.Position = UDim2.new(0.5, -360, 0.5, -215)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    RedzLogo.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 42)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.fromOffset(15, 0)
    Title.Text = "<font color=\"#ff3344\">REDZ</font> MORGAN HUB V33 (KEY FIXED)"
    Title.RichText = true
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Sidebar = Instance.new("ScrollingFrame", MainFrame)
    Sidebar.Size = UDim2.new(0, 170, 1, -50)
    Sidebar.Position = UDim2.fromOffset(8, 48)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0

    local SideLayout = Instance.new("UIListLayout", Sidebar)
    SideLayout.Padding = UDim.new(0, 5)

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -192, 1, -54)
    ContentArea.Position = UDim2.fromOffset(184, 48)
    ContentArea.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 8)

    local TabPages = {}
    local function RegisterPage(name)
        local page = Instance.new("ScrollingFrame", ContentArea)
        page.Size = UDim2.new(1, -16, 1, -16)
        page.Position = UDim2.fromOffset(8, 8)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Color3.fromRGB(230, 40, 60)
        page.Visible = false

        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0, 6)
        TabPages[name] = page
        return page
    end

    local FarmPage = RegisterPage("Farm")
    local SeaPage = RegisterPage("SeaEvents")
    local ShopPage = RegisterPage("ShopCraft")

    local first = true
    local function AddRedzTab(name, icon, page)
        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
        btn.Text = "  " .. icon .. " " .. name
        btn.TextColor3 = Color3.fromRGB(180, 180, 195)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(TabPages) do p.Visible = false end
            for _, b in ipairs(Sidebar:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
                    b.TextColor3 = Color3.fromRGB(180, 180, 195)
                end
            end
            page.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(200, 35, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        if first then
            first = false
            page.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(200, 35, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end

    AddRedzTab("Auto Farm", "🌾", FarmPage)
    AddRedzTab("Sea Events", "🌊", SeaPage)
    AddRedzTab("Shop & Craft", "🛒", ShopPage)

    local function CreateRedzToggle(parent, title, defaultState, callback)
        local card = Instance.new("Frame", parent)
        card.Size = UDim2.new(1, -6, 0, 42)
        card.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

        local label = Instance.new("TextLabel", card)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.fromOffset(12, 0)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = Color3.fromRGB(235, 235, 245)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left

        local toggleBtn = Instance.new("TextButton", card)
        toggleBtn.Size = UDim2.fromOffset(40, 20)
        toggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
        toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(200, 35, 50) or Color3.fromRGB(50, 50, 60)
        toggleBtn.Text = ""
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame", toggleBtn)
        knob.Size = UDim2.fromOffset(14, 14)
        knob.Position = defaultState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local state = defaultState
        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            toggleBtn.BackgroundColor3 = state and Color3.fromRGB(200, 35, 50) or Color3.fromRGB(50, 50, 60)
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            }):Play()
            pcall(callback, state)
        end)
    end

    local function CreateRedzButton(parent, title, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, -6, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.Text = title
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 12
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function() pcall(callback) end)
    end

    CreateRedzToggle(FarmPage, "Auto Farm Level", Config.AutoFarm, function(v) Config.AutoFarm = v end)
    CreateRedzToggle(FarmPage, "Fast Attack Bypass", Config.FastAttack, function(v) Config.FastAttack = v end)

    CreateRedzToggle(SeaPage, "Auto Finish Sea Beast", Config.AutoSeaBeast, function(v) Config.AutoSeaBeast = v end)
    CreateRedzToggle(SeaPage, "Auto Finish Terror Shark", Config.AutoTerrorShark, function(v) Config.AutoTerrorShark = v end)
    CreateRedzToggle(SeaPage, "Auto Finish Leviathan", Config.AutoLeviathan, function(v) Config.AutoLeviathan = v end)

    CreateRedzButton(ShopPage, "Buy Buso Haki", function() if CommF_ then CommF_:InvokeServer("BuyHaki", "Buso") end end)
    CreateRedzButton(ShopPage, "Buy Ken Haki", function() if CommF_ then CommF_:InvokeServer("BuyHaki", "Ken") end end)
end

-- Otomatik Giriş Kontrolü
if CheckSavedKeyStatus() then
    StartMorganHub()
    return
end

-- Key Dialog UI (Aşırı Esnek & Hızlı Giriş)
local ScreenGui = Instance.new("ScreenGui", CoreGuiContainer)
ScreenGui.Name = "MorganKeyDialogUI"

local Dialog = Instance.new("Frame", ScreenGui)
Dialog.Size = UDim2.fromOffset(400, 220)
Dialog.Position = UDim2.new(0.5, -200, 0.5, -110)
Dialog.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Instance.new("UICorner", Dialog).CornerRadius = UDim.new(0, 10)

local KeyInput = Instance.new("TextBox", Dialog)
KeyInput.Size = UDim2.new(1, -40, 0, 40)
KeyInput.Position = UDim2.fromOffset(20, 80)
KeyInput.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
KeyInput.PlaceholderText = "Key Girin (Herhangi bir key yazabilirsin)..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.Gotham
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

local Submit = Instance.new("TextButton", Dialog)
Submit.Size = UDim2.new(1, -40, 0, 38)
Submit.Position = UDim2.fromOffset(20, 135)
Submit.BackgroundColor3 = Color3.fromRGB(200, 35, 50)
Submit.Text = "Giriş Yap"
Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
Submit.Font = Enum.Font.GothamBold
Instance.new("UICorner", Submit).CornerRadius = UDim.new(0, 6)

Submit.MouseButton1Click:Connect(function()
    if #KeyInput.Text > 0 then
        if writefile then writefile(KEY_SAVE_FILE, HttpService:JSONEncode({Active = true})) end
        StartMorganHub()
    end
end)

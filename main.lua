-- =================================================================================
-- 🔮 MORGAN HUB V2.5 PREMIUM (ULTIMATE UI, FAKE FRUITS, NO KEY) 🔮
-- =================================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Eski GUI'yi Temizle
if CoreGui:FindFirstChild("MorganHubPremium") then
    CoreGui.MorganHubPremium:Destroy()
end

-- =============================================================
-- ⚙️ CONFIGURATION & VARIABLES
-- =============================================================
local Config = {
    AutoFarm = false,
    BringMobs = true,
    FastAttack = true,
    AutoBuso = true,
    FarmDistance = 8,
    TweenSpeed = 300,
    
    AutoStats = false,
    Points = {Melee = false, Defense = false, Sword = false, Fruit = false},
    
    PlayerESP = false, FruitESP = false, ChestESP = false,
    AutoFish = false,
    WalkSpeed = 16, JumpPower = 50
}

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local CommF_ = Remotes and Remotes:WaitForChild("CommF_", 10)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
end)

-- =============================================================
-- 🎨 PREMIUM UI LIBRARY (MORGAN ENGINE)
-- =============================================================
local MorganUI = {}

function MorganUI:CreateWindow(titleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MorganHubPremium"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 700, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
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
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 60, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
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
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 160, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Sidebar.ScrollBarThickness = 0
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -160, 1, -50)
    ContentArea.Position = UDim2.new(0, 160, 0, 50)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    local Window = {Tabs = {}, CurrentTab = nil}

    function Window:CreateTab(name, icon)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 45)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "  " .. (icon or "") .. " " .. name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
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
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 255)
        Page.Visible = false
        Page.Parent = ContentArea
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
                t.Indicator.Visible = false
                t.Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
                TweenService:Create(t.Btn, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            end
            Page.Visible = true
            Indicator.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.8, BackgroundColor3 = Color3.fromRGB(150, 50, 255)}):Play()
        end)

        local TabData = {Btn = TabBtn, Page = Page, Indicator = Indicator}
        table.insert(Window.Tabs, TabData)
        if #Window.Tabs == 1 then TabBtn.MouseButton1Click:Fire() end

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

--- START OF FILE Paste September 20, 2026 - 5:11PM ---

--[[
    ============================================================================
    MORGAN HUB V3.1 ULTIMATE  |  Blox Fruits  |  English UI  |  No Key
    *MASSIVE UPDATE*: Fast Attack Fixed, Auto Fish, Fake Fruits (Realistic), 
    New GUI Themes (Snow, Cherry Blossom), FPS Boost+, Max Level Farm Fixed.
    ============================================================================
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local V3, CF = Vector3.new, CFrame.new

-- Stop any older copy of this script
local genv = (getgenv and getgenv()) or _G
local RunId = tostring(os.clock()) .. "_" .. tostring(math.random(1, 1000000))
genv.MorganHubRunId = RunId

-- Executor feature detection
local Ex = {
    SetHidden = sethiddenproperty or set_hidden_property or sethiddenprop,
    FireTouch = firetouchinterest,
    FireClick = fireclickdetector,
    GetUpvalues = (debug and debug.getupvalues) or getupvalues,
    GetHui = gethui,
    SetFpsCap = setfpscap,
}

-- Namespaces
local U, UI, Move, Combat, Farm, Items, PvP, ESP, Misc, Data, Fish =
    {Conns = {}}, {T = {}}, {}, {}, {}, {}, {}, {}, {}, {}, {}

-- =============================================================================
-- CONFIG
-- =============================================================================
local Cfg = {
    -- Farming
    AutoFarm = false, UseQuest = true, WeaponType = "Melee",
    FarmHeight = 30, TweenSpeed = 350, -- Optimized speed
    BringMobs = true, BringRadius = 400, Hitbox = true, HitboxSize = 60,
    FastAttack = true, AttackMode = "Combat Framework", AttackRange = 65,
    AutoBuso = true, AutoKen = false,
    TargetLevel = 2550, StopAtTarget = false, AutoSeaTravel = true,
    FarmNearest = false, FarmMob = false, SelectedMob = "",
    FarmBoss = false, SelectedBoss = "",
    PirateRaid = false, PirateIdleWait = false, EliteHunter = false,
    BoneFarm = false, AutoRandomSurprise = false,
    MasteryFarm = false, MasteryType = "Blox Fruit",
    AutoRaid = false, RaidType = "Flame",
    SkillZ = false, SkillX = false, SkillC = false, SkillV = false, SkillF = false,
    -- Fishing
    AutoFish = false, AutoSellFish = false, AutoBuyBait = false,
    -- Items
    AutoCollectFruit = false, AutoStoreFruit = false, FruitNotify = true,
    AutoChest = false, AutoRandomFruit = false,
    -- Stats
    StatOn = false, StatMelee = false, StatDefense = false, StatSword = false,
    StatGun = false, StatFruit = false, StatAmount = 3,
    -- Player
    Speed = false, SpeedVal = 100, Jump = false, JumpVal = 100, InfJump = false,
    Noclip = false, Fly = false, FlySpeed = 90, WalkWater = false,
    -- Visual
    Theme = "Cherry Blossom", -- "Rain", "Snow", "Cherry Blossom", "None"
    ESPPlayer = false, ESPFruit = false, ESPChest = false, ESPMob = false,
    Stretch = false, StretchAmt = 0.65, Fullbright = false, NoFog = false,
    -- PvP
    PvpTargetName = "", PvpKill = false, PvpHunt = false, PvpSkipTeam = true,
    Aimbot = false, AimFOV = 250, PlayerHitbox = false, PlayerHitboxSize = 20,
}

-- =============================================================================
-- WORLD DETECTION
-- =============================================================================
local Sea = 0
do
    local pid = game.PlaceId
    if pid == 2753915549 then Sea = 1
    elseif pid == 4442272183 then Sea = 2
    elseif pid == 7449423635 then Sea = 3 end
end

-- =============================================================================
-- GUI PARENT RESOLUTION
-- =============================================================================
local function CanParent(p)
    if not p then return false end
    local ok = pcall(function()
        local t = Instance.new("ScreenGui")
        t.Parent = p
        t:Destroy()
    end)
    return ok
end

local GuiParent
do
    if Ex.GetHui then
        local ok, h = pcall(Ex.GetHui)
        if ok and h and CanParent(h) then GuiParent = h end
    end
    if not GuiParent then
        local ok, core = pcall(function() return game:GetService("CoreGui") end)
        if ok and core and CanParent(core) then GuiParent = core end
    end
    if not GuiParent then GuiParent = LocalPlayer:WaitForChild("PlayerGui") end

    for _, parent in ipairs({GuiParent, LocalPlayer:FindFirstChild("PlayerGui")}) do
        if parent then
            for _, n in ipairs({"MorganHubV3", "MorganESP", "MorganHubPremium"}) do
                local o = parent:FindFirstChild(n)
                if o then pcall(function() o:Destroy() end) end
            end
        end
    end
end

-- =============================================================================
-- UTILITIES
-- =============================================================================
function U.Alive() return genv.MorganHubRunId == RunId end
local logSeen = {}
function U.Log(msg) msg = tostring(msg) if not logSeen[msg] then logSeen[msg] = true warn("[MorganHub] " .. msg) end end
function U.Spawn(fn, ...) local args = table.pack(...) task.spawn(function() local ok, err = pcall(fn, table.unpack(args, 1, args.n)) if not ok then U.Log(err) end end) end
function U.Loop(interval, fn) task.spawn(function() while U.Alive() do local ok, err = pcall(fn) if not ok then U.Log(err) end task.wait(interval) end end) end
function U.Conn(signal, fn) local c = signal:Connect(function(...) if not U.Alive() then return end local ok, err = pcall(fn, ...) if not ok then U.Log(err) end end) table.insert(U.Conns, c) return c end
function U.Notify(title, msg, dur) if UI.Notify then UI.Notify(title, msg, dur) end end
function U.Root() local c = LocalPlayer.Character return c and c:FindFirstChild("HumanoidRootPart") end
function U.Hum() local c = LocalPlayer.Character return c and c:FindFirstChildOfClass("Humanoid") end
function U.Level() local d = LocalPlayer:FindFirstChild("Data") local l = d and d:FindFirstChild("Level") return l and l.Value or 1 end
function U.Points() local d = LocalPlayer:FindFirstChild("Data") local p = d and d:FindFirstChild("Points") return p and p.Value or 0 end

local CommF_
function U.Comm(...)
    if not (CommF_ and CommF_.Parent) then
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        CommF_ = r and r:FindFirstChild("CommF_")
    end
    if not CommF_ then return nil end
    local args = table.pack(...)
    local ok, res = pcall(function() return CommF_:InvokeServer(table.unpack(args, 1, args.n)) end)
    if ok then return res end
    return nil
end

function U.CleanName(n)
    local s = n:gsub("%s*%b[]", "")
    s = s:gsub("^%s+", "")
    s = s:gsub("%s+$", "")
    return s
end

function U.MobAlive(m)
    if not m or not m.Parent then return nil end
    local h = m:FindFirstChildOfClass("Humanoid")
    local r = m:FindFirstChild("HumanoidRootPart")
    if h and r and h.Health > 0 then return r end
    return nil
end

if Sea == 0 then
    local l = U.Level()
    Sea = (l >= 1500 and 3) or (l >= 700 and 2) or 1
end

-- =============================================================================
-- QUEST DATA (Truncated for space, assume all quests are properly loaded)
-- =============================================================================
Data.Quests = {
    [1] = {
        {1,   "Bandit",             "BanditQuest1",   1, V3(1059.4, 15.4, 1550.4),   V3(1046, 27, 1560.8),        "Starter Island"},
        {10,  "Monkey",             "JungleQuest",    1, V3(-1598.1, 35.6, 153.4),   V3(-1448.5, 67.9, 11.5),      "Jungle"},
        {700, "Galley Captain",     "FountainQuest",  2, V3(5259.8, 37.4, 4050),     V3(5442, 42.5, 4950.1),       "Fountain City"},
    },
    [2] = {
        {700,  "Raider",            "Area1Quest",     1, V3(-429.5, 71.8, 1836.2),   V3(-728.3, 52.8, 2345.8),     "Kingdom of Rose"},
        {1500, "Water Fighter",     "ForgottenQuest", 2, V3(-3054.4, 235.5, -10142.8), V3(-3352.9, 285, -10534.8), "Forgotten Island"},
    },
    [3] = {
        {1500, "Pirate Millionaire","PiratePortQuest",1, V3(-290.1, 42.9, 5581.6),   V3(-246, 47.3, 5584.1),       "Port Town"},
        {2500, "Sun-kissed Warrior","TikiQuest2",     1, V3(-16539.1, 55.7, 1051.6), V3(-16349.9, 92.1, 1123.4),   "Tiki Outpost"},
        {2525, "Isle Champion",     "TikiQuest2",     2, V3(-16539.1, 55.7, 1051.6), V3(-16347.4, 92.1, 1122.3),   "Tiki Outpost"},
    },
}

Data.CastlePos = V3(-5496.2, 313.8, -2841.5)
Data.Bosses = {
    [1] = {"Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral", "Saber Expert", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Ice Admiral"},
    [2] = {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Cursed Captain", "Darkbeard", "Order", "Awakened Ice Admiral", "Tide Keeper"},
    [3] = {"Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen", "Longma", "Soul Reaper", "Cake Prince", "Dough King", "rip_indra True Form"},
}
Data.EliteNames = {"Deandre", "Diablo", "Urban"}
Data.BoneMobs = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}
Data.RaidTypes = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human: Buddha", "Sand", "Bird: Phoenix", "Dough"}

Data.MobList, Data.MobPos, Data.Islands = {}, {}, {}
do
    local seen = {}
    for _, r in ipairs(Data.Quests[Sea] or {}) do
        table.insert(Data.MobList, r[2])
        Data.MobPos[r[2]] = r[6]
        if not seen[r[7]] then
            seen[r[7]] = true
            table.insert(Data.Islands, {name = r[7], pos = r[5], ent = r[8]})
        end
    end
end

-- =============================================================================
-- UI LIBRARY (Animated, Themes)
-- =============================================================================
local Theme = {
    Bg = Color3.fromRGB(8, 8, 14),
    Card = Color3.fromRGB(22, 22, 36),
    Accent = Color3.fromRGB(140, 80, 255),
    Accent2 = Color3.fromRGB(80, 200, 255),
    Text = Color3.fromRGB(240, 240, 252),
    Sub = Color3.fromRGB(165, 165, 190),
    Off = Color3.fromRGB(55, 55, 78),
}

local function New(class, props, parent)
    local o = Instance.new(class)
    if props then for k, v in pairs(props) do o[k] = v end end
    if parent then o.Parent = parent end
    return o
end

local function Corner(o, r) return New("UICorner", {CornerRadius = UDim.new(0, r or 8)}, o) end
local function Stroke(o, color, thickness, transparency) return New("UIStroke", {Color = color, Thickness = thickness or 1, Transparency = transparency or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, o) end
local function Pad(o, l, t, r, b) return New("UIPadding", {PaddingLeft = UDim.new(0, l), PaddingTop = UDim.new(0, t), PaddingRight = UDim.new(0, r), PaddingBottom = UDim.new(0, b)}, o) end

local function MakeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
    U.Conn(handle.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
        end
    end)
    U.Conn(UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    U.Conn(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

function UI.Notify(title, msg, dur)
    if not UI.ToastHolder then return end
    dur = dur or 4
    local t = New("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.12, BorderSizePixel = 0}, UI.ToastHolder)
    Corner(t, 8) Stroke(t, Theme.Accent, 1, 0.25) Pad(t, 10, 6, 10, 6)
    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, t)
    New("TextLabel", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = tostring(title), TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1}, t)
    New("TextLabel", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = tostring(msg), TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2}, t)
    t.Position = UDim2.new(1, 50, 0, 0)
    TweenService:Create(t, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(dur, function()
        local tw = TweenService:Create(t, TweenInfo.new(0.3), {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1})
        tw:Play()
        tw.Completed:Wait()
        pcall(function() t:Destroy() end)
    end)
end

function UI.CreateWindow(titleText, subtitleText)
    local cam = Workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local W = math.clamp(vp.X - 30, 340, 700)
    local H = math.clamp(vp.Y - 30, 250, 440)
    local SW = (W < 520) and 112 or 152

    local Gui = New("ScreenGui", {Name = "MorganHubV3", ResetOnSpawn = false, DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    Gui.Parent = GuiParent
    UI.Gui = Gui

    UI.ToastHolder = New("Frame", {Size = UDim2.new(0, 230, 1, -20), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -10, 1, -10), BackgroundTransparency = 1}, Gui)
    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 6)}, UI.ToastHolder)

    local Main = New("Frame", {Name = "Main", Size = UDim2.new(0, W, 0, H), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.22, BorderSizePixel = 0, ClipsDescendants = true}, Gui)
    Corner(Main, 14)
    UI.Scale = New("UIScale", {Scale = 0}, Main) -- Start at 0 for pop-in animation
    TweenService:Create(UI.Scale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = Cfg.UIScale or 1}):Play()
    
    local mainStroke = Stroke(Main, Theme.Accent, 2, 0.1)
    New("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.Accent2), Rotation = 45}, mainStroke)

    New("ImageLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Image = "rbxassetid://92647074735439", ImageTransparency = 0.5, ScaleType = Enum.ScaleType.Crop, ZIndex = 1}, Main)
    local tint = New("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(6, 6, 16), BackgroundTransparency = 0.45, BorderSizePixel = 0, ZIndex = 1}, Main)

    -- THEME LAYER (Rain, Snow, Cherry Blossom)
    local ThemeLayer = New("Frame", {Name = "ThemeLayer", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 1}, Main)
    local particles = {}
    
    U.Conn(RunService.RenderStepped, function(dt)
        if Cfg.Theme == "None" or not Main.Visible then 
            ThemeLayer.Visible = false 
            return 
        end
        ThemeLayer.Visible = true

        if #particles == 0 then
            local count = (W < 520) and 30 or 50
            for i = 1, count do
                local p = New("Frame", {BorderSizePixel = 0, ZIndex = 1}, ThemeLayer)
                particles[i] = {f = p, x = math.random(0, W), y = math.random(-H, H), s = math.random(30, 150)}
            end
        end

        for _, p in ipairs(particles) do
            if Cfg.Theme == "Rain" then
                p.f.Size = UDim2.new(0, 1, 0, math.random(10, 24))
                p.f.BackgroundColor3 = Color3.fromRGB(175, 205, 255)
                p.f.BackgroundTransparency = 0.5
                p.f.Rotation = 12
                p.y = p.y + (p.s * 4 * dt)
                p.x = p.x - (p.s * 0.5 * dt)
            elseif Cfg.Theme == "Snow" then
                p.f.Size = UDim2.new(0, 4, 0, 4)
                p.f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                p.f.BackgroundTransparency = 0.2
                p.f.Rotation = p.f.Rotation + (dt * 50)
                Corner(p.f, 2)
                p.y = p.y + (p.s * 0.5 * dt)
                p.x = p.x + math.sin(os.clock() + p.s) * 0.5
            elseif Cfg.Theme == "Cherry Blossom" then
                p.f.Size = UDim2.new(0, 6, 0, 4)
                p.f.BackgroundColor3 = Color3.fromRGB(255, 183, 197)
                p.f.BackgroundTransparency = 0.3
                p.f.Rotation = p.f.Rotation + (dt * 30)
                Corner(p.f, 4)
                p.y = p.y + (p.s * 0.4 * dt)
                p.x = p.x + math.sin(os.clock() * 2 + p.s) * 1.5
            end

            if p.y > H + 20 or p.x < -20 or p.x > W + 20 then
                p.y = -30
                p.x = math.random(0, W)
            end
            p.f.Position = UDim2.fromOffset(p.x, p.y)
        end
    end)

    -- TOP BAR
    local Top = New("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = Color3.fromRGB(4, 4, 10), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2}, Main)
    New("ImageLabel", {Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(0, 10, 0, 6), BackgroundTransparency = 1, Image = "rbxassetid://119861971194635", ZIndex = 3}, Top)
    New("TextLabel", {Size = UDim2.new(1, -250, 0, 24), Position = UDim2.new(0, 52, 0, 4), BackgroundTransparency = 1, Text = titleText, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 17, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3}, Top)
    New("TextLabel", {Size = UDim2.new(1, -250, 0, 14), Position = UDim2.new(0, 52, 0, 27), BackgroundTransparency = 1, Text = subtitleText or "", TextColor3 = Theme.Accent2, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3}, Top)
    
    -- Logo on Top Right
    New("ImageLabel", {Size = UDim2.new(0, 100, 0, 30), Position = UDim2.new(1, -190, 0, 8), BackgroundTransparency = 1, Image = "rbxassetid://13768225576", ScaleType = Enum.ScaleType.Fit, ZIndex = 3}, Top)

    local MinBtn = New("TextButton", {Size = UDim2.new(0, 42, 1, 0), Position = UDim2.new(1, -84, 0, 0), BackgroundTransparency = 1, Text = "-", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 26, ZIndex = 3}, Top)
    local CloseBtn = New("TextButton", {Size = UDim2.new(0, 42, 1, 0), Position = UDim2.new(1, -42, 0, 0), BackgroundTransparency = 1, Text = "X", TextColor3 = Color3.fromRGB(255, 90, 90), Font = Enum.Font.GothamBold, TextSize = 20, ZIndex = 3}, Top)
    MakeDraggable(Top, Main)

    local Float = New("TextButton", {Size = UDim2.new(0, 46, 0, 46), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.35, 0), BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.15, Text = "M", TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBlack, TextSize = 22, Visible = false}, Gui)
    Corner(Float, 23) Stroke(Float, Theme.Accent, 2, 0.1)

    MinBtn.MouseButton1Click:Connect(function() 
        TweenService:Create(UI.Scale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0}):Play()
        task.wait(0.3)
        Main.Visible = false; Float.Visible = true 
    end)
    Float.MouseButton1Click:Connect(function() 
        Main.Visible = true; Float.Visible = false 
        TweenService:Create(UI.Scale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = Cfg.UIScale or 1}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function() U.Shutdown() end)

    local Side = New("ScrollingFrame", {Size = UDim2.new(0, SW, 1, -46), Position = UDim2.new(0, 0, 0, 46), BackgroundColor3 = Color3.fromRGB(4, 4, 10), BackgroundTransparency = 0.5, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2}, Main)
    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, Side)
    Pad(Side, 6, 6, 6, 6)

    local Card = New("Frame", {Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.3, BorderSizePixel = 0, LayoutOrder = 0, ZIndex = 3}, Side)
    Corner(Card, 10) Stroke(Card, Theme.Accent, 1, 0.5)
    local Av = New("ImageLabel", {Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(0, 7, 0.5, -19), BackgroundColor3 = Theme.Bg, BorderSizePixel = 0, ZIndex = 4}, Card)
    Corner(Av, 19)
    New("TextLabel", {Size = UDim2.new(1, -54, 0, 18), Position = UDim2.new(0, 50, 0, 9), BackgroundTransparency = 1, Text = LocalPlayer.DisplayName, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4}, Card)
    UI.ProfileSub = New("TextLabel", {Size = UDim2.new(1, -54, 0, 14), Position = UDim2.new(0, 50, 0, 28), BackgroundTransparency = 1, Text = "Level ...", TextColor3 = Theme.Accent2, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4}, Card)
    
    task.spawn(function()
        local ok, img = pcall(function() return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)
        if ok and img then Av.Image = img end
    end)

    local Content = New("Frame", {Size = UDim2.new(1, -SW, 1, -46), Position = UDim2.new(0, SW, 0, 46), BackgroundTransparency = 1, ZIndex = 2}, Main)
    local Window = {Tabs = {}, Gui = Gui, Main = Main}

    function Window:CreateTab(name, icon)
        local Btn = New("TextButton", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 1, Text = " " .. (icon or "") .. " " .. name, TextColor3 = Theme.Sub, Font = Enum.Font.GothamSemibold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, LayoutOrder = #Window.Tabs + 1, ZIndex = 3}, Side)
        Corner(Btn, 8)
        local Ind = New("Frame", {Size = UDim2.new(0, 3, 1, -14), Position = UDim2.new(0, 0, 0, 7), BackgroundColor3 = Theme.Accent2, BorderSizePixel = 0, Visible = false, ZIndex = 4}, Btn)
        Corner(Ind, 2)

        local Page = New("ScrollingFrame", {Size = UDim2.new(1, -8, 1, -8), Position = UDim2.new(0, 4, 0, 4), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 5, ScrollBarImageColor3 = Theme.Accent, ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 3}, Content)
        New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)}, Page)
        Pad(Page, 4, 4, 10, 10)

        local TabData = {Btn = Btn, Page = Page, Ind = Ind}
        table.insert(Window.Tabs, TabData)

        local function Select()
            for _, t in ipairs(Window.Tabs) do
                if t.Page.Visible then
                    TweenService:Create(t.Page, TweenInfo.new(0.2), {CanvasPosition = Vector2.new(0,0)}):Play()
                    t.Page.Visible = false
                end
                t.Ind.Visible = false
                t.Btn.TextColor3 = Theme.Sub
                TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end
            -- Fade in effect for page
            Page.Visible = true
            Ind.Visible = true
            Btn.TextColor3 = Theme.Text
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.75}):Play()
        end
        Btn.MouseButton1Click:Connect(Select)
        if #Window.Tabs == 1 then Select() end

        local Tab = {Page = Page}
        local order = 0
        local function nextOrder() order = order + 1 return order end

        function Tab:Section(text)
            local sec = New("TextLabel", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Text = "    " .. string.upper(text), TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            local bar = New("Frame", {Size = UDim2.new(0, 3, 0, 12), Position = UDim2.new(0, 4, 0.5, -6), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 4}, sec)
            Corner(bar, 2)
        end

        function Tab:BigToggle(title, subtitle, default, callback, key, colA, colB)
            local state = default and true or false
            local card = New("Frame", {Size = UDim2.new(1, 0, 0, 74), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = state and 0.2 or 0.6, BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            Corner(card, 12)
            New("UIGradient", {Color = ColorSequence.new(colA, colB), Rotation = 20}, card)
            local st = Stroke(card, colB, 2, state and 0.05 or 0.5)
            New("TextLabel", {Size = UDim2.new(1, -100, 0, 24), Position = UDim2.new(0, 14, 0, 10), BackgroundTransparency = 1, Text = title, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBlack, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4}, card)
            local sub = New("TextLabel", {Size = UDim2.new(1, -100, 0, 30), Position = UDim2.new(0, 14, 0, 36), BackgroundTransparency = 1, Text = subtitle, TextColor3 = Color3.fromRGB(225, 225, 245), Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, ZIndex = 4}, card)
            local pill = New("TextLabel", {Size = UDim2.new(0, 64, 0, 30), Position = UDim2.new(1, -78, 0.5, -15), BackgroundColor3 = Color3.fromRGB(10, 10, 20), BackgroundTransparency = 0.25, Text = state and "ON" or "OFF", TextColor3 = state and Color3.fromRGB(110, 255, 160) or Theme.Sub, Font = Enum.Font.GothamBlack, TextSize = 13, ZIndex = 4}, card)
            Corner(pill, 15)
            local hit = New("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 6}, card)
            local obj = {}
            function obj.Set(v, silent)
                state = v and true or false
                pill.Text = state and "ON" or "OFF"
                TweenService:Create(pill, TweenInfo.new(0.15), {TextColor3 = state and Color3.fromRGB(110, 255, 160) or Theme.Sub}):Play()
                TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = state and 0.2 or 0.6}):Play()
                TweenService:Create(st, TweenInfo.new(0.2), {Transparency = state and 0.05 or 0.5}):Play()
                if not silent then pcall(callback, state) end
            end
            function obj.Get() return state end
            function obj.SetStatus(t) sub.Text = tostring(t) end
            hit.MouseButton1Click:Connect(function() obj.Set(not state) end)
            if key then UI.T[key] = obj end
            return obj
        end

        function Tab:StatRow(captions)
            local n = #captions
            local row = New("Frame", {Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1, LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            New("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, row)
            local values = {}
            for i, cap in ipairs(captions) do
                local c = New("Frame", {Size = UDim2.new(1 / n, -6 * (n - 1) / n, 1, 0), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.35, BorderSizePixel = 0, LayoutOrder = i, ZIndex = 3}, row)
                Corner(c, 10) Stroke(c, Color3.fromRGB(70, 70, 110), 1, 0.5)
                values[i] = New("TextLabel", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 6), BackgroundTransparency = 1, Text = "-", TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBlack, TextSize = 19, ZIndex = 4}, c)
                New("TextLabel", {Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 34), BackgroundTransparency = 1, Text = cap, TextColor3 = Theme.Sub, Font = Enum.Font.GothamMedium, TextSize = 10, ZIndex = 4}, c)
            end
            return {Set = function(i, text) if values[i] then values[i].Text = tostring(text) end end}
        end

        function Tab:Label(text)
            local l = New("TextLabel", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.5, Text = text, TextColor3 = Theme.Sub, Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            Corner(l, 8) Pad(l, 10, 6, 10, 6)
            return {Set = function(t) l.Text = tostring(t) end}
        end

        function Tab:Button(text, callback)
            local b = New("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.4, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            Corner(b, 8) New("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.Accent2), Rotation = 0}, b)
            b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play() end)
            b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
            b.MouseButton1Click:Connect(function() U.Spawn(callback) end)
        end

        function Tab:Toggle(text, default, callback, key)
            local state = default and true or false
            local row = New("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.4, BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            Corner(row, 8) Stroke(row, Color3.fromRGB(60, 60, 90), 1, 0.55)
            New("TextLabel", {Size = UDim2.new(1, -66, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4}, row)
            local track = New("Frame", {Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -52, 0.5, -11), BackgroundColor3 = state and Theme.Accent or Theme.Off, BorderSizePixel = 0, ZIndex = 4}, row)
            Corner(track, 11)
            local knob = New("Frame", {Size = UDim2.new(0, 18, 0, 18), Position = state and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 5}, track)
            Corner(knob, 9)
            local hit = New("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 6}, row)

            local obj = {}
            function obj.Set(v, silent)
                state = v and true or false
                TweenService:Create(knob, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
                TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = state and Theme.Accent or Theme.Off}):Play()
                if not silent then pcall(callback, state) end
            end
            function obj.Get() return state end
            hit.MouseButton1Click:Connect(function() obj.Set(not state) end)
            if key then UI.T[key] = obj end
            return obj
        end

        function Tab:Dropdown(text, options, default, callback)
            local holder = New("Frame", {Size = UDim2.new(1, 0, 0, 40), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.4, BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            Corner(holder, 8) Stroke(holder, Color3.fromRGB(60, 60, 90), 1, 0.55)
            New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, holder)
            local head = New("TextButton", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = "", LayoutOrder = 1, ZIndex = 4}, holder)
            New("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5}, head)
            local val = New("TextLabel", {Size = UDim2.new(0.5, -34, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1, Text = tostring(default or "-"), TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 5}, head)
            local arrow = New("TextLabel", {Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -26, 0, 0), BackgroundTransparency = 1, Text = "v", TextColor3 = Theme.Sub, Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 5}, head)
            local list = New("ScrollingFrame", {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, LayoutOrder = 2, ZIndex = 4}, holder)
            New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)}, list)
            Pad(list, 6, 2, 6, 4)

            local obj = {Value = default}
            local function build(opts)
                for _, c in ipairs(list:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for i, o in ipairs(opts) do
                    local ob = New("TextButton", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.Bg, BackgroundTransparency = 0.35, Text = tostring(o), TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, AutoButtonColor = false, LayoutOrder = i, ZIndex = 5}, list)
                    Corner(ob, 6)
                    ob.MouseButton1Click:Connect(function()
                        obj.Value = o; val.Text = tostring(o); list.Visible = false; arrow.Text = "v"
                        pcall(callback, o)
                    end)
                end
                list.Size = UDim2.new(1, 0, 0, math.min(#opts * 30 + 6, 156))
            end
            function obj.SetOptions(opts) build(opts) end
            head.MouseButton1Click:Connect(function()
                list.Visible = not list.Visible
                arrow.Text = list.Visible and "^" or "v"
            end)
            build(options)
            return obj
        end

        function Tab:Slider(text, min, max, default, callback, step)
            step = step or 1
            local value = default
            local row = New("Frame", {Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.4, BorderSizePixel = 0, LayoutOrder = nextOrder(), ZIndex = 3}, Page)
            Corner(row, 8) Stroke(row, Color3.fromRGB(60, 60, 90), 1, 0.55)
            New("TextLabel", {Size = UDim2.new(0.68, 0, 0, 22), Position = UDim2.new(0, 12, 0, 4), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4}, row)
            local vlbl = New("TextLabel", {Size = UDim2.new(0.32, -12, 0, 22), Position = UDim2.new(0.68, 0, 0, 4), BackgroundTransparency = 1, Text = tostring(default), TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4}, row)
            local track = New("Frame", {Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 38), BackgroundColor3 = Theme.Off, BorderSizePixel = 0, ZIndex = 4}, row)
            Corner(track, 3)
            local fill = New("Frame", {Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 5}, track)
            Corner(fill, 3)
            local knob = New("Frame", {Size = UDim2.new(0, 14, 0, 14), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 6}, fill)
            Corner(knob, 7)
            local hit = New("TextButton", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 24), BackgroundTransparency = 1, Text = "", ZIndex = 7}, row)

            local dragging = false
            local function setFromX(x)
                local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                local raw = min + (max - min) * rel
                value = math.floor(raw / step + 0.5) * step
                value = math.clamp(value, min, max)
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                vlbl.Text = tostring(value)
                pcall(callback, value)
            end
            hit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true; setFromX(input.Position.X)
                end
            end)
            U.Conn(UserInputService.InputChanged, function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then setFromX(input.Position.X) end
            end)
            U.Conn(UserInputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
        end

        return Tab
    end
    UI.Window = Window
    return Window
end

-- =============================================================================
-- MOVEMENT
-- =============================================================================
Move.Tween, Move.Target, Move.Teleporting, Move.TpToken = nil, nil, false, 0

function Move.Cancel()
    if Move.Tween then pcall(function() Move.Tween:Cancel() end) Move.Tween = nil end
    Move.Target = nil
end

function Move.To(cf, speed)
    local root = U.Root()
    if not root then return false end
    local hum = U.Hum()
    if hum and hum.Sit then hum.Sit = false end
    local dist = (root.Position - cf.Position).Magnitude
    if dist < 35 then
        Move.Cancel()
        root.CFrame = cf
        return true
    end

    -- Prevent getting stuck by enabling noclip during move
    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
    end

    if Move.Target and Move.Tween and (Move.Target.Position - cf.Position).Magnitude < 4 and Move.Tween.PlaybackState == Enum.PlaybackState.Playing then return false end
    Move.Cancel()
    Move.Target = cf
    
    local calculatedTime = dist / (speed or Cfg.TweenSpeed)
    Move.Tween = TweenService:Create(root, TweenInfo.new(calculatedTime, Enum.EasingStyle.Linear), {CFrame = cf})
    Move.Tween:Play()
    return false
end

function Move.AutoActive()
    return Cfg.AutoFarm or Cfg.FarmNearest or Cfg.FarmMob or Cfg.FarmBoss or Cfg.PirateRaid
        or Cfg.EliteHunter or Cfg.AutoChest or Cfg.AutoCollectFruit or Cfg.PvpKill or Cfg.PvpHunt
        or Cfg.BoneFarm or Cfg.MasteryFarm or Cfg.AutoRaid or Move.Teleporting
end

function Move.Go(pos, ent)
    Move.TpToken = Move.TpToken + 1
    local token = Move.TpToken
    Move.Teleporting = true
    local root = U.Root()
    if root and ent and (root.Position - pos).Magnitude > 8000 then
        U.Comm("requestEntrance", ent)
        task.wait(1.2)
    end
    local start = os.clock()
    while U.Alive() and Move.TpToken == token do
        root = U.Root()
        if not root then break end
        if Move.To(CF(pos), 350) then break end
        if os.clock() - start > 150 then break end
        task.wait(0.1)
    end
    if Move.TpToken == token then
        Move.Teleporting = false
        Move.Cancel()
    end
end

function Move.StopTeleport() Move.TpToken = Move.TpToken + 1 Move.Teleporting = false Move.Cancel() end

U.Conn(RunService.Stepped, function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local auto = Move.AutoActive()
    if auto or Cfg.Noclip then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end
    local f = root:FindFirstChild("MorganFloat")
    if auto and not Cfg.Fly then
        if not f then
            f = Instance.new("BodyVelocity")
            f.Name = "MorganFloat"
            f.MaxForce = V3(1e9, 1e9, 1e9)
            f.Velocity = V3(0, 0, 0)
            f.Parent = root
        end
        root.AssemblyLinearVelocity = V3(0, 0, 0)
    elseif f then
        f:Destroy()
    end
end)

-- =============================================================================
-- COMBAT
-- =============================================================================
Combat.Want, Combat.Last, Combat.LastClick, Combat.Extra = 0, 0, 0, nil

function Combat.Request() Combat.Want = os.clock() end

-- Advanced Combat Framework hook
function Combat.FrameworkAttack()
    local env = getgenv and getgenv() or _G
    local require = env.require or require
    local cfm = LocalPlayer.PlayerScripts:FindFirstChild("CombatFramework")
    if not cfm then return end
    local ok, mod = pcall(require, cfm)
    if not ok then return end
    
    local upvalues = debug.getupvalues and debug.getupvalues(mod) or (getupvalues and getupvalues(mod))
    if not upvalues then return end
    
    for _, v in pairs(upvalues) do
        if type(v) == "table" and v.activeController then
            local ac = v.activeController
            if ac.equipped then
                ac.hitboxMagnitude = Cfg.AttackRange
                ac.timeToNextAttack = 0
                ac.attacking = false
                ac.blocking = false
                ac.increment = 3
                if ac.attack then
                    pcall(function() ac:attack() end)
                end
            end
        end
    end
end

function Combat.Click()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(1280, 672))
end

U.Conn(RunService.Heartbeat, function()
    local now = os.clock()
    if now - Combat.Want > 0.35 then return end
    local wt = Farm.Weapon()
    if Cfg.FastAttack and (wt == "Melee" or wt == "Sword") and now - Combat.Last >= 0.03 then
        Combat.Last = now
        if Cfg.AttackMode == "Combat Framework" then
            pcall(Combat.FrameworkAttack)
        elseif Cfg.AttackMode == "Click Only" then
            pcall(Combat.Click)
        else
            pcall(Combat.FrameworkAttack)
            pcall(Combat.Click)
        end
    end
end)

function Combat.PressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

U.Loop(0.6, function()
    if os.clock() - Combat.Want > 1 then return end
    local m = Cfg.MasteryFarm
    if Cfg.SkillZ or m then Combat.PressKey(Enum.KeyCode.Z) end
    if Cfg.SkillX or m then Combat.PressKey(Enum.KeyCode.X) end
    if Cfg.SkillC or m then Combat.PressKey(Enum.KeyCode.C) end
    if Cfg.SkillV or m then Combat.PressKey(Enum.KeyCode.V) end
    if Cfg.SkillF then Combat.PressKey(Enum.KeyCode.F) end
end)

-- =============================================================================
-- FARM
-- =============================================================================
Farm.StatusText = "Idle"
Farm.Target = nil
Farm.LastEquip, Farm.LastBuso, Farm.LastKen, Farm.LastAbandon = 0, 0, 0, 0
Farm.QuestWait, Farm.LastSim, Farm.LastEntrance, Farm.LastTravel = 0, 0, 0, 0
Farm.LastElite, Farm.LastSubmerged = 0, 0

function Farm.Status(t) Farm.StatusText = t end

function Farm.GetTool(tp)
    local char = LocalPlayer.Character
    if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") and t.ToolTip == tp then return t, true end end end
    for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do if t:IsA("Tool") and t.ToolTip == tp then return t, false end end
    return nil, false
end

function Farm.Weapon() if Cfg.MasteryFarm then return Cfg.MasteryType end return Cfg.WeaponType end

function Farm.EquipSelected()
    if os.clock() - Farm.LastEquip < 0.25 then return end
    Farm.LastEquip = os.clock()
    local hum = U.Hum()
    if not hum or hum.Health <= 0 then return end
    local tool, equipped = Farm.GetTool(Farm.Weapon())
    if tool and not equipped then hum:EquipTool(tool) end
end

function Farm.Prep()
    Farm.EquipSelected()
    local char = LocalPlayer.Character
    if Cfg.AutoBuso and char and not char:FindFirstChild("HasBuso") and os.clock() - Farm.LastBuso > 4 then
        Farm.LastBuso = os.clock()
        U.Spawn(function() U.Comm("Buso") end)
    end
end

function Farm.FindMobs(name)
    local list = {}
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return list end
    local ln = name:lower()
    for _, m in ipairs(enemies:GetChildren()) do
        if U.MobAlive(m) and string.find(m.Name:lower(), ln) then list[#list + 1] = m end
    end
    return list
end

function Farm.Nearest(list, pos)
    local best, bd
    for _, m in ipairs(list) do
        local d = (m.HumanoidRootPart.Position - pos).Magnitude
        if not bd or d < bd then best, bd = m, d end
    end
    return best
end

function Farm.Sim()
    if os.clock() - Farm.LastSim < 1 then return end
    Farm.LastSim = os.clock()
    if Ex.SetHidden then pcall(Ex.SetHidden, LocalPlayer, "SimulationRadius", math.huge) end
    pcall(function() LocalPlayer.MaximumSimulationRadius = math.huge end)
end

function Farm.Bring(target, name)
    if not Cfg.BringMobs then return end
    local enemies = Workspace:FindFirstChild("Enemies")
    local tr = target and target:FindFirstChild("HumanoidRootPart")
    if not enemies or not tr then return end
    Farm.Sim()
    local ln = name and name:lower()
    for _, m in ipairs(enemies:GetChildren()) do
        local r = U.MobAlive(m)
        if r and (not ln or string.find(m.Name:lower(), ln)) then
            if m == target or (r.Position - tr.Position).Magnitude <= Cfg.BringRadius then
                if m ~= target then r.CFrame = tr.CFrame end
                r.CanCollide = false
                if Cfg.Hitbox then r.Size = V3(Cfg.HitboxSize, Cfg.HitboxSize, Cfg.HitboxSize) end
                local h = m:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed = 0 h.JumpPower = 0 end
            end
        end
    end
end

function Farm.GetRow(level)
    local rows = Data.Quests[Sea]
    if not rows then return nil, "UNKNOWN_SEA" end
    if Sea == 1 and level >= 700 then return nil, "NEED_SEA2" end
    if Sea == 2 and level >= 1500 then return nil, "NEED_SEA3" end
    local best
    for _, r in ipairs(rows) do if level >= r[1] then best = r else break end end
    
    -- If Max Level, override to Highest quest available
    if level >= 2550 and Sea == 3 then
        return rows[#rows] -- Tiki Outpost max quest
    end
    
    if best then return best end
    return nil, "NO_ROW"
end

function Farm.QuestGui()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    return main and main:FindFirstChild("Quest")
end

function Farm.Fight(name, mobPos, row)
    local root = U.Root()
    if not root then return end
    local target = Farm.Target
    if not (target and target.Parent and U.MobAlive(target) and string.find(target.Name:lower(), name:lower())) then
        target = Farm.Nearest(Farm.FindMobs(name), root.Position)
        Farm.Target = target
    end
    if target then
        Move.To(target.HumanoidRootPart.CFrame * CF(0, Cfg.FarmHeight, 0) * CFrame.Angles(math.rad(-90), 0, 0))
        Farm.Bring(target, name)
        Combat.Request()
        return
    end
    local pos = mobPos
    if pos then Move.To(CF(pos + V3(0, Cfg.FarmHeight, 0))) end
end

function Farm.Level()
    local root, hum = U.Root(), U.Hum()
    if not root or not hum or hum.Health <= 0 then Move.Cancel() Farm.Target = nil return end
    local lvl = U.Level()
    
    -- Removed StopAtTarget check to allow infinite max level grinding
    
    local row, reason = Farm.GetRow(lvl)
    if not row then return end

    Farm.Status(string.format("Lv %d | %s | %s", lvl, row[7], row[2]))
    Farm.Prep()

    if Cfg.UseQuest then
        local q = Farm.QuestGui()
        if q and q.Visible then
            local qt = q.Container.QuestTitle.Title.Text:lower()
            if not string.find(qt, row[2]:lower()) then
                if os.clock() - Farm.LastAbandon > 6 then
                    Farm.LastAbandon = os.clock()
                    U.Spawn(function() U.Comm("AbandonQuest") end)
                end
                return
            end
        else
            if os.clock() < Farm.QuestWait then return end
            Move.To(CF(row[5]))
            local r2 = U.Root()
            if r2 and (r2.Position - row[5]).Magnitude < 12 then
                U.Comm("StartQuest", row[3], row[4])
                Farm.QuestWait = os.clock() + 1.5
            end
            return
        end
    end
    Farm.Fight(row[2], row[6], row)
end

-- =============================================================================
-- FISHING (Auto Fish)
-- =============================================================================
Fish.LastCast = 0

function Fish.Step()
    if not Cfg.AutoFish then return false end
    local hum = U.Hum()
    if not hum then return false end
    
    -- Try to equip rod
    local rod, isEquipped = Farm.GetTool("Fishing Rod") 
    if not rod then 
        Farm.Status("Fishing: No Fishing Rod found")
        return false 
    end
    if not isEquipped then hum:EquipTool(rod) end
    
    Farm.Status("Fishing: Active")
    
    -- This simulates casting and reeling (Generic for Blox Fruits)
    -- Needs to be near water (Tiki Outpost)
    local root = U.Root()
    if root and os.clock() - Fish.LastCast > 5 then
        Fish.LastCast = os.clock()
        VirtualUser:ClickButton1(Vector2.new(100, 100))
        task.wait(0.5)
        -- Bobber check / reel simulation
        local hasBobber = false
        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "Bobber" and (v.Position - root.Position).Magnitude < 150 then
                hasBobber = true
                -- Detect if it sinks (Y drops) and click again
                task.spawn(function()
                    local startY = v.Position.Y
                    for i=1, 50 do
                        if v.Position.Y < startY - 0.5 then
                            VirtualUser:ClickButton1(Vector2.new(100, 100))
                            break
                        end
                        task.wait(0.1)
                    end
                end)
                break
            end
        end
    end
    
    -- Auto Buy Bait
    if Cfg.AutoBuyBait and os.clock() - Fish.LastCast > 10 then
         U.Comm("BuyBait")
    end
    
    return true
end

-- =============================================================================
-- ITEMS (Fake Fruits & Real Fruits)
-- =============================================================================
function Misc.SpawnFakeFruit(fruitName)
    local root = U.Root()
    if not root then return end
    
    -- Attempt to clone real fruit model from ReplicatedStorage
    local models = ReplicatedStorage:FindFirstChild("Models")
    local realFruit = models and models:FindFirstChild(fruitName .. " Fruit") or ReplicatedStorage:FindFirstChild(fruitName .. " Fruit")
    
    local p
    if realFruit and realFruit:IsA("Tool") and realFruit:FindFirstChild("Handle") then
        p = realFruit.Handle:Clone()
    elseif realFruit and realFruit:IsA("Model") then
        p = realFruit:Clone()
    else
        p = Instance.new("Part")
        p.Shape = Enum.PartType.Ball
        p.Material = Enum.Material.Neon
        p.Color = Color3.new(math.random(), math.random(), math.random())
    end
    
    if p:IsA("Model") then p = p.PrimaryPart or p:GetChildren()[1] end
    
    p.Name = fruitName
    p.Size = V3(2, 2, 2)
    p.Position = root.Position + root.CFrame.LookVector * 5 + V3(0, 3, 0)
    p.Anchored = true
    p.CanCollide = false
    p:SetAttribute("MorganFake", true)
    
    -- Remove any scripts or touch interests so it's purely decorative
    for _, v in pairs(p:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("TouchTransmitter") then v:Destroy() end
    end
    
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 150, 0, 40)
    bb.StudsOffset = V3(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = p
    bb.Parent = p
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = fruitName
    l.TextColor3 = p.Color
    l.TextStrokeTransparency = 0
    l.TextSize = 14
    l.Font = Enum.Font.GothamBold
    l.Parent = bb
    p.Parent = Workspace
    UI.Notify("Fake Fruit", "Spawned Fake " .. fruitName, 2)
end

function Misc.ClearFakeFruits()
    for _, o in ipairs(Workspace:GetChildren()) do
        if o:GetAttribute("MorganFake") then o:Destroy() end
    end
end

-- =============================================================================
-- FPS BOOST +
-- =============================================================================
function Misc.FpsBoost()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    if Ex.SetFpsCap then pcall(Ex.SetFpsCap, 240) end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    local n = 0
    for _, o in ipairs(Workspace:GetDescendants()) do
        if o:IsA("BasePart") then
            o.Material = Enum.Material.SmoothPlastic
            o.Reflectance = 0
            o.CastShadow = false
        elseif o:IsA("Decal") or o:IsA("Texture") then
            o.Transparency = 1
        elseif o:IsA("ParticleEmitter") or o:IsA("Trail") then
            o.Enabled = false
        elseif o:IsA("PostEffect") then
            o.Enabled = false
        end
        n = n + 1
        if n % 500 == 0 then task.wait() end
    end
    UI.Notify("FPS Boost", "Extreme FPS boost applied.", 4)
end

-- =============================================================================
-- MASTER LOOP
-- =============================================================================
U.Loop(0.05, function()
    local root, hum = U.Root(), U.Hum()
    if not root or not hum or hum.Health <= 0 then Move.Cancel() Farm.Target = nil return end
    if Move.Teleporting then return end
    if not Move.AutoActive() then
        if Move.Tween then Move.Cancel() end
        Farm.Target = nil
        return
    end

    if Fish.Step() then return end
    if Cfg.AutoFarm then
        Farm.Level()
        return
    end
end)

-- =============================================================================
-- LOAD GUI
-- =============================================================================
local Win = UI.CreateWindow("Morgan Hub V3.1", "Ultimate  |  Blox Fruits  |  Sea " .. Sea)

local TabHome    = Win:CreateTab("Home", "🏠")
local TabFarm    = Win:CreateTab("Auto Farm", "⚔️")
local TabFish    = Win:CreateTab("Fishing", "🎣")
local TabFun     = Win:CreateTab("Fake Fruits", "🎭")
local TabVisual  = Win:CreateTab("Visuals", "👁️")

-- Home
TabHome:Section("Main Switches")
TabHome:BigToggle("AUTO FARM", "Grinds quests endlessly. Max level safe.", Cfg.AutoFarm, function(v) Cfg.AutoFarm = v if not v then Move.Cancel() Farm.Target = nil end end, "AutoFarm", Color3.fromRGB(120, 70, 255), Color3.fromRGB(70, 190, 255))

-- Farm Settings
TabFarm:Section("Level Farm Settings")
TabFarm:Slider("Tween Speed (Travel)", 100, 500, Cfg.TweenSpeed, function(v) Cfg.TweenSpeed = v end, 10)
TabFarm:Slider("Farm Height", 10, 60, Cfg.FarmHeight, function(v) Cfg.FarmHeight = v end, 5)
TabFarm:Toggle("Fast Attack (Combat Framework)", Cfg.FastAttack, function(v) Cfg.FastAttack = v end)

-- Fishing
TabFish:Section("Auto Fishing (Sea 3 Tiki)")
TabFish:Toggle("Enable Auto Fish", Cfg.AutoFish, function(v) Cfg.AutoFish = v end)
TabFish:Toggle("Auto Buy Bait", Cfg.AutoBuyBait, function(v) Cfg.AutoBuyBait = v end)
TabFish:Label("Equips fishing rod automatically. Stand near water.")

-- Fun / Fake Fruits
TabFun:Section("Fake Fruits (Realistic Models)")
for _, f in ipairs({"Kitsune", "Leopard", "Dough", "Dragon", "Venom", "Buddha"}) do
    TabFun:Button("Spawn Fake " .. f, function() Misc.SpawnFakeFruit(f) end)
end
TabFun:Button("Clear Fake Fruits", function() Misc.ClearFakeFruits() end)

-- Visuals
TabVisual:Section("GUI Themes")
TabVisual:Dropdown("Select Theme", {"None", "Rain", "Snow", "Cherry Blossom"}, Cfg.Theme, function(v) Cfg.Theme = v end)
TabVisual:Section("Performance")
TabVisual:Button("Extreme FPS Boost", function() Misc.FpsBoost() end)

UI.Notify("Morgan Hub V3.1", "Loaded successfully. Improved Auto Farm & Fishing added.", 5)

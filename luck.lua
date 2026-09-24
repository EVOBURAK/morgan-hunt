--[[
    ⛩️ BLOX FRUITS - 140 SPEED TWEEN FRUIT SNIPER
    ---------------------------------------------------
    ✔ Pure 140 Stud/s Fast & Smooth Tween
    ✔ Working ESP (Highlight + Billboard Text)
    ✔ Auto Select Marine
    ✔ English Compact GUI
    ✔ Safe Server Hop
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players           = game:GetService("Players")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local FireTouch   = firetouchinterest

-- ==================== AUTO MARINE ====================
local function AutoSelectMarine()
    pcall(function()
        if LocalPlayer.Team == nil or LocalPlayer.Team.Name ~= "Marines" then
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local comm = remotes and remotes:FindFirstChild("CommF_")
            if comm then
                comm:InvokeServer("SetTeam", "Marines")
            end
        end
    end)
end
AutoSelectMarine()

-- ==================== SETTINGS & DATABASE ====================
local Cfg = {
    Active   = true,
    Speed    = 140, -- Updated to 140 Studs per second
    WaitTime = 15,
}

local ValidFruitNames = {
    "Dragon", "Control", "Kitsune", "Yeti", "Tiger", "Spirit", "Gas", "Venom", "Shadow", "Dough", "T-Rex", "Mammoth", "Gravity",
    "Quake", "Buddha", "Love", "Creation", "Spider", "Sound", "Phoenix", "Portal", "Lightning", "Pain", "Blizzard",
    "Light", "Rubber", "Ghost", "Magma", "Flame", "Ice", "Sand", "Dark", "Eagle", "Diamond",
    "Rocket", "Spin", "Blade", "Spring", "Bomb", "Smoke", "Spike"
}

-- ==================== ENGLISH COMPACT GUI ====================
local Gui = Instance.new("ScreenGui")
Gui.Name = "BF_140SpeedTweenSniper"
Gui.ResetOnSpawn = false

pcall(function() Gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not Gui.Parent then Gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 250, 0, 170)
Main.Position = UDim2.new(0.02, 0, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 1.5

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BackgroundTransparency = 1
Title.Text = "⚡ 140 SPEED TWEEN SNIPER"
Title.TextColor3 = Color3.fromRGB(0, 190, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12

local StatusLbl = Instance.new("TextLabel", Main)
StatusLbl.Size = UDim2.new(0.9, 0, 0, 38)
StatusLbl.Position = UDim2.new(0.05, 0, 0.22, 0)
StatusLbl.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
StatusLbl.Text = "Initializing..."
StatusLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextSize = 11
StatusLbl.TextWrapped = true
Instance.new("UICorner", StatusLbl).CornerRadius = UDim.new(0, 6)

local ToggleBtn = Instance.new("TextButton", Main)
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.50, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
ToggleBtn.Text = "AUTO FARM: ON"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 11
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

local HopBtn = Instance.new("TextButton", Main)
HopBtn.Size = UDim2.new(0.9, 0, 0, 26)
HopBtn.Position = UDim2.new(0.05, 0, 0.73, 0)
HopBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
HopBtn.Text = "Server Hop Now"
HopBtn.TextColor3 = Color3.fromRGB(200, 170, 255)
HopBtn.Font = Enum.Font.Gotham
HopBtn.TextSize = 11
Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 6)

local function SetStatus(msg) StatusLbl.Text = msg end

-- ==================== WORKING ESP ====================
local function ApplyESP(targetPart, fruitName)
    if not targetPart or targetPart:FindFirstChild("FruitESP_Bill") then return end

    local bg = Instance.new("BillboardGui")
    bg.Name = "FruitESP_Bill"
    bg.Adornee = targetPart
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 150, 0, 30)
    bg.StudsOffset = Vector3.new(0, 3, 0)

    local txt = Instance.new("TextLabel", bg)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "🍎 " .. fruitName
    txt.TextColor3 = Color3.fromRGB(255, 40, 40)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 13
    txt.TextStrokeTransparency = 0

    local hl = Instance.new("Highlight")
    hl.Name = "FruitESP_High"
    hl.Adornee = targetPart.Parent
    hl.FillColor = Color3.fromRGB(255, 0, 80)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.2
    hl.OutlineTransparency = 0

    bg.Parent = targetPart
    hl.Parent = targetPart
end

local function GetGroundFruits()
    local list = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if (obj:IsA("Tool") or obj:IsA("Model")) and not Players:GetPlayerFromCharacter(obj) then
            local lowerName = string.lower(obj.Name)
            local isFruit = false
            local cleanName = obj.Name

            if string.find(lowerName, "fruit") and not string.find(lowerName, "dealer") and not string.find(lowerName, "gacha") then
                isFruit = true
            else
                for _, fName in ipairs(ValidFruitNames) do
                    if string.find(lowerName, string.lower(fName)) then
                        isFruit = true
                        cleanName = fName .. " Fruit"
                        break
                    end
                end
            end

            if isFruit then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart", true)
                if handle then
                    ApplyESP(handle, cleanName)
                    table.insert(list, {object = obj, handle = handle, name = cleanName})
                end
            end
        end
    end
    return list
end

-- ==================== 140 SPEED EXACT TWEEN ====================
local function StoreFruit(fruitName)
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local comm = remotes and remotes:FindFirstChild("CommF_")
        if comm then
            local char = LocalPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            comm:InvokeServer("StoreFruit", fruitName, tool)
        end
    end)
end

local function TweenToFruit(item)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root or not item.handle or not item.handle.Parent then return end

    SetStatus("Tweening (140 Speed): " .. item.name)

    local targetCFrame = item.handle.CFrame * CFrame.new(0, 2, 0)
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local timeToReach = distance / Cfg.Speed -- Exactly 140 speed calculation

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = root

    local tweenInfo = TweenInfo.new(timeToReach, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})

    tween:Play()

    while tween.PlaybackState == Enum.PlaybackState.Playing do
        if not Cfg.Active or not item.handle or not item.handle.Parent then
            tween:Cancel()
            bv:Destroy()
            return
        end
        task.wait(0.05)
    end

    bv:Destroy()

    if item.handle and item.handle.Parent then
        if FireTouch and root then
            pcall(function()
                FireTouch(root, item.handle)
                FireTouch(item.handle, root)
            end)
        end
        task.wait(0.5)
        StoreFruit(item.name)
        SetStatus("Stored: " .. item.name)
    end
end

-- ==================== SAFE SERVER HOP ====================
local function ServerHop()
    SetStatus("Searching new server...")
    local req = (syn and syn.request) or (http and http.request) or request or http_request
    if not req then 
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
        return 
    end

    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)
    local success, response = pcall(function() return req({Url = url, Method = "GET"}) end)

    if success and response and response.Body then
        local ok, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
        if ok and data and data.data then
            local servers = {}
            for _, s in ipairs(data.data) do
                if type(s) == "table" and s.playable and s.id ~= game.JobId and (s.maxPlayers or 0) > (s.playing or 0) then
                    table.insert(servers, s.id)
                end
            end
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

-- ==================== BUTTON EVENTS ====================
ToggleBtn.MouseButton1Click:Connect(function()
    Cfg.Active = not Cfg.Active
    if Cfg.Active then
        ToggleBtn.Text = "AUTO FARM: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
    else
        ToggleBtn.Text = "AUTO FARM: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
        SetStatus("Paused.")
    end
end)

HopBtn.MouseButton1Click:Connect(function() ServerHop() end)

-- ==================== MAIN LOOP ====================
task.spawn(function()
    while Gui.Parent do
        AutoSelectMarine()

        if Cfg.Active then
            SetStatus("Scanning map...")
            local fruits = GetGroundFruits()

            if #fruits > 0 then
                SetStatus("Found " .. #fruits .. " fruit(s)!")
                for _, item in ipairs(fruits) do
                    if not Cfg.Active then break end
                    TweenToFruit(item)
                    task.wait(0.5)
                end
            else
                local timer = Cfg.WaitTime
                while timer > 0 and Cfg.Active do
                    if #GetGroundFruits() > 0 then break end
                    SetStatus("No Fruits! Hop in: " .. timer .. "s")
                    task.wait(1)
                    timer = timer - 1
                end

                if Cfg.Active and #GetGroundFruits() == 0 then
                    ServerHop()
                    task.wait(8)
                end
            end
        else
            task.wait(1)
        end
    end
end)

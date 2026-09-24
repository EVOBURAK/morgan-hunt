--[[
    ⛩️ BLOX FRUITS - AUTO MARINE + SMOOTH FLY FRUIT SNIPER (60 SPEED)
    ------------------------------------------------------------------
    ✔ Teleport (TP) Kaldırıldı! Saniyede 60 Hızla Meyveye Süzülür
    ✔ "Restricted Area" Fix + Otomatik Marine Seçimi
    ✔ Tüm Meyveler ve "Fruit/Meyve" Obje ESP'si
    ✔ Otomatik Toplama ve Store
    ✔ 15s Sayacı & Güvenli Server Hop
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players           = game:GetService("Players")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local FireTouch   = firetouchinterest

-- ==================== OTO MARINE SEÇİMİ ====================
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

-- ==================== AYARLAR & MEYVE LİSTESİ ====================
local Cfg = {
    Active   = true,
    FlySpeed = 60,  -- İstediğin 60 Hızı
    WaitTime = 15,
}

local AllFruitsDatabase = {
    "Dragon", "Control", "Kitsune", "Yeti", "Tiger", "Spirit", "Gas", "Venom", "Shadow", "Dough", "T-Rex", "Mammoth", "Gravity",
    "Quake", "Buddha", "Love", "Creation", "Spider", "Sound", "Phoenix", "Portal", "Lightning", "Pain", "Blizzard",
    "Light", "Rubber", "Ghost", "Magma", "Flame", "Ice", "Sand", "Dark", "Eagle", "Diamond",
    "Rocket", "Spin", "Blade", "Spring", "Bomb", "Smoke", "Spike"
}

-- ==================== ARAYÜZ (GUI) ====================
local Gui = Instance.new("ScreenGui")
Gui.Name = "FruitSniper_60SpeedFly"
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 999

pcall(function() Gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not Gui.Parent then Gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 300, 0, 230)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.45, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 15, 25)
Main.BorderSizePixel = 0

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 150, 255)
Stroke.Thickness = 2

local Layout = Instance.new("UIListLayout", Main)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 8)

local Padding = Instance.new("UIPadding", Main)
Padding.PaddingLeft = UDim.new(0, 12)
Padding.PaddingRight = UDim.new(0, 12)
Padding.PaddingTop = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 24)
Title.BackgroundTransparency = 1
Title.Text = "⚓ MARINE - 60 SPEED FLY SNIPER"
Title.TextColor3 = Color3.fromRGB(100, 200, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 13
Title.LayoutOrder = 1

local StatusLbl = Instance.new("TextLabel", Main)
StatusLbl.Size = UDim2.new(1, 0, 0, 45)
StatusLbl.BackgroundColor3 = Color3.fromRGB(28, 24, 38)
StatusLbl.Text = "Sistem hazır, tarama başlıyor..."
StatusLbl.TextColor3 = Color3.fromRGB(220, 220, 240)
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextSize = 11
StatusLbl.TextWrapped = true
StatusLbl.LayoutOrder = 2
Instance.new("UICorner", StatusLbl).CornerRadius = UDim.new(0, 8)

local ToggleBtn = Instance.new("TextButton", Main)
ToggleBtn.Size = UDim2.new(1, 0, 0, 36)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 140, 70)
ToggleBtn.Text = "OTO TOPLAMA: AÇIK"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.LayoutOrder = 3
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local HopBtn = Instance.new("TextButton", Main)
HopBtn.Size = UDim2.new(1, 0, 0, 32)
HopBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
HopBtn.Text = "🚀 Anında Server Hop"
HopBtn.TextColor3 = Color3.fromRGB(230, 200, 255)
HopBtn.Font = Enum.Font.GothamBold
HopBtn.TextSize = 12
HopBtn.LayoutOrder = 4
Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 8)

local function Status(msg) StatusLbl.Text = msg end

-- ==================== ESP & TARAMA ====================
local function ApplyESP(obj, displayName)
    if obj:FindFirstChild("FruitESP_Tag") then return end
    
    local bg = Instance.new("BillboardGui")
    bg.Name = "FruitESP_Tag"
    bg.Adornee = obj
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 150, 0, 35)
    bg.StudsOffset = Vector3.new(0, 3.5, 0)
    
    local txt = Instance.new("TextLabel", bg)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "🍎 " .. displayName
    txt.TextColor3 = Color3.fromRGB(255, 50, 50)
    txt.Font = Enum.Font.GothamBlack
    txt.TextSize = 14
    txt.TextStrokeTransparency = 0
    
    local hl = Instance.new("Highlight")
    hl.Name = "FruitESP_Highlight"
    hl.Adornee = obj
    hl.FillColor = Color3.fromRGB(255, 0, 80)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.3
    hl.OutlineTransparency = 0
    
    bg.Parent = obj
    hl.Parent = obj
end

local function CheckIsFruit(obj)
    local name = string.lower(obj.Name)
    if string.find(name, "fruit") or string.find(name, "meyve") then
        return true, obj.Name
    end
    for _, fName in ipairs(AllFruitsDatabase) do
        if string.find(name, string.lower(fName)) then
            return true, fName .. " Fruit"
        end
    end
    return false, nil
end

local function FindAllFruitsOnMap()
    local results = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        local isFruit, name = CheckIsFruit(obj)
        if isFruit then
            local handle = (obj:IsA("Tool") and obj:FindFirstChild("Handle")) or obj:FindFirstChildWhichIsA("BasePart", true) or (obj:IsA("BasePart") and obj)
            if handle then
                ApplyESP(handle, name)
                table.insert(results, {object = obj, part = handle, name = name})
            end
        end
    end
    return results
end

-- ==================== 60 HIZINDA FLY / GLIDE MANTIGI ====================
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

local function FlyToTarget(targetPart)
    local char = LocalPlayer.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or not targetPart or not targetPart.Parent then return false end

    local targetCFrame = targetPart.CFrame * CFrame.new(0, 1.5, 0)
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local duration = distance / Cfg.FlySpeed

    -- Düşmeyi önlemek için geçici BodyVelocity
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = root

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    
    local startTime = tick()
    while tween.PlaybackState == Enum.PlaybackState.Playing do
        if not Cfg.Active or not targetPart or not targetPart.Parent then
            tween:Cancel()
            bv:Destroy()
            return false
        end
        task.wait(0.05)
    end

    bv:Destroy()
    return true
end

local function CollectAndStore(item)
    if not item.part or not item.part.Parent then return end
    
    Status("60 Hızında Gidiliyor: " .. item.name)
    local reached = FlyToTarget(item.part)
    
    if reached then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if FireTouch and root and item.part then
            pcall(function()
                FireTouch(root, item.part)
                FireTouch(item.part, root)
            end)
        end
        
        task.wait(0.5)
        StoreFruit(item.name)
        Status("Toplandı ve Depolandı: " .. item.name)
    end
end

-- ==================== GÜVENLİ SERVER HOP ====================
local function SafeServerHop()
    Status("Açık ve erişilebilir sunucu aranıyor...")
    local req = (syn and syn.request) or (http and http.request) or request or http_request
    if not req then 
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
        return 
    end
    
    local currentPlaceId = game.PlaceId
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", currentPlaceId)
    
    local success, response = pcall(function()
        return req({Url = url, Method = "GET"})
    end)
    
    if success and response and response.Body then
        local ok, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
        if ok and data and data.data then
            local validServers = {}
            for _, s in ipairs(data.data) do
                if type(s) == "table" and s.playable and s.id ~= game.JobId and (s.maxPlayers or 0) > (s.playing or 0) then
                    table.insert(validServers, s.id)
                end
            end
            
            if #validServers > 0 then
                local randomServerId = validServers[math.random(1, #validServers)]
                Status("Sunucuya bağlanılıyor...")
                TeleportService:TeleportToPlaceInstance(currentPlaceId, randomServerId, LocalPlayer)
                return
            end
        end
    end
    
    Status("Yeniden deneniyor...")
    TeleportService:Teleport(currentPlaceId, LocalPlayer)
end

TeleportService.TeleportInitFailed:Connect(function()
    task.wait(1.5)
    SafeServerHop()
end)

-- ==================== BUTONLAR ====================
ToggleBtn.MouseButton1Click:Connect(function()
    Cfg.Active = not Cfg.Active
    if Cfg.Active then
        ToggleBtn.Text = "OTO TOPLAMA: AÇIK"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 140, 70)
    else
        ToggleBtn.Text = "OTO TOPLAMA: KAPALI"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        Status("Oto-toplama durduruldu.")
    end
end)

HopBtn.MouseButton1Click:Connect(function() SafeServerHop() end)

-- ==================== ANA DÖNGÜ ====================
task.spawn(function()
    while Gui.Parent do
        AutoSelectMarine()
        
        if Cfg.Active then
            Status("Haritadaki tüm meyveler taranıyor...")
            local foundFruits = FindAllFruitsOnMap()
            
            if #foundFruits > 0 then
                Status(#foundFruits .. " adet meyve bulundu! 60 Hızında Gidiliyor...")
                for _, item in ipairs(foundFruits) do
                    if not Cfg.Active then break end
                    CollectAndStore(item)
                    task.wait(0.5)
                end
            else
                local timer = Cfg.WaitTime
                while timer > 0 and Cfg.Active do
                    local instant = FindAllFruitsOnMap()
                    if #instant > 0 then break end
                    
                    Status("Haritada meyve yok! Server Hop: " .. timer .. " sn")
                    task.wait(1)
                    timer = timer - 1
                end
                
                if Cfg.Active and #FindAllFruitsOnMap() == 0 then
                    SafeServerHop()
                    task.wait(8)
                end
            end
        else
            task.wait(1)
        end
    end
end)

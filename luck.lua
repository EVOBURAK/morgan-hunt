--[[
    ⛩️  KITSUNE LUCK HUNTER  |  Blox Fruits  |  Delta (Mobile + PC)
    ---------------------------------------------------------------
    ✔ ×100 Luck boost (client)
    ✔ GERÇEK av sistemi: Fruit Sniper + Auto Server Hop
    ✔ Kitsune bulunca: ışınlanır → toplar → bildirir → webhook
    ---------------------------------------------------------------
    DÜRÜST NOT: Roblox'ta şans (RNG) sunucu tarafında hesaplanır,
    client'ta "luck 100" yazmak gerçek oranları değiştirmez.
    Kitsune avının GERÇEKTEN çalışan yolu = çok server gezip
    spawn olmuş meyveyi ilk sen kapmak. Script tam bunu yapıyor.
    İPUCU: Delta'da "Auto Exec" aç → her hop'ta script kendini
    yeniden çalıştırır, av kesintisiz devam eder.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players          = game:GetService("Players")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local FireTouch = firetouchinterest

-- ==================== AYARLAR ====================
local Cfg = {
    Active   = false,
    Mode     = "Kitsune Only", -- Kitsune Only / Mythical+ / Legendary+ / Rare+ / Any Fruit
    Wait     = 8,              -- her serverda tarama süresi (sn)
    AutoGrab = true,
    Webhook  = "",
}

local Tier = {
    Kitsune=5, Leopard=5,
    Dragon=4, Spirit=4, Control=4, Shadow=4, Venom=4, Dough=4, Gravity=4, Blizzard=4, Pain=4, Rumble=4,
    Portal=3, Phoenix=3, Sound=3, Spider=3, Love=3, Buddha=3, Quake=3, Magma=3,
    Barrier=2, Rubber=2, Light=2, Diamond=2, Falcon=2, Dark=2, Sand=2, Ice=2, Flame=2,
    Spike=1, Smoke=1, Bomb=1, Spring=1, Chop=1, Spin=1, Rocket=1,
}
local Modes   = {"Kitsune Only", "Mythical+", "Legendary+", "Rare+", "Any Fruit"}
local ModeMin = {["Kitsune Only"]=5, ["Mythical+"]=5, ["Legendary+"]=4, ["Rare+"]=3, ["Any Fruit"]=1}

-- ==================== MİNİ GUI (şeffaf cam) ====================
local function New(class, props, parent)
    local o = Instance.new(class)
    if props then for k, v in pairs(props) do o[k] = v end end
    if parent then o.Parent = parent end
    return o
end
local function Corner(o, r) return New("UICorner", {CornerRadius = UDim.new(0, r or 10)}, o) end

local Gui = New("ScreenGui", {Name = "KitsuneHunter", ResetOnSpawn = false, DisplayOrder = 999})
do
    local ok = pcall(function()
        Gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
    end)
    if not ok then Gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
end

local Main = New("Frame", {
    Size = UDim2.new(0, 290, 0, 356), AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.45, 0), BackgroundColor3 = Color3.fromRGB(10, 6, 8),
    BackgroundTransparency = 0.12, BorderSizePixel = 0,
}, Gui)
Corner(Main, 14)
local Stk = New("UIStroke", {Color = Color3.fromRGB(255, 120, 40), Thickness = 1.5, Transparency = 0.4}, Main)
New("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(255, 120, 40), Color3.fromRGB(255, 60, 90))}, Stk)

-- sürükleme
do
    local drag, dStart, sPos
    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag, dStart, sPos = true, i.Position, Main.Position
            local c = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false c:Disconnect() end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dStart
            Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
        end
    end)
end

New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)}, Main)
New("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
    PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)}, Main)

New("TextLabel", {Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Text = "⛩️ KITSUNE HUNTER",
    TextColor3 = Color3.fromRGB(255, 220, 180), Font = Enum.Font.GothamBlack, TextSize = 17, LayoutOrder = 1}, Main)

local LuckBadge = New("TextLabel", {Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(40, 20, 12),
    BackgroundTransparency = 0.3, Text = "🍀 LUCK ×100  (av aktifken)", TextColor3 = Color3.fromRGB(140, 255, 150),
    Font = Enum.Font.GothamBold, TextSize = 12, LayoutOrder = 2}, Main)
Corner(LuckBadge, 8)

local ModeBtn = New("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Color3.fromRGB(28, 14, 16),
    BackgroundTransparency = 0.25, Text = "Mod: " .. Cfg.Mode .. "   ▸", TextColor3 = Color3.fromRGB(240, 240, 250),
    Font = Enum.Font.Gotham, TextSize = 12, AutoButtonColor = false, LayoutOrder = 3}, Main)
Corner(ModeBtn, 8)

local WaitRow = New("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = 4}, Main)
local WaitLbl = New("TextLabel", {Size = UDim2.new(1, -90, 1, 0), BackgroundTransparency = 1,
    Text = "Bekleme: " .. Cfg.Wait .. " sn", TextColor3 = Color3.fromRGB(200, 200, 215),
    Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, WaitRow)
local WMinus = New("TextButton", {Size = UDim2.new(0, 40, 0, 30), Position = UDim2.new(1, -84, 0, 2),
    BackgroundColor3 = Color3.fromRGB(28, 14, 16), BackgroundTransparency = 0.25, Text = "−",
    TextColor3 = Color3.fromRGB(240, 240, 250), Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false}, WaitRow)
local WPlus = New("TextButton", {Size = UDim2.new(0, 40, 0, 30), Position = UDim2.new(1, -42, 0, 2),
    BackgroundColor3 = Color3.fromRGB(28, 14, 16), BackgroundTransparency = 0.25, Text = "+",
    TextColor3 = Color3.fromRGB(240, 240, 250), Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false}, WaitRow)
Corner(WMinus, 8) Corner(WPlus, 8)

local ToggleBtn = New("TextButton", {Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = Color3.fromRGB(90, 20, 25),
    BackgroundTransparency = 0.15, Text = "▶  AVI BAŞLAT", TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBlack, TextSize = 15, AutoButtonColor = false, LayoutOrder = 5}, Main)
Corner(ToggleBtn, 10)

local HookBox = New("TextBox", {Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(28, 14, 16),
    BackgroundTransparency = 0.25, Text = "", PlaceholderText = "Discord webhook (opsiyonel)",
    TextColor3 = Color3.fromRGB(240, 240, 250), Font = Enum.Font.Gotham, TextSize = 11,
    ClearTextOnFocus = false, LayoutOrder = 6}, Main)
Corner(HookBox, 8)

local HopBtn = New("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Color3.fromRGB(28, 14, 16),
    BackgroundTransparency = 0.25, Text = "🚀  ŞİMDİ HOP'LA", TextColor3 = Color3.fromRGB(255, 200, 150),
    Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, LayoutOrder = 7}, Main)
Corner(HopBtn, 8)

local StatusLbl = New("TextLabel", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, Text = "Hazır. Avı başlat kanka ⛩️", TextColor3 = Color3.fromRGB(170, 170, 190),
    Font = Enum.Font.Gotham, TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 8}, Main)

local function Status(s) StatusLbl.Text = tostring(s) end

-- luck badge nefes efekti
task.spawn(function()
    while Gui.Parent do
        Stk.Transparency = 0.25 + (math.sin(os.clock() * 3) + 1) * 0.15
        task.wait(0.03)
    end
end)

-- ==================== ÇEKİRDEK ====================
local function FindFruits()
    local out = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if Tier[obj.Name] then
            local part = (obj:IsA("Tool") and obj:FindFirstChild("Handle")) or obj:FindFirstChildWhichIsA("BasePart", true)
            if part then out[#out + 1] = {name = obj.Name, tier = Tier[obj.Name], part = part} end
        end
    end
    return out
end

local function Wanted(f)
    if Cfg.Mode == "Kitsune Only" then return f.name == "Kitsune" end
    return f.tier >= (ModeMin[Cfg.Mode] or 1)
end

local function Grab(f)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (root and f.part and f.part.Parent) then return end
    pcall(function() root.CFrame = f.part.CFrame * CFrame.new(0, 2, 0) end)
    for _ = 1, 5 do
        task.wait(0.25)
        if not f.part.Parent then break end -- alındı
        if FireTouch then
            pcall(function() FireTouch(root, f.part) FireTouch(f.part, root) end)
        end
    end
end

local function NotifyGame(name)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "⛩️ " .. name .. " BULUNDU!", Text = "Hemen alınıyor!", Duration = 10,
        })
    end)
end

local function Webhook(content)
    if Cfg.Webhook == "" then return end
    local req = (syn and syn.request) or (http and http.request) or request or http_request
    if not req then return end
    pcall(function()
        req({Url = Cfg.Webhook, Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({content = content})})
    end)
end

local function Hop()
    local req = (syn and syn.request) or (http and http.request) or request or http_request
    if not req then Status("HTTP yok, executor desteklemiyor!") return end
    local ok, body = pcall(function()
        local r = req({Url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=2&limit=100"):format(game.PlaceId), Method = "GET"})
        return r.Body
    end)
    if not ok then Status("Server listesi alınamadı, tekrar deneniyor...") return end
    local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not (ok2 and data and data.data) then return end
    local list = {}
    for _, s in ipairs(data.data) do
        if s.playable and s.id ~= game.JobId and (s.maxPlayers or 0) - (s.playing or 0) > 2 then
            list[#list + 1] = s
        end
    end
    if #list == 0 then Status("Boş server yok, bekleniyor...") return end
    table.sort(list, function(a, b) return (a.playing or 0) < (b.playing or 0) end)
    local pick = list[math.random(1, math.min(#list, 5))] -- düşük nüfus = meyve daha çok kalır
    Status("Hop → " .. (pick.playing or 0) .. " kişilik server...")
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, pick.id, LocalPlayer) end)
end

TeleportService.TeleportInitFailed:Connect(function()
    task.wait(2)
    Hop()
end)

-- butonlar
ModeBtn.MouseButton1Click:Connect(function()
    local i = table.find(Modes, Cfg.Mode) or 1
    Cfg.Mode = Modes[i % #Modes + 1]
    ModeBtn.Text = "Mod: " .. Cfg.Mode .. "   ▸"
end)
WMinus.MouseButton1Click:Connect(function()
    Cfg.Wait = math.clamp(Cfg.Wait - 1, 3, 30)
    WaitLbl.Text = "Bekleme: " .. Cfg.Wait .. " sn"
end)
WPlus.MouseButton1Click:Connect(function()
    Cfg.Wait = math.clamp(Cfg.Wait + 1, 3, 30)
    WaitLbl.Text = "Bekleme: " .. Cfg.Wait .. " sn"
end)
HookBox.FocusLost:Connect(function() Cfg.Webhook = HookBox.Text end)
HopBtn.MouseButton1Click:Connect(function() Hop() end)

local GotKitsune = false
ToggleBtn.MouseButton1Click:Connect(function()
    Cfg.Active = not Cfg.Active
    if Cfg.Active then
        GotKitsune = false
        ToggleBtn.Text = "⏸  AVI DURDUR"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 110, 55)
        Status("Av başladı, serverlar taranıyor...")
    else
        ToggleBtn.Text = "▶  AVI BAŞLAT"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(90, 20, 25)
        Status("Durduruldu.")
    end
end)

-- ana av döngüsü
task.spawn(function()
    while Gui.Parent do
        if Cfg.Active and not GotKitsune then
            Status("Server taranıyor (" .. Cfg.Mode .. ")...")
            local found
            local deadline = os.clock() + Cfg.Wait
            while os.clock() < deadline and Gui.Parent do
                for _, f in ipairs(FindFruits()) do
                    if Wanted(f) then found = f break end
                end
                if found then break end
                task.wait(0.8)
            end
            if found then
                Status("🎯 " .. found.name .. " BULUNDU!")
                NotifyGame(found.name)
                if Cfg.AutoGrab then Grab(found) end
                Webhook("⛩️ **" .. found.name .. "** spawn oldu ve alındı! Server: `" .. tostring(game.JobId) .. "`")
                if found.name == "Kitsune" then
                    GotKitsune = true
                    Status("🎉 KITSUNE ALINDI! Av tamamlandı, tekrar avlamak için aç.")
                end
                task.wait(2)
            else
                Status("Meyve yok → yeni servera geçiliyor...")
                task.wait(1)
                Hop()
                task.wait(8)
            end
        else
            task.wait(0.5)
        end
    end
end)

-- client luck boost (görsel — gerçek RNG sunucuda)
task.spawn(function()
    while Gui.Parent do
        if Cfg.Active then
            pcall(function()
                local d = LocalPlayer:FindFirstChild("Data")
                local l = d and d:FindFirstChild("Luck")
                if l and l.Value < 100 then l.Value = 100 end
            end)
        end
        task.wait(5)
    end
end)

Status("Hazır. Delta'da Auto Exec aç, sonra AVI BAŞLAT'a bas ⛩️")

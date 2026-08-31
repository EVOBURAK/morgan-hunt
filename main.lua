-- ============================================================
-- MORGAN HUB - DEFINITIVE EDITION (V3.0 FULL & WORKING)
-- ============================================================

if not table.find({2753915549, 4442272183, 7449423635}, game.PlaceId) then
    game:GetService("Players").LocalPlayer:Kick("Blox Fruits sunucusuna girin!")
    return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Anti-AFK Entegrasyonu (20 Dk Koruması)
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Çoklu Dil Sistemi (i18n)
local currentLang = "TR"
local i18n = {
    TR = {
        Title = "🌿 MORGAN HUB (FULL V3) 🌿",
        AutoFarm = "🚀 AUTO-FARM (Level)",
        AutoAttack = "⚔️ AUTO-ATTACK (Fast Click)",
        SpeedHack = "🏃 SPEED HACK (WalkSpeed)",
        FlyMode = "🕊️ NO-CLIP / FLY (WASD)",
        LangBtn = "🌐 DİL / LANG: TURKISH",
        Ready = "🔴 HAZIR",
        Attacking = "⚔️ SALDIRILIYOR: ",
        Searching = "🔍 DÜŞMAN ARANIYOR...",
        NotifTitle = "Morgan Hub",
        NotifText = "Script başarıyla yüklendi!"
    },
    EN = {
        Title = "🌿 MORGAN HUB (FULL V3) 🌿",
        AutoFarm = "🚀 AUTO-FARM (Level)",
        AutoAttack = "⚔️ AUTO-ATTACK (Fast Click)",
        SpeedHack = "🏃 SPEED HACK (WalkSpeed)",
        FlyMode = "🕊️ NO-CLIP / FLY (WASD)",
        LangBtn = "🌐 DİL / LANG: ENGLISH",
        Ready = "🔴 READY",
        Attacking = "⚔️ ATTACKING: ",
        Searching = "🔍 SEARCHING ENEMY...",
        NotifTitle = "Morgan Hub",
        NotifText = "Script successfully loaded!"
    },
    IT = {
        Title = "🌿 MORGAN HUB (FULL V3) 🌿",
        AutoFarm = "🚀 AUTO-FARM (Livello)",
        AutoAttack = "⚔️ AUTO-ATTACK (Click Veloce)",
        SpeedHack = "🏃 SPEED HACK (Velocità)",
        FlyMode = "🕊️ NO-CLIP / VOLO (WASD)",
        LangBtn = "🌐 DİL / LANG: ITALIANO",
        Ready = "🔴 PRONTO",
        Attacking = "⚔️ ATTACCANDO: ",
        Searching = "🔍 RICERCA NEMICO...",
        NotifTitle = "Morgan Hub",
        NotifText = "Script caricato con successo!"
    }
}

-- UI Yapılandırması
local hub = Instance.new("ScreenGui")
hub.Name = "MorganHubFullV3"
hub.ResetOnSpawn = false
hub.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 480, 0, 640)
main.Position = UDim2.new(0.5, -240, 0.5, -320)
main.BackgroundColor3 = Color3.fromRGB(8, 14, 8)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 100)
main.Active = true
main.Draggable = true
main.Parent = hub

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = i18n[currentLang].Title
title.TextColor3 = Color3.fromRGB(0, 255, 120)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
close.BorderColor3 = Color3.fromRGB(255, 50, 50)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.Parent = main
close.MouseButton1Click:Connect(function() hub:Destroy() end)

local function toggle(parent, y, key, default)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 0, 36)
    lbl.Position = UDim2.new(0.05, 0, y, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = i18n[currentLang][key]
    lbl.TextColor3 = Color3.fromRGB(150, 255, 180)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 50, 0, 24)
    bg.Position = UDim2.new(0.82, 0, y + 6, 0)
    bg.BackgroundColor3 = default and Color3.fromRGB(0, 180, 50) or Color3.fromRGB(30, 40, 30)
    bg.BorderSizePixel = 1
    bg.BorderColor3 = Color3.fromRGB(0, 255, 100)
    bg.Parent = parent

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = default and UDim2.new(0.55, 0, 0.08, 0) or UDim2.new(0.05, 0, 0.08, 0)
    knob.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    knob.BorderSizePixel = 0
    knob.Text = ""
    knob.Parent = bg

    local state = default or false
    local function update(s)
        state = s
        bg.BackgroundColor3 = s and Color3.fromRGB(0, 180, 50) or Color3.fromRGB(30, 40, 30)
        knob.Position = s and UDim2.new(0.55, 0, 0.08, 0) or UDim2.new(0.05, 0, 0.08, 0)
    end
    knob.MouseButton1Click:Connect(function() update(not state) end)
    return { get = function() return state end, set = update, labelObj = lbl, key = key }
end

local y0, sp = 0.11, 0.11
local auto = toggle(main, y0, "AutoFarm", false)
local kill = toggle(main, y0 + sp, "AutoAttack", false)
local speed = toggle(main, y0 + sp*2, "SpeedHack", false)
local fly = toggle(main, y0 + sp*3, "FlyMode", false)

-- Dil Değiştirme Butonu
local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0.9, 0, 0, 35)
langBtn.Position = UDim2.new(0.05, 0, y0 + sp*4, 0)
langBtn.BackgroundColor3 = Color3.fromRGB(15, 40, 20)
langBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
langBtn.Text = i18n[currentLang].LangBtn
langBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
langBtn.Font = Enum.Font.GothamBold
langBtn.TextSize = 13
langBtn.Parent = main

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 40)
status.Position = UDim2.new(0.05, 0, 0.85, 0)
status.BackgroundColor3 = Color3.fromRGB(12, 24, 12)
status.BorderSizePixel = 1
status.BorderColor3 = Color3.fromRGB(0, 255, 80)
status.Text = i18n[currentLang].Ready
status.TextColor3 = Color3.fromRGB(150, 255, 180)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = main

-- Dinamik Dil Güncelleme
local function updateLang(lang)
    currentLang = lang
    title.Text = i18n[lang].Title
    langBtn.Text = i18n[lang].LangBtn
    status.Text = i18n[lang].Ready
    for _, t in pairs({auto, kill, speed, fly}) do
        t.labelObj.Text = i18n[lang][t.key]
    end
end

langBtn.MouseButton1Click:Connect(function()
    if currentLang == "TR" then updateLang("EN")
    elseif currentLang == "EN" then updateLang("IT")
    else updateLang("TR") end
end)

-- Akıllı Silah Kuşanma
local function equipWeapon()
    local char = player.Character
    if not char then return end
    if not char:FindFirstChildOfClass("Tool") then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            local tool = backpack:FindFirstChildOfClass("Tool")
            if tool then
                char.Humanoid:EquipTool(tool)
            end
        end
    end
end

local function attackTarget()
    equipWeapon()
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(500, 500))
end

-- Anti-Cheat Takılmayan Yumuşak Işınlanma (Tween)
local function tweenTo(targetCFrame, speedRate)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    speedRate = speedRate or 300
    local dist = (char.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    local info = TweenInfo.new(dist / speedRate, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(char.HumanoidRootPart, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- Tam Fonksiyonel Auto-Farm Mantığı
task.spawn(function()
    while task.wait(0.15) do
        if auto.get() then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                
                local targetEnemy = nil
                local minDist = 3000
                local enemiesFolder = workspace:FindFirstChild("Enemies")
                
                if enemiesFolder then
                    for _, obj in pairs(enemiesFolder:GetChildren()) do
                        if obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and obj:FindFirstChild("HumanoidRootPart") then
                            local dist = (char.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                targetEnemy = obj
                            end
                        end
                    end
                end

                if targetEnemy then
                    status.Text = i18n[currentLang].Attacking .. targetEnemy.Name
                    local targetCF = targetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    
                    if minDist > 120 then
                        tweenTo(targetCF, 320)
                    else
                        char.HumanoidRootPart.CFrame = targetCF
                    end
                    attackTarget()
                else
                    status.Text = i18n[currentLang].Searching
                end
            end)
        end
    end
end)

-- Hızlı Saldırı Döngüsü
task.spawn(function()
    while task.wait(0.04) do
        if kill.get() then
            pcall(function() attackTarget() end)
        end
    end
end)

-- WASD Yön Kontrollü Uçma ve Hız Kontrolü
local flySpeed = 60
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then return end

    -- Speed Hack
    if speed.get() then
        char.Humanoid.WalkSpeed = 75
    else
        char.Humanoid.WalkSpeed = 16
    end

    -- Fly Mode
    if fly.get() then
        char.Humanoid.PlatformStand = true
        local flyVec = Vector3.new(0, 0, 0)
        local cam = workspace.CurrentCamera
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then flyVec = flyVec + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then flyVec = flyVec - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then flyVec = flyVec - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then flyVec = flyVec + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then flyVec = flyVec + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then flyVec = flyVec - Vector3.new(0, 1, 0) end

        char.HumanoidRootPart.Velocity = flyVec * flySpeed
    else
        if char.Humanoid.PlatformStand then
            char.Humanoid.PlatformStand = false
        end
    end
end)

-- Bildirim
game.StarterGui:SetCore("SendNotification", {
    Title = i18n[currentLang].NotifTitle,
    Text = i18n[currentLang].NotifText,
    Duration = 3
})

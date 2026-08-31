-- =============================================================
-- 🌿 MORGAN HUB – ULTRA COOL DEFINITIVE EDITION 🌿
-- by Ananin Sikimi – il massimo dell'estetica e della funzione
-- =============================================================

if not table.find({2753915549, 4442272183, 7449423635}, game.PlaceId) then
    game:Shutdown("Vai su Blox Fruits, per favore.")
    return
end

local player = game.Players.LocalPlayer

-- =============================================================
-- CREAZIONE HUB CON GLASSMORPHISM + GLOW
-- =============================================================
local hub = Instance.new("ScreenGui")
hub.Name = "MorganHubUltra"
hub.Parent = player.PlayerGui

-- Sfondo principale (glassmorphism)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 460, 0, 600)
main.Position = UDim2.new(0.5, -230, 0.5, -300)
main.BackgroundColor3 = Color3.fromRGB(10, 20, 10)
main.BackgroundTransparency = 0.25
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Draggable = true
main.Parent = hub

-- Angoli arrotondati (20px)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 22)
corner.Parent = main

-- Bordo glow esterno (verde + ciano)
local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, 12, 1, 12)
glow.Position = UDim2.new(-0.015, -6, -0.015, -6)
glow.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
glow.BackgroundTransparency = 0.65
glow.BorderSizePixel = 0
glow.ClipsDescendants = true
glow.Parent = main
local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 26)
glowCorner.Parent = glow

-- Secondo glow (ciano leggero) per effetto dual
local glow2 = Instance.new("Frame")
glow2.Size = UDim2.new(1, 8, 1, 8)
glow2.Position = UDim2.new(-0.01, -4, -0.01, -4)
glow2.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
glow2.BackgroundTransparency = 0.8
glow2.BorderSizePixel = 0
glow2.ClipsDescendants = true
glow2.Parent = main
local glowCorner2 = Instance.new("UICorner")
glowCorner2.CornerRadius = UDim.new(0, 24)
glowCorner2.Parent = glow2

-- Ombra interna (profondità)
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.BorderSizePixel = 0
shadow.Parent = main
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 22)
shadowCorner.Parent = shadow

-- =============================================================
-- LOGO (alto a sinistra) CON EFFETTO GLOW
-- =============================================================
local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0.7, 0, 0, 60)
logo.Position = UDim2.new(0.05, 0, 0.02, 0)
logo.BackgroundTransparency = 1
logo.Text = "🌿 MORGAN HUB"
logo.TextColor3 = Color3.fromRGB(0, 255, 150)
logo.TextScaled = true
logo.Font = Enum.Font.GothamBold
logo.TextXAlignment = Enum.TextXAlignment.Left
logo.TextStrokeColor3 = Color3.fromRGB(0, 180, 80)
logo.TextStrokeTransparency = 0.3
logo.Parent = main

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(0.6, 0, 0, 22)
sub.Position = UDim2.new(0.05, 0, 0.13, 0)
sub.BackgroundTransparency = 1
sub.Text = "by Ananin Sikimi ✦ ultra cool"
sub.TextColor3 = Color3.fromRGB(0, 210, 120)
sub.TextScaled = true
sub.Font = Enum.Font.Gotham
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.TextStrokeColor3 = Color3.fromRGB(0, 100, 50)
sub.TextStrokeTransparency = 0.4
sub.Parent = main

-- Pulsante chiudi (X) con stile
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 38, 0, 38)
close.Position = UDim2.new(1, -46, 0, 8)
close.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
close.BorderSizePixel = 2
close.BorderColor3 = Color3.fromRGB(0, 255, 100)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(0, 255, 130)
close.TextScaled = true
close.Font = Enum.Font.GothamBold
close.Parent = main
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = close
close.MouseButton1Click:Connect(function() hub:Destroy() end)

-- =============================================================
-- FUNZIONE TOGGLE ULTRA (3D, ANIMATO, GLASS)
-- =============================================================
local function createToggle(parent, yPos, labelText, defaultState)
    -- Card con glassmorphism
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.9, 0, 0, 52)
    card.Position = UDim2.new(0.05, 0, yPos, 0)
    card.BackgroundColor3 = Color3.fromRGB(15, 28, 15)
    card.BackgroundTransparency = 0.35
    card.BorderSizePixel = 1
    card.BorderColor3 = Color3.fromRGB(0, 220, 90)
    card.ClipsDescendants = true
    card.Parent = parent
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 14)
    cardCorner.Parent = card

    -- Sottile glow sulla card
    local cardGlow = Instance.new("Frame")
    cardGlow.Size = UDim2.new(1, 0, 1, 0)
    cardGlow.Position = UDim2.new(0, 0, 0, 0)
    cardGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 80)
    cardGlow.BackgroundTransparency = 0.9
    cardGlow.BorderSizePixel = 0
    cardGlow.Parent = card
    local cardGlowCorner = Instance.new("UICorner")
    cardGlowCorner.CornerRadius = UDim.new(0, 14)
    cardGlowCorner.Parent = cardGlow

    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(170, 255, 200)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextStrokeColor3 = Color3.fromRGB(0, 80, 40)
    label.TextStrokeTransparency = 0.3
    label.Parent = card

    -- Traccia toggle (3D effect)
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 56, 0, 30)
    toggleBg.Position = UDim2.new(0.77, 0, 0.1, 0)
    toggleBg.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 70) or Color3.fromRGB(35, 65, 35)
    toggleBg.BorderSizePixel = 2
    toggleBg.BorderColor3 = Color3.fromRGB(0, 255, 100)
    toggleBg.ClipsDescendants = true
    toggleBg.Parent = card
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggleBg

    -- Levetta (con effetto 3D)
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 24, 0, 24)
    knob.Position = defaultState and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.08, 0, 0.1, 0)
    knob.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    knob.BorderSizePixel = 2
    knob.BorderColor3 = Color3.fromRGB(0, 255, 200)
    knob.Text = ""
    knob.Parent = toggleBg
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 12)
    knobCorner.Parent = knob

    -- Stato interno
    local state = defaultState or false

    local function updateToggle(newState)
        state = newState
        if state then
            toggleBg.BackgroundColor3 = Color3.fromRGB(0, 200, 70)
            knob.Position = UDim2.new(0.55, 0, 0.1, 0)
            knob.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
            knob.BorderColor3 = Color3.fromRGB(0, 255, 200)
        else
            toggleBg.BackgroundColor3 = Color3.fromRGB(35, 65, 35)
            knob.Position = UDim2.new(0.08, 0, 0.1, 0)
            knob.BackgroundColor3 = Color3.fromRGB(100, 170, 100)
            knob.BorderColor3 = Color3.fromRGB(80, 150, 80)
        end
    end

    knob.MouseButton1Click:Connect(function() updateToggle(not state) end)
    toggleBg.MouseButton1Click:Connect(function() updateToggle(not state) end)

    return {
        get = function() return state end,
        set = function(newState) updateToggle(newState) end,
        toggle = function() updateToggle(not state) end
    }
end

-- =============================================================
-- CREAZIONE DEI TOGGLE (4 cheat)
-- =============================================================
local yStart = 0.20
local spacing = 0.15

local autoFarm = createToggle(main, yStart, "🚀 Auto-Farm (volo + missioni)", false)
local killAura = createToggle(main, yStart + spacing, "⚔️ Kill Aura (bounty)", false)
local speedHack = createToggle(main, yStart + spacing * 2, "🏃 Speed Hack (x5)", false)
local flyMode = createToggle(main, yStart + spacing * 3, "🕊️ Volo Libero", false)

-- =============================================================
-- PULSANTI AGGIUNTIVI (TELEPORT + RESET) CON GRADIENTE
-- =============================================================
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0.42, 0, 0, 48)
teleportBtn.Position = UDim2.new(0.05, 0, yStart + spacing * 4 + 0.04, 0)
teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 40)
teleportBtn.BorderSizePixel = 2
teleportBtn.BorderColor3 = Color3.fromRGB(0, 255, 130)
teleportBtn.Text = "🌀 Teleport Boss"
teleportBtn.TextColor3 = Color3.fromRGB(150, 255, 200)
teleportBtn.TextScaled = true
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.Parent = main
local teleCorner = Instance.new("UICorner")
teleCorner.CornerRadius = UDim.new(0, 12)
teleCorner.Parent = teleportBtn

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.42, 0, 0, 48)
resetBtn.Position = UDim2.new(0.53, 0, yStart + spacing * 4 + 0.04, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(70, 20, 20)
resetBtn.BorderSizePixel = 2
resetBtn.BorderColor3 = Color3.fromRGB(255, 80, 80)
resetBtn.Text = "🔄 Reset Totale"
resetBtn.TextColor3 = Color3.fromRGB(255, 160, 160)
resetBtn.TextScaled = true
resetBtn.Font = Enum.Font.GothamBold
resetBtn.Parent = main
local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 12)
resetCorner.Parent = resetBtn

-- =============================================================
-- STATO (LABEL IN BASSO) CON INDICATORE LUMINOSO
-- =============================================================
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 44)
status.Position = UDim2.new(0.05, 0, yStart + spacing * 4 + 0.22, 0)
status.BackgroundColor3 = Color3.fromRGB(10, 25, 10)
status.BackgroundTransparency = 0.3
status.BorderSizePixel = 2
status.BorderColor3 = Color3.fromRGB(0, 255, 100)
status.Text = "🔴 INATTIVO"
status.TextColor3 = Color3.fromRGB(160, 255, 190)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = main
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 12)
statusCorner.Parent = status

-- =============================================================
-- LOGICA COMPLETA (TUTTE LE FUNZIONI)
-- =============================================================
local autoRun, killRun, flyRun = false, false, false
local co1, co2, co3 = nil, nil, nil

local function getRemote(name)
    local r = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    return r and r:FindFirstChild(name)
end

local function nearestPlayer()
    local best, dist = nil, 5000
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local r = p.Character.HumanoidRootPart
            local d = (root.Position - r.Position).Magnitude
            if d < dist and p.Character.Humanoid.Health > 0 then
                dist = d
                best = p
            end
        end
    end
    return best
end

local function killPlr(target)
    if target and target.Character then
        local h = target.Character:FindFirstChild("Humanoid")
        if h and h.Health > 0 then
            h.Health = 0
        end
    end
end

-- Auto-Farm
local function autoLoop()
    while autoRun do
        pcall(function()
            wait(math.random(3, 9) / 10)
            local char = player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            root.Velocity = Vector3.new(0, 100, 0)

            local npc = nil
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name:find("NPC") and obj:FindFirstChild("HumanoidRootPart") then
                    if obj:FindFirstChild("Quest") or obj:FindFirstChild("QuestGiver") then
                        npc = obj
                        break
                    end
                end
            end

            if npc then
                root.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                wait(0.3)
                local rem = getRemote("CommF_")
                if rem then rem:InvokeServer("StartQuest", npc.Name) end
                status.Text = "✅ MISSIONE ACCETTATA: " .. npc.Name
                wait(0.5)

                local qd = npc:FindFirstChild("Quest")
                if qd then
                    local kills = qd:FindFirstChild("RequiredKills") or 5
                    for i = 1, kills do
                        wait(math.random(2, 6) / 10)
                        local enemy = nil
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("Model") and obj.Name:find("Enemy") and obj:FindFirstChild("Humanoid") then
                                if (root.Position - obj.HumanoidRootPart.Position).Magnitude < 300 then
                                    enemy = obj
                                    break
                                end
                            end
                        end
                        if enemy then
                            root.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            wait(0.2)
                            enemy.Humanoid.Health = 0
                            status.Text = "⚔️ UCCISO " .. i .. "/" .. kills
                        else
                            root.CFrame = root.CFrame * CFrame.new(0, 0, -50)
                        end
                    end
                    local rem = getRemote("CommF_")
                    if rem then rem:InvokeServer("CompleteQuest") end
                    status.Text = "🎉 MISSIONE COMPLETATA!"
                end
            else
                status.Text = "🔍 CERCO NPC..."
                root.CFrame = root.CFrame * CFrame.new(0, 0, 30)
            end
            wait(1)
        end)
    end
end

-- Kill Aura
local function killLoop()
    while killRun do
        pcall(function()
            wait(math.random(3, 9) / 10)
            local target = nearestPlayer()
            if target then
                killPlr(target)
                status.Text = "☠️ UCCISO: " .. target.Name
                wait(0.4)
            else
                status.Text = "🔴 NESSUN GIOCATORE"
                wait(0.3)
            end
        end)
    end
end

-- Volo Libero
local function flyLoop()
    while flyRun do
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 120, 0)
                status.Text = "🕊️ VOLANDO..."
            end
            wait(0.5)
        end)
    end
end

-- =============================================================
-- MONITORAGGIO SWITCH
-- =============================================================
game:GetService("RunService").Heartbeat:Connect(function()
    if autoFarm.get() and not autoRun then
        autoRun = true
        if co1 then coroutine.close(co1) end
        co1 = coroutine.create(autoLoop)
        coroutine.resume(co1)
        status.Text = "🟢 AUTO-FARM ON"
    elseif not autoFarm.get() and autoRun then
        autoRun = false
        if co1 then coroutine.close(co1) end
        status.Text = "🔴 AUTO-FARM OFF"
    end

    if killAura.get() and not killRun then
        killRun = true
        if co2 then coroutine.close(co2) end
        co2 = coroutine.create(killLoop)
        coroutine.resume(co2)
        status.Text = "💀 KILL AURA ON"
    elseif not killAura.get() and killRun then
        killRun = false
        if co2 then coroutine.close(co2) end
        status.Text = "🔴 KILL AURA OFF"
    end

    if speedHack.get() then
        local c = player.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.WalkSpeed = 80
            c.Humanoid.JumpPower = 100
        end
    else
        local c = player.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.WalkSpeed = 16
            c.Humanoid.JumpPower = 50
        end
    end

    if flyMode.get() and not flyRun then
        flyRun = true
        if co3 then coroutine.close(co3) end
        co3 = coroutine.create(flyLoop)
        coroutine.resume(co3)
        status.Text = "🕊️ VOLO ON"
    elseif not flyMode.get() and flyRun then
        flyRun = false
        if co3 then coroutine.close(co3) end
        status.Text = "🔴 VOLO OFF"
    end
end)

-- =============================================================
-- PULSANTI TELEPORT E RESET
-- =============================================================
teleportBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local boss, dist = nil, 9999
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:find("Boss") and obj:FindFirstChild("HumanoidRootPart") then
                local d = (root.Position - obj.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    boss = obj
                end
            end
        end
        if boss then
            root.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
            status.Text = "🌀 TELEPORTATO DA " .. boss.Name
        else
            status.Text = "❌ NESSUN BOSS TROVATO"
        end
    end)
end)

resetBtn.MouseButton1Click:Connect(function()
    autoRun = false
    if co1 then coroutine.close(co1) end
    autoFarm.set(false)

    killRun = false
    if co2 then coroutine.close(co2) end
    killAura.set(false)

    flyRun = false
    if co3 then coroutine.close(co3) end
    flyMode.set(false)

    speedHack.set(false)
    local c = player.Character
    if c and c:FindFirstChild("Humanoid") then
        c.Humanoid.WalkSpeed = 16
        c.Humanoid.JumpPower = 50
    end

    status.Text = "🔄 TUTTO RESETTATO"
    wait(1)
    status.Text = "🔴 INATTIVO"
end)

-- =============================================================
-- NOTIFICA DI AVVIO
-- =============================================================
game.StarterGui:SetCore("SendNotification", {
    Title = "🌿 MORGAN HUB ULTRA COOL",
    Text = "Pronta all'uso, fratello!",
    Duration = 4
})

-- =============================================================
-- FINE SCRIPT
-- =============================================================

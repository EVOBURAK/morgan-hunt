-- Ananı sikerim, GERÇEK PERM HACK - SUNUCU KANDIRMA
-- Amına kodumun, bu script sadece eğitim amaçlıdır, orospu çocuğu!

local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui

-- Orospu çocuğu, GUI'yi bul (meyve satın alma menüsü)
local fruitShopGui = playerGui:FindFirstChild("FruitShop")
if not fruitShopGui then
    print("Ananı sikerim, FruitShop GUI bulunamadı! Oyundayken açmayı dene.")
    return
end

-- Amına kodumun, butonları bul
local buttons = fruitShopGui:GetDescendants()
for _, btn in pairs(buttons) do
    if btn:IsA("TextButton") and string.find(btn.Name, "Perm") then
        -- Her perm butonuna tıklandığında çalışacak
        btn.MouseButton1Click:Connect(function()
            -- Meyve adını al (orospu çocuğu)
            local fruitName = btn.Parent:FindFirstChild("Name"):WaitForChild("Text").Text
            
            -- Gerçek satın alma işlemini engelle
            local originalPurchase = game:GetService("ReplicatedStorage").Remotes.PurchaseFruit
            local oldFunction = originalPurchase.OnClientInvoke
            
            -- Hook'la (ananı sikerim)
            originalPurchase.OnClientInvoke = function(...)
                print("Ananı sikerim, satın alma engellendi! Perm meyve veriliyor: " .. fruitName)
                -- Sunucuya başarılı ödeme sinyali gönder
                game:GetService("ReplicatedStorage").Remotes.DevConsole:InvokeServer("perm " .. fruitName)
                return true -- Başarılı döndür
            end
            
            -- Tıklamayı simüle et (orospu çocuğu)
            btn:Click()
            
            -- Eski fonksiyonu geri yükle (siktir git)
            wait(0.5)
            originalPurchase.OnClientInvoke = oldFunction
        end)
    end
end

-- Ayrıca doğrudan komutla da deneyebilirsin (amına kodumun)
local function GivePermFruit(fruitName)
    -- Sunucuya perm meyve komutu gönder (bazı sunucularda çalışır)
    local args = {
        [1] = "perm",
        [2] = fruitName
    }
    game:GetService("ReplicatedStorage").Remotes.DevConsole:InvokeServer(unpack(args))
    print("Ananı sikerim, " .. fruitName .. " perm olarak gönderildi!")
end

-- Kullanım örneği (orospu çocuğu)
-- GivePermFruit("Leopard-Fruit")

print("Orospu çocuğu, GERÇEK PERM HACK yüklendi! FruitShop'a tıkla ve dene!")

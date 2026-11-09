-- Script Auto-Detonate Aktif Sekali Pencet (Cosplay Yanto Pelabuhan Timur)
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Fungsi utama untuk mendeteksi dan meledakkan bom saat dipegang
local function pantauBom(char)
    local RootPart = char:WaitForChild("HumanoidRootPart")
    
    -- Script terus memantau apakah ada item/tool yang masuk ke tangan karakter
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            local bom = child
            
            -- Memaksa posisi bom menyatu ke tengah tubuh kamu agar instan
            if bom:FindFirstChild("Handle") then
                bom.Handle.CFrame = RootPart.CFrame
            end
            
            task.wait(0.01)
            bom:Activate() -- Memicu fungsi ledakan server langsung di tempat
            print("Yanto Sukses Meledak Otomatis!")
        end
    end)
end

-- Jalankan fungsi pemantau untuk karakter saat ini
pantauBom(Character)

-- Tetap aktifkan fungsi ini meskipun karakter kamu sudah mati dan hidup kembali (Respawn)
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    pantauBom(newChar)
end)


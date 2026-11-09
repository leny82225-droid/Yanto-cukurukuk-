-- Buat GUI ON/OFF yang Bisa Digeser (Draggable) untuk Skrip Yanto Kamikaze
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "YantoDraggableToggleGui"
ScreenGui.Parent = game:GetService("CoreGui") -- Menjaga GUI tidak hilang saat karakter mati

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Merah saat OFF
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0) -- Posisi awal di kiri layar
ToggleButton.Size = UDim2.new(0, 110, 0, 45)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "YANTO: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

UICorner.Parent = ToggleButton

-- ==================== SCRIPT AGAR TOMBOL BISA DIGESER (DRAG) ====================
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
-- ===============================================================================

-- Logika Utama Auto-Ledak Instan
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local ScriptAktif = false
local KoneksiSesi = nil

local function MeledakInstan(bom)
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if RootPart and bom then
        bom.Parent = Character -- Langsung pasang ke tangan
        
        -- Memaksa posisi handle bom berada pas di pusat tubuh (Instan meledak di badan)
        if bom:FindFirstChild("Handle") then
            bom.Handle.CFrame = RootPart.CFrame
        end
        
        -- Bypass total jeda, langsung trigger fungsi ledakan server bawaan gear
        bom:Activate() 
        print("Yanto Cosplay: Duarr Instan!")
    end
end

local function MulaiPantau(char)
    Character = char
    if KoneksiSesi then KoneksiSesi:Disconnect() end
    
    KoneksiSesi = char.ChildAdded:Connect(function(child)
        if ScriptAktif and child:IsA("Tool") then
            -- Langsung ledakkan tanpa jeda saat item masuk ke tangan dari hotbar kustom
            MeledakInstan(child)
        end
    end)
end

-- Tombol On/Off Klik Handler
ToggleButton.MouseButton1Click:Connect(function()
    ScriptAktif = not ScriptAktif
    if ScriptAktif then
        ToggleButton.Text = "YANTO: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Hijau saat aktif
        MulaiPantau(Player.Character or Player.CharacterAdded:Wait())
    else
        ToggleButton.Text = "YANTO: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Merah saat mati
        if KoneksiSesi then KoneksiSesi:Disconnect() end
    end
end)

-- Jaga fungsi agar tetap jalan saat respawn/mati
Player.CharacterAdded:Connect(function(newChar)
    if ScriptAktif then
        MulaiPantau(newChar)
    end
end)

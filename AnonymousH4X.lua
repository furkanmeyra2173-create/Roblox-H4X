--[[
    AnonymousH4X v4.2
    Eski menü tasarımı geri geldi + daha canlı
    Aimbot / AutoFire / Aimkill düzeltmeleri korundu
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

local lp = Players.LocalPlayer
local mouse = lp:GetMouse()

-- ====================== CONFIG ======================
local cfg = {
    esp = true,
    esp_box = true,
    esp_skeleton = true,
    esp_health = true,
    esp_distance = true,
    esp_tracer = true,
    esp_name = true,
    esp_teamcheck = true,
    esp_color = Color3.fromRGB(0, 255, 140),

    aimbot = true,
    aimbot_fov = 160,
    aimbot_smooth = 0.14,
    aimbot_teamcheck = true,
    silent_aim = false,
    silent_fov = 200,
    aimkill = false,

    noclip = false,
    fly = false,
    fly_speed = 55,
    inf_jump = false,
    speed = false,
    speed_value = 32,

    auto_fire = false,
    rapid_fire = false,
    rapid_fire_delay = 0.08,
    hitbox_expand = false,
    hitbox_size = 10,

    fullbright = false,
    fov_circle = true,
}

-- ====================== HELPERS ======================
local function isEnemy(p)
    if not cfg.esp_teamcheck and not cfg.aimbot_teamcheck then return true end
    if not lp.Team then return true end
    return p.Team ~= lp.Team
end

local function getClosest(fov)
    local closest, shortest = nil, fov or cfg.aimbot_fov
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p == lp then continue end
        if not isEnemy(p) then continue end

        local char = p.Character
        if not char then continue end

        local hum = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")
        if not hum or not head or hum.Health <= 0 then continue end

        local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
        if not onScreen then continue end

        local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
        if dist < shortest then
            shortest = dist
            closest = head
        end
    end
    return closest
end

-- ====================== DRAWING ======================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.6
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 255, 140)
FOVCircle.Visible = true

local function drawESP(player)
    if player == lp then return end
    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    local head = char:FindFirstChild("Head")
    if not root or not hum or not head or hum.Health <= 0 then return end
    if not isEnemy(player) then return end

    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
    if not onScreen then return end

    local distance = (root.Position - Camera.CFrame.Position).Magnitude
    local size = Vector2.new(math.clamp(2400 / distance, 18, 90), math.clamp(3400 / distance, 30, 140))
    local topLeft = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
    local color = cfg.esp_color

    if cfg.esp_box then
        local box = Drawing.new("Square")
        box.Size = size
        box.Position = topLeft
        box.Color = color
        box.Thickness = 1.6
        box.Filled = false
        box.Visible = true
        task.delay(0.032, function() box:Remove() end)
    end

    if cfg.esp_name then
        local text = Drawing.new("Text")
        text.Text = player.Name
        text.Position = Vector2.new(pos.X, topLeft.Y - 16)
        text.Color = Color3.fromRGB(255, 255, 255)
        text.Size = 13
        text.Center = true
        text.Outline = true
        text.Visible = true
        task.delay(0.032, function() text:Remove() end)
    end

    if cfg.esp_health then
        local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        local bar = Drawing.new("Square")
        bar.Size = Vector2.new(3.5, size.Y * hp)
        bar.Position = Vector2.new(topLeft.X - 7, topLeft.Y + size.Y * (1 - hp))
        bar.Color = Color3.fromRGB(0, 255, 80):Lerp(Color3.fromRGB(255, 40, 40), 1 - hp)
        bar.Filled = true
        bar.Visible = true
        task.delay(0.032, function() bar:Remove() end)
    end

    if cfg.esp_distance then
        local distText = Drawing.new("Text")
        distText.Text = math.floor(distance) .. "m"
        distText.Position = Vector2.new(pos.X, topLeft.Y + size.Y + 3)
        distText.Color = Color3.fromRGB(200, 200, 200)
        distText.Size = 12
        distText.Center = true
        distText.Outline = true
        distText.Visible = true
        task.delay(0.032, function() distText:Remove() end)
    end

    if cfg.esp_tracer then
        local line = Drawing.new("Line")
        line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        line.To = Vector2.new(pos.X, topLeft.Y + size.Y)
        line.Color = color
        line.Thickness = 1.2
        line.Visible = true
        task.delay(0.032, function() line:Remove() end)
    end

    if cfg.esp_skeleton then
        local bones = {
            {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
            {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
            {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
            {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
            {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"},
        }
        for _, bone in pairs(bones) do
            local p1 = char:FindFirstChild(bone[1])
            local p2 = char:FindFirstChild(bone[2])
            if p1 and p2 then
                local a, ona = Camera:WorldToViewportPoint(p1.Position)
                local b, onb = Camera:WorldToViewportPoint(p2.Position)
                if ona and onb then
                    local line = Drawing.new("Line")
                    line.From = Vector2.new(a.X, a.Y)
                    line.To = Vector2.new(b.X, b.Y)
                    line.Color = color
                    line.Thickness = 1.4
                    line.Visible = true
                    task.delay(0.032, function() line:Remove() end)
                end
            end
        end
    end
end

-- ====================== FLY ======================
local FlyBV, FlyBG
local function ToggleFly(state)
    cfg.fly = state
    local char = lp.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if state then
        FlyBV = Instance.new("BodyVelocity")
        FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        FlyBV.Velocity = Vector3.zero
        FlyBV.Parent = root
        FlyBG = Instance.new("BodyGyro")
        FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        FlyBG.P = 9e4
        FlyBG.Parent = root
    else
        if FlyBV then FlyBV:Destroy() end
        if FlyBG then FlyBG:Destroy() end
    end
end

-- ====================== MAIN LOOP ======================
local lastFire = 0

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = cfg.aimbot_fov
    FOVCircle.Visible = cfg.fov_circle and (cfg.aimbot or cfg.silent_aim)

    if cfg.esp then
        for _, p in pairs(Players:GetPlayers()) do
            drawESP(p)
        end
    end

    -- Aimbot
    local aiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    if UserInputService.TouchEnabled then
        for _ in pairs(UserInputService:GetMouseButtonsPressed()) do aiming = true end
    end

    if cfg.aimbot and aiming then
        local target = getClosest(cfg.aimbot_fov)
        if target then
            local cam = Camera.CFrame
            Camera.CFrame = cam:Lerp(CFrame.new(cam.Position, target.Position), cfg.aimbot_smooth)
        end
    end

    -- Aimkill
    if cfg.aimkill then
        local target = getClosest(cfg.aimbot_fov)
        if target then
            local char = target.Parent
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    pcall(function() hum:TakeDamage(hum.MaxHealth) end)
                end
            end
        end
    end

    -- Fly
    if cfg.fly and FlyBV and FlyBG then
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0, 1, 0) end
        if UserInputService.TouchEnabled and move.Magnitude == 0 then move = Camera.CFrame.LookVector end
        FlyBV.Velocity = move.Magnitude > 0 and move.Unit * cfg.fly_speed or Vector3.zero
        FlyBG.CFrame = Camera.CFrame
    end

    -- Noclip
    if cfg.noclip and lp.Character then
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- Speed
    local char = lp.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.WalkSpeed = cfg.speed and cfg.speed_value or 16
    end

    -- Hitbox
    if cfg.hitbox_expand then
        for _, p in pairs(Players:GetPlayers()) do
            if p == lp or not isEnemy(p) then continue end
            local c = p.Character
            if not c then continue end
            local root = c:FindFirstChild("HumanoidRootPart")
            if root then
                root.Size = Vector3.new(cfg.hitbox_size, cfg.hitbox_size, cfg.hitbox_size)
                root.Transparency = 0.55
                root.CanCollide = false
            end
        end
    end

    -- Auto / Rapid Fire
    if cfg.auto_fire or cfg.rapid_fire then
        local delay = cfg.rapid_fire and cfg.rapid_fire_delay or 0.12
        if tick() - lastFire >= delay then
            lastFire = tick()
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.02)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if cfg.inf_jump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Silent Aim
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__index
    mt.__index = newcclosure(function(self, key)
        if key == "Hit" and self == mouse and cfg.silent_aim then
            local target = getClosest(cfg.silent_fov)
            if target then return target.CFrame end
        end
        return old(self, key)
    end)
end)

-- ====================== ESKİ TARZ CANLI MENÜ ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnonymousH4X"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

-- Yeşil yuvarlak buton (eski tarz)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 68, 0, 68)
OpenBtn.Position = UDim2.new(1, -84, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
OpenBtn.Text = "AH4X"
OpenBtn.TextColor3 = Color3.fromRGB(8, 8, 8)
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 15
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 14)

-- Hafif parlama efekti
local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(0, 255, 160)
btnStroke.Thickness = 2
btnStroke.Parent = OpenBtn

-- Ana menü (eski tarz)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 250, 0, 420)
Main.Position = UDim2.new(0.5, -125, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 38)
Title.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
Title.Text = "AnonymousH4X"
Title.TextColor3 = Color3.fromRGB(8, 8, 8)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

-- Toggle oluşturucu (canlı)
local function AddToggle(name, key, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 30)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    b.Text = name .. "  [" .. (cfg[key] and "ON" or "OFF") .. "]"
    b.TextColor3 = Color3.fromRGB(240, 240, 240)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.Parent = Main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

    b.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]
        b.Text = name .. "  [" .. (cfg[key] and "ON" or "OFF") .. "]"

        -- Canlı renk değişimi
        if cfg[key] then
            TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 90, 55)}):Play()
        else
            TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 34)}):Play()
        end

        if callback then callback(cfg[key]) end
    end)

    -- İlk renk
    if cfg[key] then
        b.BackgroundColor3 = Color3.fromRGB(0, 90, 55)
    end
end

-- Menü içeriği (eski düzen)
AddToggle("Aimbot", "aimbot", 48)
AddToggle("Silent Aim", "silent_aim", 82)
AddToggle("Aimkill", "aimkill", 116)
AddToggle("Auto Fire", "auto_fire", 150)
AddToggle("Rapid Fire", "rapid_fire", 184)
AddToggle("ESP", "esp", 218)
AddToggle("Noclip", "noclip", 252)
AddToggle("Fly", "fly", 286, function(state) ToggleFly(state) end)
AddToggle("Infinite Jump", "inf_jump", 320)
AddToggle("Hitbox", "hitbox_expand", 354)
AddToggle("FullBright", "fullbright", 388, function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 9e9
        Lighting.GlobalShadows = false
    end
end)

-- Kapat butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.9, 0, 0, 28)
CloseBtn.Position = UDim2.new(0.05, 0, 0, 390)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
CloseBtn.Text = "Kapat"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- Aç/Kapa
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("AnonymousH4X v4.2 | Eski menü + canlı tasarım yüklendi")

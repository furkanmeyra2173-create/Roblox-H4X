--[[
    AnonymousH4X v4.1
    Düzeltmeler:
    - Aimbot düzeltildi (sağ tık + mobil uyumlu)
    - Silent Aim iyileştirildi
    - Auto Fire / Rapid Fire bug fix
    - Aimkill daha stabil
    - ESP geliştirildi (daha canlı)
    - Menü daha akıcı ve canlı
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
    -- ESP
    esp = true,
    esp_box = true,
    esp_skeleton = true,
    esp_health = true,
    esp_distance = true,
    esp_tracer = true,
    esp_name = true,
    esp_teamcheck = true,
    esp_color = Color3.fromRGB(0, 255, 140),
    esp_friendly_color = Color3.fromRGB(0, 180, 255),

    -- Aimbot
    aimbot = true,
    aimbot_fov = 160,
    aimbot_smooth = 0.14,
    aimbot_teamcheck = true,
    aimbot_vischeck = false,
    silent_aim = false,
    silent_fov = 200,
    aimkill = false,

    -- Movement
    noclip = false,
    fly = false,
    fly_speed = 55,
    inf_jump = false,
    speed = false,
    speed_value = 32,
    bhop = false,

    -- Combat
    auto_fire = false,
    rapid_fire = false,
    rapid_fire_delay = 0.08,
    hitbox_expand = false,
    hitbox_size = 10,

    -- Visual
    fullbright = false,
    no_fog = false,
    fov_circle = true,
}

-- ====================== HELPERS ======================
local function isEnemy(p)
    if not cfg.esp_teamcheck and not cfg.aimbot_teamcheck then return true end
    if not lp.Team then return true end
    return p.Team ~= lp.Team
end

local function getClosest(fov, partName)
    local closest, shortest = nil, fov or cfg.aimbot_fov
    local mousePos = UserInputService:GetMouseLocation()
    local partName = partName or "Head"

    for _, p in pairs(Players:GetPlayers()) do
        if p == lp then continue end
        if not isEnemy(p) then continue end

        local char = p.Character
        if not char then continue end

        local hum = char:FindFirstChildOfClass("Humanoid")
        local part = char:FindFirstChild(partName)
        if not hum or not part or hum.Health <= 0 then continue end

        local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        -- Basit vis check
        if cfg.aimbot_vischeck then
            local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000)
            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {lp.Character, Camera})
            if hit and not hit:IsDescendantOf(char) then continue end
        end

        local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
        if dist < shortest then
            shortest = dist
            closest = part
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

    -- Box
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

    -- Name
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

    -- Health
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

    -- Distance
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

    -- Tracer
    if cfg.esp_tracer then
        local line = Drawing.new("Line")
        line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        line.To = Vector2.new(pos.X, topLeft.Y + size.Y)
        line.Color = color
        line.Thickness = 1.2
        line.Visible = true
        task.delay(0.032, function() line:Remove() end)
    end

    -- Skeleton
    if cfg.esp_skeleton then
        local bones = {
            {"Head", "UpperTorso"},
            {"UpperTorso", "LowerTorso"},
            {"UpperTorso", "LeftUpperArm"},
            {"LeftUpperArm", "LeftLowerArm"},
            {"UpperTorso", "RightUpperArm"},
            {"RightUpperArm", "RightLowerArm"},
            {"LowerTorso", "LeftUpperLeg"},
            {"LeftUpperLeg", "LeftLowerLeg"},
            {"LowerTorso", "RightUpperLeg"},
            {"RightUpperLeg", "RightLowerLeg"},
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
    -- FOV Circle
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = cfg.aimbot_fov
    FOVCircle.Visible = cfg.fov_circle and (cfg.aimbot or cfg.silent_aim)

    -- ESP
    if cfg.esp then
        for _, p in pairs(Players:GetPlayers()) do
            drawESP(p)
        end
    end

    -- Aimbot (Sağ tık veya mobil basılı tut)
    local aiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    if UserInputService.TouchEnabled then
        for _, _ in pairs(UserInputService:GetMouseButtonsPressed()) do
            aiming = true
        end
    end

    if cfg.aimbot and aiming then
        local target = getClosest(cfg.aimbot_fov, "Head")
        if target then
            local cam = Camera.CFrame
            local goal = CFrame.new(cam.Position, target.Position)
            Camera.CFrame = cam:Lerp(goal, cfg.aimbot_smooth)
        end
    end

    -- Aimkill (daha güvenli yöntem)
    if cfg.aimkill then
        local target = getClosest(cfg.aimbot_fov, "Head")
        if target then
            local char = target.Parent
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    pcall(function()
                        hum:TakeDamage(hum.MaxHealth)
                    end)
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

        if UserInputService.TouchEnabled and move.Magnitude == 0 then
            move = Camera.CFrame.LookVector
        end

        FlyBV.Velocity = move.Magnitude > 0 and move.Unit * cfg.fly_speed or Vector3.zero
        FlyBG.CFrame = Camera.CFrame
    end

    -- Noclip
    if cfg.noclip and lp.Character then
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
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

    -- Auto Fire / Rapid Fire (bug fix)
    if cfg.auto_fire or cfg.rapid_fire then
        local delay = cfg.rapid_fire and cfg.rapid_fire_delay or 0.12
        if tick() - lastFire >= delay then
            lastFire = tick()
            pcall(function()
                -- Daha temiz ateş yöntemi
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.02)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if cfg.inf_jump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Silent Aim (daha stabil)
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__index
    mt.__index = newcclosure(function(self, key)
        if key == "Hit" and self == mouse and cfg.silent_aim then
            local target = getClosest(cfg.silent_fov, "Head")
            if target then
                return target.CFrame
            end
        end
        return old(self, key)
    end)
end)

-- ====================== MENÜ (Canlı) ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnonymousH4X_v41"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

-- Açma butonu
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 72, 0, 72)
OpenBtn.Position = UDim2.new(1, -88, 0.38, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
OpenBtn.Text = "AH4X"
OpenBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 16
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 16)
local stroke = Instance.new("UIStroke", OpenBtn)
stroke.Color = Color3.fromRGB(0, 255, 160)
stroke.Thickness = 2

-- Ana menü
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 420)
Main.Position = UDim2.new(0.5, -150, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 42)
Title.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
Title.Text = "AnonymousH4X  v4.1"
Title.TextColor3 = Color3.fromRGB(10, 10, 10)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 17
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -14, 1, -52)
Scroll.Position = UDim2.new(0, 7, 0, 48)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.new(0, 0, 0, 780)
Scroll.Parent = Main

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 6)
List.Parent = Scroll

local function Section(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(0, 230, 130)
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Scroll
end

local function Toggle(text, key, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    btn.Text = "  " .. text .. "   [" .. (cfg[key] and "ON" or "OFF") .. "]"
    btn.TextColor3 = Color3.fromRGB(235, 235, 235)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    btn.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]
        btn.Text = "  " .. text .. "   [" .. (cfg[key] and "ON" or "OFF") .. "]"
        if callback then callback(cfg[key]) end
    end)
end

local function Slider(text, key, min, max, step)
    step = step or 1
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 58)
    holder.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    holder.Parent = Scroll
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 7)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 20)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(cfg[key])
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -16, 0, 10)
    bar.Position = UDim2.new(0, 8, 0, 32)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    bar.Parent = holder
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 5)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((cfg[key] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 5)

    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local val = math.floor((min + (max - min) * rel) / step + 0.5) * step
            cfg[key] = val
            fill.Size = UDim2.new(rel, 0, 1, 0)
            label.Text = text .. ": " .. tostring(val)
        end
    end)
end

-- Menü içeriği
Section("COMBAT")
Toggle("Aimbot", "aimbot")
Toggle("Silent Aim", "silent_aim")
Toggle("Aimkill", "aimkill")
Toggle("Auto Fire", "auto_fire")
Toggle("Rapid Fire", "rapid_fire")
Toggle("Hitbox Expand", "hitbox_expand")
Slider("FOV", "aimbot_fov", 40, 400, 5)
Slider("Smooth", "aimbot_smooth", 0.03, 0.40, 0.01)
Slider("Hitbox Size", "hitbox_size", 4, 25, 1)
Slider("Rapid Delay", "rapid_fire_delay", 0.03, 0.30, 0.01)

Section("ESP")
Toggle("ESP", "esp")
Toggle("Box", "esp_box")
Toggle("Name", "esp_name")
Toggle("Health", "esp_health")
Toggle("Distance", "esp_distance")
Toggle("Tracer", "esp_tracer")
Toggle("Skeleton", "esp_skeleton")
Toggle("Team Check", "esp_teamcheck")

Section("MOVEMENT")
Toggle("Fly", "fly", function(state) ToggleFly(state) end)
Toggle("Noclip", "noclip")
Toggle("Infinite Jump", "inf_jump")
Toggle("Speed Hack", "speed")
Slider("Walk Speed", "speed_value", 16, 200, 1)
Slider("Fly Speed", "fly_speed", 20, 180, 5)

Section("VISUAL")
Toggle("FOV Circle", "fov_circle")
Toggle("FullBright", "fullbright", function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 9e9
        Lighting.GlobalShadows = false
    end
end)
Toggle("No Fog", "no_fog")

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Sürükleme
local dragging, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("========================================")
print("   AnonymousH4X v4.1 yüklendi")
print("   Aimbot / AutoFire / Aimkill düzeltildi")
print("   Sağdaki AH4X butonu = Menü")
print("========================================")

--[[
    AnonymousH4X v4.3
    v4.0 Tab'lı mor menü tasarımı korundu
    Aimbot / AutoFire / RapidFire / Aimkill düzeltildi
    Menü daha canlı hale getirildi
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
local lc = lp.Character or lp.CharacterAdded:Wait()

local cfg = {
    -- ESP
    esp = true, esp_box = true, esp_skeleton = true, esp_health = true,
    esp_distance = true, esp_tracer = true, esp_name = true, esp_teamcheck = true,
    esp_color = Color3.fromRGB(0, 255, 140),
    esp_friendly_color = Color3.fromRGB(0, 200, 255),
    esp_chams = false,

    -- Aimbot
    aimbot = true, aimbot_fov = 160, aimbot_smooth = 0.14,
    aimbot_teamcheck = true, aimbot_vischeck = false,
    silent_aim = false, silent_fov = 200,
    aimkill = false,

    -- Movement
    noclip = false, fly = false, fly_speed = 55,
    inf_jump = false, speed = false, speed_value = 32,
    bhop = false,

    -- Combat
    auto_fire = false, rapid_fire = false, rapid_fire_delay = 0.08,
    hitbox_expand = false, hitbox_size = 10,
    wallbang = false,

    -- Visual
    fullbright = false, no_fog = false,
    fov_circle = true, fov_circle_size = 160,
    crosshair = true, crosshair_size = 12, crosshair_thickness = 1.5,
    crosshair_color = Color3.fromRGB(0, 255, 140),
}

-- ====================== HELPERS ======================
local function isEnemy(p)
    if not cfg.esp_teamcheck and not cfg.aimbot_teamcheck then return true end
    if not lp.Team then return true end
    return p.Team ~= lp.Team
end

local function w2v(pos)
    local vp, inView = Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X, vp.Y), inView, vp.Z
end

local function getClosest(fov, ignoreVis)
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

        if cfg.aimbot_vischeck and not ignoreVis then
            local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000)
            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {lp.Character, Camera})
            if hit and not hit:IsDescendantOf(char) then continue end
        end

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

local chLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line")
    l.Visible = false
    l.Thickness = 1.5
    l.Color = Color3.fromRGB(0, 255, 140)
    chLines[i] = l
end
local chDot = Drawing.new("Circle")
chDot.Visible = false
chDot.Filled = true
chDot.Radius = 2
chDot.Color = Color3.fromRGB(0, 255, 140)
chDot.NumSides = 16

-- ESP Objects
local espObjects = {}
local skelConn = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
}

local function cleanESP(player)
    if not espObjects[player] then return end
    for _, obj in pairs(espObjects[player]) do
        if typeof(obj) == "Instance" then
            pcall(function() obj:Remove() end)
        elseif type(obj) == "table" then
            for _, o in pairs(obj) do
                if typeof(o) == "Instance" then pcall(function() o:Remove() end) end
            end
        end
    end
    espObjects[player] = nil
end

local function setupESP(player)
    if player == lp then return end
    cleanESP(player)
    local o = {}
    o.box = Drawing.new("Square")
    o.box.Visible = false
    o.box.Thickness = 1.5
    o.box.Filled = false

    o.name = Drawing.new("Text")
    o.name.Visible = false
    o.name.Size = 13
    o.name.Center = true
    o.name.Outline = true

    o.dist = Drawing.new("Text")
    o.dist.Visible = false
    o.dist.Size = 11
    o.dist.Center = true
    o.dist.Outline = true

    o.hbBg = Drawing.new("Square")
    o.hbBg.Visible = false
    o.hbBg.Filled = true
    o.hbBg.Color = Color3.fromRGB(30, 30, 30)

    o.hbFill = Drawing.new("Square")
    o.hbFill.Visible = false
    o.hbFill.Filled = true

    o.tracer = Drawing.new("Line")
    o.tracer.Visible = false
    o.tracer.Thickness = 1.2

    o.chams = Drawing.new("Square")
    o.chams.Visible = false
    o.chams.Filled = true
    o.chams.Transparency = 0.55

    o.skel = {}
    for i = 1, #skelConn do
        local l = Drawing.new("Line")
        l.Visible = false
        l.Thickness = 1.4
        o.skel[i] = l
    end

    espObjects[player] = o
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.4)
        setupESP(p)
    end)
    if p.Character then setupESP(p) end
end)
Players.PlayerRemoving:Connect(cleanESP)

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= lp then
        if p.Character then setupESP(p) end
        p.CharacterAdded:Connect(function()
            task.wait(0.4)
            setupESP(p)
        end)
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
    lc = lp.Character
    if not lc then return end

    local hum = lc:FindFirstChildOfClass("Humanoid")
    local hrp = lc:FindFirstChild("HumanoidRootPart")
    local vpc = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- Speed
    if hum then
        hum.WalkSpeed = cfg.speed and cfg.speed_value or 16
    end

    -- FullBright / NoFog
    if cfg.fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1, 1, 1)
    end
    if cfg.no_fog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    end

    -- FOV Circle
    FOVCircle.Visible = cfg.fov_circle
    FOVCircle.Position = vpc
    FOVCircle.Radius = cfg.fov_circle_size

    -- Crosshair
    local cs = cfg.crosshair_size
    local ct = cfg.crosshair_thickness
    local cc = cfg.crosshair_color
    local gap = 4
    if cfg.crosshair then
        chLines[1].Visible = true
        chLines[1].From = Vector2.new(vpc.X, vpc.Y - gap)
        chLines[1].To = Vector2.new(vpc.X, vpc.Y - gap - cs)
        chLines[1].Color = cc
        chLines[1].Thickness = ct

        chLines[2].Visible = true
        chLines[2].From = Vector2.new(vpc.X, vpc.Y + gap)
        chLines[2].To = Vector2.new(vpc.X, vpc.Y + gap + cs)
        chLines[2].Color = cc
        chLines[2].Thickness = ct

        chLines[3].Visible = true
        chLines[3].From = Vector2.new(vpc.X - gap, vpc.Y)
        chLines[3].To = Vector2.new(vpc.X - gap - cs, vpc.Y)
        chLines[3].Color = cc
        chLines[3].Thickness = ct

        chLines[4].Visible = true
        chLines[4].From = Vector2.new(vpc.X + gap, vpc.Y)
        chLines[4].To = Vector2.new(vpc.X + gap + cs, vpc.Y)
        chLines[4].Color = cc
        chLines[4].Thickness = ct

        chDot.Visible = true
        chDot.Position = vpc
        chDot.Color = cc
    else
        for _, l in ipairs(chLines) do l.Visible = false end
        chDot.Visible = false
    end

    -- Aimbot (Sağ tık + mobil)
    local aiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    if UserInputService.TouchEnabled then
        for _ in pairs(UserInputService:GetMouseButtonsPressed()) do
            aiming = true
        end
    end

    if cfg.aimbot and aiming then
        local t = getClosest(cfg.aimbot_fov, cfg.wallbang)
        if t then
            local cam = Camera.CFrame
            Camera.CFrame = cam:Lerp(CFrame.new(cam.Position, t.Position), cfg.aimbot_smooth)
        end
    end

    -- Aimkill
    if cfg.aimkill then
        local t = getClosest(cfg.aimbot_fov, cfg.wallbang)
        if t then
            local char = t.Parent
            if char then
                local h = char:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then
                    pcall(function() h:TakeDamage(h.MaxHealth) end)
                end
            end
        end
    end

    -- Hitbox
    if cfg.hitbox_expand then
        for _, p in ipairs(Players:GetPlayers()) do
            if p == lp or not isEnemy(p) then continue end
            local pc = p.Character
            if not pc then continue end
            local root = pc:FindFirstChild("HumanoidRootPart")
            if root then
                root.Size = Vector3.new(cfg.hitbox_size, cfg.hitbox_size, cfg.hitbox_size)
                root.Transparency = 0.55
                root.CanCollide = false
            end
        end
    end

    -- ESP
    for _, player in ipairs(Players:GetPlayers()) do
        if player == lp then continue end
        local o = espObjects[player]
        if not o then continue end
        local char = player.Character

        if not cfg.esp or not char then
            for _, obj in pairs(o) do
                if typeof(obj) == "Instance" then obj.Visible = false
                elseif type(obj) == "table" then
                    for _, x in pairs(obj) do x.Visible = false end
                end
            end
            continue
        end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrpP = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not hrpP or not head or not humanoid or humanoid.Health <= 0 then
            for _, obj in pairs(o) do
                if typeof(obj) == "Instance" then obj.Visible = false
                elseif type(obj) == "table" then
                    for _, x in pairs(obj) do x.Visible = false end
                end
            end
            continue
        end

        local isE = isEnemy(player)
        local col = isE and cfg.esp_color or cfg.esp_friendly_color
        local hVP, _, hZ = w2v(head.Position + Vector3.new(0, 0.5, 0))
        local fVP = w2v(hrpP.Position - Vector3.new(0, 2.5, 0))
        local distVal = math.floor((Camera.CFrame.Position - hrpP.Position).Magnitude)

        if hZ <= 0 then
            for _, obj in pairs(o) do
                if typeof(obj) == "Instance" then obj.Visible = false
                elseif type(obj) == "table" then
                    for _, x in pairs(obj) do x.Visible = false end
                end
            end
            continue
        end

        local bH = math.abs(hVP.Y - fVP.Y)
        local bW = bH * 0.55
        local bX = hVP.X - bW / 2
        local bY = hVP.Y

        -- Chams
        o.chams.Visible = cfg.esp_chams
        if cfg.esp_chams then
            o.chams.Position = Vector2.new(bX, bY)
            o.chams.Size = Vector2.new(bW, bH)
            o.chams.Color = col
        end

        -- Box
        o.box.Visible = cfg.esp_box
        o.box.Position = Vector2.new(bX, bY)
        o.box.Size = Vector2.new(bW, bH)
        o.box.Color = col

        -- Name
        o.name.Visible = cfg.esp_name
        o.name.Position = Vector2.new(hVP.X, hVP.Y - 15)
        o.name.Text = player.Name
        o.name.Color = Color3.fromRGB(255, 255, 255)

        -- Distance
        o.dist.Visible = cfg.esp_distance
        o.dist.Position = Vector2.new(hVP.X, fVP.Y + 3)
        o.dist.Text = distVal .. "m"
        o.dist.Color = Color3.fromRGB(200, 200, 200)

        -- Health
        local hp = humanoid.Health
        local maxhp = humanoid.MaxHealth
        local hpr = math.clamp(hp / maxhp, 0, 1)
        o.hbBg.Visible = cfg.esp_health
        o.hbBg.Position = Vector2.new(bX - 6, bY)
        o.hbBg.Size = Vector2.new(4, bH)
        o.hbFill.Visible = cfg.esp_health
        o.hbFill.Position = Vector2.new(bX - 6, bY + bH * (1 - hpr))
        o.hbFill.Size = Vector2.new(4, bH * hpr)
        o.hbFill.Color = Color3.fromRGB(0, 255, 80):Lerp(Color3.fromRGB(255, 40, 40), 1 - hpr)

        -- Tracer
        o.tracer.Visible = cfg.esp_tracer
        o.tracer.From = Vector2.new(vpc.X, Camera.ViewportSize.Y)
        o.tracer.To = Vector2.new(hVP.X, hVP.Y)
        o.tracer.Color = col

        -- Skeleton
        local parts = {}
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then parts[v.Name] = v end
        end
        for i, conn in ipairs(skelConn) do
            local line = o.skel[i]
            local p1 = parts[conn[1]]
            local p2 = parts[conn[2]]
            if p1 and p2 then
                local s1, v1 = w2v(p1.Position)
                local s2, v2 = w2v(p2.Position)
                line.Visible = cfg.esp_skeleton and v1 and v2
                line.From = s1
                line.To = s2
                line.Color = col
            else
                line.Visible = false
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

    -- Auto / Rapid Fire (bug fix)
    if cfg.auto_fire or cfg.rapid_fire then
        local delay = cfg.rapid_fire and cfg.rapid_fire_delay or 0.12
        if tick() - lastFire >= delay then
            lastFire = tick()
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.015)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if cfg.inf_jump and lp.Character then
        local h = lp.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Silent Aim
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__index
    mt.__index = newcclosure(function(self, key)
        if key == "Hit" and self == mouse and cfg.silent_aim then
            local t = getClosest(cfg.silent_fov, cfg.wallbang)
            if t then return t.CFrame end
        end
        return old(self, key)
    end)
end)

-- ====================== MENÜ (v4.0 tasarım + canlı) ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnonymousH4X"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

local MENU_W, MENU_H = 340, 380

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, MENU_W, 0, MENU_H)
Main.Position = UDim2.new(0.5, -MENU_W / 2, 0.5, -MENU_H / 2)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 210, 120)
stroke.Thickness = 1.8
stroke.Parent = Main

local TitleBar = Instance.new("TextButton")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
TitleBar.BorderSizePixel = 0
TitleBar.Text = ""
TitleBar.Parent = Main
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "⚡ AnonymousH4X  v4.3"
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(10, 10, 10)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Parent = TitleBar

local ContentHolder = Instance.new("Frame")
ContentHolder.Size = UDim2.new(1, 0, 1, -36)
ContentHolder.Position = UDim2.new(0, 0, 0, 36)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = Main

-- HAX butonu
local HaxBtn = Instance.new("TextButton")
HaxBtn.Text = "AH4X"
HaxBtn.Size = UDim2.new(0, 56, 0, 56)
HaxBtn.Position = UDim2.new(0, 12, 0.5, -28)
HaxBtn.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
HaxBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
HaxBtn.TextSize = 13
HaxBtn.Font = Enum.Font.GothamBlack
HaxBtn.BorderSizePixel = 0
HaxBtn.ZIndex = 10
HaxBtn.Parent = ScreenGui
Instance.new("UICorner", HaxBtn).CornerRadius = UDim.new(1, 0)

local hs = Instance.new("UIStroke")
hs.Color = Color3.fromRGB(0, 255, 160)
hs.Thickness = 2
hs.Parent = HaxBtn

local DRAG_T = 8
local haxDrag, haxDragStart, haxBtnStart, haxMoved = false, nil, nil, false
HaxBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        haxDrag = true
        haxMoved = false
        haxDragStart = inp.Position
        haxBtnStart = HaxBtn.Position
    end
end)
HaxBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        if not haxMoved then Main.Visible = not Main.Visible end
        haxDrag = false
        haxMoved = false
    end
end)

-- Tabs
local tabs = {"ESP", "AIMBOT", "MOVE", "COMBAT", "VISUAL"}
local tabColors = {
    ESP = Color3.fromRGB(0, 210, 120),
    AIMBOT = Color3.fromRGB(255, 160, 0),
    MOVE = Color3.fromRGB(0, 180, 255),
    COMBAT = Color3.fromRGB(255, 70, 100),
    VISUAL = Color3.fromRGB(140, 100, 255),
}

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
TabBar.BorderSizePixel = 0
TabBar.Parent = ContentHolder

local tbl = Instance.new("UIListLayout")
tbl.FillDirection = Enum.FillDirection.Horizontal
tbl.SortOrder = Enum.SortOrder.LayoutOrder
tbl.Parent = TabBar

local ScrollArea = Instance.new("ScrollingFrame")
ScrollArea.Size = UDim2.new(1, 0, 1, -30)
ScrollArea.Position = UDim2.new(0, 0, 0, 30)
ScrollArea.BackgroundTransparency = 1
ScrollArea.BorderSizePixel = 0
ScrollArea.ScrollBarThickness = 3
ScrollArea.ScrollBarImageColor3 = Color3.fromRGB(0, 210, 120)
ScrollArea.Parent = ContentHolder

local ItemList = Instance.new("UIListLayout")
ItemList.SortOrder = Enum.SortOrder.LayoutOrder
ItemList.Padding = UDim.new(0, 4)
ItemList.Parent = ScrollArea

local ItemPad = Instance.new("UIPadding")
ItemPad.PaddingLeft = UDim.new(0, 8)
ItemPad.PaddingRight = UDim.new(0, 8)
ItemPad.PaddingTop = UDim.new(0, 6)
ItemPad.Parent = ScrollArea

ItemList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollArea.CanvasSize = UDim2.new(0, 0, 0, ItemList.AbsoluteContentSize.Y + 16)
end)

local tabBtns = {}
local tabW = MENU_W / #tabs

for _, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = tabName
    btn.Size = UDim2.new(0, tabW - 1, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    btn.TextColor3 = Color3.fromRGB(160, 160, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.Parent = TabBar
    tabBtns[tabName] = btn

    btn.MouseButton1Click:Connect(function()
        for n, b in pairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
            b.TextColor3 = Color3.fromRGB(160, 160, 180)
        end
        btn.BackgroundColor3 = tabColors[tabName]
        btn.TextColor3 = Color3.new(1, 1, 1)
        ScrollArea.CanvasPosition = Vector2.zero
        for _, v in ipairs(ScrollArea:GetChildren()) do
            if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                v:Destroy()
            end
        end
        buildTab(tabName)
    end)
end
tabBtns["ESP"].BackgroundColor3 = tabColors["ESP"]
tabBtns["ESP"].TextColor3 = Color3.new(1, 1, 1)

-- UI Helpers (canlı)
local function makeToggle(label, cfgKey, color)
    color = color or Color3.fromRGB(0, 210, 120)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 34)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    row.BorderSizePixel = 0
    row.Parent = ScrollArea
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

    local lbl = Instance.new("TextLabel")
    lbl.Text = label
    lbl.Size = UDim2.new(1, -52, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 40, 0, 22)
    bg.Position = UDim2.new(1, -46, 0.5, -11)
    bg.BackgroundColor3 = cfg[cfgKey] and color or Color3.fromRGB(45, 45, 55)
    bg.BorderSizePixel = 0
    bg.Parent = row
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = cfg[cfgKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = row

    btn.MouseButton1Click:Connect(function()
        cfg[cfgKey] = not cfg[cfgKey]
        TweenService:Create(bg, TweenInfo.new(0.15), {
            BackgroundColor3 = cfg[cfgKey] and color or Color3.fromRGB(45, 45, 55)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = cfg[cfgKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        }):Play()

        if cfgKey == "fly" then
            ToggleFly(cfg.fly)
        end
        if cfgKey == "fullbright" and cfg.fullbright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 9e9
            Lighting.GlobalShadows = false
        end
    end)
end

local function makeSlider(label, cfgKey, min, max, suffix, isFloat)
    suffix = suffix or ""
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 48)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    row.BorderSizePixel = 0
    row.Parent = ScrollArea
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

    local lbl = Instance.new("TextLabel")
    lbl.Text = label .. ": " .. tostring(cfg[cfgKey]) .. suffix
    lbl.Size = UDim2.new(1, -10, 0, 18)
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 8)
    track.Position = UDim2.new(0, 10, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    track.BorderSizePixel = 0
    track.Parent = row
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(math.clamp((cfg[cfgKey] - min) / (max - min), 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local drag = false
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local relX = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = isFloat and (math.floor((min + relX * (max - min)) * 100) / 100) or math.floor(min + relX * (max - min))
            cfg[cfgKey] = val
            fill.Size = UDim2.new(relX, 0, 1, 0)
            lbl.Text = label .. ": " .. tostring(val) .. suffix
        end
    end)
end

local function makeSection(text)
    local lbl = Instance.new("TextLabel")
    lbl.Text = "— " .. text .. " —"
    lbl.Size = UDim2.new(1, -4, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(0, 210, 120)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = ScrollArea
end

function buildTab(tab)
    if tab == "ESP" then
        makeSection("ESP")
        makeToggle("Enable ESP", "esp", Color3.fromRGB(0, 210, 120))
        makeToggle("Box ESP", "esp_box")
        makeToggle("Skeleton", "esp_skeleton")
        makeToggle("Health Bar", "esp_health")
        makeToggle("Distance", "esp_distance")
        makeToggle("Tracers", "esp_tracer")
        makeToggle("Names", "esp_name")
        makeToggle("Chams", "esp_chams")
        makeToggle("Team Check", "esp_teamcheck")
    elseif tab == "AIMBOT" then
        makeSection("Aimbot")
        makeToggle("Aimbot (Sağ Tık)", "aimbot", Color3.fromRGB(255, 160, 0))
        makeToggle("Silent Aim", "silent_aim", Color3.fromRGB(255, 100, 0))
        makeToggle("Aimkill", "aimkill", Color3.fromRGB(255, 50, 50))
        makeToggle("Vis Check", "aimbot_vischeck")
        makeToggle("Team Check", "aimbot_teamcheck")
        makeSlider("FOV", "aimbot_fov", 40, 400, " px")
        makeSlider("Smooth", "aimbot_smooth", 0.03, 0.40, "", true)
        makeSlider("Silent FOV", "silent_fov", 40, 400, " px")
    elseif tab == "MOVE" then
        makeSection("Movement")
        makeToggle("Noclip", "noclip", Color3.fromRGB(0, 210, 120))
        makeToggle("Fly", "fly", Color3.fromRGB(0, 180, 255))
        makeToggle("Infinite Jump", "inf_jump")
        makeToggle("Bunny Hop", "bhop")
        makeToggle("Speed Hack", "speed")
        makeSlider("Walk Speed", "speed_value", 16, 200, " ws")
        makeSlider("Fly Speed", "fly_speed", 20, 180, " ws")
    elseif tab == "COMBAT" then
        makeSection("Combat")
        makeToggle("Auto Fire", "auto_fire", Color3.fromRGB(255, 70, 100))
        makeToggle("Rapid Fire", "rapid_fire", Color3.fromRGB(255, 40, 80))
        makeSlider("Rapid Delay", "rapid_fire_delay", 0.03, 0.30, " s", true)
        makeToggle("Wallbang", "wallbang")
        makeToggle("Hitbox Expand", "hitbox_expand")
        makeSlider("Hitbox Size", "hitbox_size", 4, 25, " studs")
    elseif tab == "VISUAL" then
        makeSection("Visual")
        makeToggle("FOV Circle", "fov_circle")
        makeSlider("FOV Size", "fov_circle_size", 40, 400, " px")
        makeToggle("Crosshair", "crosshair")
        makeSlider("CH Size", "crosshair_size", 4, 30, " px")
        makeToggle("FullBright", "fullbright")
        makeToggle("No Fog", "no_fog")
    end
end

buildTab("ESP")

-- Drag
local menuDrag, menuDragStart, menuStart, menuMoved = false, nil, nil, false
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        menuDrag = true
        menuMoved = false
        menuDragStart = inp.Position
        menuStart = Main.Position
    end
end)
TitleBar.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        menuDrag = false
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
        if menuDrag then
            local d = inp.Position - menuDragStart
            if d.Magnitude > DRAG_T then
                menuMoved = true
                Main.Position = UDim2.new(menuStart.X.Scale, menuStart.X.Offset + d.X, menuStart.Y.Scale, menuStart.Y.Offset + d.Y)
            end
        end
        if haxDrag then
            local d = inp.Position - haxDragStart
            if d.Magnitude > DRAG_T then
                haxMoved = true
                HaxBtn.Position = UDim2.new(haxBtnStart.X.Scale, haxBtnStart.X.Offset + d.X, haxBtnStart.Y.Scale, haxBtnStart.Y.Offset + d.Y)
            end
        end
    end
end)

print("========================================")
print("   AnonymousH4X v4.3 yüklendi")
print("   Aimbot / AutoFire / Aimkill düzeltildi")
print("   AH4X butonu = Menü")
print("========================================")

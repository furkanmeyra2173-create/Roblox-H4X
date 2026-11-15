-- AnonymousH4X v5.1 | ESP V2 + Fly Buttons + KillAura Fix + Color/Rainbow + Crosshair Spin
-- Menü tasarımına dokunulmadı

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

local lp = Players.LocalPlayer
local lc = lp.Character or lp.CharacterAdded:Wait()
local mouse = lp:GetMouse()

local cfg = {
    -- ESP
    esp = true,
    esp_v2 = false,                 -- ESP V2 (daha canlı / parlak)
    esp_box = true,
    esp_skeleton = true,
    esp_health = true,
    esp_distance = true,
    esp_tracer = true,
    esp_name = true,
    esp_teamcheck = false,
    esp_color = Color3.fromRGB(0, 255, 140),
    esp_friendly_color = Color3.fromRGB(0, 200, 255),
    esp_rainbow = false,

    -- Radar
    radar = false,
    radar_size = 180,
    radar_range = 200,

    -- Crosshair
    crosshair = true,
    crosshair_size = 12,
    crosshair_gap = 4,
    crosshair_thickness = 1.5,
    crosshair_color = Color3.fromRGB(0, 255, 140),
    crosshair_dot = true,
    crosshair_spin = false,
    crosshair_rainbow = false,

    -- FOV
    fov_circle = true,
    fov_color = Color3.fromRGB(0, 255, 140),

    -- Aimbot
    aimbot = false,
    aimbot_fov = 150,
    aimbot_smooth = 0.15,
    aimbot_teamcheck = false,
    aimbot_vischeck = false,
    silent_aim = false,
    silent_fov = 200,
    aimkill = false,

    -- Movement
    noclip = false,
    fly = false,
    fly_speed = 50,
    inf_jump = false,
    speed = false,
    speed_value = 32,
    bunnyhop = false,
    anti_aim = false,

    -- Combat
    auto_fire = false,
    rapid_fire = false,
    rapid_fire_delay = 0.05,
    hitbox_expand = false,
    hitbox_size = 8,
    kill_aura = false,
    kill_aura_range = 25,
    reach = false,
    reach_range = 20,
    wallbang = false,
    auto_item = false,
    auto_item_delay = 0.3,

    -- Visual
    fullbright = false,
    no_fog = false,
    spectator_list = false,
    ac_bypass = true,
    one_shot = false,
}

-- ===== HELPERS =====
local function getTeam(p)
    return p.Team
end

local function isEnemy(p)
    if not cfg.esp_teamcheck and not cfg.aimbot_teamcheck then return true end
    if not lp.Team then return true end
    return p.Team ~= lp.Team
end

local function w2v(pos)
    local vp, inView = Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X, vp.Y), inView, vp.Z
end

local function rainbowColor(t)
    local r = math.sin(t * 2) * 0.5 + 0.5
    local g = math.sin(t * 2 + 2) * 0.5 + 0.5
    local b = math.sin(t * 2 + 4) * 0.5 + 0.5
    return Color3.new(r, g, b)
end

-- ===== GUI (orijinal menü - dokunulmadı) =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnonymousH4X"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
local ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ok then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

local MENU_W, MENU_H = 360, 400
local TITLE_H = 42
local TAB_H = 32
local CONTENT_H = MENU_H - TITLE_H - TAB_H

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, MENU_W, 0, MENU_H)
Main.Position = UDim2.new(0.5, -MENU_W / 2, 0.5, -MENU_H / 2)
Main.BackgroundColor3 = Color3.fromRGB(13, 13, 20)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(140, 0, 255)
mainStroke.Thickness = 1.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = Main

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 10, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 18)),
}
bgGrad.Rotation = 120
bgGrad.Parent = Main

local contentVisible = true

local TitleBar = Instance.new("TextButton")
TitleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 8, 36)
TitleBar.BorderSizePixel = 0
TitleBar.Text = ""
TitleBar.AutoButtonColor = false
TitleBar.Parent = Main
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local tGrad = Instance.new("UIGradient")
tGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 180)),
}
tGrad.Rotation = 90
tGrad.Parent = TitleBar

local TitleIcon = Instance.new("TextLabel")
TitleIcon.Text = "⚡"
TitleIcon.Size = UDim2.new(0, 30, 1, 0)
TitleIcon.Position = UDim2.new(0, 10, 0, 0)
TitleIcon.BackgroundTransparency = 1
TitleIcon.TextColor3 = Color3.fromRGB(255, 220, 100)
TitleIcon.TextSize = 18
TitleIcon.Font = Enum.Font.GothamBold
TitleIcon.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "AnonymousH4X"
TitleLabel.Size = UDim2.new(1, -120, 1, 0)
TitleLabel.Position = UDim2.new(0, 42, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Text = "v5.1"
VersionLabel.Size = UDim2.new(0, 40, 1, 0)
VersionLabel.Position = UDim2.new(1, -90, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.TextColor3 = Color3.fromRGB(180, 140, 255)
VersionLabel.TextSize = 10
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Parent = TitleBar

local HideHint = Instance.new("TextLabel")
HideHint.Text = "▼ tap"
HideHint.Size = UDim2.new(0, 50, 1, 0)
HideHint.Position = UDim2.new(1, -52, 0, 0)
HideHint.BackgroundTransparency = 1
HideHint.TextColor3 = Color3.fromRGB(180, 140, 255)
HideHint.TextSize = 9
HideHint.Font = Enum.Font.Gotham
HideHint.Parent = TitleBar

local ContentHolder = Instance.new("Frame")
ContentHolder.Size = UDim2.new(1, 0, 1, -TITLE_H)
ContentHolder.Position = UDim2.new(0, 0, 0, TITLE_H)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = Main

-- HAX Button
local HaxBtn = Instance.new("TextButton")
HaxBtn.Text = "HAX"
HaxBtn.Size = UDim2.new(0, 56, 0, 56)
HaxBtn.Position = UDim2.new(0, 8, 0.5, -28)
HaxBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 180)
HaxBtn.TextColor3 = Color3.new(1, 1, 1)
HaxBtn.TextSize = 12
HaxBtn.Font = Enum.Font.GothamBold
HaxBtn.BorderSizePixel = 0
HaxBtn.ZIndex = 10
HaxBtn.AutoButtonColor = false
HaxBtn.Parent = ScreenGui
Instance.new("UICorner", HaxBtn).CornerRadius = UDim.new(1, 0)
local haxStroke = Instance.new("UIStroke")
haxStroke.Color = Color3.fromRGB(180, 80, 255)
haxStroke.Thickness = 2
haxStroke.Parent = HaxBtn

-- ===== FLY DIRECTION BUTTONS (SOL TARAF) =====
_G.FlyFwd = false
_G.FlyBack = false
_G.FlyLeft = false
_G.FlyRight = false
_G.FlyUp = false
_G.FlyDown = false

local function makeDirBtn(text, x, y, key)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Size = UDim2.new(0, 42, 0, 42)
    b.Position = UDim2.new(0, x, 0.5, y)
    b.BackgroundColor3 = Color3.fromRGB(0, 90, 180)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 16
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.ZIndex = 10
    b.Visible = false
    b.AutoButtonColor = false
    b.Parent = ScreenGui
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    local st = Instance.new("UIStroke")
    st.Color = Color3.fromRGB(0, 180, 255)
    st.Thickness = 1.5
    st.Parent = b

    b.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            _G[key] = true
            TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(0, 160, 255)}):Play()
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            _G[key] = false
            TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(0, 90, 180)}):Play()
        end
    end)
    return b
end

-- Sol tarafta düzen:
--        [▲]          Up
--   [◀]  [●]  [▶]     Left / Forward / Right
--        [▼]          Down
--   [◀◀]     [▶▶]     Back (alt satır)

local flyUpBtn   = makeDirBtn("▲",  58, -90, "FlyUp")
local flyLeftBtn = makeDirBtn("◀",  12, -42, "FlyLeft")
local flyFwdBtn  = makeDirBtn("●",  58, -42, "FlyFwd")
local flyRightBtn= makeDirBtn("▶", 104, -42, "FlyRight")
local flyDownBtn = makeDirBtn("▼",  58,   6, "FlyDown")
local flyBackBtn = makeDirBtn("▼▼", 58,  54, "FlyBack")

local flyButtons = {flyUpBtn, flyLeftBtn, flyFwdBtn, flyRightBtn, flyDownBtn, flyBackBtn}

-- ===== DRAGGABLE =====
local THRESH = 10
local function makeDraggable(handle, target)
    local drag, ds, sp, moved = false, nil, nil, false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; moved = false; ds = i.Position; sp = target.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            if d.Magnitude > THRESH then
                moved = true
                target.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
            end
        end
    end)
    return function() return moved end
end

local menuMovedFn = makeDraggable(TitleBar, Main)
local haxMovedFn = makeDraggable(HaxBtn, HaxBtn)

HaxBtn.MouseButton1Click:Connect(function()
    if not haxMovedFn() then
        Main.Visible = not Main.Visible
    end
end)
TitleBar.MouseButton1Click:Connect(function()
    if not menuMovedFn() then
        contentVisible = not contentVisible
        ContentHolder.Visible = contentVisible
        Main.Size = contentVisible and UDim2.new(0, MENU_W, 0, MENU_H) or UDim2.new(0, MENU_W, 0, TITLE_H)
        HideHint.Text = contentVisible and "▼ tap" or "▲ tap"
    end
end)

-- ===== TAB SYSTEM (aynı) =====
local tabs = {"ESP", "AIMBOT", "MOVE", "COMBAT", "VISUAL", "MISC"}
local tabColors = {
    ESP = Color3.fromRGB(255, 70, 70),
    AIMBOT = Color3.fromRGB(255, 150, 0),
    MOVE = Color3.fromRGB(0, 210, 110),
    COMBAT = Color3.fromRGB(255, 50, 110),
    VISUAL = Color3.fromRGB(60, 150, 255),
    MISC = Color3.fromRGB(160, 70, 255),
}

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, TAB_H)
TabBar.BackgroundColor3 = Color3.fromRGB(14, 8, 24)
TabBar.BorderSizePixel = 0
TabBar.Parent = ContentHolder
local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = TabBar

local TabIndicator = Instance.new("Frame")
TabIndicator.Size = UDim2.new(0, MENU_W / #tabs - 2, 0, 2)
TabIndicator.Position = UDim2.new(0, 1, 1, -2)
TabIndicator.BackgroundColor3 = tabColors["ESP"]
TabIndicator.BorderSizePixel = 0
TabIndicator.Parent = TabBar
Instance.new("UICorner", TabIndicator).CornerRadius = UDim.new(1, 0)

local ScrollArea = Instance.new("ScrollingFrame")
ScrollArea.Size = UDim2.new(1, 0, 0, CONTENT_H)
ScrollArea.Position = UDim2.new(0, 0, 0, TAB_H)
ScrollArea.BackgroundTransparency = 1
ScrollArea.BorderSizePixel = 0
ScrollArea.ScrollBarThickness = 4
ScrollArea.ScrollBarImageColor3 = Color3.fromRGB(140, 0, 255)
ScrollArea.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollArea.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollArea.Parent = ContentHolder

local ItemList = Instance.new("UIListLayout")
ItemList.SortOrder = Enum.SortOrder.LayoutOrder
ItemList.Padding = UDim.new(0, 4)
ItemList.Parent = ScrollArea
local ItemPad = Instance.new("UIPadding")
ItemPad.PaddingLeft = UDim.new(0, 10)
ItemPad.PaddingRight = UDim.new(0, 10)
ItemPad.PaddingTop = UDim.new(0, 8)
ItemPad.PaddingBottom = UDim.new(0, 8)
ItemPad.Parent = ScrollArea
ItemList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollArea.CanvasSize = UDim2.new(0, 0, 0, ItemList.AbsoluteContentSize.Y + 20)
end)

local tabBtns = {}
local tabW = MENU_W / #tabs

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = tabName
    btn.Size = UDim2.new(0, tabW, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(14, 8, 24)
    btn.TextColor3 = Color3.fromRGB(120, 100, 160)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = TabBar
    tabBtns[tabName] = btn

    btn.MouseButton1Click:Connect(function()
        for n, b in pairs(tabBtns) do
            b.TextColor3 = Color3.fromRGB(120, 100, 160)
            b.BackgroundColor3 = Color3.fromRGB(14, 8, 24)
        end
        btn.TextColor3 = tabColors[tabName]
        btn.BackgroundColor3 = Color3.fromRGB(20, 12, 32)
        TweenService:Create(TabIndicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, (i - 1) * tabW + 1, 1, -2),
            BackgroundColor3 = tabColors[tabName],
        }):Play()
        ScrollArea.CanvasPosition = Vector2.zero
        for _, v in ipairs(ScrollArea:GetChildren()) do
            if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end
        end
        buildTab(tabName)
    end)
end
tabBtns["ESP"].TextColor3 = tabColors["ESP"]
tabBtns["ESP"].BackgroundColor3 = Color3.fromRGB(20, 12, 32)

-- ===== UI COMPONENTS =====
local COL_ROW = Color3.fromRGB(20, 14, 32)
local COL_ROW_H = Color3.fromRGB(28, 18, 42)
local COL_OFF = Color3.fromRGB(50, 40, 65)
local COL_TEXT = Color3.fromRGB(220, 210, 240)

local function makeToggle(label, cfgKey, color)
    color = color or Color3.fromRGB(140, 0, 255)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = COL_ROW
    row.BorderSizePixel = 0
    row.Parent = ScrollArea
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -8)
    accent.Position = UDim2.new(0, 0, 0, 4)
    accent.BackgroundColor3 = cfg[cfgKey] and color or COL_OFF
    accent.BorderSizePixel = 0
    accent.Parent = row
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new("TextLabel")
    lbl.Text = label
    lbl.Size = UDim2.new(1, -58, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = COL_TEXT
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0, 40, 0, 22)
    sw.Position = UDim2.new(1, -46, 0.5, -11)
    sw.BackgroundColor3 = cfg[cfgKey] and color or COL_OFF
    sw.BorderSizePixel = 0
    sw.Parent = row
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = cfg[cfgKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = sw
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 1, 0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = row

    local function refresh()
        TweenService:Create(sw, TweenInfo.new(0.14), {BackgroundColor3 = cfg[cfgKey] and color or COL_OFF}):Play()
        TweenService:Create(knob, TweenInfo.new(0.14), {Position = cfg[cfgKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
        TweenService:Create(accent, TweenInfo.new(0.14), {BackgroundColor3 = cfg[cfgKey] and color or COL_OFF}):Play()
        lbl.TextColor3 = cfg[cfgKey] and Color3.new(1, 1, 1) or COL_TEXT
    end

    hitbox.MouseButton1Click:Connect(function()
        cfg[cfgKey] = not cfg[cfgKey]
        refresh()
        if cfgKey == "fly" then
            for _, b in ipairs(flyButtons) do b.Visible = cfg.fly end
        end
    end)
end

local function makeSlider(label, cfgKey, min, max, suffix, isFloat)
    suffix = suffix or ""
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = COL_ROW
    row.BorderSizePixel = 0
    row.Parent = ScrollArea
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Text = label .. ":  " .. tostring(cfg[cfgKey]) .. suffix
    lbl.Size = UDim2.new(1, -12, 0, 22)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = COL_TEXT
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 8)
    track.Position = UDim2.new(0, 12, 0, 32)
    track.BackgroundColor3 = Color3.fromRGB(40, 30, 55)
    track.BorderSizePixel = 0
    track.Parent = row
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(math.clamp((cfg[cfgKey] - min) / (max - min), 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
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
            lbl.Text = label .. ":  " .. tostring(val) .. suffix
        end
    end)
end

local function makeSection(text)
    local lbl = Instance.new("TextLabel")
    lbl.Text = "— " .. text .. " —"
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(160, 80, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = ScrollArea
end

function buildTab(tab)
    if tab == "ESP" then
        makeSection("ESP")
        makeToggle("Enable ESP", "esp", Color3.fromRGB(255, 70, 70))
        makeToggle("ESP V2 (Canlı/Parlak)", "esp_v2", Color3.fromRGB(0, 255, 180))
        makeToggle("Box", "esp_box")
        makeToggle("Skeleton", "esp_skeleton")
        makeToggle("Health Bar", "esp_health")
        makeToggle("Distance", "esp_distance")
        makeToggle("Tracers", "esp_tracer")
        makeToggle("Names", "esp_name")
        makeToggle("Team Check", "esp_teamcheck")
        makeToggle("ESP Rainbow", "esp_rainbow", Color3.fromRGB(255, 100, 255))
    elseif tab == "AIMBOT" then
        makeSection("Aimbot")
        makeToggle("Aimbot", "aimbot", Color3.fromRGB(255, 150, 0))
        makeToggle("Silent Aim", "silent_aim", Color3.fromRGB(255, 100, 0))
        makeToggle("Aimkill", "aimkill", Color3.fromRGB(255, 40, 40))
        makeToggle("Vis Check", "aimbot_vischeck")
        makeToggle("Team Check", "aimbot_teamcheck")
        makeSlider("FOV", "aimbot_fov", 40, 400, " px")
        makeSlider("Smooth", "aimbot_smooth", 0.03, 0.40, "", true)
        makeSlider("Silent FOV", "silent_fov", 40, 400, " px")
    elseif tab == "MOVE" then
        makeSection("Movement")
        makeToggle("Noclip", "noclip", Color3.fromRGB(0, 210, 110))
        makeToggle("Fly", "fly", Color3.fromRGB(0, 180, 255))
        makeToggle("Infinite Jump", "inf_jump")
        makeToggle("Bunny Hop", "bunnyhop")
        makeToggle("Speed Hack", "speed")
        makeSlider("Walk Speed", "speed_value", 16, 200, " ws")
        makeSlider("Fly Speed", "fly_speed", 20, 180, " ws")
    elseif tab == "COMBAT" then
        makeSection("Combat")
        makeToggle("Auto Fire", "auto_fire", Color3.fromRGB(255, 50, 110))
        makeToggle("Rapid Fire", "rapid_fire")
        makeSlider("Rapid Delay", "rapid_fire_delay", 0.02, 0.30, " s", true)
        makeToggle("Kill Aura", "kill_aura", Color3.fromRGB(255, 30, 30))
        makeSlider("Kill Aura Range", "kill_aura_range", 5, 60, " studs")
        makeToggle("Hitbox Expand", "hitbox_expand")
        makeSlider("Hitbox Size", "hitbox_size", 4, 25, " studs")
        makeToggle("Reach", "reach")
        makeSlider("Reach Range", "reach_range", 5, 40, " studs")
        makeToggle("Wallbang", "wallbang")
    elseif tab == "VISUAL" then
        makeSection("Crosshair")
        makeToggle("Crosshair", "crosshair")
        makeToggle("Crosshair Spin", "crosshair_spin")
        makeToggle("Crosshair Rainbow", "crosshair_rainbow")
        makeSlider("CH Size", "crosshair_size", 4, 30, " px")
        makeSlider("CH Gap", "crosshair_gap", 0, 15, " px")
        makeSection("FOV / World")
        makeToggle("FOV Circle", "fov_circle")
        makeToggle("FullBright", "fullbright")
        makeToggle("No Fog", "no_fog")
        makeToggle("Radar", "radar")
    elseif tab == "MISC" then
        makeSection("Misc")
        makeToggle("AC Bypass", "ac_bypass")
        makeToggle("Spectator List", "spectator_list")
        makeToggle("Anti Aim", "anti_aim")
        makeToggle("Auto Item Switch", "auto_item")
    end
end

buildTab("ESP")

-- ===== DRAWING OBJECTS =====
local function newD(class, props)
    local d = Drawing.new(class)
    for k, v in pairs(props or {}) do
        d[k] = v
    end
    return d
end

local fovCircle = newD("Circle", {Visible = false, Thickness = 1.5, Filled = false, NumSides = 64})
local ch = {
    top = newD("Line", {Visible = false}),
    bot = newD("Line", {Visible = false}),
    left = newD("Line", {Visible = false}),
    right = newD("Line", {Visible = false}),
    dot = newD("Circle", {Visible = false, Filled = true, NumSides = 16}),
}

local crosshairAngle = 0

-- ===== ESP SYSTEM (temizlik düzeltildi) =====
local espObjects = {}
local trackedEntities = {}

local skelConn = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
}

local function hideAll(o)
    if not o then return end
    pcall(function()
        o.box.Visible = false
        o.name.Visible = false
        o.dist.Visible = false
        o.hbBg.Visible = false
        o.hbFill.Visible = false
        o.tracer.Visible = false
        o.chams.Visible = false
        for _, l in ipairs(o.skel) do l.Visible = false end
    end)
end

local function cleanESP(key)
    local o = espObjects[key]
    if not o then return end
    hideAll(o)
    pcall(function()
        o.box:Remove()
        o.name:Remove()
        o.dist:Remove()
        o.hbBg:Remove()
        o.hbFill:Remove()
        o.tracer:Remove()
        o.chams:Remove()
        for _, l in ipairs(o.skel) do l:Remove() end
    end)
    espObjects[key] = nil
    trackedEntities[key] = nil
end

local function setupESP(player)
    if player == lp then return end
    cleanESP(player)

    local o = {}
    o.box = newD("Square", {Visible = false, Thickness = 1.6, Filled = false})
    o.name = newD("Text", {Visible = false, Size = 13, Center = true, Outline = true})
    o.dist = newD("Text", {Visible = false, Size = 11, Center = true, Outline = true})
    o.hbBg = newD("Square", {Visible = false, Filled = true, Color = Color3.fromRGB(30, 30, 30)})
    o.hbFill = newD("Square", {Visible = false, Filled = true})
    o.tracer = newD("Line", {Visible = false, Thickness = 1.3})
    o.chams = newD("Square", {Visible = false, Filled = true, Transparency = 0.5})
    o.skel = {}
    for i = 1, #skelConn do
        o.skel[i] = newD("Line", {Visible = false, Thickness = 1.5})
    end
    espObjects[player] = o
    trackedEntities[player] = {isPlayer = true, player = player, model = player.Character}
end

-- Oyuncu ekle / karakter yenile / çıkınca temizle
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        setupESP(p)
        trackedEntities[p] = {isPlayer = true, player = p, model = char, humanoid = char:FindFirstChildOfClass("Humanoid")}
    end)
    p.CharacterRemoving:Connect(function()
        cleanESP(p)
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    cleanESP(p)
end)

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= lp then
        if p.Character then
            setupESP(p)
            trackedEntities[p] = {
                isPlayer = true,
                player = p,
                model = p.Character,
                humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            }
        end
        p.CharacterAdded:Connect(function(char)
            task.wait(0.3)
            setupESP(p)
            trackedEntities[p] = {isPlayer = true, player = p, model = char, humanoid = char:FindFirstChildOfClass("Humanoid")}
        end)
        p.CharacterRemoving:Connect(function()
            cleanESP(p)
        end)
    end
end

-- ===== AIM TARGET =====
local function getAimTarget(fovLimit, ignoreVis)
    local best = fovLimit or cfg.aimbot_fov
    local target = nil
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in ipairs(Players:GetPlayers()) do
        if p == lp then continue end
        if cfg.aimbot_teamcheck and getTeam(p) == getTeam(lp) then continue end
        local char = p.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not head or not hum or hum.Health <= 0 then continue end

        if cfg.aimbot_vischeck and not ignoreVis then
            local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000)
            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {lp.Character, Camera})
            if hit and not hit:IsDescendantOf(char) then continue end
        end

        local vp, inView = Camera:WorldToViewportPoint(head.Position)
        if not inView then continue end
        local d = (Vector2.new(vp.X, vp.Y) - mousePos).Magnitude
        if d < best then
            best = d
            target = head
        end
    end
    return target
end

-- ===== FIRE =====
local function fireOnce()
    pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.015)
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end)
    pcall(function()
        local char = lp.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end)
end

-- ===== SILENT AIM =====
pcall(function()
    if hookmetamethod then
        local oi
        oi = hookmetamethod(game, "__index", function(self, key)
            local cc = false
            pcall(function() cc = checkcaller() end)
            if not cc and key == "Hit" and self == mouse and cfg.silent_aim then
                local t = getAimTarget(cfg.silent_fov)
                if t then return CFrame.new(t.Position) end
            end
            return oi(self, key)
        end)
    end
end)

-- ===== MAIN LOOPS =====
local lastFire = 0
local lastItem = 0
local itemIdx = 1
local antiAimAngle = 0
local rainbowT = 0

RunService.RenderStepped:Connect(function(dt)
    lc = lp.Character
    if not lc then return end
    local hum = lc:FindFirstChildOfClass("Humanoid")
    local hrp = lc:FindFirstChild("HumanoidRootPart")
    local vpSize = Camera.ViewportSize
    local vpc = Vector2.new(vpSize.X / 2, vpSize.Y / 2)

    rainbowT = rainbowT + dt

    -- Speed
    if hum then
        hum.WalkSpeed = cfg.speed and cfg.speed_value or 16
    end

    -- Fullbright / NoFog
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

    -- Anti Aim
    if cfg.anti_aim and hrp then
        antiAimAngle = (antiAimAngle + 18) % 360
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(antiAimAngle), 0)
    end

    -- Aimbot
    if cfg.aimbot then
        local t = getAimTarget(cfg.aimbot_fov)
        if t then
            local targetCF = CFrame.new(Camera.CFrame.Position, t.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, cfg.aimbot_smooth)
        end
    end

    -- Aimkill
    if cfg.aimkill then
        local t = getAimTarget(cfg.aimbot_fov)
        if t then
            local model = t.Parent
            if model then
                local h = model:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then
                    pcall(function() h:TakeDamage(h.MaxHealth) end)
                    pcall(function()
                        local tool = lc:FindFirstChildOfClass("Tool")
                        if tool then
                            for _, v in ipairs(tool:GetDescendants()) do
                                if v:IsA("RemoteEvent") then
                                    v:FireServer(t.Position, t)
                                    break
                                end
                            end
                        end
                    end)
                end
            end
        end
    end

    -- Hitbox
    if cfg.hitbox_expand then
        for key, ent in pairs(trackedEntities) do
            if ent.isPlayer and ent.player == lp then continue end
            local model = ent.model
            if not model or not model.Parent then continue end
            local head = model:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                local cf = head.CFrame
                head.Size = Vector3.new(cfg.hitbox_size, cfg.hitbox_size, cfg.hitbox_size)
                head.CFrame = cf
                head.Transparency = 0.5
                head.CanCollide = false
            end
        end
    end

    -- FOV Circle
    local currentEspColor = cfg.esp_rainbow and rainbowColor(rainbowT) or cfg.esp_color
    fovCircle.Visible = cfg.fov_circle
    if cfg.fov_circle then
        fovCircle.Position = vpc
        fovCircle.Radius = cfg.aimbot_fov
        fovCircle.Color = cfg.esp_rainbow and currentEspColor or cfg.fov_color
    end

    -- Crosshair + Spin + Rainbow
    local chColor = cfg.crosshair_rainbow and rainbowColor(rainbowT * 1.3) or cfg.crosshair_color
    if cfg.crosshair then
        if cfg.crosshair_spin then
            crosshairAngle = crosshairAngle + dt * 4
        end
        local cs = cfg.crosshair_size
        local cg = cfg.crosshair_gap
        local ct = cfg.crosshair_thickness
        local ang = crosshairAngle

        local function rot(x, y, a)
            local c, s = math.cos(a), math.sin(a)
            return x * c - y * s, x * s + y * c
        end

        local function setLine(line, x1, y1, x2, y2)
            local rx1, ry1 = rot(x1, y1, ang)
            local rx2, ry2 = rot(x2, y2, ang)
            line.From = Vector2.new(vpc.X + rx1, vpc.Y + ry1)
            line.To = Vector2.new(vpc.X + rx2, vpc.Y + ry2)
            line.Color = chColor
            line.Thickness = ct
            line.Visible = true
        end

        setLine(ch.top, 0, -cg, 0, -cg - cs)
        setLine(ch.bot, 0, cg, 0, cg + cs)
        setLine(ch.left, -cg, 0, -cg - cs, 0)
        setLine(ch.right, cg, 0, cg + cs, 0)

        ch.dot.Visible = cfg.crosshair_dot
        ch.dot.Position = vpc
        ch.dot.Color = chColor
        ch.dot.Radius = ct + 1
    else
        for _, v in pairs(ch) do v.Visible = false end
    end

    -- ESP Loop (ölü / çıkan temizlenir)
    for key, o in pairs(espObjects) do
        local ent = trackedEntities[key]
        local model, humanoid, player

        if ent then
            model = ent.model
            humanoid = ent.humanoid or (model and model:FindFirstChildOfClass("Humanoid"))
            player = ent.player
        end

        -- Model yok veya ölü → temizle
        if not model or not model.Parent or not humanoid or humanoid.Health <= 0 then
            hideAll(o)
            if not model or not model.Parent then
                cleanESP(key)
            end
            continue
        end

        if not cfg.esp then
            hideAll(o)
            continue
        end

        local hrpP = model:FindFirstChild("HumanoidRootPart")
        local head = model:FindFirstChild("Head")
        if not hrpP or not head then
            hideAll(o)
            continue
        end

        local isE = true
        if player and cfg.esp_teamcheck then
            isE = getTeam(player) ~= getTeam(lp)
        end

        local col = cfg.esp_rainbow and currentEspColor or (isE and cfg.esp_color or cfg.esp_friendly_color)

        -- ESP V2 = daha kalın + parlak + hafif glow hissi
        local thick = cfg.esp_v2 and 2.4 or 1.5
        local nameSize = cfg.esp_v2 and 15 or 13

        local hVP, _, hZ = w2v(head.Position + Vector3.new(0, 0.5, 0))
        local fVP = w2v(hrpP.Position - Vector3.new(0, 2.5, 0))
        local distVal = math.floor((Camera.CFrame.Position - hrpP.Position).Magnitude)

        if hZ <= 0 then
            hideAll(o)
            continue
        end

        local bH = math.abs(hVP.Y - fVP.Y)
        local bW = bH * 0.55
        local bX = hVP.X - bW / 2
        local bY = hVP.Y

        pcall(function()
            o.box.Visible = cfg.esp_box
            o.box.Position = Vector2.new(bX, bY)
            o.box.Size = Vector2.new(bW, bH)
            o.box.Color = col
            o.box.Thickness = thick

            o.name.Visible = cfg.esp_name
            o.name.Position = Vector2.new(hVP.X, hVP.Y - 16)
            o.name.Text = player and player.Name or model.Name
            o.name.Color = cfg.esp_v2 and Color3.new(1, 1, 1) or col
            o.name.Size = nameSize
            o.name.Outline = true

            o.dist.Visible = cfg.esp_distance
            o.dist.Position = Vector2.new(hVP.X, fVP.Y + 3)
            o.dist.Text = distVal .. "m"
            o.dist.Color = Color3.fromRGB(220, 220, 220)

            local hp = humanoid.Health
            local maxhp = humanoid.MaxHealth
            local hpr = math.clamp(hp / maxhp, 0, 1)
            o.hbBg.Visible = cfg.esp_health
            o.hbBg.Position = Vector2.new(bX - 7, bY)
            o.hbBg.Size = Vector2.new(cfg.esp_v2 and 5 or 4, bH)
            o.hbFill.Visible = cfg.esp_health
            o.hbFill.Position = Vector2.new(bX - 7, bY + bH * (1 - hpr))
            o.hbFill.Size = Vector2.new(cfg.esp_v2 and 5 or 4, bH * hpr)
            o.hbFill.Color = Color3.fromRGB(0, 255, 80):Lerp(Color3.fromRGB(255, 40, 40), 1 - hpr)

            o.tracer.Visible = cfg.esp_tracer
            o.tracer.From = Vector2.new(vpc.X, vpSize.Y)
            o.tracer.To = Vector2.new(hVP.X, hVP.Y)
            o.tracer.Color = col
            o.tracer.Thickness = cfg.esp_v2 and 1.8 or 1.2
        end)

        if cfg.esp_skeleton then
            for i, conn in ipairs(skelConn) do
                pcall(function()
                    local line = o.skel[i]
                    local p1 = model:FindFirstChild(conn[1])
                    local p2 = model:FindFirstChild(conn[2])
                    if p1 and p2 then
                        local s1, v1 = w2v(p1.Position)
                        local s2, v2 = w2v(p2.Position)
                        line.Visible = v1 and v2
                        line.From = s1
                        line.To = s2
                        line.Color = col
                        line.Thickness = cfg.esp_v2 and 2 or 1.4
                    else
                        line.Visible = false
                    end
                end)
            end
        else
            for _, l in ipairs(o.skel) do
                l.Visible = false
            end
        end
    end

    -- Fly buttons visibility
    for _, b in ipairs(flyButtons) do
        b.Visible = cfg.fly
    end
end)

-- HEARTBEAT
RunService.Heartbeat:Connect(function()
    lc = lp.Character
    if not lc then return end
    local hrp = lc:FindFirstChild("HumanoidRootPart")
    local hum = lc:FindFirstChildOfClass("Humanoid")
    local now = tick()

    -- Noclip
    if cfg.noclip then
        for _, p in ipairs(lc:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    -- Fly + Direction Buttons
    if cfg.fly and hrp then
        local bv = hrp:FindFirstChild("FlyBV") or Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyBV"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)

        local dir = Vector3.zero
        if _G.FlyFwd then dir = dir + Camera.CFrame.LookVector end
        if _G.FlyBack then dir = dir - Camera.CFrame.LookVector end
        if _G.FlyLeft then dir = dir - Camera.CFrame.RightVector end
        if _G.FlyRight then dir = dir + Camera.CFrame.RightVector end
        if _G.FlyUp then dir = dir + Vector3.new(0, 1, 0) end
        if _G.FlyDown then dir = dir - Vector3.new(0, 1, 0) end

        -- Klavye desteği
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end

        bv.Velocity = dir.Magnitude > 0 and dir.Unit * cfg.fly_speed or Vector3.zero
    else
        if hrp then
            local bv = hrp:FindFirstChild("FlyBV")
            if bv then bv:Destroy() end
        end
    end

    -- Bunnyhop
    if cfg.bunnyhop and hum and hum.FloorMaterial ~= Enum.Material.Air then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    -- Auto / Rapid Fire
    if cfg.auto_fire and not cfg.rapid_fire then
        local t = getAimTarget(cfg.aimbot_fov)
        if t and now - lastFire >= 0.1 then
            fireOnce()
            lastFire = now
        end
    end
    if cfg.rapid_fire then
        if now - lastFire >= math.max(cfg.rapid_fire_delay, 0.016) then
            fireOnce()
            lastFire = now
        end
    end

    -- ===== KILL AURA FIX =====
    if cfg.kill_aura and hrp then
        for key, ent in pairs(trackedEntities) do
            if ent.isPlayer and ent.player == lp then continue end
            if ent.isPlayer and cfg.aimbot_teamcheck and getTeam(ent.player) == getTeam(lp) then continue end

            local model = ent.model
            if not model or not model.Parent then continue end
            local ehrp = model:FindFirstChild("HumanoidRootPart")
            local h = model:FindFirstChildOfClass("Humanoid")
            if not ehrp or not h or h.Health <= 0 then continue end

            local dist = (hrp.Position - ehrp.Position).Magnitude
            if dist <= cfg.kill_aura_range then
                -- Hasar dene
                pcall(function() h:TakeDamage(h.MaxHealth) end)
                pcall(function() h.Health = 0 end)

                -- Tool remote ile vur
                pcall(function()
                    local tool = lc:FindFirstChildOfClass("Tool")
                    if tool then
                        for _, v in ipairs(tool:GetDescendants()) do
                            if v:IsA("RemoteEvent") then
                                v:FireServer(ehrp.Position, ehrp)
                                break
                            end
                        end
                        tool:Activate()
                    end
                end)
            end
        end
    end

    -- Reach
    if cfg.reach then
        pcall(function()
            local tool = lc:FindFirstChildOfClass("Tool")
            if not tool then return end
            local t = getAimTarget(cfg.aimbot_fov)
            if t then
                local dist = (Camera.CFrame.Position - t.Position).Magnitude
                if dist <= cfg.reach_range then
                    for _, v in ipairs(tool:GetDescendants()) do
                        if v:IsA("RemoteEvent") then
                            v:FireServer(t.Position, t)
                            break
                        end
                    end
                end
            end
        end)
    end

    -- Auto Item
    if cfg.auto_item and hum then
        if now - lastItem >= cfg.auto_item_delay then
            local backpack = lp:FindFirstChild("Backpack")
            local items = {}
            if lc then
                for _, v in ipairs(lc:GetChildren()) do
                    if v:IsA("Tool") then table.insert(items, v) end
                end
            end
            if backpack then
                for _, v in ipairs(backpack:GetChildren()) do
                    if v:IsA("Tool") then table.insert(items, v) end
                end
            end
            if #items > 0 then
                itemIdx = (itemIdx % #items) + 1
                local tool = items[itemIdx]
                if tool then
                    if tool.Parent == backpack then
                        hum:EquipTool(tool)
                    else
                        hum:UnequipTools()
                    end
                end
            end
            lastItem = now
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

-- AC Bypass
if cfg.ac_bypass then
    pcall(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Script") or v:IsA("LocalScript") then
                local n = v.Name:lower()
                if n:find("anti") or n:find("cheat") or n:find("detect") then
                    v.Disabled = true
                end
            end
        end
    end)
end

print("========================================")
print("  AnonymousH4X v5.1")
print("  ESP V2 + Fly Buttons + KillAura Fix")
print("  Crosshair Spin/Rainbow + ESP Rainbow")
print("  HAX = menü")
print("========================================")

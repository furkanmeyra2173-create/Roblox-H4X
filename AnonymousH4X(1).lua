-- AnonymousH4X | Delta Executor Script
-- Mobile compatible, draggable UI

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
    esp = true, esp_box = true, esp_skeleton = true, esp_health = true,
    esp_distance = true, esp_tracer = true, esp_name = true,
    esp_teamcheck = true, esp_chams = true,
    esp_color = Color3.fromRGB(255, 50, 50),
    esp_friendly_color = Color3.fromRGB(0, 200, 255),
    aimbot = false, aimbot_key = Enum.KeyCode.Q, aimbot_fov = 150,
    aimbot_smooth = 0.25, aimbot_bone = "Head",
    aimbot_teamcheck = true, aimbot_vischeck = true,
    silent_aim = false, silent_fov = 200, aimkill = false,
    noclip = false, fly = false, fly_speed = 50,
    inf_jump = false, speed = false, speed_value = 32,
    auto_fire = false, hitbox_expand = false, hitbox_size = 5,
    fullbright = false, no_fog = false, ac_bypass = true,
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnonymousH4X"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
local ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ok then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 520, 0, 420)
Main.Position = UDim2.new(0.5, -260, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(10,10,20)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20,10,30))})
grad.Rotation = 135
grad.Parent = Main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(180, 0, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = Main

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "AnonymousH4X"
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(220, 100, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local SubLabel = Instance.new("TextLabel")
SubLabel.Text = "v2.0 | Premium"
SubLabel.Size = UDim2.new(0, 100, 0, 15)
SubLabel.Position = UDim2.new(0, 15, 0, 25)
SubLabel.BackgroundTransparency = 1
SubLabel.TextColor3 = Color3.fromRGB(150, 80, 200)
SubLabel.TextSize = 10
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 60)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local tabs = {"ESP","AIMBOT","MOVEMENT","COMBAT","VISUAL","MISC"}
local tabColors = {
    ESP=Color3.fromRGB(255,80,80), AIMBOT=Color3.fromRGB(255,160,0),
    MOVEMENT=Color3.fromRGB(0,220,120), COMBAT=Color3.fromRGB(255,60,120),
    VISUAL=Color3.fromRGB(80,160,255), MISC=Color3.fromRGB(180,80,255),
}

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 36)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
TabBar.BorderSizePixel = 0
TabBar.Parent = Main
local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 2)
TabLayout.Parent = TabBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -76)
ContentFrame.Position = UDim2.new(0, 0, 0, 76)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Main

local tabFrames = {}
local tabBtns = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = tabName
    btn.Size = UDim2.new(0, 82, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(18, 10, 28)
    btn.TextColor3 = Color3.fromRGB(160, 120, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.Parent = TabBar
    tabBtns[tabName] = btn

    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 3
    frame.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 255)
    frame.Visible = tabName == "ESP"
    frame.Parent = ContentFrame
    tabFrames[tabName] = frame

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = frame
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 8)
    pad.Parent = frame

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabFrames) do f.Visible = false end
        for n, b in pairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(18,10,28)
            b.TextColor3 = Color3.fromRGB(160,120,200)
        end
        frame.Visible = true
        btn.BackgroundColor3 = tabColors[tabName]
        btn.TextColor3 = Color3.new(1,1,1)
    end)
end
tabBtns["ESP"].BackgroundColor3 = tabColors["ESP"]
tabBtns["ESP"].TextColor3 = Color3.new(1,1,1)

local function makeToggle(parent, label, cfgKey, color)
    color = color or Color3.fromRGB(180, 0, 255)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 34)
    row.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel")
    lbl.Text = label
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(220, 200, 240)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 40, 0, 20)
    toggleBg.Position = UDim2.new(1, -48, 0.5, -10)
    toggleBg.BackgroundColor3 = cfg[cfgKey] and color or Color3.fromRGB(50,40,60)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = row
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = cfg[cfgKey] and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local btn2 = Instance.new("TextButton")
    btn2.Size = UDim2.new(1, 0, 1, 0)
    btn2.BackgroundTransparency = 1
    btn2.Text = ""
    btn2.Parent = row
    btn2.MouseButton1Click:Connect(function()
        cfg[cfgKey] = not cfg[cfgKey]
        TweenService:Create(toggleBg, TweenInfo.new(0.15), {BackgroundColor3 = cfg[cfgKey] and color or Color3.fromRGB(50,40,60)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = cfg[cfgKey] and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
    end)
end

local function makeSlider(parent, label, cfgKey, min, max, suffix)
    suffix = suffix or ""
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 50)
    row.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local lbl2 = Instance.new("TextLabel")
    lbl2.Text = label..": "..tostring(cfg[cfgKey])..suffix
    lbl2.Size = UDim2.new(1, -10, 0, 20)
    lbl2.Position = UDim2.new(0, 10, 0, 4)
    lbl2.BackgroundTransparency = 1
    lbl2.TextColor3 = Color3.fromRGB(220, 200, 240)
    lbl2.Font = Enum.Font.Gotham
    lbl2.TextSize = 11
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.Parent = row
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 0, 32)
    track.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
    track.BorderSizePixel = 0
    track.Parent = row
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((cfg[cfgKey]-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local dragging2 = false
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging2 = true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging2 = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging2 and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local relX = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + relX*(max-min))
            cfg[cfgKey] = val
            fill.Size = UDim2.new(relX, 0, 1, 0)
            lbl2.Text = label..": "..tostring(val)..suffix
        end
    end)
end

local function makeSectionLabel(parent, text)
    local lbl3 = Instance.new("TextLabel")
    lbl3.Text = "-- "..text.." --"
    lbl3.Size = UDim2.new(1, -10, 0, 22)
    lbl3.BackgroundTransparency = 1
    lbl3.TextColor3 = Color3.fromRGB(180, 100, 255)
    lbl3.Font = Enum.Font.GothamBold
    lbl3.TextSize = 11
    lbl3.TextXAlignment = Enum.TextXAlignment.Left
    lbl3.Parent = parent
end

local espFrame = tabFrames["ESP"]
makeSectionLabel(espFrame, "ESP Settings")
makeToggle(espFrame, "Enable ESP", "esp", Color3.fromRGB(255,80,80))
makeToggle(espFrame, "Box ESP", "esp_box")
makeToggle(espFrame, "Skeleton", "esp_skeleton")
makeToggle(espFrame, "Health Bar", "esp_health")
makeToggle(espFrame, "Distance", "esp_distance")
makeToggle(espFrame, "Tracers", "esp_tracer")
makeToggle(espFrame, "Name ESP", "esp_name")
makeToggle(espFrame, "Team Check", "esp_teamcheck")
makeToggle(espFrame, "Chams", "esp_chams")

local aimbotFrame = tabFrames["AIMBOT"]
makeSectionLabel(aimbotFrame, "Aimbot")
makeToggle(aimbotFrame, "Aimbot (Hold Q)", "aimbot", Color3.fromRGB(255,160,0))
makeToggle(aimbotFrame, "Silent Aim", "silent_aim", Color3.fromRGB(255,100,0))
makeToggle(aimbotFrame, "Aimkill", "aimkill", Color3.fromRGB(255,30,30))
makeToggle(aimbotFrame, "Visibility Check", "aimbot_vischeck")
makeToggle(aimbotFrame, "Team Check", "aimbot_teamcheck")
makeSlider(aimbotFrame, "FOV", "aimbot_fov", 10, 500, " px")

local moveFrame = tabFrames["MOVEMENT"]
makeSectionLabel(moveFrame, "Movement")
makeToggle(moveFrame, "Noclip", "noclip", Color3.fromRGB(0,220,120))
makeToggle(moveFrame, "Fly", "fly", Color3.fromRGB(0,180,255))
makeToggle(moveFrame, "Infinite Jump", "inf_jump", Color3.fromRGB(0,220,120))
makeToggle(moveFrame, "Speed Hack", "speed", Color3.fromRGB(0,220,120))
makeSlider(moveFrame, "Walk Speed", "speed_value", 16, 200, " ws")
makeSlider(moveFrame, "Fly Speed", "fly_speed", 10, 300, " ws")

local combatFrame = tabFrames["COMBAT"]
makeSectionLabel(combatFrame, "Combat")
makeToggle(combatFrame, "Auto Fire", "auto_fire", Color3.fromRGB(255,60,120))
makeToggle(combatFrame, "Hitbox Expand", "hitbox_expand", Color3.fromRGB(255,60,120))
makeSlider(combatFrame, "Hitbox Size", "hitbox_size", 1, 20, " studs")

local visualFrame = tabFrames["VISUAL"]
makeSectionLabel(visualFrame, "Visual")
makeToggle(visualFrame, "FullBright", "fullbright", Color3.fromRGB(80,160,255))
makeToggle(visualFrame, "No Fog", "no_fog", Color3.fromRGB(80,160,255))

local miscFrame = tabFrames["MISC"]
makeSectionLabel(miscFrame, "Misc")
makeToggle(miscFrame, "AC Bypass", "ac_bypass", Color3.fromRGB(180,80,255))

for _, f in pairs(tabFrames) do
    local layout = f:FindFirstChildOfClass("UIListLayout")
    if layout then
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            f.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        end)
    end
end

local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = inp.Position; startPos = Main.Position
    end
end)
TitleBar.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local delta = inp.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
end)

local MobileBtn = Instance.new("TextButton")
MobileBtn.Text = "HAX"
MobileBtn.Size = UDim2.new(0, 50, 0, 50)
MobileBtn.Position = UDim2.new(0, 10, 0.5, -25)
MobileBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
MobileBtn.TextColor3 = Color3.new(1,1,1)
MobileBtn.TextSize = 11
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.BorderSizePixel = 0
MobileBtn.Parent = ScreenGui
Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(1, 0)
MobileBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local espObjects = {}
local function getTeam(player) return player.Team end
local function worldToViewport(pos)
    local vp, inView = Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X, vp.Y), inView, vp.Z
end
local function getCharParts(char)
    local parts = {}
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then parts[v.Name] = v end
    end
    return parts
end
local skeletonConnections = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
}
local function cleanESP(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            if typeof(obj) == "Instance" then obj:Remove()
            elseif type(obj) == "table" then for _, o in pairs(obj) do if typeof(o) == "Instance" then o:Remove() end end end
        end
        espObjects[player] = nil
    end
end
local function setupESP(player)
    if player == lp then return end
    cleanESP(player)
    local objs = {}
    local box = Drawing.new("Square"); box.Visible=false; box.Thickness=1.5; box.Filled=false; objs.box=box
    local name = Drawing.new("Text"); name.Visible=false; name.Size=13; name.Center=true; name.Font=Drawing.Fonts.UI; objs.name=name
    local dist = Drawing.new("Text"); dist.Visible=false; dist.Size=11; dist.Center=true; dist.Font=Drawing.Fonts.UI; objs.dist=dist
    local hbBg = Drawing.new("Square"); hbBg.Visible=false; hbBg.Filled=true; hbBg.Color=Color3.fromRGB(30,30,30); objs.hbBg=hbBg
    local hbFill = Drawing.new("Square"); hbFill.Visible=false; hbFill.Filled=true; objs.hbFill=hbFill
    local tracer = Drawing.new("Line"); tracer.Visible=false; tracer.Thickness=1; objs.tracer=tracer
    local skelLines = {}
    for i=1,#skeletonConnections do local line=Drawing.new("Line"); line.Visible=false; line.Thickness=1; skelLines[i]=line end
    objs.skel = skelLines
    espObjects[player] = objs
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(0.5); setupESP(p) end)
    if p.Character then setupESP(p) end
end)
Players.PlayerRemoving:Connect(cleanESP)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= lp then
        if p.Character then setupESP(p) end
        p.CharacterAdded:Connect(function() task.wait(0.5); setupESP(p) end)
    end
end

local function getAimTarget(fovLimit)
    local bestDist = fovLimit
    local target = nil
    local vpCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p == lp then continue end
        if cfg.aimbot_teamcheck and getTeam(p) == getTeam(lp) then continue end
        local char = p.Character; if not char then continue end
        local head = char:FindFirstChild(cfg.aimbot_bone) or char:FindFirstChild("Head"); if not head then continue end
        if cfg.aimbot_vischeck then
            local ray = Ray.new(Camera.CFrame.Position, (head.Position-Camera.CFrame.Position).Unit*1000)
            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {lc, Camera})
            if hit and not hit:IsDescendantOf(char) then continue end
        end
        local vp, inView = worldToViewport(head.Position); if not inView then continue end
        local d = (vp-vpCenter).Magnitude
        if d < bestDist then bestDist=d; target=head end
    end
    return target
end

local function applyHitbox(player)
    local char = player.Character; if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Size = Vector3.new(cfg.hitbox_size, cfg.hitbox_size, cfg.hitbox_size)
        end
    end
end

RunService.RenderStepped:Connect(function()
    lc = lp.Character; if not lc then return end
    local hum = lc:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = cfg.speed and cfg.speed_value or 16 end
    if cfg.fullbright then
        Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.FogEnd=100000
        Lighting.GlobalShadows=false; Lighting.Ambient=Color3.new(1,1,1); Lighting.OutdoorAmbient=Color3.new(1,1,1)
    end
    if cfg.no_fog then Lighting.FogEnd=100000; Lighting.FogStart=100000 end
    if cfg.aimbot and UserInputService:IsKeyDown(cfg.aimbot_key) then
        local target = getAimTarget(cfg.aimbot_fov)
        if target then
            local vp = worldToViewport(target.Position)
            local vpCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            local delta = vp - vpCenter
            pcall(function() mousemoverel(delta.X*cfg.aimbot_smooth, delta.Y*cfg.aimbot_smooth) end)
        end
    end
    if cfg.hitbox_expand then
        for _, p in ipairs(Players:GetPlayers()) do if p ~= lp then applyHitbox(p) end end
    end
    local vpSize = Camera.ViewportSize
    local vpCenter = Vector2.new(vpSize.X/2, vpSize.Y/2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player == lp then continue end
        local objs = espObjects[player]; if not objs then continue end
        local char = player.Character
        local vis = cfg.esp and char ~= nil
        if not vis then
            for k, obj in pairs(objs) do
                if typeof(obj)=="Instance" then obj.Visible=false
                elseif type(obj)=="table" then for _,o in pairs(obj) do o.Visible=false end end
            end
            continue
        end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrpPart = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not hrpPart or not head then continue end
        local isEnemy = not cfg.esp_teamcheck or getTeam(player) ~= getTeam(lp)
        local espCol = isEnemy and cfg.esp_color or cfg.esp_friendly_color
        local headVP, headVis, headZ = worldToViewport(head.Position+Vector3.new(0,0.5,0))
        local feetVP = worldToViewport(hrpPart.Position-Vector3.new(0,2.5,0))
        local distance = math.floor((Camera.CFrame.Position-hrpPart.Position).Magnitude)
        if headZ <= 0 then
            for k, obj in pairs(objs) do
                if typeof(obj)=="Instance" then obj.Visible=false
                elseif type(obj)=="table" then for _,o in pairs(obj) do o.Visible=false end end
            end
            continue
        end
        local boxH = math.abs(headVP.Y-feetVP.Y)
        local boxW = boxH*0.55
        local boxX = headVP.X-boxW/2
        local boxY = headVP.Y
        objs.box.Visible=cfg.esp_box; objs.box.Position=Vector2.new(boxX,boxY); objs.box.Size=Vector2.new(boxW,boxH); objs.box.Color=espCol
        objs.name.Visible=cfg.esp_name; objs.name.Position=Vector2.new(headVP.X,headVP.Y-15); objs.name.Text=player.Name; objs.name.Color=espCol
        objs.dist.Visible=cfg.esp_distance; objs.dist.Position=Vector2.new(headVP.X,feetVP.Y+2); objs.dist.Text=distance.."m"; objs.dist.Color=Color3.fromRGB(220,220,220)
        local hp = humanoid and humanoid.Health or 100
        local maxhp = humanoid and humanoid.MaxHealth or 100
        local hpRatio = math.clamp(hp/maxhp,0,1)
        objs.hbBg.Visible=cfg.esp_health; objs.hbBg.Position=Vector2.new(boxX-7,boxY); objs.hbBg.Size=Vector2.new(4,boxH)
        objs.hbFill.Visible=cfg.esp_health; objs.hbFill.Position=Vector2.new(boxX-7,boxY+boxH*(1-hpRatio)); objs.hbFill.Size=Vector2.new(4,boxH*hpRatio)
        objs.hbFill.Color=Color3.fromRGB(math.floor(255*(1-hpRatio)),math.floor(255*hpRatio),50)
        objs.tracer.Visible=cfg.esp_tracer; objs.tracer.From=Vector2.new(vpCenter.X,vpSize.Y); objs.tracer.To=Vector2.new(headVP.X,headVP.Y); objs.tracer.Color=espCol
        local parts = getCharParts(char)
        for i, conn in ipairs(skeletonConnections) do
            local line = objs.skel[i]
            local p1 = parts[conn[1]]; local p2 = parts[conn[2]]
            if p1 and p2 then
                local s1,v1 = worldToViewport(p1.Position); local s2,v2 = worldToViewport(p2.Position)
                line.Visible=cfg.esp_skeleton and v1 and v2; line.From=s1; line.To=s2; line.Color=espCol
            else line.Visible=false end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    lc = lp.Character; if not lc then return end
    local hrp = lc:FindFirstChild("HumanoidRootPart")
    if cfg.noclip then
        for _, part in ipairs(lc:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end
    if cfg.fly and hrp then
        local bv = hrp:FindFirstChild("FlyBV") or Instance.new("BodyVelocity", hrp)
        bv.Name="FlyBV"; bv.MaxForce=Vector3.new(1e5,1e5,1e5)
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.new(0,1,0) end
        bv.Velocity = dir.Magnitude>0 and dir.Unit*cfg.fly_speed or Vector3.zero
    else
        if hrp then local bv=hrp:FindFirstChild("FlyBV"); if bv then bv:Destroy() end end
    end
    if cfg.auto_fire then pcall(function() mouse1press() end) end
end)

local oldIndex
oldIndex = hookmetamethod and hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and key=="Hit" and self==mouse then
        if cfg.silent_aim then
            local target = getAimTarget(cfg.silent_fov)
            if target then return CFrame.new(target.Position) end
        end
    end
    return oldIndex(self, key)
end) or nil

UserInputService.JumpRequest:Connect(function()
    if cfg.inf_jump then
        local char = lp.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not cfg.aimkill then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p==lp then continue end
        if cfg.aimbot_teamcheck and getTeam(p)==getTeam(lp) then continue end
        local pc = p.Character; if not pc then continue end
        local hum = pc:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health>0 then pcall(function() hum.Health=0 end) end
    end
end)

if cfg.ac_bypass then
    pcall(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Script") or v:IsA("LocalScript") then
                local n = v.Name:lower()
                if n:find("anti") or n:find("cheat") or n:find("detect") then v.Disabled=true end
            end
        end
    end)
end

print("AnonymousH4X loaded | Mobile: sol taraftaki HAX butonu")

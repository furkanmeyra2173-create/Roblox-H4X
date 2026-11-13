-- AnonymousH4X v3.0 | Mobile Optimized

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
    esp=true, esp_box=true, esp_skeleton=true, esp_health=true,
    esp_distance=true, esp_tracer=true, esp_name=true,
    esp_teamcheck=true,
    esp_color=Color3.fromRGB(255,50,50),
    esp_friendly_color=Color3.fromRGB(0,200,255),
    aimbot=false, aimbot_fov=150, aimbot_smooth=0.25,
    aimbot_bone="Head", aimbot_teamcheck=true, aimbot_vischeck=true,
    silent_aim=false, silent_fov=200,
    aimkill=false,
    noclip=false, fly=false, fly_speed=50,
    inf_jump=false, speed=false, speed_value=32,
    auto_fire=false, rapid_fire=false, rapid_fire_delay=0.05,
    hitbox_expand=false, hitbox_size=5,
    fullbright=false, no_fog=false,
    auto_item=false, auto_item_delay=0.3,
    ac_bypass=true,
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnonymousH4X"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
local ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ok then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

-- Menü boyutu mobil için küçültüldü
local MENU_W = 340
local MENU_H = 360

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, MENU_W, 0, MENU_H)
Main.Position = UDim2.new(0.5, -MENU_W/2, 0.5, -MENU_H/2)
Main.BackgroundColor3 = Color3.fromRGB(10,10,15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(160,0,255)
stroke.Thickness = 1.5
stroke.Parent = Main

-- Başlık (dokunarak aç/kapa)
local TitleBar = Instance.new("TextButton")
TitleBar.Size = UDim2.new(1,0,0,36)
TitleBar.BackgroundColor3 = Color3.fromRGB(20,5,35)
TitleBar.BorderSizePixel = 0
TitleBar.Text = ""
TitleBar.Parent = Main
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "⚡ AnonymousH4X  |  TAP TO HIDE"
TitleLabel.Size = UDim2.new(1,0,1,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(210,100,255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

local ContentHolder = Instance.new("Frame")
ContentHolder.Size = UDim2.new(1,0,1,-36)
ContentHolder.Position = UDim2.new(0,0,0,36)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = Main

-- Başlığa dokunca içerik gizle/göster
local contentVisible = true
TitleBar.MouseButton1Click:Connect(function()
    contentVisible = not contentVisible
    ContentHolder.Visible = contentVisible
    Main.Size = contentVisible and UDim2.new(0,MENU_W,0,MENU_H) or UDim2.new(0,MENU_W,0,36)
    TitleLabel.Text = contentVisible and "⚡ AnonymousH4X  |  TAP TO HIDE" or "⚡ AnonymousH4X  |  TAP TO SHOW"
end)

-- Tabs
local tabs = {"ESP","AIMBOT","MOVE","COMBAT","VISUAL","MISC"}
local tabColors = {
    ESP=Color3.fromRGB(255,80,80), AIMBOT=Color3.fromRGB(255,160,0),
    MOVE=Color3.fromRGB(0,220,120), COMBAT=Color3.fromRGB(255,60,120),
    VISUAL=Color3.fromRGB(80,160,255), MISC=Color3.fromRGB(180,80,255),
}

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,0,0,30)
TabBar.BackgroundColor3 = Color3.fromRGB(12,8,20)
TabBar.BorderSizePixel = 0
TabBar.Parent = ContentHolder
local tbl = Instance.new("UIListLayout")
tbl.FillDirection = Enum.FillDirection.Horizontal
tbl.SortOrder = Enum.SortOrder.LayoutOrder
tbl.Parent = TabBar

local ScrollArea = Instance.new("ScrollingFrame")
ScrollArea.Size = UDim2.new(1,0,1,-30)
ScrollArea.Position = UDim2.new(0,0,0,30)
ScrollArea.BackgroundTransparency = 1
ScrollArea.BorderSizePixel = 0
ScrollArea.ScrollBarThickness = 3
ScrollArea.ScrollBarImageColor3 = Color3.fromRGB(160,0,255)
ScrollArea.Parent = ContentHolder

local ItemList = Instance.new("UIListLayout")
ItemList.SortOrder = Enum.SortOrder.LayoutOrder
ItemList.Padding = UDim.new(0,3)
ItemList.Parent = ScrollArea
local ItemPad = Instance.new("UIPadding")
ItemPad.PaddingLeft = UDim.new(0,8)
ItemPad.PaddingRight = UDim.new(0,8)
ItemPad.PaddingTop = UDim.new(0,6)
ItemPad.Parent = ScrollArea

ItemList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollArea.CanvasSize = UDim2.new(0,0,0,ItemList.AbsoluteContentSize.Y+16)
end)

local tabBtns = {}
local activeTab = "ESP"

local tabW = MENU_W / #tabs
for _, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = tabName
    btn.Size = UDim2.new(0, tabW-1, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(18,10,28)
    btn.TextColor3 = Color3.fromRGB(160,120,200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    btn.Parent = TabBar
    tabBtns[tabName] = btn
    btn.MouseButton1Click:Connect(function()
        activeTab = tabName
        for n, b in pairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(18,10,28)
            b.TextColor3 = Color3.fromRGB(160,120,200)
        end
        btn.BackgroundColor3 = tabColors[tabName]
        btn.TextColor3 = Color3.new(1,1,1)
        -- Scroll'u sıfırla
        ScrollArea.CanvasPosition = Vector2.zero
        -- İçeriği yeniden çiz
        for _, v in ipairs(ScrollArea:GetChildren()) do
            if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end
        end
        buildTab(tabName)
    end)
end
tabBtns["ESP"].BackgroundColor3 = tabColors["ESP"]
tabBtns["ESP"].TextColor3 = Color3.new(1,1,1)

-- UI helpers
local function makeToggle(label, cfgKey, color)
    color = color or Color3.fromRGB(160,0,255)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-4,0,32)
    row.BackgroundColor3 = Color3.fromRGB(18,12,28)
    row.BorderSizePixel = 0
    row.Parent = ScrollArea
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,7)
    local lbl = Instance.new("TextLabel")
    lbl.Text = label
    lbl.Size = UDim2.new(1,-52,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(220,200,240)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0,38,0,20)
    bg.Position = UDim2.new(1,-44,0.5,-10)
    bg.BackgroundColor3 = cfg[cfgKey] and color or Color3.fromRGB(50,40,60)
    bg.BorderSizePixel = 0
    bg.Parent = row
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,14,0,14)
    knob.Position = cfg[cfgKey] and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = row
    btn.MouseButton1Click:Connect(function()
        cfg[cfgKey] = not cfg[cfgKey]
        TweenService:Create(bg,TweenInfo.new(0.12),{BackgroundColor3=cfg[cfgKey] and color or Color3.fromRGB(50,40,60)}):Play()
        TweenService:Create(knob,TweenInfo.new(0.12),{Position=cfg[cfgKey] and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
    end)
end

local function makeSlider(label, cfgKey, min, max, suffix, isFloat)
    suffix = suffix or ""
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-4,0,46)
    row.BackgroundColor3 = Color3.fromRGB(18,12,28)
    row.BorderSizePixel = 0
    row.Parent = ScrollArea
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,7)
    local lbl = Instance.new("TextLabel")
    lbl.Text = label..": "..tostring(cfg[cfgKey])..suffix
    lbl.Size = UDim2.new(1,-10,0,18)
    lbl.Position = UDim2.new(0,10,0,3)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(220,200,240)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1,-20,0,6)
    track.Position = UDim2.new(0,10,0,30)
    track.BackgroundColor3 = Color3.fromRGB(50,40,70)
    track.BorderSizePixel = 0
    track.Parent = row
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((cfg[cfgKey]-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(160,0,255)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    local drag = false
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then drag=true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local relX = math.clamp((inp.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            local val
            if isFloat then
                val = math.floor((min+relX*(max-min))*100)/100
            else
                val = math.floor(min+relX*(max-min))
            end
            cfg[cfgKey] = val
            fill.Size = UDim2.new(relX,0,1,0)
            lbl.Text = label..": "..tostring(val)..suffix
        end
    end)
end

local function makeSection(text)
    local lbl = Instance.new("TextLabel")
    lbl.Text = "— "..text.." —"
    lbl.Size = UDim2.new(1,-4,0,18)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(160,80,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = ScrollArea
end

function buildTab(tab)
    if tab=="ESP" then
        makeSection("ESP")
        makeToggle("Enable ESP","esp",Color3.fromRGB(255,80,80))
        makeToggle("Box ESP","esp_box")
        makeToggle("Skeleton","esp_skeleton")
        makeToggle("Health Bar","esp_health")
        makeToggle("Distance","esp_distance")
        makeToggle("Tracers","esp_tracer")
        makeToggle("Names","esp_name")
        makeToggle("Team Check","esp_teamcheck")
    elseif tab=="AIMBOT" then
        makeSection("Aimbot")
        makeToggle("Aimbot (Hold Q)","aimbot",Color3.fromRGB(255,160,0))
        makeToggle("Silent Aim","silent_aim",Color3.fromRGB(255,100,0))
        makeToggle("Aimkill","aimkill",Color3.fromRGB(255,30,30))
        makeToggle("Vis Check","aimbot_vischeck")
        makeToggle("Team Check","aimbot_teamcheck")
        makeSlider("FOV","aimbot_fov",10,500," px")
        makeSlider("Smooth","aimbot_smooth",0.01,1,"",true)
        makeSlider("Silent FOV","silent_fov",10,500," px")
    elseif tab=="MOVE" then
        makeSection("Movement")
        makeToggle("Noclip","noclip",Color3.fromRGB(0,220,120))
        makeToggle("Fly","fly",Color3.fromRGB(0,180,255))
        makeToggle("Infinite Jump","inf_jump",Color3.fromRGB(0,220,120))
        makeToggle("Speed Hack","speed",Color3.fromRGB(0,220,120))
        makeSlider("Walk Speed","speed_value",16,250," ws")
        makeSlider("Fly Speed","fly_speed",10,400," ws")
    elseif tab=="COMBAT" then
        makeSection("Combat")
        makeToggle("Auto Fire","auto_fire",Color3.fromRGB(255,60,120))
        makeToggle("Rapid Fire","rapid_fire",Color3.fromRGB(255,30,80))
        makeSlider("Rapid Delay","rapid_fire_delay",0.01,0.5," s",true)
        makeToggle("Hitbox Expand","hitbox_expand",Color3.fromRGB(255,60,120))
        makeSlider("Hitbox Size","hitbox_size",1,20," studs")
        makeSection("Auto Item")
        makeToggle("Auto Item Switch","auto_item",Color3.fromRGB(255,180,0))
        makeSlider("Switch Delay","auto_item_delay",0.1,2," s",true)
    elseif tab=="VISUAL" then
        makeSection("Visual")
        makeToggle("FullBright","fullbright",Color3.fromRGB(80,160,255))
        makeToggle("No Fog","no_fog",Color3.fromRGB(80,160,255))
    elseif tab=="MISC" then
        makeSection("Misc")
        makeToggle("AC Bypass","ac_bypass",Color3.fromRGB(180,80,255))
    end
end

buildTab("ESP")

-- Draggable
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=inp.Position; startPos=Main.Position
    end
end)
TitleBar.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
        local d = inp.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)

-- ===== ESP =====
local espObjects = {}
local function getTeam(p) return p.Team end
local function w2v(pos)
    local vp,inView = Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X,vp.Y),inView,vp.Z
end
local function getCharParts(char)
    local parts={}
    for _,v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then parts[v.Name]=v end end
    return parts
end
local skelConn={
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
}
local function cleanESP(player)
    if not espObjects[player] then return end
    for _,obj in pairs(espObjects[player]) do
        if typeof(obj)=="Instance" then obj:Remove()
        elseif type(obj)=="table" then for _,o in pairs(obj) do if typeof(o)=="Instance" then o:Remove() end end end
    end
    espObjects[player]=nil
end
local function setupESP(player)
    if player==lp then return end
    cleanESP(player)
    local o={}
    local box=Drawing.new("Square"); box.Visible=false; box.Thickness=1.5; box.Filled=false; o.box=box
    local name=Drawing.new("Text"); name.Visible=false; name.Size=12; name.Center=true; name.Font=Drawing.Fonts.UI; o.name=name
    local dist=Drawing.new("Text"); dist.Visible=false; dist.Size=10; dist.Center=true; dist.Font=Drawing.Fonts.UI; o.dist=dist
    local hbBg=Drawing.new("Square"); hbBg.Visible=false; hbBg.Filled=true; hbBg.Color=Color3.fromRGB(30,30,30); o.hbBg=hbBg
    local hbFill=Drawing.new("Square"); hbFill.Visible=false; hbFill.Filled=true; o.hbFill=hbFill
    local tracer=Drawing.new("Line"); tracer.Visible=false; tracer.Thickness=1; o.tracer=tracer
    local skel={}
    for i=1,#skelConn do local l=Drawing.new("Line"); l.Visible=false; l.Thickness=1; skel[i]=l end
    o.skel=skel
    espObjects[player]=o
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(0.5); setupESP(p) end)
    if p.Character then setupESP(p) end
end)
Players.PlayerRemoving:Connect(cleanESP)
for _,p in ipairs(Players:GetPlayers()) do
    if p~=lp then
        if p.Character then setupESP(p) end
        p.CharacterAdded:Connect(function() task.wait(0.5); setupESP(p) end)
    end
end

-- ===== AIM =====
local function getAimTarget(fovLimit)
    local best=fovLimit; local target=nil
    local vc=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    for _,p in ipairs(Players:GetPlayers()) do
        if p==lp then continue end
        if cfg.aimbot_teamcheck and getTeam(p)==getTeam(lp) then continue end
        local char=p.Character; if not char then continue end
        local head=char:FindFirstChild("Head"); if not head then continue end
        if cfg.aimbot_vischeck then
            local ray=Ray.new(Camera.CFrame.Position,(head.Position-Camera.CFrame.Position).Unit*1000)
            local hit=workspace:FindPartOnRayWithIgnoreList(ray,{lc,Camera})
            if hit and not hit:IsDescendantOf(char) then continue end
        end
        local vp,inView=w2v(head.Position); if not inView then continue end
        local d=(vp-vc).Magnitude
        if d<best then best=d; target=head end
    end
    return target
end

-- ===== AUTO ITEM =====
local autoItemIndex = 1
local lastItemSwitch = 0

-- ===== RAPID FIRE =====
local lastRapidFire = 0
local rapidFireDown = false

-- ===== MAIN LOOP =====
RunService.RenderStepped:Connect(function()
    lc=lp.Character; if not lc then return end
    local hum=lc:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed=cfg.speed and cfg.speed_value or 16 end
    if cfg.fullbright then
        Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.FogEnd=100000
        Lighting.GlobalShadows=false; Lighting.Ambient=Color3.new(1,1,1); Lighting.OutdoorAmbient=Color3.new(1,1,1)
    end
    if cfg.no_fog then Lighting.FogEnd=100000; Lighting.FogStart=100000 end

    -- Aimbot
    if cfg.aimbot and UserInputService:IsKeyDown(Enum.KeyCode.Q) then
        local t=getAimTarget(cfg.aimbot_fov)
        if t then
            local vp=w2v(t.Position)
            local vc=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
            local delta=vp-vc
            pcall(function() mousemoverel(delta.X*cfg.aimbot_smooth,delta.Y*cfg.aimbot_smooth) end)
        end
    end

    -- Aimkill
    if cfg.aimkill then
        for _,p in ipairs(Players:GetPlayers()) do
            if p==lp then continue end
            if cfg.aimbot_teamcheck and getTeam(p)==getTeam(lp) then continue end
            local pc=p.Character; if not pc then continue end
            local h=pc:FindFirstChildOfClass("Humanoid")
            if h and h.Health>0 then pcall(function() h.Health=0 end) end
        end
    end

    -- Hitbox
    if cfg.hitbox_expand then
        for _,p in ipairs(Players:GetPlayers()) do
            if p==lp then continue end
            local pc=p.Character; if not pc then continue end
            for _,part in ipairs(pc:GetDescendants()) do
                if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
                    part.Size=Vector3.new(cfg.hitbox_size,cfg.hitbox_size,cfg.hitbox_size)
                end
            end
        end
    end

    -- ESP
    local vpSize=Camera.ViewportSize
    local vpc=Vector2.new(vpSize.X/2,vpSize.Y/2)
    for _,player in ipairs(Players:GetPlayers()) do
        if player==lp then continue end
        local o=espObjects[player]; if not o then continue end
        local char=player.Character
        if not cfg.esp or not char then
            for _,obj in pairs(o) do
                if typeof(obj)=="Instance" then obj.Visible=false
                elseif type(obj)=="table" then for _,x in pairs(obj) do x.Visible=false end end
            end
            continue
        end
        local humanoid=char:FindFirstChildOfClass("Humanoid")
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local head=char:FindFirstChild("Head")
        if not hrp or not head then continue end
        local isEnemy=not cfg.esp_teamcheck or getTeam(player)~=getTeam(lp)
        local col=isEnemy and cfg.esp_color or cfg.esp_friendly_color
        local hVP,_,hZ=w2v(head.Position+Vector3.new(0,0.5,0))
        local fVP=w2v(hrp.Position-Vector3.new(0,2.5,0))
        local dist=math.floor((Camera.CFrame.Position-hrp.Position).Magnitude)
        if hZ<=0 then
            for _,obj in pairs(o) do
                if typeof(obj)=="Instance" then obj.Visible=false
                elseif type(obj)=="table" then for _,x in pairs(obj) do x.Visible=false end end
            end
            continue
        end
        local bH=math.abs(hVP.Y-fVP.Y); local bW=bH*0.55
        local bX=hVP.X-bW/2; local bY=hVP.Y
        o.box.Visible=cfg.esp_box; o.box.Position=Vector2.new(bX,bY); o.box.Size=Vector2.new(bW,bH); o.box.Color=col
        o.name.Visible=cfg.esp_name; o.name.Position=Vector2.new(hVP.X,hVP.Y-14); o.name.Text=player.Name; o.name.Color=col
        o.dist.Visible=cfg.esp_distance; o.dist.Position=Vector2.new(hVP.X,fVP.Y+2); o.dist.Text=dist.."m"; o.dist.Color=Color3.fromRGB(220,220,220)
        local hp=humanoid and humanoid.Health or 100
        local maxhp=humanoid and humanoid.MaxHealth or 100
        local hpr=math.clamp(hp/maxhp,0,1)
        o.hbBg.Visible=cfg.esp_health; o.hbBg.Position=Vector2.new(bX-6,bY); o.hbBg.Size=Vector2.new(4,bH)
        o.hbFill.Visible=cfg.esp_health; o.hbFill.Position=Vector2.new(bX-6,bY+bH*(1-hpr)); o.hbFill.Size=Vector2.new(4,bH*hpr)
        o.hbFill.Color=Color3.fromRGB(math.floor(255*(1-hpr)),math.floor(255*hpr),50)
        o.tracer.Visible=cfg.esp_tracer; o.tracer.From=Vector2.new(vpc.X,vpSize.Y); o.tracer.To=Vector2.new(hVP.X,hVP.Y); o.tracer.Color=col
        local parts=getCharParts(char)
        for i,conn in ipairs(skelConn) do
            local line=o.skel[i]
            local p1=parts[conn[1]]; local p2=parts[conn[2]]
            if p1 and p2 then
                local s1,v1=w2v(p1.Position); local s2,v2=w2v(p2.Position)
                line.Visible=cfg.esp_skeleton and v1 and v2; line.From=s1; line.To=s2; line.Color=col
            else line.Visible=false end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    lc=lp.Character; if not lc then return end
    local hrp=lc:FindFirstChild("HumanoidRootPart")
    local hum=lc:FindFirstChildOfClass("Humanoid")
    local now=tick()

    -- Noclip
    if cfg.noclip then
        for _,p in ipairs(lc:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end

    -- Fly
    if cfg.fly and hrp then
        local bv=hrp:FindFirstChild("FlyBV") or Instance.new("BodyVelocity",hrp)
        bv.Name="FlyBV"; bv.MaxForce=Vector3.new(1e5,1e5,1e5)
        local dir=Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.new(0,1,0) end
        bv.Velocity=dir.Magnitude>0 and dir.Unit*cfg.fly_speed or Vector3.zero
    else
        if hrp then local bv=hrp:FindFirstChild("FlyBV"); if bv then bv:Destroy() end end
    end

    -- Auto Fire (sürekli tıklama, her frame)
    if cfg.auto_fire and not cfg.rapid_fire then
        pcall(function() mouse1click() end)
    end

    -- Rapid Fire (delay'li hızlı ateş)
    if cfg.rapid_fire then
        if now - lastRapidFire >= cfg.rapid_fire_delay then
            pcall(function()
                mouse1press()
                task.wait(0.01)
                mouse1release()
            end)
            lastRapidFire = now
        end
    end

    -- Auto Item Switch
    if cfg.auto_item and hum then
        if now - lastItemSwitch >= cfg.auto_item_delay then
            local backpack = lp:FindFirstChild("Backpack")
            local char = lp.Character
            local items = {}
            if char then
                for _, v in ipairs(char:GetChildren()) do
                    if v:IsA("Tool") then table.insert(items, v) end
                end
            end
            if backpack then
                for _, v in ipairs(backpack:GetChildren()) do
                    if v:IsA("Tool") then table.insert(items, v) end
                end
            end
            if #items > 0 then
                autoItemIndex = (autoItemIndex % #items) + 1
                local tool = items[autoItemIndex]
                if tool and tool.Parent == backpack then
                    -- backpack'taki tool'u equip et
                    hum:EquipTool(tool)
                elseif tool and tool.Parent == char then
                    -- zaten equipped, unequip yap
                    hum:UnequipTools()
                end
            end
            lastItemSwitch = now
        end
    end
end)

-- Silent Aim hook
local oldIndex
oldIndex = hookmetamethod and hookmetamethod(game,"__index",function(self,key)
    if not checkcaller() and key=="Hit" and self==mouse then
        if cfg.silent_aim then
            local t=getAimTarget(cfg.silent_fov)
            if t then return CFrame.new(t.Position) end
        end
    end
    return oldIndex(self,key)
end) or nil

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if cfg.inf_jump then
        local char=lp.Character; if not char then return end
        local h=char:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- AC Bypass
if cfg.ac_bypass then
    pcall(function()
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Script") or v:IsA("LocalScript") then
                local n=v.Name:lower()
                if n:find("anti") or n:find("cheat") or n:find("detect") then v.Disabled=true end
            end
        end
    end)
end

print("AnonymousH4X v3.0 | Basliga dokun = gizle/goster")

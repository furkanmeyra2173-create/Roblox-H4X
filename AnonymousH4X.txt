-- AnonymousH4X v4.0 | Full Feature Pack

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
    esp=true, esp_box=true, esp_skeleton=true, esp_health=true,
    esp_distance=true, esp_tracer=true, esp_name=true, esp_teamcheck=true,
    esp_color=Color3.fromRGB(255,50,50),
    esp_friendly_color=Color3.fromRGB(0,200,255),
    esp_chams=false,
    -- Radar
    radar=false, radar_size=200, radar_range=200,
    -- Crosshair
    crosshair=false, crosshair_size=12, crosshair_gap=4, crosshair_thickness=1,
    crosshair_color=Color3.fromRGB(255,255,255), crosshair_dot=true,
    -- FOV Circle
    fov_circle=false, fov_color=Color3.fromRGB(255,255,255),
    -- Aimbot
    aimbot=false, aimbot_fov=150, aimbot_smooth=0.25,
    aimbot_bone="Head", aimbot_teamcheck=true, aimbot_vischeck=true,
    silent_aim=false, silent_fov=200,
    aimkill=false,
    -- Movement
    noclip=false, fly=false, fly_speed=50,
    inf_jump=false, speed=false, speed_value=32,
    bunnyhop=false,
    anti_aim=false,
    -- Combat
    auto_fire=false, rapid_fire=false, rapid_fire_delay=0.05,
    hitbox_expand=false, hitbox_size=5,
    kill_aura=false, kill_aura_range=15,
    reach=false, reach_range=15,
    wallbang=false,
    -- Auto Item
    auto_item=false, auto_item_delay=0.3,
    -- Visual
    fullbright=false, no_fog=false,
    -- Misc
    spectator_list=false,
    ac_bypass=true,
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnonymousH4X"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
local ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ok then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

local MENU_W = 340
local MENU_H = 360

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,MENU_W,0,MENU_H)
Main.Position = UDim2.new(0.5,-MENU_W/2,0.5,-MENU_H/2)
Main.BackgroundColor3 = Color3.fromRGB(10,10,15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,10)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(160,0,255)
stroke.Thickness = 1.5
stroke.Parent = Main

local TitleBar = Instance.new("TextButton")
TitleBar.Size = UDim2.new(1,0,0,36)
TitleBar.BackgroundColor3 = Color3.fromRGB(20,5,35)
TitleBar.BorderSizePixel = 0
TitleBar.Text = ""
TitleBar.Parent = Main
Instance.new("UICorner",TitleBar).CornerRadius = UDim.new(0,10)

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

local contentVisible = true

-- HAX Button
local HaxBtn = Instance.new("TextButton")
HaxBtn.Text = "HAX"
HaxBtn.Size = UDim2.new(0,52,0,52)
HaxBtn.Position = UDim2.new(0,10,0.5,-26)
HaxBtn.BackgroundColor3 = Color3.fromRGB(100,0,200)
HaxBtn.TextColor3 = Color3.new(1,1,1)
HaxBtn.TextSize = 12
HaxBtn.Font = Enum.Font.GothamBold
HaxBtn.BorderSizePixel = 0
HaxBtn.ZIndex = 10
HaxBtn.Parent = ScreenGui
Instance.new("UICorner",HaxBtn).CornerRadius = UDim.new(1,0)
local haxStroke = Instance.new("UIStroke")
haxStroke.Color = Color3.fromRGB(180,0,255)
haxStroke.Thickness = 1.5
haxStroke.Parent = HaxBtn

-- Mobil Aim butonu (sağ alt)
_G.AimHeld = false
local AimBtn = Instance.new("TextButton")
AimBtn.Text = "AIM"
AimBtn.Size = UDim2.new(0,60,0,60)
AimBtn.Position = UDim2.new(1,-80,1,-80)
AimBtn.BackgroundColor3 = Color3.fromRGB(200,80,0)
AimBtn.TextColor3 = Color3.new(1,1,1)
AimBtn.TextSize = 13
AimBtn.Font = Enum.Font.GothamBold
AimBtn.BorderSizePixel = 0
AimBtn.ZIndex = 10
AimBtn.Parent = ScreenGui
Instance.new("UICorner",AimBtn).CornerRadius = UDim.new(1,0)
AimBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
        _G.AimHeld=true
    end
end)
AimBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
        _G.AimHeld=false
    end
end)

-- Fly Up/Down butonları (sağ taraf)
_G.FlyUp=false; _G.FlyDown=false
local function makeFlyBtn(text,yOffset,upDown)
    local b=Instance.new("TextButton")
    b.Text=text; b.Size=UDim2.new(0,44,0,44)
    b.Position=UDim2.new(1,-54,0.5,yOffset)
    b.BackgroundColor3=Color3.fromRGB(0,100,200)
    b.TextColor3=Color3.new(1,1,1); b.TextSize=16
    b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0; b.ZIndex=10
    b.Parent=ScreenGui
    Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
    b.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
            if upDown=="up" then _G.FlyUp=true else _G.FlyDown=true end
        end
    end)
    b.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
            if upDown=="up" then _G.FlyUp=false else _G.FlyDown=false end
        end
    end)
    return b
end
local flyUpBtn = makeFlyBtn("▲",-50,"up")
local flyDnBtn = makeFlyBtn("▼",10,"dn")
-- fly butonları sadece fly açıkken görünür
RunService.RenderStepped:Connect(function()
    flyUpBtn.Visible = cfg.fly
    flyDnBtn.Visible = cfg.fly
    AimBtn.Visible = cfg.aimbot
end)

local HAX_DRAG_THRESHOLD = 8
local haxDragging,haxDragStart,haxBtnStartPos,haxMoved = false,nil,nil,false
HaxBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        haxDragging=true; haxMoved=false; haxDragStart=inp.Position; haxBtnStartPos=HaxBtn.Position
    end
end)
HaxBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        if not haxMoved then Main.Visible = not Main.Visible end
        haxDragging=false; haxMoved=false
    end
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
local tabW = MENU_W/#tabs

for _,tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = tabName
    btn.Size = UDim2.new(0,tabW-1,1,0)
    btn.BackgroundColor3 = Color3.fromRGB(18,10,28)
    btn.TextColor3 = Color3.fromRGB(160,120,200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    btn.Parent = TabBar
    tabBtns[tabName] = btn
    btn.MouseButton1Click:Connect(function()
        activeTab = tabName
        for n,b in pairs(tabBtns) do b.BackgroundColor3=Color3.fromRGB(18,10,28); b.TextColor3=Color3.fromRGB(160,120,200) end
        btn.BackgroundColor3=tabColors[tabName]; btn.TextColor3=Color3.new(1,1,1)
        ScrollArea.CanvasPosition=Vector2.zero
        for _,v in ipairs(ScrollArea:GetChildren()) do
            if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end
        end
        buildTab(tabName)
    end)
end
tabBtns["ESP"].BackgroundColor3=tabColors["ESP"]; tabBtns["ESP"].TextColor3=Color3.new(1,1,1)

-- UI helpers
local function makeToggle(label,cfgKey,color)
    color = color or Color3.fromRGB(160,0,255)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-4,0,32)
    row.BackgroundColor3 = Color3.fromRGB(18,12,28)
    row.BorderSizePixel = 0
    row.Parent = ScrollArea
    Instance.new("UICorner",row).CornerRadius = UDim.new(0,7)
    local lbl = Instance.new("TextLabel")
    lbl.Text=label; lbl.Size=UDim2.new(1,-52,1,0); lbl.Position=UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.fromRGB(220,200,240)
    lbl.Font=Enum.Font.Gotham; lbl.TextSize=11; lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Parent=row
    local bg = Instance.new("Frame")
    bg.Size=UDim2.new(0,38,0,20); bg.Position=UDim2.new(1,-44,0.5,-10)
    bg.BackgroundColor3=cfg[cfgKey] and color or Color3.fromRGB(50,40,60)
    bg.BorderSizePixel=0; bg.Parent=row
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)
    local knob = Instance.new("Frame")
    knob.Size=UDim2.new(0,14,0,14)
    knob.Position=cfg[cfgKey] and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    knob.BackgroundColor3=Color3.new(1,1,1); knob.BorderSizePixel=0; knob.Parent=bg
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    local btn = Instance.new("TextButton")
    btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""; btn.Parent=row
    btn.MouseButton1Click:Connect(function()
        cfg[cfgKey]=not cfg[cfgKey]
        TweenService:Create(bg,TweenInfo.new(0.12),{BackgroundColor3=cfg[cfgKey] and color or Color3.fromRGB(50,40,60)}):Play()
        TweenService:Create(knob,TweenInfo.new(0.12),{Position=cfg[cfgKey] and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
    end)
end

local function makeSlider(label,cfgKey,min,max,suffix,isFloat)
    suffix=suffix or ""
    local row = Instance.new("Frame")
    row.Size=UDim2.new(1,-4,0,46); row.BackgroundColor3=Color3.fromRGB(18,12,28)
    row.BorderSizePixel=0; row.Parent=ScrollArea
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,7)
    local lbl = Instance.new("TextLabel")
    lbl.Text=label..": "..tostring(cfg[cfgKey])..suffix
    lbl.Size=UDim2.new(1,-10,0,18); lbl.Position=UDim2.new(0,10,0,3)
    lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.fromRGB(220,200,240)
    lbl.Font=Enum.Font.Gotham; lbl.TextSize=10; lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Parent=row
    local track = Instance.new("Frame")
    track.Size=UDim2.new(1,-20,0,6); track.Position=UDim2.new(0,10,0,30)
    track.BackgroundColor3=Color3.fromRGB(50,40,70); track.BorderSizePixel=0; track.Parent=row
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local fill = Instance.new("Frame")
    fill.Size=UDim2.new((cfg[cfgKey]-min)/(max-min),0,1,0)
    fill.BackgroundColor3=Color3.fromRGB(160,0,255); fill.BorderSizePixel=0; fill.Parent=track
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local drag=false
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then drag=true end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local relX=math.clamp((inp.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            local val = isFloat and math.floor((min+relX*(max-min))*100)/100 or math.floor(min+relX*(max-min))
            cfg[cfgKey]=val; fill.Size=UDim2.new(relX,0,1,0)
            lbl.Text=label..": "..tostring(val)..suffix
        end
    end)
end

local function makeSec(text)
    local lbl=Instance.new("TextLabel")
    lbl.Text="— "..text.." —"; lbl.Size=UDim2.new(1,-4,0,18)
    lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.fromRGB(160,80,255)
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=10; lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Parent=ScrollArea
end

function buildTab(tab)
    if tab=="ESP" then
        makeSec("ESP")
        makeToggle("Enable ESP","esp",Color3.fromRGB(255,80,80))
        makeToggle("Box ESP","esp_box")
        makeToggle("Skeleton","esp_skeleton")
        makeToggle("Health Bar","esp_health")
        makeToggle("Distance","esp_distance")
        makeToggle("Tracers","esp_tracer")
        makeToggle("Names","esp_name")
        makeToggle("Team Check","esp_teamcheck")
        makeToggle("Chams","esp_chams")
        makeSec("Radar")
        makeToggle("2D Radar","radar",Color3.fromRGB(0,220,100))
        makeSlider("Radar Size","radar_size",100,400," px")
        makeSlider("Radar Range","radar_range",50,500," studs")
        makeSec("Crosshair")
        makeToggle("Crosshair","crosshair",Color3.fromRGB(255,255,255))
        makeToggle("Center Dot","crosshair_dot")
        makeSlider("CH Size","crosshair_size",4,30," px")
        makeSlider("CH Gap","crosshair_gap",0,20," px")
        makeSlider("CH Thickness","crosshair_thickness",1,5," px")
    elseif tab=="AIMBOT" then
        makeSec("Aimbot")
        makeToggle("Aimbot (Hold Q)","aimbot",Color3.fromRGB(255,160,0))
        makeToggle("FOV Circle","fov_circle")
        makeSlider("FOV","aimbot_fov",10,500," px")
        makeSlider("Smooth","aimbot_smooth",0.01,1,"",true)
        makeToggle("Vis Check","aimbot_vischeck")
        makeToggle("Team Check","aimbot_teamcheck")
        makeSec("Silent Aim")
        makeToggle("Silent Aim","silent_aim",Color3.fromRGB(255,100,0))
        makeSlider("Silent FOV","silent_fov",10,500," px")
        makeSec("Aimkill")
        makeToggle("Aimkill","aimkill",Color3.fromRGB(255,30,30))
    elseif tab=="MOVE" then
        makeSec("Movement")
        makeToggle("Noclip","noclip",Color3.fromRGB(0,220,120))
        makeToggle("Fly","fly",Color3.fromRGB(0,180,255))
        makeSlider("Fly Speed","fly_speed",10,400," ws")
        makeToggle("Infinite Jump","inf_jump",Color3.fromRGB(0,220,120))
        makeToggle("Bunnyhop","bunnyhop",Color3.fromRGB(0,220,120))
        makeToggle("Speed Hack","speed",Color3.fromRGB(0,220,120))
        makeSlider("Walk Speed","speed_value",16,250," ws")
        makeToggle("Anti-Aim","anti_aim",Color3.fromRGB(255,80,80))
    elseif tab=="COMBAT" then
        makeSec("Combat")
        makeToggle("Auto Fire","auto_fire",Color3.fromRGB(255,60,120))
        makeToggle("Rapid Fire","rapid_fire",Color3.fromRGB(255,30,80))
        makeSlider("Rapid Delay","rapid_fire_delay",0.01,0.5," s",true)
        makeToggle("Wallbang","wallbang",Color3.fromRGB(255,120,0))
        makeToggle("Kill Aura","kill_aura",Color3.fromRGB(255,0,80))
        makeSlider("Kill Aura Range","kill_aura_range",5,50," studs")
        makeToggle("Reach Hack","reach",Color3.fromRGB(255,80,0))
        makeSlider("Reach Range","reach_range",5,50," studs")
        makeToggle("Hitbox Expand","hitbox_expand",Color3.fromRGB(255,60,120))
        makeSlider("Hitbox Size","hitbox_size",1,20," studs")
        makeSec("Auto Item")
        makeToggle("Auto Item Switch","auto_item",Color3.fromRGB(255,180,0))
        makeSlider("Switch Delay","auto_item_delay",0.1,2," s",true)
    elseif tab=="VISUAL" then
        makeSec("Visual")
        makeToggle("FullBright","fullbright",Color3.fromRGB(80,160,255))
        makeToggle("No Fog","no_fog",Color3.fromRGB(80,160,255))
    elseif tab=="MISC" then
        makeSec("Misc")
        makeToggle("Spectator List","spectator_list",Color3.fromRGB(180,80,255))
        makeToggle("AC Bypass","ac_bypass",Color3.fromRGB(180,80,255))
    end
end

buildTab("ESP")

-- Draggable menu + HAX tap/drag
local menuDragging,menuDragStart,menuStartPos,menuMoved = false,nil,nil,false
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        menuDragging=true; menuMoved=false; menuDragStart=inp.Position; menuStartPos=Main.Position
    end
end)
TitleBar.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
        menuDragging=false
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
        -- menu drag
        if menuDragging and menuDragStart then
            local d=inp.Position-menuDragStart
            if d.Magnitude>HAX_DRAG_THRESHOLD then
                menuMoved=true
                Main.Position=UDim2.new(menuStartPos.X.Scale,menuStartPos.X.Offset+d.X,menuStartPos.Y.Scale,menuStartPos.Y.Offset+d.Y)
            end
        end
        -- hax btn drag
        if haxDragging and haxDragStart then
            local d=inp.Position-haxDragStart
            if d.Magnitude>HAX_DRAG_THRESHOLD then
                haxMoved=true
                HaxBtn.Position=UDim2.new(haxBtnStartPos.X.Scale,haxBtnStartPos.X.Offset+d.X,haxBtnStartPos.Y.Scale,haxBtnStartPos.Y.Offset+d.Y)
            end
        end
    end
end)

TitleBar.MouseButton1Click:Connect(function()
    if not menuMoved then
        contentVisible=not contentVisible
        ContentHolder.Visible=contentVisible
        Main.Size=contentVisible and UDim2.new(0,MENU_W,0,MENU_H) or UDim2.new(0,MENU_W,0,36)
        TitleLabel.Text=contentVisible and "⚡ AnonymousH4X  |  TAP TO HIDE" or "⚡ AnonymousH4X  |  TAP TO SHOW"
    end
    menuMoved=false
end)

-- ===== DRAWINGS =====
local espObjects = {}
-- Crosshair drawings
local chLines = {
    top = Drawing.new("Line"), bot = Drawing.new("Line"),
    left = Drawing.new("Line"), right = Drawing.new("Line"),
    dot = Drawing.new("Circle"),
}
for _,v in pairs(chLines) do v.Visible=false; v.Thickness=1; v.Color=Color3.new(1,1,1) end
chLines.dot.Filled=true; chLines.dot.Radius=2

-- FOV circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible=false; fovCircle.Filled=false; fovCircle.Thickness=1
fovCircle.Color=Color3.fromRGB(255,255,255); fovCircle.NumSides=64

-- Radar frame (2D)
local radarBg = Drawing.new("Square")
radarBg.Visible=false; radarBg.Filled=true; radarBg.Color=Color3.fromRGB(10,10,10); radarBg.Transparency=0.5

local radarBorder = Drawing.new("Square")
radarBorder.Visible=false; radarBorder.Filled=false; radarBorder.Color=Color3.fromRGB(160,0,255); radarBorder.Thickness=1

local radarCenter = Drawing.new("Circle")
radarCenter.Visible=false; radarCenter.Filled=true; radarCenter.Color=Color3.fromRGB(0,200,255); radarCenter.Radius=4

local radarDots = {}

-- Spectator list
local specLabel = Instance.new("TextLabel")
specLabel.Size = UDim2.new(0,180,0,200)
specLabel.Position = UDim2.new(1,-190,0,50)
specLabel.BackgroundColor3 = Color3.fromRGB(10,10,15)
specLabel.BackgroundTransparency = 0.3
specLabel.BorderSizePixel = 0
specLabel.TextColor3 = Color3.fromRGB(220,180,255)
specLabel.Font = Enum.Font.Gotham
specLabel.TextSize = 10
specLabel.TextXAlignment = Enum.TextXAlignment.Left
specLabel.TextYAlignment = Enum.TextYAlignment.Top
specLabel.Visible = false
specLabel.Text = ""
specLabel.ZIndex = 5
specLabel.Parent = ScreenGui
Instance.new("UICorner",specLabel).CornerRadius=UDim.new(0,6)

-- ESP helpers
local function getTeam(p) return p.Team end
local function w2v(pos)
    local vp,inView=Camera:WorldToViewportPoint(pos)
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
        pcall(function()
            if typeof(obj)=="Instance" then obj:Remove()
            elseif type(obj)=="table" then
                for _,o2 in pairs(obj) do
                    if typeof(o2)=="Instance" then o2:Remove() end
                end
            end
        end)
    end
    espObjects[player]=nil
end

local function newDrawing(type_, props)
    local d = Drawing.new(type_)
    for k,v in pairs(props) do pcall(function() d[k]=v end) end
    return d
end

local function setupESP(player)
    if player==lp then return end
    cleanESP(player)
    local o={}
    o.box   = newDrawing("Square",{Visible=false,Thickness=1.5,Filled=false})
    o.name  = newDrawing("Text",  {Visible=false,Size=12,Center=true,Font=Drawing.Fonts.UI})
    o.dist  = newDrawing("Text",  {Visible=false,Size=10,Center=true,Font=Drawing.Fonts.UI})
    o.hbBg  = newDrawing("Square",{Visible=false,Filled=true,Color=Color3.fromRGB(30,30,30)})
    o.hbFill= newDrawing("Square",{Visible=false,Filled=true})
    o.tracer= newDrawing("Line",  {Visible=false,Thickness=1})
    local skel={}
    for i=1,#skelConn do
        skel[i]=newDrawing("Line",{Visible=false,Thickness=1})
    end
    o.skel=skel
    espObjects[player]=o
end

local function hideESPObj(o)
    pcall(function() o.Visible=false end)
end
local function hideAllESP(o)
    for _,obj in pairs(o) do
        if typeof(obj)=="Instance" then hideESPObj(obj)
        elseif type(obj)=="table" then for _,x in pairs(obj) do hideESPObj(x) end end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(0.5); setupESP(p) end)
    if p.Character then setupESP(p) end
end)
Players.PlayerRemoving:Connect(function(p)
    cleanESP(p)
    for i,d in ipairs(radarDots) do
        if d.player==p then pcall(function() d.dot:Remove() end); table.remove(radarDots,i); break end
    end
end)
for _,p in ipairs(Players:GetPlayers()) do
    if p~=lp then
        if p.Character then setupESP(p) end
        p.CharacterAdded:Connect(function() task.wait(0.5); setupESP(p) end)
    end
end

-- ===== AIM TARGET =====
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

-- ===== WALLBANG =====
local function getWallbangTarget()
    -- raycast qua duvar, maksimum 2 hit
    local origin = Camera.CFrame.Position
    local dir = Camera.CFrame.LookVector * 500
    local ray = Ray.new(origin, dir)
    local ignore = {lc}
    local hitParts = {}
    for i=1,3 do
        local hit,pos = workspace:FindPartOnRayWithIgnoreList(ray,ignore)
        if not hit then break end
        table.insert(ignore,hit)
        local char = hit:FindFirstAncestorOfClass("Model")
        if char then
            local p = Players:GetPlayerFromCharacter(char)
            if p and p~=lp then
                if cfg.aimbot_teamcheck and getTeam(p)==getTeam(lp) then break end
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health>0 then
                    return hum
                end
            end
        end
        ray = Ray.new(pos+dir.Unit*0.1,dir)
    end
    return nil
end

-- state vars
local lastRapidFire = 0
local lastItemSwitch = 0
local autoItemIndex = 1

-- fireOnce global — silent aim fallback bunu wrap edebilir
fireOnce = function()
    pcall(function()
        local char=lp.Character; if not char then return end
        local tool=char:FindFirstChildOfClass("Tool"); if not tool then return end
        local activated=tool:FindFirstChild("Activated")
        if activated then pcall(function() activated:Fire() end) end
        for _,v in ipairs(tool:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                pcall(function() v:FireServer() end); break
            end
        end
    end)
end
local bhopConn = nil

-- ===== RENDER LOOP =====
RunService.RenderStepped:Connect(function()
    lc=lp.Character; if not lc then return end
    local hum=lc:FindFirstChildOfClass("Humanoid")
    local hrp=lc:FindFirstChild("HumanoidRootPart")
    local vpSize=Camera.ViewportSize
    local vpc=Vector2.new(vpSize.X/2,vpSize.Y/2)

    -- Speed
    if hum then hum.WalkSpeed=cfg.speed and cfg.speed_value or 16 end

    -- Fullbright
    if cfg.fullbright then
        Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.FogEnd=100000
        Lighting.GlobalShadows=false; Lighting.Ambient=Color3.new(1,1,1); Lighting.OutdoorAmbient=Color3.new(1,1,1)
    end
    if cfg.no_fog then Lighting.FogEnd=100000; Lighting.FogStart=100000 end

    -- Anti-Aim (spin)
    if cfg.anti_aim and hrp then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(15), 0)
    end

    -- Aimbot — mobil butona basılıyken aktif
    if cfg.aimbot and _G.AimHeld then
        local t=getAimTarget(cfg.aimbot_fov)
        if t then
            local targetCF=CFrame.new(Camera.CFrame.Position,t.Position)
            Camera.CFrame=Camera.CFrame:Lerp(targetCF,cfg.aimbot_smooth)
        end
    end

    -- FOV Circle
    fovCircle.Visible = cfg.fov_circle
    if cfg.fov_circle then
        fovCircle.Position = vpc
        fovCircle.Radius = cfg.aimbot_fov
        fovCircle.Color = cfg.fov_color
    end

    -- Crosshair
    local chVis = cfg.crosshair
    local cs = cfg.crosshair_size
    local cg = cfg.crosshair_gap
    local ct = cfg.crosshair_thickness
    local cc = cfg.crosshair_color
    chLines.top.Visible=chVis; chLines.bot.Visible=chVis
    chLines.left.Visible=chVis; chLines.right.Visible=chVis
    chLines.dot.Visible=chVis and cfg.crosshair_dot
    if chVis then
        chLines.top.From=Vector2.new(vpc.X,vpc.Y-cg); chLines.top.To=Vector2.new(vpc.X,vpc.Y-cg-cs)
        chLines.bot.From=Vector2.new(vpc.X,vpc.Y+cg); chLines.bot.To=Vector2.new(vpc.X,vpc.Y+cg+cs)
        chLines.left.From=Vector2.new(vpc.X-cg,vpc.Y); chLines.left.To=Vector2.new(vpc.X-cg-cs,vpc.Y)
        chLines.right.From=Vector2.new(vpc.X+cg,vpc.Y); chLines.right.To=Vector2.new(vpc.X+cg+cs,vpc.Y)
        for _,l in pairs(chLines) do
            if l~=chLines.dot then l.Thickness=ct; l.Color=cc end
        end
        chLines.dot.Position=vpc; chLines.dot.Color=cc; chLines.dot.Radius=ct+1
    end

    -- Aimkill
    if cfg.aimkill then
        local t=getAimTarget(cfg.aimbot_fov)
        if t then
            local char=t:FindFirstAncestorOfClass("Model")
            if char then
                local h=char:FindFirstChildOfClass("Humanoid")
                if h and h.Health>0 then
                    pcall(function() h.Health=0 end)
                    pcall(function() h:TakeDamage(h.MaxHealth) end)
                end
            end
        end
    end

    -- Hitbox expand — sadece kafa büyür
    if cfg.hitbox_expand then
        for _,p in ipairs(Players:GetPlayers()) do
            if p==lp then continue end
            local pc=p.Character; if not pc then continue end
            local head=pc:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                head.Size=Vector3.new(cfg.hitbox_size,cfg.hitbox_size,cfg.hitbox_size)
            end
        end
    end

    -- Kill Aura
    if cfg.kill_aura and hrp then
        for _,p in ipairs(Players:GetPlayers()) do
            if p==lp then continue end
            if cfg.aimbot_teamcheck and getTeam(p)==getTeam(lp) then continue end
            local pc=p.Character; if not pc then continue end
            local phrp=pc:FindFirstChild("HumanoidRootPart"); if not phrp then continue end
            if (hrp.Position-phrp.Position).Magnitude<=cfg.kill_aura_range then
                local h=pc:FindFirstChildOfClass("Humanoid")
                if h and h.Health>0 then
                    pcall(function() h:TakeDamage(h.MaxHealth) end)
                    pcall(function() h.Health=0 end)
                end
            end
        end
    end

    -- Reach hack: equip edilen tool'un reach'ini genişlet
    if cfg.reach and lc then
        local tool=lc:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function()
                local handle=tool:FindFirstChild("Handle")
                if handle then
                    -- tool'u fiziksel olarak hedefe yaklaştır (görsel reach)
                    local t=getAimTarget(cfg.aimbot_fov)
                    if t then
                        local dist=(Camera.CFrame.Position-t.Position).Magnitude
                        if dist<=cfg.reach_range then
                            -- remote fire simülasyonu
                            local remote=tool:FindFirstChildOfClass("RemoteEvent")
                            if remote then pcall(function() remote:FireServer(t.Position) end) end
                        end
                    end
                end
            end)
        end
    end

    -- Wallbang
    if cfg.wallbang then
        local h=getWallbangTarget()
        if h and h.Health>0 then
            pcall(function() h:TakeDamage(1) end)
        end
    end

    -- Spectator list
    specLabel.Visible = cfg.spectator_list
    if cfg.spectator_list then
        local text = "👁 Spectators:\n"
        for _,p in ipairs(Players:GetPlayers()) do
            if p==lp then continue end
            local cam=p.Character and p.Character:FindFirstChild("Camera")
            -- check if spectating us via admin spectate or simple camera subject
            local subj = p.CameraSubject
            if subj then
                local char=lp.Character
                if char and (subj==char or subj:IsDescendantOf(char)) then
                    text=text.."• "..p.Name.."\n"
                end
            end
        end
        specLabel.Text=text
    end

    -- ESP
    for _,player in ipairs(Players:GetPlayers()) do
        if player==lp then continue end
        local o=espObjects[player]; if not o then continue end
        local char=player.Character
        if not cfg.esp or not char or not char.Parent then
            hideAllESP(o); continue
        end
        local humanoid=char:FindFirstChildOfClass("Humanoid")
        local hrpP=char:FindFirstChild("HumanoidRootPart")
        local head=char:FindFirstChild("Head")
        if not hrpP or not head or not humanoid or humanoid.Health<=0 then
            hideAllESP(o); continue
        end
        local isEnemy=not cfg.esp_teamcheck or getTeam(player)~=getTeam(lp)
        local col=isEnemy and cfg.esp_color or cfg.esp_friendly_color
        local hVP,_,hZ=w2v(head.Position+Vector3.new(0,0.5,0))
        local fVP=w2v(hrpP.Position-Vector3.new(0,2.5,0))
        local distVal=math.floor((Camera.CFrame.Position-hrpP.Position).Magnitude)
        if hZ<=0 then hideAllESP(o); continue end
        local bH=math.abs(hVP.Y-fVP.Y); local bW=bH*0.55
        local bX=hVP.X-bW/2; local bY=hVP.Y
        o.box.Visible=cfg.esp_box; o.box.Position=Vector2.new(bX,bY); o.box.Size=Vector2.new(bW,bH); o.box.Color=col
        o.name.Visible=cfg.esp_name; o.name.Position=Vector2.new(hVP.X,hVP.Y-14); o.name.Text=player.Name; o.name.Color=col
        o.dist.Visible=cfg.esp_distance; o.dist.Position=Vector2.new(hVP.X,fVP.Y+2); o.dist.Text=distVal.."m"; o.dist.Color=Color3.fromRGB(220,220,220)
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

    -- 2D Radar
    local rSize = cfg.radar_size
    local rX = vpSize.X - rSize - 10
    local rY = 10
    radarBg.Visible=cfg.radar; radarBorder.Visible=cfg.radar; radarCenter.Visible=cfg.radar
    if cfg.radar then
        radarBg.Position=Vector2.new(rX,rY); radarBg.Size=Vector2.new(rSize,rSize)
        radarBorder.Position=Vector2.new(rX,rY); radarBorder.Size=Vector2.new(rSize,rSize)
        radarCenter.Position=Vector2.new(rX+rSize/2,rY+rSize/2)
        -- clear old dots
        for _,d in ipairs(radarDots) do d.dot.Visible=false end
        radarDots={}
        if hrp then
            local myPos=hrp.Position
            local myCF=hrp.CFrame
            for _,player in ipairs(Players:GetPlayers()) do
                if player==lp then continue end
                local pc=player.Character; if not pc then continue end
                local phrp2=pc:FindFirstChild("HumanoidRootPart"); if not phrp2 then continue end
                local rel=myCF:PointToObjectSpace(phrp2.Position)
                local rx=rX+rSize/2 + (rel.X/cfg.radar_range)*(rSize/2)
                local ry=rY+rSize/2 - (rel.Z/cfg.radar_range)*(rSize/2)
                rx=math.clamp(rx,rX+2,rX+rSize-2)
                ry=math.clamp(ry,rY+2,rY+rSize-2)
                local dot=Drawing.new("Circle")
                local isEnemy=not cfg.esp_teamcheck or getTeam(player)~=getTeam(lp)
                dot.Color=isEnemy and Color3.fromRGB(255,50,50) or Color3.fromRGB(0,200,255)
                dot.Filled=true; dot.Radius=4; dot.Position=Vector2.new(rx,ry); dot.Visible=true
                table.insert(radarDots,{dot=dot,player=player})
            end
        end
    end
end)

-- ===== HEARTBEAT =====
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
        -- thumbstick input — joystick'i bozmaz
        local dir=Vector3.zero
        local mv=UserInputService:GetKeysPressed()
        local thumb=UserInputService:GetNavigationGamepads()
        -- mobil joystick state
        local ms=UserInputService:GetStringForKeyCode(Enum.KeyCode.Thumbstick1)
        local lx=0; local ly=0
        for _,gp in ipairs(UserInputService:GetConnectedGamepads()) do
            local state=UserInputService:GetGamepadState(gp)
            for _,axis in ipairs(state) do
                if axis.KeyCode==Enum.KeyCode.Thumbstick1 then lx=axis.Position.X; ly=axis.Position.Y end
            end
        end
        if math.abs(lx)>0.1 or math.abs(ly)>0.1 then
            dir=dir + Camera.CFrame.LookVector*ly + Camera.CFrame.RightVector*lx
        end
        -- klavye fallback (pc)
        for _,k in ipairs(mv) do
            if k.KeyCode==Enum.KeyCode.W then dir=dir+Camera.CFrame.LookVector
            elseif k.KeyCode==Enum.KeyCode.S then dir=dir-Camera.CFrame.LookVector
            elseif k.KeyCode==Enum.KeyCode.A then dir=dir-Camera.CFrame.RightVector
            elseif k.KeyCode==Enum.KeyCode.D then dir=dir+Camera.CFrame.RightVector
            elseif k.KeyCode==Enum.KeyCode.Space then dir=dir+Vector3.new(0,1,0)
            elseif k.KeyCode==Enum.KeyCode.LeftShift then dir=dir-Vector3.new(0,1,0) end
        end
        -- fly up/down butonları
        if _G.FlyUp then dir=dir+Vector3.new(0,1,0) end
        if _G.FlyDown then dir=dir-Vector3.new(0,1,0) end
        bv.Velocity=dir.Magnitude>0 and dir.Unit*cfg.fly_speed or Vector3.zero
    else
        if hrp then local bv=hrp:FindFirstChild("FlyBV"); if bv then bv:Destroy() end end
    end

    -- Bunnyhop
    if cfg.bunnyhop and hum then
        if hum.FloorMaterial~=Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    -- Auto Fire / Rapid Fire — VIM yok (joystick bugu), sadece tool remote
    -- auto fire: sadece FOV içinde düşman varsa ateş et
    if cfg.auto_fire and not cfg.rapid_fire then
        local t = getAimTarget(cfg.aimbot_fov)
        if t and now-lastRapidFire>=0.1 then
            fireOnce(); lastRapidFire=now
        end
    end
    -- rapid fire: delay slider'a bağlı, düşman yoksa da çalışır (hız artırır)
    if cfg.rapid_fire then
        local delay=math.max(cfg.rapid_fire_delay, 0.016)
        if now-lastRapidFire>=delay then
            fireOnce(); lastRapidFire=now
        end
    end

    -- Auto Item
    if cfg.auto_item and hum then
        if now-lastItemSwitch>=cfg.auto_item_delay then
            local backpack=lp:FindFirstChild("Backpack")
            local char=lp.Character
            local items={}
            if char then for _,v in ipairs(char:GetChildren()) do if v:IsA("Tool") then table.insert(items,v) end end end
            if backpack then for _,v in ipairs(backpack:GetChildren()) do if v:IsA("Tool") then table.insert(items,v) end end end
            if #items>0 then
                autoItemIndex=(autoItemIndex%#items)+1
                local tool=items[autoItemIndex]
                if tool then
                    if tool.Parent==backpack then hum:EquipTool(tool)
                    else hum:UnequipTools() end
                end
            end
            lastItemSwitch=now
        end
    end
end)

-- ===== SILENT AIM =====
-- Yöntem 1: hookmetamethod (Synapse X, Script-Ware, KRNL)
local silentHooked = false
if hookmetamethod then
    pcall(function()
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", function(self, key)
            local cc = false
            pcall(function() cc = checkcaller() end)
            if not cc and key == "Hit" and self == mouse then
                if cfg.silent_aim then
                    local t = getAimTarget(cfg.silent_fov)
                    if t then return CFrame.new(t.Position) end
                end
            end
            return oldIndex(self, key)
        end)
        silentHooked = true
    end)
end

-- Yöntem 2: Nam hook (Delta, Fluxus gibi executor'lar)
if not silentHooked and Nam then
    pcall(function()
        Nam.hook(mouse, "Hit", function()
            if cfg.silent_aim then
                local t = getAimTarget(cfg.silent_fov)
                if t then return CFrame.new(t.Position) end
            end
            return rawget(mouse, "Hit")
        end)
        silentHooked = true
    end)
end

-- Yöntem 3: Camera-based silent aim fallback (her executor'da çalışır)
-- ateş anında kamerayı hedefe döndürür, sonra geri alır
if not silentHooked then
    local origFire = fireOnce
    fireOnce = function()
        if cfg.silent_aim then
            local t = getAimTarget(cfg.silent_fov)
            if t then
                local savedCF = Camera.CFrame
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
                origFire()
                task.defer(function()
                    Camera.CFrame = savedCF
                end)
                return
            end
        end
        origFire()
    end
end

-- ===== INFINITE JUMP =====
UserInputService.JumpRequest:Connect(function()
    if cfg.inf_jump then
        local char=lp.Character; if not char then return end
        local h=char:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ===== AC BYPASS =====
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

print("AnonymousH4X v4.0 loaded")

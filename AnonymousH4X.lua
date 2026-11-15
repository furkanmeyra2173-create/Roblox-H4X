-- AnonymousH4X v5.0 | Full Rewrite

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
    esp_distance=true, esp_tracer=true, esp_name=true, esp_teamcheck=false,
    esp_color=Color3.fromRGB(255,50,50),
    esp_friendly_color=Color3.fromRGB(0,200,255),
    esp_v2=false,
    esp_rainbow=false,
    menu_rainbow=false,
    menu_color=Color3.fromRGB(140,0,255),
    radar=false, radar_size=180, radar_range=200,
    crosshair=false, crosshair_size=12, crosshair_gap=4, crosshair_thickness=1,
    crosshair_color=Color3.fromRGB(255,255,255), crosshair_dot=true,
    crosshair_rainbow=false, crosshair_rotate=false, crosshair_rotate_speed=2,
    fov_circle=true, fov_color=Color3.fromRGB(255,255,255),
    aimbot=false, aimbot_fov=150, aimbot_smooth=0.15,
    aimbot_teamcheck=false, aimbot_vischeck=false,
    silent_aim=false, silent_fov=200,
    aimkill=false,
    noclip=false, fly=false, fly_speed=50,
    inf_jump=false, speed=false, speed_value=32,
    bunnyhop=false, anti_aim=false,
    auto_fire=false, rapid_fire=false, rapid_fire_delay=0.05,
    hitbox_expand=false, hitbox_size=8,
    kill_aura=false, kill_aura_range=20,
    reach=false, reach_range=20,
    wallbang=false,
    auto_item=false, auto_item_delay=0.3,
    fullbright=false, no_fog=false,
    spectator_list=false,
    ac_bypass=true,
    one_shot=false,
}

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnonymousH4X"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
local ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ok then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

local MENU_W,MENU_H = 360,400
local TITLE_H = 42
local TAB_H   = 32
local CONTENT_H = MENU_H - TITLE_H - TAB_H

-- ====== MAIN FRAME ======
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,MENU_W,0,MENU_H)
Main.Position = UDim2.new(0.5,-MENU_W/2,0.5,-MENU_H/2)
Main.BackgroundColor3 = Color3.fromRGB(13,13,20)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)

-- outer glow stroke
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(140,0,255)
mainStroke.Thickness = 1.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = Main

-- subtle gradient bg
local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18,10,28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,18)),
}
bgGrad.Rotation = 120
bgGrad.Parent = Main

local contentVisible = true

-- ====== TITLE BAR ======
local TitleBar = Instance.new("TextButton")
TitleBar.Size = UDim2.new(1,0,0,TITLE_H)
TitleBar.BackgroundColor3 = Color3.fromRGB(20,8,36)
TitleBar.BorderSizePixel = 0
TitleBar.Text = ""
TitleBar.AutoButtonColor = false
TitleBar.Parent = Main
Instance.new("UICorner",TitleBar).CornerRadius = UDim.new(0,12)

-- title gradient
local tGrad = Instance.new("UIGradient")
tGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100,0,200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160,0,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80,0,180)),
}
tGrad.Rotation = 90
tGrad.Parent = TitleBar

-- title icon + text
local TitleIcon = Instance.new("TextLabel")
TitleIcon.Text = "⚡"
TitleIcon.Size = UDim2.new(0,30,1,0)
TitleIcon.Position = UDim2.new(0,10,0,0)
TitleIcon.BackgroundTransparency = 1
TitleIcon.TextColor3 = Color3.fromRGB(255,220,100)
TitleIcon.TextSize = 18
TitleIcon.Font = Enum.Font.GothamBold
TitleIcon.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "AnonymousH4X"
TitleLabel.Size = UDim2.new(1,-120,1,0)
TitleLabel.Position = UDim2.new(0,42,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Text = "v5.0"
VersionLabel.Size = UDim2.new(0,40,1,0)
VersionLabel.Position = UDim2.new(1,-90,0,0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.TextColor3 = Color3.fromRGB(180,140,255)
VersionLabel.TextSize = 10
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Parent = TitleBar

-- mini hide indicator
local HideHint = Instance.new("TextLabel")
HideHint.Text = "▼ tap"
HideHint.Size = UDim2.new(0,50,1,0)
HideHint.Position = UDim2.new(1,-52,0,0)
HideHint.BackgroundTransparency = 1
HideHint.TextColor3 = Color3.fromRGB(180,140,255)
HideHint.TextSize = 9
HideHint.Font = Enum.Font.Gotham
HideHint.Parent = TitleBar

-- content holder
local ContentHolder = Instance.new("Frame")
ContentHolder.Size = UDim2.new(1,0,1,-TITLE_H)
ContentHolder.Position = UDim2.new(0,0,0,TITLE_H)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = Main

-- ====== HAX BUTTON ======
local HaxBtn = Instance.new("TextButton")
HaxBtn.Text = "HAX"
HaxBtn.Size = UDim2.new(0,56,0,56)
HaxBtn.Position = UDim2.new(0,8,0.5,-28)
HaxBtn.BackgroundColor3 = Color3.fromRGB(80,0,180)
HaxBtn.TextColor3 = Color3.new(1,1,1)
HaxBtn.TextSize = 12
HaxBtn.Font = Enum.Font.GothamBold
HaxBtn.BorderSizePixel = 0
HaxBtn.ZIndex = 10
HaxBtn.AutoButtonColor = false
HaxBtn.Parent = ScreenGui
Instance.new("UICorner",HaxBtn).CornerRadius = UDim.new(1,0)
local haxStroke = Instance.new("UIStroke")
haxStroke.Color = Color3.fromRGB(180,80,255)
haxStroke.Thickness = 2
haxStroke.Parent = HaxBtn
local haxGrad = Instance.new("UIGradient")
haxGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120,0,220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60,0,160)),
}
haxGrad.Rotation = 90
haxGrad.Parent = HaxBtn

-- ====== AIM BUTTON ======
_G.AimHeld = false
local AimBtn = Instance.new("TextButton")
AimBtn.Text = "🎯"
AimBtn.Size = UDim2.new(0,64,0,64)
AimBtn.Position = UDim2.new(1,-78,1,-78)
AimBtn.BackgroundColor3 = Color3.fromRGB(180,60,0)
AimBtn.TextColor3 = Color3.new(1,1,1)
AimBtn.TextSize = 22
AimBtn.Font = Enum.Font.GothamBold
AimBtn.BorderSizePixel = 0
AimBtn.ZIndex = 10
AimBtn.Visible = false
AimBtn.AutoButtonColor = false
AimBtn.Parent = ScreenGui
Instance.new("UICorner",AimBtn).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke",AimBtn).Color = Color3.fromRGB(255,120,0)
AimBtn.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
        _G.AimHeld=true
        TweenService:Create(AimBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(255,100,0)}):Play()
    end
end)
AimBtn.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
        _G.AimHeld=false
        TweenService:Create(AimBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(180,60,0)}):Play()
    end
end)

-- ====== FLY JOYSTICK PAD (sol alt) ======
_G.FlyUp=false; _G.FlyDown=false
_G.FlyForward=false; _G.FlyBack=false
_G.FlyLeft=false; _G.FlyRight=false

local FlyPad = Instance.new("Frame")
FlyPad.Size=UDim2.new(0,148,0,148)
FlyPad.Position=UDim2.new(0,8,1,-160)
FlyPad.BackgroundColor3=Color3.fromRGB(10,10,18)
FlyPad.BackgroundTransparency=0.3
FlyPad.BorderSizePixel=0
FlyPad.ZIndex=9
FlyPad.Visible=false
FlyPad.Parent=ScreenGui
Instance.new("UICorner",FlyPad).CornerRadius=UDim.new(0,14)
Instance.new("UIStroke",FlyPad).Color=Color3.fromRGB(0,100,200)

local function makeFlyBtn(text,px,py,w,h,gKey)
    local b=Instance.new("TextButton")
    b.Text=text; b.Size=UDim2.new(0,w,0,h)
    b.Position=UDim2.new(0,px,0,py)
    b.BackgroundColor3=Color3.fromRGB(0,70,160)
    b.TextColor3=Color3.new(1,1,1); b.TextSize=16
    b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0
    b.ZIndex=10; b.AutoButtonColor=false; b.Parent=FlyPad
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    b.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
            _G[gKey]=true
            TweenService:Create(b,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(0,140,255)}):Play()
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
            _G[gKey]=false
            TweenService:Create(b,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(0,70,160)}):Play()
        end
    end)
    return b
end

-- layout: W top center, A left, D right, S bottom center, Q up, E down
--          pad = 148px
makeFlyBtn("W",  50, 4,  48,42, "FlyForward")
makeFlyBtn("A",   4,50,  42,48, "FlyLeft")
makeFlyBtn("D", 102,50,  42,48, "FlyRight")
makeFlyBtn("S",  50,102, 48,42, "FlyBack")
-- up/down in center column
makeFlyBtn("↑",  50,50,  22,22, "FlyUp")    -- small center-top
makeFlyBtn("↓",  76,50,  22,22, "FlyDown")  -- small center-bottom
-- flyUpBtn/flyDnBtn references kept for visibility toggle
local flyUpBtn=FlyPad   -- repurpose refs
local flyDnBtn=FlyPad

-- ====== DRAGGABLE ======
local THRESH = 10
local function makeDraggable(handle, target)
    local drag,ds,sp,moved = false,nil,nil,false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true; moved=false; ds=i.Position; sp=target.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            if d.Magnitude>THRESH then
                moved=true
                target.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
            end
        end
    end)
    return function() return moved end
end

local menuMovedFn = makeDraggable(TitleBar,Main)
local haxMovedFn  = makeDraggable(HaxBtn,HaxBtn)

HaxBtn.MouseButton1Click:Connect(function()
    if not haxMovedFn() then
        Main.Visible = not Main.Visible
        TweenService:Create(HaxBtn,TweenInfo.new(0.1),{
            BackgroundColor3=Main.Visible and Color3.fromRGB(80,0,180) or Color3.fromRGB(40,0,100)
        }):Play()
    end
end)
TitleBar.MouseButton1Click:Connect(function()
    if not menuMovedFn() then
        contentVisible = not contentVisible
        ContentHolder.Visible = contentVisible
        Main.Size = contentVisible and UDim2.new(0,MENU_W,0,MENU_H) or UDim2.new(0,MENU_W,0,TITLE_H)
        HideHint.Text = contentVisible and "▼ tap" or "▲ tap"
    end
end)

-- ====== TAB SYSTEM ======
local tabs = {"ESP","AIMBOT","MOVE","COMBAT","VISUAL","MISC"}
local tabColors = {
    ESP     = Color3.fromRGB(255,70,70),
    AIMBOT  = Color3.fromRGB(255,150,0),
    MOVE    = Color3.fromRGB(0,210,110),
    COMBAT  = Color3.fromRGB(255,50,110),
    VISUAL  = Color3.fromRGB(60,150,255),
    MISC    = Color3.fromRGB(160,70,255),
}

-- Tab bar container
local TabBar = Instance.new("Frame")
TabBar.Size=UDim2.new(1,0,0,TAB_H)
TabBar.BackgroundColor3=Color3.fromRGB(14,8,24)
TabBar.BorderSizePixel=0
TabBar.Parent=ContentHolder
local tabLayout=Instance.new("UIListLayout")
tabLayout.FillDirection=Enum.FillDirection.Horizontal
tabLayout.SortOrder=Enum.SortOrder.LayoutOrder
tabLayout.Parent=TabBar

-- Active tab indicator bar (bottom of tab)
local TabIndicator = Instance.new("Frame")
TabIndicator.Size=UDim2.new(0,MENU_W/#tabs-2,0,2)
TabIndicator.Position=UDim2.new(0,1,1,-2)
TabIndicator.BackgroundColor3=tabColors["ESP"]
TabIndicator.BorderSizePixel=0
TabIndicator.Parent=TabBar
Instance.new("UICorner",TabIndicator).CornerRadius=UDim.new(1,0)

-- Content scroll
local ScrollArea = Instance.new("ScrollingFrame")
ScrollArea.Size=UDim2.new(1,0,0,CONTENT_H)
ScrollArea.Position=UDim2.new(0,0,0,TAB_H)
ScrollArea.BackgroundTransparency=1
ScrollArea.BorderSizePixel=0
ScrollArea.ScrollBarThickness=4
ScrollArea.ScrollBarImageColor3=Color3.fromRGB(140,0,255)
ScrollArea.ScrollingDirection=Enum.ScrollingDirection.Y
ScrollArea.CanvasSize=UDim2.new(0,0,0,0)
ScrollArea.Parent=ContentHolder

local ItemList=Instance.new("UIListLayout")
ItemList.SortOrder=Enum.SortOrder.LayoutOrder
ItemList.Padding=UDim.new(0,4)
ItemList.Parent=ScrollArea
local ItemPad=Instance.new("UIPadding")
ItemPad.PaddingLeft=UDim.new(0,10)
ItemPad.PaddingRight=UDim.new(0,10)
ItemPad.PaddingTop=UDim.new(0,8)
ItemPad.PaddingBottom=UDim.new(0,8)
ItemPad.Parent=ScrollArea
ItemList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollArea.CanvasSize=UDim2.new(0,0,0,ItemList.AbsoluteContentSize.Y+20)
end)

local tabBtns={}
local activeTab="ESP"
local tabW=MENU_W/#tabs

for i,tabName in ipairs(tabs) do
    local btn=Instance.new("TextButton")
    btn.Text=tabName
    btn.Size=UDim2.new(0,tabW,1,0)
    btn.BackgroundColor3=Color3.fromRGB(14,8,24)
    btn.TextColor3=Color3.fromRGB(120,100,160)
    btn.Font=Enum.Font.GothamBold
    btn.TextSize=10
    btn.BorderSizePixel=0
    btn.AutoButtonColor=false
    btn.Parent=TabBar
    tabBtns[tabName]=btn

    btn.MouseButton1Click:Connect(function()
        activeTab=tabName
        for n,b in pairs(tabBtns) do
            b.TextColor3=Color3.fromRGB(120,100,160)
            b.BackgroundColor3=Color3.fromRGB(14,8,24)
        end
        btn.TextColor3=tabColors[tabName]
        btn.BackgroundColor3=Color3.fromRGB(20,12,32)
        -- slide indicator
        TweenService:Create(TabIndicator,TweenInfo.new(0.15,Enum.EasingStyle.Quad),{
            Position=UDim2.new(0,(i-1)*tabW+1,1,-2),
            BackgroundColor3=tabColors[tabName],
        }):Play()
        -- rebuild content
        ScrollArea.CanvasPosition=Vector2.zero
        for _,v in ipairs(ScrollArea:GetChildren()) do
            if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then v:Destroy() end
        end
        buildTab(tabName)
    end)
end
-- activate first tab
tabBtns["ESP"].TextColor3=tabColors["ESP"]
tabBtns["ESP"].BackgroundColor3=Color3.fromRGB(20,12,32)

-- ====== UI COMPONENTS ======
local COL_ROW   = Color3.fromRGB(20,14,32)
local COL_ROW_H = Color3.fromRGB(28,18,42)   -- hover
local COL_OFF   = Color3.fromRGB(50,40,65)
local COL_TEXT  = Color3.fromRGB(220,210,240)
local COL_SUB   = Color3.fromRGB(140,120,180)

local function makeToggle(label,cfgKey,color)
    color = color or Color3.fromRGB(140,0,255)
    local row=Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,36)
    row.BackgroundColor3=COL_ROW
    row.BorderSizePixel=0
    row.Parent=ScrollArea
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)

    -- left accent bar
    local accent=Instance.new("Frame")
    accent.Size=UDim2.new(0,3,1,-8)
    accent.Position=UDim2.new(0,0,0,4)
    accent.BackgroundColor3=cfg[cfgKey] and color or COL_OFF
    accent.BorderSizePixel=0
    accent.Parent=row
    Instance.new("UICorner",accent).CornerRadius=UDim.new(1,0)

    local lbl=Instance.new("TextLabel")
    lbl.Text=label
    lbl.Size=UDim2.new(1,-58,1,0)
    lbl.Position=UDim2.new(0,14,0,0)
    lbl.BackgroundTransparency=1
    lbl.TextColor3=COL_TEXT
    lbl.Font=Enum.Font.Gotham
    lbl.TextSize=12
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Parent=row

    -- toggle switch
    local sw=Instance.new("Frame")
    sw.Size=UDim2.new(0,40,0,22)
    sw.Position=UDim2.new(1,-46,0.5,-11)
    sw.BackgroundColor3=cfg[cfgKey] and color or COL_OFF
    sw.BorderSizePixel=0
    sw.Parent=row
    Instance.new("UICorner",sw).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame")
    knob.Size=UDim2.new(0,16,0,16)
    knob.Position=cfg[cfgKey] and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3=Color3.new(1,1,1)
    knob.BorderSizePixel=0
    knob.Parent=sw
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    -- knob shadow
    Instance.new("UIStroke",knob).Color=Color3.fromRGB(0,0,0)

    local hitbox=Instance.new("TextButton")
    hitbox.Size=UDim2.new(1,0,1,0)
    hitbox.BackgroundTransparency=1
    hitbox.Text=""
    hitbox.Parent=row

    local function refresh()
        TweenService:Create(sw,TweenInfo.new(0.14),{BackgroundColor3=cfg[cfgKey] and color or COL_OFF}):Play()
        TweenService:Create(knob,TweenInfo.new(0.14),{Position=cfg[cfgKey] and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)}):Play()
        TweenService:Create(accent,TweenInfo.new(0.14),{BackgroundColor3=cfg[cfgKey] and color or COL_OFF}):Play()
        lbl.TextColor3=cfg[cfgKey] and Color3.new(1,1,1) or COL_TEXT
    end

    hitbox.MouseButton1Click:Connect(function()
        cfg[cfgKey]=not cfg[cfgKey]; refresh()
    end)
    hitbox.MouseEnter:Connect(function()
        TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=COL_ROW_H}):Play()
    end)
    hitbox.MouseLeave:Connect(function()
        TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=COL_ROW}):Play()
    end)
end

local function makeSlider(label,cfgKey,min,max,suffix,isFloat)
    suffix=suffix or ""
    local row=Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,52)
    row.BackgroundColor3=COL_ROW
    row.BorderSizePixel=0
    row.Parent=ScrollArea
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)

    local lbl=Instance.new("TextLabel")
    lbl.Text=label..":  "..tostring(cfg[cfgKey])..suffix
    lbl.Size=UDim2.new(1,-12,0,22)
    lbl.Position=UDim2.new(0,12,0,4)
    lbl.BackgroundTransparency=1
    lbl.TextColor3=COL_TEXT
    lbl.Font=Enum.Font.Gotham
    lbl.TextSize=11
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Parent=row

    -- value badge
    local badge=Instance.new("TextLabel")
    badge.Text=tostring(cfg[cfgKey])..suffix
    badge.Size=UDim2.new(0,70,0,18)
    badge.Position=UDim2.new(1,-78,0,4)
    badge.BackgroundColor3=Color3.fromRGB(30,20,45)
    badge.TextColor3=Color3.fromRGB(180,140,255)
    badge.Font=Enum.Font.GothamBold
    badge.TextSize=10
    badge.BorderSizePixel=0
    badge.Parent=row
    Instance.new("UICorner",badge).CornerRadius=UDim.new(0,4)

    -- track bg
    local trackBg=Instance.new("Frame")
    trackBg.Size=UDim2.new(1,-24,0,8)
    trackBg.Position=UDim2.new(0,12,0,34)
    trackBg.BackgroundColor3=Color3.fromRGB(35,25,55)
    trackBg.BorderSizePixel=0
    trackBg.Parent=row
    Instance.new("UICorner",trackBg).CornerRadius=UDim.new(1,0)

    local fill=Instance.new("Frame")
    fill.Size=UDim2.new(math.clamp((cfg[cfgKey]-min)/(max-min),0,1),0,1,0)
    fill.BackgroundColor3=Color3.fromRGB(140,0,255)
    fill.BorderSizePixel=0
    fill.Parent=trackBg
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local fillGrad=Instance.new("UIGradient")
    fillGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(180,60,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,0,220))}
    fillGrad.Rotation=0; fillGrad.Parent=fill

    -- thumb
    local thumb=Instance.new("Frame")
    local ratio=math.clamp((cfg[cfgKey]-min)/(max-min),0,1)
    thumb.Size=UDim2.new(0,14,0,14)
    thumb.AnchorPoint=Vector2.new(0.5,0.5)
    thumb.Position=UDim2.new(ratio,0,0.5,0)
    thumb.BackgroundColor3=Color3.new(1,1,1)
    thumb.BorderSizePixel=0
    thumb.ZIndex=2
    thumb.Parent=trackBg
    Instance.new("UICorner",thumb).CornerRadius=UDim.new(1,0)
    local tStroke=Instance.new("UIStroke",thumb)
    tStroke.Color=Color3.fromRGB(140,0,255); tStroke.Thickness=1.5

    local drag=false
    trackBg.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local relX=math.clamp((i.Position.X-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
            local val=isFloat and math.floor((min+relX*(max-min))*100)/100 or math.floor(min+relX*(max-min))
            cfg[cfgKey]=val
            fill.Size=UDim2.new(relX,0,1,0)
            thumb.Position=UDim2.new(relX,0,0.5,0)
            local disp=tostring(val)..suffix
            lbl.Text=label..":  "..disp
            badge.Text=disp
        end
    end)
end

local function makeSec(text)
    local wrap=Instance.new("Frame")
    wrap.Size=UDim2.new(1,0,0,22)
    wrap.BackgroundTransparency=1
    wrap.Parent=ScrollArea

    local line=Instance.new("Frame")
    line.Size=UDim2.new(0.3,0,0,1)
    line.Position=UDim2.new(0,0,0.5,0)
    line.BackgroundColor3=Color3.fromRGB(80,40,120)
    line.BorderSizePixel=0
    line.Parent=wrap

    local lbl=Instance.new("TextLabel")
    lbl.Text=text
    lbl.Size=UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency=1
    lbl.TextColor3=Color3.fromRGB(160,100,255)
    lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=10
    lbl.TextXAlignment=Enum.TextXAlignment.Center
    lbl.Parent=wrap

    local line2=Instance.new("Frame")
    line2.Size=UDim2.new(0.3,0,0,1)
    line2.Position=UDim2.new(0.7,0,0.5,0)
    line2.BackgroundColor3=Color3.fromRGB(80,40,120)
    line2.BorderSizePixel=0
    line2.Parent=wrap
end

function buildTab(tab)
    if tab=="ESP" then
        makeSec("ESP")
        makeToggle("Enable ESP","esp",Color3.fromRGB(255,70,70))
        makeToggle("ESP V2 (Vivid/Glow)","esp_v2",Color3.fromRGB(255,0,180))
        makeToggle("ESP Rainbow","esp_rainbow",Color3.fromRGB(255,100,0))
        makeToggle("Box ESP","esp_box"); makeToggle("Skeleton","esp_skeleton")
        makeToggle("Health Bar","esp_health"); makeToggle("Distance","esp_distance")
        makeToggle("Tracers","esp_tracer"); makeToggle("Names","esp_name")
        makeToggle("Team Check","esp_teamcheck")
        makeSec("Radar")
        makeToggle("2D Radar","radar",Color3.fromRGB(0,210,100))
        makeSlider("Radar Size","radar_size",100,350," px")
        makeSlider("Radar Range","radar_range",50,500," st")
        makeSec("Crosshair")
        makeToggle("Crosshair","crosshair",Color3.fromRGB(255,255,255))
        makeToggle("Center Dot","crosshair_dot")
        makeSlider("CH Size","crosshair_size",4,30," px")
        makeSlider("CH Gap","crosshair_gap",0,20," px")
        makeSlider("CH Thickness","crosshair_thickness",1,5," px")
    elseif tab=="AIMBOT" then
        makeSec("Aimbot")
        makeToggle("Aimbot (Auto)","aimbot",Color3.fromRGB(255,150,0))
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
        makeToggle("Noclip","noclip",Color3.fromRGB(0,210,110))
        makeToggle("Fly","fly",Color3.fromRGB(0,170,255))
        makeSlider("Fly Speed","fly_speed",10,400," ws")
        makeToggle("Infinite Jump","inf_jump",Color3.fromRGB(0,210,110))
        makeToggle("Bunnyhop","bunnyhop",Color3.fromRGB(0,210,110))
        makeToggle("Speed Hack","speed",Color3.fromRGB(0,210,110))
        makeSlider("Walk Speed","speed_value",16,250," ws")
        makeToggle("Anti-Aim","anti_aim",Color3.fromRGB(255,70,70))
    elseif tab=="COMBAT" then
        makeSec("Combat")
        makeToggle("One Shot (99999 dmg)","one_shot",Color3.fromRGB(255,0,0))
        makeToggle("Auto Fire (on enemy)","auto_fire",Color3.fromRGB(255,50,110))
        makeToggle("Rapid Fire","rapid_fire",Color3.fromRGB(255,20,70))
        makeSlider("Rapid Delay","rapid_fire_delay",0.01,0.5," s",true)
        makeSec("Damage")
        makeToggle("Wallbang","wallbang",Color3.fromRGB(255,120,0))
        makeToggle("Kill Aura","kill_aura",Color3.fromRGB(255,0,80))
        makeSlider("Kill Aura Range","kill_aura_range",5,50," st")
        makeToggle("Reach Hack","reach",Color3.fromRGB(255,80,0))
        makeSlider("Reach Range","reach_range",5,50," st")
        makeSec("Hitbox")
        makeToggle("Hitbox Expand (Head)","hitbox_expand",Color3.fromRGB(255,50,110))
        makeSlider("Hitbox Size","hitbox_size",2,20," st")
        makeSec("Auto Item")
        makeToggle("Auto Item Switch","auto_item",Color3.fromRGB(255,180,0))
        makeSlider("Switch Delay","auto_item_delay",0.1,2," s",true)
    elseif tab=="VISUAL" then
        makeSec("Visual")
        makeToggle("FullBright","fullbright",Color3.fromRGB(60,150,255))
        makeToggle("No Fog","no_fog",Color3.fromRGB(60,150,255))
        makeSec("Menu Color")
        makeToggle("Menu Rainbow","menu_rainbow",Color3.fromRGB(255,100,0))
        makeSec("Crosshair")
        makeToggle("Crosshair Rainbow","crosshair_rainbow",Color3.fromRGB(255,100,0))
        makeToggle("Crosshair Rotate","crosshair_rotate",Color3.fromRGB(0,200,255))
        makeSlider("Rotate Speed","crosshair_rotate_speed",1,20," x")
    elseif tab=="MISC" then
        makeSec("Misc")
        makeToggle("Spectator List","spectator_list",Color3.fromRGB(160,70,255))
        makeToggle("AC Bypass","ac_bypass",Color3.fromRGB(160,70,255))
    end
end
buildTab("ESP")

-- ===== DRAWINGS =====
local function newD(type_,props)
    local d=Drawing.new(type_)
    for k,v in pairs(props) do pcall(function() d[k]=v end) end
    return d
end

-- Crosshair
local ch={
    top=newD("Line",{Visible=false,Thickness=1}),
    bot=newD("Line",{Visible=false,Thickness=1}),
    left=newD("Line",{Visible=false,Thickness=1}),
    right=newD("Line",{Visible=false,Thickness=1}),
    dot=newD("Circle",{Visible=false,Filled=true,Radius=2}),
}
-- FOV
local fovCircle=newD("Circle",{Visible=false,Filled=false,Thickness=1,NumSides=64,Color=Color3.new(1,1,1)})
-- Radar
local radarBg=newD("Square",{Visible=false,Filled=true,Color=Color3.fromRGB(10,10,10),Transparency=0.5})
local radarBorder=newD("Square",{Visible=false,Filled=false,Color=Color3.fromRGB(160,0,255),Thickness=1})
local radarCenter=newD("Circle",{Visible=false,Filled=true,Color=Color3.fromRGB(0,200,255),Radius=4})
local radarDots={}
-- Spectator
local specLabel=Instance.new("TextLabel")
specLabel.Size=UDim2.new(0,180,0,200); specLabel.Position=UDim2.new(1,-190,0,50)
specLabel.BackgroundColor3=Color3.fromRGB(10,10,15); specLabel.BackgroundTransparency=0.3
specLabel.BorderSizePixel=0; specLabel.TextColor3=Color3.fromRGB(220,180,255)
specLabel.Font=Enum.Font.Gotham; specLabel.TextSize=10; specLabel.TextXAlignment=Enum.TextXAlignment.Left
specLabel.TextYAlignment=Enum.TextYAlignment.Top; specLabel.Visible=false; specLabel.ZIndex=5
specLabel.Parent=ScreenGui
Instance.new("UICorner",specLabel).CornerRadius=UDim.new(0,6)

-- ===== ESP OBJECTS =====
local espObjects={}
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
            elseif type(obj)=="table" then for _,o in pairs(obj) do if typeof(o)=="Instance" then o:Remove() end end end
        end)
    end
    espObjects[player]=nil
end

local function setupESP(player)
    if player==lp then return end
    cleanESP(player)
    local o={}
    o.box=newD("Square",{Visible=false,Thickness=1.5,Filled=false})
    o.name=newD("Text",{Visible=false,Size=12,Center=true,Font=Drawing.Fonts.UI})
    o.dist=newD("Text",{Visible=false,Size=10,Center=true,Font=Drawing.Fonts.UI})
    o.hbBg=newD("Square",{Visible=false,Filled=true,Color=Color3.fromRGB(30,30,30)})
    o.hbFill=newD("Square",{Visible=false,Filled=true})
    o.tracer=newD("Line",{Visible=false,Thickness=1})
    local skel={}
    for i=1,#skelConn do skel[i]=newD("Line",{Visible=false,Thickness=1}) end
    o.skel=skel
    espObjects[player]=o
end

local function hideAll(o)
    for _,obj in pairs(o) do
        pcall(function()
            if typeof(obj)=="Instance" then obj.Visible=false
            elseif type(obj)=="table" then for _,x in pairs(obj) do x.Visible=false end end
        end)
    end
end

-- ===== PLAYER/BOT TRACKING =====
-- Hem Players hem de workspace'teki NPC/Bot'ları track et
local trackedEntities = {} -- {model, humanoid, isPlayer}

local function getTeam(p) return p and p.Team or nil end

local function addModel(model)
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if not espObjects[model] then
        setupESP(model)
    end
    trackedEntities[model] = {model=model, humanoid=hum, isPlayer=false}
end

local function registerPlayer(p)
    if p==lp then return end
    local function onChar(char)
        task.wait(0.5)
        setupESP(p)
        local ent={model=char,humanoid=char:FindFirstChildOfClass("Humanoid"),isPlayer=true,player=p}
        trackedEntities[p]=ent
        -- öldüğünde ESP'yi hemen gizle/temizle
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                task.wait(0.1)
                -- sadece hide et, temizleme CharacterAdded'da olur
                local o=espObjects[p]
                if o then hideAll(o) end
            end)
        end
        -- karakter kaldırılınca (spawn/ölüm) temizle
        char.AncestryChanged:Connect(function(_,newParent)
            if not newParent then
                local o=espObjects[p]; if o then hideAll(o) end
            end
        end)
    end
    p.CharacterAdded:Connect(onChar)
    if p.Character then onChar(p.Character) end
end

Players.PlayerAdded:Connect(registerPlayer)
Players.PlayerRemoving:Connect(function(p)
    -- hemen gizle
    local o=espObjects[p]; if o then hideAll(o) end
    task.wait(0.05)
    cleanESP(p)
    trackedEntities[p]=nil
    for i,d in ipairs(radarDots) do
        if d.key==p then pcall(function() d.dot:Remove() end); table.remove(radarDots,i); break end
    end
end)
for _,p in ipairs(Players:GetPlayers()) do
    registerPlayer(p)
end

local function registerNPC(model)
    if model==lp.Character or Players:GetPlayerFromCharacter(model) then return end
    local hum=model:FindFirstChildOfClass("Humanoid"); if not hum then return end
    setupESP(model)
    trackedEntities[model]={model=model,humanoid=hum,isPlayer=false}
    hum.Died:Connect(function()
        task.wait(0.05)
        local o=espObjects[model]; if o then hideAll(o) end
    end)
    model.AncestryChanged:Connect(function(_,newParent)
        if not newParent then
            local o=espObjects[model]; if o then hideAll(o) end
            task.wait(0.05); cleanESP(model); trackedEntities[model]=nil
        end
    end)
end

workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("Model") and desc~=workspace then
        task.wait(0.1); registerNPC(desc)
    end
end)
for _,desc in ipairs(workspace:GetDescendants()) do
    if desc:IsA("Model") then registerNPC(desc) end
end

-- ===== AIM TARGET (players + NPCs) =====
local function w2v(pos)
    local vp,inView=Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X,vp.Y),inView,vp.Z
end

local function getAimTarget(fovLimit)
    local best=fovLimit; local target=nil
    local vc=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    for key,ent in pairs(trackedEntities) do
        if ent.isPlayer and ent.player==lp then continue end
        if ent.isPlayer and cfg.aimbot_teamcheck and getTeam(ent.player)==getTeam(lp) then continue end
        local model=ent.model; if not model or not model.Parent then continue end
        local head=model:FindFirstChild("Head"); if not head then continue end
        local hum=ent.humanoid; if not hum or hum.Health<=0 then continue end
        if cfg.aimbot_vischeck then
            local ray=Ray.new(Camera.CFrame.Position,(head.Position-Camera.CFrame.Position).Unit*1000)
            local hit=workspace:FindPartOnRayWithIgnoreList(ray,{lc,Camera})
            if hit and not hit:IsDescendantOf(model) then continue end
        end
        local vp,inView=w2v(head.Position); if not inView then continue end
        local d=(vp-vc).Magnitude
        if d<best then best=d; target=head end
    end
    return target
end

-- ===== FIRE ONCE =====
fireOnce = function()
    pcall(function()
        local char=lp.Character; if not char then return end
        local tool=char:FindFirstChildOfClass("Tool"); if not tool then return end

        -- one shot: aim target'a direkt TakeDamage + remote fire with damage arg
        if cfg.one_shot then
            local t=getAimTarget(cfg.aimbot_fov)
            if t then
                local model=t:FindFirstAncestorOfClass("Model")
                if model then
                    local h=model:FindFirstChildOfClass("Humanoid")
                    if h and h.Health>0 then
                        pcall(function() h:TakeDamage(99999) end)
                        pcall(function() h.Health=0 end)
                        -- remote fire with damage payload (bazı oyunlar damage değeri alır)
                        for _,v in ipairs(tool:GetDescendants()) do
                            if v:IsA("RemoteEvent") then
                                -- çeşitli argüman kombinasyonlarını dene
                                pcall(function() v:FireServer(t.Position,t,99999) end)
                                pcall(function() v:FireServer(t.Position,t) end)
                                pcall(function() v:FireServer(99999) end)
                                break
                            end
                        end
                    end
                end
            end
            return
        end

        -- normal fire
        for _,v in ipairs(tool:GetDescendants()) do
            if v:IsA("RemoteEvent") then pcall(function() v:FireServer() end); break end
        end
        pcall(function()
            local ev=tool:FindFirstChild("Activated")
            if ev then ev:Fire() end
        end)
    end)
end

-- ===== SILENT AIM =====
-- Yöntem 1: hookmetamethod
local silentHooked=false
if hookmetamethod then
    pcall(function()
        local oi
        oi=hookmetamethod(game,"__index",function(self,key)
            local cc=false; pcall(function() cc=checkcaller() end)
            if not cc and key=="Hit" and self==mouse and cfg.silent_aim then
                local t=getAimTarget(cfg.silent_fov)
                if t then return CFrame.new(t.Position) end
            end
            return oi(self,key)
        end)
        silentHooked=true
    end)
end
-- Yöntem 2: Nam (Delta/Fluxus)
if not silentHooked and Nam then
    pcall(function()
        Nam.hook(mouse,"Hit",function()
            if cfg.silent_aim then
                local t=getAimTarget(cfg.silent_fov)
                if t then return CFrame.new(t.Position) end
            end
            return rawget(mouse,"Hit")
        end)
        silentHooked=true
    end)
end
-- Yöntem 3: camera snap fallback — ateş anında kamera döner, 1 frame sonra geri
if not silentHooked then
    local orig=fireOnce
    fireOnce=function()
        if cfg.silent_aim then
            local t=getAimTarget(cfg.silent_fov)
            if t then
                local saved=Camera.CFrame
                Camera.CFrame=CFrame.new(Camera.CFrame.Position,t.Position)
                orig()
                task.defer(function() Camera.CFrame=saved end)
                return
            end
        end
        orig()
    end
end

-- state
local lastFire=0; local lastItem=0; local itemIdx=1
local rainbowHue=0        -- 0-1, shared rainbow hue
local crossAngle=0        -- crosshair rotation degrees
local espV2Pulse=0        -- V2 glow pulse

-- ===== FLY JOYSTICK UI (sol taraf) =====
_G.FlyDir=Vector3.zero
local flyPad=Instance.new("Frame")
flyPad.Size=UDim2.new(0,130,0,130)
flyPad.Position=UDim2.new(0,10,1,-148)
flyPad.BackgroundColor3=Color3.fromRGB(15,10,25)
flyPad.BackgroundTransparency=0.3
flyPad.BorderSizePixel=0
flyPad.ZIndex=10
flyPad.Visible=false
flyPad.Parent=ScreenGui
Instance.new("UICorner",flyPad).CornerRadius=UDim.new(0,10)
Instance.new("UIStroke",flyPad).Color=Color3.fromRGB(0,100,200)

local function makeDirBtn(text,gx,gy,dx,dy,dz)
    local b=Instance.new("TextButton")
    b.Text=text; b.Size=UDim2.new(0,38,0,38)
    b.Position=UDim2.new(0,gx,0,gy)
    b.BackgroundColor3=Color3.fromRGB(0,80,180)
    b.TextColor3=Color3.new(1,1,1); b.TextSize=16
    b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0
    b.ZIndex=11; b.AutoButtonColor=false; b.Parent=flyPad
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    b.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
            _G.FlyDir=_G.FlyDir+Vector3.new(dx,dy,dz)
            TweenService:Create(b,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(0,140,255)}):Play()
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
            _G.FlyDir=_G.FlyDir-Vector3.new(dx,dy,dz)
            TweenService:Create(b,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(0,80,180)}):Play()
        end
    end)
end
-- layout: forward/back/left/right/up/down
makeDirBtn("▲", 46, 4,  0,0,-1)   -- forward
makeDirBtn("▼", 46, 88, 0,0, 1)   -- back
makeDirBtn("◀",  4, 46,-1,0, 0)   -- left
makeDirBtn("▶", 88, 46, 1,0, 0)   -- right
makeDirBtn("↑", 46, 46, 0,1, 0)   -- up (center)
-- up/down separate small buttons
local udFrame=Instance.new("Frame")
udFrame.Size=UDim2.new(0,38,0,88)
udFrame.Position=UDim2.new(0,138,0,46)
udFrame.BackgroundTransparency=1; udFrame.ZIndex=10; udFrame.Visible=false; udFrame.Parent=ScreenGui
-- actually embed up/down in pad
makeDirBtn("U", 46,46, 0, 1,0)  -- already above, override
-- simpler: replace center with up, add separate row
-- clear and redo
for _,v in ipairs(flyPad:GetChildren()) do
    if v:IsA("TextButton") and v.Text=="U" then v:Destroy() end
end
-- center = UP
makeDirBtn("⬆", 46, 46, 0, 1, 0)  -- up

-- separate DOWN button below pad
local flyDownBig=Instance.new("TextButton")
flyDownBig.Text="⬇"; flyDownBig.Size=UDim2.new(0,38,0,38)
flyDownBig.Position=UDim2.new(0,56,1,-42)
flyDownBig.BackgroundColor3=Color3.fromRGB(0,80,180)
flyDownBig.TextColor3=Color3.new(1,1,1); flyDownBig.TextSize=16
flyDownBig.Font=Enum.Font.GothamBold; flyDownBig.BorderSizePixel=0
flyDownBig.ZIndex=11; flyDownBig.AutoButtonColor=false; flyDownBig.Visible=false
flyDownBig.Parent=ScreenGui
Instance.new("UICorner",flyDownBig).CornerRadius=UDim.new(0,8)
flyDownBig.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
        _G.FlyDown=true
        TweenService:Create(flyDownBig,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(0,140,255)}):Play()
    end
end)
flyDownBig.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
        _G.FlyDown=false
        TweenService:Create(flyDownBig,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(0,80,180)}):Play()
    end
end)

-- ===== RENDER LOOP =====
local antiAimAngle=0
RunService.RenderStepped:Connect(function()
    lc=lp.Character; if not lc then return end
    local hum=lc:FindFirstChildOfClass("Humanoid")
    local hrp=lc:FindFirstChild("HumanoidRootPart")
    local vpSize=Camera.ViewportSize
    local vpc=Vector2.new(vpSize.X/2,vpSize.Y/2)

    -- Rainbow tick (shared hue)
    rainbowHue=(rainbowHue+0.004)%1
    espV2Pulse=(espV2Pulse+0.05)%1
    crossAngle=(crossAngle+cfg.crosshair_rotate_speed*0.5)%360

    local rbColor=Color3.fromHSV(rainbowHue,1,1)

    -- Menu stroke rainbow
    if cfg.menu_rainbow then
        mainStroke.Color=rbColor
        mainStroke.Thickness=2
    else
        mainStroke.Color=cfg.menu_color
        mainStroke.Thickness=1.5
    end

    -- Resolve active ESP color (rainbow overrides)
    local activeESPColor = cfg.esp_rainbow and rbColor or cfg.esp_color

    -- Speed
    if hum then hum.WalkSpeed=cfg.speed and cfg.speed_value or 16 end

    -- Fullbright/NoFog
    if cfg.fullbright then
        Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.FogEnd=100000
        Lighting.GlobalShadows=false; Lighting.Ambient=Color3.new(1,1,1); Lighting.OutdoorAmbient=Color3.new(1,1,1)
    end
    if cfg.no_fog then Lighting.FogEnd=100000; Lighting.FogStart=100000 end

    -- Anti-Aim — HRP'yi döndür, kamera değil
    if cfg.anti_aim and hrp then
        antiAimAngle=(antiAimAngle+15)%360
        hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(0,math.rad(antiAimAngle),0)
    end

    -- Aimbot — sürekli aktif (hold olmadan), sadece hedef varken döner
    if cfg.aimbot then
        local t=getAimTarget(cfg.aimbot_fov)
        if t then
            local targetCF=CFrame.new(Camera.CFrame.Position,t.Position)
            Camera.CFrame=Camera.CFrame:Lerp(targetCF,cfg.aimbot_smooth)
        end
    end
    AimBtn.Visible=false -- artık hold lazım değil, butonu gizle

    -- Aimkill — hedef yakınsa tool remote fire + damage
    if cfg.aimkill then
        local t=getAimTarget(cfg.aimbot_fov)
        if t then
            local model=t:FindFirstAncestorOfClass("Model")
            if model then
                local h=model:FindFirstChildOfClass("Humanoid")
                if h and h.Health>0 then
                    -- local damage dene
                    pcall(function() h.Health=0 end)
                    pcall(function() h:TakeDamage(9999) end)
                    -- tool remote fire (en güvenilir yol)
                    pcall(function()
                        local myChar=lp.Character; if not myChar then return end
                        local tool=myChar:FindFirstChildOfClass("Tool"); if not tool then return end
                        for _,v in ipairs(tool:GetDescendants()) do
                            if v:IsA("RemoteEvent") then v:FireServer(t.Position,t); break end
                        end
                    end)
                end
            end
        end
    end

    -- Hitbox expand — sadece Head, local only
    -- NOT: server-side hit detection olan oyunlarda hasar için "Reach" kullan
    if cfg.hitbox_expand then
        for key,ent in pairs(trackedEntities) do
            if ent.isPlayer and ent.player==lp then continue end
            local model=ent.model; if not model or not model.Parent then continue end
            local head=model:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                -- CFrame'i koru, sadece size değiştir
                local cf=head.CFrame
                head.Size=Vector3.new(cfg.hitbox_size,cfg.hitbox_size,cfg.hitbox_size)
                head.CFrame=cf
            end
        end
    end

    -- Kill Aura — hitbox expand + tool remote + TakeDamage üçlüsü
    if cfg.kill_aura and hrp then
        for key,ent in pairs(trackedEntities) do
            if ent.isPlayer and ent.player==lp then continue end
            if ent.isPlayer and cfg.aimbot_teamcheck and getTeam(ent.player)==getTeam(lp) then continue end
            local model=ent.model; if not model or not model.Parent then continue end
            local ehrp=model:FindFirstChild("HumanoidRootPart"); if not ehrp then continue end
            local h=ent.humanoid; if not h or h.Health<=0 then continue end
            local dist=(hrp.Position-ehrp.Position).Magnitude
            if dist<=cfg.kill_aura_range then
                -- tüm yolları dene
                pcall(function() h:TakeDamage(99999) end)
                pcall(function() h.Health=0 end)
                -- tool remote
                pcall(function()
                    local myChar=lp.Character; if not myChar then return end
                    local tool=myChar:FindFirstChildOfClass("Tool"); if not tool then return end
                    for _,v in ipairs(tool:GetDescendants()) do
                        if v:IsA("RemoteEvent") then
                            v:FireServer(ehrp.Position,ehrp,99999)
                            v:FireServer(ehrp.Position,ehrp)
                            break
                        end
                    end
                end)
                -- noclip stye: teleport tool handle to target briefly
                pcall(function()
                    local myChar=lp.Character; if not myChar then return end
                    local tool=myChar:FindFirstChildOfClass("Tool"); if not tool then return end
                    local handle=tool:FindFirstChild("Handle"); if not handle then return end
                    local orig=handle.CFrame
                    handle.CFrame=CFrame.new(ehrp.Position)
                    task.defer(function() pcall(function() handle.CFrame=orig end) end)
                end)
            end
        end
    end

    -- FOV Circle
    fovCircle.Visible=cfg.fov_circle
    if cfg.fov_circle then
        local fovCol=cfg.esp_rainbow and rbColor or cfg.fov_color
        fovCircle.Position=vpc; fovCircle.Radius=cfg.aimbot_fov; fovCircle.Color=fovCol
    end

    -- Crosshair (rotation + rainbow)
    if cfg.crosshair then
        local cs=cfg.crosshair_size; local cg=cfg.crosshair_gap; local ct=cfg.crosshair_thickness
        local cc=cfg.crosshair_rainbow and rbColor or cfg.crosshair_color
        local ang=cfg.crosshair_rotate and math.rad(crossAngle) or 0
        local cos_a,sin_a=math.cos(ang),math.sin(ang)
        local function rotPt(dx,dy)
            return Vector2.new(vpc.X+dx*cos_a-dy*sin_a, vpc.Y+dx*sin_a+dy*cos_a)
        end
        ch.top.Visible=true;   ch.top.From=rotPt(0,-cg);    ch.top.To=rotPt(0,-cg-cs);    ch.top.Thickness=ct;    ch.top.Color=cc
        ch.bot.Visible=true;   ch.bot.From=rotPt(0, cg);    ch.bot.To=rotPt(0, cg+cs);    ch.bot.Thickness=ct;    ch.bot.Color=cc
        ch.left.Visible=true;  ch.left.From=rotPt(-cg,0);   ch.left.To=rotPt(-cg-cs,0);   ch.left.Thickness=ct;   ch.left.Color=cc
        ch.right.Visible=true; ch.right.From=rotPt(cg,0);   ch.right.To=rotPt(cg+cs,0);   ch.right.Thickness=ct;  ch.right.Color=cc
        ch.dot.Visible=cfg.crosshair_dot; ch.dot.Position=vpc; ch.dot.Color=cc; ch.dot.Radius=ct+1
    else
        for _,v in pairs(ch) do pcall(function() v.Visible=false end) end
    end

    -- Spectator list
    specLabel.Visible=cfg.spectator_list
    if cfg.spectator_list then
        local text="Spectators:\n"
        for _,p in ipairs(Players:GetPlayers()) do
            if p==lp then continue end
            pcall(function()
                if p.CameraSubject and lc and p.CameraSubject:IsDescendantOf(lc) then
                    text=text.."• "..p.Name.."\n"
                end
            end)
        end
        specLabel.Text=text
    end

    -- ESP — players + NPCs
    local allKeys={}
    for key,_ in pairs(espObjects) do table.insert(allKeys,key) end

    for _,key in ipairs(allKeys) do
        local o=espObjects[key]; if not o then continue end
        -- entity bilgisini bul
        local ent=trackedEntities[key]
        local model,humanoid
        if ent then
            model=ent.model; humanoid=ent.humanoid
        elseif typeof(key)=="Instance" and key:IsA("Player") then
            model=key.Character
            humanoid=model and model:FindFirstChildOfClass("Humanoid")
        else
            model=key
            humanoid=model and model:FindFirstChildOfClass("Humanoid")
        end

        if not cfg.esp or not model or not model.Parent then hideAll(o); continue end
        if not humanoid or humanoid.Health<=0 then hideAll(o); continue end

        local hrpP=model:FindFirstChild("HumanoidRootPart")
        local head=model:FindFirstChild("Head")
        if not hrpP or not head then hideAll(o); continue end

        -- team check sadece player için
        local isEnemy=true
        if ent and ent.isPlayer and cfg.esp_teamcheck then
            isEnemy = getTeam(ent.player)~=getTeam(lp)
        end
        -- V2: per-entity rainbow offset for vivid effect
        local col
        if cfg.esp_rainbow then
            -- each entity gets slightly different hue
            local entityHue=(rainbowHue + (key and (typeof(key)=="Instance" and key:GetAttribute("_hueOff") or 0) or 0))%1
            if typeof(key)=="Instance" and not key:GetAttribute("_hueOff") then
                pcall(function() key:SetAttribute("_hueOff", math.random()*0.3) end)
            end
            col=Color3.fromHSV(entityHue,1,1)
        else
            col = isEnemy and activeESPColor or cfg.esp_friendly_color
        end

        -- V2 vivid: pulse thickness + brighter color
        local v2thick = cfg.esp_v2 and (1.5+math.sin(espV2Pulse*math.pi*2)*0.8) or 1.5
        local v2col = cfg.esp_v2 and Color3.fromHSV(Color3.toHSV(col)) or col
        -- V2 makes color fully saturated+bright
        if cfg.esp_v2 then
            local h2,s2,_ = Color3.toHSV(col)
            v2col = Color3.fromHSV(h2, 1, 1)
        end
        col = v2col

        local hVP,_,hZ=w2v(head.Position+Vector3.new(0,0.5,0))
        local fVP=w2v(hrpP.Position-Vector3.new(0,2.5,0))
        local distVal=math.floor((Camera.CFrame.Position-hrpP.Position).Magnitude)

        if hZ<=0 then hideAll(o); continue end

        local bH=math.abs(hVP.Y-fVP.Y); local bW=bH*0.55
        local bX=hVP.X-bW/2; local bY=hVP.Y

        pcall(function()
            o.box.Visible=cfg.esp_box; o.box.Position=Vector2.new(bX,bY); o.box.Size=Vector2.new(bW,bH)
            o.box.Color=col; o.box.Thickness=v2thick
            -- V2: corner-only box illusion via thicker lines
            if cfg.esp_v2 then o.box.Thickness=v2thick+0.5 end
            o.name.Visible=cfg.esp_name; o.name.Position=Vector2.new(hVP.X,hVP.Y-14)
            local dispName=(ent and ent.isPlayer and ent.player) and ent.player.Name or model.Name
            o.name.Text=dispName; o.name.Color=col
            o.name.Size=cfg.esp_v2 and 14 or 12
            o.dist.Visible=cfg.esp_distance; o.dist.Position=Vector2.new(hVP.X,fVP.Y+2); o.dist.Text=distVal.."m"
            o.dist.Color=cfg.esp_v2 and col or Color3.fromRGB(220,220,220)
            local hp=humanoid.Health; local maxhp=humanoid.MaxHealth
            local hpr=math.clamp(hp/maxhp,0,1)
            o.hbBg.Visible=cfg.esp_health; o.hbBg.Position=Vector2.new(bX-7,bY); o.hbBg.Size=Vector2.new(5,bH)
            o.hbFill.Visible=cfg.esp_health; o.hbFill.Position=Vector2.new(bX-7,bY+bH*(1-hpr)); o.hbFill.Size=Vector2.new(5,bH*hpr)
            o.hbFill.Color=Color3.fromRGB(math.floor(255*(1-hpr)),math.floor(255*hpr),50)
            o.tracer.Visible=cfg.esp_tracer; o.tracer.From=Vector2.new(vpc.X,vpSize.Y)
            o.tracer.To=Vector2.new(hVP.X,hVP.Y); o.tracer.Color=col; o.tracer.Thickness=cfg.esp_v2 and 1.5 or 1
        end)

        -- Skeleton
        if cfg.esp_skeleton then
            for i,conn in ipairs(skelConn) do
                pcall(function()
                    local line=o.skel[i]
                    local p1=model:FindFirstChild(conn[1]); local p2=model:FindFirstChild(conn[2])
                    if p1 and p2 then
                        local s1,v1=w2v(p1.Position); local s2,v2=w2v(p2.Position)
                        line.Visible=v1 and v2; line.From=s1; line.To=s2; line.Color=col
                    else line.Visible=false end
                end)
            end
        else
            for _,l in ipairs(o.skel) do pcall(function() l.Visible=false end) end
        end
    end

    -- 2D Radar
    local rSize=cfg.radar_size; local rX=vpSize.X-rSize-10; local rY=10
    radarBg.Visible=cfg.radar; radarBorder.Visible=cfg.radar; radarCenter.Visible=cfg.radar
    for _,d in ipairs(radarDots) do pcall(function() d.dot.Visible=false end) end
    radarDots={}
    if cfg.radar and hrp then
        radarBg.Position=Vector2.new(rX,rY); radarBg.Size=Vector2.new(rSize,rSize)
        radarBorder.Position=Vector2.new(rX,rY); radarBorder.Size=Vector2.new(rSize,rSize)
        radarCenter.Position=Vector2.new(rX+rSize/2,rY+rSize/2)
        for key,ent in pairs(trackedEntities) do
            if ent.isPlayer and ent.player==lp then continue end
            local model=ent.model; if not model or not model.Parent then continue end
            local ehrp=model:FindFirstChild("HumanoidRootPart"); if not ehrp then continue end
            local h=ent.humanoid; if not h or h.Health<=0 then continue end
            local rel=hrp.CFrame:PointToObjectSpace(ehrp.Position)
            local rx=rX+rSize/2+(rel.X/cfg.radar_range)*(rSize/2)
            local ry=rY+rSize/2-(rel.Z/cfg.radar_range)*(rSize/2)
            rx=math.clamp(rx,rX+2,rX+rSize-2); ry=math.clamp(ry,rY+2,rY+rSize-2)
            local dot=newD("Circle",{Filled=true,Radius=4,Position=Vector2.new(rx,ry),Visible=true,
                Color=cfg.esp_teamcheck and getTeam(ent.player)~=getTeam(lp) and Color3.fromRGB(255,50,50) or Color3.fromRGB(255,50,50)})
            table.insert(radarDots,{dot=dot,key=key})
        end
    end

    -- button visibility
    flyPad.Visible=cfg.fly
    flyDownBig.Visible=cfg.fly
    flyUpBtn.Visible=false   -- replaced by flyPad
    flyDnBtn.Visible=false
    AimBtn.Visible=false
end)

-- ===== HEARTBEAT =====
RunService.Heartbeat:Connect(function()
    lc=lp.Character; if not lc then return end
    local hrp=lc:FindFirstChild("HumanoidRootPart")
    local hum=lc:FindFirstChildOfClass("Humanoid")
    local now=tick()

    if cfg.noclip then
        for _,p in ipairs(lc:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end

    if cfg.fly and hrp then
        local bv=hrp:FindFirstChild("FlyBV") or Instance.new("BodyVelocity",hrp)
        bv.Name="FlyBV"; bv.MaxForce=Vector3.new(1e5,1e5,1e5)
        local dir=Vector3.zero
        -- thumbstick
        for _,gp in ipairs(UserInputService:GetConnectedGamepads()) do
            pcall(function()
                local state=UserInputService:GetGamepadState(gp)
                for _,axis in ipairs(state) do
                    if axis.KeyCode==Enum.KeyCode.Thumbstick1 then
                        dir=dir+Camera.CFrame.LookVector*axis.Position.Y+Camera.CFrame.RightVector*axis.Position.X
                    end
                end
            end)
        end
        if _G.FlyUp then dir=dir+Vector3.new(0,1,0) end
        if _G.FlyDown then dir=dir-Vector3.new(0,1,0) end
        -- joystick pad directional input
        if _G.FlyDir and _G.FlyDir.Magnitude>0 then
            local fd=_G.FlyDir
            dir=dir + Camera.CFrame.RightVector*fd.X + Vector3.new(0,fd.Y,0) + Camera.CFrame.LookVector*(-fd.Z)
        end
        bv.Velocity=dir.Magnitude>0 and dir.Unit*cfg.fly_speed or Vector3.zero
    else
        if hrp then local bv=hrp:FindFirstChild("FlyBV"); if bv then bv:Destroy() end end
    end

    if cfg.bunnyhop and hum and hum.FloorMaterial~=Enum.Material.Air then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    -- Auto fire — FOV içinde hedef varsa
    if cfg.auto_fire and not cfg.rapid_fire then
        local t=getAimTarget(cfg.aimbot_fov)
        if t and now-lastFire>=0.1 then fireOnce(); lastFire=now end
    end
    -- Rapid fire — sürekli, delay ile
    if cfg.rapid_fire then
        if now-lastFire>=math.max(cfg.rapid_fire_delay,0.016) then fireOnce(); lastFire=now end
    end

    -- Reach hack
    if cfg.reach then
        pcall(function()
            local char=lp.Character; if not char then return end
            local tool=char:FindFirstChildOfClass("Tool"); if not tool then return end
            local t=getAimTarget(cfg.aimbot_fov)
            if t then
                local dist=(Camera.CFrame.Position-t.Position).Magnitude
                if dist<=cfg.reach_range then
                    for _,v in ipairs(tool:GetDescendants()) do
                        if v:IsA("RemoteEvent") then v:FireServer(t.Position,t); break end
                    end
                end
            end
        end)
    end

    -- Wallbang
    if cfg.wallbang then
        pcall(function()
            local origin=Camera.CFrame.Position
            local dir=Camera.CFrame.LookVector*500
            local ignore={lc}
            for i=1,3 do
                local ray=Ray.new(origin,dir)
                local hit,pos=workspace:FindPartOnRayWithIgnoreList(ray,ignore)
                if not hit then break end
                table.insert(ignore,hit)
                local model=hit:FindFirstAncestorOfClass("Model")
                if model then
                    local h=model:FindFirstChildOfClass("Humanoid")
                    local pp=Players:GetPlayerFromCharacter(model)
                    if h and h.Health>0 and model~=lc then
                        if not cfg.aimbot_teamcheck or not pp or getTeam(pp)~=getTeam(lp) then
                            pcall(function() h:TakeDamage(9999) end)
                        end
                        break
                    end
                end
                origin=pos+dir.Unit*0.1
            end
        end)
    end

    -- Auto item switch
    if cfg.auto_item and hum then
        if now-lastItem>=cfg.auto_item_delay then
            local backpack=lp:FindFirstChild("Backpack")
            local char=lp.Character; local items={}
            if char then for _,v in ipairs(char:GetChildren()) do if v:IsA("Tool") then table.insert(items,v) end end end
            if backpack then for _,v in ipairs(backpack:GetChildren()) do if v:IsA("Tool") then table.insert(items,v) end end end
            if #items>0 then
                itemIdx=(itemIdx%#items)+1
                local tool=items[itemIdx]
                if tool then
                    if tool.Parent==backpack then hum:EquipTool(tool) else hum:UnequipTools() end
                end
            end
            lastItem=now
        end
    end
end)

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

print("AnonymousH4X v5.0 | HAX = menu, ESP botlari da yakalar")

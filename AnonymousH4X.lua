-- AnonymousH4X v5.2 | ESP V2 + Fly Controls + Visual Customization

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local Camera = workspace.CurrentCamera

local Debris = game:GetService("Debris")
local visualHitCooldown = {}
local lp = Players.LocalPlayer
local lc = lp.Character or lp.CharacterAdded:Wait()
local mouse = lp:GetMouse()

local cfg = {
    esp=true, esp_box=true, esp_skeleton=true, esp_health=true,
    esp_distance=true, esp_tracer=true, esp_name=true, esp_teamcheck=false,
    esp_color=Color3.fromRGB(255,50,50),
    esp_v2=true, esp_rainbow=false, menu_rainbow=false, crosshair_rainbow=false,
    menu_color=Color3.fromRGB(140,0,255),
    crosshair_rotate=false, crosshair_rotation_speed=120,
    esp_friendly_color=Color3.fromRGB(0,200,255),
    radar=false, radar_size=180, radar_range=200,
    crosshair=false, crosshair_size=12, crosshair_gap=4, crosshair_thickness=1,
    crosshair_color=Color3.fromRGB(255,255,255), crosshair_dot=true,
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
VersionLabel.Text = "v5.3"
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

-- ====== FLY BUTTONS ======
_G.FlyDirections={forward=false,back=false,left=false,right=false,up=false,down=false}
local flyButtons={}
local function makeFlyBtn(text,xOff,yOff,dir)
    local b=Instance.new("TextButton")
    b.Text=text; b.Size=UDim2.new(0,48,0,48)
    b.Position=UDim2.new(0,xOff,0.5,yOff)
    b.BackgroundColor3=Color3.fromRGB(0,80,180)
    b.TextColor3=Color3.new(1,1,1); b.TextSize=20
    b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0
    b.ZIndex=10; b.Visible=false; b.AutoButtonColor=false; b.Parent=ScreenGui
    Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
    Instance.new("UIStroke",b).Color=Color3.fromRGB(0,160,255)
    b.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
            _G.FlyDirections[dir]=true
            TweenService:Create(b,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(0,140,255)}):Play()
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
            _G.FlyDirections[dir]=false
            TweenService:Create(b,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(0,80,180)}):Play()
        end
    end)
    return b
end
local flyUpBtn = makeFlyBtn("▲",62,-62,"up")
local flyDnBtn = makeFlyBtn("▼",62,62,"down")
local flyForwardBtn = makeFlyBtn("W",62,-112,"forward")
local flyBackBtn = makeFlyBtn("S",62,112,"back")
local flyLeftBtn = makeFlyBtn("A",12,0,"left")
local flyRightBtn = makeFlyBtn("D",112,0,"right")
flyButtons={flyUpBtn,flyDnBtn,flyForwardBtn,flyBackBtn,flyLeftBtn,flyRightBtn}
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch then
        for k in pairs(_G.FlyDirections) do _G.FlyDirections[k]=false end
    end
end)

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

local toggleRefreshers={}

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

local palette={
    Color3.fromRGB(255,60,80), Color3.fromRGB(0,210,255),
    Color3.fromRGB(150,70,255), Color3.fromRGB(70,255,140),
    Color3.fromRGB(255,190,40), Color3.fromRGB(255,255,255),
}
local function makeColorCycle(label,cfgKey)
    local row=Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,42); row.BackgroundColor3=COL_ROW
    row.BorderSizePixel=0; row.Parent=ScrollArea
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local text=Instance.new("TextLabel")
    text.Size=UDim2.new(1,-82,1,0); text.Position=UDim2.new(0,12,0,0)
    text.BackgroundTransparency=1; text.Text=label; text.TextColor3=COL_TEXT
    text.Font=Enum.Font.Gotham; text.TextSize=11; text.TextXAlignment=Enum.TextXAlignment.Left
    text.Parent=row
    local swatch=Instance.new("TextButton")
    swatch.Size=UDim2.new(0,58,0,26); swatch.Position=UDim2.new(1,-68,0.5,-13)
    swatch.Text="COLOR"; swatch.TextSize=9; swatch.Font=Enum.Font.GothamBold
    swatch.TextColor3=Color3.new(1,1,1); swatch.BackgroundColor3=cfg[cfgKey]
    swatch.BorderSizePixel=0; swatch.Parent=row
    Instance.new("UICorner",swatch).CornerRadius=UDim.new(0,6)
    local index=1
    for i,c in ipairs(palette) do if c==cfg[cfgKey] then index=i break end end
    swatch.Activated:Connect(function()
        index=index%#palette+1; cfg[cfgKey]=palette[index]; swatch.BackgroundColor3=cfg[cfgKey]
    end)
end

function buildTab(tab)
    if tab=="ESP" then
        makeSec("ESP")
        makeToggle("Enable ESP","esp",Color3.fromRGB(255,70,70))
        makeToggle("ESP V2 - Bright Highlight","esp_v2",Color3.fromRGB(0,220,255))
        makeToggle("Rainbow ESP","esp_rainbow",Color3.fromRGB(255,0,200))
        makeColorCycle("ESP Color","esp_color")
        makeToggle("Box ESP","esp_box"); makeToggle("Skeleton","esp_skeleton")
        makeToggle("Health Bar","esp_health"); makeToggle("Distance","esp_distance")
        makeToggle("Tracers","esp_tracer"); makeToggle("Names","esp_name")
        makeToggle("Team Check","esp_teamcheck")
        makeSec("Theme")
        makeToggle("Rainbow Menu","menu_rainbow")
        makeColorCycle("Menu Color","menu_color")
        makeSec("Radar")
        makeToggle("2D Radar","radar",Color3.fromRGB(0,210,100))
        makeSlider("Radar Size","radar_size",100,350," px")
        makeSlider("Radar Range","radar_range",50,500," st")
        makeSec("Crosshair")
        makeToggle("Crosshair","crosshair",Color3.fromRGB(255,255,255))
        makeToggle("Rotate Crosshair","crosshair_rotate")
        makeToggle("Rainbow Crosshair","crosshair_rainbow")
        makeColorCycle("Crosshair Color","crosshair_color")
        makeSlider("Rotation Speed","crosshair_rotation_speed",0,360," deg/s")
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
        makeToggle("Silent NPC Test","silent_aim",Color3.fromRGB(255,100,0))
        makeSlider("Silent FOV","silent_fov",10,500," px")
        makeSec("Aimkill")
        makeToggle("NPC Aimkill Test","aimkill",Color3.fromRGB(255,30,30))
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
        makeToggle("NPC One Shot Test","one_shot",Color3.fromRGB(255,0,0))
        makeToggle("NPC Auto Fire","auto_fire",Color3.fromRGB(255,50,110))
        makeToggle("NPC Rapid Fire","rapid_fire",Color3.fromRGB(255,20,70))
        makeSlider("Rapid Delay","rapid_fire_delay",0.01,0.5," s",true)
        makeSec("Damage")
        makeToggle("Kill Aura","kill_aura",Color3.fromRGB(255,0,80))
        makeSlider("Kill Aura Range","kill_aura_range",5,50," st")
        makeToggle("NPC Reach Test","reach",Color3.fromRGB(255,80,0))
        makeSlider("Reach Range","reach_range",5,50," st")
        makeSec("Hitbox")
        makeToggle("NPC Hitbox Expand (Head)","hitbox_expand",Color3.fromRGB(255,50,110))
        makeSlider("Hitbox Size","hitbox_size",2,20," st")
        makeSec("Auto Item")
        makeToggle("Auto Item Switch","auto_item",Color3.fromRGB(255,180,0))
        makeSlider("Switch Delay","auto_item_delay",0.1,2," s",true)
    elseif tab=="VISUAL" then
        makeSec("Visual")
        makeToggle("FullBright","fullbright",Color3.fromRGB(60,150,255))
        makeToggle("No Fog","no_fog",Color3.fromRGB(60,150,255))
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

local function removeESPObject(obj)
    if type(obj)=="table" then
        for _,child in pairs(obj) do removeESPObject(child) end
        return
    end
    pcall(function()
        if typeof(obj)=="Instance" then
            obj:Destroy()
        else
            obj:Remove()
        end
    end)
end

local function cleanESP(player)
    local objects=espObjects[player]
    if not objects then return end
    removeESPObject(objects)
    espObjects[player]=nil
end

local function setupESP(player)
    if player==lp then return end
    cleanESP(player)
    local o={}
    o.highlight=Instance.new("Highlight")
    o.highlight.Name="AH4X_ESP_V2"
    o.highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    o.highlight.FillColor=cfg.esp_color
    o.highlight.OutlineColor=Color3.new(1,1,1)
    o.highlight.FillTransparency=0.72
    o.highlight.OutlineTransparency=0
    o.highlight.Enabled=false
    o.highlight.Parent=workspace
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
        if type(obj)=="table" then
            for _,line in pairs(obj) do pcall(function() line.Visible=false end) end
        elseif typeof(obj)=="Instance" and obj:IsA("Highlight") then
            obj.Enabled=false
        else
            pcall(function() obj.Visible=false end)
        end
    end
end

-- ===== PLAYER/BOT TRACKING =====
-- Visual ESP may track player characters and NPCs. Combat test targeting is NPC-only.
local trackedEntities = {}
local playerCharacter = {}
local characterConnections = {}

local function getTeam(p) return p and p.Team or nil end

local function registerCharacter(player, character)
    if not player or not character then return end
    local old = playerCharacter[player]
    if old and old ~= character then
        cleanESP(old)
        trackedEntities[old] = nil
    end
    playerCharacter[player] = character
    local hum = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
    if not hum then return end
    setupESP(character)
    trackedEntities[character] = {model=character, humanoid=hum, isPlayer=true, player=player}
    hum.Died:Connect(function()
        -- A delayed Died callback from an old character must not erase a respawned one.
        if playerCharacter[player] == character then
            cleanESP(character)
            trackedEntities[character] = nil
        end
    end)
end

local function registerPlayer(player)
    if player == lp then return end
    if characterConnections[player] then
        for _, connection in ipairs(characterConnections[player]) do connection:Disconnect() end
    end
    characterConnections[player] = {
        player.CharacterAdded:Connect(function(char) registerCharacter(player, char) end),
        player.CharacterRemoving:Connect(function(char)
            cleanESP(char)
            trackedEntities[char] = nil
            if playerCharacter[player] == char then playerCharacter[player] = nil end
        end),
    }
    if player.Character then registerCharacter(player, player.Character) end
end

Players.PlayerAdded:Connect(registerPlayer)
Players.PlayerRemoving:Connect(function(player)
    local char = playerCharacter[player]
    if char then cleanESP(char); trackedEntities[char] = nil end
    playerCharacter[player] = nil
    if characterConnections[player] then
        for _, connection in ipairs(characterConnections[player]) do connection:Disconnect() end
        characterConnections[player] = nil
    end
    for i=#radarDots,1,-1 do
        local d=radarDots[i]
        if d.key==player or d.key==char then
            pcall(function() d.dot:Remove() end)
            table.remove(radarDots,i)
        end
    end
end)
for _, player in ipairs(Players:GetPlayers()) do registerPlayer(player) end

local function registerNPC(model)
    if not model or not model:IsA("Model") or model == lp.Character then return end
    if Players:GetPlayerFromCharacter(model) then return end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if trackedEntities[model] then return end
    setupESP(model)
    trackedEntities[model] = {model=model, humanoid=hum, isPlayer=false}
    hum.Died:Connect(function()
        cleanESP(model)
        trackedEntities[model] = nil
    end)
    model.AncestryChanged:Connect(function(_, parent)
        if not parent then cleanESP(model); trackedEntities[model] = nil end
    end)
end

workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("Model") then
        task.defer(function()
            if desc.Parent then registerNPC(desc) end
        end)
    elseif desc:IsA("Humanoid") then
        local model = desc.Parent
        if model and model:IsA("Model") then task.defer(function() registerNPC(model) end) end
    end
end)
for _, desc in ipairs(workspace:GetDescendants()) do
    if desc:IsA("Model") then registerNPC(desc) end
end

-- ===== NPC TEST TARGETING =====
local function w2v(pos)
    local vp,inView=Camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X,vp.Y),inView,vp.Z
end

local function getAimTarget(fovLimit)
    local best=fovLimit or math.huge
    local target=nil
    local viewport=Camera.ViewportSize
    local center=Vector2.new(viewport.X/2,viewport.Y/2)
    for model,ent in pairs(trackedEntities) do
        if ent.isPlayer then continue end
        if not model or not model.Parent then continue end
        if not CollectionService:HasTag(model,"AH4X_Damageable") then continue end
        local humanoid=ent.humanoid
        if not humanoid or humanoid.Health<=0 then continue end
        local head=model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
        if not head or not head:IsA("BasePart") then continue end
        local screen,inView,depth=w2v(head.Position)
        if not inView or depth<=0 then continue end
        local distance=(screen-center).Magnitude
        if distance<best then best=distance; target=head end
    end
    return target
end

-- VISUAL-ONLY NPC TEST: never changes Health and never sends a RemoteEvent.
local function fireTestTarget(mode, target)
    if not target then return false end
    local model=target:FindFirstAncestorOfClass("Model")
    if not model or Players:GetPlayerFromCharacter(model) then return false end
    if not CollectionService:HasTag(model,"AH4X_Damageable") then return false end
    local humanoid=model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health<=0 then return false end
    local now=os.clock()
    if now-(visualHitCooldown[model] or 0)<0.18 then return true end
    visualHitCooldown[model]=now
    local old=model:FindFirstChild("AH4X_VisualTestHit")
    if old then old:Destroy() end
    local gui=Instance.new("BillboardGui")
    gui.Name="AH4X_VisualTestHit"
    gui.Adornee=target
    gui.AlwaysOnTop=true
    gui.Size=UDim2.fromOffset(120,32)
    gui.StudsOffset=Vector3.new(0,2.5,0)
    gui.Parent=model
    local label=Instance.new("TextLabel")
    label.Size=UDim2.fromScale(1,1)
    label.BackgroundColor3=Color3.fromRGB(20,20,28)
    label.BackgroundTransparency=0.2
    label.TextColor3=Color3.fromRGB(100,255,150)
    label.TextStrokeTransparency=0.35
    label.Font=Enum.Font.GothamBold
    label.TextScaled=true
    label.Text="VISUAL TEST"
    label.Parent=gui
    Instance.new("UICorner",label).CornerRadius=UDim.new(0,6)
    Debris:AddItem(gui,0.45)
    return true
end

-- In the private test place, Silent Aim means fire at the selected tagged NPC
-- without rotating the camera. It never targets player characters.
local silentClickConnection = UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not cfg.silent_aim then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fireTestTarget("normal", getAimTarget(cfg.silent_fov))
    end
end)

local function fireOnce(mode)
    local target=getAimTarget(cfg.aimbot_fov)
    if not target then return false end
    return fireTestTarget(mode or (cfg.one_shot and "one_shot" or "normal"), target)
end

-- state
local lastFire=0; local lastItem=0; local itemIdx=1

-- ===== RENDER LOOP =====
local antiAimAngle=0
local auraLastHit={}
RunService.RenderStepped:Connect(function()
    lc=lp.Character; if not lc then return end
    local hum=lc:FindFirstChildOfClass("Humanoid")
    local hrp=lc:FindFirstChild("HumanoidRootPart")
    local vpSize=Camera.ViewportSize
    local vpc=Vector2.new(vpSize.X/2,vpSize.Y/2)

    -- Animated menu accent
    if cfg.menu_rainbow then
        local themeColor=Color3.fromHSV((tick()*0.12)%1,1,1)
        mainStroke.Color=themeColor
        haxStroke.Color=themeColor
        TabIndicator.BackgroundColor3=themeColor
    else
        mainStroke.Color=cfg.menu_color
        haxStroke.Color=cfg.menu_color
        TabIndicator.BackgroundColor3=cfg.menu_color
    end

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

    -- Visible camera aim is restricted to tagged NPCs in this test place.
    if cfg.aimbot then
        local target=getAimTarget(cfg.aimbot_fov)
        if target then
            local targetCF=CFrame.new(Camera.CFrame.Position,target.Position)
            Camera.CFrame=Camera.CFrame:Lerp(targetCF,math.clamp(cfg.aimbot_smooth,0.01,1))
        end
    end
    AimBtn.Visible=false

    -- Hitbox expand — sadece Head, local only
    -- NOT: server-side hit detection olan oyunlarda hasar için "Reach" kullan
    if cfg.hitbox_expand then
        for key,ent in pairs(trackedEntities) do
            if ent.isPlayer then continue end
            local model=ent.model; if not model or not model.Parent then continue end
            if not CollectionService:HasTag(model,"AH4X_Damageable") then continue end
            local head=model:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                -- CFrame'i koru, sadece size değiştir
                local cf=head.CFrame
                head.Size=Vector3.new(cfg.hitbox_size,cfg.hitbox_size,cfg.hitbox_size)
                head.CFrame=cf
            end
        end
    end

    -- Kill Aura — tool remote fire ile yakındakilere
    if cfg.kill_aura and hrp then
        for key,ent in pairs(trackedEntities) do
            if ent.isPlayer then continue end
            local model=ent.model; if not model or not model.Parent then continue end
            if not CollectionService:HasTag(model,"AH4X_Damageable") then continue end
            local ehrp=model:FindFirstChild("HumanoidRootPart"); if not ehrp then continue end
            local h=ent.humanoid; if not h or h.Health<=0 then continue end
            if (hrp.Position-ehrp.Position).Magnitude<=cfg.kill_aura_range then
                -- Show a local visual marker only; no damage is sent.
                local stamp=os.clock()
                if auraRemote and stamp-(auraLastHit[model] or 0)>=0.25 then
                    auraLastHit[model]=stamp
                    fireTestTarget("aura", model:FindFirstChild("Head") or ehrp)
                end
            end
        end
    end

    -- FOV Circle
    fovCircle.Visible=cfg.fov_circle
    if cfg.fov_circle then
        fovCircle.Position=vpc; fovCircle.Radius=cfg.aimbot_fov; fovCircle.Color=cfg.fov_color
    end

    -- Crosshair
    if cfg.crosshair then
        local cs,cg,ct=cfg.crosshair_size,cfg.crosshair_gap,cfg.crosshair_thickness
        local cc=cfg.crosshair_rainbow and Color3.fromHSV((tick()*0.25)%1,1,1) or cfg.crosshair_color
        local angle=cfg.crosshair_rotate and math.rad((tick()*cfg.crosshair_rotation_speed)%360) or 0
        local function rotated(x,y)
            local dx,dy=x-vpc.X,y-vpc.Y
            return Vector2.new(vpc.X+dx*math.cos(angle)-dy*math.sin(angle),vpc.Y+dx*math.sin(angle)+dy*math.cos(angle))
        end
        ch.top.Visible=true; ch.top.From=rotated(vpc.X,vpc.Y-cg); ch.top.To=rotated(vpc.X,vpc.Y-cg-cs); ch.top.Thickness=ct; ch.top.Color=cc
        ch.bot.Visible=true; ch.bot.From=rotated(vpc.X,vpc.Y+cg); ch.bot.To=rotated(vpc.X,vpc.Y+cg+cs); ch.bot.Thickness=ct; ch.bot.Color=cc
        ch.left.Visible=true; ch.left.From=rotated(vpc.X-cg,vpc.Y); ch.left.To=rotated(vpc.X-cg-cs,vpc.Y); ch.left.Thickness=ct; ch.left.Color=cc
        ch.right.Visible=true; ch.right.From=rotated(vpc.X+cg,vpc.Y); ch.right.To=rotated(vpc.X+cg+cs,vpc.Y); ch.right.Thickness=ct; ch.right.Color=cc
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

        if not cfg.esp or not model or not model.Parent then
            hideAll(o); if o.highlight then o.highlight.Enabled=false end
            if model and not model.Parent then cleanESP(key); trackedEntities[key]=nil end
            continue
        end
        if not humanoid or humanoid.Health<=0 then
            hideAll(o); if o.highlight then o.highlight.Enabled=false end
            cleanESP(key); trackedEntities[key]=nil
            continue
        end

        local hrpP=model:FindFirstChild("HumanoidRootPart")
        local head=model:FindFirstChild("Head")
        if not hrpP or not head then hideAll(o); continue end

        -- team check sadece player için
        local isEnemy=true
        if ent and ent.isPlayer and cfg.esp_teamcheck then
            isEnemy = getTeam(ent.player)~=getTeam(lp)
        end
        local hue=(tick()*0.18)%1
        local rainbowColor=Color3.fromHSV(hue,1,1)
        local col=cfg.esp_rainbow and rainbowColor or (isEnemy and cfg.esp_color or cfg.esp_friendly_color)
        if o.highlight then
            o.highlight.Adornee=model
            o.highlight.Enabled=cfg.esp_v2
            o.highlight.FillColor=col
            o.highlight.OutlineColor=Color3.fromHSV((hue+0.12)%1,0.65,1)
        end

        local hVP,_,hZ=w2v(head.Position+Vector3.new(0,0.5,0))
        local fVP=w2v(hrpP.Position-Vector3.new(0,2.5,0))
        local distVal=math.floor((Camera.CFrame.Position-hrpP.Position).Magnitude)

        if hZ<=0 then hideAll(o); if o.highlight then o.highlight.Enabled=false end; continue end

        local bH=math.abs(hVP.Y-fVP.Y); local bW=bH*0.55
        local bX=hVP.X-bW/2; local bY=hVP.Y

        pcall(function()
            o.box.Visible=cfg.esp_box; o.box.Position=Vector2.new(bX,bY); o.box.Size=Vector2.new(bW,bH); o.box.Color=col
            o.name.Visible=cfg.esp_name; o.name.Position=Vector2.new(hVP.X,hVP.Y-14)
            -- bot için model adı, player için player adı
            local dispName=(ent and ent.isPlayer and ent.player) and ent.player.Name or model.Name
            o.name.Text=dispName; o.name.Color=col
            o.dist.Visible=cfg.esp_distance; o.dist.Position=Vector2.new(hVP.X,fVP.Y+2); o.dist.Text=distVal.."m"; o.dist.Color=Color3.fromRGB(220,220,220)
            local hp=humanoid.Health; local maxhp=humanoid.MaxHealth
            local hpr=math.clamp(hp/maxhp,0,1)
            o.hbBg.Visible=cfg.esp_health; o.hbBg.Position=Vector2.new(bX-6,bY); o.hbBg.Size=Vector2.new(4,bH)
            o.hbFill.Visible=cfg.esp_health; o.hbFill.Position=Vector2.new(bX-6,bY+bH*(1-hpr)); o.hbFill.Size=Vector2.new(4,bH*hpr)
            o.hbFill.Color=Color3.fromRGB(math.floor(255*(1-hpr)),math.floor(255*hpr),50)
            o.tracer.Visible=cfg.esp_tracer; o.tracer.From=Vector2.new(vpc.X,vpSize.Y); o.tracer.To=Vector2.new(hVP.X,hVP.Y); o.tracer.Color=col
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
    for _,button in ipairs(flyButtons) do button.Visible=cfg.fly end
end)

-- ===== HEARTBEAT =====
RunService.Heartbeat:Connect(function()
    lc=lp.Character; if not lc then return end
    local hrp=lc:FindFirstChild("HumanoidRootPart")
    local hum=lc:FindFirstChildOfClass("Humanoid")
    local now=tick()

    -- Aimkill test: visual marker against tagged NPCs only.
    if cfg.aimkill and now-lastFire>=0.15 then
        local target=getAimTarget(cfg.aimbot_fov)
        if target then
            fireTestTarget("aimkill",target)
            lastFire=now
        end
    end

    if cfg.noclip then
        for _,p in ipairs(lc:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end

    if cfg.fly and hrp then
        local bv=hrp:FindFirstChild("FlyBV") or Instance.new("BodyVelocity",hrp)
        bv.Name="FlyBV"; bv.MaxForce=Vector3.new(1e5,1e5,1e5)
        local dir=Vector3.zero
        -- keyboard + touch buttons
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
        local fd=_G.FlyDirections
        if fd.forward then dir=dir+Camera.CFrame.LookVector end
        if fd.back then dir=dir-Camera.CFrame.LookVector end
        if fd.left then dir=dir-Camera.CFrame.RightVector end
        if fd.right then dir=dir+Camera.CFrame.RightVector end
        if fd.up then dir=dir+Vector3.new(0,1,0) end
        if fd.down then dir=dir-Vector3.new(0,1,0) end
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
        bv.Velocity=dir.Magnitude>0 and dir.Unit*cfg.fly_speed or Vector3.zero
    else
        if hrp then local bv=hrp:FindFirstChild("FlyBV"); if bv then bv:Destroy() end end
    end

    if cfg.bunnyhop and hum and hum.FloorMaterial~=Enum.Material.Air then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    -- Auto Fire: automatically hit the selected tagged NPC while inside FOV.
    if cfg.auto_fire and not cfg.rapid_fire and now-lastFire>=0.12 then
        if fireOnce("normal") then lastFire=now end
    end
    -- Rapid Fire: repeats the local visual marker only.
    if cfg.rapid_fire and now-lastFire>=math.max(cfg.rapid_fire_delay,0.04) then
        if fireOnce("rapid") then lastFire=now end
    end
    -- One Shot displays a single visual marker; it does not change health.
    if cfg.one_shot and not cfg.auto_fire and not cfg.rapid_fire and not cfg.aimkill then
        if fireOnce("one_shot") then
            cfg.one_shot=false
            if toggleRefreshers.one_shot then toggleRefreshers.one_shot() end
        end
    end

    -- Reach test: displays a visual marker for nearby tagged NPCs only.
    if cfg.reach then
        local target=getAimTarget(cfg.aimbot_fov)
        if target and (Camera.CFrame.Position-target.Position).Magnitude<=cfg.reach_range then
            fireTestTarget("normal",target)
        end
    end

    -- Wallbang remains visual-only; this client script never applies damage.

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

-- Anti-cheat bypass intentionally removed.

print("AnonymousH4X v5.4 | Visual-only NPC test | No damage / no RemoteEvent")

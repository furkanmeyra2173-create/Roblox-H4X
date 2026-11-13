--[[
    AnonymousH4X  v2
    Delta Compatible | Mobile + PC
    Canlı ESP | Aimbot | Silent | Fly | Noclip | Hitbox | Speed | Jump | Anti-Cheat Bypass
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- ====================== ANTI-CHEAT BYPASS ======================
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "Kick" or method == "Ban" then return nil end
    if method == "FireServer" then
        local n = tostring(self):lower()
        if n:find("anticheat") or n:find("detect") or n:find("ban") or n:find("kick") or n:find("report") then
            return nil
        end
    end
    if (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay") and getgenv().AH4X and getgenv().AH4X.SilentAim then
        local t = getgenv().AH4X.GetClosest and getgenv().AH4X.GetClosest("Head")
        if t then args[1] = Ray.new(Camera.CFrame.Position, (t.Position - Camera.CFrame.Position).Unit * 2000) end
    end
    return oldNamecall(self, unpack(args))
end)
pcall(function() if setfflag then setfflag("DebugDisableAntiCheat", "true") end end)

-- ====================== SETTINGS ======================
getgenv().AH4X = getgenv().AH4X or {}
local S = getgenv().AH4X

S.ESP = true
S.Box = true
S.CornerBox = true
S.Name = true
S.Health = true
S.Distance = true
S.Tracer = true
S.Skeleton = true
S.Chams = false
S.ChinaHat = true

S.Aimbot = true
S.SilentAim = false
S.FOV = 170
S.Smooth = 0.12
S.TeamCheck = true
S.Prediction = 0.14
S.AimPart = "Head"

S.Fly = false
S.FlySpeed = 60
S.Noclip = false
S.Speed = 16
S.JumpPower = 50
S.InfiniteJump = false

S.HitboxExpand = false
S.HitboxSize = 14
S.FullBright = false
S.NoFog = false
S.Xray = false

-- ====================== HELPERS ======================
local function IsEnemy(p)
    if not S.TeamCheck then return true end
    if not LocalPlayer.Team then return true end
    return p.Team \~= LocalPlayer.Team
end

function S.GetClosest(part)
    local closest, short = nil, S.FOV
    local mouse = UserInputService:GetMouseLocation()
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer or not IsEnemy(p) then continue end
        local c = p.Character
        if not c then continue end
        local h = c:FindFirstChildOfClass("Humanoid")
        local t = c:FindFirstChild(part or S.AimPart)
        if not h or not t or h.Health <= 0 then continue end
        local pos, on = Camera:WorldToViewportPoint(t.Position)
        if not on then continue end
        local d = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
        if d < short then short = d; closest = t end
    end
    return closest
end

-- ====================== CANLI ESP ======================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.6
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 255, 140)
FOVCircle.Visible = true

local function DrawCornerBox(pos, size, color)
    local t = 2
    local len = size.X * 0.25
    local lines = {}
    -- sol üst
    table.insert(lines, {Vector2.new(pos.X, pos.Y), Vector2.new(pos.X + len, pos.Y)})
    table.insert(lines, {Vector2.new(pos.X, pos.Y), Vector2.new(pos.X, pos.Y + len)})
    -- sağ üst
    table.insert(lines, {Vector2.new(pos.X + size.X, pos.Y), Vector2.new(pos.X + size.X - len, pos.Y)})
    table.insert(lines, {Vector2.new(pos.X + size.X, pos.Y), Vector2.new(pos.X + size.X, pos.Y + len)})
    -- sol alt
    table.insert(lines, {Vector2.new(pos.X, pos.Y + size.Y), Vector2.new(pos.X + len, pos.Y + size.Y)})
    table.insert(lines, {Vector2.new(pos.X, pos.Y + size.Y), Vector2.new(pos.X, pos.Y + size.Y - len)})
    -- sağ alt
    table.insert(lines, {Vector2.new(pos.X + size.X, pos.Y + size.Y), Vector2.new(pos.X + size.X - len, pos.Y + size.Y)})
    table.insert(lines, {Vector2.new(pos.X + size.X, pos.Y + size.Y), Vector2.new(pos.X + size.X, pos.Y + size.Y - len)})
    for _, l in pairs(lines) do
        local line = Drawing.new("Line")
        line.From = l[1]
        line.To = l[2]
        line.Color = color
        line.Thickness = t
        line.Visible = true
        task.delay(0.03, function() line:Remove() end)
    end
end

local function DrawSkeleton(char, color)
    local bones = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
    }
    for _, b in pairs(bones) do
        local p1 = char:FindFirstChild(b[1])
        local p2 = char:FindFirstChild(b[2])
        if p1 and p2 then
            local a, ona = Camera:WorldToViewportPoint(p1.Position)
            local c, onc = Camera:WorldToViewportPoint(p2.Position)
            if ona and onc then
                local line = Drawing.new("Line")
                line.From = Vector2.new(a.X, a.Y)
                line.To = Vector2.new(c.X, c.Y)
                line.Color = color
                line.Thickness = 1.4
                line.Visible = true
                task.delay(0.03, function() line:Remove() end)
            end
        end
    end
end

local function DrawESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    local head = char:FindFirstChild("Head")
    if not root or not hum or not head or hum.Health <= 0 then return end
    if not IsEnemy(player) then return end

    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
    if not onScreen then return end

    local distance = (root.Position - Camera.CFrame.Position).Magnitude
    local size = Vector2.new(math.clamp(2400/distance, 20, 90), math.clamp(3400/distance, 32, 140))
    local topLeft = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
    local color = Color3.fromRGB(0, 255, 140)

    if S.Box and not S.CornerBox then
        local box = Drawing.new("Square")
        box.Size = size
        box.Position = topLeft
        box.Color = color
        box.Thickness = 1.6
        box.Filled = false
        box.Visible = true
        task.delay(0.03, function() box:Remove() end)
    end

    if S.CornerBox then
        DrawCornerBox(topLeft, size, color)
    end

    if S.Name then
        local text = Drawing.new("Text")
        text.Text = player.Name
        text.Position = Vector2.new(pos.X, topLeft.Y - 16)
        text.Color = Color3.fromRGB(255, 255, 255)
        text.Size = 14
        text.Center = true
        text.Outline = true
        text.Visible = true
        task.delay(0.03, function() text:Remove() end)
    end

    if S.Health then
        local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        local bar = Drawing.new("Square")
        bar.Size = Vector2.new(3.5, size.Y * hp)
        bar.Position = Vector2.new(topLeft.X - 7, topLeft.Y + size.Y * (1-hp))
        bar.Color = Color3.fromRGB(0, 255, 80):Lerp(Color3.fromRGB(255, 40, 40), 1-hp)
        bar.Filled = true
        bar.Visible = true
        task.delay(0.03, function() bar:Remove() end)
    end

    if S.Distance then
        local distText = Drawing.new("Text")
        distText.Text = math.floor(distance) .. "m"
        distText.Position = Vector2.new(pos.X, topLeft.Y + size.Y + 3)
        distText.Color = Color3.fromRGB(200, 200, 200)
        distText.Size = 12
        distText.Center = true
        distText.Outline = true
        distText.Visible = true
        task.delay(0.03, function() distText:Remove() end)
    end

    if S.Tracer then
        local line = Drawing.new("Line")
        line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
        line.To = Vector2.new(pos.X, topLeft.Y + size.Y)
        line.Color = color
        line.Thickness = 1.2
        line.Visible = true
        task.delay(0.03, function() line:Remove() end)
    end

    if S.Skeleton then
        DrawSkeleton(char, color)
    end

    if S.ChinaHat and head then
        local hatPos, on = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.9, 0))
        if on then
            local hat = Drawing.new("Circle")
            hat.Position = Vector2.new(hatPos.X, hatPos.Y)
            hat.Radius = math.clamp(900/distance, 4, 18)
            hat.Color = Color3.fromRGB(0, 255, 200)
            hat.Thickness = 1.5
            hat.Filled = false
            hat.Visible = true
            task.delay(0.03, function() hat:Remove() end)
        end
    end
end

-- ====================== FLY ======================
local FlyBV, FlyBG
local function ToggleFly(state)
    S.Fly = state
    local char = LocalPlayer.Character
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

local function ExpandHitboxes()
    if not S.HitboxExpand then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer or not IsEnemy(p) then continue end
        local c = p.Character
        if not c then continue end
        local r = c:FindFirstChild("HumanoidRootPart")
        if r then
            r.Size = Vector3.new(S.HitboxSize, S.HitboxSize, S.HitboxSize)
            r.Transparency = 0.55
            r.CanCollide = false
        end
    end
end

-- ====================== MAIN LOOP ======================
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = S.FOV
    FOVCircle.Visible = S.Aimbot or S.SilentAim

    if S.ESP then
        for _, p in pairs(Players:GetPlayers()) do DrawESP(p) end
    end

    local aiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    if UserInputService.TouchEnabled then
        for _, _ in pairs(UserInputService:GetMouseButtonsPressed()) do aiming = true end
    end

    if S.Aimbot and aiming then
        local target = S.GetClosest(S.AimPart)
        if target then
            local cam = Camera.CFrame
            local vel = target.AssemblyLinearVelocity or Vector3.zero
            Camera.CFrame = cam:Lerp(CFrame.new(cam.Position, target.Position + vel * S.Prediction), S.Smooth)
        end
    end

    if S.Fly and FlyBV and FlyBG then
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        if UserInputService.TouchEnabled and move.Magnitude == 0 then move = Camera.CFrame.LookVector end
        FlyBV.Velocity = move.Magnitude > 0 and move.Unit * S.FlySpeed or Vector3.zero
        FlyBG.CFrame = Camera.CFrame
    end

    if S.Noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.WalkSpeed = S.Speed
        char.Humanoid.JumpPower = S.JumpPower
    end

    ExpandHitboxes()
end)

UserInputService.JumpRequest:Connect(function()
    if S.InfiniteJump and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ====================== PREMIUM MENÜ ======================
local SG = Instance.new("ScreenGui")
SG.Name = "AH4X_UI"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() SG.Parent = CoreGui end)
if not SG.Parent then SG.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 74, 0, 74)
OpenBtn.Position = UDim2.new(1, -90, 0.38, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
OpenBtn.Text = "AH4X"
OpenBtn.TextColor3 = Color3.fromRGB(8, 8, 8)
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 17
OpenBtn.Parent = SG
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 16)
local stroke = Instance.new("UIStroke", OpenBtn)
stroke.Color = Color3.fromRGB(0, 255, 160)
stroke.Thickness = 2

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 360, 0, 520)
Main.Position = UDim2.new(0.5, -180, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 48)
Top.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
Top.BorderSizePixel = 0
Top.Parent = Main
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -55, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AnonymousH4X  v2"
Title.TextColor3 = Color3.fromRGB(8, 8, 8)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 42, 0, 42)
Close.Position = UDim2.new(1, -46, 0, 3)
Close.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 70, 70)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.Parent = Top
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 9)

Close.MouseButton1Click:Connect(function() Main.Visible = false end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -16, 1, -60)
Scroll.Position = UDim2.new(0, 8, 0, 54)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
Scroll.Parent = Main

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 7)
List.Parent = Scroll

local function Section(t)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 26)
    l.BackgroundTransparency = 1
    l.Text = "  "..t
    l.TextColor3 = Color3.fromRGB(0, 230, 130)
    l.Font = Enum.Font.GothamBlack
    l.TextSize = 15
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = Scroll
end

local function Toggle(text, key)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    b.Text = "  "..text.."   ["..(S[key] and "ON" or "OFF").."]"
    b.TextColor3 = Color3.fromRGB(235, 235, 235)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = Scroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        b.Text = "  "..text.."   ["..(S[key] and "ON" or "OFF").."]"
        if key == "Fly" then ToggleFly(S.Fly) end
        if key == "FullBright" and S.FullBright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 9e9
            Lighting.GlobalShadows = false
        end
        if key == "Xray" then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsDescendantOf(LocalPlayer.Character) then
                    v.LocalTransparencyModifier = S.Xray and 0.7 or 0
                end
            end
        end
    end)
end

local function Slider(text, key, min, max, step)
    step = step or 1
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 68)
    h.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    h.Parent = Scroll
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 8)

    local lab = Instance.new("TextLabel")
    lab.Size = UDim2.new(1, -14, 0, 22)
    lab.Position = UDim2.new(0, 10, 0, 6)
    lab.BackgroundTransparency = 1
    lab.Text = text..": "..tostring(S[key])
    lab.TextColor3 = Color3.fromRGB(230, 230, 230)
    lab.Font = Enum.Font.Gotham
    lab.TextSize = 13
    lab.TextXAlignment = Enum.TextXAlignment.Left
    lab.Parent = h

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 12)
    bar.Position = UDim2.new(0, 10, 0, 38)
    bar.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
    bar.Parent = h
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 6)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((S[key]-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)

    local drag = false
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local r = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local v = math.floor((min + (max-min)*r)/step + 0.5)*step
            S[key] = v
            fill.Size = UDim2.new(r, 0, 1, 0)
            lab.Text = text..": "..tostring(v)
        end
    end)
end

Section("COMBAT")
Toggle("Aimbot", "Aimbot")
Toggle("Silent Aim", "SilentAim")
Toggle("Team Check", "TeamCheck")
Toggle("Hitbox Expand", "HitboxExpand")
Slider("FOV", "FOV", 40, 400, 5)
Slider("Smooth (düşük=hızlı)", "Smooth", 0.03, 0.40, 0.01)
Slider("Prediction", "Prediction", 0, 0.40, 0.01)
Slider("Hitbox Size", "HitboxSize", 5, 30, 1)

Section("VISUALS")
Toggle("ESP", "ESP")
Toggle("Box", "Box")
Toggle("Corner Box", "CornerBox")
Toggle("Name", "Name")
Toggle("Health Bar", "Health")
Toggle("Distance", "Distance")
Toggle("Tracer", "Tracer")
Toggle("Skeleton", "Skeleton")
Toggle("China Hat", "ChinaHat")
Toggle("FullBright", "FullBright")
Toggle("No Fog", "NoFog")
Toggle("Xray", "Xray")

Section("MOVEMENT")
Toggle("Fly", "Fly")
Toggle("Noclip", "Noclip")
Toggle("Infinite Jump", "InfiniteJump")
Slider("Walk Spe
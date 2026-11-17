-- R: Universal Hub v2 (Delta/Luau)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- ================= GUI CORE =================
local gui = Instance.new("ScreenGui")
gui.Name = "RHubV2"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
gui.Parent = LP:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 460, 0, 360)
main.Position = UDim2.new(0.5, -230, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", main); stroke.Color = Color3.fromRGB(0,170,255); stroke.Thickness = 1.5

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 32); title.BackgroundColor3 = Color3.fromRGB(32,32,42)
title.Text = "  R HUB v2"; title.TextColor3 = Color3.fromRGB(0,170,255)
title.Font = Enum.Font.GothamBold; title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32); closeBtn.Position = UDim2.new(1,-32,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50); closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = title
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 10)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- drag
local dragging, dragStart, startPos
title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = i.Position; startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1,-10,0,30); tabsBar.Position = UDim2.new(0,5,0,36)
tabsBar.BackgroundTransparency = 1; tabsBar.Parent = main
local tl = Instance.new("UIListLayout", tabsBar); tl.FillDirection = Enum.FillDirection.Horizontal; tl.Padding = UDim.new(0,3)

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1,-10,1,-76); content.Position = UDim2.new(0,5,0,70)
content.BackgroundTransparency = 1; content.BorderSizePixel = 0
content.ScrollBarThickness = 3; content.CanvasSize = UDim2.new(0,0,0,0)
content.Parent = main

local tabs = {}
local function newTab(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,85,1,0); b.BackgroundColor3 = Color3.fromRGB(32,32,42)
    b.Text = name; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham; b.TextSize = 12; b.Parent = tabsBar
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1,0,1,0); p.BackgroundTransparency = 1; p.Visible = false; p.Parent = content
    tabs[#tabs+1] = {btn=b, page=p}
    b.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabs) do t.page.Visible=false; t.btn.BackgroundColor3=Color3.fromRGB(32,32,42) end
        p.Visible = true; b.BackgroundColor3 = Color3.fromRGB(0,120,200)
    end)
    return p
end

local function label(parent, text, y)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-10,0,20); l.Position = UDim2.new(0,5,0,y)
    l.BackgroundTransparency = 1; l.Text = text
    l.TextColor3 = Color3.fromRGB(180,180,190); l.Font = Enum.Font.Gotham
    l.TextSize = 13; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = parent
end

local function toggle(parent, text, y, default, cb)
    local state = default or false
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,160,0,28); b.Position = UDim2.new(0,5,0,y)
    b.BackgroundColor3 = state and Color3.fromRGB(0,140,80) or Color3.fromRGB(60,60,70)
    b.Text = text..": "..(state and "ON" or "OFF")
    b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 12; b.Parent = parent
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(0,140,80) or Color3.fromRGB(60,60,70)
        b.Text = text..": "..(state and "ON" or "OFF")
        cb(state)
    end)
end

local function slider(parent, text, y, min, max, default, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-10,0,40); f.Position = UDim2.new(0,5,0,y)
    f.BackgroundTransparency = 1; f.Parent = parent
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,0,0,18); l.BackgroundTransparency = 1
    l.Text = text..": "..default; l.TextColor3 = Color3.fromRGB(180,180,190)
    l.Font = Enum.Font.Gotham; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(1,0,0,18); bar.Position = UDim2.new(0,0,0,20)
    bar.BackgroundColor3 = Color3.fromRGB(60,60,70); bar.Text = ""; bar.Parent = f
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(0,170,255); fill.BorderSizePixel = 0; fill.Parent = bar
    local ds = false
    local function setVal(x)
        local rel = math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
        local v = math.floor(min + rel*(max-min))
        fill.Size = UDim2.new(rel,0,1,0); l.Text = text..": "..v; cb(v)
    end
    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then ds=true; setVal(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then ds=false end
    end)
    UIS.InputChanged:Connect(function(i)
        if ds and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then setVal(i.Position.X) end
    end)
end

local function textbox(parent, placeholder, y, cb)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(1,-10,0,26); t.Position = UDim2.new(0,5,0,y)
    t.BackgroundColor3 = Color3.fromRGB(50,50,60); t.TextColor3 = Color3.new(1,1,1)
    t.PlaceholderText = placeholder; t.Font = Enum.Font.Gotham; t.TextSize = 12
    t.Parent = parent
    t.FocusLost:Connect(function() cb(t.Text) end)
end

-- ================= TABS =================
local tVisual = newTab("Visual")
local tCombat = newTab("Combat")
local tMove = newTab("Move")
local tMisc = newTab("Misc")
tabs[1].page.Visible = true; tabs[1].btn.BackgroundColor3 = Color3.fromRGB(0,120,200)

-- ================= ESP =================
local espEnabled = false
local espColor = Color3.fromRGB(255,60,60)
local espCache = {}
local function newLine()
    local l = Drawing.new("Line"); l.Visible=false; l.Color=espColor; l.Thickness=1; l.Transparency=1; return l
end
local function getParts(c)
    return {
        Head=c:FindFirstChild("Head"),
        UT=c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso"),
        LT=c:FindFirstChild("LowerTorso") or c:FindFirstChild("Torso"),
        LA=c:FindFirstChild("LeftUpperArm") or c:FindFirstChild("Left Arm"),
        RA=c:FindFirstChild("RightUpperArm") or c:FindFirstChild("Right Arm"),
        LL=c:FindFirstChild("LeftUpperLeg") or c:FindFirstChild("Left Leg"),
        RL=c:FindFirstChild("RightUpperLeg") or c:FindFirstChild("Right Leg"),
    }
end
local function dl(l, a, b)
    if espEnabled and a and b then
        local pa, oa = Camera:WorldToViewportPoint(a.Position)
        local pb, ob = Camera:WorldToViewportPoint(b.Position)
        if oa and ob then l.From=Vector2.new(pa.X,pa.Y); l.To=Vector2.new(pb.X,pb.Y); l.Visible=true; return end
    end
    l.Visible = false
end
local function updateESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            if not espCache[p] then
                espCache[p] = {ht=newLine(),la=newLine(),ra=newLine(),ll=newLine(),rl=newLine()}
            end
            local c = espCache[p]; local b = getParts(p.Character)
            dl(c.ht, b.Head, b.UT); dl(c.la, b.UT, b.LA); dl(c.ra, b.UT, b.RA)
            dl(c.ll, b.LT, b.LL); dl(c.rl, b.LT, b.RL)
        elseif espCache[p] then
            for _, l in pairs(espCache[p]) do l.Visible = false end
        end
    end
end

toggle(tVisual, "Skeleton ESP", 10, false, function(s) espEnabled = s end)
label(tVisual, "ESP Color", 45)
textbox(tVisual, "255,60,60", 70, function(txt)
    local r,g,b = txt:match("(%d+),(%d+),(%d+)")
    if r and g and b then espColor = Color3.fromRGB(tonumber(r),tonumber(g),tonumber(b)) end
end)
label(tVisual, "Aimbot", 105)
local aimEnabled = false
local aimFov = 150
local aimSmooth = 0.3
slider(tVisual, "FOV", 130, 50, 400, 150, function(v) aimFov = v end)
slider(tVisual, "Smooth", 180, 0, 100, 30, function(v) aimSmooth = v/100 end)
toggle(tVisual, "Aimbot (RMB)", 230, false, function(s) aimEnabled = s end)
label(tVisual, "Lighting", 265)
toggle(tVisual, "Fullbright", 290, false, function(s)
    if s then Lighting.Ambient=Color3.fromRGB(200,200,200); Lighting.OutdoorAmbient=Color3.fromRGB(200,200,200); Lighting.Brightness=3
    else Lighting.Ambient=Color3.fromRGB(0,0,0); Lighting.OutdoorAmbient=Color3.fromRGB(128,128,128); Lighting.Brightness=1 end
end)
toggle(tVisual, "No Fog", 325, false, function(s) Lighting.FogEnd = s and 1e6 or 1000 end)

-- ================= COMBAT =================
local hitboxEnabled = false
local hitboxSize = 5
label(tCombat, "Hitbox Expander", 10)
slider(tCombat, "Size", 35, 1, 20, 5, function(v) hitboxSize = v end)
toggle(tCombat, "Hitbox Expander", 85, false, function(s)
    hitboxEnabled = s
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if s then
                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    hrp.Transparency = 0.5
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2,2,1); hrp.Transparency = 1
                end
            end
        end
    end
end)
toggle(tCombat, "Auto-Clicker", 120, false, function(s)
    if s then
        task.spawn(function()
            local vu = game:GetService("VirtualUser")
            while hitboxEnabled or true do
                if not _G.RAutoClick then break end
                vu:CaptureController(); vu:Button1Down(Vector2.new(0.5,0.5))
                task.wait(0.1)
            end
        end)
        _G.RAutoClick = true
    else _G.RAutoClick = false end
end)
label(tCombat, "Anti-Ragdoll", 155)
toggle(tCombat, "Anti-Ragdoll", 180, false, function(s)
    if s then
        task.spawn(function()
            while _G.RAntiRag do
                local c = LP.Character
                if c and c:FindFirstChild("Humanoid") then c.Humanoid.PlatformStand = false end
                task.wait(0.1)
            end
        end)
        _G.RAntiRag = true
    else _G.RAntiRag = false end
end)

-- ================= MOVE =================
local speedEnabled = false
local speedValue = 50
slider(tMove, "Speed", 10, 16, 200, 50, function(v) speedValue = v end)
toggle(tMove, "Speed Hack", 60, false, function(s) speedEnabled = s end)
local jumpEnabled = false
toggle(tMove, "Infinite Jump", 95, false, function(s)
    jumpEnabled = s
    if s then
        UIS.JumpRequest:Connect(function()
            if jumpEnabled and LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)
local flyEnabled = false
local flySpeed = 50
slider(tMove, "Fly Speed", 130, 10, 200, 50, function(v) flySpeed = v end)
toggle(tMove, "Fly (WASD)", 180, false, function(s)
    flyEnabled = s
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if s then
        local bv = Instance.new("BodyVelocity")
        bv.Name="RFly"; bv.MaxForce=Vector3.new(1e5,1e5,1e5); bv.Velocity=Vector3.zero; bv.Parent=hrp
    else
        local bv = hrp:FindFirstChild("RFly"); if bv then bv:Destroy() end
    end
end)
local waterEnabled = false
toggle(tMove, "Walk on Water", 215, false, function(s)
    waterEnabled = s
    if s then
        task.spawn(function()
            while waterEnabled do
                local c = LP.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    local r = RaycastParams.new()
                    r.FilterDescendantsInstances = {c}
                    local res = workspace:Raycast(c.HumanoidRootPart.Position, Vector3.new(0,-10,0), r)
                    if res and res.Instance.Material == Enum.Material.Water then
                        c.HumanoidRootPart.CFrame = CFrame.new(c.HumanoidRootPart.Position + Vector3.new(0,3,0))
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- ================= MISC =================
local tpMode = "click"
local function getChars()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then t[#t+1]=p end
    end
    return t
end

local function refreshPlayers()
    for _, c in ipairs(tMisc:GetChildren()) do
        if c.Name == "PBtn" then c:Destroy() end
    end
    local y = 200
    for _, p in ipairs(getChars()) do
        local b = Instance.new("TextButton")
        b.Name="PBtn"; b.Size=UDim2.new(0,200,0,24); b.Position=UDim2.new(0,5,0,y)
        b.BackgroundColor3=Color3.fromRGB(50,50,60); b.Text=p.Name
        b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.Gotham; b.TextSize=12; b.Parent=tMisc
        b.MouseButton1Click:Connect(function()
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            local tgt = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and tgt then hrp.CFrame = tgt.CFrame + Vector3.new(0,3,0) end
        end)
        y = y + 28
    end
    content.CanvasSize = UDim2.new(0,0,0,math.max(y+50, 500))
end

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size=UDim2.new(0,200,0,28); refreshBtn.Position=UDim2.new(0,5,0,10)
refreshBtn.BackgroundColor3=Color3.fromRGB(0,140,80); refreshBtn.Text="Refresh Players"
refreshBtn.TextColor3=Color3.new(1,1,1); refreshBtn.Font=Enum.Font.GothamBold; refreshBtn.Parent=tMisc
refreshBtn.MouseButton1Click:Connect(refreshPlayers)

label(tMisc, "Click TP", 50)
toggle(tMisc, "Click TP", 75, false, function(s)
    _G.RClickTP = s
end)
UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if _G.RClickTP and i.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = UIS:GetMouseLocation()
        local ray = Camera:ViewportPointToRay(mouse.X, mouse.Y)
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {LP.Character}
        local r = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
        if r and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(r.Position + Vector3.new(0,3,0))
        end
    end
end)

label(tMisc, "Anti-AFK", 110)
toggle(tMisc, "Anti-AFK", 135, false, function(s)
    _G.RAntiAFK = s
    if s then
        task.spawn(function()
            while _G.RAntiAFK do
                local vu = game:GetService("VirtualUser")
                vu:CaptureController(); vu:Button2Down(Vector2.new(0.5,0.5))
                task.wait(0.1); vu:Button2Up(Vector2.new(0.5,0.5))
                task.wait(30)
            end
        end)
    end
end)

label(tMisc, "Server Hop", 170)
local hopBtn = Instance.new("TextButton")
hopBtn.Size=UDim2.new(0,200,0,28); hopBtn.Position=UDim2.new(0,5,0,195)
hopBtn.BackgroundColor3=Color3.fromRGB(0,120,200); hopBtn.Text="Server Hop"
hopBtn.TextColor3=Color3.new(1,1,1); hopBtn.Font=Enum.Font.GothamBold; hopBtn.Parent=tMisc
hopBtn.MouseButton1Click:Connect(function()
    local ts = game:GetService("TeleportService")
    local http = game:GetService("HttpService")
    local ok, list = pcall(function()
        return http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))
    end)
    if ok and list and list.data then
        for _, s in ipairs(list.data) do
            if s.playing < s.maxPlayers then
                ts:TeleportToPlaceInstance(game.PlaceId, s.id, LP); return
            end
        end
    end
end)

-- ================= CONFIG SAVE/LOAD =================
local config = {}
label(tMisc, "Config", 235)
local saveBtn = Instance.new("TextButton")
saveBtn.Size=UDim2.new(0,95,0,26); saveBtn.Position=UDim2.new(0,5,0,260)
saveBtn.BackgroundColor3=Color3.fromRGB(0,140,80); saveBtn.Text="Save"
saveBtn.TextColor3=Color3.new(1,1,1); saveBtn.Parent=tMisc
saveBtn.MouseButton1Click:Connect(function()
    config.speed = speedValue; config.jump = jumpEnabled; config.fly = flySpeed
    config.esp = espEnabled; config.aimFov = aimFov; config.hitbox = hitboxSize
    if writefile then
        pcall(function() writefile("Rhub_config.json", game:GetService("HttpService"):JSONEncode(config)) end)
    end
end)
local loadBtn = Instance.new("TextButton")
loadBtn.Size=UDim2.new(0,95,0,26); loadBtn.Position=UDim2.new(0,105,0,260)
loadBtn.BackgroundColor3=Color3.fromRGB(0,120,200); loadBtn.Text="Load"
loadBtn.TextColor3=Color3.new(1,1,1); loadBtn.Parent=tMisc
loadBtn.MouseButton1Click:Connect(function()
    if readfile and isfile and isfile("Rhub_config.json") then
        local ok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile("Rhub_config.json")) end)
        if ok and data then
            speedValue = data.speed or 50; jumpEnabled = data.jump or false
            flySpeed = data.fly or 50; espEnabled = data.esp or false
            aimFov = data.aimFov or 150; hitboxSize = data.hitbox or 5
        end
    end
end)

-- ================= MAIN LOOP =================
local function closestTarget()
    local center = Camera.ViewportSize/2
    local mouse = UIS:GetMouseLocation()
    if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then mouse = center end
    local best, bestD = nil, aimFov
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local h = p.Character:FindFirstChild("Head")
            if h then
                local sp, on = Camera:WorldToViewportPoint(h.Position)
                if on then
                    local d = (Vector2.new(sp.X,sp.Y)-mouse).Magnitude
                    if d < bestD then bestD=d; best=h end
                end
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function(dt)
    updateESP()
    -- aim
    if aimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = closestTarget()
        if t then
            local pos = Camera.CFrame.Position
            local goal = CFrame.new(pos, t.Position)
            Camera.CFrame = Camera.CFrame:Lerp(goal, 1-aimSmooth)
        end
    end
    -- sp

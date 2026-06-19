--// MOBILE HUB v6 - Toggle: puxar só ao atirar (FireButton) ou sempre
--// Fully Functional UI with Configurations

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// WeaponSystem
local WS = require(
    ReplicatedStorage
        :WaitForChild("WeaponsSystem")
        :WaitForChild("WeaponsSystem")
)
local WSCamera = WS.camera

--// ============================================
--// CONFIGURAÇÕES GLOBAIS (TUDO DESLIGADO POR PADRÃO)
--// ============================================

local Config = {
    AimAssist = {
        Enabled = false,
        FOV = 30,
        Smoothness = 0.18,
        MaxDistance = 400,
        WallCheck = true,
        AimPart = "Head",
        OffsetY = 0.18,
        PredictEnabled = false,
        BulletSpeed = 1000,
        GravityFactor = 0,
        PredictOnlyLateral = true,
        RecoilReducao = 0.8,
        TrackingSoLateral = true,
        MinHealth = 4,
        OnlyFireButton = true,  -- NOVO: true = só no FireButton, false = sempre
    },

    SilentAim = {
        Enabled = false,
        FOV = 100,
        TargetPart = "Head",
        Prediction = 0.045,
        HeadOffset = Vector3.new(0, 0.12, 0),
        WallCheck = true,
    },

    Hub = {
        Keybind = Enum.KeyCode.RightShift,
        MobileButton = true,
    }
}

--// Variáveis de Estado
local CurrentTarget = nil
local YTravado = nil
local firing = false
local HubVisible = false
local UI = {}

--// ============================================
--// FUNÇÕES UTILITÁRIAS
--// ============================================

local function GetCenter()
    local v = Camera.ViewportSize
    return Vector2.new(v.X / 2, v.Y / 2)
end

local function WallCheck(part)
    local origin = Camera.CFrame.Position
    local direction = part.Position - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LP.Character}
    local result = Workspace:Raycast(origin, direction, params)
    if not result then return true end
    return result.Instance:IsDescendantOf(part.Parent)
end

local function EstaNoChao(humanoid)
    return humanoid.FloorMaterial ~= Enum.Material.Air
end

local function CalcularPredictAlvo(alvoPos, alvoVel, minhaPos, bulletSpeed, gravity)
    if not Config.AimAssist.PredictEnabled then return alvoPos end
    local distancia = (alvoPos - minhaPos).Magnitude
    local tempoVoo = distancia / bulletSpeed
    if gravity > 0 then tempoVoo = tempoVoo * 1.2 end
    local posicaoFutura = alvoPos + (alvoVel * tempoVoo)
    if Config.AimAssist.PredictOnlyLateral then
        posicaoFutura = Vector3.new(posicaoFutura.X, alvoPos.Y, posicaoFutura.Z)
    end
    return posicaoFutura
end

local function GetAimPosition(part, humanoid, root, minhaPos)
    local basePos = part.Position
    local headSize = part.Size.Y
    local offsetY = headSize * Config.AimAssist.OffsetY
    local velocidade = root and root.Velocity or Vector3.new(0, 0, 0)
    local posicaoComPredict = CalcularPredictAlvo(basePos, velocidade, minhaPos, Config.AimAssist.BulletSpeed, Config.AimAssist.GravityFactor)

    if Config.AimAssist.TrackingSoLateral then
        if EstaNoChao(humanoid) then
            YTravado = basePos.Y + offsetY
        else
            if YTravado == nil then YTravado = basePos.Y + offsetY end
        end
        return Vector3.new(posicaoComPredict.X, YTravado, posicaoComPredict.Z)
    else
        return Vector3.new(posicaoComPredict.X, basePos.Y + offsetY, posicaoComPredict.Z)
    end
end

local function GetTargetAimAssist()
    local center = GetCenter()
    local closest = nil
    local shortest = Config.AimAssist.FOV
    local minhaPos = Camera.CFrame.Position

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LP then continue end
        if not plr.Character then continue end
        local part = plr.Character:FindFirstChild(Config.AimAssist.AimPart)
        if not part then continue end
        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        if humanoid.Health <= 4 then continue end
        local root = plr.Character:FindFirstChild("HumanoidRootPart")
        local aimPos = GetAimPosition(part, humanoid, root, minhaPos)
        local pos, onScreen = Camera:WorldToViewportPoint(aimPos)
        if not onScreen then continue end
        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
        if dist < shortest then
            if not Config.AimAssist.WallCheck or WallCheck(part) then
                shortest = dist
                closest = {Part = part, Humanoid = humanoid, Root = root}
            end
        end
    end
    return closest
end

local function PodeMirar()
    if not WS.camera then return false end
    if not WS.camera.enabled then return false end
    if not WS.currentWeapon then return false end
    return true
end

local function worldToScreen(pos)
    local v, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), onScreen
end

local function getTargetSilent()
    local bestTarget = nil
    local bestDist = Config.SilentAim.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local part = char:FindFirstChild(Config.SilentAim.TargetPart)
            local root = char:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 4 and part and root then
                if Config.SilentAim.WallCheck and not WallCheck(part) then continue end
                local screenPos, onScreen = worldToScreen(part.Position)
                if onScreen then
                    local dist = (screenPos - center).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        bestTarget = part
                    end
                end
            end
        end
    end
    return bestTarget
end

local function applySilent()
    if not Config.SilentAim.Enabled then return end
    if not firing then return end
    if not WSCamera or not WSCamera.currentCFrame then return end
    local weapon = WS.currentWeapon
    if not weapon then return end
    local target = getTargetSilent()
    if not target then return end
    local root = target.Parent:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local predictedPos = target.Position + Config.SilentAim.HeadOffset + root.AssemblyLinearVelocity * Config.SilentAim.Prediction
    local camPos = WSCamera.currentCFrame.Position
    WSCamera.currentCFrame = CFrame.lookAt(camPos, predictedPos)
end

--// ============================================
--// FIRE BUTTON DETECTION (Game's UI)
--// ============================================

local function GetFireButton()
    local success, result = pcall(function()
        return LP.PlayerGui.HudSystem.Gun.GunButtons.FireButton
    end)
    if success and result then
        return result
    end
    return nil
end

local function SetupFireButtonDetection()
    local fireBtn = GetFireButton()
    if not fireBtn then
        task.delay(2, SetupFireButtonDetection)
        return
    end

    print("✅ FireButton detectado!")

    fireBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            firing = true
        end
    end)

    fireBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            firing = false
            CurrentTarget = nil
            YTravado = nil
        end
    end)

    fireBtn.AncestryChanged:Connect(function()
        task.delay(0.5, SetupFireButtonDetection)
    end)
end

--// ============================================
--// UI CREATION
--// ============================================

local function CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MobileHub"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LP:WaitForChild("PlayerGui")
    UI.ScreenGui = screenGui

    --// MOBILE TOGGLE BUTTON (Floating + Draggable)
    local mobileBtn = Instance.new("TextButton")
    mobileBtn.Name = "MobileToggle"
    mobileBtn.Size = UDim2.new(0, 60, 0, 60)
    mobileBtn.Position = UDim2.new(0, 20, 0.5, -30)
    mobileBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mobileBtn.BorderSizePixel = 0
    mobileBtn.Text = "📱"
    mobileBtn.TextSize = 28
    mobileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mobileBtn.Font = Enum.Font.GothamBold
    mobileBtn.Parent = screenGui

    local mobileCorner = Instance.new("UICorner")
    mobileCorner.CornerRadius = UDim.new(1, 0)
    mobileCorner.Parent = mobileBtn

    local mobileStroke = Instance.new("UIStroke")
    mobileStroke.Color = Color3.fromRGB(0, 170, 255)
    mobileStroke.Thickness = 2
    mobileStroke.Parent = mobileBtn

    -- Draggable mobile button
    local btnDragging = false
    local btnDragStart = nil
    local btnStartPos = nil

    mobileBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            btnDragging = true
            btnDragStart = input.Position
            btnStartPos = mobileBtn.Position
        end
    end)

    mobileBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            btnDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if btnDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - btnDragStart
            mobileBtn.Position = UDim2.new(
                btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X,
                btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y
            )
        end
    end)

    UI.MobileButton = mobileBtn

    --// MAIN FRAME
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainHub"
    mainFrame.Size = UDim2.new(0, 340, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -170, 0.5, -240)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    UI.MainFrame = mainFrame

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 170, 255)
    mainStroke.Thickness = 2
    mainStroke.Parent = mainFrame

    --// TITLE BAR
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar

    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🔫 MOBILE HUB"
    titleText.TextColor3 = Color3.fromRGB(0, 170, 255)
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -40, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    --// TAB BUTTONS
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(1, -20, 0, 40)
    tabFrame.Position = UDim2.new(0, 10, 0, 50)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.Parent = tabFrame

    UI.Tabs = {}
    UI.CurrentTab = "AimAssist"

    local function CreateTabButton(name, displayName)
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Tab"
        btn.Size = UDim2.new(0.5, -4, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.BorderSizePixel = 0
        btn.Text = displayName
        btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Parent = tabFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        UI.Tabs[name] = btn
        return btn
    end

    CreateTabButton("AimAssist", "🎯 Aim Assist")
    CreateTabButton("SilentAim", "🔇 Silent Aim")

    --// CONTENT FRAME
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -105)
    contentFrame.Position = UDim2.new(0, 10, 0, 95)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 6
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.Parent = mainFrame
    contentFrame.ScrollingEnabled = true
    contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    contentFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    contentFrame.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    UI.ContentFrame = contentFrame

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = contentFrame

    local function UpdateCanvasSize()
        task.wait(0.05)
        local totalHeight = contentLayout.AbsoluteContentSize.Y + contentLayout.Padding.Offset * 2
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end

    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)

    --// FOV CIRCLE VISUAL
    local fovCircle = Instance.new("Frame")
    fovCircle.Name = "FOVCircle"
    fovCircle.Size = UDim2.new(0, Config.AimAssist.FOV * 2, 0, Config.AimAssist.FOV * 2)
    fovCircle.Position = UDim2.new(0.5, -Config.AimAssist.FOV, 0.5, -Config.AimAssist.FOV)
    fovCircle.BackgroundTransparency = 1
    fovCircle.BorderSizePixel = 0
    fovCircle.Visible = false
    fovCircle.Parent = screenGui

    local circleStroke = Instance.new("UIStroke")
    circleStroke.Color = Color3.fromRGB(0, 170, 255)
    circleStroke.Thickness = 1.5
    circleStroke.Parent = fovCircle

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = fovCircle

    UI.FOVCircle = fovCircle

    return UI
end

--// ============================================
--// UI COMPONENTS
--// ============================================

local function CreateToggle(parent, text, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 26)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -13)
    toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 70)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = defaultValue and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 13)
    toggleCorner.Parent = toggleBtn

    local state = defaultValue
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 70)
        toggleBtn.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)

    return frame, function() return state end
end

local function CreateSlider(parent, text, min, max, default, decimals, callback, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.65, 0, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default) .. (suffix or "")
    valueLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -24, 0, 8)
    sliderFrame.Position = UDim2.new(0, 12, 0, 35)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = frame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderFrame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderFrame

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = sliderFrame

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local dragging = false
    local currentValue = default

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * pos
        if decimals then
            local mult = 10 ^ decimals
            value = math.floor(value * mult + 0.5) / mult
        else
            value = math.floor(value + 0.5)
        end
        currentValue = value
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -8, 0.5, -8)
        valueLabel.Text = tostring(value) .. (suffix or "")
        if callback then callback(value) end
    end

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    return frame, function() return currentValue end
end

local function CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 30)
    section.BackgroundTransparency = 1
    section.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "━━ " .. title .. " ━━"
    label.TextColor3 = Color3.fromRGB(0, 170, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section

    return section
end

--// ============================================
--// BUILD TABS CONTENT
--// ============================================

local function BuildAimAssistTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.Parent = UI.ContentFrame
    UI.AimAssistContainer = container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container

    CreateSection(container, "GERAL")

    CreateToggle(container, "🎯 Ativar Aim Assist", Config.AimAssist.Enabled, function(v)
        Config.AimAssist.Enabled = v
    end)

    -- NOVO: Toggle para escolher se puxa só no FireButton ou sempre
    CreateToggle(container, "🔫 Só no FireButton", Config.AimAssist.OnlyFireButton, function(v)
        Config.AimAssist.OnlyFireButton = v
    end)

    CreateToggle(container, "🔍 Wall Check", Config.AimAssist.WallCheck, function(v)
        Config.AimAssist.WallCheck = v
    end)

    CreateToggle(container, "📊 Mostrar FOV", false, function(v)
        UI.FOVCircle.Visible = v
    end)

    CreateSection(container, "AJUSTES")

    CreateSlider(container, "📐 FOV Radius", 10, 200, Config.AimAssist.FOV, 0, function(v)
        Config.AimAssist.FOV = v
        UI.FOVCircle.Size = UDim2.new(0, v * 2, 0, v * 2)
        UI.FOVCircle.Position = UDim2.new(0.5, -v, 0.5, -v)
    end, "px")

    CreateSlider(container, "🔄 Smoothness", 0.01, 1, Config.AimAssist.Smoothness, 2, function(v)
        Config.AimAssist.Smoothness = v
    end)

    CreateSlider(container, "📏 Max Distance", 50, 1000, Config.AimAssist.MaxDistance, 0, function(v)
        Config.AimAssist.MaxDistance = v
    end, " studs")

    CreateSlider(container, "⬆️ Offset Y", 0, 1, Config.AimAssist.OffsetY, 2, function(v)
        Config.AimAssist.OffsetY = v
    end)

    CreateSection(container, "PREDIÇÃO")

    CreateToggle(container, "🔮 Predict Ativo", Config.AimAssist.PredictEnabled, function(v)
        Config.AimAssist.PredictEnabled = v
    end)

    CreateSlider(container, "⚡ Bullet Speed", 100, 5000, Config.AimAssist.BulletSpeed, 0, function(v)
        Config.AimAssist.BulletSpeed = v
    end)

    CreateToggle(container, "↔️ Predict Só Lateral", Config.AimAssist.PredictOnlyLateral, function(v)
        Config.AimAssist.PredictOnlyLateral = v
    end)

    CreateSection(container, "TRACKING & RECOIL")

    CreateToggle(container, "↔️ Tracking Lateral", Config.AimAssist.TrackingSoLateral, function(v)
        Config.AimAssist.TrackingSoLateral = v
    end)

    CreateSlider(container, "💨 Redução Recoil", 0, 1, Config.AimAssist.RecoilReducao, 2, function(v)
        Config.AimAssist.RecoilReducao = v
    end, "%")

    -- Info: comportamento fixo
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, 0, 0, 55)
    infoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = container

    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = infoFrame

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -16, 1, -8)
    infoLabel.Position = UDim2.new(0, 8, 0, 4)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "🔒 FIXO: ❤️ Não puxa se vida ≤ 4"
    infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    infoLabel.TextSize = 11
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextWrapped = true
    infoLabel.TextYAlignment = Enum.TextYAlignment.Center
    infoLabel.Parent = infoFrame
end

local function BuildSilentAimTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.Visible = false
    container.Parent = UI.ContentFrame
    UI.SilentAimContainer = container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container

    CreateSection(container, "GERAL")

    CreateToggle(container, "🔇 Ativar Silent Aim", Config.SilentAim.Enabled, function(v)
        Config.SilentAim.Enabled = v
    end)

    CreateToggle(container, "🔍 Wall Check", Config.SilentAim.WallCheck, function(v)
        Config.SilentAim.WallCheck = v
    end)

    CreateSection(container, "AJUSTES")

    CreateSlider(container, "📐 FOV Radius", 10, 300, Config.SilentAim.FOV, 0, function(v)
        Config.SilentAim.FOV = v
    end, "px")

    CreateSlider(container, "🔮 Prediction", 0, 0.2, Config.SilentAim.Prediction, 3, function(v)
        Config.SilentAim.Prediction = v
    end)

    CreateSlider(container, "⬆️ Head Offset Y", 0, 0.5, 0.12, 2, function(v)
        Config.SilentAim.HeadOffset = Vector3.new(0, v, 0)
    end)

    CreateSection(container, "INFO")

    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, 0, 0, 80)
    infoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = container

    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = infoFrame

    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, -20, 1, -10)
    infoText.Position = UDim2.new(0, 10, 0, 5)
    infoText.BackgroundTransparency = 1
    infoText.Text = "💡 Silent Aim funciona ao atirar.\nMantenha pressionado para ativar.\nNão puxa se vida ≤ 4."
    infoText.TextColor3 = Color3.fromRGB(180, 180, 180)
    infoText.TextSize = 12
    infoText.Font = Enum.Font.Gotham
    infoText.TextWrapped = true
    infoText.TextYAlignment = Enum.TextYAlignment.Center
    infoText.Parent = infoFrame
end

--// ============================================
--// TAB SWITCHING
--// ============================================

local function SwitchTab(tabName)
    UI.CurrentTab = tabName

    for name, btn in pairs(UI.Tabs) do
        if name == tabName then
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end

    UI.AimAssistContainer.Visible = (tabName == "AimAssist")
    UI.SilentAimContainer.Visible = (tabName == "SilentAim")

    task.delay(0.1, function()
        if UI.ContentFrame then
            local visibleContainer = tabName == "AimAssist" and UI.AimAssistContainer or UI.SilentAimContainer
            if visibleContainer then
                local layout = visibleContainer:FindFirstChildOfClass("UIListLayout")
                if layout then
                    local totalHeight = layout.AbsoluteContentSize.Y + 20
                    UI.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
                end
            end
        end
    end)
end

--// ============================================
--// TOGGLE HUB VISIBILITY
--// ============================================

local function ToggleHub()
    HubVisible = not HubVisible
    UI.MainFrame.Visible = HubVisible

    if HubVisible then
        local tween = TweenService:Create(UI.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 340, 0, 480)
        })
        tween:Play()
        task.delay(0.2, function()
            local visibleContainer = UI.CurrentTab == "AimAssist" and UI.AimAssistContainer or UI.SilentAimContainer
            if visibleContainer then
                local layout = visibleContainer:FindFirstChildOfClass("UIListLayout")
                if layout then
                    UI.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
                end
            end
        end)
    end
end

--// ============================================
--// INITIALIZE UI
--// ============================================

CreateUI()
BuildAimAssistTab()
BuildSilentAimTab()

UI.Tabs.AimAssist.MouseButton1Click:Connect(function() SwitchTab("AimAssist") end)
UI.Tabs.SilentAim.MouseButton1Click:Connect(function() SwitchTab("SilentAim") end)

UI.MobileButton.MouseButton1Click:Connect(ToggleHub)

UI.MainFrame.TitleBar.Close.MouseButton1Click:Connect(function()
    HubVisible = false
    UI.MainFrame.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Config.Hub.Keybind then
        ToggleHub()
    end
end)

SwitchTab("AimAssist")

--// ============================================
--// FIRE BUTTON DETECTION (Game's UI)
--// ============================================

SetupFireButtonDetection()

--// ============================================
--// MAIN LOOPS
--// ============================================

-- Recoil Reduction
RunService.RenderStepped:Connect(function()
    if not WS.camera then return end
    if not WS.camera.currentRecoil then return end
    WS.camera.currentRecoil = WS.camera.currentRecoil * Config.AimAssist.RecoilReducao
end)

-- Aim Assist - respeita o toggle OnlyFireButton
RunService.RenderStepped:Connect(function()
    -- Se OnlyFireButton estiver ON, só ativa quando firing == true
    if Config.AimAssist.OnlyFireButton and not firing then
        CurrentTarget = nil
        YTravado = nil
        return
    end

    -- Se Aim Assist OFF
    if not Config.AimAssist.Enabled then return end

    -- Se sem arma
    if not PodeMirar() then 
        CurrentTarget = nil
        YTravado = nil
        return 
    end

    local target = GetTargetAimAssist()
    CurrentTarget = target

    if target then
        local cam = WS.camera
        if not cam or not cam.currentCamera then return end

        local camPos = cam.currentCamera.CFrame.Position
        local aimPos = GetAimPosition(target.Part, target.Humanoid, target.Root, camPos)

        local currentLook = cam.currentCamera.CFrame.LookVector
        local targetLook = (aimPos - camPos).Unit

        local screenPos = Camera:WorldToViewportPoint(aimPos)
        local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - GetCenter()).Magnitude
        local smoothFactor = Config.AimAssist.Smoothness * (1 - (distFromCenter / Config.AimAssist.FOV))

        local newLook = currentLook:Lerp(targetLook, math.clamp(smoothFactor, 0.01, Config.AimAssist.Smoothness))

        local newCFrame = CFrame.new(camPos, camPos + newLook)
        cam.currentCamera.CFrame = newCFrame
        cam.currentCFrame = newCFrame

        cam.yaw = math.atan2(-newLook.X, -newLook.Z)
        cam.pitch = math.asin(math.clamp(newLook.Y, -0.99, 0.99))
    else
        YTravado = nil
    end
end)

-- Silent Aim (Dual timing) - sempre só no FireButton
RunService.RenderStepped:Connect(applySilent)
RunService.Heartbeat:Connect(applySilent)

--// ============================================
--// CHAT COMMANDS
--// ============================================

LP.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    local cmd = args[1]:lower()

    if cmd == "/hub" then
        ToggleHub()
    elseif cmd == "/aim" then
        Config.AimAssist.Enabled = not Config.AimAssist.Enabled
        print("Aim Assist:", Config.AimAssist.Enabled and "ON" or "OFF")
    elseif cmd == "/silent" then
        Config.SilentAim.Enabled = not Config.SilentAim.Enabled
        print("Silent Aim:", Config.SilentAim.Enabled and "ON" or "OFF")
    end
end)

--// ============================================
--// PRINT INFO
--// ============================================

print("✅ MOBILE HUB v6 CARREGADO!")
print("📱 Botão flutuante ARRASTÁVEL no canto esquerdo")
print("⌨️ Pressione RightShift para abrir/fechar")
print("💬 /hub para abrir pelo chat")
print("⚠️ TUDO DESLIGADO por padrão - ative no hub!")
print("🔫 'Só no FireButton' = ON → puxa só ao clicar no botão de atirar")
print("🔫 'Só no FireButton' = OFF → puxa sempre (modo clássico)")

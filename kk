--// Load WindUI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--// Create Window + Key System
local Window = WindUI:CreateWindow({
    Title = "Faz Completo",
    Icon = "zap",
    Author = "Oi prazer sou o Lyrics",
    Folder = "FazCompleto",

    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    HideSearchBar = true,

    User = {
        Enabled = true,
        Anonymous = true,
    },

    -- 🔐 KEY SYSTEM
    KeySystem = {
        Key = { "batman" },
        Note = "Acesso restrito. Digite a key correta.",
        SaveKey = false,
    },
})

--// Notify
WindUI:Notify({
    Title = "vlw cumparsa",
    Content = "paraem de xitar seus vermes!",
    Duration = 6
})

--// Tabs
local Tabs = {
    Basico   = Window:Tab({Title="Básico", Icon="home"}),
    Esp      = Window:Tab({Title="ESP", Icon="eye"}),
    Comprar  = Window:Tab({Title="Comprar", Icon="shopping-cart"}),
    Combate  = Window:Tab({Title="Combate", Icon="crosshair"}),
    TP       = Window:Tab({Title="Teleportes", Icon="map-pin"}),
    Veiculo  = Window:Tab({Title="Veículo", Icon="car"}),
}

-------------------------------------------------------
-- BÁSICO
-------------------------------------------------------

Tabs.Basico:Paragraph({
    Title = "Goats🏳️‍🌈",
    Content = "_____________________________"
})

Tabs.Basico:Button({
    Title = "Ative isso é obrigatório se não o ban vem",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/ant"))()
    end
})

Tabs.Basico:Button({
    Title = "Shiftlock",
    Callback = function()
        
    end
})

Tabs.Basico:Button({
    Title = "Desativar AutoJump",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/desable"))()
    end
})

Tabs.Basico:Button({
    Title = "Farmar Rota",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/faz"))()
    end
})

Tabs.Basico:Button({
    Title = "Farmar de Entregador",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/pizzayolo"))()
    end
})

Tabs.Basico:Button({
    Title = "Esconder Identidade 🙅🏿‍♂️",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local gui = plr.PlayerGui:FindFirstChild("ExpBar")
        if gui then gui:Destroy() end
    end
})

Tabs.Basico:Button({
    Title = "Zero delay nos botões",
    Callback = function()
        local ws = workspace

        local function fix()
            for _,v in pairs(ws:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0.0001
                end
            end
        end

        fix()
        ws.DescendantAdded:Connect(function(v)
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0.0001
            end
        end)
    end
})

Tabs.Basico:Button({
    Title = "Atravessar Paredes",
    Callback = function()
        game:GetService("RunService").Stepped:Connect(function()
            for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    end
})

Tabs.Basico:Button({
    Title = "Remover Dano de Queda 💩",
    Callback = function()
        local dmg = game.ReplicatedStorage:FindFirstChild("ReceberDano")
        if dmg then dmg:Destroy() end
    end
})

Tabs.Basico:Button({
    Title = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-------------------------------------------------------
-- ESP
-------------------------------------------------------

Tabs.Esp:Button({
    Title = "ESP Player",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/Esp"))()
    end
})

Tabs.Esp:Button({
    Title = "ESP Carros",
    Callback = function()
        _G.ESP_Ativo = true
        local carros = workspace:FindFirstChild("CarrosSpawnados")
        if not carros then return end

        while _G.ESP_Ativo do
            for _,carro in pairs(carros:GetChildren()) do
                if carro:IsA("Model") and not carro:FindFirstChildOfClass("Highlight") then
                    local porta = carro:FindFirstChild("Info")
                        and carro.Info:FindFirstChild("Status")
                        and carro.Info.Status:FindFirstChild("PortaLocked")

                    if porta then
                        local h = Instance.new("Highlight", carro)
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.OutlineColor = Color3.new(1,1,1)

                        local function update()
                            h.FillColor = porta.Value and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
                        end
                        update()
                        porta:GetPropertyChangedSignal("Value"):Connect(update)
                    end
                end
            end
            task.wait(1)
        end
    end
})

-------------------------------------------------------
-- COMPRAR
-------------------------------------------------------

local function comprar(item)
    game.ReplicatedStorage.InventarioSystem.Comprar:FireServer(item)
end

Tabs.Comprar:Button({Title="Pizza 🍕", Callback=function() comprar("Pizza") end})
Tabs.Comprar:Button({Title="Água 🌊", Callback=function() comprar("Agua") end})
Tabs.Comprar:Button({Title="Coca-Cola 🍼", Callback=function() comprar("Coca-Cola") end})
Tabs.Comprar:Button({Title="Kit de Reparo 🧰", Callback=function() comprar("Kit de Reparo") end})
Tabs.Comprar:Button({Title="Gasolina ⛽", Callback=function() comprar("Jerry Can") end})

-------------------------------------------------------
-- COMBATE
-------------------------------------------------------

Tabs.Combate:Button({
    Title = "silent 100",
    Callback = function()
        --// WeaponSystem Silent Tracking (Mobile + PC FIX)

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// WeaponSystem
local WS = require(
    ReplicatedStorage
        :WaitForChild("WeaponsSystem")
        :WaitForChild("WeaponsSystem")
)

local WSCamera = WS.camera

--// CONFIG
local FOV_RADIUS = 100
local TARGET_PART = "Head"
local PREDICTION = 0.045
local HEAD_OFFSET = Vector3.new(0, 0.12, 0)

--// INPUT STATE
local firing = false

-- Touch (Mobile)
UserInputService.TouchStarted:Connect(function()
    firing = true
end)

UserInputService.TouchEnded:Connect(function()
    firing = false
end)

-- Mouse (PC)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        firing = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        firing = false
    end
end)

--// Utils
local function worldToScreen(pos)
    local v, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), onScreen
end

--// Target selector (centro da tela)
local function getTarget()
    local bestTarget = nil
    local bestDist = FOV_RADIUS

    local center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local part = char:FindFirstChild(TARGET_PART)
            local root = char:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and part and root then
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

--// CORE SILENT AIM
local function applySilent()
    if not firing then return end
    if not WSCamera or not WSCamera.currentCFrame then return end

    local weapon = WS.currentWeapon
    if not weapon then return end

    local target = getTarget()
    if not target then return end

    local root = target.Parent:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local predictedPos =
        target.Position
        + HEAD_OFFSET
        + root.AssemblyLinearVelocity * PREDICTION

    local camPos = WSCamera.currentCFrame.Position
    WSCamera.currentCFrame = CFrame.lookAt(camPos, predictedPos)
end

--// Duplo timing
RunService.RenderStepped:Connect(applySilent)
RunService.Heartbeat:Connect(applySilent)
    end
})

Tabs.Combate:Button({
    Title = "Silent Aim 25size",
    Callback = function()
        --// WeaponSystem Silent Tracking (Mobile + PC FIX)

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// WeaponSystem
local WS = require(
    ReplicatedStorage
        :WaitForChild("WeaponsSystem")
        :WaitForChild("WeaponsSystem")
)

local WSCamera = WS.camera

--// CONFIG
local FOV_RADIUS = 25
local TARGET_PART = "Head"
local PREDICTION = 0.045
local HEAD_OFFSET = Vector3.new(0, 0.12, 0)

--// INPUT STATE
local firing = false

-- Touch (Mobile)
UserInputService.TouchStarted:Connect(function()
    firing = true
end)

UserInputService.TouchEnded:Connect(function()
    firing = false
end)

-- Mouse (PC)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        firing = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        firing = false
    end
end)

--// Utils
local function worldToScreen(pos)
    local v, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), onScreen
end

--// Target selector (centro da tela)
local function getTarget()
    local bestTarget = nil
    local bestDist = FOV_RADIUS

    local center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local part = char:FindFirstChild(TARGET_PART)
            local root = char:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and part and root then
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

--// CORE SILENT AIM
local function applySilent()
    if not firing then return end
    if not WSCamera or not WSCamera.currentCFrame then return end

    local weapon = WS.currentWeapon
    if not weapon then return end

    local target = getTarget()
    if not target then return end

    local root = target.Parent:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local predictedPos =
        target.Position
        + HEAD_OFFSET
        + root.AssemblyLinearVelocity * PREDICTION

    local camPos = WSCamera.currentCFrame.Position
    WSCamera.currentCFrame = CFrame.lookAt(camPos, predictedPos)
end

--// Duplo timing
RunService.RenderStepped:Connect(applySilent)
RunService.Heartbeat:Connect(applySilent)
    end
})

Tabs.Combate:Button({
    Title = "Auto Fire Mobile",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/at"))()
    end
})

Tabs.Combate:Button({
    Title = "Hed 1.50",
    Callback = function()
        local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentSize = Vector3.new(1.5, 1.5, 1.5)

-- Função auxiliar para detectar se um objeto tem face/decals
local function hasFaceMarker(obj)
	if not obj then return false end
	if obj:FindFirstChild("face") then return true end
	for _, c in ipairs(obj:GetChildren()) do
		if c:IsA("Decal") or c:IsA("Texture") then
			return true
		end
	end
	return false
end

-- Aplica a modificação à cabeça do jogador
local function applyToPart(part, model)
	if not part or not model then return end
	if model == LocalPlayer.Character then return end
	if model:FindFirstChild("FakeVisualCabesa") then return end

	pcall(function()
		local fake = part:Clone()
		fake.Name = "FakeVisualCabesa"
		fake.Size = Vector3.new(1, 1, 1)
		fake.Transparency = 0
		fake.CanCollide = false
		fake.Anchored = false
		fake.Massless = true
		fake.Parent = model

		fake.CFrame = part.CFrame

		-- esconder cabeça original
		part.Size = currentSize
		part.Transparency = 1
		part.CanCollide = false
		part.Massless = true

		local face = part:FindFirstChild("face")
		if face and face:IsA("Decal") then face.Transparency = 1 end
		for _, c in ipairs(part:GetChildren()) do
			if c:IsA("Decal") or c:IsA("Texture") then
				c.Transparency = 1
			end
		end

		-- weld simples
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = fake
		weld.Part1 = part
		weld.Parent = fake

		part:GetPropertyChangedSignal("Size"):Connect(function()
			if part.Size ~= currentSize then
				part.Size = currentSize
			end
		end)
	end)
end

-- Função para processar um personagem recém-criado
local function processCharacter(char)
	if not char then return end
	task.wait(0.5)
	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") and hasFaceMarker(obj) then
			local model = obj:FindFirstAncestorOfClass("Model")
			if model and model:FindFirstChildOfClass("Humanoid") then
				applyToPart(obj, model)
			end
		end
	end
end

-- Monitora todos os jogadores (sem scan pesado)
for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
		if plr.Character then
			processCharacter(plr.Character)
		end
		plr.CharacterAdded:Connect(processCharacter)
	end
end

Players.PlayerAdded:Connect(function(plr)
	if plr ~= LocalPlayer then
		plr.CharacterAdded:Connect(processCharacter)
	end
end)
    end
})

Tabs.Combate:Button({
    Title = "Time Stop",
    Callback = function()
        

-- Instances:
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextLabel_2 = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")

--Properties:
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0, 0, 0) -- Cor invisÃ­vel
Frame.BackgroundTransparency = 1 -- Define a transparÃªncia para 100% (completamente transparente)
Frame.Position = UDim2.new(0.369825214, 0, 0.423832893, 0)
Frame.Size = UDim2.new(0, 316, 0, 325)
Frame.Active = true
Frame.Draggable = true

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1) -- Cor branca
TextLabel.BackgroundTransparency = 0.9 -- Define a transparÃªncia para 90%
TextLabel.Size = UDim2.new(0, 316, 0, 50)
TextLabel.Font = Enum.Font.SciFi
TextLabel.Text = "Time Stop GUI"
TextLabel.TextColor3 = Color3.new(1, 1, 1) -- Cor branca
TextLabel.TextSize = 30.000

TextLabel_2.Parent = Frame
TextLabel_2.BackgroundColor3 = Color3.new(1, 1, 1) -- Cor branca
TextLabel_2.BackgroundTransparency = 0.9 -- Define a transparÃªncia para 90%
TextLabel_2.Position = UDim2.new(0, 0, 0.846153915, 0)
TextLabel_2.Size = UDim2.new(0, 316, 0, 50)
TextLabel_2.Font = Enum.Font.SciFi
TextLabel_2.Text = "Criado por lyrics.zx#0000"
TextLabel_2.TextColor3 = Color3.new(1, 1, 1) -- Cor branca
TextLabel_2.TextSize = 28.000

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Cor invisÃ­vel
TextButton.BackgroundTransparency = 1 -- Define a transparÃªncia para 100% (completamente transparente)
TextButton.Position = UDim2.new(0.0664556995, 0, 0.212307781, 0)
TextButton.Size = UDim2.new(0, 274, 0, 184)
TextButton.Font = Enum.Font.Cartoon
TextButton.Text = "Activate!"
TextButton.TextColor3 = Color3.new(1, 1, 1) -- Cor branca
TextButton.TextSize = 50.000

local Effect = Instance.new("ColorCorrectionEffect")
Effect.Parent = game.Lighting
Effect.Saturation = 3
Effect.Brightness = 0
Effect.Contrast = 0

local toggle = false

function toggleEffect()
    toggle = not toggle -- Alternar o estado do toggle
    
    if toggle == true then
        settings().Network.IncomingReplicationLag = 1000
        Effect.Enabled = true
        TextButton.Text = "Desativar!"
    else
        settings().Network.IncomingReplicationLag = 0
        Effect.Enabled = false
        TextButton.Text = "Ativa ai verme!"
    end
end

TextButton.MouseButton1Down:Connect(toggleEffect)

-- verificar variável global
if _G.SendNotifications == nil then
    -- Define a variÃ¡vel como true, indicando que notificaÃ§Ãµes devem ser enviadas
    _G.SendNotifications = true
end

-- variável global SendNotifications estÃ¡ definida
if _G.SendNotifications == nil then
    -- Define a variÃ¡vel como true, indicando que notificaÃ§Ãµes devem ser enviadas
    _G.SendNotifications = true
end

-- função para enviar uma notificação
local function sendNotification(message)
    if _G.SendNotifications then
        -- instÃ¢ncia de screengui
        local screenGui = Instance.new("ScreenGui")
        screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        
        -- TextLabel
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(0, 300, 0, 50) -- Tamanho mediano
        textLabel.Position = UDim2.new(1, -310, 1, -60) -- Canto inferior direito
        textLabel.AnchorPoint = Vector2.new(1, 1) -- Ancora no canto inferior direito
        textLabel.BackgroundTransparency = 0.5 -- TransparÃªncia de fundo
        textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Cor de fundo preta
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Cor do texto branca
        textLabel.Font = Enum.Font.SourceSansBold -- Fonte do texto
        textLabel.TextSize = 24 -- Tamanho do texto
        textLabel.Text = message
        textLabel.Parent = screenGui
        
        -- tantantanan
        wait(5)
        screenGui:Destroy()
    end
end

-- Envia a mensagem desejada
sendNotification("Xitando? sei nÃ£o viu")
    end
})

Tabs.Combate:Button({
    Title = "Recoil Baixinho",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer

-- Função que zera o recoil dos valores dentro do Configuration
local function zeroRecoil(tool)
    if tool and tool:FindFirstChild("Configuration") then
        local config = tool.Configuration
        local props = {
            "RecoilDecay",
            "RecoilMax",
            "RecoilMin",
            "TotalRecoilMax"
        }

        for _, name in ipairs(props) do
            local prop = config:FindFirstChild(name)
            if prop and prop:IsA("NumberValue") then
                prop.Value = 0.50
            end
        end
    end
end

-- Função que monitora ferramentas no Character e no Backpack
local function monitorTools()
    -- Já aplica nas ferramentas existentes
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            zeroRecoil(tool)
        end
    end
    for _, tool in ipairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            zeroRecoil(tool)
        end
    end

    -- Monitora novas ferramentas no Backpack
    player.Backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            zeroRecoil(child)
        end
    end)

    -- Monitora novas ferramentas no Character
    player.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            zeroRecoil(child)
        end
    end)
end

-- Chama a função inicial
monitorTools()

-- Reconecta sempre que o personagem for recriado (após morrer)
player.CharacterAdded:Connect(function()
    task.wait(1) -- Espera o personagem carregar
    monitorTools()
end)
    end
})

-------------------------------------------------------
-- TELEPORTES
-------------------------------------------------------

local TS = game:GetService("TweenService")
local plr = game.Players.LocalPlayer

local function TP(cf, t)
    TS:Create(plr.Character.HumanoidRootPart, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = cf}):Play()
end

Tabs.TP:Button({Title="Hospital", Callback=function() TP(CFrame.new(3908,4,2100),8) end})
Tabs.TP:Button({Title="Praça", Callback=function() TP(CFrame.new(3610,8,2896),8) end})
Tabs.TP:Button({Title="Oficina", Callback=function() TP(CFrame.new(3085,3,3192),8) end})
Tabs.TP:Button({Title="Banco do Brasil", Callback=function() TP(CFrame.new(3220,10,2323),8) end})
Tabs.TP:Button({Title="Cassino", Callback=function() TP(CFrame.new(4066,13,-2059),10.5) end})

-------------------------------------------------------
-- VEÍCULO
-------------------------------------------------------

Tabs.Veiculo:Button({
    Title = "Vida Infinita ⛑️",
    Callback = function()
        local carros = workspace:FindFirstChild("CarrosSpawnados")
        if not carros then return end

        for _,carro in pairs(carros:GetChildren()) do
            local status = carro:FindFirstChild("Info") and carro.Info:FindFirstChild("Status")
            if status then
                if status:FindFirstChild("Vida") then
                    status.Vida.Value = 99999
                    status.Vida:GetPropertyChangedSignal("Value"):Connect(function()
                        status.Vida.Value = 99999
                    end)
                end
                if status:FindFirstChild("Quebrou") then
                    status.Quebrou.Value = false
                end
            end
        end
    end
})

Tabs.Veiculo:Button({
    Title = "Gasolina Infinita ⛽",
    Callback = function()
        local carros = workspace:FindFirstChild("CarrosSpawnados")
        if not carros then return end

        for _,carro in pairs(carros:GetChildren()) do
            local gas = carro:FindFirstChild("Info")
                and carro.Info:FindFirstChild("Status")
                and carro.Info.Status:FindFirstChild("Gasolina")

            if gas then
                gas.Value = 99999
                gas:GetPropertyChangedSignal("Value"):Connect(function()
                    gas.Value = 99999
                end)
            end
        end
    end
})

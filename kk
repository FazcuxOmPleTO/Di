local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Faz Completo",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Carregando...",
   LoadingSubtitle = "Oi prazer sou o Lyrics",
   Theme = "DarkBlue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = calma, -- Create a custom folder for your hub/game
      FileName = "Lyrics"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Prove do seu Veneno bots",
      Subtitle = "Sistema de Chave",
      Note = "Acesso restrito.", -- Use this to tell the user how to get a key
      FileName = "Chave", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"arceus"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

Rayfield:Notify({
   Title = "Agradecimento",
   Content = "paraem de xitar seus vermes!",
   Duration = 6.5,
   Image = 4483362458,
})

local Tab = Window:CreateTab("Básico", 97682995973876) -- Title, Image
local Divider = Tab:CreateDivider()

local Paragraph = Tab:CreateParagraph({Title = "Funções Atualizadas 02/05/25", Content = "_____________________________"})
local Divider = Tab:CreateDivider()

local Button = Tab:CreateButton({
   Name = " Ative isso é obrigatório se não o ban vem",
   Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/desable'),true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "shiftlock",
   Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/shi'),true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "desativar autojump",
   Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/faz'),true))()
   end,
})


local Button = Tab:CreateButton({
   Name = " farmar rota",
   Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/faz'),true))()
   end,
})

local Button = Tab:CreateButton({
   Name = " farmar de entregador",
   Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/pizzayolo'),true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Esconder Identidade 🙅🏿‍♂️",
   Callback = function()
-- Apagar "ExpBar" de PlayerGui do jogador local
local player = game:GetService("Players").LocalPlayer
local expBar = player.PlayerGui:FindFirstChild("ExpBar")
if expBar then
    expBar:Destroy()
end
   end,
})

local Button = Tab:CreateButton({
   Name = "Zero delay nos botão tlgd?",
   Callback = function()
local Workspace = game:GetService("Workspace")

local function updateProximityPrompts()
    for i, v in ipairs(Workspace:GetDescendants()) do
        if v.ClassName == "ProximityPrompt" then
            v.HoldDuration = 0.0001
        end
    end
end

updateProximityPrompts()

Workspace.DescendantAdded:Connect(function(descendant)
    if descendant.ClassName == "ProximityPrompt" then
        descendant.HoldDuration = 0.000001
    end
end)
   end,
})

local Button = Tab:CreateButton({
   Name = "Atravessar Paredes para bicudar ou sla",
   Callback = function()
   for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
    if v:IsA("BasePart") then
        v.CanCollide = false
    end
end;
game:GetService("RunService").Stepped:Connect(function()
    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end)
   end,
})

local Button = Tab:CreateButton({
   Name = "Remover Dano de Queda 💩",
   Callback = function()
local replicatedStorage = game:GetService("ReplicatedStorage")
local receberDano = replicatedStorage:FindFirstChild("ReceberDano")
if receberDano then
    receberDano:Destroy()
end
   end,
})

local Divider = Tab:CreateDivider()

local Button = Tab:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
   end,
})

local Tab = Window:CreateTab("Esp", 12907910012) -- Title, Image
local Divider = Tab:CreateDivider()

local Button = Tab:CreateButton({
   Name = " ESP Player",
   Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/Esp'),true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Esp Carros",
   Callback = function()
_G.ESP_Ativo = true -- Define a flag como ativa inicialmente

local carrosSpawnados = workspace:FindFirstChild("CarrosSpawnados")

if carrosSpawnados then
    while _G.ESP_Ativo do
        for _, carro in pairs(carrosSpawnados:GetChildren()) do
            if carro:IsA("Model") then
                -- Verifica se o carro já tem um Highlight
                if not carro:FindFirstChildOfClass("Highlight") then
                    local info = carro:FindFirstChild("Info")
                    if info then
                        local status = info:FindFirstChild("Status")
                        if status then
                            local portaLocked = status:FindFirstChild("PortaLocked")
                            
                            if portaLocked and typeof(portaLocked.Value) == "boolean" then
                                -- Cria o Highlight
                                local highlight = Instance.new("Highlight")
                                highlight.Parent = carro
                                
                                -- Define a cor com base no estado de "PortaLocked"
                                if portaLocked.Value then
                                    highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Verde para trancado
                                else
                                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho para destrancado
                                end
                                
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Cor da borda
                                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Sempre visível
                                
                                -- Atualiza o highlight caso o status mude
                                portaLocked:GetPropertyChangedSignal("Value"):Connect(function()
                                    if portaLocked.Value then
                                        highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Verde para trancado
                                    else
                                        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho para destrancado
                                    end
                                end)
                            else
                                warn("Atributo 'PortaLocked' não encontrado ou inválido para o carro: " .. carro.Name)
                            end
                        else
                            warn("Status não encontrado no carro: " .. carro.Name)
                        end
                    else
                        warn("Info não encontrada no carro: " .. carro.Name)
                    end
                end
            end
        end
        
        -- Espera antes de verificar novamente
        task.wait(1) -- Configurável (1 segundo)
    end
else
    warn("Pasta 'CarrosSpawnados' não encontrada!")
end

print("ESP loop encerrado.")
   end,
})

local Tab = Window:CreateTab("Comprar", 13152284137) -- Title, Image
local Divider = Tab:CreateDivider()

local Button = Tab:CreateButton({
   Name = "Pizza 🍕",
   Callback = function()
local args = {
	"Pizza"
}
game:GetService("ReplicatedStorage"):WaitForChild("InventarioSystem"):WaitForChild("Comprar"):FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Água 🌊",
   Callback = function()
local args = {
	"Agua"
}
game:GetService("ReplicatedStorage"):WaitForChild("InventarioSystem"):WaitForChild("Comprar"):FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Coca-Cola 🍼",
   Callback = function()
local args = {
	"Coca-Cola"
}
game:GetService("ReplicatedStorage"):WaitForChild("InventarioSystem"):WaitForChild("Comprar"):FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Kit de Reparo 🧰",
   Callback = function()
local args = {
	"Kit de Reparo"
}
game:GetService("ReplicatedStorage"):WaitForChild("InventarioSystem"):WaitForChild("Comprar"):FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Gasolina ⛽",
   Callback = function()
local args = {
	"Jerry Can"
}
game:GetService("ReplicatedStorage"):WaitForChild("InventarioSystem"):WaitForChild("Comprar"):FireServer(unpack(args))
   end,
})

local Tab = Window:CreateTab("Combate", 7113019423) -- Title, Image
local Divider = Tab:CreateDivider()

local Button = Tab:CreateButton({
   Name = "Acerta izi hitb",
   Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/hitbox"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Cerebro Grande Para jogar clipando",
   Callback = function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentSize = Vector3.new(2.3, 2.3, 2.3) -- Edite esse valor manualmente se quiser

-- Função para aplicar a hitbox grande
local function applyHeadSize(char)
    task.wait(0.1)
    local head = char:FindFirstChild("Head")
    if not head or char == LocalPlayer.Character then return end
    if char:FindFirstChild("FakeVisualHead") then return end

    -- Clona a cabeça visual
    local fakeHead = head:Clone()
    fakeHead.Name = "FakeVisualHead"
    fakeHead.Size = Vector3.new(1, 1, 1)
    fakeHead.Transparency = 0
    fakeHead.CanCollide = false
    fakeHead.Anchored = false
    fakeHead.Massless = true
    fakeHead.Parent = char

    -- Altera a hitbox física real
    head.Size = currentSize
    head.Transparency = 1
    head.CanCollide = false
    head.Massless = true

    -- Torna a face invisível
    local face = head:FindFirstChildOfClass("Decal")
    if face then
        face.Transparency = 1
    end

    -- Solda visual na cabeça real
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = fakeHead
    weld.Parent = head

    -- Proteção contra scripts que tentam restaurar o tamanho original
    head:GetPropertyChangedSignal("Size"):Connect(function()
        if head.Size ~= currentSize then
            head.Size = currentSize
        end
    end)
end

-- Monitora cada player para reaplicar quando morrer
local function monitorPlayer(player)
    if player == LocalPlayer then return end

    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Head", 5)
        applyHeadSize(char)
    end)

    if player.Character then
        applyHeadSize(player.Character)
    end
end

-- Inicializa todos os players atuais
for _, player in ipairs(Players:GetPlayers()) do
    monitorPlayer(player)
end

-- Quando um novo player entrar
Players.PlayerAdded:Connect(monitorPlayer)
   end,
})

local Button = Tab:CreateButton({
   Name = "Cerebro Grande",
   Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/l'),true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Recoil Baixinho",
   Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/tim'),true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Recoil Baixinho",
   Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/n'),true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Munição Infinita 🔫",
   Callback = function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TARGET_VALUE = 999999999

-- Função para congelar o valor
local function congelarAmmo(valor)
    if valor:IsA("IntValue") or valor:IsA("NumberValue") then
        valor.Value = TARGET_VALUE

        task.spawn(function()
            while valor.Parent do
                if valor.Value ~= TARGET_VALUE then
                    valor.Value = TARGET_VALUE
                end
                task.wait(0.1)
            end
        end)
    end
end

-- Verifica se a Tool pertence ao jogador e tem CurrentAmmo
local function verificarArma(tool)
    if tool:IsA("Tool") and tool:FindFirstChild("CurrentAmmo") then
        -- Só age se a Tool estiver no Character do jogador local
        if tool.Parent == LocalPlayer.Character then
            congelarAmmo(tool.CurrentAmmo)
        end
    end
end

-- Verifica ferramentas já no personagem
if LocalPlayer.Character then
    for _, item in pairs(LocalPlayer.Character:GetChildren()) do
        verificarArma(item)
    end
end

-- Reage a novas ferramentas equipadas
LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(verificarArma)
end)

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(verificarArma)
end

-- (Opcional) verifica também se alguma arma for jogada no workspace depois
workspace.DescendantAdded:Connect(function(desc)
    verificarArma(desc)
end)
   end,
})

local Tab = Window:CreateTab("Teleportes", 10516012746) -- Title, Image
local Divider = Tab:CreateDivider()

local Button = Tab:CreateButton({
   Name = "Hospital",
   Callback = function()
tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(8, Enum.EasingStyle.Linear)tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(3908.38525390625, 4.651368618011475, 2100.5224609375)}):Play()
   end,
})

local Button = Tab:CreateButton({
   Name = "Praça",
   Callback = function()
tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(8, Enum.EasingStyle.Linear)tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(3610.766845703125, 8.509111404418945, 2896.408203125)}):Play()
   end,
})

local Button = Tab:CreateButton({
   Name = "Oficina",
   Callback = function()
tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(8, Enum.EasingStyle.Linear)tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(3085.550537109375, 3.7505321502685547, 3192.69287109375)}):Play()
   end,
})

local Button = Tab:CreateButton({
   Name = "Banco do Brasil",
   Callback = function()
tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(8, Enum.EasingStyle.Linear)tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(3220.339599609375, 10.168707847595215, 2323.764892578125)}):Play()
   end,
})

local Button = Tab:CreateButton({
   Name = "Cassino",
   Callback = function()
tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(10.5, Enum.EasingStyle.Linear)tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(4066.586181640625, 13.67834758758545, -2059.316650390625)}):Play()
   end,
})

local Tab = Window:CreateTab("Veículo", 18209578679) -- Title, Image
local Divider = Tab:CreateDivider()

local Button = Tab:CreateButton({
   Name = "Vida Infinita ⛑️",
   Callback = function()
local carros = workspace:FindFirstChild("CarrosSpawnados")
if not carros then return end

for _, carro in ipairs(carros:GetChildren()) do
    local status = carro:FindFirstChild("Info")
        and carro.Info:FindFirstChild("Status")

    if status then
        -- Congelar Vida
        local vida = status:FindFirstChild("Vida")
        if vida and vida:IsA("NumberValue") then
            vida.Value = 99999
            vida:GetPropertyChangedSignal("Value"):Connect(function()
                vida.Value = 99999
            end)
        end

        -- Congelar Quebrou
        local quebrou = status:FindFirstChild("Quebrou")
        if quebrou and quebrou:IsA("BoolValue") then
            quebrou.Value = false
            quebrou:GetPropertyChangedSignal("Value"):Connect(function()
                quebrou.Value = false
            end)
        end
    end
end
   end,
})

local Button = Tab:CreateButton({
   Name = "Gasolina Infinita ⛽",
   Callback = function()
local carros = workspace:FindFirstChild("CarrosSpawnados")
if not carros then return end

for _, carro in ipairs(carros:GetChildren()) do
    local gasolina = carro:FindFirstChild("Info")
        and carro.Info:FindFirstChild("Status")
        and carro.Info.Status:FindFirstChild("Gasolina")
    
    if gasolina and gasolina:IsA("NumberValue") then
        gasolina.Value = 99999

        -- Congelar o valor
        gasolina:GetPropertyChangedSignal("Value"):Connect(function()
            gasolina.Value = 99999
        end)
    end
end
   end,
})

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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/shi"))()
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
    Title = "Acerta izi hitbox",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/hitbox"))()
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/l"))()
    end
})

Tabs.Combate:Button({
    Title = "Time Stop",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/tim"))()
    end
})

Tabs.Combate:Button({
    Title = "Recoil Baixinho",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FazcuxOmPleTO/Di/refs/heads/main/n"))()
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

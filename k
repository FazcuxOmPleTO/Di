task.spawn(function()
    task.wait(2)

    ------------------------------------------------
    -- ANTI-LAG / OTIMIZAÇÃO DE DESEMPENHO
    -- By Lyrics
    ------------------------------------------------
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer

    ------------------------------------------------
    -- CONFIGURAÇÃO DE DESEMPENHO
    ------------------------------------------------
    local function otimizarObjeto(obj)
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj:Destroy() end)
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = false
        end
    end

    local function aplicarNoMapa()
        for _, obj in pairs(workspace:GetDescendants()) do
            otimizarObjeto(obj)
        end

        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
        end
    end

    ------------------------------------------------
    -- AJUSTES GLOBAIS DE RENDERIZAÇÃO
    ------------------------------------------------
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.FogEnd = 9e9

    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") then
            v.Enabled = false
        end
    end

    -- Primeira aplicação
    aplicarNoMapa()

    ------------------------------------------------
    -- OTIMIZAÇÃO DE OBJETOS NOVOS
    ------------------------------------------------
    workspace.DescendantAdded:Connect(function(obj)
        task.wait()
        otimizarObjeto(obj)
    end)

    ------------------------------------------------
    -- REAPLICAR AUTOMATICAMENTE
    ------------------------------------------------
    task.spawn(function()
        while true do
            task.wait(60)
            aplicarNoMapa()
        end
    end)
end)

task.spawn(function()
    task.wait(2)
local replicated_storage = game.GetService(game, "ReplicatedStorage")
local players = game.GetService(game, "Players")

local camera = workspace.CurrentCamera
local utility = require(replicated_storage.Modules.Utility)

-- CONFIG DO FOV
local FOV_RADIUS = 30 -- tamanho do FOV invisível (em pixels)

local get_players = function()
    local entities = {}

    for _, child in workspace.GetChildren(workspace) do
        if child.FindFirstChildOfClass(child, "Humanoid") then
            table.insert(entities, child)
        elseif child.Name == "HurtEffect" then
            for _, hurt_player in child.GetChildren(child) do
                if (hurt_player.ClassName ~= "Highlight") then
                    table.insert(entities, hurt_player)
                end
            end
        end
    end
    return entities
end

local get_closest_player = function()
    local closest, closest_distance = nil, FOV_RADIUS
    local character = players.LocalPlayer.Character

    if (character == nil) then
        return
    end

    local center = Vector2.new(
        camera.ViewportSize.X / 2,
        camera.ViewportSize.Y / 2
    )

    for _, player in get_players() do
        if (player == players.LocalPlayer) then
            continue
        end

        if (not player:FindFirstChild("HumanoidRootPart")) then
            continue
        end

        local position, on_screen =
            camera.WorldToViewportPoint(camera, player.HumanoidRootPart.Position)

        if (on_screen == false) then
            continue
        end

        local distance = (center - Vector2.new(position.X, position.Y)).Magnitude

        -- AQUI ESTÁ O FOV INVISÍVEL
        if (distance > FOV_RADIUS) then
            continue
        end

        if (distance < closest_distance) then
            closest = player
            closest_distance = distance
        end
    end

    return closest
end

local old = utility.Raycast
utility.Raycast = function(...)
    local arguments = {...}

    if (#arguments > 0 and arguments[4] == 999) then
        local closest = get_closest_player()

        if (closest and closest:FindFirstChild("Head")) then
            arguments[3] = closest.Head.Position
        end
    end

    return old(table.unpack(arguments))
end
    

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

    -- Skybox Setup
    local skybox = Instance.new("Sky")
    skybox.SkyboxBk = "rbxassetid://6598038571"
    skybox.SkyboxDn = "rbxassetid://6598060864"
    skybox.SkyboxFt = "rbxassetid://6598069162"
    skybox.SkyboxLf = "rbxassetid://6598081281"
    skybox.SkyboxRt = "rbxassetid://6598083861"
    skybox.SkyboxUp = "rbxassetid://6598088065"
    skybox.Parent = game.Lighting
end)

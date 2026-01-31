--// WeaponSystem Silent Aim (Mobile + PC FIX)

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
local FOV_RADIUS = 237
local TARGET_PART = "Head"
local WALLCHECK = true
local PREDICTION = 0.045
local HEAD_OFFSET = Vector3.new(0, 0.15, 0)

--// Utils
local function worldToScreen(pos)
    local v, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), onScreen
end

local function wallCheck(from, to, ignore)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = ignore
    params.IgnoreWater = true

    local r = Workspace:Raycast(from, to - from, params)
    return not r or r.Instance:IsDescendantOf(ignore[2])
end

--// Target selector
local function getTarget()
    local best, bestDist = nil, FOV_RADIUS
    local center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild(TARGET_PART)
            local root = char:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and head and root then
                local screenPos, onScreen = worldToScreen(head.Position)
                if onScreen then
                    local dist = (screenPos - center).Magnitude
                    if dist < bestDist then
                        if not WALLCHECK or wallCheck(
                            Camera.CFrame.Position,
                            head.Position,
                            { LP.Character, char }
                        ) then
                            bestDist = dist
                            best = head
                        end
                    end
                end
            end
        end
    end

    return best
end

--// CORE AIM (sincronizado PC + Mobile)
local function applyAim()
    if not WSCamera or not WSCamera.currentCFrame then return end

    local target = getTarget()
    if not target then return end

    local root = target.Parent:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local predictedPos =
        target.Position
        + HEAD_OFFSET
        + root.AssemblyLinearVelocity * PREDICTION

    local camPos = Camera.CFrame.Position
    local aimCF = CFrame.lookAt(camPos, predictedPos)

    -- sincroniza as duas câmeras
    WSCamera.currentCFrame = aimCF
    Camera.CFrame = aimCF
end

--// TIMING CORRETO
RunService.Heartbeat:Connect(applyAim)

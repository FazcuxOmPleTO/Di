--// WeaponSystem Silent Tracking (PC + Mobile REAL)

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
local FOV_RADIUS = 360
local TARGET_PART = "Head"
local PREDICTION = 0.045
local HEAD_OFFSET = Vector3.new(0, 0.12, 0)

--// Utils
local function worldToScreen(pos)
    local v, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), onScreen
end

--// Centro de mira
local function getCenter()
    if UserInputService.TouchEnabled then
        return Vector2.new(
            Camera.ViewportSize.X / 2,
            Camera.ViewportSize.Y / 2
        )
    else
        local mouse = UserInputService:GetMouseLocation()
        return Vector2.new(mouse.X, mouse.Y)
    end
end

--// Target selector
local function getTarget()
    local bestTarget
    local bestDist = FOV_RADIUS
    local center = getCenter()

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

--// MOBILE: usa câmera (igual antes)
local function mobileSilent()
    if not UserInputService.TouchEnabled then return end
    if not WSCamera or not WSCamera.currentCFrame then return end

    local weapon = WS.currentWeapon
    if not weapon or not weapon.activated then return end

    local target = getTarget()
    if not target then return end

    local root = target.Parent:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local predicted =
        target.Position
        + HEAD_OFFSET
        + root.AssemblyLinearVelocity * PREDICTION

    local camPos = WSCamera.currentCFrame.Position
    WSCamera.currentCFrame = CFrame.lookAt(camPos, predicted)
end

--// PC: silent REAL (raycast)
local function pcSilent()
    if UserInputService.TouchEnabled then return end

    WS.aimRayCallback = function()
        local target = getTarget()
        if not target then
            return Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 1000)
        end

        local root = target.Parent:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local predicted =
            target.Position
            + HEAD_OFFSET
            + root.AssemblyLinearVelocity * PREDICTION

        local origin = Camera.CFrame.Position
        local dir = (predicted - origin).Unit * 1000

        return Ray.new(origin, dir)
    end
end

--// Loop
RunService.RenderStepped:Connect(function()
    mobileSilent()
    pcSilent()
end)

--// WeaponSystem Silent Tracker (PC + Mobile REAL)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LP:GetMouse()

local WS = require(
    ReplicatedStorage
        :WaitForChild("WeaponsSystem")
        :WaitForChild("WeaponsSystem")
)

-- CONFIG
local FOV_RADIUS = 360
local TARGET_PART = "Head"
local PREDICTION = 0.045
local HEAD_OFFSET = Vector3.new(0, 0.12, 0)

-- Utils
local function worldToScreen(pos)
    local v, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), onScreen
end

local function getCenter()
    if UserInputService.TouchEnabled then
        return Vector2.new(
            Camera.ViewportSize.X / 2,
            Camera.ViewportSize.Y / 2
        )
    else
        local m = UserInputService:GetMouseLocation()
        return Vector2.new(m.X, m.Y)
    end
end

local function getTarget()
    local best, bestDist = nil, FOV_RADIUS
    local center = getCenter()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local part = char:FindFirstChild(TARGET_PART)
            local root = char:FindFirstChild("HumanoidRootPart")

            if hum and hum.Health > 0 and part and root then
                local screen, onScreen = worldToScreen(part.Position)
                if onScreen then
                    local dist = (screen - center).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        best = part
                    end
                end
            end
        end
    end

    return best
end

-- MOBILE (igual antes)
local function mobileSilent()
    if not UserInputService.TouchEnabled then return end
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

    local cam = WS.camera
    if cam and cam.currentCFrame then
        local pos = cam.currentCFrame.Position
        cam.currentCFrame = CFrame.lookAt(pos, predicted)
    end
end

-- PC (O QUE FALTAVA)
local oldUnitRay = Mouse.UnitRay
RunService.RenderStepped:Connect(function()
    if UserInputService.TouchEnabled then
        mobileSilent()
        return
    end

    local weapon = WS.currentWeapon
    if not weapon or not weapon.activated then
        Mouse.UnitRay = oldUnitRay
        return
    end

    local target = getTarget()
    if not target then
        Mouse.UnitRay = oldUnitRay
        return
    end

    local root = target.Parent:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local predicted =
        target.Position
        + HEAD_OFFSET
        + root.AssemblyLinearVelocity * PREDICTION

    local origin = Camera.CFrame.Position
    local dir = (predicted - origin).Unit

    Mouse.UnitRay = Ray.new(origin, dir * 1000)
end)

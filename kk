--// WeaponSystem REAL Silent Aim (PC FIX)

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LP:GetMouse()

--// CONFIG
local FOV_RADIUS = 360
local TARGET_PART = "Head"
local PREDICTION = 0.045
local WALLCHECK = true
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
                            best = head
                            bestDist = dist
                        end
                    end
                end
            end
        end
    end

    return best
end

--// METATABLE HOOK (PC REAL)
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, key)
    if self == Mouse and (key == "Hit" or key == "UnitRay") then
        local target = getTarget()
        if target then
            local root = target.Parent:FindFirstChild("HumanoidRootPart")
            if root then
                local predicted =
                    target.Position
                    + HEAD_OFFSET
                    + root.AssemblyLinearVelocity * PREDICTION

                if key == "Hit" then
                    return CFrame.new(predicted)
                end

                if key == "UnitRay" then
                    local origin = Camera.CFrame.Position
                    return Ray.new(origin, (predicted - origin).Unit * 1000)
                end
            end
        end
    end

    return oldIndex(self, key)
end)

setreadonly(mt, true)

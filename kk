--// WeaponSystem Silent Tracking (PC + Mobile REAL FIX)

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

--// INPUT
local firing = false

-- Mobile
UserInputService.TouchStarted:Connect(function()
    firing = true
end)

UserInputService.TouchEnded:Connect(function()
    firing = false
end)

-- PC
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        firing = true
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        firing = false
    end
end)

--// Utils
local function worldToScreen(pos)
    local v, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), onScreen
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
                local pos, on = worldToScreen(head.Position)
                if on then
                    local d = (pos - center).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = head
                    end
                end
            end
        end
    end

    return best
end

--// SILENT CORE
local function silentStep()
    if not firing then return end
    if not WSCamera or not WSCamera.currentCFrame then return end
    if not WS.currentWeapon then return end

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

-- 🔥 RODA DEPOIS DA CÂMERA (PC FIX)
RunService:BindToRenderStep(
    "SilentAfterCamera",
    Enum.RenderPriority.Camera.Value + 1,
    silentStep
)

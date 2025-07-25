local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local FOV = 100
local TargetPart = "Head"
local Prediction = 0.12

function GetClosestTarget()
    local closest, distance = nil, FOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(TargetPart) then
            local part = player.Character[TargetPart]
            local pos, visible = Camera:WorldToViewportPoint(part.Position)
            if visible then
                local diff = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if diff < distance then
                    distance = diff
                    closest = part
                end
            end
        end
    end
    return closest
end

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if tostring(self) == "S" and method == "FireServer" then
        local target = GetClosestTarget()
        if target then
            local predicted = target.Position + target.Velocity * Prediction
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, predicted) -- "безшумная" наводка
        end
    end

    return old(self, ...)
end)

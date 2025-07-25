--// Автопатч GunFramework
local gunframework = require(game.ReplicatedStorage.ModuleScripts.GunModules.GunFramework)
local oldNew = gunframework.new

gunframework.new = function(config)
    -- Убираем отдачу, делаем оружие автоматическим, ускоряем стрельбу
    if config.Configuration then
        local c = config.Configuration
        if c:FindFirstChild("Recoil") then
            c.Recoil.Value = Vector3.new(0, 0, 0)
        end
        if c:FindFirstChild("isAuto") then
            c.isAuto.Value = true
        end
        if c:FindFirstChild("reloadTime") then
            c.reloadTime.Value = 0
        end
        if c:FindFirstChild("FireRate") then
            c.FireRate.Value = c.FireRate.Value / 5
        end
    end
    return oldNew(config)
end

--// Silent Aim (без CFrame)

local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local FOV = 120
local TargetPart = "Head"
local Prediction = 0.12

local function GetClosestTarget()
    local closest = nil
    local shortestDistance = FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(TargetPart) then
            local part = player.Character[TargetPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closest = part
                end
            end
        end
    end

    return closest
end

--// Перехват вызова FireServer для Remotes.S (наведение)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = { ... }
    local method = getnamecallmethod()

    if tostring(self) == "S" and method == "FireServer" then
        local target = GetClosestTarget()
        if target and target:IsA("BasePart") then
            local predicted = target.Position + (target.Velocity * Prediction)
            args[1] = predicted
            return oldNamecall(self, unpack(args))
        end
    end

    return oldNamecall(self, ...)
end)

--// Конец скрипта

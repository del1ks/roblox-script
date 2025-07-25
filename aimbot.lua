-- Загрузка Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Shoot Players GUI",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By ChatGPT",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

-- Получение сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 🟢 Auto Shoot
local AutoShoot = false
local ShootLoop

MainTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Callback = function(value)
        AutoShoot = value
        if value then
            ShootLoop = RunService.RenderStepped:Connect(function()
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("RemoteEvent") then
                    tool.RemoteEvent:FireServer()
                end
            end)
        elseif ShootLoop then
            ShootLoop:Disconnect()
        end
    end,
})

-- 🚀 WalkSpeed
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = value end
    end,
})

-- 🦘 JumpPower
MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(value)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = value end
    end,
})

-- 🛡️ GodMode (альтернатива)
MainTab:CreateButton({
    Name = "Enable GodMode (Alt)",
    Callback = function()
        local function god()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum.PlatformStand = false
            end
            for _, obj in pairs(char:GetDescendants()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") then
                    obj:Destroy()
                end
            end
        end

        god()
        LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            god()
        end)

        Rayfield:Notify({
            Title = "GodMode Enabled",
            Content = "Альтернативный режим бессмертия активирован.",
            Duration = 5
        })
    end,
})

-- 🌀 Spinbot
MainTab:CreateButton({
    Name = "Enable Spinbot",
    Callback = function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local att = hrp:FindFirstChild("RootAttachment")
        if not att then return end

        local av = Instance.new("AngularVelocity")
        av.Attachment0 = att
        av.AngularVelocity = Vector3.new(0, 30, 0)
        av.MaxTorque = math.huge
        av.Name = "Spinbot"
        av.Parent = hrp

        Rayfield:Notify({
            Title = "Spinbot",
            Content = "Спинбот включён.",
            Duration = 5
        })
    end
})

-- 💨 Anti-Ragdoll
MainTab:CreateButton({
    Name = "Disable Ragdoll",
    Callback = function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum.PlatformStand = false
        end
    end
})

-- 🧍 Телепорт к игроку
MainTab:CreateButton({
    Name = "TP к случайному игроку",
    Callback = function()
        local candidates = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(candidates, plr)
            end
        end

        if #candidates > 0 then
            local target = candidates[math.random(1, #candidates)]
            LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
            Rayfield:Notify({
                Title = "Телепорт",
                Content = "Вы телепортировались к: " .. target.Name,
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Ошибка",
                Content = "Не найдено подходящих игроков",
                Duration = 4
            })
        end
    end
})

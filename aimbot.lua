-- Загрузка Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Shoot Players GUI",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By ChatGPT",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

-- Получение сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- 📌 Auto Shoot
local AutoShoot = false
local ShootLoop

MainTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Callback = function(value)
        AutoShoot = value
        if value then
            ShootLoop = RunService.RenderStepped:Connect(function()
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("RemoteEvent") then
                    tool.RemoteEvent:FireServer()
                end
            end)
        else
            if ShootLoop then
                ShootLoop:Disconnect()
                ShootLoop = nil
            end
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
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end,
})

-- 🦘 JumpPower
MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end,
})

-- 🛡️ GodMode (анти-отдача + бесконечное хп)
MainTab:CreateButton({
    Name = "Enable GodMode",
    Callback = function()
        local function god()
            -- Удаляем все фейковые силы (например BodyVelocity и др.)
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyForce") then
                    v:Destroy()
                end
            end

            -- Бесконечное здоровье
            if LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.MaxHealth = math.huge
                LocalPlayer.Character.Humanoid.Health = math.huge
            end

            -- Анти-отталкивание
            LocalPlayer.Character.Humanoid.PlatformStand = false
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end

        god()
        -- Авто-господство
        LocalPlayer.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid")
            task.wait(0.5)
            god()
        end)

        Rayfield:Notify({
            Title = "GodMode Enabled",
            Content = "Вы неуязвим (пока скрипт активен).",
            Duration = 5
        })
    end,
})

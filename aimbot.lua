-- 📦 Загрузка Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "⚡️ GoatedTeeHub - Enhanced ⚡️",
    LoadingTitle = "Loading GoatedTeeHub...",
    LoadingSubtitle = "By TheGoatedTee + ChatGPT",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "GoatedTeeHubEnhanced"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = true,
    KeySettings = {
        Title = "Enter Key",
        Subtitle = "Use: TheGoatedTee",
        Key = { "TheGoatedTee" }
    }
})

local MainTab = Window:CreateTab("💥 Main", 4483362458)

-- 🔫 Aimbot
local aimEnabled = false
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

local fov = 150
local smoothing = 0.15
local FOVCircle

function GetClosestTarget()
    local closest = nil
    local shortestDistance = fov
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPoint, onScreen = Camera:WorldToScreenPoint(head.Position)
            if onScreen then
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if distance < shortestDistance then
                    closest = head
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

MainTab:CreateToggle({
    Name = "🎯 Aimbot (Hold Right Click)",
    CurrentValue = false,
    Flag = "aimbot_toggle",
    Callback = function(value)
        aimEnabled = value
        if value and not FOVCircle then
            FOVCircle = Drawing.new("Circle")
            FOVCircle.Color = Color3.fromRGB(255, 0, 0)
            FOVCircle.Radius = fov
            FOVCircle.Thickness = 1.5
            FOVCircle.Transparency = 0.8
            FOVCircle.Filled = false
        elseif not value and FOVCircle then
            FOVCircle:Remove()
            FOVCircle = nil
        end
    end,
})

RunService.RenderStepped:Connect(function()
    if aimEnabled then
        if FOVCircle then
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = GetClosestTarget()
            if target then
                local aimPosition = target.Position
                local camPos = Camera.CFrame.Position
                local newCF = CFrame.new(camPos, aimPosition)
                Camera.CFrame = Camera.CFrame:Lerp(newCF, smoothing)
            end
        end
    end
end)

-- 🧍 WalkSpeed & JumpPower
MainTab:CreateSlider({
    Name = "🏃 WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end,
})

MainTab:CreateSlider({
    Name = "🚀 JumpPower",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 100,
    Callback = function(value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end,
})

-- 🔄 Spinbot
MainTab:CreateSlider({
    Name = "🌀 Spinbot Speed",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(value)
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local existing = root:FindFirstChild("Spinbot")
            if existing then existing:Destroy() end
            if value > 0 then
                local vel = Instance.new("AngularVelocity")
                vel.Attachment0 = root:WaitForChild("RootAttachment")
                vel.MaxTorque = math.huge
                vel.AngularVelocity = Vector3.new(0, value, 0)
                vel.Name = "Spinbot"
                vel.Parent = root
            end
        end
    end,
})

-- 🧠 ESP
MainTab:CreateButton({
    Name = "🔍 Enable ESP",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP"))()
    end,
})

-- 🔫 TriggerBot
MainTab:CreateButton({
    Name = "🔫 TriggerBot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/UselessManS90/TriggerBot/main/TriggBot"))()
    end,
})

-- ❌ Exit script
MainTab:CreateButton({
    Name = "❌ Unload Script",
    Callback = function()
        if FOVCircle then FOVCircle:Remove() end
        Rayfield:Destroy()
    end,
})

print("✅ GoatedTeeHub Enhanced Loaded")

-- Получаем сервисы
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Получаем LocalPlayer
local PLAYER = Players.LocalPlayer

-- Создаем ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxUI"
ScreenGui.Parent = PLAYER.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true

-- Создаем главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.ClipsDescendants = true

-- Добавляем закругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Перетаскивание UI
local dragging = false
local dragStart = nil
local startPos = nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Уведомление
local Notification = Instance.new("TextLabel")
Notification.Size = UDim2.new(0, 150, 0, 30)
Notification.Position = UDim2.new(0.5, -75, 0.1, 0)
Notification.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
Notification.TextColor3 = Color3.fromRGB(200, 150, 255)
Notification.TextSize = 16
Notification.Text = ""
Notification.Parent = ScreenGui
Notification.Visible = false

local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 10)
NotificationCorner.Parent = Notification

-- Функция для показа уведомления
local function showNotification(text, duration)
    Notification.Text = text
    Notification.Visible = true
    wait(duration)
    Notification.Visible = false
end

-- Заголовок
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
TitleLabel.Text = "Hitbox Control"
TitleLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleLabel

-- Функция для создания кнопки переключения
local function createToggleButton(name, positionY, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.Position = UDim2.new(0, 0, 0, positionY)
    frame.BackgroundTransparency = 1
    frame.Parent = MainFrame
    frame.Visible = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 150, 255)
    label.TextSize = 18
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.3, 0, 0.7, 0)
    button.Position = UDim2.new(0.7, 0, 0.15, 0)
    button.Text = "OFF"
    button.TextColor3 = Color3.fromRGB(255, 100, 100)
    button.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
    button.TextSize = 16
    button.Font = Enum.Font.SourceSansBold
    button.Parent = frame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = button

    local isEnabled = false
    button.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        button.Text = isEnabled and "ON" or "OFF"
        button.TextColor3 = isEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        callback(isEnabled)
    end)

    return frame
end

-- Функция для создания слайдера
local function createSlider(name, positionY, minValue, maxValue, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.Position = UDim2.new(0, 0, 0, positionY)
    frame.BackgroundTransparency = 1
    frame.Parent = MainFrame
    frame.Visible = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 150, 255)
    label.TextSize = 18
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.3, 0, 0.2, 0)
    sliderFrame.Position = UDim2.new(0.7, 0, 0.4, 0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
    sliderFrame.Parent = frame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = sliderFrame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    fill.Parent = sliderFrame

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 8)
    FillCorner.Parent = fill

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = sliderFrame

    local currentValue = defaultValue
    button.MouseButton1Down:Connect(function()
        local mouseConn
        mouseConn = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouseX = input.Position.X
                local frameX = sliderFrame.AbsolutePosition.X
                local frameWidth = sliderFrame.AbsoluteSize.X
                local relativeX = math.clamp((mouseX - frameX) / frameWidth, 0, 1)
                fill.Size = UDim2.new(relativeX, 0, 1, 0)
                currentValue = minValue + (maxValue - minValue) * relativeX
                callback(currentValue)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                mouseConn:Disconnect()
            end
        end)
    end)

    return frame
end

-- Переменные состояния
local hitboxEnabled = false
local hitboxRadius = 10 -- Начальный радиус хитбокса

-- Логика хитбокса для ловли мяча
RunService:BindToRenderStep("HitboxCatch", Enum.RenderPriority.Camera.Value, function()
    if hitboxEnabled then
        for _, ballModel in ipairs(workspace:GetChildren()) do
            if ballModel:IsA("Model") and ballModel.Name == "Ball" then
                local ball = ballModel:FindFirstChild("BallPart")
                if ball then
                    local playerPosition = PLAYER.Character and PLAYER.Character.PrimaryPart and PLAYER.Character.PrimaryPart.Position
                    if playerPosition then
                        local distance = (ball.Position - playerPosition).Magnitude
                        if distance <= hitboxRadius then
                            -- Эмулируем левый клик мыши для "Receive"
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        end
                    end
                end
            end
        end
    end
end)

-- Открытие/закрытие UI по F1
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F1 and not gameProcessed then
        MainFrame.Visible = not MainFrame.Visible
        showNotification(MainFrame.Visible and "UI Opened" or "UI Closed", 1)
    end
end)

-- Создаем элементы UI
local HitboxButton = createToggleButton("HITBOX CATCH", 40, function(state)
    hitboxEnabled = state
    showNotification("Hitbox Catch " .. (state and "Enabled" or "Disabled"), 1)
end)

local HitboxRadiusSlider = createSlider("HITBOX RADIUS", 80, 5, 50, 10, function(value)
    hitboxRadius = value
    showNotification("Hitbox Radius set to " .. tostring(math.floor(value)), 1)
end)

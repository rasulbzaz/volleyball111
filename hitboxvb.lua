-- Сервисы
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Локальный игрок
local PLAYER = Players.LocalPlayer

-- Создаем ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxUI"
ScreenGui.Parent = PLAYER.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 120)
MainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false
MainFrame.Active = true

-- Закругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Перетаскивание UI
local dragging, dragStart, startPos
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

-- Заголовок
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.Text = "Hitbox VB4.2"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

-- Функция для создания кнопки переключения
local function createToggleButton(name, positionY, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.Position = UDim2.new(0, 0, 0, positionY)
    frame.BackgroundTransparency = 1
    frame.Parent = MainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 16
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.3, 0, 0.7, 0)
    button.Position = UDim2.new(0.65, 0, 0.15, 0)
    button.Text = "OFF"
    button.TextColor3 = Color3.fromRGB(255, 100, 100)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextSize = 14
    button.Font = Enum.Font.SourceSans
    button.Parent = frame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
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
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.Position = UDim2.new(0, 0, 0, positionY)
    frame.BackgroundTransparency = 1
    frame.Parent = MainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 16
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.3, 0, 0.2, 0)
    sliderFrame.Position = UDim2.new(0.65, 0, 0.4, 0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderFrame.Parent = frame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = sliderFrame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    fill.Parent = sliderFrame

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 6)
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
                callback(math.floor(currentValue))
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

-- Состояние хитбокса
local hitboxEnabled = false
local hitboxRadius = 10
local lastClickTime = 0
local CLICK_COOLDOWN = 0.2

-- Логика хитбокса
RunService:BindToRenderStep("HitboxCatch", Enum.RenderPriority.Camera.Value, function()
    if hitboxEnabled then
        for _, ballModel in ipairs(workspace:GetChildren()) do
            if ballModel:IsA("Model") and ballModel.Name == "Ball" then
                local ball = ballModel:FindFirstChild("BallPart")
                if ball then
                    local playerPosition = PLAYER.Character and PLAYER.Character.PrimaryPart and PLAYER.Character.PrimaryPart.Position
                    if playerPosition then
                        local distance = (ball.Position - playerPosition).Magnitude
                        if distance <= hitboxRadius and (tick() - lastClickTime) >= CLICK_COOLDOWN then
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            lastClickTime = tick()
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
    end
end)

-- Создание UI элементов
createToggleButton("Hitbox", 40, function(state)
    hitboxEnabled = state
end)

createSlider("Radius", 80, 5, 30, 10, function(value)
    hitboxRadius = value
end)

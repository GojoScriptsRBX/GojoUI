-- GojoUI Library by DevEx | Ultra Modern UI Solution
local GojoUI = {}

-- Configuration
local config = {
    accentColor = Color3.fromRGB(100, 200, 255),
    darkColor = Color3.fromRGB(25, 25, 35),
    lightColor = Color3.fromRGB(40, 40, 50),
    textColor = Color3.fromRGB(240, 240, 240),
    errorColor = Color3.fromRGB(255, 80, 80),
    successColor = Color3.fromRGB(80, 255, 140),
    font = Enum.Font.Gotham,
    titleFont = Enum.Font.GothamBold,
    cornerRadius = UDim.new(0, 8),
    animationSpeed = 0.15,
    loadingDuration = 1.5,
    theme = "Dark", -- Добавлена поддержка тем (Dark/Light)
    toggleKey = Enum.KeyCode.F9 -- Горячая клавиша для открытия/закрытия
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Create loading screen
local function CreateLoader()
    local loaderUI = Instance.new("ScreenGui")
    loaderUI.Name = "GojoUILoader"
    loaderUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loaderUI.ResetOnSpawn = false
    loaderUI.Parent = CoreGui

    -- Background
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = config.darkColor
    background.BorderSizePixel = 0
    background.ZIndex = 999
    background.Parent = loaderUI

    -- Container
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 400, 0, 200)
    container.Position = UDim2.new(0.5, -200, 0.5, -100)
    container.BackgroundTransparency = 1
    container.ZIndex = 1000
    container.Parent = background

    -- Logo
    local logo = Instance.new("TextLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(1, 0, 0, 80)
    logo.Text = "GojoUI"
    logo.TextColor3 = config.accentColor
    logo.TextSize = 48
    logo.Font = config.titleFont
    logo.BackgroundTransparency = 1
    logo.ZIndex = 1001
    logo.Parent = container

    -- Progress bar background
    local progressBg = Instance.new("Frame")
    progressBg.Name = "ProgressBackground"
    progressBg.Size = UDim2.new(1, -40, 0, 8)
    progressBg.Position = UDim2.new(0, 20, 1, -40)
    progressBg.BackgroundColor3 = config.lightColor
    progressBg.ZIndex = 1001
    progressBg.Parent = container

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = config.cornerRadius
    bgCorner.Parent = progressBg

    -- Progress bar fill
    local progressFill = Instance.new("Frame")
    progressFill.Name = "ProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = config.accentColor
    progressFill.ZIndex = 1002
    progressFill.Parent = progressBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = config.cornerRadius
    fillCorner.Parent = progressFill

    -- Status text
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 1, -20)
    status.Text = "Initializing..."
    status.TextColor3 = config.textColor
    status.TextSize = 14
    status.Font = config.font
    status.BackgroundTransparency = 1
    status.ZIndex = 1001
    status.Parent = container

    -- Animation
    local tweenInfo = TweenInfo.new(config.loadingDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    TweenService:Create(progressFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)}):Play()

    -- Simulate loading steps
    local steps = {
        "Loading assets...",
        "Initializing components...",
        "Building interface...",
        "Almost done...",
        "Ready!"
    }

    local stepInterval = config.loadingDuration / #steps
    for i, text in ipairs(steps) do
        task.delay((i - 1) * stepInterval, function()
            if status and status.Parent then
                status.Text = text
            end
        end)
    end

    -- Cleanup
    task.delay(config.loadingDuration, function()
        if loaderUI and loaderUI.Parent then
            local fadeOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenService:Create(background, fadeOut, {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            loaderUI:Destroy()
        end
    end)

    return loaderUI
end

-- Create main window
function GojoUI:CreateWindow(title)
    -- Show loading screen
    CreateLoader()

    local window = {}
    local connections = {}
    local notifications = {}
    local isDragging = false
    local isMinimized = false
    local dragInput, dragStart, startPos

    -- Main UI container
    local ui = Instance.new("ScreenGui")
    ui.Name = "GojoUI"
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ui.ResetOnSpawn = false
    ui.Parent = CoreGui

    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    mainFrame.BackgroundColor3 = config.darkColor
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = ui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.cornerRadius
    corner.Parent = mainFrame

    -- Enhanced drop shadow
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = -1
    shadow.Parent = mainFrame

    local shadowGradient = Instance.new("UIGradient")
    shadowGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    shadowGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 1)
    })
    shadowGradient.Parent = shadow

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 42)
    titleBar.BackgroundColor3 = config.accentColor
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar

    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title
    titleText.TextColor3 = config.textColor
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = config.titleFont
    titleText.TextSize = 18
    titleText.Parent = titleBar

    -- Minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 32, 0, 32)
    minimizeButton.Position = UDim2.new(1, -74, 0.5, -16)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 80)
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = config.textColor
    minimizeButton.TextSize = 24
    minimizeButton.Font = config.titleFont
    minimizeButton.Parent = titleBar

    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(1, 0)
    minimizeCorner.Parent = minimizeButton

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 32, 0, 32)
    closeButton.Position = UDim2.new(1, -37, 0.5, -16)
    closeButton.BackgroundColor3 = config.errorColor
    closeButton.Text = "×"
    closeButton.TextColor3 = config.textColor
    closeButton.TextSize = 24
    closeButton.Font = config.titleFont
    closeButton.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton

    -- Button effects
    local function applyButtonEffects(button, hoverColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = hoverColor, Size = UDim2.new(0, 34, 0, 34)}):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = button.BackgroundColor3, Size = UDim2.new(0, 32, 0, 32)}):Play()
        end)
    end

    applyButtonEffects(closeButton, Color3.fromRGB(255, 120, 120))
    applyButtonEffects(minimizeButton, Color3.fromRGB(255, 200, 120))

    -- Minimize functionality
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, 500, 0, 42) or UDim2.new(0, 500, 0, 600)
        TweenService:Create(mainFrame, TweenInfo.new(config.animationSpeed), {Size = targetSize}):Play()
    end)

    closeButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)

    -- Tab buttons container
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.Size = UDim2.new(1, -20, 0, 40)
    tabButtons.Position = UDim2.new(0, 10, 0, 47)
    tabButtons.BackgroundTransparency = 1
    tabButtons.Parent = mainFrame

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = tabButtons

    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -20, 1, -100)
    contentContainer.Position = UDim2.new(0, 10, 0, 92)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame

    -- Drag functionality
    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not isMinimized then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and isDragging then
            updateDrag(input)
        end
    end))

    -- Toggle visibility with hotkey
    table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == config.toggleKey then
            ui.Enabled = not ui.Enabled
        end
    end))

    -- Window methods
    function window:Notification(title, message, duration)
        duration = duration or 3

        local notification = Instance.new("Frame")
        notification.Name = "Notification_" .. tostring(#notifications + 1)
        notification.Size = UDim2.new(0, 300, 0, 100)
        notification.Position = UDim2.new(1, -320, 1, -120 - (#notifications * 110))
        notification.BackgroundColor3 = config.darkColor
        notification.Parent = ui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = config.cornerRadius
        corner.Parent = notification

        local shadow = Instance.new("Frame")
        shadow.Name = "Shadow"
        shadow.Size = UDim2.new(1, 12, 1, 12)
        shadow.Position = UDim2.new(0, -6, 0, -6)
        shadow.BackgroundTransparency = 1
        shadow.ZIndex = -1
        shadow.Parent = notification

        local shadowGradient = Instance.new("UIGradient")
        shadowGradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
        shadowGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(1, 1)})
        shadowGradient.Parent = shadow

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, -20, 0, 30)
        titleLabel.Position = UDim2.new(0, 15, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = config.accentColor
        titleLabel.Font = config.titleFont
        titleLabel.TextSize = 18
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notification

        local messageLabel = Instance.new("TextLabel")
        messageLabel.Name = "Message"
        messageLabel.Size = UDim2.new(1, -20, 0, 50)
        messageLabel.Position = UDim2.new(0, 15, 0, 40)
        messageLabel.BackgroundTransparency = 1
        messageLabel.Text = message
        messageLabel.TextColor3 = config.textColor
        messageLabel.Font = config.font
        messageLabel.TextSize = 14
        messageLabel.TextXAlignment = Enum.TextXAlignment.Left
        messageLabel.TextYAlignment = Enum.TextYAlignment.Top
        messageLabel.TextWrapped = true
        messageLabel.Parent = notification

        table.insert(notifications, notification)

        -- Animate in
        notification.Position = UDim2.new(1, 20, 1, -120 - (#notifications * 110))
        TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2.new(1, -320, 1, -120 - (#notifications * 110))}):Play()

        -- Auto remove after duration
        task.delay(duration, function()
            if notification and notification.Parent then
                TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2.new(1, 20, notification.Position.Y.Scale, notification.Position.Y.Offset)}):Play()
                task.wait(0.3)
                notification:Destroy()
                table.remove(notifications, table.find(notifications, notification))

                -- Update positions of remaining notifications
                for i, notif in ipairs(notifications) do
                    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, -320, 1, -120 - (i * 110))}):Play()
                end
            end
        end)
    end

    function window:Destroy()
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end
        ui:Destroy()
    end

    -- Tab methods
    function window:NewTab(name)
        local tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.BackgroundColor3 = config.darkColor
        tabButton.BackgroundTransparency = 0.5
        tabButton.Text = name
        tabButton.TextColor3 = config.textColor
        tabButton.Font = config.font
        tabButton.TextSize = 14
        tabButton.Parent = tabButtons

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = config.cornerRadius
        tabCorner.Parent = tabButton

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = config.accentColor
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Parent = contentContainer

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Parent = tabContent
        contentLayout.Padding = UDim.new(0, 10)

        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Tab switching
        tabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(contentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            tabContent.Visible = true

            for _, btn in ipairs(tabButtons:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(config.animationSpeed), {TextColor3 = config.textColor, BackgroundTransparency = 0.5}):Play()
                end
            end

            TweenService:Create(tabButton, TweenInfo.new(config.animationSpeed), {TextColor3 = config.accentColor, BackgroundTransparency = 0}):Play()
        end)

        -- Activate first tab
        if #tabButtons:GetChildren() == 1 then
            tabButton.TextColor3 = config.accentColor
            tabButton.BackgroundTransparency = 0
            tabContent.Visible = true
        end

        -- Section methods
        function tab:NewSection(name)
            local section = {}
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundColor3 = config.lightColor
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Parent = tabContent

            local corner = Instance.new("UICorner")
            corner.CornerRadius = config.cornerRadius
            corner.Parent = sectionFrame

            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Size = UDim2.new(1, -20, 0, 40)
            sectionTitle.Position = UDim2.new(0, 15, 0, 0)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = name
            sectionTitle.TextColor3 = config.accentColor
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Font = config.titleFont
            sectionTitle.TextSize = 16
            sectionTitle.Parent = sectionFrame

            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Parent = sectionFrame
            contentLayout.Padding = UDim.new(0, 10)

            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionFrame.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 50)
            end)

            -- Button element
            function section:NewButton(name, description, callback)
                local button = Instance.new("TextButton")
                button.Name = name
                button.Size = UDim2.new(1, -20, 0, 40)
                button.Position = UDim2.new(0, 10, 0, 40)
                button.BackgroundColor3 = config.darkColor
                button.Text = name
                button.TextColor3 = config.textColor
                button.Font = config.font
                button.TextSize = 14
                button.Parent = sectionFrame

                local corner = Instance.new("UICorner")
                corner.CornerRadius = config.cornerRadius
                corner.Parent = button

                local tooltip = Instance.new("TextLabel")
                tooltip.Name = "Tooltip"
                tooltip.Size = UDim2.new(1, -20, 0, 0)
                tooltip.Position = UDim2.new(0, 10, 0, 40)
                tooltip.BackgroundColor3 = config.darkColor
                tooltip.Text = description
                tooltip.TextColor3 = config.textColor
                tooltip.Font = config.font
                tooltip.TextSize = 12
                tooltip.TextWrapped = true
                tooltip.Visible = false
                tooltip.Parent = sectionFrame

                local tooltipCorner = Instance.new("UICorner")
                tooltipCorner.CornerRadius = config.cornerRadius
                tooltipCorner.Parent = tooltip

                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = config.accentColor, Size = UDim2.new(1, -18, 0, 42)}):Play()
                    tooltip.Size = UDim2.new(1, -20, 0, 0)
                    tooltip.Visible = true
                    TweenService:Create(tooltip, TweenInfo.new(config.animationSpeed), {Size = UDim2.new(1, -20, 0, 40)}):Play()
                end)

                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = config.darkColor, Size = UDim2.new(1, -20, 0, 40)}):Play()
                    TweenService:Create(tooltip, TweenInfo.new(config.animationSpeed), {Size = UDim2.new(1, -20, 0, 0)}):Play()
                    task.wait(config.animationSpeed)
                    tooltip.Visible = false
                end)

                button.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)

                return button
            end

            -- Toggle element
            function section:NewToggle(name, description, callback)
                local toggle = {}
                local value = false

                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = name
                toggleFrame.Size = UDim2.new(1, -20, 0, 40)
                toggleFrame.Position = UDim2.new(0, 10, 0, 0)
                toggleFrame.BackgroundColor3 = config.darkColor
                toggleFrame.Parent = sectionFrame

                local corner = Instance.new("UICorner")
                corner.CornerRadius = config.cornerRadius
                corner.Parent = toggleFrame

                local title = Instance.new("TextLabel")
                title.Name = "Title"
                title.Size = UDim2.new(0.7, 0, 1, 0)
                title.Position = UDim2.new(0, 15, 0, 0)
                title.BackgroundTransparency = 1
                title.Text = name
                title.TextColor3 = config.textColor
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Font = config.font
                title.TextSize = 14
                title.Parent = toggleFrame

                local toggleIndicator = Instance.new("Frame")
                toggleIndicator.Name = "Indicator"
                toggleIndicator.Size = UDim2.new(0, 24, 0, 24)
                toggleIndicator.Position = UDim2.new(1, -30, 0.5, -12)
                toggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                toggleIndicator.Parent = toggleFrame

                local indicatorCorner = Instance.new("UICorner")
                indicatorCorner.CornerRadius = UDim.new(1, 0)
                indicatorCorner.Parent = toggleIndicator

                toggleFrame.MouseEnter:Connect(function()
                    TweenService:Create(toggleFrame, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = config.accentColor, Size = UDim2.new(1, -18, 0, 42)}):Play()
                end)

                toggleFrame.MouseLeave:Connect(function()
                    TweenService:Create(toggleFrame, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = config.darkColor, Size = UDim2.new(1, -20, 0, 40)}):Play()
                end)

                toggleFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        value = not value
                        TweenService:Create(toggleIndicator, TweenInfo.new(config.animationSpeed), {
                            BackgroundColor3 = value and config.accentColor or Color3.fromRGB(80, 80, 80)
                        }):Play()
                        pcall(callback, value)
                    end
                end)

                function toggle:SetValue(newValue)
                    value = newValue
                    TweenService:Create(toggleIndicator, TweenInfo.new(config.animationSpeed), {
                        BackgroundColor3 = value and config.accentColor or Color3.fromRGB(80, 80, 80)
                    }):Play()
                    pcall(callback, value)
                end

                return toggle
            end

            -- Label element
            function section:NewLabel(text)
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Size = UDim2.new(1, -20, 0, 20)
                label.Position = UDim2.new(0, 10, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = config.textColor
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = config.font
                label.TextSize = 14
                label.Parent = sectionFrame

                function label:Update(newText)
                    label.Text = newText
                end

                return label
            end

            -- Slider element
            function section:NewSlider(name, minValue, maxValue, defaultValue, callback)
                local slider = {}
                local value = defaultValue or minValue

                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = name
                sliderFrame.Size = UDim2.new(1, -20, 0, 60)
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Parent = sectionFrame

                local title = Instance.new("TextLabel")
                title.Name = "Title"
                title.Size = UDim2.new(1, 0, 0, 20)
                title.BackgroundTransparency = 1
                title.Text = name
                title.TextColor3 = config.textColor
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Font = config.font
                title.TextSize = 14
                title.Parent = sliderFrame

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Name = "Value"
                valueLabel.Size = UDim2.new(0, 60, 0, 20)
                valueLabel.Position = UDim2.new(1, -60, 0, 0)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(value)
                valueLabel.TextColor3 = config.accentColor
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Font = config.font
                valueLabel.TextSize = 14
                valueLabel.Parent = sliderFrame

                local track = Instance.new("Frame")
                track.Name = "Track"
                track.Size = UDim2.new(1, 0, 0, 4)
                track.Position = UDim2.new(0, 0, 0, 30)
                track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                track.Parent = sliderFrame

                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = track

                local fill = Instance.new("Frame")
                fill.Name = "Fill"
                fill.Size = UDim2.new((value - minValue) / (maxValue - minValue), 0, 1, 0)
                fill.BackgroundColor3 = config.accentColor
                fill.Parent = track

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = fill

                local handle = Instance.new("TextButton")
                handle.Name = "Handle"
                handle.Size = UDim2.new(0, 16, 0, 16)
                handle.Position = UDim2.new(fill.Size.X.Scale, -8, 0.5, -8)
                handle.BackgroundColor3 = config.textColor
                handle.Text = ""
                handle.Parent = track

                local handleCorner = Instance.new("UICorner")
                handleCorner.CornerRadius = UDim.new(1, 0)
                handleCorner.Parent = handle

                local dragging = false

                local function updateValue(input)
                    local relativeX = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                    relativeX = math.clamp(relativeX, 0, 1)
                    value = math.floor(minValue + (maxValue - minValue) * relativeX)
                    valueLabel.Text = tostring(value)
                    fill.Size = UDim2.new(relativeX, 0, 1, 0)
                    handle.Position = UDim2.new(relativeX, -8, 0.5, -8)
                    pcall(callback, value)
                end

                handle.MouseButton1Down:Connect(function()
                    dragging = true
                end)

                table.insert(connections, UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end))

                table.insert(connections, UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateValue(input)
                    end
                end))

                track.MouseButton1Down:Connect(function(input)
                    updateValue(input)
                end)

                function slider:SetValue(newValue)
                    value = math.clamp(newValue, minValue, maxValue)
                    local relativeX = (value - minValue) / (maxValue - minValue)
                    valueLabel.Text = tostring(value)
                    fill.Size = UDim2.new(relativeX, 0, 1, 0)
                    handle.Position = UDim2.new(relativeX, -8, 0.5, -8)
                    pcall(callback, value)
                end

                return slider
            end

            -- ColorPicker element (New)
            function section:NewColorPicker(name, defaultColor, callback)
                local colorPicker = {}
                local value = defaultColor or Color3.fromRGB(255, 255, 255)
                local isOpen = false

                local pickerFrame = Instance.new("Frame")
                pickerFrame.Name = name
                pickerFrame.Size = UDim2.new(1, -20, 0, 40)
                pickerFrame.BackgroundColor3 = config.darkColor
                pickerFrame.Parent = sectionFrame

                local corner = Instance.new("UICorner")
                corner.CornerRadius = config.cornerRadius
                corner.Parent = pickerFrame

                local title = Instance.new("TextLabel")
                title.Name = "Title"
                title.Size = UDim2.new(0.7, 0, 1, 0)
                title.Position = UDim2.new(0, 15, 0, 0)
                title.BackgroundTransparency = 1
                title.Text = name
                title.TextColor3 = config.textColor
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Font = config.font
                title.TextSize = 14
                title.Parent = pickerFrame

                local colorIndicator = Instance.new("Frame")
                colorIndicator.Name = "ColorIndicator"
                colorIndicator.Size = UDim2.new(0, 24, 0, 24)
                colorIndicator.Position = UDim2.new(1, -30, 0.5, -12)
                colorIndicator.BackgroundColor3 = value
                colorIndicator.Parent = pickerFrame

                local indicatorCorner = Instance.new("UICorner")
                indicatorCorner.CornerRadius = UDim.new(0, 4)
                indicatorCorner.Parent = colorIndicator

                local pickerPanel = Instance.new("Frame")
                pickerPanel.Name = "PickerPanel"
                pickerPanel.Size = UDim2.new(1, -20, 0, 0)
                pickerPanel.Position = UDim2.new(0, 10, 0, 40)
                pickerPanel.BackgroundColor3 = config.lightColor
                pickerPanel.Visible = false
                pickerPanel.Parent = sectionFrame

                local pickerCorner = Instance.new("UICorner")
                pickerCorner.CornerRadius = config.cornerRadius
                pickerCorner.Parent = pickerPanel

                local hueBar = Instance.new("Frame")
                hueBar.Name = "HueBar"
                hueBar.Size = UDim2.new(1, -20, 0, 20)
                hueBar.Position = UDim2.new(0, 10, 0, 10)
                hueBar.Parent = pickerPanel

                local hueGradient = Instance.new("UIGradient")
                hueGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                })
                hueGradient.Parent = hueBar

                local hueCorner = Instance.new("UICorner")
                hueCorner.CornerRadius = UDim.new(0, 4)
                hueCorner.Parent = hueBar

                pickerFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isOpen = not isOpen
                        pickerPanel.Visible = isOpen
                        TweenService:Create(pickerPanel, TweenInfo.new(config.animationSpeed), {Size = UDim2.new(1, -20, 0, isOpen and 100 or 0)}):Play()
                    end
                end)

                function colorPicker:SetValue(newColor)
                    value = newColor
                    colorIndicator.BackgroundColor3 = value
                    pcall(callback, value)
                end

                return colorPicker
            end

            return section
        end

        return tab
    end

    return window
end

return GojoUI

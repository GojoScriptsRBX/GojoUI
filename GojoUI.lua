-- GojoUI Library by DevEx | Ultra Modern UI Solution
local GojoUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local config = {
    accentColor = Color3.fromRGB(100, 200, 255),
    darkColor = Color3.fromRGB(30, 30, 40),
    lightColor = Color3.fromRGB(50, 50, 60),
    textColor = Color3.fromRGB(230, 230, 230),
    errorColor = Color3.fromRGB(255, 100, 100),
    successColor = Color3.fromRGB(100, 255, 150),
    font = Enum.Font.Gotham,
    titleFont = Enum.Font.GothamBold,
    cornerRadius = UDim.new(0, 10),
    animationSpeed = 0.2,
    loadingDuration = 1,
    theme = "Dark",
    toggleKey = Enum.KeyCode.F9,
    shadowTransparency = 0.6
}

-- Light theme colors (optional)
if config.theme == "Light" then
    config.darkColor = Color3.fromRGB(220, 220, 220)
    config.lightColor = Color3.fromRGB(240, 240, 240)
    config.textColor = Color3.fromRGB(30, 30, 30)
end

-- Utility function to create shadows
local function CreateShadow(parent)
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = -1
    shadow.Parent = parent

    local shadowGradient = Instance.new("UIGradient")
    shadowGradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
    shadowGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, config.shadowTransparency),
        NumberSequenceKeypoint.new(1, 1)
    })
    shadowGradient.Parent = shadow
end

-- Create compact loading screen
local function CreateLoader()
    local loaderUI = Instance.new("ScreenGui")
    loaderUI.Name = "GojoUILoader"
    loaderUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loaderUI.ResetOnSpawn = false
    loaderUI.Parent = CoreGui

    -- Background
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(0, 300, 0, 150)
    background.Position = UDim2.new(0.5, -150, 0.5, -75)
    background.BackgroundColor3 = config.darkColor
    background.BorderSizePixel = 0
    background.ZIndex = 999
    background.Parent = loaderUI

    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.cornerRadius
    corner.Parent = background

    CreateShadow(background)

    -- Logo
    local logo = Instance.new("TextLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(1, 0, 0, 50)
    logo.Text = "GojoUI"
    logo.TextColor3 = config.accentColor
    logo.TextSize = 32
    logo.Font = config.titleFont
    logo.BackgroundTransparency = 1
    logo.ZIndex = 1000
    logo.Parent = background

    -- Progress bar background
    local progressBg = Instance.new("Frame")
    progressBg.Name = "ProgressBackground"
    progressBg.Size = UDim2.new(1, -40, 0, 6)
    progressBg.Position = UDim2.new(0, 20, 0, 80)
    progressBg.BackgroundColor3 = config.lightColor
    progressBg.ZIndex = 1000
    progressBg.Parent = background

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 3)
    bgCorner.Parent = progressBg

    -- Progress bar fill
    local progressFill = Instance.new("Frame")
    progressFill.Name = "ProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = config.accentColor
    progressFill.ZIndex = 1001
    progressFill.Parent = progressBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = progressFill

    -- Status text
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0, 110)
    status.Text = "Initializing..."
    status.TextColor3 = config.textColor
    status.TextSize = 12
    status.Font = config.font
    status.BackgroundTransparency = 1
    status.ZIndex = 1000
    status.Parent = background

    -- Animation
    local tweenInfo = TweenInfo.new(config.loadingDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    background.BackgroundTransparency = 1
    TweenService:Create(background, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(progressFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)}):Play()

    -- Simulate loading steps
    local steps = {
        "Loading assets...",
        "Building interface...",
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
            TweenService:Create(background, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
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
    local currentTab = nil

    -- Main UI container
    local ui = Instance.new("ScreenGui")
    ui.Name = "GojoUI"
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ui.ResetOnSpawn = false
    ui.Parent = CoreGui

    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 550, 0, 650)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -325)
    mainFrame.BackgroundColor3 = config.darkColor
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = ui

    TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.cornerRadius
    corner.Parent = mainFrame

    CreateShadow(mainFrame)

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = config.accentColor
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, config.accentColor),
        ColorSequenceKeypoint.new(1, config.accentColor:Lerp(Color3.fromRGB(255, 255, 255), 0.2))
    })
    titleGradient.Parent = titleBar

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar

    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title
    titleText.TextColor3 = config.textColor
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = config.titleFont
    titleText.TextSize = 20
    titleText.Parent = titleBar

    -- Minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 36, 0, 36)
    minimizeButton.Position = UDim2.new(1, -82, 0.5, -18)
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
    closeButton.Size = UDim2.new(0, 36, 0, 36)
    closeButton.Position = UDim2.new(1, -42, 0.5, -18)
    closeButton.BackgroundColor3 = config.errorColor
    closeButton.Text = "×"
    closeButton.TextColor3 = config.textColor
    closeButton.TextSize = 24
    closeButton.Font = config.titleFont
    closeButton.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton

    -- Button effects with ripple
    local function applyButtonEffects(button, hoverColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = hoverColor, Size = UDim2.new(0, 38, 0, 38)}):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = button.BackgroundColor3, Size = UDim2.new(0, 36, 0, 36)}):Play()
        end)

        button.MouseButton1Down:Connect(function()
            local ripple = Instance.new("Frame")
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
            ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ripple.BackgroundTransparency = 0.5
            ripple.ZIndex = 10
            ripple.Parent = button

            local rippleCorner = Instance.new("UICorner")
            rippleCorner.CornerRadius = UDim.new(1, 0)
            rippleCorner.Parent = ripple

            TweenService:Create(ripple, TweenInfo.new(0.3), {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            ripple:Destroy()
        end)
    end

    applyButtonEffects(closeButton, Color3.fromRGB(255, 120, 120))
    applyButtonEffects(minimizeButton, Color3.fromRGB(255, 200, 120))

    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, 550, 0, 50) or UDim2.new(0, 550, 0, 650)
        TweenService:Create(mainFrame, TweenInfo.new(config.animationSpeed), {Size = targetSize}):Play()
    end)

    closeButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)

    -- Tab buttons container
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.Size = UDim2.new(1, -20, 0, 50)
    tabButtons.Position = UDim2.new(0, 10, 0, 60)
    tabButtons.BackgroundTransparency = 1
    tabButtons.Parent = mainFrame

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.Padding = UDim.new(0, 8)
    tabListLayout.Parent = tabButtons

    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -20, 1, -120)
    contentContainer.Position = UDim2.new(0, 10, 0, 120)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ClipsDescendants = true
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
        notification.Size = UDim2.new(0, 320, 0, 110)
        notification.Position = UDim2.new(1, -340, 1, -130 - (#notifications * 120))
        notification.BackgroundColor3 = config.darkColor
        notification.Parent = ui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = config.cornerRadius
        corner.Parent = notification

        CreateShadow(notification)

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
        messageLabel.Size = UDim2.new(1, -20, 0, 60)
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

        notification.Position = UDim2.new(1, 20, 1, -130 - (#notifications * 120))
        TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2.new(1, -340, 1, -130 - (#notifications * 120))}):Play()

        task.delay(duration, function()
            if notification and notification.Parent then
                TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2.new(1, 20, notification.Position.Y.Scale, notification.Position.Y.Offset)}):Play()
                task.wait(0.3)
                notification:Destroy()
                table.remove(notifications, table.find(notifications, notification))

                for i, notif in ipairs(notifications) do
                    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, -340, 1, -130 - (i * 120))}):Play()
                end
            end
        end)
    end

    function window:Destroy()
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        ui:Destroy()
    end

    -- Tab methods
    function window:NewTab(name, icon)
        local tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name
        tabButton.Size = UDim2.new(0, 120, 1, 0)
        tabButton.BackgroundColor3 = config.lightColor
        tabButton.BackgroundTransparency = 0.5
        tabButton.Text = icon and "" or name
        tabButton.TextColor3 = config.textColor
        tabButton.Font = config.font
        tabButton.TextSize = 14
        tabButton.Parent = tabButtons

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = config.cornerRadius
        tabCorner.Parent = tabButton

        if icon then
            local tabIcon = Instance.new("ImageLabel")
            tabIcon.Size = UDim2.new(0, 24, 0, 24)
            tabIcon.Position = UDim2.new(0, 10, 0.5, -12)
            tabIcon.BackgroundTransparency = 1
            tabIcon.Image = icon
            tabIcon.ImageColor3 = config.textColor
            tabIcon.Parent = tabButton

            local tabText = Instance.new("TextLabel")
            tabText.Size = UDim2.new(1, -50, 1, 0)
            tabText.Position = UDim2.new(0, 40, 0, 0)
            tabText.BackgroundTransparency = 1
            tabText.Text = name
            tabText.TextColor3 = config.textColor
            tabText.Font = config.font
            tabText.TextSize = 14
            tabText.TextXAlignment = Enum.TextXAlignment.Left
            tabText.Parent = tabButton
        end

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = config.accentColor
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.Parent = contentContainer

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Parent = tabContent
        contentLayout.Padding = UDim.new(0, 12)

        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Tab switching with animation
        tabButton.MouseButton1Click:Connect(function()
            if currentTab == tabContent then return end

            -- Fade out current tab
            if currentTab then
                TweenService:Create(currentTab, TweenInfo.new(config.animationSpeed), {Position = UDim2.new(-1, 0, 0, 0)}):Play()
                currentTab.Visible = false
            end

            -- Fade in new tab
            tabContent.Position = UDim2.new(1, 0, 0, 0)
            tabContent.Visible = true
            TweenService:Create(tabContent, TweenInfo.new(config.animationSpeed), {Position = UDim2.new(0, 0, 0, 0)}):Play()
            currentTab = tabContent

            for _, btn in ipairs(tabButtons:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(config.animationSpeed), {BackgroundTransparency = 0.5, TextColor3 = config.textColor}):Play()
                end
            end

            TweenService:Create(tabButton, TweenInfo.new(config.animationSpeed), {BackgroundTransparency = 0, TextColor3 = config.accentColor}):Play()
        end)

        if #tabButtons:GetChildren() == 1 then
            tabButton.BackgroundTransparency = 0
            tabButton.TextColor3 = config.accentColor
            tabContent.Visible = true
            currentTab = tabContent
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
            sectionTitle.Position = UDim2.new(0, 15, 0, 10)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = name
            sectionTitle.TextColor3 = config.accentColor
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Font = config.titleFont
            sectionTitle.TextSize = 18
            sectionTitle.Parent = sectionFrame

            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Parent = sectionFrame
            contentLayout.Padding = UDim.new(0, 12)

            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionFrame.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 60)
            end)

            -- Button element
            function section:NewButton(name, description, callback, icon)
                local button = Instance.new("TextButton")
                button.Name = name
                button.Size = UDim2.new(1, -20, 0, 45)
                button.Position = UDim2.new(0, 10, 0, 40)
                button.BackgroundColor3 = config.darkColor
                button.Text = icon and "" or name
                button.TextColor3 = config.textColor
                button.Font = config.font
                button.TextSize = 15
                button.Parent = sectionFrame

                local corner = Instance.new("UICorner")
                corner.CornerRadius = config.cornerRadius
                corner.Parent = button

                if icon then
                    local buttonIcon = Instance.new("ImageLabel")
                    buttonIcon.Size = UDim2.new(0, 24, 0, 24)
                    buttonIcon.Position = UDim2.new(0, 10, 0.5, -12)
                    buttonIcon.BackgroundTransparency = 1
                    buttonIcon.Image = icon
                    buttonIcon.ImageColor3 = config.textColor
                    buttonIcon.Parent = button

                    local buttonText = Instance.new("TextLabel")
                    buttonText.Size = UDim2.new(1, -50, 1, 0)
                    buttonText.Position = UDim2.new(0, 40, 0, 0)
                    buttonText.BackgroundTransparency = 1
                    buttonText.Text = name
                    buttonText.TextColor3 = config.textColor
                    buttonText.Font = config.font
                    buttonText.TextSize = 15
                    buttonText.TextXAlignment = Enum.TextXAlignment.Left
                    buttonText.Parent = button
                end

                local tooltip = Instance.new("TextLabel")
                tooltip.Name = "Tooltip"
                tooltip.Size = UDim2.new(1, -20, 0, 0)
                tooltip.Position = UDim2.new(0, 10, 0, 45)
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
                    TweenService:Create(button, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = config.accentColor, Size = UDim2.new(1, -18, 0, 47)}):Play()
                    tooltip.Size = UDim2.new(1, -20, 0, 0)
                    tooltip.Visible = true
                    TweenService:Create(tooltip, TweenInfo.new(config.animationSpeed), {Size = UDim2.new(1, -20, 0, 40)}):Play()
                end)

                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = config.darkColor, Size = UDim2.new(1, -20, 0, 45)}):Play()
                    TweenService:Create(tooltip, TweenInfo.new(config.animationSpeed), {Size = UDim2.new(1, -20, 0, 0)}):Play()
                    task.wait(config.animationSpeed)
                    tooltip.Visible = false
                end)

                button.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)

                applyButtonEffects(button, config.accentColor)

                return button
            end

            -- Toggle element
            function section:NewToggle(name, description, callback)
                local toggle = {}
                local value = false

                local toggleButton = Instance.new("TextButton")
                toggleButton.Name = name
                toggleButton.Size = UDim2.new(1, -20, 0, 45)
                toggleButton.Position = UDim2.new(0, 10, 0, 40)
                toggleButton.BackgroundColor3 = config.darkColor
                toggleButton.Text = ""
                toggleButton.Parent = sectionFrame

                local corner = Instance.new("UICorner")
                corner.CornerRadius = config.cornerRadius
                corner.Parent = toggleButton

                local title = Instance.new("TextLabel")
                title.Name = "Title"
                title.Size = UDim2.new(0.7, 0, 1, 0)
                title.Position = UDim2.new(0, 15, 0, 0)
                title.BackgroundTransparency = 1
                title.Text = name
                title.TextColor3 = config.textColor
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Font = config.font
                title.TextSize = 15
                title.Parent = toggleButton

                local toggleTrack = Instance.new("Frame")
                toggleTrack.Name = "Track"
                toggleTrack.Size = UDim2.new(0, 50, 0, 24)
                toggleTrack.Position = UDim2.new(1, -60, 0.5, -12)
                toggleTrack.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                toggleTrack.Parent = toggleButton

                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = toggleTrack

                local toggleIndicator = Instance.new("Frame")
                toggleIndicator.Name = "Indicator"
                toggleIndicator.Size = UDim2.new(0, 20, 0, 20)
                toggleIndicator.Position = UDim2.new(0, 4, 0.5, -10)
                toggleIndicator.BackgroundColor3 = config.textColor
                toggleIndicator.Parent = toggleTrack

                local indicatorCorner = Instance.new("UICorner")
                indicatorCorner.CornerRadius = UDim.new(1, 0)
                indicatorCorner.Parent = toggleIndicator

                toggleButton.MouseEnter:Connect(function()
                    TweenService:Create(toggleButton, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = config.accentColor, Size = UDim2.new(1, -18, 0, 47)}):Play()
                end)

                toggleButton.MouseLeave:Connect(function()
                    TweenService:Create(toggleButton, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = config.darkColor, Size = UDim2.new(1, -20, 0, 45)}):Play()
                end)

                toggleButton.MouseButton1Click:Connect(function()
                    value = not value
                    local targetPos = value and UDim2.new(0, 26, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
                    local targetColor = value and config.accentColor or config.textColor
                    TweenService:Create(toggleIndicator, TweenInfo.new(config.animationSpeed), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
                    pcall(callback, value)
                end)

                function toggle:SetValue(newValue)
                    value = newValue
                    local targetPos = value and UDim2.new(0, 26, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
                    local targetColor = value and config.accentColor or config.textColor
                    TweenService:Create(toggleIndicator, TweenInfo.new(config.animationSpeed), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
                    pcall(callback, value)
                end

                applyButtonEffects(toggleButton, config.accentColor)

                return toggle
            end

            -- Label element
            function section:NewLabel(text)
                local label = Instance.new("TextLabel")
                label.Name = "Label"
                label.Size = UDim2.new(1, -20, 0, 25)
                label.Position = UDim2.new(0, 10, 0, 40)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = config.textColor
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = config.font
                label.TextSize = 15
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
                sliderFrame.Size = UDim2.new(1, -20, 0, 70)
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Parent = sectionFrame

                local title = Instance.new("TextLabel")
                title.Name = "Title"
                title.Size = UDim2.new(1, 0, 0, 25)
                title.BackgroundTransparency = 1
                title.Text = name
                title.TextColor3 = config.textColor
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Font = config.font
                title.TextSize = 15
                title.Parent = sliderFrame

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Name = "Value"
                valueLabel.Size = UDim2.new(0, 60, 0, 25)
                valueLabel.Position = UDim2.new(1, -60, 0, 0)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(value)
                valueLabel.TextColor3 = config.accentColor
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Font = config.font
                valueLabel.TextSize = 15
                valueLabel.Parent = sliderFrame

                local track = Instance.new("Frame")
                track.Name = "Track"
                track.Size = UDim2.new(1, 0, 0, 6)
                track.Position = UDim2.new(0, 0, 0, 35)
                track.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
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
                handle.Size = UDim2.new(0, 18, 0, 18)
                handle.Position = UDim2.new(fill.Size.X.Scale, -9, 0.5, -9)
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
                    handle.Position = UDim2.new(relativeX, -9, 0.5, -9)
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
                    handle.Position = UDim2.new(relativeX, -9, 0.5, -9)
                    pcall(callback, value)
                end

                return slider
            end

            -- Full ColorPicker element (with HSV)
            function section:NewColorPicker(name, defaultColor, callback)
                local colorPicker = {}
                local value = defaultColor or Color3.fromRGB(255, 255, 255)
                local isOpen = false
                local h, s, v = value:ToHSV()

                local pickerButton = Instance.new("TextButton")
                pickerButton.Name = name
                pickerButton.Size = UDim2.new(1, -20, 0, 45)
                pickerButton.Position = UDim2.new(0, 10, 0, 40)
                pickerButton.BackgroundColor3 = config.darkColor
                pickerButton.Text = ""
                pickerButton.Parent = sectionFrame

                local corner = Instance.new("UICorner")
                corner.CornerRadius = config.cornerRadius
                corner.Parent = pickerButton

                local title = Instance.new("TextLabel")
                title.Name = "Title"
                title.Size = UDim2.new(0.7, 0, 1, 0)
                title.Position = UDim2.new(0, 15, 0, 0)
                title.BackgroundTransparency = 1
                title.Text = name
                title.TextColor3 = config.textColor
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Font = config.font
                title.TextSize = 15
                title.Parent = pickerButton

                local colorIndicator = Instance.new("Frame")
                colorIndicator.Name = "ColorIndicator"
                colorIndicator.Size = UDim2.new(0, 24, 0, 24)
                colorIndicator.Position = UDim2.new(1, -60, 0.5, -12)
                colorIndicator.BackgroundColor3 = value
                colorIndicator.Parent = pickerButton

                local indicatorCorner = Instance.new("UICorner")
                indicatorCorner.CornerRadius = UDim.new(0, 4)
                indicatorCorner.Parent = colorIndicator

                local pickerPanel = Instance.new("Frame")
                pickerPanel.Name = "PickerPanel"
                pickerPanel.Size = UDim2.new(1, -20, 0, 0)
                pickerPanel.Position = UDim2.new(0, 10, 0, 45)
                pickerPanel.BackgroundColor3 = config.lightColor
                pickerPanel.Visible = false
                pickerPanel.Parent = sectionFrame

                local pickerCorner = Instance.new("UICorner")
                pickerCorner.CornerRadius = config.cornerRadius
                pickerCorner.Parent = pickerPanel

                -- Saturation and Value (SV) picker
                local svPicker = Instance.new("Frame")
                svPicker.Name = "SVPicker"
                svPicker.Size = UDim2.new(0, 200, 0, 150)
                svPicker.Position = UDim2.new(0, 10, 0, 10)
                svPicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svPicker.Parent = pickerPanel

                local svCorner = Instance.new("UICorner")
                svCorner.CornerRadius = UDim.new(0, 4)
                svCorner.Parent = svPicker

                local satGradient = Instance.new("UIGradient")
                satGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))
                })
                satGradient.Rotation = 0
                satGradient.Parent = svPicker

                local valGradient = Instance.new("UIGradient")
                valGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                })
                valGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
                valGradient.Rotation = 90
                valGradient.Parent = svPicker

                local svHandle = Instance.new("Frame")
                svHandle.Size = UDim2.new(0, 8, 0, 8)
                svHandle.Position = UDim2.new(s, -4, 1 - v, -4)
                svHandle.BackgroundColor3 = config.textColor
                svHandle.BorderSizePixel = 2
                svHandle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                svHandle.Parent = svPicker

                local svHandleCorner = Instance.new("UICorner")
                svHandleCorner.CornerRadius = UDim.new(1, 0)
                svHandleCorner.Parent = svHandle

                -- Hue picker
                local hueBar = Instance.new("Frame")
                hueBar.Name = "HueBar"
                hueBar.Size = UDim2.new(1, -230, 0, 20)
                hueBar.Position = UDim2.new(0, 220, 0, 10)
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

                local hueHandle = Instance.new("Frame")
                hueHandle.Size = UDim2.new(0, 4, 1, 4)
                hueHandle.Position = UDim2.new(h, -2, 0, -2)
                hueHandle.BackgroundColor3 = config.textColor
                hueHandle.Parent = hueBar

                local hueHandleCorner = Instance.new("UICorner")
                hueHandleCorner.CornerRadius = UDim.new(1, 0)
                hueHandleCorner.Parent = hueHandle

                local draggingHue = false
                local draggingSV = false

                local function updateHue(input)
                    local relativeX = (input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X
                    relativeX = math.clamp(relativeX, 0, 1)
                    h = relativeX
                    value = Color3.fromHSV(h, s, v)
                    svPicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    satGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))
                    })
                    colorIndicator.BackgroundColor3 = value
                    hueHandle.Position = UDim2.new(h, -2, 0, -2)
                    pcall(callback, value)
                end

                local function updateSV(input)
                    local relativeX = (input.Position.X - svPicker.AbsolutePosition.X) / svPicker.AbsoluteSize.X
                    local relativeY = (input.Position.Y - svPicker.AbsolutePosition.Y) / svPicker.AbsoluteSize.Y
                    s = math.clamp(relativeX, 0, 1)
                    v = 1 - math.clamp(relativeY, 0, 1)
                    value = Color3.fromHSV(h, s, v)
                    colorIndicator.BackgroundColor3 = value
                    svHandle.Position = UDim2.new(s, -4, 1 - v, -4)
                    pcall(callback, value)
                end

                hueBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingHue = true
                        updateHue(input)
                    end
                end)

                svPicker.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSV = true
                        updateSV(input)
                    end
                end)

                table.insert(connections, UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingHue = false
                        draggingSV = false
                    end
                end))

                table.insert(connections, UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if draggingHue then
                            updateHue(input)
                        elseif draggingSV then
                            updateSV(input)
                        end
                    end
                end))

                pickerButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    pickerPanel.Visible = isOpen
                    TweenService:Create(pickerPanel, TweenInfo.new(config.animationSpeed), {Size = UDim2.new(1, -20, 0, isOpen and 170 or 0)}):Play()
                end)

                function colorPicker:SetValue(newColor)
                    value = newColor
                    h, s, v = value:ToHSV()
                    colorIndicator.BackgroundColor3 = value
                    hueHandle.Position = UDim2.new(h, -2, 0, -2)
                    svHandle.Position = UDim2.new(s, -4, 1 - v, -4)
                    svPicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    satGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))
                    })
                    pcall(callback, value)
                end

                applyButtonEffects(pickerButton, config.accentColor)

                return colorPicker
            end

            -- TextBox element
            function section:NewTextBox(name, placeholder, callback)
                local textBox = {}
                local value = ""

                local textBoxFrame = Instance.new("Frame")
                textBoxFrame.Name = name
                textBoxFrame.Size = UDim2.new(1, -20, 0, 45)
                textBoxFrame.Position = UDim2.new(0, 10, 0, 40)
                textBoxFrame.BackgroundColor3 = config.darkColor
                textBoxFrame.Parent = sectionFrame

                local corner = Instance.new("UICorner")
                corner.CornerRadius = config.cornerRadius
                corner.Parent = textBoxFrame

                local title = Instance.new("TextLabel")
                title.Name = "Title"
                title.Size = UDim2.new(0.7, 0, 1, 0)
                title.Position = UDim2.new(0, 15, 0, 0)
                title.BackgroundTransparency = 1
                title.Text = name
                title.TextColor3 = config.textColor
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Font = config.font
                title.TextSize = 15
                title.Parent = textBoxFrame

                local inputBox = Instance.new("TextBox")
                inputBox.Size = UDim2.new(0, 100, 0, 24)
                inputBox.Position = UDim2.new(1, -110, 0.5, -12)
                inputBox.BackgroundColor3 = config.lightColor
                inputBox.Text = placeholder or ""
                inputBox.TextColor3 = config.textColor
                inputBox.Font = config.font
                inputBox.TextSize = 14
                inputBox.ClearTextOnFocus = false
                inputBox.Parent = textBoxFrame

                local inputCorner = Instance.new("UICorner")
                inputCorner.CornerRadius = UDim.new(0, 4)
                inputCorner.Parent = inputBox

                inputBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        value = inputBox.Text
                        pcall(callback, value)
                    end
                end)

                function textBox:SetValue(newValue)
                    value = newValue
                    inputBox.Text = value
                    pcall(callback, value)
                end

                return textBox
            end

            -- Dropdown element
            function section:NewDropdown(name, options, defaultOption, callback)
                local dropdown = {}
                local value = defaultOption or options[1]
                local isOpen = false

                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = name
                dropdownButton.Size = UDim2.new(1, -20, 0, 45)
                dropdownButton.Position = UDim2.new(0, 10, 0, 40)
                dropdownButton.BackgroundColor3 = config.darkColor
                dropdownButton.Text = ""
                dropdownButton.Parent = sectionFrame

                local corner = Instance.new("UICorner")
                corner.CornerRadius = config.cornerRadius
                corner.Parent = dropdownButton

                local title = Instance.new("TextLabel")
                title.Name = "Title"
                title.Size = UDim2.new(0.7, 0, 1, 0)
                title.Position = UDim2.new(0, 15, 0, 0)
                title.BackgroundTransparency = 1
                title.Text = name
                title.TextColor3 = config.textColor
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Font = config.font
                title.TextSize = 15
                title.Parent = dropdownButton

                local selectedLabel = Instance.new("TextLabel")
                selectedLabel.Name = "Selected"
                selectedLabel.Size = UDim2.new(0, 100, 0, 24)
                selectedLabel.Position = UDim2.new(1, -110, 0.5, -12)
                selectedLabel.BackgroundColor3 = config.lightColor
                selectedLabel.Text = value
                selectedLabel.TextColor3 = config.textColor
                selectedLabel.Font = config.font
                selectedLabel.TextSize = 14
                selectedLabel.TextXAlignment = Enum.TextXAlignment.Center
                selectedLabel.Parent = dropdownButton

                local selectedCorner = Instance.new("UICorner")
                selectedCorner.CornerRadius = UDim.new(0, 4)
                selectedCorner.Parent = selectedLabel

                local dropdownPanel = Instance.new("Frame")
                dropdownPanel.Name = "DropdownPanel"
                dropdownPanel.Size = UDim2.new(1, -20, 0, 0)
                dropdownPanel.Position = UDim2.new(0, 10, 0, 45)
                dropdownPanel.BackgroundColor3 = config.lightColor
                dropdownPanel.Visible = false
                dropdownPanel.Parent = sectionFrame

                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.CornerRadius = config.cornerRadius
                dropdownCorner.Parent = dropdownPanel

                local dropdownList = Instance.new("ScrollingFrame")
                dropdownList.Size = UDim2.new(1, 0, 1, 0)
                dropdownList.BackgroundTransparency = 1
                dropdownList.ScrollBarThickness = 4
                dropdownList.ScrollBarImageColor3 = config.accentColor
                dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
                dropdownList.Parent = dropdownPanel

                local listLayout = Instance.new("UIListLayout")
                listLayout.Parent = dropdownList
                listLayout.Padding = UDim.new(0, 5)

                listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropdownList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
                end)

                -- Populate dropdown options
                for _, option in ipairs(options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Size = UDim2.new(1, -10, 0, 30)
                    optionButton.BackgroundColor3 = config.darkColor
                    optionButton.Text = tostring(option)
                    optionButton.TextColor3 = config.textColor
                    optionButton.Font = config.font
                    optionButton.TextSize = 14
                    optionButton.Parent = dropdownList

                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = optionButton

                    optionButton.MouseButton1Click:Connect(function()
                        value = option
                        selectedLabel.Text = tostring(value)
                        isOpen = false
                        dropdownPanel.Visible = false
                        TweenService:Create(dropdownPanel, TweenInfo.new(config.animationSpeed), {Size = UDim2.new(1, -20, 0, 0)}):Play()
                        pcall(callback, value)
                    end)

                    optionButton.MouseEnter:Connect(function()
                        TweenService:Create(optionButton, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = config.accentColor}):Play()
                    end)

                    optionButton.MouseLeave:Connect(function()
                        TweenService:Create(optionButton, TweenInfo.new(config.animationSpeed), {BackgroundColor3 = config.darkColor}):Play()
                    end)
                end

                dropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    dropdownPanel.Visible = isOpen
                    local targetHeight = isOpen and math.min(#options * 35, 140) or 0
                    TweenService:Create(dropdownPanel, TweenInfo.new(config.animationSpeed), {Size = UDim2.new(1, -20, 0, targetHeight)}):Play()
                end)

                function dropdown:SetValue(newValue)
                    if table.find(options, newValue) then
                        value = newValue
                        selectedLabel.Text = tostring(value)
                        pcall(callback, value)
                    end
                end

                applyButtonEffects(dropdownButton, config.accentColor)

                return dropdown
            end

            return section
        end

        return tab
    end

    return window
end

return GojoUI

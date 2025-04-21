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
    loadingDuration = 1.5
}

-- Create loading screen
local function CreateLoader()
    local loaderUI = Instance.new("ScreenGui")
    loaderUI.Name = "GojoUILoader"
    loaderUI.Parent = game:GetService("CoreGui")
    loaderUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loaderUI.ResetOnSpawn = false

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
    game:GetService("TweenService"):Create(progressFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)}):Play()

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
            status.Text = text
        end)
    end

    -- Cleanup
    task.delay(config.loadingDuration, function()
        local fadeOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        game:GetService("TweenService"):Create(background, fadeOut, {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        loaderUI:Destroy()
    end)

    return loaderUI
end

-- Create main window
function GojoUI:CreateWindow(title)
    -- Show loading screen
    CreateLoader()
    task.wait(config.loadingDuration)

    local window = {}
    local dragInput, dragStart, startPos
    local tabs = {}
    local notifications = {}

    -- Main UI container
    local ui = Instance.new("ScreenGui")
    ui.Name = "GojoUI"
    ui.Parent = game:GetService("CoreGui")
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ui.ResetOnSpawn = false

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

    -- Drop shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 12, 1, 12)
    shadow.Position = UDim2.new(0, -6, 0, -6)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    shadow.Parent = mainFrame

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
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title
    titleText.TextColor3 = config.textColor
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = config.titleFont
    titleText.TextSize = 18
    titleText.Parent = titleBar

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

    -- Close button effects
    closeButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            closeButton,
            TweenInfo.new(config.animationSpeed),
            {BackgroundColor3 = Color3.fromRGB(255, 120, 120)}
        ):Play()
    end)

    closeButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            closeButton,
            TweenInfo.new(config.animationSpeed),
            {BackgroundColor3 = config.errorColor}
        ):Play()
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)

    -- Window methods
    function window:Notification(title, message, duration)
        duration = duration or 3
        
        local notification = Instance.new("Frame")
        notification.Name = "Notification_"..tostring(#notifications + 1)
        notification.Size = UDim2.new(0, 300, 0, 100)
        notification.Position = UDim2.new(1, -320, 1, -120 - (#notifications * 110))
        notification.BackgroundColor3 = config.darkColor
        notification.Parent = ui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = config.cornerRadius
        corner.Parent = notification

        local shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Size = UDim2.new(1, 12, 1, 12)
        shadow.Position = UDim2.new(0, -6, 0, -6)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://1316045217"
        shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        shadow.ImageTransparency = 0.8
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.ZIndex = -1
        shadow.Parent = notification

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
        messageLabel.Parent = notification

        table.insert(notifications, notification)

        -- Animate in
        notification.Position = UDim2.new(1, 20, 1, -120 - (#notifications * 110))
        game:GetService("TweenService"):Create(
            notification,
            TweenInfo.new(0.3),
            {Position = UDim2.new(1, -320, 1, -120 - (#notifications * 110))}
        ):Play()

        -- Auto remove after duration
        task.delay(duration, function()
            game:GetService("TweenService"):Create(
                notification,
                TweenInfo.new(0.3),
                {Position = UDim2.new(1, 20, notification.Position.Y.Scale, notification.Position.Y.Offset)}
            ):Play()
            task.wait(0.3)
            notification:Destroy()
            table.remove(notifications, table.find(notifications, notification))
            
            -- Update positions of remaining notifications
            for i, notif in ipairs(notifications) do
                notif.Position = UDim2.new(1, -320, 1, -120 - (i * 110))
            end
        end)
    end

    function window:Destroy()
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
        tabContent.Parent = contentContainer

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Parent = tabContent
        contentLayout.Padding = UDim.new(0, 10)

        -- Tab switching
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tab contents
            for _, child in ipairs(contentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            
            -- Show this tab's content
            tabContent.Visible = true
            
            -- Update tab buttons appearance
            for _, btn in ipairs(tabButtons:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.TextColor3 = config.textColor
                    btn.BackgroundTransparency = 0.5
                end
            end
            
            -- Highlight active tab
            tabButton.TextColor3 = config.accentColor
            tabButton.BackgroundTransparency = 0
            
            -- Play animation
            game:GetService("TweenService"):Create(
                tabButton,
                TweenInfo.new(config.animationSpeed),
                {TextColor3 = config.accentColor, BackgroundTransparency = 0}
            ):Play()
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

            -- Section title
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

            -- Content layout
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

                -- Tooltip for description
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

                -- Hover effects
                button.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(
                        button,
                        TweenInfo.new(config.animationSpeed),
                        {BackgroundColor3 = config.accentColor}
                    ):Play()
                    
                    -- Show tooltip
                    tooltip.Size = UDim2.new(1, -20, 0, 0)
                    tooltip.Visible = true
                    game:GetService("TweenService"):Create(
                        tooltip,
                        TweenInfo.new(config.animationSpeed),
                        {Size = UDim2.new(1, -20, 0, 40)}
                    ):Play()
                end)

                button.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(
                        button,
                        TweenInfo.new(config.animationSpeed),
                        {BackgroundColor3 = config.darkColor}
                    ):Play()
                    
                    -- Hide tooltip
                    game:GetService("TweenService"):Create(
                        tooltip,
                        TweenInfo.new(config.animationSpeed),
                        {Size = UDim2.new(1, -20, 0, 0)}
                    ):Play()
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

                -- Hover effects
                toggleFrame.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(
                        toggleFrame,
                        TweenInfo.new(config.animationSpeed),
                        {BackgroundColor3 = config.accentColor}
                    ):Play()
                end)

                toggleFrame.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(
                        toggleFrame,
                        TweenInfo.new(config.animationSpeed),
                        {BackgroundColor3 = config.darkColor}
                    ):Play()
                end)

                -- Toggle functionality
                toggleFrame.MouseButton1Click:Connect(function()
                    value = not value
                    if value then
                        game:GetService("TweenService"):Create(
                            toggleIndicator,
                            TweenInfo.new(config.animationSpeed),
                            {BackgroundColor3 = config.accentColor}
                        ):Play()
                    else
                        game:GetService("TweenService"):Create(
                            toggleIndicator,
                            TweenInfo.new(config.animationSpeed),
                            {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}
                        ):Play()
                    end
                    pcall(callback, value)
                end)

                -- Set value method
                function toggle:SetValue(newValue)
                    value = newValue
                    if value then
                        toggleIndicator.BackgroundColor3 = config.accentColor
                    else
                        toggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    end
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

                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateValue(input)
                    end
                end)

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

            return section
        end

        return tab
    end

    return window
end

return GojoUI

-- GojoUI Library by DevEx | Inspired by KavoUI with modern design
local GojoUI = {}

-- Color palette
local colors = {
    main = Color3.fromRGB(30, 30, 40),
    accent = Color3.fromRGB(100, 200, 255),
    text = Color3.fromRGB(240, 240, 240),
    hover = Color3.fromRGB(50, 50, 60),
    section = Color3.fromRGB(40, 40, 50),
    close = Color3.fromRGB(255, 80, 80)
}

-- Create main window
function GojoUI:CreateWindow(name)
    local GojoUI = {}
    local dragging = false
    local dragInput, dragStart, startPos
    
    -- Main UI container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GojoUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 600)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    MainFrame.BackgroundColor3 = colors.main
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    -- Shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = MainFrame
    Shadow.ZIndex = -1
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = colors.accent
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = name
    Title.TextColor3 = colors.text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = TitleBar
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
    CloseButton.BackgroundColor3 = colors.close
    CloseButton.Text = "×"
    CloseButton.TextColor3 = colors.text
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseEnter:Connect(function()
        CloseButton.BackgroundColor3 = Color3.fromRGB(255, 120, 120)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CloseButton.BackgroundColor3 = colors.close
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab buttons
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, -20, 0, 40)
    TabButtons.Position = UDim2.new(0, 10, 0, 45)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = TabButtons
    
    -- Content container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -20, 1, -100)
    ContentContainer.Position = UDim2.new(0, 10, 0, 90)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Drag logic
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Window functions
    function GojoUI:Notification(title, text, duration)
        duration = duration or 3
        
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification"
        Notification.Size = UDim2.new(0, 300, 0, 100)
        Notification.Position = UDim2.new(1, -320, 1, -120)
        Notification.BackgroundColor3 = colors.main
        Notification.Parent = ScreenGui
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Notification
        
        local Shadow = Instance.new("ImageLabel")
        Shadow.Name = "Shadow"
        Shadow.Size = UDim2.new(1, 10, 1, 10)
        Shadow.Position = UDim2.new(0, -5, 0, -5)
        Shadow.BackgroundTransparency = 1
        Shadow.Image = "rbxassetid://1316045217"
        Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        Shadow.ImageTransparency = 0.8
        Shadow.ScaleType = Enum.ScaleType.Slice
        Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        Shadow.Parent = Notification
        Shadow.ZIndex = -1
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.Size = UDim2.new(1, -20, 0, 30)
        TitleLabel.Position = UDim2.new(0, 15, 0, 10)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.TextColor3 = colors.accent
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 18
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = Notification
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "Text"
        TextLabel.Size = UDim2.new(1, -20, 0, 50)
        TextLabel.Position = UDim2.new(0, 15, 0, 40)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = text
        TextLabel.TextColor3 = colors.text
        TextLabel.Font = Enum.Font.Gotham
        TextLabel.TextSize = 14
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextYAlignment = Enum.TextYAlignment.Top
        TextLabel.Parent = Notification
        
        task.spawn(function()
            wait(duration)
            Notification:Destroy()
        end)
    end
    
    function GojoUI:Destroy()
        ScreenGui:Destroy()
    end
    
    -- Tab functions
    function GojoUI:NewTab(name)
        local Tab = {}
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.BackgroundColor3 = colors.main
        TabButton.BackgroundTransparency = 0.5
        TabButton.Text = name
        TabButton.TextColor3 = colors.text
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.Parent = TabButtons
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = colors.accent
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.Padding = UDim.new(0, 10)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            TabContent.Visible = true
            
            for _, btn in ipairs(TabButtons:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.TextColor3 = colors.text
                    btn.BackgroundTransparency = 0.5
                end
            end
            TabButton.TextColor3 = colors.accent
            TabButton.BackgroundTransparency = 0
        end)
        
        -- Activate first tab
        if #TabButtons:GetChildren() == 1 then
            TabButton.TextColor3 = colors.accent
            TabButton.BackgroundTransparency = 0
            TabContent.Visible = true
        end
        
        -- Section functions
        function Tab:NewSection(name)
            local Section = {}
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.BackgroundColor3 = colors.section
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 8)
            Corner.Parent = SectionFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -20, 0, 40)
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = name
            SectionTitle.TextColor3 = colors.accent
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextSize = 16
            SectionTitle.Parent = SectionFrame
            
            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Parent = SectionFrame
            ContentLayout.Padding = UDim.new(0, 10)
            
            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 50)
            end)
            
            -- Button element
            function Section:NewButton(name, desc, callback)
                local Button = Instance.new("TextButton")
                Button.Name = name
                Button.Size = UDim2.new(1, -20, 0, 40)
                Button.Position = UDim2.new(0, 10, 0, 40)
                Button.BackgroundColor3 = colors.main
                Button.Text = name
                Button.TextColor3 = colors.text
                Button.Font = Enum.Font.Gotham
                Button.TextSize = 14
                Button.Parent = SectionFrame
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = Button
                
                -- Hover effects
                Button.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(
                        Button,
                        TweenInfo.new(0.2),
                        {BackgroundColor3 = colors.hover}
                    ):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(
                        Button,
                        TweenInfo.new(0.2),
                        {BackgroundColor3 = colors.main}
                    ):Play()
                end)
                
                Button.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)
                
                return Button
            end
            
            -- Toggle element
            function Section:NewToggle(name, desc, callback)
                local Toggle = {}
                local value = false
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = name
                ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
                ToggleFrame.Position = UDim2.new(0, 10, 0, 0)
                ToggleFrame.BackgroundColor3 = colors.main
                ToggleFrame.Parent = SectionFrame
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = ToggleFrame
                
                local Title = Instance.new("TextLabel")
                Title.Name = "Title"
                Title.Size = UDim2.new(0.7, 0, 1, 0)
                Title.Position = UDim2.new(0, 15, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = name
                Title.TextColor3 = colors.text
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Font = Enum.Font.Gotham
                Title.TextSize = 14
                Title.Parent = ToggleFrame
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "Indicator"
                ToggleIndicator.Size = UDim2.new(0, 24, 0, 24)
                ToggleIndicator.Position = UDim2.new(1, -30, 0.5, -12)
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                ToggleIndicator.Parent = ToggleFrame
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(1, 0)
                Corner.Parent = ToggleIndicator
                
                -- Hover effects
                ToggleFrame.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(
                        ToggleFrame,
                        TweenInfo.new(0.2),
                        {BackgroundColor3 = colors.hover}
                    ):Play()
                end)
                
                ToggleFrame.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(
                        ToggleFrame,
                        TweenInfo.new(0.2),
                        {BackgroundColor3 = colors.main}
                    ):Play()
                end)
                
                ToggleFrame.MouseButton1Click:Connect(function()
                    value = not value
                    if value then
                        game:GetService("TweenService"):Create(
                            ToggleIndicator,
                            TweenInfo.new(0.2),
                            {BackgroundColor3 = colors.accent}
                        ):Play()
                    else
                        game:GetService("TweenService"):Create(
                            ToggleIndicator,
                            TweenInfo.new(0.2),
                            {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}
                        ):Play()
                    end
                    pcall(callback, value)
                end)
                
                function Toggle:SetValue(newValue)
                    value = newValue
                    if value then
                        ToggleIndicator.BackgroundColor3 = colors.accent
                    else
                        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    end
                    pcall(callback, value)
                end
                
                return Toggle
            end
            
            -- Label element
            function Section:NewLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.Size = UDim2.new(1, -20, 0, 20)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = colors.text
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.Parent = SectionFrame
                
                function Label:Update(newText)
                    Label.Text = newText
                end
                
                return Label
            end
            
            -- Slider element
            function Section:NewSlider(name, min, max, default, callback)
                local Slider = {}
                local value = default or min
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = name
                SliderFrame.Size = UDim2.new(1, -20, 0, 60)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = SectionFrame
                
                local Title = Instance.new("TextLabel")
                Title.Name = "Title"
                Title.Size = UDim2.new(1, 0, 0, 20)
                Title.BackgroundTransparency = 1
                Title.Text = name
                Title.TextColor3 = colors.text
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Font = Enum.Font.Gotham
                Title.TextSize = 14
                Title.Parent = SliderFrame
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Name = "Value"
                ValueLabel.Size = UDim2.new(0, 60, 0, 20)
                ValueLabel.Position = UDim2.new(1, -60, 0, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(value)
                ValueLabel.TextColor3 = colors.accent
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.TextSize = 14
                ValueLabel.Parent = SliderFrame
                
                local Track = Instance.new("Frame")
                Track.Name = "Track"
                Track.Size = UDim2.new(1, 0, 0, 4)
                Track.Position = UDim2.new(0, 0, 0, 30)
                Track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                Track.Parent = SliderFrame
                
                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = Track
                
                local Fill = Instance.new("Frame")
                Fill.Name = "Fill"
                Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = colors.accent
                Fill.Parent = Track
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = Fill
                
                local Handle = Instance.new("TextButton")
                Handle.Name = "Handle"
                Handle.Size = UDim2.new(0, 16, 0, 16)
                Handle.Position = UDim2.new(Fill.Size.X.Scale, -8, 0.5, -8)
                Handle.BackgroundColor3 = colors.text
                Handle.Text = ""
                Handle.Parent = Track
                
                local HandleCorner = Instance.new("UICorner")
                HandleCorner.CornerRadius = UDim.new(1, 0)
                HandleCorner.Parent = Handle
                
                local dragging = false
                
                local function updateValue(input)
                    local relativeX = (input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X
                    relativeX = math.clamp(relativeX, 0, 1)
                    value = math.floor(min + (max - min) * relativeX)
                    ValueLabel.Text = tostring(value)
                    Fill.Size = UDim2.new(relativeX, 0, 1, 0)
                    Handle.Position = UDim2.new(relativeX, -8, 0.5, -8)
                    pcall(callback, value)
                end
                
                Handle.MouseButton1Down:Connect(function()
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
                
                Track.MouseButton1Down:Connect(function(input)
                    updateValue(input)
                end)
                
                function Slider:SetValue(newValue)
                    value = math.clamp(newValue, min, max)
                    local relativeX = (value - min) / (max - min)
                    ValueLabel.Text = tostring(value)
                    Fill.Size = UDim2.new(relativeX, 0, 1, 0)
                    Handle.Position = UDim2.new(relativeX, -8, 0.5, -8)
                    pcall(callback, value)
                end
                
                return Slider
            end
            
            return Section
        end
        
        return Tab
    end
    
    return GojoUI
end

return GojoUI

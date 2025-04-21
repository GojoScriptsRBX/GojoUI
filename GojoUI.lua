-- Rainbow UI Library by DevEx (вдохновлено KavoUI)
local RainbowUI = {}

-- Цветовая палитра
local colors = {
    main = Color3.fromRGB(45, 45, 45),
    accent = Color3.fromRGB(0, 170, 255),
    text = Color3.fromRGB(255, 255, 255),
    hover = Color3.fromRGB(60, 60, 60),
    section = Color3.fromRGB(35, 35, 35)
}

-- Создание главного окна
function RainbowUI:CreateWindow(name)
    local RainbowUI = {}
    local dragging = false
    local dragInput, dragStart, startPos
    
    -- Основное окно
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RainbowUI"
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
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = MainFrame
    
    -- Заголовок окна
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = colors.accent
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = name
    Title.TextColor3 = colors.text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = TitleBar
    
    -- Вкладки
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, 0, 0, 40)
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Parent = TabButtons
    
    -- Контейнер для контента
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -20, 1, -100)
    ContentContainer.Position = UDim2.new(0, 10, 0, 90)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Drag логика
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
    
    -- Функции
    function RainbowUI:NewTab(name)
        local Tab = {}
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.BackgroundColor3 = colors.main
        TabButton.BackgroundTransparency = 1
        TabButton.Text = name
        TabButton.TextColor3 = colors.text
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.Parent = TabButtons
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
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
                    btn.BackgroundTransparency = 1
                end
            end
            TabButton.TextColor3 = colors.accent
        end)
        
        -- Активируем первую вкладку
        if #TabButtons:GetChildren() == 1 then
            TabButton.TextColor3 = colors.accent
            TabContent.Visible = true
        end
        
        function Tab:NewSection(name)
            local Section = {}
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.BackgroundColor3 = colors.section
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = SectionFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -20, 0, 30)
            SectionTitle.Position = UDim2.new(0, 10, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = name
            SectionTitle.TextColor3 = colors.text
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextSize = 16
            SectionTitle.Parent = SectionFrame
            
            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Parent = SectionFrame
            ContentLayout.Padding = UDim.new(0, 10)
            
            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 40)
            end)
            
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
                Corner.CornerRadius = UDim.new(0, 4)
                Corner.Parent = Button
                
                Button.MouseEnter:Connect(function()
                    Button.BackgroundColor3 = colors.hover
                end)
                
                Button.MouseLeave:Connect(function()
                    Button.BackgroundColor3 = colors.main
                end)
                
                Button.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)
            end
            
            function Section:NewToggle(name, desc, callback)
                local Toggle = {}
                local value = false
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = name
                ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
                ToggleFrame.Position = UDim2.new(0, 10, 0, 0)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = SectionFrame
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Button"
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.BackgroundColor3 = colors.main
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 4)
                Corner.Parent = ToggleButton
                
                local Title = Instance.new("TextLabel")
                Title.Name = "Title"
                Title.Size = UDim2.new(0.7, 0, 1, 0)
                Title.Position = UDim2.new(0, 10, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = name
                Title.TextColor3 = colors.text
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Font = Enum.Font.Gotham
                Title.TextSize = 14
                Title.Parent = ToggleFrame
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "Indicator"
                ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
                ToggleIndicator.Position = UDim2.new(1, -30, 0.5, -10)
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                ToggleIndicator.Parent = ToggleFrame
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(1, 0)
                Corner.Parent = ToggleIndicator
                
                ToggleButton.MouseEnter:Connect(function()
                    ToggleButton.BackgroundColor3 = colors.hover
                end)
                
                ToggleButton.MouseLeave:Connect(function()
                    ToggleButton.BackgroundColor3 = colors.main
                end)
                
                ToggleButton.MouseButton1Click:Connect(function()
                    value = not value
                    if value then
                        ToggleIndicator.BackgroundColor3 = colors.accent
                    else
                        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
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
            
            return Section
        end
        
        return Tab
    end
    
    function RainbowUI:Notification(title, text, duration)
        duration = duration or 5
        
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification"
        Notification.Size = UDim2.new(0, 300, 0, 80)
        Notification.Position = UDim2.new(1, -320, 1, -100)
        Notification.BackgroundColor3 = colors.main
        Notification.Parent = ScreenGui
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Notification
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.Size = UDim2.new(1, -20, 0, 30)
        TitleLabel.Position = UDim2.new(0, 10, 0, 5)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.TextColor3 = colors.accent
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 16
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = Notification
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "Text"
        TextLabel.Size = UDim2.new(1, -20, 1, -40)
        TextLabel.Position = UDim2.new(0, 10, 0, 30)
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
    
    return RainbowUI
end

return RainbowUI

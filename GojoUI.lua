-- GojoUI Library for Roblox Injectors
-- Minimalistic, functional UI library with animations, inspired by Kavo UI
-- Features: Tabs, Dropdowns, Sliders, Color Picker, Sections, Enhanced Toggles, Loading Screen
local GojoUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Core UI Setup
local function createScreenGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "GojoUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	return screenGui
end

-- Tween Animation Helper
local function createTween(instance, properties, duration, easingStyle, easingDirection)
	local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	return tween
end

-- Loading Screen
local function createLoadingScreen()
	local screenGui = createScreenGui()
	local loadingFrame = Instance.new("Frame")
	local corner = Instance.new("UICorner")
	local progressBar = Instance.new("Frame")
	local progressFill = Instance.new("Frame")
	local progressCorner = Instance.new("UICorner")
	local loadingText = Instance.new("TextLabel")

	loadingFrame.Size = UDim2.new(0, 300, 0, 100)
	loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
	loadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	loadingFrame.Parent = screenGui
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = loadingFrame

	progressBar.Size = UDim2.new(0.9, 0, 0, 20)
	progressBar.Position = UDim2.new(0.05, 0, 0.7, 0)
	progressBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	progressBar.Parent = loadingFrame
	progressCorner.CornerRadius = UDim.new(0, 5)
	progressCorner.Parent = progressBar

	progressFill.Size = UDim2.new(0, 0, 1, 0)
	progressFill.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
	progressFill.Parent = progressBar
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 5)
	fillCorner.Parent = progressFill

	loadingText.Size = UDim2.new(1, 0, 0, 40)
	loadingText.Position = UDim2.new(0, 0, 0.2, 0)
	loadingText.BackgroundTransparency = 1
	loadingText.Text = "Loading GojoUI..."
	loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
	loadingText.TextSize = 16
	loadingText.Font = Enum.Font.GothamBold
	loadingText.Parent = loadingFrame

	-- Animate Progress Bar
	local function animateLoading()
		createTween(progressFill, {Size = UDim2.new(1, 0, 1, 0)}, 2).Completed:Connect(function()
			createTween(loadingFrame, {BackgroundTransparency = 1, Size = UDim2.new(0, 300, 0, 0)}, 0.5).Completed:Connect(function()
				screenGui:Destroy()
			end)
			progressBar.BackgroundTransparency = 1
			progressFill.BackgroundTransparency = 1
			loadingText.TextTransparency = 1
		end)
	end
	animateLoading()
end

-- Main Library Function
function GojoUI:CreateWindow(title)
	-- Create a loading screen before showing the main window
	createLoadingScreen()

	local screenGui = createScreenGui()
	local window = Instance.new("Frame")
	local corner = Instance.new("UICorner")
	local titleBar = Instance.new("Frame")
	local titleText = Instance.new("TextLabel")
	local closeButton = Instance.new("TextButton")
	local tabFrame = Instance.new("Frame")
	local tabLayout = Instance.new("UIListLayout")
	local contentFrame = Instance.new("Frame")

	-- Window Setup
	-- Description: Creates the main window with a title bar and tabbed interface
	window.Name = "GojoWindow"
	window.Size = UDim2.new(0, 400, 0, 500)
	window.Position = UDim2.new(0.5, -200, 0.5, -250)
	window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	window.BorderSizePixel = 0
	window.ClipsDescendants = true
	window.Parent = screenGui
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = window

	-- Title Bar
	-- Description: Contains the window title and close button
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 30)
	titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = window
	local titleBarCorner = Instance.new("UICorner")
	titleBarCorner.CornerRadius = UDim.new(0, 8)
	titleBarCorner.Parent = titleBar

	-- Title Text
	titleText.Name = "TitleText"
	titleText.Size = UDim2.new(0.8, 0, 1, 0)
	titleText.Position = UDim2.new(0.05, 0, 0, 0)
	titleText.BackgroundTransparency = 1
	titleText.Text = title or "GojoUI"
	titleText.TextColor3 = Color3.fromRGB(200, 200, 200)
	titleText.TextSize = 14
	titleText.Font = Enum.Font.GothamBold
	titleText.TextXAlignment = Enum.TextXAlignment.Left
	titleText.Parent = titleBar

	-- Close Button
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -30, 0, 0)
	closeButton.BackgroundTransparency = 1
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.fromRGB(255, 80, 80)
	closeButton.TextSize = 14
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = titleBar

	-- Tab Frame
	-- Description: Holds tab buttons horizontally
	tabFrame.Name = "TabFrame"
	tabFrame.Size = UDim2.new(1, 0, 0, 30)
	tabFrame.Position = UDim2.new(0, 0, 0, 30)
	tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	tabFrame.BorderSizePixel = 0
	tabFrame.Parent = window
	tabLayout.Name = "TabLayout"
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0, 5)
	tabLayout.Parent = tabFrame

	-- Content Frame
	-- Description: Holds the content of the active tab
	contentFrame.Name = "ContentFrame"
	contentFrame.Size = UDim2.new(1, -10, 1, -70)
	contentFrame.Position = UDim2.new(0, 5, 0, 65)
	contentFrame.BackgroundTransparency = 1
	contentFrame.ClipsDescendants = true
	contentFrame.Parent = window

	-- Dragging Functionality
	local dragging, dragInput, dragStart, startPos
	local function updateInput(input)
		local delta = input.Position - dragStart
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		createTween(window, {Position = newPos}, 0.1)
	end

	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = window.Position
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

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			updateInput(input)
		end
	end)

	-- Close Button Functionality
	closeButton.MouseButton1Click:Connect(function()
		createTween(window, {Size = UDim2.new(0, 400, 0, 0)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Connect(function()
			screenGui:Destroy()
		end)
	end)

	-- Window Animation
	window.Size = UDim2.new(0, 400, 0, 0)
	createTween(window, {Size = UDim2.new(0, 400, 0, 500)}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Window API
	local windowAPI = {}
	local tabs = {}
	local activeTab = nil

	function windowAPI:CreateTab(name)
		-- Description: Creates a new tab with a button and content frame
		local tabButton = Instance.new("TextButton")
		local tabContent = Instance.new("Frame")
		local tabLayout = Instance.new("UIListLayout")

		tabButton.Name = name .. "Tab"
		tabButton.Size = UDim2.new(0, 100, 1, 0)
		tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		tabButton.BorderSizePixel = 0
		tabButton.Text = name
		tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		tabButton.TextSize = 12
		tabButton.Font = Enum.Font.Gotham
		tabButton.Parent = tabFrame
		local tabButtonCorner = Instance.new("UICorner")
		tabButtonCorner.CornerRadius = UDim.new(0, 5)
		tabButtonCorner.Parent = tabButton

		tabContent.Name = name .. "Content"
		tabContent.Size = UDim2.new(1, 0, 1, 0)
		tabContent.BackgroundTransparency = 1
		tabContent.Visible = false
		tabContent.Parent = contentFrame

		tabLayout.Name = "TabLayout"
		tabLayout.Padding = UDim.new(0, 5)
		tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
		tabLayout.Parent = tabContent

		local function setActive()
			if activeTab then
				activeTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				activeTab.Content.Visible = false
			end
			activeTab = {Button = tabButton, Content = tabContent}
			tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			tabContent.Visible = true
		end

		tabButton.MouseButton1Click:Connect(setActive)
		if not activeTab then
			setActive()
		end

		local tabAPI = {}

		function tabAPI:CreateSection(name)
			-- Description: Creates a section (subcategory) within a tab
			local sectionFrame = Instance.new("Frame")
			local sectionTitle = Instance.new("TextLabel")
			local sectionContent = Instance.new("Frame")
			local sectionLayout = Instance.new("UIListLayout")

			sectionFrame.Name = name .. "Section"
			sectionFrame.Size = UDim2.new(1, 0, 0, 0)
			sectionFrame.BackgroundTransparency = 1
			sectionFrame.Parent = tabContent
			sectionFrame.SizeConstraint = Enum.SizeConstraint.RelativeXX

			sectionTitle.Name = "SectionTitle"
			sectionTitle.Size = UDim2.new(1, 0, 0, 20)
			sectionTitle.BackgroundTransparency = 1
			sectionTitle.Text = name
			sectionTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
			sectionTitle.TextSize = 12
			sectionTitle.Font = Enum.Font.GothamBold
			sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			sectionTitle.Parent = sectionFrame

			sectionContent.Name = "SectionContent"
			sectionContent.Size = UDim2.new(1, -10, 0, 0)
			sectionContent.Position = UDim2.new(0, 5, 0, 25)
			sectionContent.BackgroundTransparency = 1
			sectionContent.Parent = sectionFrame

			sectionLayout.Name = "SectionLayout"
			sectionLayout.Padding = UDim.new(0, 5)
			sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
			sectionLayout.Parent = sectionContent

			-- Auto-resize section
			local function updateSectionSize()
				local height = sectionLayout.AbsoluteContentSize.Y + 30
				sectionFrame.Size = UDim2.new(1, 0, 0, height)
			end
			sectionLayout.Changed:Connect(updateSectionSize)

			local sectionAPI = {}

			function sectionAPI:CreateButton(text, callback)
				-- Description: Creates a button with a callback function
				local button = Instance.new("TextButton")
				local buttonCorner = Instance.new("UICorner")
				button.Name = "Button"
				button.Size = UDim2.new(1, 0, 0, 30)
				button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				button.BorderSizePixel = 0
				button.Text = text or "Button"
				button.TextColor3 = Color3.fromRGB(200, 200, 200)
				button.TextSize = 12
				button.Font = Enum.Font.Gotham
				button.Parent = sectionContent
				buttonCorner.CornerRadius = UDim.new(0, 5)
				buttonCorner.Parent = button

				button.MouseEnter:Connect(function()
					createTween(button, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
				end)
				button.MouseLeave:Connect(function()
					createTween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
				end)

				button.MouseButton1Click:Connect(function()
					if callback then
						callback()
					end
				end)

				updateSectionSize()
				return button
			end

			function sectionAPI:CreateTextBox(placeholder, callback)
				-- Description: Creates a text box that returns input text via callback
				local textBox = Instance.new("TextBox")
				local textBoxCorner = Instance.new("UICorner")
				textBox.Name = "TextBox"
				textBox.Size = UDim2.new(1, 0, 0, 30)
				textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				textBox.BorderSizePixel = 0
				textBox.Text = ""
				textBox.PlaceholderText = placeholder or "Enter text..."
				textBox.TextColor3 = Color3.fromRGB(200, 200, 200)
				textBox.TextSize = 12
				textBox.Font = Enum.Font.Gotham
				textBox.Parent = sectionContent
				textBoxCorner.CornerRadius = UDim.new(0, 5)
				textBoxCorner.Parent = textBox

				textBox.Focused:Connect(function()
					createTween(textBox, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
				end)
				textBox.FocusLost:Connect(function()
					createTween(textBox, { BackgroundColor3 = Color3.fromRGB(45, 45, 45) }, 0.2)
					if callback then
						callback(textBox.Text)
					end
				end)

				updateSectionSize()
				return textBox
			end

			function sectionAPI:CreateToggle(text, default, callback)
				-- Description: Creates an enhanced toggle with animated switch
				local toggleFrame = Instance.new("Frame")
				local toggleLabel = Instance.new("TextLabel")
				local toggleSwitch = Instance.new("Frame")
				local toggleKnob = Instance.new("Frame")
				local knobCorner = Instance.new("UICorner")
				local toggleState = default or false

				toggleFrame.Name = "Toggle"
				toggleFrame.Size = UDim2.new(1, 0, 0, 30)
				toggleFrame.BackgroundTransparency = 1
				toggleFrame.Parent = sectionContent

				toggleLabel.Name = "ToggleLabel"
				toggleLabel.Size = UDim2.new(0.8, 0, 1, 0)
				toggleLabel.BackgroundTransparency = 1
				toggleLabel.Text = text or "Toggle"
				toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
				toggleLabel.TextSize = 12
				toggleLabel.Font = Enum.Font.Gotham
				toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
				toggleLabel.Parent = toggleFrame

				toggleSwitch.Name = "ToggleSwitch"
				toggleSwitch.Size = UDim2.new(0, 40, 0, 20)
				toggleSwitch.Position = UDim2.new(1, -40, 0.5, -10)
				toggleSwitch.BackgroundColor3 = toggleState and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
				toggleSwitch.Parent = toggleFrame
				local switchCorner = Instance.new("UICorner")
				switchCorner.CornerRadius = UDim.new(0, 10)
				switchCorner.Parent = toggleSwitch

				toggleKnob.Name = "ToggleKnob"
				toggleKnob.Size = UDim2.new(0, 16, 0, 16)
				toggleKnob.Position = toggleState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
				toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				toggleKnob.Parent = toggleSwitch
				knobCorner.CornerRadius = UDim.new(0, 8)
				knobCorner.Parent = toggleKnob

				toggleSwitch.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						toggleState = not toggleState
						createTween(toggleSwitch, {BackgroundColor3 = toggleState and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)}, 0.2)
						createTween(toggleKnob, {Position = toggleState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
						if callback then
							callback(toggleState)
						end
					end
				end)

				updateSectionSize()
				return toggleFrame
			end

			function sectionAPI:CreateDropdown(text, options, callback)
				-- Description: Creates a dropdown menu with selectable options
				local dropdownFrame = Instance.new("Frame")
				local dropdownButton = Instance.new("TextButton")
				local dropdownCorner = Instance.new("UICorner")
				local dropdownList = Instance.new("Frame")
				local listLayout = Instance.new("UIListLayout")
				local isOpen = false

				dropdownFrame.Name = "Dropdown"
				dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
				dropdownFrame.BackgroundTransparency = 1
				dropdownFrame.Parent = sectionContent

				dropdownButton.Name = "DropdownButton"
				dropdownButton.Size = UDim2.new(1, 0, 0, 30)
				dropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				dropdownButton.BorderSizePixel = 0
				dropdownButton.Text = text or "Select..."
				dropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
				dropdownButton.TextSize = 12
				dropdownButton.Font = Enum.Font.Gotham
				dropdownButton.Parent = dropdownFrame
				dropdownCorner.CornerRadius = UDim.new(0, 5)
				dropdownCorner.Parent = dropdownButton

				dropdownList.Name = "DropdownList"
				dropdownList.Size = UDim2.new(1, 0, 0, 0)
				dropdownList.Position = UDim2.new(0, 0, 0, 35)
				dropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				dropdownList.BorderSizePixel = 0
				dropdownList.ClipsDescendants = true
				dropdownList.Visible = false
				dropdownList.Parent = dropdownFrame
				local listCorner = Instance.new("UICorner")
				listCorner.CornerRadius = UDim.new(0, 5)
				listCorner.Parent = dropdownList

				listLayout.Name = "ListLayout"
				listLayout.Padding = UDim.new(0, 2)
				listLayout.SortOrder = Enum.SortOrder.LayoutOrder
				listLayout.Parent = dropdownList

				local function toggleDropdown()
					isOpen = not isOpen
					dropdownList.Visible = isOpen
					local height = isOpen and (math.min(#options * 30, 120)) or 0
					createTween(dropdownList, {Size = UDim2.new(1, 0, 0, height)}, 0.3)
					updateSectionSize()
				end

				for _, option in ipairs(options) do
					local optionButton = Instance.new("TextButton")
					optionButton.Size = UDim2.new(1, 0, 0, 30)
					optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
					optionButton.BorderSizePixel = 0
					optionButton.Text = tostring(option)
					optionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
					optionButton.TextSize = 12
					optionButton.Font = Enum.Font.Gotham
					optionButton.Parent = dropdownList

					optionButton.MouseEnter:Connect(function()
						createTween(optionButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
					end)
					optionButton.MouseLeave:Connect(function()
						createTween(optionButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
					end)

					optionButton.MouseButton1Click:Connect(function()
						dropdownButton.Text = tostring(option)
						toggleDropdown()
						if callback then
							callback(option)
						end
					end)
				end

				dropdownButton.MouseButton1Click:Connect(toggleDropdown)
				updateSectionSize()
				return dropdownFrame
			end

			function sectionAPI:CreateSlider(text, min, max, default, callback)
				-- Description: Creates a slider for selecting a value within a range
				local sliderFrame = Instance.new("Frame")
				local sliderLabel = Instance.new("TextLabel")
				local sliderBar = Instance.new("Frame")
				local sliderFill = Instance.new("Frame")
				local sliderKnob = Instance.new("Frame")
				local knobCorner = Instance.new("UICorner")
				local valueLabel = Instance.new("TextLabel")
				local currentValue = default or min

				sliderFrame.Name = "Slider"
				sliderFrame.Size = UDim2.new(1, 0, 0, 40)
				sliderFrame.BackgroundTransparency = 1
				sliderFrame.Parent = sectionContent

				sliderLabel.Name = "SliderLabel"
				sliderLabel.Size = UDim2.new(0.8, 0, 0, 20)
				sliderLabel.BackgroundTransparency = 1
				sliderLabel.Text = text or "Slider"
				sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
				sliderLabel.TextSize = 12
				sliderLabel.Font = Enum.Font.Gotham
				sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
				sliderLabel.Parent = sliderFrame

				sliderBar.Name = "SliderBar"
				sliderBar.Size = UDim2.new(1, 0, 0, 10)
				sliderBar.Position = UDim2.new(0, 0, 0, 25)
				sliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				sliderBar.Parent = sliderFrame
				local barCorner = Instance.new("UICorner")
				barCorner.CornerRadius = UDim.new(0, 5)
				barCorner.Parent = sliderBar

				sliderFill.Name = "SliderFill"
				sliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
				sliderFill.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
				sliderFill.Parent = sliderBar
				local fillCorner = Instance.new("UICorner")
				fillCorner.CornerRadius = UDim.new(0, 5)
				fillCorner.Parent = sliderFill

				sliderKnob.Name = "SliderKnob"
				sliderKnob.Size = UDim2.new(0, 16, 0, 16)
				sliderKnob.Position = UDim2.new((currentValue - min) / (max - min), -8, 0.5, -8)
				sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				sliderKnob.Parent = sliderBar
				knobCorner.CornerRadius = UDim.new(0, 8)
				knobCorner.Parent = sliderKnob

				valueLabel.Name = "ValueLabel"
				valueLabel.Size = UDim2.new(0, 40, 0, 20)
				valueLabel.Position = UDim2rnaew(1, -40, 0, 0)
				valueLabel.BackgroundTransparency = 1
				valueLabel.Text = tostring(currentValue)
				valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
				valueLabel.TextSize = 12
				valueLabel.Font = Enum.Font.Gotham
				valueLabel.Parent = sliderFrame

				local draggingSlider = false
				sliderBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingSlider = true
					end
				end)

				sliderBar.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingSlider = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
						local mousePos = input.Position.X
						local barPos = sliderBar.AbsolutePosition.X
						local barWidth = sliderBar.AbsoluteSize.X
						local relativePos = math.clamp((mousePos - barPos) / barWidth, 0, 1)
						currentValue = math.floor(min + (max - min) * relativePos)
						createTween(sliderFill, {Size = UDim2.new(relativePos, 0, 1, 0)}, 0.1)
						createTween(sliderKnob, {Position = UDim2.new(relativePos, -8, 0.5, -8)}, 0.1)
						valueLabel.Text = tostring(currentValue)
						if callback then
							callback(currentValue)
						end
					end
				end)

				updateSectionSize()
				return sliderFrame
			end

			function sectionAPI:CreateColorPicker(text, defaultColor, callback)
				-- Description: Creates a color picker with a simple RGB interface
				local colorPickerFrame = Instance.new("Frame")
				local colorLabel = Instance.new("TextLabel")
				local colorPreview = Instance.new("Frame")
				local colorButton = Instance.new("TextButton")
				local pickerFrame = Instance.new("Frame")
				local rSlider = Instance.new("Frame")
				local gSlider = Instance.new("Frame")
				local bSlider = Instance.new("Frame")
				local isOpen = false
				local currentColor = defaultColor or Color3.fromRGB(255, 255, 255)

				colorPickerFrame.Name = "ColorPicker"
				colorPickerFrame.Size = UDim2.new(1, 0, 0, 30)
				colorPickerFrame.BackgroundTransparency = 1
				colorPickerFrame.Parent = sectionContent

				colorLabel.Name = "ColorLabel"
				colorLabel.Size = UDim2.new(0.8, 0, 1, 0)
				colorLabel.BackgroundTransparency = 1
				colorLabel.Text = text or "Color Picker"
				colorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
				colorLabel.TextSize = 12
				colorLabel.Font = Enum.Font.Gotham
				colorLabel.TextXAlignment = Enum.TextXAlignment.Left
				colorLabel.Parent = colorPickerFrame

				colorPreview.Name = "ColorPreview"
				colorPreview.Size = UDim2.new(0, 30, 0, 20)
				colorPreview.Position = UDim2.new(1, -40, 0.5, -10)
				colorPreview.BackgroundColor3 = currentColor
				colorPreview.Parent = colorPickerFrame
				local previewCorner = Instance.new("UICorner")
				previewCorner.CornerRadius = UDim.new(0, 5)
				previewCorner.Parent = colorPreview

				colorButton.Name = "ColorButton"
				colorButton.Size = UDim2.new(0, 30, 0, 20)
				colorButton.Position = UDim2.new(1, -40, 0.5, -10)
				colorButton.BackgroundTransparency = 1
				colorButton.Text = ""
				colorButton.Parent = colorPickerFrame

				pickerFrame.Name = "PickerFrame"
				pickerFrame.Size = UDim2.new(1, 0, 0, 0)
				pickerFrame.Position = UDim2.new(0, 0, 0, 35)
				pickerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				pickerFrame.Visible = false
				pickerFrame.Parent = colorPickerFrame
				local pickerCorner = Instance.new("UICorner")
				pickerCorner.CornerRadius = UDim.new(0, 5)
				pickerCorner.Parent = pickerFrame

				local function createSlider(color, posY, label)
					local sliderFrame = Instance.new("Frame")
					local sliderLabel = Instance.new("TextLabel")
					local sliderBar = Instance.new("Frame")
					local sliderFill = Instance.new("Frame")
					local value = color * 255

					sliderFrame.Size = UDim2.new(1, 0, 0, 30)
					sliderFrame.Position = UDim2.new(0, 0, 0, posY)
					sliderFrame.BackgroundTransparency = 1
					sliderFrame.Parent = pickerFrame

					sliderLabel.Size = UDim2.new(0, 20, 1, 0)
					sliderLabel.BackgroundTransparency = 1
					sliderLabel.Text = label
					sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
					sliderLabel.TextSize = 12
					sliderLabel.Font = Enum.Font.Gotham
					sliderLabel.Parent = sliderFrame

					sliderBar.Size = UDim2.new(0.8, 0, 0, 10)
					sliderBar.Position = UDim2.new(0.1, 0, 0.5, -5)
					sliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
					sliderBar.Parent = sliderFrame
					local barCorner = Instance.new("UICorner")
					barCorner.CornerRadius = UDim.new(0, 5)
					barCorner.Parent = sliderBar

					sliderFill.Size = UDim2.new(value / 255, 0, 1, 0)
					sliderFill.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
					sliderFill.Parent = sliderBar
					local fillCorner = Instance.new("UICorner")
					fillCorner.CornerRadius = UDim.new(0, 5)
					fillCorner.Parent = sliderFill

					local draggingSlider = false
					sliderBar.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							draggingSlider = true
						end
					end)

					sliderBar.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							draggingSlider = false
						end
					end)

					UserInputService.InputChanged:Connect(function(input)
						if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
							local mousePos = input.Position.X
							local barPos = sliderBar.AbsolutePosition.X
							local barWidth = sliderBar.AbsoluteSize.X
							local relativePos = math.clamp((mousePos - barPos) / barWidth, 0, 1)
							value = math.floor(255 * relativePos)
							createTween(sliderFill, {Size = UDim2.new(relativePos, 0, 1, 0)}, 0.1)
							currentColor = Color3.fromRGB(
								label == "R" and value or currentColor.R * 255,
								label == "G" and value or currentColor.G * 255,
								label == "B" and value or currentColor.B * 255
							)
							colorPreview.BackgroundColor3 = currentColor
							if callback then
								callback(currentColor)
							end
						end
					end)
				end

				createSlider(currentColor.R, 0, "R")
				createSlider(currentColor.G, 30, "G")
				createSlider(currentColor.B, 60, "B")

				colorButton.MouseButton1Click:Connect(function()
					isOpen = not isOpen
					pickerFrame.Visible = isOpen
					createTween(pickerFrame, {Size = UDim2.new(1, 0, 0, isOpen and 90 or 0)}, 0.3)
					updateSectionSize()
				end)

				updateSectionSize()
				return colorPickerFrame
			end

			return sectionAPI
		end

		return tabAPI
	end

	return windowAPI
end

return GojoUI

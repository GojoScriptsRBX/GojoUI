-- GojoUI Library for Roblox Injectors
-- Minimalistic, functional, with animations, inspired by Kavo UI
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

-- Main Library Function
function GojoUI:CreateWindow(title)
	local screenGui = createScreenGui()
	local window = Instance.new("Frame")
	local titleBar = Instance.new("Frame")
	local titleText = Instance.new("TextLabel")
	local closeButton = Instance.new("TextButton")
	local content = Instance.new("Frame")
	local layout = Instance.new("UIListLayout")
	local corner = Instance.new("UICorner")

	-- Window Setup
	window.Name = "GojoWindow"
	window.Size = UDim2.new(0, 250, 0, 350)
	window.Position = UDim2.new(0.5, -125, 0.5, -175)
	window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	window.BorderSizePixel = 0
	window.ClipsDescendants = true
	window.Parent = screenGui

	-- Rounded Corners
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = window

	-- Title Bar
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

	-- Content Frame
	content.Name = "Content"
	content.Size = UDim2.new(1, -10, 1, -40)
	content.Position = UDim2.new(0, 5, 0, 35)
	content.BackgroundTransparency = 1
	content.Parent = window

	-- Layout
	layout.Name = "Layout"
	layout.Padding = UDim.new(0, 5)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = content

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
		createTween(window, {Size = UDim2.new(0, 250, 0, 0)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Connect(function()
			screenGui:Destroy()
		end)
	end)

	-- Window Animation
	window.Size = UDim2.new(0, 250, 0, 0)
	createTween(window, {Size = UDim2.new(0, 250, 0, 350)}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	-- Window API
	local windowAPI = {}

	function windowAPI:CreateButton(text, callback)
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
		button.Parent = content
		buttonCorner.CornerRadius = UDim.new(0, 5)
		buttonCorner.Parent = button

		-- Button Animation
		button.MouseEnter:Connect(function()
			createTween(button, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
		end)
		button.MouseLeave:Connect(function()
			createTween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
		end)

		-- Button Click
		button.MouseButton1Click:Connect(function()
			if callback then
				callback()
			end
		end)

		return button
	end

	function windowAPI:CreateTextBox(placeholder, callback)
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
		textBox.Parent = content
		textBoxCorner.CornerRadius = UDim.new(0, 5)
		textBoxCorner.Parent = textBox

		-- TextBox Animation
		textBox.Focused:Connect(function()
			createTween(textBox, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
		end)
		textBox.FocusLost:Connect(function()
			createTween(textBox, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
			if callback then
				callback(textBox.Text)
			end
		end)

		return textBox
	end

	function windowAPI:CreateToggle(text, default, callback)
		local toggleFrame = Instance.new("Frame")
		local toggleLabel = Instance.new("TextLabel")
		local toggleButton = Instance.new("TextButton")
		local toggleButtonCorner = Instance.new("UICorner")
		local toggleState = default or false

		toggleFrame.Name = "Toggle"
		toggleFrame.Size = UDim2.new(1, 0, 0, 30)
		toggleFrame.BackgroundTransparency = 1
		toggleFrame.Parent = content

		toggleLabel.Name = "ToggleLabel"
		toggleLabel.Size = UDim2.new(0.8, 0, 1, 0)
		toggleLabel.BackgroundTransparency = 1
		toggleLabel.Text = text or "Toggle"
		toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		toggleLabel.TextSize = 12
		toggleLabel.Font = Enum.Font.Gotham
		toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
		toggleLabel.Parent = toggleFrame

		toggleButton.Name = "ToggleButton"
		toggleButton.Size = UDim2.new(0, 30, 0, 20)
		toggleButton.Position = UDim2.new(1, -30, 0.5, -10)
		toggleButton.BackgroundColor3 = toggleState and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
		toggleButton.BorderSizePixel = 0
		toggleButton.Text = ""
		toggleButton.Parent = toggleFrame
		toggleButtonCorner.CornerRadius = UDim.new(0, 5)
		toggleButtonCorner.Parent = toggleButton

		-- Toggle Functionality
		toggleButton.MouseButton1Click:Connect(function()
			toggleState = not toggleState
			createTween(toggleButton, {BackgroundColor3 = toggleState and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)}, 0.2)
			if callback then
				callback(toggleState)
			end
		end)

		return toggleFrame
	end

	return windowAPI
end

return GojoUI

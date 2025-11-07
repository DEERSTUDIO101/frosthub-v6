-- IceHub Style UI Library
-- Basierend auf Kavo UI mit modernem Design

local IceHub = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Utility Functions
local Utility = {}

function Utility:Tween(obj, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tween = TweenService:Create(obj, TweenInfo.new(duration, style, direction), properties)
    tween:Play()
    return tween
end

function Utility:MakeGradient(parent, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(color1, color2)
    gradient.Rotation = 45
    gradient.Parent = parent
    return gradient
end

function Utility:MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Utility:Tween(frame, {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
end

function Utility:CreateRipple(button)
    local ripple = Instance.new("ImageLabel")
    ripple.Name = "Ripple"
    ripple.BackgroundTransparency = 1
    ripple.Image = "rbxassetid://4560909609"
    ripple.ImageTransparency = 0.5
    ripple.ZIndex = 1000
    
    button.MouseButton1Click:Connect(function()
        local clone = ripple:Clone()
        clone.Parent = button
        
        local x = Mouse.X - button.AbsolutePosition.X
        local y = Mouse.Y - button.AbsolutePosition.Y
        
        clone.Position = UDim2.new(0, x, 0, y)
        
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        
        Utility:Tween(clone, {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(0.5, -size/2, 0.5, -size/2),
            ImageTransparency = 1
        }, 0.4)
        
        task.delay(0.4, function()
            clone:Destroy()
        end)
    end)
end

-- Theme System
local Themes = {
    IceHub = {
        Primary = Color3.fromRGB(100, 200, 255),
        Secondary = Color3.fromRGB(70, 150, 220),
        Background = Color3.fromRGB(15, 15, 20),
        Surface = Color3.fromRGB(25, 25, 35),
        Header = Color3.fromRGB(20, 20, 28),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Accent = Color3.fromRGB(120, 220, 255),
        Success = Color3.fromRGB(100, 255, 150),
        Warning = Color3.fromRGB(255, 200, 100),
        Error = Color3.fromRGB(255, 100, 100)
    },
    Dark = {
        Primary = Color3.fromRGB(138, 43, 226),
        Secondary = Color3.fromRGB(100, 30, 180),
        Background = Color3.fromRGB(10, 10, 15),
        Surface = Color3.fromRGB(20, 20, 28),
        Header = Color3.fromRGB(15, 15, 22),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(170, 170, 170),
        Accent = Color3.fromRGB(160, 80, 255),
        Success = Color3.fromRGB(80, 255, 120),
        Warning = Color3.fromRGB(255, 180, 80),
        Error = Color3.fromRGB(255, 80, 80)
    },
    Neon = {
        Primary = Color3.fromRGB(0, 255, 255),
        Secondary = Color3.fromRGB(255, 0, 255),
        Background = Color3.fromRGB(5, 5, 10),
        Surface = Color3.fromRGB(15, 15, 25),
        Header = Color3.fromRGB(10, 10, 20),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 200, 200),
        Accent = Color3.fromRGB(0, 255, 200),
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 0, 100)
    }
}

-- Main Library Function
function IceHub:CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "IceHub"
    local theme = Themes[options.Theme] or Themes.IceHub
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = HttpService:GenerateGUID(false)
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main Container
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.BackgroundColor3 = theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = Main
    
    -- Glow Effect
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Parent = Main
    Glow.BackgroundTransparency = 1
    Glow.Position = UDim2.new(0, -15, 0, -15)
    Glow.Size = UDim2.new(1, 30, 1, 30)
    Glow.ZIndex = 0
    Glow.Image = "rbxassetid://4996891970"
    Glow.ImageColor3 = theme.Primary
    Glow.ImageTransparency = 0.7
    
    -- Animated Glow
    coroutine.wrap(function()
        while Main.Parent do
            Utility:Tween(Glow, {ImageTransparency = 0.5}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(1.5)
            Utility:Tween(Glow, {ImageTransparency = 0.8}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(1.5)
        end
    end)()
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Main
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = theme.Header
    Header.BorderSizePixel = 0
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header
    
    local HeaderCover = Instance.new("Frame")
    HeaderCover.Name = "Cover"
    HeaderCover.Parent = Header
    HeaderCover.Position = UDim2.new(0, 0, 1, -12)
    HeaderCover.Size = UDim2.new(1, 0, 0, 12)
    HeaderCover.BackgroundColor3 = theme.Header
    HeaderCover.BorderSizePixel = 0
    
    -- Gradient on Header
    Utility:MakeGradient(Header, theme.Primary, theme.Secondary)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Header
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = windowName
    Title.TextColor3 = theme.Text
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Parent = Header
    CloseButton.AnchorPoint = Vector2.new(1, 0.5)
    CloseButton.Position = UDim2.new(1, -10, 0.5, 0)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.BackgroundColor3 = theme.Error
    CloseButton.Text = "×"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextColor3 = theme.Text
    CloseButton.TextSize = 20
    CloseButton.AutoButtonColor = false
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseEnter:Connect(function()
        Utility:Tween(CloseButton, {Size = UDim2.new(0, 35, 0, 35)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Utility:Tween(CloseButton, {Size = UDim2.new(0, 30, 0, 30)}, 0.2)
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        Utility:Tween(Main, {
            Size = UDim2.new(0, 0, 0, 0)
        }, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Minimize Button
    local MinButton = Instance.new("TextButton")
    MinButton.Name = "Minimize"
    MinButton.Parent = Header
    MinButton.AnchorPoint = Vector2.new(1, 0.5)
    MinButton.Position = UDim2.new(1, -50, 0.5, 0)
    MinButton.Size = UDim2.new(0, 30, 0, 30)
    MinButton.BackgroundColor3 = theme.Warning
    MinButton.Text = "−"
    MinButton.Font = Enum.Font.GothamBold
    MinButton.TextColor3 = theme.Text
    MinButton.TextSize = 18
    MinButton.AutoButtonColor = false
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(1, 0)
    MinCorner.Parent = MinButton
    
    local minimized = false
    MinButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Utility:Tween(Main, {Size = UDim2.new(0, 600, 0, 45)}, 0.3)
        else
            Utility:Tween(Main, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
        end
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "Tabs"
    TabContainer.Parent = Main
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.Size = UDim2.new(0, 150, 1, -45)
    TabContainer.BackgroundColor3 = theme.Surface
    TabContainer.BorderSizePixel = 0
    
    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "Content"
    ContentContainer.Parent = Main
    ContentContainer.Position = UDim2.new(0, 150, 0, 45)
    ContentContainer.Size = UDim2.new(1, -150, 1, -45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    
    -- Make Draggable
    Utility:MakeDraggable(Main, Header)
    
    -- Intro Animation
    Main.Size = UDim2.new(0, 0, 0, 0)
    Utility:Tween(Main, {Size = UDim2.new(0, 600, 0, 400)}, 0.5, Enum.EasingStyle.Back)
    
    -- Window Functions
    local Window = {}
    Window.Theme = theme
    
    function Window:CreateTab(tabName)
        local Tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Parent = TabContainer
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = theme.Surface
        TabButton.Text = tabName
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextColor3 = theme.TextDark
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        Utility:CreateRipple(TabButton)
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName.."Content"
        TabContent.Parent = ContentContainer
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = theme.Primary
        TabContent.Visible = false
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Parent = TabContent
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 8)
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    Utility:Tween(v, {
                        BackgroundColor3 = theme.Surface,
                        TextColor3 = theme.TextDark
                    }, 0.2)
                end
            end
            
            TabContent.Visible = true
            Utility:Tween(TabButton, {
                BackgroundColor3 = theme.Primary,
                TextColor3 = theme.Text
            }, 0.2)
        end)
        
        -- Auto-select first tab
        if #TabContainer:GetChildren() == 2 then -- UIListLayout + first tab
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Tab Element Functions
        function Tab:CreateButton(options)
            options = options or {}
            local buttonText = options.Name or "Button"
            local callback = options.Callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = TabContent
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = theme.Surface
            Button.Text = buttonText
            Button.Font = Enum.Font.Gotham
            Button.TextColor3 = theme.Text
            Button.TextSize = 14
            Button.AutoButtonColor = false
            Button.ClipsDescendants = true
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = Button
            
            Utility:CreateRipple(Button)
            
            Button.MouseEnter:Connect(function()
                Utility:Tween(Button, {BackgroundColor3 = theme.Header}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Utility:Tween(Button, {BackgroundColor3 = theme.Surface}, 0.2)
            end)
            
            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            
            return Button
        end
        
        function Tab:CreateToggle(options)
            options = options or {}
            local toggleText = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end
            
            local toggled = default
            
            local Toggle = Instance.new("Frame")
            Toggle.Name = "Toggle"
            Toggle.Parent = TabContent
            Toggle.Size = UDim2.new(1, 0, 0, 40)
            Toggle.BackgroundColor3 = theme.Surface
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = Toggle
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Toggle
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = toggleText
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = Toggle
            ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
            ToggleButton.Position = UDim2.new(1, -15, 0.5, 0)
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.BackgroundColor3 = toggled and theme.Success or theme.TextDark
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            
            local ToggleBtnCorner = Instance.new("UICorner")
            ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
            ToggleBtnCorner.Parent = ToggleButton
            
            local Circle = Instance.new("Frame")
            Circle.Parent = ToggleButton
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = theme.Text
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                Utility:Tween(ToggleButton, {
                    BackgroundColor3 = toggled and theme.Success or theme.TextDark
                }, 0.2)
                
                Utility:Tween(Circle, {
                    Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }, 0.2)
                
                pcall(callback, toggled)
            end)
            
            if default then
                pcall(callback, toggled)
            end
            
            return Toggle
        end
        
        function Tab:CreateSlider(options)
            options = options or {}
            local sliderText = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            
            local Slider = Instance.new("Frame")
            Slider.Name = "Slider"
            Slider.Parent = TabContent
            Slider.Size = UDim2.new(1, 0, 0, 50)
            Slider.BackgroundColor3 = theme.Surface
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = Slider
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Slider
            Label.Position = UDim2.new(0, 15, 0, 5)
            Label.Size = UDim2.new(0.7, 0, 0, 20)
            Label.BackgroundTransparency = 1
            Label.Text = sliderText
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Value = Instance.new("TextLabel")
            Value.Parent = Slider
            Value.AnchorPoint = Vector2.new(1, 0)
            Value.Position = UDim2.new(1, -15, 0, 5)
            Value.Size = UDim2.new(0.3, 0, 0, 20)
            Value.BackgroundTransparency = 1
            Value.Text = tostring(default)
            Value.Font = Enum.Font.GothamBold
            Value.TextColor3 = theme.Primary
            Value.TextSize = 14
            Value.TextXAlignment = Enum.TextXAlignment.Right
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Parent = Slider
            SliderBar.Position = UDim2.new(0, 15, 1, -15)
            SliderBar.Size = UDim2.new(1, -30, 0, 4)
            SliderBar.BackgroundColor3 = theme.Header
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local Fill = Instance.new("Frame")
            Fill.Parent = SliderBar
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = theme.Primary
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((Mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * pos)
                    
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    Value.Text = tostring(value)
                    pcall(callback, value)
                end
            end)
            
            return Slider
        end
        
        function Tab:CreateDropdown(options)
            options = options or {}
            local dropdownText = options.Name or "Dropdown"
            local items = options.Options or {}
            local callback = options.Callback or function() end
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = "Dropdown"
            Dropdown.Parent = TabContent
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            Dropdown.BackgroundColor3 = theme.Surface
            Dropdown.ClipsDescendants = true
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = Dropdown
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Dropdown
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(0.7, 0, 0, 40)
            Label.BackgroundTransparency = 1
            Label.Text = dropdownText
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Parent = Dropdown
            Arrow.AnchorPoint = Vector2.new(1, 0.5)
            Arrow.Position = UDim2.new(1, -15, 0, 20)
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextColor3 = theme.Primary
            Arrow.TextSize = 12
            
            local ItemList = Instance.new("Frame")
            ItemList.Parent = Dropdown
            ItemList.Position = UDim2.new(0, 0, 0, 40)
            ItemList.Size = UDim2.new(1, 0, 0, 0)
            ItemList.BackgroundTransparency = 1
            
            local ItemListLayout = Instance.new("UIListLayout")
            ItemListLayout.Parent = ItemList
            ItemListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local opened = false
            
            local Button = Instance.new("TextButton")
            Button.Parent = Dropdown
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundTransparency = 1
            Button.Text = ""
            
            Button.MouseButton1Click:Connect(function()
                opened = not opened
                
                if opened then
                    Utility:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 40 + #items * 35)}, 0.3)
                    Utility:Tween(Arrow, {Rotation = 180}, 0.3)
                else
                    Utility:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
                    Utility:Tween(Arrow, {Rotation = 0}, 0.3)
                end
            end)
            
            for i, item in ipairs(items) do
                local ItemButton = Instance.new("TextButton")
                ItemButton.Parent = ItemList
                ItemButton.Size = UDim2.new(1, 0, 0, 35)
                ItemButton.BackgroundColor3 = theme.Header
                ItemButton.Text = "  " .. item
                ItemButton.Font = Enum.Font.Gotham
                ItemButton.TextColor3 = theme.Text
                ItemButton.TextSize = 13
                ItemButton.TextXAlignment = Enum.TextXAlignment.Left
                ItemButton.AutoButtonColor = false
                
                ItemButton.MouseEnter:Connect(function()
                    Utility:Tween(ItemButton, {BackgroundColor3 = theme.Primary}, 0.2)
                end)
                
                ItemButton.MouseLeave:Connect(function()
                    Utility:Tween(ItemButton, {BackgroundColor3 = theme.Header}, 0.2)
                end)
                
                ItemButton.MouseButton1Click:Connect(function()
                    Label.Text = dropdownText .. ": " .. item
                    opened = false
                    Utility:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
                    Utility:Tween(Arrow, {Rotation = 0}, 0.3)
                    pcall(callback, item)
                end)
            end
            
            return Dropdown
        end
        
        function Tab:CreateTextbox(options)
            options = options or {}
            local textboxText = options.Name or "Textbox"
            local placeholder = options.Placeholder or "Enter text..."
            local callback = options.Callback or function() end
            
            local Textbox = Instance.new("Frame")
            Textbox.Name = "Textbox"
            Textbox.Parent = TabContent
            Textbox.Size = UDim2.new(1, 0, 0, 60)
            Textbox.BackgroundColor3 = theme.Surface
            
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 8)
            TextboxCorner.Parent = Textbox
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Textbox
            Label.Position = UDim2.new(0, 15, 0, 5)
            Label.Size = UDim2.new(1, -30, 0, 20)
            Label.BackgroundTransparency = 1
            Label.Text = textboxText
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local Input = Instance.new("TextBox")
            Input.Parent = Textbox
            Input.Position = UDim2.new(0, 15, 0, 30)
            Input.Size = UDim2.new(1, -30, 0, 25)
            Input.BackgroundColor3 = theme.Header
            Input.PlaceholderText = placeholder
            Input.PlaceholderColor3 = theme.TextDark
            Input.Text = ""
            Input.Font = Enum.Font.Gotham
            Input.TextColor3 = theme.Text
            Input.TextSize = 13
            Input.TextXAlignment = Enum.TextXAlignment.Left
            Input.ClearTextOnFocus = false
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 6)
            InputCorner.Parent = Input
            
            local InputPadding = Instance.new("UIPadding")
            InputPadding.Parent = Input
            InputPadding.PaddingLeft = UDim.new(0, 8)
            InputPadding.PaddingRight = UDim.new(0, 8)
            
            Input.FocusLost:Connect(function(enter)
                if enter then
                    pcall(callback, Input.Text)
                end
            end)
            
            Input.Focused:Connect(function()
                Utility:Tween(Input, {BackgroundColor3 = theme.Primary}, 0.2)
            end)
            
            Input.FocusLost:Connect(function()
                Utility:Tween(Input, {BackgroundColor3 = theme.Header}, 0.2)
            end)
            
            return Textbox
        end
        
        function Tab:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Parent = TabContent
            Label.Size = UDim2.new(1, 0, 0, 35)
            Label.BackgroundColor3 = theme.Surface
            Label.Text = "  " .. text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextColor3 = theme.Primary
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 8)
            LabelCorner.Parent = Label
            
            return Label
        end
        
        function Tab:CreateColorPicker(options)
            options = options or {}
            local pickerText = options.Name or "Color Picker"
            local default = options.Default or Color3.fromRGB(255, 255, 255)
            local callback = options.Callback or function() end
            
            local h, s, v = Color3.toHSV(default)
            local currentColor = default
            
            local ColorPicker = Instance.new("Frame")
            ColorPicker.Name = "ColorPicker"
            ColorPicker.Parent = TabContent
            ColorPicker.Size = UDim2.new(1, 0, 0, 40)
            ColorPicker.BackgroundColor3 = theme.Surface
            ColorPicker.ClipsDescendants = true
            
            local PickerCorner = Instance.new("UICorner")
            PickerCorner.CornerRadius = UDim.new(0, 8)
            PickerCorner.Parent = ColorPicker
            
            local Label = Instance.new("TextLabel")
            Label.Parent = ColorPicker
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(0.7, 0, 0, 40)
            Label.BackgroundTransparency = 1
            Label.Text = pickerText
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Parent = ColorPicker
            ColorDisplay.AnchorPoint = Vector2.new(1, 0.5)
            ColorDisplay.Position = UDim2.new(1, -15, 0, 20)
            ColorDisplay.Size = UDim2.new(0, 50, 0, 25)
            ColorDisplay.BackgroundColor3 = currentColor
            
            local DisplayCorner = Instance.new("UICorner")
            DisplayCorner.CornerRadius = UDim.new(0, 6)
            DisplayCorner.Parent = ColorDisplay
            
            local Button = Instance.new("TextButton")
            Button.Parent = ColorPicker
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundTransparency = 1
            Button.Text = ""
            
            local opened = false
            
            Button.MouseButton1Click:Connect(function()
                opened = not opened
                
                if opened then
                    Utility:Tween(ColorPicker, {Size = UDim2.new(1, 0, 0, 200)}, 0.3)
                else
                    Utility:Tween(ColorPicker, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
                end
            end)
            
            -- Color Picker Canvas
            local Canvas = Instance.new("ImageLabel")
            Canvas.Parent = ColorPicker
            Canvas.Position = UDim2.new(0, 15, 0, 50)
            Canvas.Size = UDim2.new(0, 130, 0, 130)
            Canvas.BackgroundTransparency = 1
            Canvas.Image = "rbxassetid://4155801252"
            
            local CanvasCorner = Instance.new("UICorner")
            CanvasCorner.CornerRadius = UDim.new(0, 6)
            CanvasCorner.Parent = Canvas
            
            local Cursor = Instance.new("Frame")
            Cursor.Parent = Canvas
            Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
            Cursor.Size = UDim2.new(0, 8, 0, 8)
            Cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Cursor.BorderSizePixel = 2
            Cursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
            
            local CursorCorner = Instance.new("UICorner")
            CursorCorner.CornerRadius = UDim.new(1, 0)
            CursorCorner.Parent = Cursor
            
            -- Hue Bar
            local HueBar = Instance.new("ImageLabel")
            HueBar.Parent = ColorPicker
            HueBar.Position = UDim2.new(0, 155, 0, 50)
            HueBar.Size = UDim2.new(0, 20, 0, 130)
            HueBar.BackgroundTransparency = 1
            HueBar.Image = "rbxassetid://3641079629"
            
            local HueCorner = Instance.new("UICorner")
            HueCorner.CornerRadius = UDim.new(0, 6)
            HueCorner.Parent = HueBar
            
            local HueCursor = Instance.new("Frame")
            HueCursor.Parent = HueBar
            HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
            HueCursor.Size = UDim2.new(1, 4, 0, 4)
            HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueCursor.BorderSizePixel = 2
            HueCursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
            
            local function updateColor()
                currentColor = Color3.fromHSV(h, s, v)
                ColorDisplay.BackgroundColor3 = currentColor
                Canvas.ImageColor3 = Color3.fromHSV(h, 1, 1)
                pcall(callback, currentColor)
            end
            
            local canvasDragging = false
            local hueDragging = false
            
            Canvas.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    canvasDragging = true
                end
            end)
            
            HueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    canvasDragging = false
                    hueDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if canvasDragging then
                        local posX = math.clamp((Mouse.X - Canvas.AbsolutePosition.X) / Canvas.AbsoluteSize.X, 0, 1)
                        local posY = math.clamp((Mouse.Y - Canvas.AbsolutePosition.Y) / Canvas.AbsoluteSize.Y, 0, 1)
                        
                        Cursor.Position = UDim2.new(posX, 0, posY, 0)
                        s = posX
                        v = 1 - posY
                        updateColor()
                    end
                    
                    if hueDragging then
                        local posY = math.clamp((Mouse.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                        
                        HueCursor.Position = UDim2.new(0.5, 0, posY, 0)
                        h = 1 - posY
                        updateColor()
                    end
                end
            end)
            
            -- Set initial position
            Cursor.Position = UDim2.new(s, 0, 1 - v, 0)
            HueCursor.Position = UDim2.new(0.5, 0, 1 - h, 0)
            updateColor()
            
            return ColorPicker
        end
        
        function Tab:CreateKeybind(options)
            options = options or {}
            local keybindText = options.Name or "Keybind"
            local default = options.Default or Enum.KeyCode.E
            local callback = options.Callback or function() end
            
            local currentKey = default
            local listening = false
            
            local Keybind = Instance.new("Frame")
            Keybind.Name = "Keybind"
            Keybind.Parent = TabContent
            Keybind.Size = UDim2.new(1, 0, 0, 40)
            Keybind.BackgroundColor3 = theme.Surface
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 8)
            KeybindCorner.Parent = Keybind
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Keybind
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = keybindText
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local KeyButton = Instance.new("TextButton")
            KeyButton.Parent = Keybind
            KeyButton.AnchorPoint = Vector2.new(1, 0.5)
            KeyButton.Position = UDim2.new(1, -15, 0.5, 0)
            KeyButton.Size = UDim2.new(0, 60, 0, 25)
            KeyButton.BackgroundColor3 = theme.Header
            KeyButton.Text = currentKey.Name
            KeyButton.Font = Enum.Font.GothamBold
            KeyButton.TextColor3 = theme.Primary
            KeyButton.TextSize = 12
            KeyButton.AutoButtonColor = false
            
            local KeyCorner = Instance.new("UICorner")
            KeyCorner.CornerRadius = UDim.new(0, 6)
            KeyCorner.Parent = KeyButton
            
            KeyButton.MouseButton1Click:Connect(function()
                listening = true
                KeyButton.Text = "..."
                Utility:Tween(KeyButton, {BackgroundColor3 = theme.Primary}, 0.2)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = input.KeyCode
                    KeyButton.Text = currentKey.Name
                    Utility:Tween(KeyButton, {BackgroundColor3 = theme.Header}, 0.2)
                end
                
                if not gameProcessed and input.KeyCode == currentKey then
                    pcall(callback)
                end
            end)
            
            return Keybind
        end
        
        function Tab:CreateSection(sectionText)
            local Section = Instance.new("TextLabel")
            Section.Name = "Section"
            Section.Parent = TabContent
            Section.Size = UDim2.new(1, 0, 0, 30)
            Section.BackgroundTransparency = 1
            Section.Text = sectionText
            Section.Font = Enum.Font.GothamBold
            Section.TextColor3 = theme.Primary
            Section.TextSize = 16
            Section.TextXAlignment = Enum.TextXAlignment.Left
            
            local Line = Instance.new("Frame")
            Line.Parent = Section
            Line.Position = UDim2.new(0, 0, 1, -2)
            Line.Size = UDim2.new(1, 0, 0, 2)
            Line.BackgroundColor3 = theme.Primary
            
            local LineCorner = Instance.new("UICorner")
            LineCorner.CornerRadius = UDim.new(1, 0)
            LineCorner.Parent = Line
            
            return Section
        end
        
        return Tab
    end
    
    function Window:Notify(options)
        options = options or {}
        local title = options.Title or "Notification"
        local text = options.Text or "This is a notification"
        local duration = options.Duration or 3
        local type = options.Type or "Info" -- Info, Success, Warning, Error
        
        local NotifContainer = ScreenGui:FindFirstChild("Notifications")
        if not NotifContainer then
            NotifContainer = Instance.new("Frame")
            NotifContainer.Name = "Notifications"
            NotifContainer.Parent = ScreenGui
            NotifContainer.AnchorPoint = Vector2.new(1, 0)
            NotifContainer.Position = UDim2.new(1, -20, 0, 20)
            NotifContainer.Size = UDim2.new(0, 300, 1, -40)
            NotifContainer.BackgroundTransparency = 1
            
            local NotifList = Instance.new("UIListLayout")
            NotifList.Parent = NotifContainer
            NotifList.SortOrder = Enum.SortOrder.LayoutOrder
            NotifList.Padding = UDim.new(0, 10)
        end
        
        local Notification = Instance.new("Frame")
        Notification.Parent = NotifContainer
        Notification.Size = UDim2.new(1, 0, 0, 80)
        Notification.BackgroundColor3 = theme.Surface
        Notification.BorderSizePixel = 0
        Notification.Position = UDim2.new(1, 50, 0, 0)
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 10)
        NotifCorner.Parent = Notification
        
        local colorMap = {
            Info = theme.Primary,
            Success = theme.Success,
            Warning = theme.Warning,
            Error = theme.Error
        }
        
        local Accent = Instance.new("Frame")
        Accent.Parent = Notification
        Accent.Size = UDim2.new(0, 4, 1, 0)
        Accent.BackgroundColor3 = colorMap[type] or theme.Primary
        Accent.BorderSizePixel = 0
        
        local AccentCorner = Instance.new("UICorner")
        AccentCorner.CornerRadius = UDim.new(0, 10)
        AccentCorner.Parent = Accent
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Parent = Notification
        TitleLabel.Position = UDim2.new(0, 15, 0, 10)
        TitleLabel.Size = UDim2.new(1, -30, 0, 20)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextColor3 = theme.Text
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Parent = Notification
        TextLabel.Position = UDim2.new(0, 15, 0, 35)
        TextLabel.Size = UDim2.new(1, -30, 0, 35)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = text
        TextLabel.Font = Enum.Font.Gotham
        TextLabel.TextColor3 = theme.TextDark
        TextLabel.TextSize = 12
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextWrapped = true
        TextLabel.TextYAlignment = Enum.TextYAlignment.Top
        
        -- Slide in animation
        Utility:Tween(Notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Back)
        
        -- Auto destroy
        task.delay(duration, function()
            Utility:Tween(Notification, {
                Position = UDim2.new(1, 50, 0, 0)
            }, 0.3)
            task.wait(0.3)
            Notification:Destroy()
        end)
    end
    
    function Window:SetTheme(themeName)
        if Themes[themeName] then
            theme = Themes[themeName]
            Window.Theme = theme
        end
    end
    
    function Window:Destroy()
        Utility:Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end
    
    return Window
end

return IceHub

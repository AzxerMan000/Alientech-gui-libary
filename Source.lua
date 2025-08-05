-- AlienTech GUI + Kavo UI Wrapper Module renamed to AlienGui
local AlienTechGUI = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Themes Table
local Themes = {
    ["White"] = {
        BackgroundColor = Color3.fromRGB(245, 245, 245),
        StrokeColor = Color3.fromRGB(200, 200, 200),
        GlowColor = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(50, 50, 50),
    },
    ["Black"] = {
        BackgroundColor = Color3.fromRGB(20, 20, 20),
        StrokeColor = Color3.fromRGB(50, 50, 50),
        GlowColor = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
    },
    ["BlackRed"] = {
        BackgroundColor = Color3.fromRGB(20, 20, 20),
        StrokeColor = Color3.fromRGB(255, 0, 0),
        GlowColor = Color3.fromRGB(255, 50, 50),
        TextColor = Color3.fromRGB(255, 100, 100),
    },
    ["BlackAlienGreen"] = {
        BackgroundColor = Color3.fromRGB(10, 10, 10),
        StrokeColor = Color3.fromRGB(0, 255, 0),
        GlowColor = Color3.fromRGB(0, 255, 120),
        TextColor = Color3.fromRGB(120, 255, 120),
    },
}

-- Core AlienTech GUI creation function
function AlienTechGUI.CreateGUI(titleText)
    local LocalPlayer = Players.LocalPlayer
    local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    ScreenGui.Name = "AlienTechGUI"

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 500, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 12)

    local TitleBar = Instance.new("Frame", MainFrame)
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundTransparency = 1

    local TitleLabel = Instance.new("TextLabel", TitleBar)
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Text = titleText or "AlienTech GUI"
    TitleLabel.TextScaled = true
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local MinimizeButton = Instance.new("TextButton", TitleBar)
    MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
    MinimizeButton.Position = UDim2.new(1, -70, 0, 0)
    MinimizeButton.Text = "-"

    local CloseButton = Instance.new("TextButton", TitleBar)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Position = UDim2.new(1, -35, 0, 0)
    CloseButton.Text = "X"

    local TabsFrame = Instance.new("Frame", MainFrame)
    TabsFrame.Size = UDim2.new(0, 100, 1, -30)
    TabsFrame.Position = UDim2.new(0, 0, 0, 30)
    TabsFrame.BackgroundTransparency = 0.4
    TabsFrame.BorderSizePixel = 0

    local TabsList = Instance.new("UIListLayout", TabsFrame)
    TabsList.Padding = UDim.new(0, 5)
    TabsList.SortOrder = Enum.SortOrder.LayoutOrder

    local ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, -100, 1, -30)
    ContentFrame.Position = UDim2.new(0, 100, 0, 30)
    ContentFrame.BackgroundTransparency = 0.3
    ContentFrame.BorderSizePixel = 0

    local ScrollingContent = Instance.new("ScrollingFrame", ContentFrame)
    ScrollingContent.Size = UDim2.new(1, 0, 1, 0)
    ScrollingContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingContent.ScrollBarThickness = 6
    ScrollingContent.BackgroundTransparency = 1

    local UIListLayout = Instance.new("UIListLayout", ScrollingContent)
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ThemeDropdown = Instance.new("TextButton", TabsFrame)
    ThemeDropdown.Size = UDim2.new(1, -20, 0, 30)
    ThemeDropdown.Text = "Themes"

    local ThemeOrder = {"White", "Black", "BlackRed", "BlackAlienGreen"}
    local CurrentThemeIndex = 1

    local function ApplyTheme(themeName)
        local theme = Themes[themeName]
        if theme then
            TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundColor3 = theme.BackgroundColor}):Play()
            TitleLabel.TextColor3 = theme.TextColor
            TabsFrame.BackgroundColor3 = theme.StrokeColor
            ContentFrame.BackgroundColor3 = theme.StrokeColor
            ThemeDropdown.TextColor3 = theme.TextColor

            for _, child in ipairs(ScrollingContent:GetChildren()) do
                if child:IsA("TextButton") or child:IsA("TextBox") then
                    child.TextColor3 = theme.TextColor
                    child.BackgroundColor3 = theme.GlowColor
                end
            end
        end
    end

    ThemeDropdown.MouseButton1Click:Connect(function()
        CurrentThemeIndex = CurrentThemeIndex + 1
        if CurrentThemeIndex > #ThemeOrder then
            CurrentThemeIndex = 1
        end
        ApplyTheme(ThemeOrder[CurrentThemeIndex])
    end)

    local Minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        if not Minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.5), {Size = UDim2.new(0, 500, 0, 30)}):Play()
            Minimized = true
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.5), {Size = UDim2.new(0, 500, 0, 300)}):Play()
            Minimized = false
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local Tabs = {}

    local function UpdateCanvas()
        ScrollingContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end

    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

    ApplyTheme("BlackAlienGreen")

    -- Return the API to manipulate GUI
    return {
        SetTitle = function(newTitle)
            TitleLabel.Text = newTitle
        end,
        AddTab = function(tabName)
            local TabButton = Instance.new("TextButton")
            TabButton.Size = UDim2.new(1, -20, 0, 30)
            TabButton.Text = tabName
            TabButton.BackgroundTransparency = 0.2
            TabButton.BorderSizePixel = 0

            local UICorner = Instance.new("UICorner", TabButton)
            UICorner.CornerRadius = UDim.new(0, 6)

            TabButton.Parent = TabsFrame

            local TabContent = Instance.new("Frame")
            TabContent.Size = UDim2.new(1, 0, 0, 0)
            TabContent.BackgroundTransparency = 1
            TabContent.Visible = false
            TabContent.LayoutOrder = 1

            local TabList = Instance.new("UIListLayout", TabContent)
            TabList.Padding = UDim.new(0, 10)
            TabList.SortOrder = Enum.SortOrder.LayoutOrder

            TabContent.Parent = ScrollingContent

            TabButton.MouseButton1Click:Connect(function()
                for _, tab in pairs(Tabs) do
                    tab.Content.Visible = false
                end
                TabContent.Visible = true
                UpdateCanvas()
            end)

            table.insert(Tabs, {Button = TabButton, Content = TabContent})

            return {
                AddButton = function(text, callback)
                    local Button = Instance.new("TextButton")
                    Button.Size = UDim2.new(1, -20, 0, 30)
                    Button.Text = text
                    Button.BackgroundTransparency = 0.2
                    Button.BorderSizePixel = 0
                    local UICorner = Instance.new("UICorner", Button)
                    UICorner.CornerRadius = UDim.new(0, 6)
                    Button.MouseButton1Click:Connect(function()
                        if callback then callback() end
                    end)
                    Button.Parent = TabContent
                end,
                AddToggle = function(text, default, callback)
                    local Toggle = Instance.new("TextButton")
                    Toggle.Size = UDim2.new(1, -20, 0, 30)
                    Toggle.Text = text .. ": " .. (default and "ON" or "OFF")
                    Toggle.BackgroundTransparency = 0.2
                    Toggle.BorderSizePixel = 0
                    local State = default
                    local UICorner = Instance.new("UICorner", Toggle)
                    UICorner.CornerRadius = UDim.new(0, 6)
                    Toggle.MouseButton1Click:Connect(function()
                        State = not State
                        Toggle.Text = text .. ": " .. (State and "ON" or "OFF")
                        if callback then callback(State) end
                    end)
                    Toggle.Parent = TabContent
                end,
                AddTextbox = function(placeholder, callback)
                    local TextBox = Instance.new("TextBox")
                    TextBox.Size = UDim2.new(1, -20, 0, 30)
                    TextBox.PlaceholderText = placeholder
                    TextBox.BackgroundTransparency = 0.2
                    TextBox.BorderSizePixel = 0
                    local UICorner = Instance.new("UICorner", TextBox)
                    UICorner.CornerRadius = UDim.new(0, 6)
                    TextBox.FocusLost:Connect(function(enter)
                        if enter and callback then
                            callback(TextBox.Text)
                        end
                    end)
                    TextBox.Parent = TabContent
                end
            }
        end
    }
end

-- Kavo UI Wrapper Interface for AlienTechGUI with renamed library
local AlienGui = {}

function AlienGui.CreateLib(title, theme)
    local Window = AlienTechGUI.CreateGUI(title)

    local WindowWrapper = {}

    function WindowWrapper:NewTab(tabName)
        local Tab = Window.AddTab(tabName)
        local TabWrapper = {}

        function TabWrapper:NewButton(text, info, callback)
            Tab.AddButton(text, callback)
        end

        function TabWrapper:NewToggle(text, default, callback)
            Tab.AddToggle(text, default, callback)
        end

        function TabWrapper:NewTextbox(placeholder, callback)
            Tab.AddTextbox(placeholder, callback)
        end

        return TabWrapper
    end

    return WindowWrapper
end

return AlienGui

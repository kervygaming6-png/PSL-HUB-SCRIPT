-- ============================================
-- MUSCLE LEGENDS RGB DRAGGABLE UI
-- ============================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ============================================
-- UI CONFIGURATION
-- ============================================

local UIConfig = {
    Width = 327,
    Height = 450,
    RGBSpeed = 0.01,
    TabCount = 6,
    Tabs = {
        "Farming",
        "Strength", 
        "Chest",
        "Equipment",
        "Settings",
        "Credits"
    }
}

-- ============================================
-- CREATE MAIN SCREEN GUI
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MuscleLegendsUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- ============================================
-- GLOBAL VARIABLES
-- ============================================

local isDragging = false
local dragStart = nil
local dragOffset = nil
local isUIVisible = true
local currentTab = 1
local rgbHue = 0

-- ============================================
-- RGB COLOR FUNCTION
-- ============================================

local function getRGBColor(hue)
    local r = math.sin(hue) * 0.5 + 0.5
    local g = math.sin(hue + 2.094) * 0.5 + 0.5
    local b = math.sin(hue + 4.188) * 0.5 + 0.5
    return Color3.fromRGB(r * 255, g * 255, b * 255)
end

-- ============================================
-- CREATE MINIMIZE BUTTON (CIRCLE ICON)
-- ============================================

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 50, 0, 50)
minimizeButton.Position = UDim2.new(0, 10, 0, 10)
minimizeButton.BackgroundColor3 = getRGBColor(0)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Text = "◎"
minimizeButton.Parent = screenGui

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(1, 0)
minimizeCorner.Parent = minimizeButton

-- ============================================
-- CREATE MAIN UI FRAME (HIDDEN BY DEFAULT)
-- ============================================

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, UIConfig.Width, 0, UIConfig.Height)
mainFrame.Position = UDim2.new(0, 100, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- ============================================
-- CREATE TOP BAR (DRAGGABLE)
-- ============================================

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = getRGBColor(0)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 10)
topBarCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "MUSCLE LEGENDS"
titleLabel.Parent = topBar

-- ============================================
-- CREATE TAB BUTTONS
-- ============================================

local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(1, 0, 0, 35)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

local tabLayout = Instance.new("UIGridLayout")
tabLayout.CellSize = UDim2.new(1/UIConfig.TabCount, 0, 1, 0)
tabLayout.Parent = tabFrame

local tabs = {}
for i = 1, UIConfig.TabCount do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Tab" .. i
    tabButton.BackgroundColor3 = (i == 1) and getRGBColor(0) or Color3.fromRGB(45, 45, 55)
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextSize = 10
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Text = UIConfig.Tabs[i]
    tabButton.BorderSizePixel = 0
    tabButton.Parent = tabFrame
    
    tabButton.MouseButton1Click:Connect(function()
        currentTab = i
        for j = 1, UIConfig.TabCount do
            tabs[j].BackgroundColor3 = (j == i) and getRGBColor(rgbHue) or Color3.fromRGB(45, 45, 55)
        end
    end)
    
    tabs[i] = tabButton
end

-- ============================================
-- CREATE SCROLLABLE CONTENT FRAME
-- ============================================

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -75)
contentFrame.Position = UDim2.new(0, 0, 0, 75)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 8
contentFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.Parent = contentFrame

-- ============================================
-- TAB CONTENT DATA
-- ============================================

local tabContent = {
    {
        title = "Auto Farm",
        description = "Enable/Disable auto farming",
        type = "toggle"
    },
    {
        title = "Farm Speed",
        description = "Adjust farming speed",
        type = "slider"
    },
    {
        title = "Auto Strength",
        description = "Auto upgrade strength",
        type = "toggle"
    },
    {
        title = "Strength Level",
        description = "Current level: 50",
        type = "label"
    },
    {
        title = "Auto Chest",
        description = "Auto upgrade chest",
        type = "toggle"
    },
    {
        title = "Chest Level",
        description = "Current level: 45",
        type = "label"
    },
    {
        title = "Auto Equipment",
        description = "Auto equip items",
        type = "toggle"
    },
    {
        title = "Equipment Grade",
        description = "Legendary",
        type = "label"
    },
    {
        title = "Animation Speed",
        description = "Speed: 1.0x",
        type = "slider"
    },
    {
        title = "Debug Mode",
        description = "Enable debugging",
        type = "toggle"
    },
    {
        title = "Creator",
        description = "Made by Kev",
        type = "label"
    },
    {
        title = "Version",
        description = "v1.0.0",
        type = "label"
    }
}

-- ============================================
-- POPULATE CONTENT
-- ============================================

local function createContent()
    -- Clear content
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add content based on current tab
    local startIdx = (currentTab - 1) * 2 + 1
    for i = startIdx, math.min(startIdx + 1, #tabContent) do
        local content = tabContent[i]
        
        local contentItem = Instance.new("Frame")
        contentItem.Name = content.title
        contentItem.Size = UDim2.new(1, -20, 0, 60)
        contentItem.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        contentItem.BorderSizePixel = 0
        contentItem.Parent = contentFrame
        
        local contentCorner = Instance.new("UICorner")
        contentCorner.CornerRadius = UDim.new(0, 8)
        contentCorner.Parent = contentItem
        
        local titleText = Instance.new("TextLabel")
        titleText.Name = "Title"
        titleText.Size = UDim2.new(1, -20, 0, 20)
        titleText.Position = UDim2.new(0, 10, 0, 5)
        titleText.BackgroundTransparency = 1
        titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleText.TextSize = 12
        titleText.Font = Enum.Font.GothamBold
        titleText.Text = content.title
        titleText.TextXAlignment = Enum.TextXAlignment.Left
        titleText.Parent = contentItem
        
        local descText = Instance.new("TextLabel")
        descText.Name = "Description"
        descText.Size = UDim2.new(1, -20, 0, 30)
        descText.Position = UDim2.new(0, 10, 0, 25)
        descText.BackgroundTransparency = 1
        descText.TextColor3 = Color3.fromRGB(200, 200, 200)
        descText.TextSize = 11
        descText.Font = Enum.Font.Gotham
        descText.Text = content.description
        descText.TextXAlignment = Enum.TextXAlignment.Left
        descText.TextWrapped = true
        descText.Parent = contentItem
        
        if content.type == "toggle" then
            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "ToggleButton"
            toggleButton.Size = UDim2.new(0, 40, 0, 20)
            toggleButton.Position = UDim2.new(1, -55, 0, 20)
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
            toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleButton.TextSize = 10
            toggleButton.Font = Enum.Font.GothamBold
            toggleButton.Text = "ON"
            toggleButton.BorderSizePixel = 0
            toggleButton.Parent = contentItem
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 5)
            toggleCorner.Parent = toggleButton
            
            toggleButton.MouseButton1Click:Connect(function()
                if toggleButton.Text == "ON" then
                    toggleButton.Text = "OFF"
                    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
                else
                    toggleButton.Text = "ON"
                    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
                end
            end)
        elseif content.type == "slider" then
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = "SliderFrame"
            sliderFrame.Size = UDim2.new(0, 60, 0, 5)
            sliderFrame.Position = UDim2.new(1, -65, 0, 22)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = contentItem
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Name = "SliderBar"
            sliderBar.Size = UDim2.new(0.5, 0, 1, 0)
            sliderBar.BackgroundColor3 = getRGBColor(rgbHue)
            sliderBar.BorderSizePixel = 0
            sliderBar.Parent = sliderFrame
        end
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y)
end

createContent()

-- ============================================
-- MOUSE DRAGGING
-- ============================================

topBar.MouseButton1Down:Connect(function(x, y)
    isDragging = true
    dragStart = Vector2.new(x, y)
    dragOffset = mainFrame.Position - UDim2.new(0, x, 0, y)
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- ============================================
-- UPDATE MOUSE POSITION FOR DRAGGING
-- ============================================

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        mainFrame.Position = UDim2.new(0, mousePos.X - mainFrame.AbsoluteSize.X/2, 0, mousePos.Y - 20)
    end
end)

-- ============================================
-- MINIMIZE/SHOW BUTTON
-- ============================================

minimizeButton.MouseButton1Click:Connect(function()
    isUIVisible = not isUIVisible
    mainFrame.Visible = isUIVisible
    minimizeButton.Text = isUIVisible and "◎" or "○"
end)

-- ============================================
-- RGB UPDATE LOOP
-- ============================================

RunService.RenderStepped:Connect(function()
    rgbHue = rgbHue + UIConfig.RGBSpeed
    if rgbHue > math.pi * 2 then
        rgbHue = rgbHue - math.pi * 2
    end
    
    local rgbColor = getRGBColor(rgbHue)
    topBar.BackgroundColor3 = rgbColor
    minimizeButton.BackgroundColor3 = rgbColor
    tabs[currentTab].BackgroundColor3 = rgbColor
    
    -- Update slider color
    local sliderBar = contentFrame:FindFirstChild(tabContent[(currentTab - 1) * 2 + 1].title)
    if sliderBar then
        local slider = sliderBar:FindFirstChild("SliderFrame")
        if slider then
            local bar = slider:FindFirstChild("SliderBar")
            if bar then
                bar.BackgroundColor3 = rgbColor
            end
        end
    end
end)

-- ============================================
-- TAB CHANGE LISTENER
-- ============================================

local lastTab = currentTab
RunService.Heartbeat:Connect(function()
    if currentTab ~= lastTab then
        createContent()
        lastTab = currentTab
    end
end)

print("✓ Muscle Legends UI Loaded Successfully!")
print("✓ Click the RGB circle to show/hide the UI")
print("✓ Click and drag the top bar to move the UI")

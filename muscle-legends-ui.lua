-- ============================================
-- MUSCLE LEGENDS RGB DRAGGABLE UI WITH REAL FEATURES
-- MOBILE OPTIMIZED FOR DELTA EXECUTOR
-- ============================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
        "Killing",
        "Rebirth",
        "Eggs",
        "Settings"
    }
}

-- ============================================
-- CREATE MAIN SCREEN GUI
-- ============================================

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MuscleLegendsUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

-- ============================================
-- GLOBAL VARIABLES
-- ============================================

local isDragging = false
local dragStart = nil
local isUIVisible = true
local currentTab = 1
local rgbHue = 0

-- Feature toggles
local autoFarmEnabled = false
local autoWeightEnabled = false
local autoPushupsEnabled = false
local autoHandstandEnabled = false
local autoSitupsEnabled = false
local autoEatEggEnabled = false
local autoPunchEnabled = false
local fastToolsEnabled = false
local autoGoodKarmaKillEnabled = false
local autoKillAllEnabled = false
local autoRebirthEnabled = false
local autoSizeEnabled = false
local autoOpenEggsEnabled = false

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
minimizeButton.Size = UDim2.new(0, 60, 0, 60)
minimizeButton.Position = UDim2.new(0, 15, 0, 15)
minimizeButton.BackgroundColor3 = getRGBColor(0)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 28
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Text = "◎"
minimizeButton.BorderSizePixel = 0
minimizeButton.Parent = screenGui
minimizeButton.ZIndex = 1000

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(1, 0)
minimizeCorner.Parent = minimizeButton

-- ============================================
-- CREATE MAIN UI FRAME
-- ============================================

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, UIConfig.Width, 0, UIConfig.Height)
mainFrame.Position = UDim2.new(0, 20, 0, 150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.ZIndex = 999
mainFrame.Visible = true

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
topBar.ZIndex = 1001

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 10)
topBarCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "MUSCLE LEGENDS"
titleLabel.Parent = topBar
titleLabel.ZIndex = 1001

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
tabFrame.ZIndex = 999

local tabLayout = Instance.new("UIGridLayout")
tabLayout.CellSize = UDim2.new(1/UIConfig.TabCount, 0, 1, 0)
tabLayout.Parent = tabFrame

local tabs = {}
for i = 1, UIConfig.TabCount do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Tab" .. i
    tabButton.BackgroundColor3 = (i == 1) and getRGBColor(0) or Color3.fromRGB(45, 45, 55)
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextSize = 9
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Text = UIConfig.Tabs[i]
    tabButton.BorderSizePixel = 0
    tabButton.Parent = tabFrame
    tabButton.ZIndex = 999
    
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
contentFrame.ZIndex = 999

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.Parent = contentFrame

-- ============================================
-- FARMING FUNCTIONS
-- ============================================

local function equipTool(toolName)
    local character = player.Character
    local backpack = player.Backpack
    
    if not character or not backpack then return end
    
    local tool = backpack:FindFirstChild(toolName)
    if tool then
        character.Humanoid:EquipTool(tool)
    end
end

local function fireRep()
    if player:FindFirstChild("muscleEvent") then
        player.muscleEvent:FireServer("rep")
    end
end

-- ============================================
-- AUTO FARM LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoFarmEnabled then
            fireRep()
            task.wait(0.2)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO WEIGHT LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoWeightEnabled then
            equipTool("Weight")
            fireRep()
            task.wait(0.3)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO PUSHUPS LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoPushupsEnabled then
            equipTool("Pushups")
            fireRep()
            task.wait(0.3)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO HANDSTAND LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoHandstandEnabled then
            equipTool("Handstand")
            fireRep()
            task.wait(0.3)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO SITUPS LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoSitupsEnabled then
            equipTool("Situps")
            fireRep()
            task.wait(0.3)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO EAT EGG LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoEatEggEnabled then
            local backpack = player.Backpack
            local character = player.Character
            
            if character and backpack then
                local egg = backpack:FindFirstChild("Protein Egg")
                if egg then
                    egg.Parent = character
                    pcall(function()
                        egg:Activate()
                    end)
                end
            end
            task.wait(0.5)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO PUNCH LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoPunchEnabled then
            equipTool("Punch")
            if player:FindFirstChild("muscleEvent") then
                player.muscleEvent:FireServer("punch", "rightHand")
                player.muscleEvent:FireServer("punch", "leftHand")
            end
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- FAST TOOLS LOOP
-- ============================================

task.spawn(function()
    while true do
        if fastToolsEnabled then
            local backpack = player.Backpack
            local character = player.Character
            
            local tools = {
                {"Punch", "attackTime", 0},
                {"Pushups", "repTime", 0},
                {"Weight", "repTime", 0},
                {"Handstand", "repTime", 0},
                {"Situps", "repTime", 0}
            }
            
            for _, toolInfo in ipairs(tools) do
                local tool = backpack:FindFirstChild(toolInfo[1])
                if tool and tool:FindFirstChild(toolInfo[2]) then
                    tool[toolInfo[2]].Value = toolInfo[3]
                end
            end
            
            task.wait(1)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO GOOD KARMA KILL LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoGoodKarmaKillEnabled then
            local character = player.Character
            if character then
                local rightHand = character:FindFirstChild("RightHand")
                local leftHand = character:FindFirstChild("LeftHand")
                
                if rightHand and leftHand then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= player then
                            local evilKarma = target:FindFirstChild("evilKarma")
                            local goodKarma = target:FindFirstChild("goodKarma")
                            
                            if evilKarma and goodKarma and evilKarma.Value > goodKarma.Value then
                                local targetChar = target.Character
                                if targetChar then
                                    local rootPart = targetChar:FindFirstChild("HumanoidRootPart")
                                    if rootPart then
                                        firetouchinterest(rightHand, rootPart, 1)
                                        firetouchinterest(leftHand, rootPart, 1)
                                        firetouchinterest(rightHand, rootPart, 0)
                                        firetouchinterest(leftHand, rootPart, 0)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.2)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO KILL ALL LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoKillAllEnabled then
            local character = player.Character
            if character then
                local rightHand = character:FindFirstChild("RightHand")
                local leftHand = character:FindFirstChild("LeftHand")
                
                if rightHand and leftHand then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= player then
                            local targetChar = target.Character
                            if targetChar then
                                local rootPart = targetChar:FindFirstChild("HumanoidRootPart")
                                if rootPart then
                                    firetouchinterest(rightHand, rootPart, 1)
                                    firetouchinterest(leftHand, rootPart, 1)
                                    firetouchinterest(rightHand, rootPart, 0)
                                    firetouchinterest(leftHand, rootPart, 0)
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.2)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO REBIRTH LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoRebirthEnabled then
            pcall(function()
                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            end)
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO SIZE LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoSizeEnabled then
            pcall(function()
                ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 1)
            end)
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO OPEN EGGS LOOP
-- ============================================

task.spawn(function()
    while true do
        if autoOpenEggsEnabled then
            pcall(function()
                local eggShop = ReplicatedStorage:FindFirstChild("cPetShopFolder")
                if eggShop then
                    local eggs = eggShop:GetChildren()
                    if #eggs > 0 then
                        local randomEgg = eggs[math.random(1, #eggs)]
                        ReplicatedStorage.cPetShopRemote:InvokeServer(randomEgg)
                    end
                end
            end)
            task.wait(0.5)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- CREATE CONTENT FOR EACH TAB
-- ============================================

local function createToggle(parent, title, description, callback)
    local contentItem = Instance.new("Frame")
    contentItem.Name = title
    contentItem.Size = UDim2.new(1, -20, 0, 60)
    contentItem.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    contentItem.BorderSizePixel = 0
    contentItem.Parent = parent
    contentItem.ZIndex = 999
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentItem
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -20, 0, 20)
    titleText.Position = UDim2.new(0, 10, 0, 5)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 11
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = title
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = contentItem
    titleText.ZIndex = 999
    
    local descText = Instance.new("TextLabel")
    descText.Name = "Description"
    descText.Size = UDim2.new(1, -20, 0, 30)
    descText.Position = UDim2.new(0, 10, 0, 25)
    descText.BackgroundTransparency = 1
    descText.TextColor3 = Color3.fromRGB(200, 200, 200)
    descText.TextSize = 10
    descText.Font = Enum.Font.Gotham
    descText.Text = description
    descText.TextXAlignment = Enum.TextXAlignment.Left
    descText.TextWrapped = true
    descText.Parent = contentItem
    descText.ZIndex = 999
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 45, 0, 20)
    toggleButton.Position = UDim2.new(1, -60, 0, 20)
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 9
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Text = "OFF"
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = contentItem
    toggleButton.ZIndex = 999
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 5)
    toggleCorner.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        if toggleButton.Text == "OFF" then
            toggleButton.Text = "ON"
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
            callback(true)
        else
            toggleButton.Text = "OFF"
            toggleButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
            callback(false)
        end
    end)
end

-- ============================================
-- POPULATE CONTENT BASED ON TAB
-- ============================================

local function createContent()
    -- Clear content
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Tab 1: FARMING
    if currentTab == 1 then
        createToggle(contentFrame, "Auto Farm", "Enable/Disable auto farming", function(state)
            autoFarmEnabled = state
        end)
        
        createToggle(contentFrame, "Auto Weight", "Auto equip & farm weight", function(state)
            autoWeightEnabled = state
        end)
        
        createToggle(contentFrame, "Auto Pushups", "Auto equip & farm pushups", function(state)
            autoPushupsEnabled = state
        end)
        
        createToggle(contentFrame, "Auto Handstand", "Auto equip & farm handstand", function(state)
            autoHandstandEnabled = state
        end)
        
        createToggle(contentFrame, "Auto Situps", "Auto equip & farm situps", function(state)
            autoSitupsEnabled = state
        end)
        
        createToggle(contentFrame, "Auto Eat Egg", "Auto eat Protein Eggs", function(state)
            autoEatEggEnabled = state
        end)
    
    -- Tab 2: STRENGTH
    elseif currentTab == 2 then
        createToggle(contentFrame, "Auto Punch", "Auto punch fast", function(state)
            autoPunchEnabled = state
        end)
        
        createToggle(contentFrame, "Fast Tools", "Speed up all tools to 0 delay", function(state)
            fastToolsEnabled = state
        end)
    
    -- Tab 3: KILLING
    elseif currentTab == 3 then
        createToggle(contentFrame, "Good Karma Kill", "Kill evil karma players only", function(state)
            autoGoodKarmaKillEnabled = state
        end)
        
        createToggle(contentFrame, "Kill All", "Attack all players", function(state)
            autoKillAllEnabled = state
        end)
    
    -- Tab 4: REBIRTH
    elseif currentTab == 4 then
        createToggle(contentFrame, "Auto Rebirth", "Rebirth infinitely", function(state)
            autoRebirthEnabled = state
        end)
        
        createToggle(contentFrame, "Auto Size 1", "Auto set size to 1", function(state)
            autoSizeEnabled = state
        end)
    
    -- Tab 5: EGGS
    elseif currentTab == 5 then
        createToggle(contentFrame, "Auto Open Eggs", "Auto open random eggs", function(state)
            autoOpenEggsEnabled = state
        end)
    
    -- Tab 6: SETTINGS
    elseif currentTab == 6 then
        local settingsLabel = Instance.new("TextLabel")
        settingsLabel.Name = "SettingsLabel"
        settingsLabel.Size = UDim2.new(1, -20, 0, 120)
        settingsLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        settingsLabel.BorderSizePixel = 0
        settingsLabel.Parent = contentFrame
        settingsLabel.ZIndex = 999
        
        local settingsCorner = Instance.new("UICorner")
        settingsCorner.CornerRadius = UDim.new(0, 8)
        settingsCorner.Parent = settingsLabel
        
        settingsLabel.Text = "🔷 MUSCLE LEGENDS UI\n\nVersion: v2.0.0\n\nCreator: Kev\n\nAll tabs fully working!\nClick circle to hide/show"
        settingsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        settingsLabel.TextSize = 11
        settingsLabel.Font = Enum.Font.Gotham
        settingsLabel.TextWrapped = true
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y)
end

createContent()

-- ============================================
-- DRAGGING SYSTEM (IMPROVED FOR MOBILE)
-- ============================================

topBar.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
    end
end)

topBar.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- ============================================
-- DRAG UPDATE
-- ============================================

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if isDragging and dragStart and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        local newPosition = mainFrame.Position + UDim2.new(0, delta.X, 0, delta.Y)
        mainFrame.Position = newPosition
        dragStart = input.Position
    end
end)

-- ============================================
-- MINIMIZE/SHOW BUTTON (IMPROVED)
-- ============================================

minimizeButton.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isUIVisible = not isUIVisible
        mainFrame.Visible = isUIVisible
        minimizeButton.Text = isUIVisible and "◎" or "○"
    end
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

print("✓ Muscle Legends UI v2.0.0 Loaded!")
print("✓ Click the RGB circle to show/hide")
print("✓ Drag the top bar to move")
print("✓ All 6 tabs with real features ready!")

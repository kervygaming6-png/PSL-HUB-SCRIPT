-- ============================================
-- MUSCLE LEGENDS RGB DRAGGABLE UI WITH REAL FEATURES
-- LANDSCAPE MODE - MOBILE OPTIMIZED FOR DELTA EXECUTOR
-- ============================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- ============================================
-- UI CONFIGURATION - LANDSCAPE MODE
-- ============================================

local UIConfig = {
    Width = 500,
    Height = 350,
    RGBSpeed = 0.01,
    TabCount = 8,
    Tabs = {
        "Farming",
        "Strength", 
        "Killing",
        "Rebirth",
        "Teleport",
        "Eggs",
        "Glitching",
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
local selectedPet = "Neon Guardian"
local selectedAura = "Blue Aura"
local selectedRock = "Tiny Island Rock"
local autoRockEnabled = false
local autoTPMuscleKingEnabled = false

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
-- CREATE MAIN UI FRAME - LANDSCAPE
-- ============================================

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, UIConfig.Width, 0, UIConfig.Height)
mainFrame.Position = UDim2.new(0.5, -UIConfig.Width/2, 0.5, -UIConfig.Height/2)
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
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "MUSCLE LEGENDS V3"
titleLabel.Parent = topBar
titleLabel.ZIndex = 1001

-- ============================================
-- CREATE TAB BUTTONS
-- ============================================

local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(1, 0, 0, 50)
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
    tabButton.TextSize = 8
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
contentFrame.Size = UDim2.new(1, 0, 1, -90)
contentFrame.Position = UDim2.new(0, 0, 0, 90)
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
-- AUTO FARM LOOPS
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
-- KILLING LOOPS
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
-- REBIRTH LOOPS
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
-- AUTO TELEPORT TO MUSCLE KING
-- ============================================

task.spawn(function()
    while true do
        if autoTPMuscleKingEnabled then
            pcall(function()
                if player.Character then
                    player.Character:MoveTo(Vector3.new(-8646, 17, -5738))
                end
            end)
            task.wait(0.5)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO OPEN EGGS (DROPDOWN SELECTED)
-- ============================================

task.spawn(function()
    while true do
        if autoOpenEggsEnabled and selectedPet ~= "" then
            pcall(function()
                local eggShop = ReplicatedStorage:FindFirstChild("cPetShopFolder")
                if eggShop then
                    local petToOpen = eggShop:FindFirstChild(selectedPet)
                    if petToOpen then
                        ReplicatedStorage.cPetShopRemote:InvokeServer(petToOpen)
                    end
                end
            end)
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- AUTO ROCK GLITCHING (WITHOUT TELEPORTING)
-- ============================================

task.spawn(function()
    while true do
        if autoRockEnabled and selectedRock ~= "" then
            pcall(function()
                local character = player.Character
                if character then
                    local leftHand = character:FindFirstChild("LeftHand")
                    local rightHand = character:FindFirstChild("RightHand")
                    
                    if leftHand and rightHand then
                        -- Find the rock without teleporting
                        for _, rock in ipairs(Workspace.machinesFolder:GetDescendants()) do
                            if rock.Name == "Rock" then
                                local parent = rock.Parent
                                if parent and parent.Name == selectedRock then
                                    -- Fire touch interest to hit the rock
                                    firetouchinterest(rightHand, rock, 1)
                                    firetouchinterest(leftHand, rock, 1)
                                    firetouchinterest(rightHand, rock, 0)
                                    firetouchinterest(leftHand, rock, 0)
                                end
                            end
                        end
                        
                        -- Fire punch event
                        player.muscleEvent:FireServer("punch", "rightHand")
                        player.muscleEvent:FireServer("punch", "leftHand")
                    end
                end
            end)
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)

-- ============================================
-- CREATE TOGGLE FUNCTION
-- ============================================

local function createToggle(parent, title, description, callback)
    local contentItem = Instance.new("Frame")
    contentItem.Name = title
    contentItem.Size = UDim2.new(1, -20, 0, 50)
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
    titleText.Parent = titleText.Parent or contentItem
    titleText.ZIndex = 999
    
    local descText = Instance.new("TextLabel")
    descText.Name = "Description"
    descText.Size = UDim2.new(1, -60, 0, 25)
    descText.Position = UDim2.new(0, 10, 0, 22)
    descText.BackgroundTransparency = 1
    descText.TextColor3 = Color3.fromRGB(180, 180, 180)
    descText.TextSize = 9
    descText.Font = Enum.Font.Gotham
    descText.Text = description
    descText.TextXAlignment = Enum.TextXAlignment.Left
    descText.TextWrapped = true
    descText.Parent = contentItem
    descText.ZIndex = 999
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 40, 0, 18)
    toggleButton.Position = UDim2.new(1, -55, 0, 16)
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 8
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
-- CREATE DROPDOWN FUNCTION
-- ============================================

local function createDropdown(parent, title, options, callback)
    local contentItem = Instance.new("Frame")
    contentItem.Name = title
    contentItem.Size = UDim2.new(1, -20, 0, 50)
    contentItem.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    contentItem.BorderSizePixel = 0
    contentItem.Parent = parent
    contentItem.ZIndex = 999
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentItem
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(0.5, -10, 0, 20)
    titleText.Position = UDim2.new(0, 10, 0, 5)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 11
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = title
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = contentItem
    titleText.ZIndex = 999
    
    local dropdown = Instance.new("TextButton")
    dropdown.Name = "Dropdown"
    dropdown.Size = UDim2.new(1, -20, 0, 20)
    dropdown.Position = UDim2.new(0, 10, 0, 27)
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    dropdown.TextColor3 = Color3.fromRGB(200, 200, 200)
    dropdown.TextSize = 9
    dropdown.Font = Enum.Font.Gotham
    dropdown.Text = options[1] or "Select"
    dropdown.BorderSizePixel = 0
    dropdown.Parent = contentItem
    dropdown.ZIndex = 999
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 5)
    dropdownCorner.Parent = dropdown
    
    local isOpen = false
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Name = "ListFrame"
    listFrame.Size = UDim2.new(1, -20, 0, 0)
    listFrame.Position = UDim2.new(0, 10, 0, 50)
    listFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 5
    listFrame.Visible = false
    listFrame.Parent = contentItem
    listFrame.ZIndex = 998
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = listFrame
    
    dropdown.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        listFrame.Visible = isOpen
        if isOpen then
            contentItem.Size = UDim2.new(1, -20, 0, 50 + (#options * 20) + 10)
            listFrame.Size = UDim2.new(1, 0, 0, (#options * 20) + 5)
        else
            contentItem.Size = UDim2.new(1, -20, 0, 50)
            listFrame.Size = UDim2.new(1, 0, 0, 0)
        end
    end)
    
    for _, option in ipairs(options) do
        local button = Instance.new("TextButton")
        button.Name = option
        button.Size = UDim2.new(1, 0, 0, 18)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.TextSize = 9
        button.Font = Enum.Font.Gotham
        button.Text = option
        button.BorderSizePixel = 0
        button.Parent = listFrame
        button.ZIndex = 998
        
        button.MouseButton1Click:Connect(function()
            dropdown.Text = option
            callback(option)
            isOpen = false
            listFrame.Visible = false
            contentItem.Size = UDim2.new(1, -20, 0, 50)
            listFrame.Size = UDim2.new(1, 0, 0, 0)
        end)
    end
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
    
    -- Tab 5: TELEPORT
    elseif currentTab == 5 then
        createToggle(contentFrame, "Auto TP Muscle King", "Teleport to Muscle King Gym", function(state)
            autoTPMuscleKingEnabled = state
        end)
    
    -- Tab 6: EGGS
    elseif currentTab == 6 then
        local petList = {
            "Neon Guardian", "Blue Birdie", "Blue Bunny", "Blue Firecaster", "Blue Pheonix",
            "Crimson Falcon", "Cybernetic Showdown Dragon", "Dark Golem", "Dark Legends Manticore",
            "Dark Vampy", "Darkstar Hunter", "Eternal Strike Leviathan", "Frostwave Legends Penguin",
            "Gold Warrior", "Golden Pheonix", "Golden Viking", "Green Butterfly", "Green Firecaster",
            "Infernal Dragon", "Lightning Strike Phantom", "Magic Butterfly", "Muscle Sensei",
            "Orange Hedgehog", "Orange Pegasus", "Phantom Genesis Dragon", "Purple Dragon",
            "Purple Falcon", "Red Dragon", "Red Firecaster", "Red Kitty", "Silver Dog",
            "Ultimate Supernova Pegasus", "Ultra Birdie", "White Pegasus", "White Pheonix", "Yellow Butterfly"
        }
        
        createDropdown(contentFrame, "Select Pet", petList, function(pet)
            selectedPet = pet
        end)
        
        createToggle(contentFrame, "Auto Open Pet", "Auto hatch selected pet", function(state)
            autoOpenEggsEnabled = state
        end)
    
    -- Tab 7: GLITCHING
    elseif currentTab == 7 then
        local rockList = {
            "Tiny Island Rock", "Starter Island Rock", "Legend Beach Rock", "Frost Gym Rock",
            "Mythical Gym Rock", "Eternal Gym Rock", "Legend Gym Rock", "Muscle King Gym Rock",
            "Ancient Jungle Rock"
        }
        
        createDropdown(contentFrame, "Select Rock", rockList, function(rock)
            selectedRock = rock
        end)
        
        createToggle(contentFrame, "Auto Glitch Rock", "Auto punch rock without TP", function(state)
            autoRockEnabled = state
        end)
    
    -- Tab 8: SETTINGS
    elseif currentTab == 8 then
        local settingsLabel = Instance.new("TextLabel")
        settingsLabel.Name = "SettingsLabel"
        settingsLabel.Size = UDim2.new(1, -20, 0, 150)
        settingsLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        settingsLabel.BorderSizePixel = 0
        settingsLabel.Parent = contentFrame
        settingsLabel.ZIndex = 999
        
        local settingsCorner = Instance.new("UICorner")
        settingsCorner.CornerRadius = UDim.new(0, 8)
        settingsCorner.Parent = settingsLabel
        
        settingsLabel.Text = "🔷 MUSCLE LEGENDS V3\n\nVersion: v3.0.0\n\nCreator: Kev\n\nAll tabs fully working!\nClick circle to hide/show\n\nLandscape Mode Enabled!"
        settingsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        settingsLabel.TextSize = 11
        settingsLabel.Font = Enum.Font.Gotham
        settingsLabel.TextWrapped = true
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
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
-- MINIMIZE/SHOW BUTTON
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

print("✓ Muscle Legends UI v3.0.0 Loaded!")
print("✓ Landscape Mode Enabled!")
print("✓ 8 Tabs with full features ready!")

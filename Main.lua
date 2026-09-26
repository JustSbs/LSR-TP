local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

--// CONFIG
local TELEPORT_INTERVAL = 0.1
local JUMP_INTERVAL = 5
local MOVEMENT_INTERVAL = 2
local SELL_INTERVAL = 1800
local BUY_INTERVAL = 300

local TELEPORT_POSITION = Vector3.new(14992, -55, 938)

--// FILE SETTINGS
local SETTINGS_FILE = "LSR-TP"

local defaultSettings = {
    teleport = false,
    autoSell = false,
    ultimateClass = false,
    position = {
        X = 500,
        Y = 300
    },
    miniPosition = {
        X = 25,
        Y = 300
    }
}

local settings = table.clone(defaultSettings)

local function loadSettings()
    if not (isfile and readfile and isfile(SETTINGS_FILE)) then
        return
    end

    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(SETTINGS_FILE))
    end)

    if success and type(data) == "table" then
        for key, value in pairs(data) do
            settings[key] = value
        end
    end
end

local function saveSettings()
    if not writefile then
        return
    end

    pcall(function()
        writefile(SETTINGS_FILE, HttpService:JSONEncode(settings))
    end)
end

loadSettings()

--// REMOVE OLD GUI
local oldGui = game.CoreGui:FindFirstChild("GudScriptUI")
if oldGui then
    oldGui:Destroy()
end

--// SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GudScriptUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

--// MAIN UI
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 390, 0, 290)
Main.Position = UDim2.new(
    0,
    settings.position.X or 500,
    0,
    settings.position.Y or 300
)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Main.ZIndex = 2

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(55, 55, 65)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.2
MainStroke.Parent = Main

--// SHADOW
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 7)
Shadow.Size = UDim2.new(1, 35, 1, 35)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.45
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.ZIndex = 1
Shadow.Parent = Main

--// HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 58)
Header.BackgroundTransparency = 1
Header.Parent = Main
Header.ZIndex = 3

local Title = Instance.new("TextLabel")
Title.Position = UDim2.new(0, 20, 0, 9)
Title.Size = UDim2.new(1, -115, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "Gud script - By @justsbsxd"
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header
Title.ZIndex = 4

local Line = Instance.new("Frame")
Line.Position = UDim2.new(0, 20, 1, -1)
Line.Size = UDim2.new(1, -40, 0, 1)
Line.BackgroundColor3 = Color3.fromRGB(45, 45, 53)
Line.BorderSizePixel = 0
Line.Parent = Header
Line.ZIndex = 4

--// MINIMIZE BUTTON
local Minimize = Instance.new("TextButton")
Minimize.Position = UDim2.new(1, -82, 0, 12)
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
Minimize.Text = "−"
Minimize.TextColor3 = Color3.fromRGB(180, 180, 190)
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamMedium
Minimize.AutoButtonColor = false
Minimize.Parent = Header
Minimize.ZIndex = 5

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = Minimize

Minimize.MouseEnter:Connect(function()
    TweenService:Create(
        Minimize,
        TweenInfo.new(0.15),
        {
            BackgroundColor3 = Color3.fromRGB(45, 45, 55),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }
    ):Play()
end)

Minimize.MouseLeave:Connect(function()
    TweenService:Create(
        Minimize,
        TweenInfo.new(0.15),
        {
            BackgroundColor3 = Color3.fromRGB(30, 30, 37),
            TextColor3 = Color3.fromRGB(180, 180, 190)
        }
    ):Play()
end)

--// CLOSE BUTTON
local Close = Instance.new("TextButton")
Close.Position = UDim2.new(1, -45, 0, 12)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(180, 180, 190)
Close.TextSize = 20
Close.Font = Enum.Font.GothamMedium
Close.AutoButtonColor = false
Close.Parent = Header
Close.ZIndex = 5

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

Close.MouseEnter:Connect(function()
    TweenService:Create(
        Close,
        TweenInfo.new(0.15),
        {
            BackgroundColor3 = Color3.fromRGB(190, 55, 65),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }
    ):Play()
end)

Close.MouseLeave:Connect(function()
    TweenService:Create(
        Close,
        TweenInfo.new(0.15),
        {
            BackgroundColor3 = Color3.fromRGB(30, 30, 37),
            TextColor3 = Color3.fromRGB(180, 180, 190)
        }
    ):Play()
end)

Close.MouseButton1Click:Connect(function()
    settings.position.X = Main.AbsolutePosition.X
    settings.position.Y = Main.AbsolutePosition.Y
    saveSettings()

    TweenService:Create(
        Main,
        TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {
            Size = UDim2.new(0, 390, 0, 0)
        }
    ):Play()

    task.wait(0.2)
    ScreenGui:Destroy()
end)

--// CONTENT
local Content = Instance.new("Frame")
Content.Position = UDim2.new(0, 15, 0, 68)
Content.Size = UDim2.new(1, -30, 1, -83)
Content.BackgroundTransparency = 1
Content.Parent = Main
Content.ZIndex = 3

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 10)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

--// TOGGLE CREATOR
local function createToggle(text, defaultValue, callback)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 52)
    Button.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Content
    Button.ZIndex = 4

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(40, 40, 48)
    Stroke.Thickness = 1
    Stroke.Transparency = 0.2
    Stroke.Parent = Button

    local Label = Instance.new("TextLabel")
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Size = UDim2.new(1, -80, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(225, 225, 230)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    Label.ZIndex = 5

    local Switch = Instance.new("Frame")
    Switch.Position = UDim2.new(1, -58, 0.5, -11)
    Switch.Size = UDim2.new(0, 42, 0, 22)
    Switch.BackgroundColor3 = Color3.fromRGB(42, 42, 50)
    Switch.BorderSizePixel = 0
    Switch.Parent = Button
    Switch.ZIndex = 5

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch

    local Circle = Instance.new("Frame")
    Circle.Position = UDim2.new(0, 3, 0.5, -8)
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.BackgroundColor3 = Color3.fromRGB(170, 170, 180)
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch
    Circle.ZIndex = 6

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local enabled = defaultValue

    local function update(animated)

        local switchColor
        local circleColor
        local circlePosition

        if enabled then
            switchColor = Color3.fromRGB(75, 115, 255)
            circleColor = Color3.fromRGB(255, 255, 255)
            circlePosition = UDim2.new(1, -19, 0.5, -8)
        else
            switchColor = Color3.fromRGB(42, 42, 50)
            circleColor = Color3.fromRGB(170, 170, 180)
            circlePosition = UDim2.new(0, 3, 0.5, -8)
        end

        local info = TweenInfo.new(
            animated and 0.18 or 0,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        )

        TweenService:Create(
            Switch,
            info,
            {
                BackgroundColor3 = switchColor
            }
        ):Play()

        TweenService:Create(
            Circle,
            info,
            {
                Position = circlePosition,
                BackgroundColor3 = circleColor
            }
        ):Play()
    end

    Button.MouseEnter:Connect(function()

        TweenService:Create(
            Button,
            TweenInfo.new(0.15),
            {
                BackgroundColor3 = Color3.fromRGB(27, 27, 34)
            }
        ):Play()
    end)

    Button.MouseLeave:Connect(function()

        TweenService:Create(
            Button,
            TweenInfo.new(0.15),
            {
                BackgroundColor3 = Color3.fromRGB(22, 22, 28)
            }
        ):Play()
    end)

    Button.MouseButton1Click:Connect(function()

        enabled = not enabled

        update(true)
        callback(enabled)
    end)

    update(false)

    return {
        set = function(value)
            enabled = value
            update(true)
        end,

        get = function()
            return enabled
        end
    }
end

--// TOGGLES
local TeleportToggle = createToggle(
    "Teleport",
    settings.teleport,
    function(value)

        settings.teleport = value
        saveSettings()
    end
)

local SellToggle = createToggle(
    "Auto Sell",
    settings.autoSell,
    function(value)

        settings.autoSell = value
        saveSettings()
    end
)

local UltimateToggle = createToggle(
    "Ultimate Class",
    settings.ultimateClass,
    function(value)

        settings.ultimateClass = value
        saveSettings()
    end
)

--// MINI BUTTON
local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.new(0, 48, 0, 48)
MiniButton.Position = UDim2.new(
    0,
    settings.miniPosition.X or 25,
    0,
    settings.miniPosition.Y or 300
)
MiniButton.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
MiniButton.BorderSizePixel = 0
MiniButton.Text = "G"
MiniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniButton.TextSize = 18
MiniButton.Font = Enum.Font.GothamBold
MiniButton.AutoButtonColor = false
MiniButton.Visible = false
MiniButton.Parent = ScreenGui
MiniButton.ZIndex = 20

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 12)
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(75, 115, 255)
MiniStroke.Thickness = 1.5
MiniStroke.Transparency = 0.15
MiniStroke.Parent = MiniButton

--// MINI BUTTON HOVER
MiniButton.MouseEnter:Connect(function()

    TweenService:Create(
        MiniButton,
        TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 53, 0, 53),
            BackgroundColor3 = Color3.fromRGB(28, 28, 36)
        }
    ):Play()
end)

MiniButton.MouseLeave:Connect(function()

    TweenService:Create(
        MiniButton,
        TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 48, 0, 48),
            BackgroundColor3 = Color3.fromRGB(18, 18, 23)
        }
    ):Play()
end)

--// DRAG MAIN UI
local draggingMain = false
local dragStartMain
local startPosMain

Header.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        draggingMain = true
        dragStartMain = input.Position
        startPosMain = Main.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then

                draggingMain = false

                settings.position.X = Main.AbsolutePosition.X
                settings.position.Y = Main.AbsolutePosition.Y

                saveSettings()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if draggingMain and input.UserInputType == Enum.UserInputType.MouseMovement then

        local delta = input.Position - dragStartMain

        Main.Position = UDim2.new(
            0,
            startPosMain.X.Offset + delta.X,
            0,
            startPosMain.Y.Offset + delta.Y
        )
    end
end)

--// DRAG MINI BUTTON
local draggingMini = false
local dragStartMini
local startPosMini

MiniButton.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        draggingMini = true
        dragStartMini = input.Position
        startPosMini = MiniButton.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then

                draggingMini = false

                settings.miniPosition.X = MiniButton.AbsolutePosition.X
                settings.miniPosition.Y = MiniButton.AbsolutePosition.Y

                saveSettings()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if draggingMini and input.UserInputType == Enum.UserInputType.MouseMovement then

        local delta = input.Position - dragStartMini

        MiniButton.Position = UDim2.new(
            0,
            startPosMini.X.Offset + delta.X,
            0,
            startPosMini.Y.Offset + delta.Y
        )
    end
end)

--// MINIMIZE
Minimize.MouseButton1Click:Connect(function()

    settings.position.X = Main.AbsolutePosition.X
    settings.position.Y = Main.AbsolutePosition.Y

    saveSettings()

    Main.Visible = false
    MiniButton.Visible = true
end)

--// RESTORE
MiniButton.MouseButton1Click:Connect(function()

    MiniButton.Visible = false
    Main.Visible = true
end)

--// TELEPORT LOOP
task.spawn(function()

    while ScreenGui.Parent do

        if settings.teleport then

            local character = player.Character

            if character then

                local root = character:FindFirstChild("HumanoidRootPart")

                if root then
                    root.CFrame = CFrame.new(TELEPORT_POSITION)
                end
            end
        end

        task.wait(TELEPORT_INTERVAL)
    end
end)

--// JUMP LOOP
task.spawn(function()

    while ScreenGui.Parent do

        if settings.teleport then

            local character = player.Character

            if character then

                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.Jump = true
                end
            end
        end

        task.wait(JUMP_INTERVAL)
    end
end)

--// MOVEMENT LOOP
task.spawn(function()

    local direction = 1

    while ScreenGui.Parent do

        if settings.teleport then

            local character = player.Character

            if character then

                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid then

                    humanoid:Move(
                        Vector3.new(direction, 0, 0),
                        false
                    )

                    direction = -direction
                end
            end
        end

        task.wait(MOVEMENT_INTERVAL)
    end
end)

--// AUTO SELL
task.spawn(function()

    while ScreenGui.Parent do

        if settings.autoSell then

            pcall(function()

                local Event = game:GetService("ReplicatedStorage").RemoteEvent

                Event:FireServer({
                    "SellMuscle"
                })
            end)
        end

        task.wait(SELL_INTERVAL)
    end
end)

--// ULTIMATE CLASS
task.spawn(function()

    while ScreenGui.Parent do

        if settings.ultimateClass then

            pcall(function()

                local Event = game:GetService("ReplicatedStorage").RemoteEvent

                Event:FireServer({
                    "BuyItem",
                    "Income_Item",
                    "1ST ULTIMATE CLASS",
                    126
                })
            end)
        end

        task.wait(BUY_INTERVAL)
    end
end)

--// SAVE ON LEAVE
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)

    if leavingPlayer == player then

        settings.position.X = Main.AbsolutePosition.X
        settings.position.Y = Main.AbsolutePosition.Y

        settings.miniPosition.X = MiniButton.AbsolutePosition.X
        settings.miniPosition.Y = MiniButton.AbsolutePosition.Y

        saveSettings()
    end
end)

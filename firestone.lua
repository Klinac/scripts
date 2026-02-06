repeat task.wait() until game:IsLoaded()

-- // SERVICES \\ --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- // CONFIGURATION \\ --
local Config = {
    HubName = "UtopiaHub",
    ScriptID = "40dd20119987fb9a320477bac5bb2ad4",
    DiscordInvite = "GMeJJAYqKQ",
    GetKeyLink = "https://utopiahub.mysellauth.com/product/apocalypse-rising-2",
    AccentColor = Color3.fromRGB(114, 137, 218), -- Discord-ish blurple/Utopia blue
    BackgroundColor = Color3.fromRGB(20, 20, 20)
}

-- // CORE LOGIC (LUARMOR) \\ --
local API = loadstring(game:HttpGet("https://sdkAPI-public.luarmor.net/library.lua"))()
API.script_id = Config.ScriptID
makefolder(Config.HubName)
local key_path = Config.HubName .. "/Key.txt"
-- IMPORTANT: script_key MUST be global for Luarmor API
script_key = script_key or (isfile(key_path) and readfile(key_path) or nil)

-- // UI HELPER FUNCTIONS \\ --
local function MakeDraggable(gui)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

-- // UI CONSTRUCTION (CUSTOM "10K" LAYOUT) \\ --
local ScreenGui = Create("ScreenGui", {
    Name = "UtopiaLoader",
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    ResetOnSpawn = false
})

-- Blur Effect
local Blur = Create("BlurEffect", {
    Parent = game:GetService("Lighting"),
    Size = 0
})

-- Main Frame
local MainFrame = Create("Frame", {
    Name = "MainFrame",
    Parent = ScreenGui,
    BackgroundColor3 = Config.BackgroundColor,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -200, 0.5, -125),
    Size = UDim2.new(0, 400, 0, 250),
    ClipsDescendants = true,
    BackgroundTransparency = 1 -- Start invisible for anim
})

local UICorner = Create("UICorner", {
    CornerRadius = UDim.new(0, 12),
    Parent = MainFrame
})

-- Background Gradient/Glow
local UIGradient = Create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 12))
    },
    Rotation = 45,
    Parent = MainFrame
})

local Stroke = Create("UIStroke", {
    Parent = MainFrame,
    Color = Config.AccentColor,
    Thickness = 1,
    Transparency = 0.8
})

-- Title
local TitleScale = Create("UIScale", {Parent = MainFrame, Scale = 0.1}) -- Start small

local Title = Create("TextLabel", {
    Parent = MainFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 25),
    Size = UDim2.new(1, -40, 0, 30),
    Font = Enum.Font.GothamBold,
    Text = Config.HubName:upper(),
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 24,
    TextXAlignment = Enum.TextXAlignment.Left
})

local SubTitle = Create("TextLabel", {
    Parent = MainFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 50),
    Size = UDim2.new(1, -40, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "Premium Script Loader",
    TextColor3 = Color3.fromRGB(150, 150, 150),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Close Button
local CloseBtn = Create("TextButton", {
    Parent = MainFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -35, 0, 8),
    Size = UDim2.new(0, 25, 0, 25),
    Font = Enum.Font.GothamBold,
    Text = "×",
    TextColor3 = Color3.fromRGB(150, 150, 150),
    TextSize = 22
})

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Position = MainFrame.Position + UDim2.new(0,0,0,50)}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
    Blur:Destroy()
end)

-- Key Input Container
local InputContainer = Create("Frame", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -180, 0, 90),
    Size = UDim2.new(0, 360, 0, 45)
})
Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = InputContainer})
Create("UIStroke", {Parent = InputContainer, Color = Color3.fromRGB(60, 60, 65), Thickness = 1})

local KeyBox = Create("TextBox", {
    Parent = InputContainer,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 0),
    Size = UDim2.new(1, -30, 1, 0),
    Font = Enum.Font.Gotham,
    PlaceholderText = "Enter License Key...",
    PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
    Text = script_key or "",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false
})

-- Status Label
local StatusLabel = Create("TextLabel", {
    Parent = MainFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 140),
    Size = UDim2.new(1, -40, 0, 20),
    Font = Enum.Font.GothamMedium,
    Text = "Waiting for input...",
    TextColor3 = Color3.fromRGB(100, 100, 100),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Center
})

-- Interaction Buttons
local ButtonContainer = Create("Frame", {
    Parent = MainFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 1, -60),
    Size = UDim2.new(1, -40, 0, 40)
})

local function CreateButton(text, posScale, callback)
    local Btn = Create("TextButton", {
        Parent = ButtonContainer,
        BackgroundColor3 = Config.AccentColor,
        BorderSizePixel = 0,
        Position = UDim2.new(posScale, 0, 0, 0),
        Size = UDim2.new(0.48, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = text,
        TextColor3 = Color3.fromRGB(20, 20, 20), -- Dark text on bright button
        TextSize = 14,
        AutoButtonColor = false
    })
    
    local BtnCorner = Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Btn})
    
    -- Hover Animation
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Config.AccentColor}):Play()
    end)
    
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local VerifyBtn = CreateButton("VERIFY ACCESS", 0.52, function()
    local input = KeyBox.Text
    if input == "" then
        StatusLabel.Text = "Please enter a key"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end

    StatusLabel.Text = "Checking key..."
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

    -- API Check
    local status = API.check_key(input)
    if status.code == "KEY_VALID" then
        StatusLabel.Text = "Access Granted"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Set global script_key for Luarmor API
        script_key = input
        writefile(key_path, input)
        
        -- Success Anim
        TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.6)
        ScreenGui:Destroy()
        Blur:Destroy()
        
        API.load_script()
    else
        StatusLabel.Text = "Invalid Key: " .. (status.message or "Unknown")
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        
        -- Shake Effect
        for i = 1, 5 do
            MainFrame.Position = MainFrame.Position + UDim2.new(0, math.random(-5,5), 0, 0)
            task.wait(0.05)
            MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
        end
    end
end)

local GetKeyBtn = CreateButton("GET KEY", 0, function()
    setclipboard(Config.GetKeyLink)
    StatusLabel.Text = "Link copied to clipboard!"
    StatusLabel.TextColor3 = Config.AccentColor
    task.wait(2)
    StatusLabel.Text = "Waiting for input..."
    StatusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
end)

-- Discord Button (Text Button, Visible)
local DiscordBtn = Create("TextButton", {
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(88, 101, 242), -- Discord Blurple
    BorderSizePixel = 0,
    Position = UDim2.new(1, -115, 0, 8),
    Size = UDim2.new(0, 70, 0, 25),
    Font = Enum.Font.GothamBold,
    Text = "Discord",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 11,
    AutoButtonColor = false
})
Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DiscordBtn})

DiscordBtn.MouseEnter:Connect(function()
    TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 130, 255)}):Play()
end)
DiscordBtn.MouseLeave:Connect(function()
    TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
end)

DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/" .. Config.DiscordInvite)
    StatusLabel.Text = "Discord invite copied!"
    StatusLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
    
     if request then
        request({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json", ["Origin"] = "https://discord.com" },
            Body = HttpService:JSONEncode({ args = { code = Config.DiscordInvite }, cmd = "INVITE_BROWSER", nonce = "." }),
        })
    end
end)


MakeDraggable(MainFrame)


MainFrame.BackgroundTransparency = 1
TitleScale.Scale = 0.5
Blur.Size = 0

TweenService:Create(Blur, TweenInfo.new(1), {Size = 24}):Play()

MainFrame.Visible = true
TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0
}):Play()

TweenService:Create(TitleScale, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
    Scale = 1
}):Play()

-- Auto-Check Old Key
if script_key and script_key ~= "" then
    StatusLabel.Text = "Verifying saved key..."
    task.delay(0.5, function()
        
        local status = API.check_key(script_key)
        if status.code == "KEY_VALID" then
             StatusLabel.Text = "Welcome back!"
             StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
             
             writefile(key_path, script_key)
             task.wait(0.5)
             -- Close
             TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
             TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
             }):Play()
             task.wait(0.6)
             ScreenGui:Destroy()
             Blur:Destroy()
             API.load_script()
        else
            StatusLabel.Text = "Saved key expired/invalid"
            KeyBox.Text = ""
            script_key = nil
        end
    end)
end

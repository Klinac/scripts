--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                    UTOPIAHUB.NET v1.0.0                     ║
    ║              Premium Script Hub – Roblox Lua                ║
    ╚══════════════════════════════════════════════════════════════╝
]]

--------------------------------------------------------------
-- Services
--------------------------------------------------------------
local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService    = game:GetService("HttpService")
local Lighting       = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------------------
-- Configuration
--------------------------------------------------------------
local CONFIG = {
    -- Colors
    BG_PRIMARY     = Color3.fromRGB(12, 12, 18),
    BG_SECONDARY   = Color3.fromRGB(18, 18, 28),
    BG_TERTIARY    = Color3.fromRGB(24, 24, 36),
    BG_CARD        = Color3.fromRGB(22, 22, 34),
    BG_CARD_HOVER  = Color3.fromRGB(30, 30, 46),
    ACCENT         = Color3.fromRGB(130, 80, 255),
    ACCENT_GLOW    = Color3.fromRGB(160, 110, 255),
    ACCENT_DIM     = Color3.fromRGB(90, 50, 200),
    TEXT_PRIMARY    = Color3.fromRGB(235, 235, 245),
    TEXT_SECONDARY  = Color3.fromRGB(150, 150, 175),
    TEXT_DIM        = Color3.fromRGB(100, 100, 130),
    BORDER         = Color3.fromRGB(45, 45, 65),
    BORDER_ACCENT  = Color3.fromRGB(100, 60, 200),
    NEW_BADGE      = Color3.fromRGB(255, 75, 110),
    BUTTON_GRADIENT_START = Color3.fromRGB(130, 80, 255),
    BUTTON_GRADIENT_END   = Color3.fromRGB(90, 50, 220),
    SEARCH_BG      = Color3.fromRGB(28, 28, 42),
    DISCORD_COLOR  = Color3.fromRGB(88, 101, 242),

    -- Dimensions
    WINDOW_WIDTH   = 720,
    WINDOW_HEIGHT  = 500,
    SIDEBAR_WIDTH  = 56,
    CARD_SIZE      = UDim2.new(0, 195, 0, 240),
    CORNER_RADIUS  = UDim.new(0, 10),
    CORNER_RADIUS_SM = UDim.new(0, 6),
    CORNER_RADIUS_LG = UDim.new(0, 14),

    -- Animation
    TWEEN_SPEED    = 0.3,
    TWEEN_FAST     = 0.15,
    TWEEN_SLOW     = 0.5,
}

--------------------------------------------------------------
-- Script Data
--------------------------------------------------------------
local SCRIPTS = {
    { Name = "Abyss",              PlaceId = "127794225497302", IsNew = true,  Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/abyss.lua", true))()' },
    { Name = "Blockspin",          PlaceId = "104715542330896", IsNew = false, Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/blockspin_new.lua", true))()' },
    { Name = "Apocalypse Rising 2",PlaceId = "863266079",      IsNew = false, StaticThumb = "https://tr.rbxcdn.com/180DAY-7f567a3332e78830db1c48e694a6ea81/512/512/Image/Png/noFilter", Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/ar2_new.lua", true))()' },
    { Name = "Bloxstrike",        PlaceId = "114234929420007", IsNew = false, Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/bloxstrike.lua", true))()' },
    { Name = "Tha Bronx 3",       PlaceId = "16472538603",     IsNew = false, Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/thabronx3_new.lua", true))()' },
    { Name = "Dig Legends",       PlaceId = "103571191458177", IsNew = false, Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/diglegends.lua", true))()' },
    { Name = "Rivals",            PlaceId = "17625359962",     IsNew = false, Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/rivals_new.lua", true))()' },
    { Name = "Fight in a school",  PlaceId = "17698425045",     IsNew = false, Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/fias.lua", true))()' },
}

--------------------------------------------------------------
-- Helpers
--------------------------------------------------------------
local function tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(
        duration or CONFIG.TWEEN_SPEED,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or CONFIG.CORNER_RADIUS
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or CONFIG.BORDER
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function addPadding(parent, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.Parent = parent
    return padding
end

local function addGradient(parent, startColor, endColor, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, startColor),
        ColorSequenceKeypoint.new(1, endColor),
    })
    gradient.Rotation = rotation or 90
    gradient.Parent = parent
    return gradient
end

-- HTTP GET (uses request() which was confirmed working)
local function httpGet(url)
    if request then
        local s, r = pcall(function()
            return request({ Url = url, Method = "GET" })
        end)
        if s and r and r.Body and #r.Body > 0 then return r.Body end
    end
    if http_request then
        local s, r = pcall(function()
            return http_request({ Url = url, Method = "GET" })
        end)
        if s and r and r.Body and #r.Body > 0 then return r.Body end
    end
    local s, r = pcall(function() return game:HttpGet(url) end)
    if s and r and type(r) == "string" and #r > 0 then return r end
    return nil
end

local function fetchThumbnail(placeId)
    local url = "https://thumbnails.roblox.com/v1/places/gameicons?placeIds=" .. placeId .. "&size=512x512&format=Png&isCircular=false"
    local body = httpGet(url)
    if not body then return nil end
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if ok and decoded and decoded.data and decoded.data[1] and decoded.data[1].imageUrl then
        return decoded.data[1].imageUrl
    end
    return nil
end

-- Load image into an ImageLabel using writefile + getcustomasset
local function loadImageAsync(imageLabel, imageUrl, placeId)
    task.spawn(function()
        -- Try writefile + getcustomasset (works in most executors)
        pcall(function()
            local fileName = "utopiahub_" .. placeId .. ".png"
            local resp = request({ Url = imageUrl, Method = "GET" })
            if resp and resp.Body then
                if writefile and getcustomasset then
                    writefile(fileName, resp.Body)
                    imageLabel.Image = getcustomasset(fileName)
                    return
                elseif writefile and getsynasset then
                    writefile(fileName, resp.Body)
                    imageLabel.Image = getsynasset(fileName)
                    return
                end
            end
        end)

        -- Fallback: direct URL
        if imageLabel.Image == "" then
            imageLabel.Image = imageUrl
        end
    end)
end

--------------------------------------------------------------
-- Blur Effect
--------------------------------------------------------------
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Name = "UtopiaHubBlur"
blur.Parent = Lighting

--------------------------------------------------------------
-- ScreenGui
--------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UtopiaHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

--------------------------------------------------------------
-- Main Frame
--------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, CONFIG.WINDOW_WIDTH, 0, CONFIG.WINDOW_HEIGHT)
mainFrame.Position = UDim2.new(0.5, -CONFIG.WINDOW_WIDTH / 2, 0.5, -CONFIG.WINDOW_HEIGHT / 2)
mainFrame.BackgroundColor3 = CONFIG.BG_SECONDARY
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
addCorner(mainFrame, CONFIG.CORNER_RADIUS_LG)
addStroke(mainFrame, CONFIG.BORDER, 1, 0.7)

-- Drop shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 50, 1, 50)
shadow.Position = UDim2.new(0, -25, 0, -25)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.4
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = -1
shadow.Parent = mainFrame

--------------------------------------------------------------
-- Opening Animation
--------------------------------------------------------------
mainFrame.BackgroundTransparency = 1
mainFrame.Size = UDim2.new(0, CONFIG.WINDOW_WIDTH * 0.85, 0, CONFIG.WINDOW_HEIGHT * 0.85)
mainFrame.Position = UDim2.new(0.5, -(CONFIG.WINDOW_WIDTH * 0.85) / 2, 0.5, -(CONFIG.WINDOW_HEIGHT * 0.85) / 2)

task.defer(function()
    tween(blur, { Size = 12 }, 0.5)
    tween(mainFrame, {
        BackgroundTransparency = 0,
        Size = UDim2.new(0, CONFIG.WINDOW_WIDTH, 0, CONFIG.WINDOW_HEIGHT),
        Position = UDim2.new(0.5, -CONFIG.WINDOW_WIDTH / 2, 0.5, -CONFIG.WINDOW_HEIGHT / 2),
    }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

--------------------------------------------------------------
-- Dragging
--------------------------------------------------------------
local dragging, dragInput, dragStart, startPos

local function onDragBegin(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end

local function onDragUpdate(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

--------------------------------------------------------------
-- Title Bar
--------------------------------------------------------------
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = CONFIG.BG_SECONDARY
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Drag from title bar
titleBar.InputBegan:Connect(onDragBegin)
titleBar.InputChanged:Connect(onDragUpdate)

-- Title accent line
local accentLine = Instance.new("Frame")
accentLine.Name = "AccentLine"
accentLine.Size = UDim2.new(1, 0, 0, 1)
accentLine.Position = UDim2.new(0, 0, 1, -1)
accentLine.BackgroundColor3 = CONFIG.ACCENT
accentLine.BackgroundTransparency = 0.7
accentLine.BorderSizePixel = 0
accentLine.Parent = titleBar

-- Hub Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Utopiahub.net"
titleLabel.TextColor3 = CONFIG.TEXT_PRIMARY
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Version badge
local versionBadge = Instance.new("TextLabel")
versionBadge.Name = "Version"
versionBadge.Size = UDim2.new(0, 46, 0, 18)
versionBadge.Position = UDim2.new(0, 130, 0.5, -9)
versionBadge.BackgroundColor3 = CONFIG.ACCENT
versionBadge.BackgroundTransparency = 0.8
versionBadge.Font = Enum.Font.GothamMedium
versionBadge.Text = "v1.0.0"
versionBadge.TextColor3 = CONFIG.ACCENT_GLOW
versionBadge.TextSize = 10
versionBadge.Parent = titleBar
addCorner(versionBadge, CONFIG.CORNER_RADIUS_SM)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -38, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.BackgroundTransparency = 0.85
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 13
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar
addCorner(closeBtn, UDim.new(0, 8))

closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, { BackgroundTransparency = 0.5 }, CONFIG.TWEEN_FAST)
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, { BackgroundTransparency = 0.85 }, CONFIG.TWEEN_FAST)
end)
closeBtn.MouseButton1Click:Connect(function()
    tween(mainFrame, {
        Size = UDim2.new(0, CONFIG.WINDOW_WIDTH * 0.85, 0, CONFIG.WINDOW_HEIGHT * 0.85),
        Position = UDim2.new(0.5, -(CONFIG.WINDOW_WIDTH * 0.85) / 2, 0.5, -(CONFIG.WINDOW_HEIGHT * 0.85) / 2),
        BackgroundTransparency = 1,
    }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(blur, { Size = 0 }, 0.4)
    task.delay(0.45, function()
        screenGui:Destroy()
        blur:Destroy()
    end)
end)

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Name = "Minimize"
minBtn.Size = UDim2.new(0, 32, 0, 32)
minBtn.Position = UDim2.new(1, -74, 0.5, -16)
minBtn.BackgroundColor3 = CONFIG.TEXT_DIM
minBtn.BackgroundTransparency = 0.85
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "-"
minBtn.TextColor3 = CONFIG.TEXT_SECONDARY
minBtn.TextSize = 18
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
minBtn.Parent = titleBar
addCorner(minBtn, UDim.new(0, 8))

local minimized = false
minBtn.MouseEnter:Connect(function()
    tween(minBtn, { BackgroundTransparency = 0.5 }, CONFIG.TWEEN_FAST)
end)
minBtn.MouseLeave:Connect(function()
    tween(minBtn, { BackgroundTransparency = 0.85 }, CONFIG.TWEEN_FAST)
end)
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        tween(mainFrame, {
            Size = UDim2.new(0, CONFIG.WINDOW_WIDTH, 0, 38),
        }, CONFIG.TWEEN_SPEED)
    else
        tween(mainFrame, {
            Size = UDim2.new(0, CONFIG.WINDOW_WIDTH, 0, CONFIG.WINDOW_HEIGHT),
        }, CONFIG.TWEEN_SPEED)
    end
end)

--------------------------------------------------------------
-- Body (Below Title Bar)
--------------------------------------------------------------
local body = Instance.new("Frame")
body.Name = "Body"
body.Size = UDim2.new(1, 0, 1, -38)
body.Position = UDim2.new(0, 0, 0, 38)
body.BackgroundTransparency = 1
body.BorderSizePixel = 0
body.ClipsDescendants = true
body.Parent = mainFrame

--------------------------------------------------------------
-- Sidebar
--------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, CONFIG.SIDEBAR_WIDTH, 1, 0)
sidebar.BackgroundColor3 = CONFIG.BG_SECONDARY
sidebar.BorderSizePixel = 0
sidebar.Parent = body

-- Sidebar divider
local sidebarDivider = Instance.new("Frame")
sidebarDivider.Name = "Divider"
sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
sidebarDivider.Position = UDim2.new(1, 0, 0, 0)
sidebarDivider.BackgroundColor3 = CONFIG.BORDER
sidebarDivider.BackgroundTransparency = 0.5
sidebarDivider.BorderSizePixel = 0
sidebarDivider.Parent = sidebar

-- Tab indicator (animated bar)
local tabIndicator = Instance.new("Frame")
tabIndicator.Name = "Indicator"
tabIndicator.Size = UDim2.new(0, 3, 0, 28)
tabIndicator.Position = UDim2.new(0, 0, 0, 16)
tabIndicator.BackgroundColor3 = CONFIG.ACCENT
tabIndicator.BorderSizePixel = 0
tabIndicator.Parent = sidebar
addCorner(tabIndicator, UDim.new(0, 2))

--------------------------------------------------------------
-- Tab Buttons
--------------------------------------------------------------
local TABS = {
    { Name = "Home",    Icon = "🏠", Order = 1 },
    { Name = "Discord", Icon = "🌐", Order = 2 },
    { Name = "Info",    Icon = "ℹ",  Order = 3 },
}

local tabButtons = {}
local tabPages = {}
local currentTab = "Home"

for i, tabData in ipairs(TABS) do
    local btn = Instance.new("TextButton")
    btn.Name = tabData.Name .. "Tab"
    btn.Size = UDim2.new(1, -8, 0, 40)
    btn.Position = UDim2.new(0, 4, 0, 8 + (i - 1) * 46)
    btn.BackgroundColor3 = CONFIG.ACCENT
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.GothamMedium
    btn.Text = tabData.Icon
    btn.TextColor3 = (i == 1) and CONFIG.ACCENT_GLOW or CONFIG.TEXT_DIM
    btn.TextSize = 20
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = sidebar
    addCorner(btn, CONFIG.CORNER_RADIUS_SM)

    if i == 1 then
        btn.BackgroundTransparency = 0.85
    end

    tabButtons[tabData.Name] = btn
end

--------------------------------------------------------------
-- Content Area
--------------------------------------------------------------
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -(CONFIG.SIDEBAR_WIDTH + 1), 1, 0)
content.Position = UDim2.new(0, CONFIG.SIDEBAR_WIDTH + 1, 0, 0)
content.BackgroundColor3 = CONFIG.BG_PRIMARY
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.Parent = body

--------------------------------------------------------------
-- HOME TAB PAGE
--------------------------------------------------------------
local homePage = Instance.new("Frame")
homePage.Name = "HomePage"
homePage.Size = UDim2.new(1, 0, 1, 0)
homePage.BackgroundTransparency = 1
homePage.BorderSizePixel = 0
homePage.Parent = content
tabPages["Home"] = homePage

-- Search Bar
local searchContainer = Instance.new("Frame")
searchContainer.Name = "SearchContainer"
searchContainer.Size = UDim2.new(1, -28, 0, 38)
searchContainer.Position = UDim2.new(0, 14, 0, 12)
searchContainer.BackgroundColor3 = CONFIG.SEARCH_BG
searchContainer.BorderSizePixel = 0
searchContainer.Parent = homePage
addCorner(searchContainer, CONFIG.CORNER_RADIUS)
addStroke(searchContainer, CONFIG.BORDER, 1, 0.6)

local searchIcon = Instance.new("TextLabel")
searchIcon.Name = "SearchIcon"
searchIcon.Size = UDim2.new(0, 34, 1, 0)
searchIcon.Position = UDim2.new(0, 0, 0, 0)
searchIcon.BackgroundTransparency = 1
searchIcon.Font = Enum.Font.GothamMedium
searchIcon.Text = "🔍"
searchIcon.TextColor3 = CONFIG.TEXT_DIM
searchIcon.TextSize = 14
searchIcon.Parent = searchContainer

local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(1, -40, 1, 0)
searchBox.Position = UDim2.new(0, 36, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.Font = Enum.Font.GothamMedium
searchBox.PlaceholderText = "Search scripts..."
searchBox.PlaceholderColor3 = CONFIG.TEXT_DIM
searchBox.Text = ""
searchBox.TextColor3 = CONFIG.TEXT_PRIMARY
searchBox.TextSize = 13
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false
searchBox.Parent = searchContainer

searchBox.Focused:Connect(function()
    tween(searchContainer, { BackgroundColor3 = Color3.fromRGB(34, 34, 52) }, CONFIG.TWEEN_FAST)
    local s = searchContainer:FindFirstChildOfClass("UIStroke")
    if s then tween(s, { Color = CONFIG.ACCENT_DIM, Transparency = 0.3 }, CONFIG.TWEEN_FAST) end
end)
searchBox.FocusLost:Connect(function()
    tween(searchContainer, { BackgroundColor3 = CONFIG.SEARCH_BG }, CONFIG.TWEEN_FAST)
    local s = searchContainer:FindFirstChildOfClass("UIStroke")
    if s then tween(s, { Color = CONFIG.BORDER, Transparency = 0.6 }, CONFIG.TWEEN_FAST) end
end)

-- Scrolling Frame for Script Cards
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScriptScroll"
scrollFrame.Size = UDim2.new(1, -14, 1, -64)
scrollFrame.Position = UDim2.new(0, 7, 0, 58)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = CONFIG.ACCENT_DIM
scrollFrame.ScrollBarImageTransparency = 0.4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = homePage

local gridLayout = Instance.new("UIGridLayout")
gridLayout.Name = "Grid"
gridLayout.CellSize = CONFIG.CARD_SIZE
gridLayout.CellPadding = UDim2.new(0, 12, 0, 12)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
gridLayout.Parent = scrollFrame

local gridPadding = Instance.new("UIPadding")
gridPadding.PaddingLeft = UDim.new(0, 7)
gridPadding.PaddingTop = UDim.new(0, 4)
gridPadding.PaddingRight = UDim.new(0, 7)
gridPadding.PaddingBottom = UDim.new(0, 12)
gridPadding.Parent = scrollFrame

--------------------------------------------------------------
-- Script Card Builder
--------------------------------------------------------------
local scriptCards = {}

local function createScriptCard(data, order)
    local card = Instance.new("Frame")
    card.Name = data.Name .. "_Card"
    card.BackgroundColor3 = CONFIG.BG_CARD
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.ClipsDescendants = true
    card.Parent = scrollFrame
    addCorner(card, CONFIG.CORNER_RADIUS)
    local cardStroke = addStroke(card, CONFIG.BORDER, 1, 0.6)

    if data.IsNew then
        cardStroke.Color = CONFIG.ACCENT
        cardStroke.Transparency = 0.35
    end

    -- Inner glow gradient (top) – no UICorner, card clips it
    local glowTop = Instance.new("Frame")
    glowTop.Name = "GlowTop"
    glowTop.Size = UDim2.new(1, 0, 0, 60)
    glowTop.BackgroundColor3 = data.IsNew and CONFIG.ACCENT or CONFIG.BG_TERTIARY
    glowTop.BackgroundTransparency = data.IsNew and 0.88 or 0.92
    glowTop.BorderSizePixel = 0
    glowTop.Parent = card

    -- Game Image
    local imageHolder = Instance.new("ImageLabel")
    imageHolder.Name = "ImageHolder"
    imageHolder.Size = UDim2.new(0, 80, 0, 80)
    imageHolder.Position = UDim2.new(0.5, -40, 0, 16)
    imageHolder.BackgroundColor3 = CONFIG.BG_TERTIARY
    imageHolder.BorderSizePixel = 0
    imageHolder.ClipsDescendants = true
    imageHolder.ScaleType = Enum.ScaleType.Crop
    imageHolder.Image = ""
    imageHolder.Parent = card
    addCorner(imageHolder, UDim.new(0, 12))
    addStroke(imageHolder, CONFIG.BORDER, 1, 0.5)

    -- Load thumbnail image
    task.spawn(function()
        local imageUrl = data.StaticThumb or fetchThumbnail(data.PlaceId)
        if imageUrl and imageHolder and imageHolder.Parent then
            loadImageAsync(imageHolder, imageUrl, data.PlaceId)
        end
    end)

    -- NEW badge
    if data.IsNew then
        local newBadge = Instance.new("Frame")
        newBadge.Name = "NewBadge"
        newBadge.Size = UDim2.new(0, 40, 0, 18)
        newBadge.Position = UDim2.new(1, -48, 0, 8)
        newBadge.BackgroundColor3 = CONFIG.NEW_BADGE
        newBadge.BorderSizePixel = 0
        newBadge.Parent = card
        addCorner(newBadge, CONFIG.CORNER_RADIUS_SM)

        local newLabel = Instance.new("TextLabel")
        newLabel.Size = UDim2.new(1, 0, 1, 0)
        newLabel.BackgroundTransparency = 1
        newLabel.Font = Enum.Font.GothamBold
        newLabel.Text = "NEW"
        newLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        newLabel.TextSize = 9
        newLabel.Parent = newBadge

        -- Pulse animation on NEW badge
        task.spawn(function()
            while newBadge and newBadge.Parent do
                tween(newBadge, { BackgroundTransparency = 0.3 }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(1)
                tween(newBadge, { BackgroundTransparency = 0 }, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(1)
            end
        end)
    end

    -- Game Name
    local gameName = Instance.new("TextLabel")
    gameName.Name = "GameName"
    gameName.Size = UDim2.new(1, -16, 0, 20)
    gameName.Position = UDim2.new(0, 8, 0, 104)
    gameName.BackgroundTransparency = 1
    gameName.Font = Enum.Font.GothamBold
    gameName.Text = data.Name
    gameName.TextColor3 = CONFIG.TEXT_PRIMARY
    gameName.TextSize = 13
    gameName.TextTruncate = Enum.TextTruncate.AtEnd
    gameName.TextXAlignment = Enum.TextXAlignment.Center
    gameName.Parent = card

    -- Place ID
    local placeIdLabel = Instance.new("TextLabel")
    placeIdLabel.Name = "PlaceId"
    placeIdLabel.Size = UDim2.new(1, -16, 0, 16)
    placeIdLabel.Position = UDim2.new(0, 8, 0, 124)
    placeIdLabel.BackgroundTransparency = 1
    placeIdLabel.Font = Enum.Font.Gotham
    placeIdLabel.Text = "ID: " .. data.PlaceId
    placeIdLabel.TextColor3 = CONFIG.TEXT_DIM
    placeIdLabel.TextSize = 10
    placeIdLabel.TextXAlignment = Enum.TextXAlignment.Center
    placeIdLabel.Parent = card

    -- Separator line
    local sep = Instance.new("Frame")
    sep.Name = "Separator"
    sep.Size = UDim2.new(0.7, 0, 0, 1)
    sep.Position = UDim2.new(0.15, 0, 0, 150)
    sep.BackgroundColor3 = CONFIG.BORDER
    sep.BackgroundTransparency = 0.5
    sep.BorderSizePixel = 0
    sep.Parent = card

    -- Load Script Button
    local loadBtn = Instance.new("TextButton")
    loadBtn.Name = "LoadButton"
    loadBtn.Size = UDim2.new(0.78, 0, 0, 36)
    loadBtn.Position = UDim2.new(0.11, 0, 0, 164)
    loadBtn.BackgroundColor3 = CONFIG.ACCENT
    loadBtn.BorderSizePixel = 0
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.Text = "Load Script"
    loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadBtn.TextSize = 12
    loadBtn.AutoButtonColor = false
    loadBtn.Parent = card
    addCorner(loadBtn, CONFIG.CORNER_RADIUS_SM)

    -- Button gradient
    addGradient(loadBtn, CONFIG.BUTTON_GRADIENT_START, CONFIG.BUTTON_GRADIENT_END, 90)

    -- Button glow stroke
    local btnStroke = addStroke(loadBtn, CONFIG.ACCENT_GLOW, 1, 0.6)

    -- Spacer text below button
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(1, -8, 0, 16)
    statusLabel.Position = UDim2.new(0, 4, 0, 206)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = ""
    statusLabel.TextColor3 = CONFIG.ACCENT_GLOW
    statusLabel.TextSize = 9
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = card

    -- Button Hover
    loadBtn.MouseEnter:Connect(function()
        tween(loadBtn, { BackgroundColor3 = CONFIG.ACCENT_GLOW }, CONFIG.TWEEN_FAST)
        tween(btnStroke, { Transparency = 0.2 }, CONFIG.TWEEN_FAST)
    end)
    loadBtn.MouseLeave:Connect(function()
        tween(loadBtn, { BackgroundColor3 = CONFIG.ACCENT }, CONFIG.TWEEN_FAST)
        tween(btnStroke, { Transparency = 0.6 }, CONFIG.TWEEN_FAST)
    end)

    -- Button Click
    loadBtn.MouseButton1Click:Connect(function()
        -- Click scale animation
        tween(loadBtn, { Size = UDim2.new(0.72, 0, 0, 33) }, 0.08)
        task.wait(0.08)
        tween(loadBtn, { Size = UDim2.new(0.78, 0, 0, 36) }, 0.15, Enum.EasingStyle.Back)

        -- Show loading state
        loadBtn.Text = "Loading..."
        statusLabel.Text = "Loading..."
        tween(statusLabel, { TextTransparency = 0 }, CONFIG.TWEEN_FAST)
        print("[UtopiaHub] Loading script for: " .. data.Name .. " (PlaceID: " .. data.PlaceId .. ")")

        -- Extract the URL and fetch the script source first
        local scriptUrl = data.Script:match('"(.-)"')
        local fetchSuccess, scriptSource = pcall(function()
            return game:HttpGet(scriptUrl, true)
        end)

        if fetchSuccess and scriptSource then
            statusLabel.Text = "✓ Loaded"
            print("[UtopiaHub] Successfully loaded: " .. data.Name)

            -- Spawn the script in a separate thread so it doesn't block UI closing
            task.spawn(function()
                local fn, compileErr = loadstring(scriptSource)
                if fn then
                    fn()
                else
                    warn("[UtopiaHub] Compile error for " .. data.Name .. ": " .. tostring(compileErr))
                end
            end)

            -- Close and destroy the UI permanently (same as X button)
            tween(mainFrame, {
                Size = UDim2.new(0, CONFIG.WINDOW_WIDTH * 0.85, 0, CONFIG.WINDOW_HEIGHT * 0.85),
                Position = UDim2.new(0.5, -(CONFIG.WINDOW_WIDTH * 0.85) / 2, 0.5, -(CONFIG.WINDOW_HEIGHT * 0.85) / 2),
                BackgroundTransparency = 1,
            }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            tween(blur, { Size = 0 }, 0.4)
            task.delay(0.45, function()
                screenGui:Destroy()
                blur:Destroy()
            end)
        else
            statusLabel.Text = "✗ Failed to load"
            loadBtn.Text = "Load Script"
            warn("[UtopiaHub] Failed to load " .. data.Name .. ": " .. tostring(scriptSource))
            task.wait(2)
            tween(statusLabel, { TextTransparency = 1 }, CONFIG.TWEEN_SPEED)
            task.wait(CONFIG.TWEEN_SPEED)
            statusLabel.Text = ""
            statusLabel.TextTransparency = 0
        end
    end)

    -- Card Hover Animation
    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            tween(card, { BackgroundColor3 = CONFIG.BG_CARD_HOVER }, CONFIG.TWEEN_FAST)
            tween(cardStroke, { Transparency = 0.2 }, CONFIG.TWEEN_FAST)
        end
    end)
    card.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            tween(card, { BackgroundColor3 = CONFIG.BG_CARD }, CONFIG.TWEEN_FAST)
            tween(cardStroke, { Transparency = data.IsNew and 0.35 or 0.6 }, CONFIG.TWEEN_FAST)
        end
    end)

    scriptCards[data.Name] = card
    return card
end

-- Create all script cards
for i, scriptData in ipairs(SCRIPTS) do
    createScriptCard(scriptData, i)
end

--------------------------------------------------------------
-- Live Search Filter
--------------------------------------------------------------
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(searchBox.Text)
    for name, card in pairs(scriptCards) do
        local visible = query == "" or string.find(string.lower(name), query, 1, true)
        card.Visible = visible ~= nil
    end
end)

--------------------------------------------------------------
-- DISCORD TAB PAGE
--------------------------------------------------------------
local discordPage = Instance.new("Frame")
discordPage.Name = "DiscordPage"
discordPage.Size = UDim2.new(1, 0, 1, 0)
discordPage.BackgroundTransparency = 1
discordPage.BorderSizePixel = 0
discordPage.Visible = false
discordPage.Parent = content
tabPages["Discord"] = discordPage

-- Discord content container
local discordContainer = Instance.new("Frame")
discordContainer.Name = "Container"
discordContainer.Size = UDim2.new(0, 320, 0, 280)
discordContainer.Position = UDim2.new(0.5, -160, 0.5, -140)
discordContainer.BackgroundColor3 = CONFIG.BG_CARD
discordContainer.BorderSizePixel = 0
discordContainer.Parent = discordPage
addCorner(discordContainer, CONFIG.CORNER_RADIUS)
addStroke(discordContainer, CONFIG.BORDER, 1, 0.5)

-- Discord icon
local discordIcon = Instance.new("TextLabel")
discordIcon.Name = "Icon"
discordIcon.Size = UDim2.new(1, 0, 0, 60)
discordIcon.Position = UDim2.new(0, 0, 0, 28)
discordIcon.BackgroundTransparency = 1
discordIcon.Font = Enum.Font.GothamBold
discordIcon.Text = "🌐"
discordIcon.TextColor3 = CONFIG.DISCORD_COLOR
discordIcon.TextSize = 42
discordIcon.Parent = discordContainer

-- Discord title
local discordTitle = Instance.new("TextLabel")
discordTitle.Name = "Title"
discordTitle.Size = UDim2.new(1, 0, 0, 28)
discordTitle.Position = UDim2.new(0, 0, 0, 94)
discordTitle.BackgroundTransparency = 1
discordTitle.Font = Enum.Font.GothamBold
discordTitle.Text = "Join Our Discord"
discordTitle.TextColor3 = CONFIG.TEXT_PRIMARY
discordTitle.TextSize = 18
discordTitle.Parent = discordContainer

-- Discord description
local discordDesc = Instance.new("TextLabel")
discordDesc.Name = "Description"
discordDesc.Size = UDim2.new(1, -40, 0, 40)
discordDesc.Position = UDim2.new(0, 20, 0, 126)
discordDesc.BackgroundTransparency = 1
discordDesc.Font = Enum.Font.Gotham
discordDesc.Text = "Get updates, support, and exclusive scripts by joining the Utopiahub community."
discordDesc.TextColor3 = CONFIG.TEXT_SECONDARY
discordDesc.TextSize = 12
discordDesc.TextWrapped = true
discordDesc.Parent = discordContainer

-- Discord button
local discordBtn = Instance.new("TextButton")
discordBtn.Name = "JoinButton"
discordBtn.Size = UDim2.new(0, 220, 0, 44)
discordBtn.Position = UDim2.new(0.5, -110, 0, 186)
discordBtn.BackgroundColor3 = CONFIG.DISCORD_COLOR
discordBtn.BorderSizePixel = 0
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Text = "📋  Copy Discord Link"
discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
discordBtn.TextSize = 14
discordBtn.AutoButtonColor = false
discordBtn.Parent = discordContainer
addCorner(discordBtn, CONFIG.CORNER_RADIUS)
addStroke(discordBtn, Color3.fromRGB(110, 125, 255), 1, 0.5)

discordBtn.MouseEnter:Connect(function()
    tween(discordBtn, { BackgroundColor3 = Color3.fromRGB(108, 121, 255) }, CONFIG.TWEEN_FAST)
end)
discordBtn.MouseLeave:Connect(function()
    tween(discordBtn, { BackgroundColor3 = CONFIG.DISCORD_COLOR }, CONFIG.TWEEN_FAST)
end)
discordBtn.MouseButton1Click:Connect(function()
    -- Click animation
    tween(discordBtn, { Size = UDim2.new(0, 210, 0, 41) }, 0.08)
    task.wait(0.08)
    tween(discordBtn, { Size = UDim2.new(0, 220, 0, 44) }, 0.15, Enum.EasingStyle.Back)

    -- Copy Discord link to clipboard
    pcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/5qH4kYan9m")
        elseif toclipboard then
            toclipboard("https://discord.gg/5qH4kYan9m")
        end
    end)

    discordBtn.Text = "Copied!"
    task.wait(2)
    discordBtn.Text = "Copy Discord Link"
end)

--------------------------------------------------------------
-- INFO TAB PAGE
--------------------------------------------------------------
local infoPage = Instance.new("Frame")
infoPage.Name = "InfoPage"
infoPage.Size = UDim2.new(1, 0, 1, 0)
infoPage.BackgroundTransparency = 1
infoPage.BorderSizePixel = 0
infoPage.Visible = false
infoPage.Parent = content
tabPages["Info"] = infoPage

-- Info scroll
local infoScroll = Instance.new("ScrollingFrame")
infoScroll.Name = "InfoScroll"
infoScroll.Size = UDim2.new(1, -28, 1, -24)
infoScroll.Position = UDim2.new(0, 14, 0, 12)
infoScroll.BackgroundTransparency = 1
infoScroll.BorderSizePixel = 0
infoScroll.ScrollBarThickness = 3
infoScroll.ScrollBarImageColor3 = CONFIG.ACCENT_DIM
infoScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
infoScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
infoScroll.Parent = infoPage

local infoLayout = Instance.new("UIListLayout")
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
infoLayout.Padding = UDim.new(0, 12)
infoLayout.Parent = infoScroll

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingTop = UDim.new(0, 4)
infoPadding.PaddingBottom = UDim.new(0, 12)
infoPadding.Parent = infoScroll

-- Helper: Info Section Card
local function createInfoCard(title, description, layoutOrder)
    local card = Instance.new("Frame")
    card.Name = title .. "_Card"
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = CONFIG.BG_CARD
    card.BorderSizePixel = 0
    card.LayoutOrder = layoutOrder
    card.Parent = infoScroll
    addCorner(card, CONFIG.CORNER_RADIUS)
    addStroke(card, CONFIG.BORDER, 1, 0.6)
    addPadding(card, 16, 16, 18, 18)

    local cardLayout = Instance.new("UIListLayout")
    cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cardLayout.Padding = UDim.new(0, 8)
    cardLayout.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 22)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = CONFIG.ACCENT_GLOW
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.LayoutOrder = 1
    titleLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(1, 0, 0, 0)
    descLabel.AutomaticSize = Enum.AutomaticSize.Y
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = description
    descLabel.TextColor3 = CONFIG.TEXT_SECONDARY
    descLabel.TextSize = 12
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.LayoutOrder = 2
    descLabel.Parent = card

    return card
end

createInfoCard("🎮 Utopiahub.net", "A premium, high-end Roblox script hub designed for the best exploiting experience.\nBuilt with clean code, smooth animations, and a modern UI.", 1)
createInfoCard("📦 Version", "v1.0.0 – Initial Release\n\n• 8 supported games\n• Premium dark-themed UI\n• Live search & filtering\n• Smooth tween animations", 2)
createInfoCard("✨ Features", "• Clean dark theme with accent highlights\n• Draggable, minimizable window\n• Animated tab switching\n• Per-game script loading\n• Search bar with live filtering\n• Hover & click animations\n• Background blur effect", 3)
createInfoCard("👥 Credits", "Developed by the Utopiahub Team\n\nUI Design • Script Development • Community\n\nJoin our Discord for updates and support!", 4)
createInfoCard("⚠ Disclaimer", "This script hub is for educational purposes only.\nUse at your own risk. We are not responsible for any bans or consequences.", 5)

--------------------------------------------------------------
-- Tab Switching Logic
--------------------------------------------------------------
local function switchTab(tabName)
    if currentTab == tabName then return end
    currentTab = tabName

    -- Animate pages
    for name, page in pairs(tabPages) do
        if name == tabName then
            page.Visible = true
            -- Fade in from right
            for _, child in ipairs(page:GetChildren()) do
                if child:IsA("GuiObject") then
                    child.Position = child.Position + UDim2.new(0, 20, 0, 0)
                    child.BackgroundTransparency = child.BackgroundTransparency -- maintain
                end
            end
            -- Quick slide in
            for _, child in ipairs(page:GetChildren()) do
                if child:IsA("GuiObject") then
                    tween(child, { Position = child.Position - UDim2.new(0, 20, 0, 0) }, CONFIG.TWEEN_SPEED)
                end
            end
        else
            page.Visible = false
        end
    end

    -- Animate tab buttons
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            tween(btn, { TextColor3 = CONFIG.ACCENT_GLOW, BackgroundTransparency = 0.85 }, CONFIG.TWEEN_SPEED)
        else
            tween(btn, { TextColor3 = CONFIG.TEXT_DIM, BackgroundTransparency = 1 }, CONFIG.TWEEN_SPEED)
        end
    end

    -- Animate indicator
    local targetBtn = tabButtons[tabName]
    if targetBtn then
        tween(tabIndicator, {
            Position = UDim2.new(0, 0, 0, targetBtn.Position.Y.Offset + 6),
        }, CONFIG.TWEEN_SPEED, Enum.EasingStyle.Quart)
    end
end

-- Connect tab buttons
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

--------------------------------------------------------------
-- Toggle Keybind (RightShift to show/hide)
--------------------------------------------------------------
local uiVisible = true
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        if uiVisible then
            mainFrame.Visible = true
            tween(mainFrame, {
                BackgroundTransparency = 0,
                Size = UDim2.new(0, CONFIG.WINDOW_WIDTH, 0, CONFIG.WINDOW_HEIGHT),
                Position = UDim2.new(0.5, -CONFIG.WINDOW_WIDTH / 2, 0.5, -CONFIG.WINDOW_HEIGHT / 2),
            }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            tween(blur, { Size = 12 }, 0.4)
        else
            tween(mainFrame, {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, CONFIG.WINDOW_WIDTH * 0.85, 0, CONFIG.WINDOW_HEIGHT * 0.85),
                Position = UDim2.new(0.5, -(CONFIG.WINDOW_WIDTH * 0.85) / 2, 0.5, -(CONFIG.WINDOW_HEIGHT * 0.85) / 2),
            }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            tween(blur, { Size = 0 }, 0.35)
            task.delay(0.4, function()
                if not uiVisible then
                    mainFrame.Visible = false
                end
            end)
        end
    end
end)

--------------------------------------------------------------
-- Startup notification
--------------------------------------------------------------
print("═══════════════════════════════════════════")
print("   Utopiahub.net v1.0.0 – Loaded! 🚀")
print("   Press RightShift to toggle UI")
print("═══════════════════════════════════════════")

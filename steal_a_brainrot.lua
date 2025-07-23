repeat
    task.wait()
until game:IsLoaded()

--//=================================\\--
--||   Variables you can customize   ||--
--\\=================================//--

local Hub = 'Utopia Hub'
local Hub_Script_ID = '61370fffc2d4efee724d84ffd5aa4031'
local Discord_Invite = 'https://discord.gg/zYq89UmXEj'
local UI_Theme = 'Dark' -- Can be 'Dark', 'Light', 'Nord', 'Solarized' or 'Dracula'

-- Ad-link settings
local Linkvertise_Enabled = true
local Linkvertise_Link = 'https://ads.luarmor.net/get_key?for=Rivals_KEY-xruvyEeDEsqS'

local Lootlabs_Enabled = false
local Lootlabs_Link = ''

--//=================================\\--
--||         Script Loader           ||--
--\\=================================//--

makefolder(Hub)
local key_path = Hub .. '/Key.txt'
script_key = script_key
    or (isfile and isfile(key_path) and readfile(key_path))
    or nil

-- Load UI Library
local UI = loadstring(
    game:HttpGet(
        'https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua'
    )
)()

-- Load Luarmor API
local API = loadstring(
    game:HttpGet('https://sdkAPI-public.luarmor.net/library.lua')
)()

-- Set the script ID directly since we are not checking for different places
API.script_id = Hub_Script_ID

-- Get necessary services and functions
local Cloneref = cloneref or function(instance)
    return instance
end
local Players = Cloneref(game:GetService('Players'))
local HttpService = Cloneref(game:GetService('HttpService'))
local Request = http_request or request or syn.request or http

-- Function to show notifications
local function notify(title, content, duration)
    UI:Notify({ Title = title, Content = content, Duration = duration or 8 })
end

-- Function to check the provided key
local function checkKey(input_key)
    local status = API.check_key(input_key or script_key)
    if status.code == 'KEY_VALID' then
        script_key = input_key or script_key
        writefile(key_path, script_key)
        UI:Destroy()
        API.load_script()
    elseif status.code:find('KEY_') then
        local messages = {
            KEY_HWID_LOCKED = 'Key linked to a different HWID. Please reset it using our bot',
            KEY_INCORRECT = 'Key is incorrect',
            KEY_INVALID = 'Key is invalid',
        }
        notify('Key Check Failed', messages[status.code] or 'Unknown error')
    else
        Players.LocalPlayer:Kick(
            'Key check failed: ' .. status.message .. ' Code: ' .. status.code
        )
    end
end

-- Automatically check key if it was saved previously
if script_key then
    checkKey()
end

-- Create the main UI window
local Window = UI:CreateWindow({
    Title = Hub,
    SubTitle = 'Loader',
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 320),
    Acrylic = false,
    Theme = UI_Theme,
    MinimizeKey = Enum.KeyCode.End,
})

-- Add the main tab
local Tabs = { Main = Window:AddTab({ Title = 'Key', Icon = '' }) }

-- Add the key input field
local Input = Tabs.Main:AddInput('Key', {
    Title = 'Enter Key:',
    Default = script_key or '',
    Placeholder = 'Example: agKhRikQP..',
    Numeric = false,
    Finished = false,
})

-- Add "Get Key" button for Linkvertise if enabled
if Linkvertise_Enabled then
    Tabs.Main:AddButton({
        Title = 'Get Key (Linkvertise)',
        Callback = function()
            setclipboard(Linkvertise_Link)
            notify(
                'Copied To Clipboard',
                'Ad Reward Link has been copied to your clipboard',
                16
            )
        end,
    })
end

-- Add "Get Key" button for Lootlabs if enabled
if Lootlabs_Enabled then
    Tabs.Main:AddButton({
        Title = 'Get Key (Lootlabs)',
        Callback = function()
            setclipboard(Lootlabs_Link)
            notify(
                'Copied To Clipboard',
                'Ad Reward Link has been copied to your clipboard',
                16
            )
        end,
    })
end

-- Add the button to check the key
Tabs.Main:AddButton({
    Title = 'Check Key',
    Callback = function()
        checkKey(Input.Value)
    end,
})

-- Add the button to join the Discord server
Tabs.Main:AddButton({
    Title = 'Join Discord',
    Callback = function()
        setclipboard(Discord_Invite)
        notify(
            'Copied To Clipboard',
            'Discord Server Link has been copied to your clipboard',
            16
        )
        -- Attempt to open Discord invite via local RPC
        Request({
            Url = 'http://127.0.0.1:6463/rpc?v=1',
            Method = 'POST',
            Headers = {
                ['Content-Type'] = 'application/json',
                ['origin'] = 'https://discord.com',
            },
            Body = HttpService:JSONEncode({
                args = { code = Discord_Invite },
                cmd = 'INVITE_BROWSER',
                nonce = '.',
            }),
        })
    end,
})

-- Finalize UI setup
Window:SelectTab(1)
notify(Hub, 'Loader Has Loaded Successfully')

-- HEllOW WOLRD ("print")





local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LieaBloxSoundExplorer"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
local outerFrame = Instance.new("Frame")
outerFrame.Size = UDim2.new(0, 560, 0, 610)
outerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
outerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
outerFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
outerFrame.BorderSizePixel = 0
outerFrame.Parent = screenGui
local outerCorner = Instance.new("UICorner")
outerCorner.CornerRadius = UDim.new(0, 10)
outerCorner.Parent = outerFrame
local rainbowHue = 0
task.spawn(function()
    while true do
        rainbowHue = (rainbowHue + 0.005) % 1
        outerFrame.BackgroundColor3 = Color3.fromHSV(rainbowHue, 1, 1)
        task.wait()
    end
end)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, -8, 1, -8)
mainFrame.Position = UDim2.new(0, 4, 0, 4)
mainFrame.AnchorPoint = Vector2.new(0, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = outerFrame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(235, 235, 235) 
title.Text = "LieaBlox Sound Explorer"
title.TextColor3 = Color3.fromRGB(20, 20, 20) 
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title
local dragging, dragInput, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = outerFrame.Position 
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        outerFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
local function toggleMinimize()
    local isMinimized = outerFrame.Size.Y.Offset == 45
    if isMinimized then
        outerFrame.Size = UDim2.new(0, 560, 0, 610)
        mainFrame.Size = UDim2.new(1, -8, 1, -8)
        searchBox.Visible = true
        countLabel.Visible = true
        refreshBtn.Visible = true
        downloadAllBtn.Visible = true
        stopBtn.Visible = true
        listFrame.Visible = true
        minimizeBtn.Text = "─"
    else
        outerFrame.Size = UDim2.new(0, 560, 0, 45)
        mainFrame.Size = UDim2.new(1, -8, 1, -8)
        searchBox.Visible = false
        countLabel.Visible = false
        refreshBtn.Visible = false
        downloadAllBtn.Visible = false
        stopBtn.Visible = false
        listFrame.Visible = false
        minimizeBtn.Text = "□"
    end
end
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 2.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = mainFrame
minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0, 180, 0, 28)
searchBox.Position = UDim2.new(0, 10, 0, 45)
searchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
searchBox.TextColor3 = Color3.fromRGB(20, 20, 20)
searchBox.PlaceholderText = "🔍 Search sounds..."
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 13
searchBox.Parent = mainFrame
local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 4)
searchCorner.Parent = searchBox
local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(0, 100, 0, 28)
countLabel.Position = UDim2.new(0, 200, 0, 45)
countLabel.BackgroundTransparency = 1
countLabel.Text = "Loading..."
countLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
countLabel.TextXAlignment = Enum.TextXAlignment.Left
countLabel.Font = Enum.Font.Gotham
countLabel.TextSize = 13
countLabel.Parent = mainFrame
local function makeButton(text, xPos, bgColor, textColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 0, 28)
    btn.Position = UDim2.new(0, xPos, 0, 45)
    btn.BackgroundColor3 = bgColor
    btn.Text = text
    btn.TextColor3 = textColor
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = mainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    return btn
end
local refreshBtn = makeButton("Refresh", 310, Color3.fromRGB(70, 130, 180), Color3.fromRGB(255,255,255))
local downloadAllBtn = makeButton("DL All", 390, Color3.fromRGB(200, 150, 50), Color3.fromRGB(255,255,255))
local stopBtn = makeButton("⏹ Stop", 470, Color3.fromRGB(200, 60, 60), Color3.fromRGB(255,255,255))
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, -10, 1, -105)
listFrame.Position = UDim2.new(0, 5, 0, 80)
listFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
listFrame.BorderSizePixel = 1
listFrame.BorderColor3 = Color3.fromRGB(210, 210, 210)
listFrame.ScrollBarThickness = 6
listFrame.Parent = mainFrame
local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 4)
listCorner.Parent = listFrame
local listLayout = Instance.new("UIListLayout")
listLayout.Parent = listFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 2)
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
local currentPlayingSound = nil
local function getAllSounds()
    local sounds = {}
    local function scan(obj)
        if obj:IsA("Sound") then table.insert(sounds, obj) end
        for _, child in ipairs(obj:GetChildren()) do scan(child) end
    end
    scan(SoundService); scan(Workspace); scan(Players)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then scan(p.Character) end
        scan(p)
    end
    return sounds
end
local function playSoundPreview(soundObj)
    if currentPlayingSound and currentPlayingSound.Parent then
        currentPlayingSound:Destroy(); currentPlayingSound = nil
    end
    local clone = soundObj:Clone()
    clone.Parent = Workspace
    currentPlayingSound = clone
    clone:Play()
    clone.Ended:Connect(function()
        if clone and clone.Parent then clone:Destroy() end
        if currentPlayingSound == clone then currentPlayingSound = nil end
    end)
    task.delay(60, function()
        if clone and clone.Parent then clone:Destroy() end
        if currentPlayingSound == clone then currentPlayingSound = nil end
    end)
end
local function stopAllSounds()
    if currentPlayingSound and currentPlayingSound.Parent then
        currentPlayingSound:Destroy(); currentPlayingSound = nil
    end
end
local function downloadSound(soundObj)
    local id = string.match(soundObj.SoundId, "%d+")
    if not id then return false end
    local success, result = pcall(function()
        return game:GetService("HttpService"):GetAsync("https://assetdelivery.roblox.com/v1/asset/?id=" .. id)
    end)
    if success then
        if not isfolder("sounds") then makefolder("sounds") end
        local fileName = soundObj.Name .. "_" .. id .. ".mp3"
        fileName = fileName:gsub("[^%w%.%-_]", "_")
        writefile("sounds/" .. fileName, result)
        return true
    end
    return false
end
local function createSoundRow(sound, index)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 45)
    row.BackgroundColor3 = index % 2 == 0 and Color3.fromRGB(255,255,255) or Color3.fromRGB(235,235,235)
    row.BorderSizePixel = 0
    row.Parent = listFrame
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0, 160, 1, 0)
    nameLbl.Position = UDim2.new(0, 5, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = sound.Name
    nameLbl.TextColor3 = Color3.fromRGB(20,20,20)
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Font = Enum.Font.Gotham
    nameLbl.TextSize = 13
    nameLbl.Parent = row
    local idLbl = Instance.new("TextLabel")
    idLbl.Size = UDim2.new(0, 140, 1, 0)
    idLbl.Position = UDim2.new(0, 170, 0, 0)
    idLbl.BackgroundTransparency = 1
    local soundId = sound.SoundId
    idLbl.Text = #soundId > 30 and string.sub(soundId, 1, 27).."..." or soundId
    idLbl.TextColor3 = Color3.fromRGB(80,80,80)
    idLbl.TextTruncate = Enum.TextTruncate.AtEnd
    idLbl.TextXAlignment = Enum.TextXAlignment.Left
    idLbl.Font = Enum.Font.Gotham
    idLbl.TextSize = 11
    idLbl.Parent = row
    local function makeRowBtn(text, xPos, bg, txtCol, action)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 50, 0, 25)
        b.Position = UDim2.new(0, xPos, 0.5, -12)
        b.BackgroundColor3 = bg
        b.Text = text
        b.TextColor3 = txtCol
        b.Font = Enum.Font.Gotham
        b.TextSize = 11
        b.Parent = row
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent = b
        b.MouseButton1Click:Connect(action)
        return b
    end
    makeRowBtn("▶ Play", 320, Color3.fromRGB(100, 200, 100), Color3.fromRGB(255,255,255), function()
        playSoundPreview(sound)
    end)
    makeRowBtn("Copy ID", 380, Color3.fromRGB(180,180,180), Color3.fromRGB(20,20,20), function()
        setclipboard(sound.SoundId)
    end)
    makeRowBtn("DL", 440, Color3.fromRGB(100, 150, 200), Color3.fromRGB(255,255,255), function()
        downloadSound(sound)
    end)
end
local allSoundsCache = {}
local function refreshList(filterText)
    filterText = filterText and string.lower(filterText) or ""
    for _, c in ipairs(listFrame:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    allSoundsCache = getAllSounds()
    table.sort(allSoundsCache, function(a,b) return a.Name < b.Name end)
    local visible = 0
    for _, s in ipairs(allSoundsCache) do
        local nameMatch = string.find(string.lower(s.Name), filterText)
        local idMatch = string.find(string.lower(s.SoundId), filterText)
        if filterText == "" or nameMatch or idMatch then
            createSoundRow(s, visible + 1)
            visible = visible + 1
        end
    end
    countLabel.Text = "Showing: " .. visible .. " / " .. #allSoundsCache
end
searchBox:GetPropertyChangedSignal("Text"):Connect(function() refreshList(searchBox.Text) end)
refreshBtn.MouseButton1Click:Connect(function() refreshList(searchBox.Text) end)
stopBtn.MouseButton1Click:Connect(function()
    stopAllSounds()
end)
local dlAllRunning = false
downloadAllBtn.MouseButton1Click:Connect(function()
    if dlAllRunning or #allSoundsCache == 0 then return end
    dlAllRunning = true
    downloadAllBtn.Text = "0/"..#allSoundsCache
    downloadAllBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    for i, s in ipairs(allSoundsCache) do
        downloadSound(s)
        downloadAllBtn.Text = i.."/"..#allSoundsCache
        task.wait(0.1)
    end
    downloadAllBtn.Text = "Done!"
    task.delay(2, function()
        downloadAllBtn.Text = "DL All"
        downloadAllBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
        dlAllRunning = false
    end)
end)
refreshList("")

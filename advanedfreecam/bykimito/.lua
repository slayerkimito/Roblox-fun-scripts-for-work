-- ROBLOX FREECAM SCRIPT (InfiniteYield-style)
-- Controls: WASD to move, SHIFT = up, CTRL = down, Mouse = look, M = toggle

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Configuration
local MOVE_SPEED = 60          -- studs per second
local FAST_MULTIPLIER = 3      -- hold nothing extra for now, adjust if needed
local SENSITIVITY = 0.35       -- mouse look sensitivity

-- State
local freecamEnabled = false
local camCFrame = camera.CFrame
local keysDown = {}

local function setCharacterFrozen(frozen)
    local char = player.Character
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if frozen then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid.AutoRotate = false
        else
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            humanoid.AutoRotate = true
        end
    end

    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not frozen
        end
    end
end

local function startFreecam()
    if freecamEnabled then return end
    freecamEnabled = true

    camCFrame = camera.CFrame
    camera.CameraType = Enum.CameraType.Scriptable

    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false

    setCharacterFrozen(true)

    print("Freecam ENABLED — WASD move, Shift up, Ctrl down, Mouse look, M to exit")
end

local function stopFreecam()
    if not freecamEnabled then return end
    freecamEnabled = false

    camera.CameraType = Enum.CameraType.Custom
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true

    setCharacterFrozen(false)

    print("Freecam DISABLED")
end

local function toggleFreecam()
    if freecamEnabled then
        stopFreecam()
    else
        startFreecam()
    end
end

-- Input tracking
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.M and not gameProcessed then
        toggleFreecam()
        return
    end
    keysDown[input.KeyCode] = true
end)

UserInputService.InputEnded:Connect(function(input)
    keysDown[input.KeyCode] = false
end)

-- Mouse look via delta
UserInputService.InputChanged:Connect(function(input)
    if not freecamEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Delta
        local yaw = -delta.X * SENSITIVITY * 0.01
        local pitch = -delta.Y * SENSITIVITY * 0.01

        local _, currentYaw, currentPitch = camCFrame:ToOrientation()
        -- ToOrientation returns (rx, ry, rz) but easier: rebuild manually

        local pos = camCFrame.Position
        local newLook = camCFrame * CFrame.Angles(0, yaw, 0)
        newLook = newLook * CFrame.Angles(pitch, 0, 0)

        camCFrame = CFrame.new(pos) * (newLook - newLook.Position)

        -- Clamp pitch to avoid flipping
        local lookVector = camCFrame.LookVector
        local maxPitch = math.rad(89)
        local currentPitchAngle = math.asin(math.clamp(lookVector.Y, -1, 1))
        if currentPitchAngle > maxPitch or currentPitchAngle < -maxPitch then
            -- revert pitch change if over-rotated
            camCFrame = CFrame.new(pos) * CFrame.Angles(0, yaw, 0) * (camCFrame - camCFrame.Position)
        end
    end
end)

-- Movement + render update
RunService.RenderStepped:Connect(function(dt)
    if not freecamEnabled then return end

    local moveDir = Vector3.new()
    local lookVector = camCFrame.LookVector
    local rightVector = camCFrame.RightVector

    local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z)
    if flatLook.Magnitude > 0 then
        flatLook = flatLook.Unit
    end

    if keysDown[Enum.KeyCode.W] then
        moveDir = moveDir + flatLook
    end
    if keysDown[Enum.KeyCode.S] then
        moveDir = moveDir - flatLook
    end
    if keysDown[Enum.KeyCode.A] then
        moveDir = moveDir - rightVector
    end
    if keysDown[Enum.KeyCode.D] then
        moveDir = moveDir + rightVector
    end
    if keysDown[Enum.KeyCode.LeftShift] or keysDown[Enum.KeyCode.RightShift] then
        moveDir = moveDir + Vector3.new(0, 1, 0)
    end
    if keysDown[Enum.KeyCode.LeftControl] or keysDown[Enum.KeyCode.RightControl] then
        moveDir = moveDir - Vector3.new(0, 1, 0)
    end

    if moveDir.Magnitude > 0 then
        moveDir = moveDir.Unit
    end

    local speed = MOVE_SPEED
    camCFrame = camCFrame + (moveDir * speed * dt)

    camera.CFrame = camCFrame
end)

-- Re-freeze character if it respawns while freecam is active
player.CharacterAdded:Connect(function()
    if freecamEnabled then
        task.wait(0.5)
        setCharacterFrozen(true)
    end
end)

print("Freecam script loaded. Press M to toggle.")

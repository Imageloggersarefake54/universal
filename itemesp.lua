-- [REX] Universal Item ESP + Nice Menu for Severe

print("✅ [REX] Item ESP with Menu Loading...")

local Camera = workspace.CurrentCamera
local Drawings = {}
local MenuDrawings = {}

local Settings = {
    Enabled = true,
    ShowName = true,
    ShowDistance = true,
    MaxDistance = 500,
}

-- ==================== MENU ====================
local function CreateMenu()
    -- Title
    local title = Drawing.new("Text")
    title.Text = "[REX] Item ESP Menu"
    title.Position = Vector2.new(20, 50)
    title.Size = 18
    title.Color = Color3.fromRGB(0, 255, 150)
    title.Outline = true
    title.Visible = true
    MenuDrawings.Title = title

    -- Status
    local status = Drawing.new("Text")
    status.Text = "ESP: ON"
    status.Position = Vector2.new(20, 80)
    status.Size = 16
    status.Color = Color3.fromRGB(0, 255, 0)
    status.Outline = true
    status.Visible = true
    MenuDrawings.Status = status

    print("Press Right Shift to toggle ESP")
end

CreateMenu()

-- ==================== ESP ====================
local function IsItem(obj)
    if not obj or not obj.Parent then return false end
    if obj:IsA("Tool") then return true end
    local n = obj.Name:lower()
    return n:find("tool") or n:find("gun") or n:find("weapon") or n:find("loot")
        or n:find("chest") or n:find("crate") or n:find("pickup")
end

local function CreateLabel()
    local label = Drawing.new("Text")
    label.Size = 14
    label.Color = Color3.fromRGB(0, 255, 120)
    label.Outline = true
    label.Center = true
    label.Visible = false
    return label
end

-- Main ESP Loop
spawn(function()
    while true do
        if Settings.Enabled then
            MenuDrawings.Status.Text = "ESP: ON"
            MenuDrawings.Status.Color = Color3.fromRGB(0, 255, 0)
        else
            MenuDrawings.Status.Text = "ESP: OFF"
            MenuDrawings.Status.Color = Color3.fromRGB(255, 50, 50)
        end

        for item, label in pairs(Drawings) do
            if not (item and item.Parent) then
                pcall(function() label:Remove() end)
                Drawings[item] = nil
            end
        end

        if Settings.Enabled then
            for _, obj in ipairs(workspace:GetChildren()) do
                if IsItem(obj) then
                    if not Drawings[obj] then
                        Drawings[obj] = CreateLabel()
                    end

                    local label = Drawings[obj]
                    local root = obj:FindFirstChildWhichIsA("BasePart") or obj.PrimaryPart or obj:FindFirstChild("Handle")

                    if root then
                        local success, pos, onScreen = pcall(function()
                            local p = Camera:WorldToScreenPoint(root.Position + Vector3.new(0, 3, 0))
                            return Vector2.new(p.X, p.Y), p.Z >= 0
                        end)

                        if success and onScreen then
                            local text = obj.Name
                            if Settings.ShowDistance then
                                local dist = (Camera.CFrame.Position - root.Position).Magnitude
                                text = text .. string.format(" [%d]", math.floor(dist))
                            end
                            label.Text = text
                            label.Position = pos
                            label.Visible = true
                        else
                            label.Visible = false
                        end
                    end
                end
            end
        end

        task.wait(0.1)
    end
end)

-- Toggle with Right Shift
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Settings.Enabled = not Settings.Enabled
        print("Item ESP: " .. (Settings.Enabled and "ON" or "OFF"))
    end
end)

print("✅ Menu Loaded | Press Right Shift to toggle ESP")

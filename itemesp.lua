-- [REX] Fixed Item ESP + Menu for Severe

print("✅ [REX] Item ESP Loading...")

local Camera = workspace.CurrentCamera
local Drawings = {}

local Settings = {
    Enabled = true,
    MaxDistance = 600,
}

-- ==================== MENU ====================
local title = Drawing.new("Text")
title.Text = "[REX] Item ESP"
title.Position = Vector2.new(20, 40)
title.Size = 18
title.Color = Color3.fromRGB(0, 255, 150)
title.Outline = true
title.Visible = true

local status = Drawing.new("Text")
status.Position = Vector2.new(20, 70)
status.Size = 16
status.Outline = true
status.Visible = true

-- ==================== ESP ====================
local function IsItem(obj)
    if not obj or not obj.Parent then return false end
    if obj:IsA("Tool") then return true end
    local n = obj.Name:lower()
    return n:find("tool") or n:find("gun") or n:find("weapon") or n:find("loot") 
        or n:find("chest") or n:find("crate") or n:find("pickup")
end

local function CreateLabel()
    local l = Drawing.new("Text")
    l.Size = 14
    l.Color = Color3.fromRGB(0, 255, 100)
    l.Outline = true
    l.Center = true
    l.Visible = false
    return l
end

-- Main Loop
spawn(function()
    while true do
        status.Text = Settings.Enabled and "ESP: ON" or "ESP: OFF"
        status.Color = Settings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)

        if Settings.Enabled then
            for _, obj in ipairs(workspace:GetChildren()) do
                if IsItem(obj) and not Drawings[obj] then
                    Drawings[obj] = CreateLabel()
                end
            end

            for item, label in pairs(Drawings) do
                if item and item.Parent then
                    local root = item:FindFirstChildWhichIsA("BasePart") or item.PrimaryPart or item:FindFirstChild("Handle")
                    if root then
                        local dist = (Camera.CFrame.Position - root.Position).Magnitude
                        if dist < Settings.MaxDistance then
                            local success, screenPos, onScreen = pcall(function()
                                local p = Camera:WorldToScreenPoint(root.Position + Vector3.new(0, 3, 0))
                                return Vector2.new(p.X, p.Y), p.Z >= 0
                            end)
                            if success and onScreen then
                                label.Text = item.Name .. string.format(" [%d]", math.floor(dist))
                                label.Position = screenPos
                                label.Visible = true
                            else
                                label.Visible = false
                            end
                        else
                            label.Visible = false
                        end
                    end
                else
                    pcall(function() label:Remove() end)
                    Drawings[item] = nil
                end
            end
        end

        task.wait(0.1)
    end
end)

print("✅ Loaded! Change Settings.Enabled = false to turn off")

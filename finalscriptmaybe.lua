-- [REX] Lost Rooms Item ESP for Severe

print("✅ [REX] Lost Rooms Item ESP Loading...")

local Camera = workspace.CurrentCamera
local Drawings = {}

local Settings = { Enabled = true, MaxDistance = 800 }

-- ==================== MENU ====================
local title = Drawing.new("Text")
title.Text = "[REX] Lost Rooms ESP"
title.Position = Vector2.new(20, 40)
title.Size = 18
title.Color = Color3.fromRGB(0, 255, 180)
title.Outline = true
title.Visible = true

local status = Drawing.new("Text")
status.Position = Vector2.new(20, 70)
status.Size = 16
status.Outline = true
status.Visible = true

-- ==================== ITEM DETECTION ====================
local function IsScrap(obj)
    if not obj or not obj.Parent then return false end
    local name = obj.Name:lower()
    return obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart") and (
        name:find("scrap") or name:find("item") or name:find("metal") or
        name:find("food") or name:find("water") or name:find("gun") or
        name:find("tool") or name:find("box") or name:find("pile")
    )
end

local function CreateLabel()
    local l = Drawing.new("Text")
    l.Size = 15
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
            -- Scan important folders
            local folders = {
                workspace,
                game.ReplicatedFirst:FindFirstChild("Rooms")
            }

            for _, folder in ipairs(folders) do
                if folder then
                    for _, obj in ipairs(folder:GetDescendants()) do
                        if IsScrap(obj) and not Drawings[obj] then
                            Drawings[obj] = CreateLabel()
                        end
                    end
                end
            end

            for item, label in pairs(Drawings) do
                if item and item.Parent then
                    local root = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")
                    if root then
                        local dist = (Camera.CFrame.Position - root.Position).Magnitude
                        if dist < Settings.MaxDistance then
                            local success, screenPos, onScreen = pcall(function()
                                local p = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 2.5, 0))
                                return Vector2.new(p.X, p.Y), p.Z > 0
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

        task.wait(0.12)
    end
end)

print("✅ Loaded for Lost Rooms! Items should now appear.")

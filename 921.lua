-- [REX] Lost Rooms Item ESP - Ultra Safe for Severe

print("✅ [REX] Lost Rooms Item ESP Loading...")

local Camera = workspace:FindFirstChild("CurrentCamera") or workspace.CurrentCamera
local Drawings = {}

local Settings = { Enabled = true, MaxDistance = 800 }

-- Menu
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

local function IsItem(obj)
    if not obj or not obj.Parent then return false end
    local name = obj.Name:lower()
    return name:find("item") or name:find("box") or name:find("scrap") or name:find("metal") 
        or name:find("pile") or name:find("tool") or name:find("gun") or obj:IsA("Tool")
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
        status.Color = Settings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 80, 80)

        if Settings.Enabled and Camera then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if IsItem(obj) and not Drawings[obj] then
                    Drawings[obj] = CreateLabel()
                end
            end

            for item, label in pairs(Drawings) do
                if item and item.Parent then
                    local root = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")
                    if root then
                        local dist = (Camera.CFrame.Position - root.Position).Magnitude
                        if dist < Settings.MaxDistance then
                            local success, screenPos, onScreen = pcall(function()
                                local vec = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 2.5, 0))
                                return Vector2.new(vec.X, vec.Y), vec.Z > 0
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

        task.wait(0.15)
    end
end)

print("✅ Loaded. Look for ItemBox, MetalPile, etc.")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Create = {}
Create.__index = Create

function Create:Blur()
	local blur = Instance.new("BlurEffect")
	blur.Name = "VHSBlur"
	blur.Enabled = false
	blur.Size = 6
	blur.Parent = Lighting

	return blur
end

function Create:ColorCorrection()
	local colorCorrection = Instance.new("ColorCorrectionEffect")
	colorCorrection.Name = "VHSColorCorrection"
	colorCorrection.Contrast = 0.2
	colorCorrection.Enabled = false
	colorCorrection.Saturation = 0.4
	colorCorrection.TintColor = Color3.fromRGB(250, 225, 250)
	colorCorrection.Parent = Lighting

	return colorCorrection
end

function Create:Gui()
	local VHSGui = Instance.new("ScreenGui")
	VHSGui.Name = "VHSGUI"
	VHSGui.DisplayOrder = 100
	VHSGui.Enabled = false
	VHSGui.IgnoreGuiInset = true
	VHSGui.ResetOnSpawn = false
	VHSGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local noise = Instance.new("ImageLabel")
	noise.Name = "Noise"
	noise.Image = "rbxassetid://103196207045886"
	noise.ImageRectSize = Vector2.new(255.47, 187.67)
	noise.ImageTransparency = 0.5
	noise.AnchorPoint = Vector2.new(0.5, 0.5)
	noise.BackgroundTransparency = 1
	noise.Position = UDim2.fromScale(0.5, 0.5)
	noise.Size = UDim2.fromScale(1, 1)
	noise.Visible = false
	noise.ZIndex = 3
	noise.Parent = VHSGui

	local pink = Instance.new("Frame")
	pink.Name = "Pink"
	pink.AnchorPoint = Vector2.new(0, 0.5)
	pink.BackgroundColor3 = Color3.fromRGB(255, 200, 255)
	pink.BackgroundTransparency = 0.75
	pink.Position = UDim2.fromScale(0, 0.5)
	pink.Size = UDim2.new(0, 2, 1, 0)
	pink.Visible = false
	pink.ZIndex = 4
	pink.Parent = VHSGui

	local linesFolder = Instance.new("Folder")
	linesFolder.Name = "Lines"
	linesFolder.Parent = VHSGui

	local lineTemplate = Instance.new("ImageLabel")
	lineTemplate.Name = "LineTemplate"
	lineTemplate.Image = "rbxassetid://80164818592276"
	lineTemplate.ImageTransparency = 0.8
	lineTemplate.BackgroundTransparency = 1
	lineTemplate.Position = UDim2.fromScale(0, 1)
	lineTemplate.Size = UDim2.fromScale(2, 0.1)
	lineTemplate.Visible = false
	lineTemplate.ZIndex = 2
	lineTemplate.Parent = VHSGui

	local presetLines = Instance.new("ImageLabel")
	presetLines.Name = "PresetLines"
	presetLines.Image = "rbxassetid://104308955051295"
	presetLines.ImageTransparency = 0.75
	presetLines.AnchorPoint = Vector2.new(0.5, 0.5)
	presetLines.BackgroundTransparency = 1
	presetLines.Position = UDim2.fromScale(0.5, 0.5)
	presetLines.Size = UDim2.fromScale(1, 1)
	presetLines.Visible = false
	presetLines.ZIndex = 1
	presetLines.Parent = VHSGui

	VHSGui.Parent = PlayerGui
	return VHSGui
end

return Create

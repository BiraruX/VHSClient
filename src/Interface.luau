local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local OFFSETS = {
	NOISE = {
		Vector2.new(0, 0),
		Vector2.new(255.47, 0),
		Vector2.new(510.93, 0),
		Vector2.new(766.40, 0),
		Vector2.new(0, 187.67),
		Vector2.new(255.47, 187.67),
		Vector2.new(510.93, 187.67),
		Vector2.new(766.40, 187.67),
		Vector2.new(0, 375.33),
		Vector2.new(255.47, 375.33),
	},
}
local IMAGES = {
	"rbxassetid://103196207045886",
	"rbxassetid://133243681163212",
	"rbxassetid://80164818592276",
	"rbxassetid://104308955051295",
}
local VHSLocal
local VHSClient
local Interface = {
	Events = {},
}
Interface.__index = Interface

function lerp(a: number, b: number, c: number): number
	return a + c * (b - a)
end

local function preload(contents: string | table)
	if typeof(contents) == "string" then
		contents = { contents }
	end
	ContentProvider:PreloadAsync(contents, function(contentId, status)
		if status == Enum.AssetFetchStatus.Failure then
			print("[VHSClient] Failed to preload", contentId)
			return false
		end
	end)
end

local function setup()
	local Blur
	local ColorCorrection
	local VHSGui

	if VHSLocal.Standalone then
		local Create = require(script.Parent:WaitForChild("Create"))
		Blur = Create:Blur()
		ColorCorrection = Create:ColorCorrection()
		VHSGui = Create:Gui()
	end
	if not Blur then
		Blur = Lighting:WaitForChild("VHSBlur")
	end
	if not VHSGui then
		VHSGui = PlayerGui:WaitForChild("VHSGUI")
	end

	local Noise = VHSGui:WaitForChild("Noise")
	local Pink = VHSGui:WaitForChild("Pink")
	local PresetLines = VHSGui:WaitForChild("PresetLines")

	Interface.Elements = {
		Blur = Blur,
		ColorCorrection = ColorCorrection,
		Gui = {
			Self = VHSGui,
			Noise = Noise,
			Pink = Pink,
			PresetLines = PresetLines,
		},
	}

	preload(IMAGES)

	task.spawn(function()
		while true do
			print(VHSLocal.Enabled)
			if
				not ((VHSLocal.Enabled.Gui.Self and VHSLocal.Enabled.Gui.Noise) and (VHSGui.Enabled and Noise.Visible))
			then
				task.wait(0.05)
				continue
			end

			local noisePosition
			for index, offset in OFFSETS.NOISE do
				if Noise.ImageRectOffset == offset then
					noisePosition = index
					break
				else
					noisePosition = 0
				end
			end
			noisePosition += 1
			if noisePosition > 10 then
				noisePosition = 1
			end
			if Noise.Rotation >= 360 then
				Noise.Rotation = 0
			end

			Noise.Rotation = Noise.Rotation + 180
			Noise.ImageRectOffset = OFFSETS.NOISE[noisePosition]
			task.wait(0.05)
		end
	end)
	task.spawn(function()
		while true do
			task.wait(lerp(1, 2, math.random()))
			if not ((VHSLocal.Enabled.Gui.Self and VHSLocal.Enabled.Gui.Lines) and VHSGui.Enabled) then
				task.wait(0.05)
				continue
			end

			local LinesFolder = VHSGui:WaitForChild("Lines")
			local Line = VHSGui:WaitForChild("LineTemplate"):Clone()
			local LineType = math.random() ^ 4
			local VerticalSize = lerp(0.01, 0.5, LineType)

			Line.Name = "Line"
			Line.Size = UDim2.new(Line.Size.X.Scale, 0, VerticalSize, 0)
			Line.ImageTransparency = lerp(0.7, 0.95, LineType)
			Line.Visible = true
			Line.Parent = LinesFolder

			local Render
			Render = RunService.Heartbeat:Connect(function(DeltaTime)
				local CurrentY = Line.Position.Y.Scale
				CurrentY += -0.25 * DeltaTime
				if CurrentY < -VerticalSize then
					Render:Disconnect()
					Line:Destroy()
					return
				end

				Line.Position = UDim2.new(-math.random(), 0, CurrentY, 0)
			end)
		end
	end)
end

local function setupHooks()
	VHSClient.RemoteEvent.OnClientEvent:Connect(function(name: string, ...)
		local lowerName = name:lower()
		if VHSClient.Events[lowerName] then
			VHSClient.Events[lowerName](...)
		end
	end)

	local events = {
		Blur = true,
		ColorCorrection = true,
		Gui = true,
		Noise = true,
		Pink = true,
		PinkLine = true,
		Lines = true,
		PresetLines = true,
	}

	for event, bool in events do
		if not bool then
			continue
		end

		VHSClient:HandleEvent(event, function()
			VHSClient:Show(event)
		end)
		VHSClient:HandleEvent(event, function()
			VHSClient:Hide(event)
		end)
		VHSClient:HandleEvent(event, function()
			VHSClient:Toggle(event)
		end)
	end
end

function Interface:Get(type: string?)
	if type then
		local lowerType = type:lower()

		if lowerType == "blur" then
			return VHSLocal.Enabled.Blur
		elseif lowerType == "colorcorrection" or lowerType == "color" then
			return VHSLocal.Enabled.ColorCorrection
		elseif lowerType == "gui" then
			return VHSLocal.Enabled.Gui.Self
		elseif lowerType == "noise" then
			return VHSLocal.Enabled.Gui.Noise
		elseif lowerType == "pinkline" or lowerType == "pink" then
			return VHSLocal.Enabled.Gui.Pink
		elseif lowerType == "lines" then
			return VHSLocal.Enabled.Gui.Lines
		elseif lowerType == "presetlines" then
			return VHSLocal.Enabled.Gui.PresetLines
		else
			return false
		end
	end

	return VHSLocal.Enabled
end

function Interface:Set(type: string?, value: boolean)
	if type then
		local lowerType = type:lower()

		if lowerType == "blur" then
			VHSLocal.Enabled.Blur = value
		elseif lowerType == "colorcorrection" or lowerType == "color" then
			VHSLocal.Enabled.ColorCorrection = value
		elseif lowerType == "gui" then
			VHSLocal.Enabled.Gui.Self = value
		elseif lowerType == "noise" then
			VHSLocal.Enabled.Gui.Noise = value
		elseif lowerType == "pinkline" or lowerType == "pink" then
			VHSLocal.Enabled.Gui.Pink = value
		elseif lowerType == "lines" then
			VHSLocal.Enabled.Gui.Lines = value
		elseif lowerType == "presetlines" then
			VHSLocal.Enabled.Gui.PresetLines = value
		else
			return false
		end
	else
		VHSLocal.Enabled.Blur = value
		VHSLocal.Enabled.ColorCorrection = value
		VHSLocal.Enabled.Gui.Self = value
		VHSLocal.Enabled.Gui.Noise = value
		VHSLocal.Enabled.Gui.Pink = value
		VHSLocal.Enabled.Gui.Lines = value
		VHSLocal.Enabled.Gui.PresetLines = value
	end

	Interface.Elements.Blur.Enabled = VHSLocal.Enabled.Blur
	Interface.Elements.ColorCorrection.Enabled = VHSLocal.Enabled.ColorCorrection
	Interface.Elements.Gui.Self.Enabled = VHSLocal.Enabled.Gui.Self
	Interface.Elements.Gui.Noise.Visible = VHSLocal.Enabled.Gui.Noise
	Interface.Elements.Gui.Pink.Visible = VHSLocal.Enabled.Gui.Pink
	Interface.Elements.Gui.PresetLines.Visible = VHSLocal.Enabled.Gui.PresetLines
end

function Interface:Toggle(type: string?)
	if type then
		local lowerType = type:lower()

		if lowerType == "blur" then
			VHSLocal.Enabled.Blur = not VHSLocal.Enabled.Blur
		elseif lowerType == "colorcorrection" or lowerType == "color" then
			VHSLocal.Enabled.ColorCorrection = not VHSLocal.Enabled.ColorCorrection
		elseif lowerType == "gui" then
			VHSLocal.Enabled.Gui.Self = not VHSLocal.Enabled.Gui.Self
		elseif lowerType == "noise" then
			VHSLocal.Enabled.Gui.Noise = not VHSLocal.Enabled.Gui.Noise
		elseif lowerType == "pinkline" or lowerType == "pink" then
			VHSLocal.Enabled.Gui.Pink = not VHSLocal.Enabled.Gui.Pink
		elseif lowerType == "lines" then
			VHSLocal.Enabled.Gui.Lines = not VHSLocal.Enabled.Gui.Lines
		elseif lowerType == "presetlines" then
			VHSLocal.Enabled.Gui.PresetLines = not VHSLocal.Enabled.Gui.PresetLines
		else
			return false
		end
	else
		VHSLocal.Enabled.Blur = not VHSLocal.Enabled.Blur
		VHSLocal.Enabled.ColorCorrection = not VHSLocal.Enabled.ColorCorrection
		VHSLocal.Enabled.Gui.Self = not VHSLocal.Enabled.Gui.Self
		VHSLocal.Enabled.Gui.Noise = not VHSLocal.Enabled.Gui.Noise
		VHSLocal.Enabled.Gui.Pink = not VHSLocal.Enabled.Gui.Pink
		VHSLocal.Enabled.Gui.Lines = not VHSLocal.Enabled.Gui.Lines
		VHSLocal.Enabled.Gui.PresetLines = not VHSLocal.Enabled.Gui.PresetLines
	end

	Interface.Elements.Blur.Enabled = VHSLocal.Enabled.Blur
	Interface.Elements.ColorCorrection.Enabled = VHSLocal.Enabled.ColorCorrection
	Interface.Elements.Gui.Self.Enabled = VHSLocal.Enabled.Gui.Self
	Interface.Elements.Gui.Noise.Visible = VHSLocal.Enabled.Gui.Noise
	Interface.Elements.Gui.Pink.Visible = VHSLocal.Enabled.Gui.Pink
	Interface.Elements.Gui.PresetLines.Visible = VHSLocal.Enabled.Gui.PresetLines
end

function Interface:Init(Client, Local)
	VHSLocal = Local
	VHSClient = Client

	setup()

	if not VHSLocal.Standalone then
		local VHSFolder = ReplicatedStorage:WaitForChild("VHSFolder")
		if not VHSFolder then
			return false
		end

		VHSClient.ReplicatedRoot = VHSFolder
		VHSClient.RemoteEvent = VHSFolder:WaitForChild("RemoteEvent")

		setupHooks()
	end
end

return Interface

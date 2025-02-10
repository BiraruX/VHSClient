local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

if RunService:IsServer() then
	error(
		"[VHSClient] Server scripts cannot require the client library. Please require the server library from the server to use."
	)
end

local VHSLocal = {
	Standalone = if ReplicatedStorage:FindFirstChild("VHSFolder") then false else true,
	Enabled = {
		Blur = false,
		ColorCorrection = false,
		Gui = {
			Self = false,
			Noise = false,
			Pink = false,
			Lines = false,
			PresetLines = false,
		},
	},
}
local VHSClient = {}
VHSClient.__index = VHSClient

local Interface = require(script.Interface)

function VHSClient:Get(type: string?)
	return Interface:Get(type)
end

function VHSClient:Show(type: string?)
	return Interface:Set(type, true)
end

function VHSClient:Hide(type: string?)
	return Interface:Set(type, false)
end

function VHSClient:Toggle(type: string?)
	return Interface:Toggle(type)
end

function VHSClient:HandleEvent(name: string, callback: (...any) -> ())
	if not VHSClient.Standalone then
		return false
	end

	Interface.Events[name:lower()] = callback
end

Interface:Init(VHSClient, VHSLocal)

return VHSClient

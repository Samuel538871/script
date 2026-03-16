-- LocalScript — colocar em StarterGui ou StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local ReGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua"))()

local noclip = false
local tpTool = false

local function getCharacter()
	return Player.Character
end

local function getHumanoid()
	local char = getCharacter()
	if char then
		return char:FindFirstChildOfClass("Humanoid")
	end
end

RunService.Stepped:Connect(function()
	if noclip then
		local char = getCharacter()
		if char then
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end
end)

Mouse.Button1Down:Connect(function()
	if tpTool then
		local char = getCharacter()
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.p + Vector3.new(0,3,0))
		end
	end
end)

local Window = ReGui:TabsWindow({
	Title = "Player Hub",
	Size = UDim2.fromOffset(420,340)
})

local Tabs = {"Player","Menu"}

for _,Name in ipairs(Tabs) do
	local Tab = Window:CreateTab({Name = Name})

	if Name == "Player" then

		Tab:Label({Text = "Player Tools"})

		Tab:Checkbox({
			Value = false,
			Label = "Noclip",
			Callback = function(_,Value)
				noclip = Value
			end
		})

		Tab:Button({
			Text = "Toggle Noclip (button pequeno)",
			Callback = function()
				noclip = not noclip
			end
		})

		Tab:Checkbox({
			Value = false,
			Label = "TP Tool (clicar para teleportar)",
			Callback = function(_,Value)
				tpTool = Value
			end
		})

		Tab:SliderInt({
			Label = "Speed",
			Value = 16,
			Minimum = 8,
			Maximum = 200,
			Callback = function(_,Value)
				local hum = getHumanoid()
				if hum then
					hum.WalkSpeed = Value
				end
			end
		})

		Tab:SliderInt({
			Label = "Jump",
			Value = 50,
			Minimum = 20,
			Maximum = 300,
			Callback = function(_,Value)
				local hum = getHumanoid()
				if hum then
					if hum.UseJumpPower then
						hum.JumpPower = Value
					else
						hum.JumpHeight = Value
					end
				end
			end
		})

	elseif Name == "Menu" then

		Tab:Label({Text = "Menu"})

		Tab:Button({
			Text = "Reset Player",
			Callback = function()
				local hum = getHumanoid()
				if hum then
					hum.Health = 0
				end
			end
		})

	end
end

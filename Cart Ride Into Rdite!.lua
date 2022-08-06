local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
	Name = "Cart Ride Into Rdite!",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "OrionTest",
})

getgenv().CartOn = false
getgenv().SpeedCart = false
getgenv().SpeedValue = 50
getgenv().Notis = true

function MakeNoti(name, content, time)
	OrionLib:MakeNotification({
		Name = name,
		Content = content,
		Image = "rbxassetid://4483345998",
		Time = time,
	})
end

function makecartspeed(Value)
	task.spawn(function()
		while getgenv().SpeedCart do
			if not getgenv().SpeedCart then
				break
			end
			for i, v in pairs(game.Workspace:GetChildren()) do
				if v.Name == "Carts" then
					for _, click in pairs(v:GetDescendants()) do
						if click:IsA("ClickDetector") and click.Parent.Name == "On" then
							if click.Parent.Parent:WaitForChild("Configuration").CarOn.Value == false then
								fireclickdetector(click)
							end
						end
						if click:IsA("ClickDetector") and click.Parent.Name == "Up" then
							if click.Parent.Parent:WaitForChild("Configuration").Speed.Value < Value then
								fireclickdetector(click)
							end
						end
						if click:IsA("ClickDetector") and click.Parent.Name == "Down" then
							if click.Parent.Parent:WaitForChild("Configuration").Speed.Value > Value then
								fireclickdetector(click)
							end
						end
					end
				end
			end
			wait(0.2)
		end
	end)
end

function Turncartsoff()
	task.spawn(function()
		while getgenv().CartOn do
			for i, v in pairs(game.Workspace:GetChildren()) do
				if v.Name == "Carts" then
					for _, click in pairs(v:GetDescendants()) do
						if click:IsA("ClickDetector") and click.Parent.Name == "On" then
							if click.Parent.Parent:WaitForChild("Configuration").CarOn.Value == true then
								fireclickdetector(click)
							end
						end
					end
				end
			end
			wait(0.2)
		end
	end)
end

local MainTab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false,
})

local MiscTab = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false,
})

local player = game.Players.LocalPlayer

OrionLib:MakeNotification({
	Name = "Welcome " .. player.Name .. "!",
	Content = "Made by Grayy#9991",
	Image = "rbxassetid://4483345998",
	Time = 5,
})

local Section = MainTab:AddSection({
	Name = "Carts",
})

MainTab:AddSlider({
	Name = "Carts Speed",
	Min = 0,
	Max = 200,
	Default = 50,
	Color = Color3.fromRGB(255, 255, 255),
	Increment = 5,
	ValueName = "Speed",
	Callback = function(Value)
		getgenv().SpeedValue = Value
	end,
})
local launch = false
MainTab:AddToggle({
	Name = "Loop All The Carts Speed",
	Callback = function(Value)
		if launch then
			getgenv().SpeedCart = Value
			makecartspeed(getgenv().SpeedValue)
		end
		launch = true
	end,
})
MainTab:AddToggle({
	Name = "Loop Carts Off",
	Callback = function(Value)
		getgenv().CartOn = Value
		Turncartsoff()
	end,
})

local Section = MainTab:AddSection({
	Name = "Teleport",
})

local players = {}

for i, v in pairs(game.Players:GetPlayers()) do
	table.insert(players, v.Name)
end

local a

local playerdropdown = MainTab:AddDropdown({
	Name = "Teleport To Player",
	Options = players,
	Callback = function(Value)
		a = v
		task.spawn(function()
			for i, v in pairs(game.Players:GetPlayers()) do
				if v.Name == Value then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
				end
			end
		end)
	end,
})

MiscTab:AddToggle({
	Name = "Player Join/Leave Notifications",
	Default = true,
	Callback = function(Value)
		getgenv().Notis = Value
	end,
})

game.Players.PlayerAdded:Connect(function(plr)
	if getgenv().Notis then
		MakeNoti("Player Joined", plr.Name .. " has joined the game.", 3)
	end
	local players2 = game:GetService("Players"):GetPlayers()
	local playerbackup1 = {}
	for i, v in pairs(players2) do
		table.insert(playerbackup1, v.Name)
		print(playerbackup1[i])
	end
	playerdropdown:Refresh(playerbackup1, true)
end)

game.Players.PlayerRemoving:Connect(function(plr)
	if getgenv().Notis then
		MakeNoti("Player Left", plr.Name .. " has left the game.", 3)
	end
	if table.find(players, plr.Name) then
		local players1 = game:GetService("Players"):GetPlayers()
		table.remove(players1, table.find(players, plr.Name))
		local playerbackup = {}
		for i, v in pairs(players) do
			table.insert(playerbackup, v)
		end
		playerdropdown:Refresh(playerbackup, true)
	end
end)

MainTab:AddButton({
	Name = "Teleport To End",
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
			CFrame.new(311.1185607910156, 852.7978515625, 321.91143798828125)
	end,
})

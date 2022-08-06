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
	Name = "Set All the Carts Speed",
	Callback = function(Value)
		if launch then
			getgenv().SpeedCart = Value
			makecartspeed(getgenv().SpeedValue)
		end
		launch = true
	end,
})
MainTab:AddToggle({
	Name = "Loop Carts off",
	Callback = function(Value)
		getgenv().CartOn = Value
		Turncartsoff()
	end,
})

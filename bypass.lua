local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Storage = game:GetService("ReplicatedStorage")
local Remotes = Storage.Remotes
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Client = Player.PlayerScripts:WaitForChild("Client")
local CoreGui = game:GetService("CoreGui")
local PlaceId = game.PlaceId
local JobId = game.JobId

getgenv().GroupID = 7548958

for _, v in pairs(getgc()) do 
	if type(v) == "function" then 
		if getfenv(v).script == Client then
			pcall(function()
				if getupvalue(v, 1) == Player then
					setupvalue(v, 1, nil)
				end 
			end)
		end
	end 
end

local Old; Old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    if Method == "FireServer" and tostring(self) == "2Event" then
        return task.wait(math.huge)
    end
    return Old(self, ...)
end))

RunService.RenderStepped:Connect(function()
    pcall(function()
        Player.Character.Anticheat.Disabled = true
    end)
end)

for _, Variant in pairs(Players:GetPlayers()) do
    if Variant:IsInGroup(getgenv().GroupID) and Variant:GetRankInGroup(255, 240, 5, 1) then
        local ServerTables = {}
        for _, Variant2 in pairs(HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
            if type(Variant2) == "table" and Variant2.maxPlayers > Variant2.playing and Variant2.id ~= JobId then
        	    ServerTables[#ServerTables + 1] = Variant2.id
            end
        end
        if #ServerTables > 0 then
            TeleportService:TeleportToPlaceInstance(PlaceId, ServerTables[math.random(1, #ServerTables)])
        else
            Player:Kick("No Servers.")
        end
    end
end

Players.PlayerAdded:Connect(function(Plr)
    pcall(function()
        if Plr:IsInGroup(getgenv().GroupID) and Plr:GetRankInGroup(255, 240, 5, 1) then
            local ServerTables = {}
            for _, Variant2 in pairs(HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
                if type(Variant2) == "table" and Variant2.maxPlayers > Variant2.playing and Variant2.id ~= JobId then
            	    ServerTables[#ServerTables + 1] = Variant2.id
                end
            end
            if #ServerTables > 0 then
                TeleportService:TeleportToPlaceInstance(PlaceId, ServerTables[math.random(1, #ServerTables)])
            else
                Player:Kick("No Servers.")
            end
        end
    end)
end)

getgenv().Rejoin = CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(Child)
    pcall(function()
        if Child.Name == "ErrorPrompt" and Child:FindFirstChild("MessageArea") and Child.MessageArea:FindFirstChild("ErrorFrame") then
            TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Player)
        end
    end)
end)
